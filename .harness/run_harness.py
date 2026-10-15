#!/usr/bin/env python3
"""Assemble the stub + dist bundle + example into one Luau file and run it.

The Luau CLI has no `io`/`load`/`dofile`, so the three pieces are embedded as
strings and evaluated with setfenv, mirroring how an executor runs a script.
"""
import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
STUB = ROOT / ".harness" / "roblox_stub.luau"
BUNDLE = ROOT / "dist" / "main.lua"
LUAU = pathlib.Path("/tmp/luau")


def long_string(text: str, name: str) -> str:
    """Wrap text in a Lua long string, choosing a delimiter that cannot appear."""
    level = 0
    while f"]{'=' * level}]" in text:
        level += 1
    eq = "=" * level
    return f"[{eq}[\n{text}\n]{eq}]"


def module_id(path: pathlib.Path) -> str:
    """Map src/components/window/Init.lua to src/components/window/Init."""
    return path.relative_to(ROOT).with_suffix("").as_posix()


def collect_modules() -> dict:
    """Every requireable .lua file, keyed by repo-relative path without suffix."""
    roots = [ROOT / "src", ROOT / "build"]
    return {
        module_id(p): p.read_text()
        for root in roots
        if root.is_dir()
        for p in sorted(root.rglob("*.lua"))
    }


def source_mode_prelude(example_src: str) -> str:
    """Provide a relative-path `require` over the real src/ tree.

    The library calls require("./modules/Creator") style paths, so each module
    runs in its own environment whose `require` resolves against that module's
    directory.
    """
    modules = collect_modules()
    entries = ",\n".join(
        f"\t[{json.dumps(mid)}] = {long_string(src, mid)}"
        for mid, src in modules.items()
    )
    example_name = "src/__example"
    modules_lua = entries + ",\n\t[%s] = %s" % (
        json.dumps(example_name),
        long_string(example_src, "example"),
    )

    return f"""local __MODULES = {{
{modules_lua}
}}

local __MODULE_CACHE = {{}}
local __MODULE_ENVS = {{}}

local function __normalize(path)
        local parts = {{}}
        for segment in string.gmatch(path, "[^/]+") do
                if segment == ".." then
                        if #parts > 0 then table.remove(parts) end
                elseif segment ~= "." then
                        table.insert(parts, segment)
                end
        end
        return table.concat(parts, "/")
end

local function __dirname(path)
        return string.match(path, "^(.*)/[^/]*$") or ""
end

local function __makeRequire(fromDir)
        return function(request)
                if type(request) ~= "string" then
                        error("require expects a string module path", 2)
                end

                local path = request
                if string.sub(path, 1, 1) == "." then
                        path = __normalize(fromDir .. "/" .. path)
                else
                        path = __normalize(path)
                end

                if __MODULE_CACHE[path] ~= nil then
                        return __MODULE_CACHE[path]
                end

                local source = __MODULES[path]
                if not source then
                        error("module not found: " .. tostring(request) .. " (resolved to " .. path .. ")", 2)
                end

                local chunk = assert(loadstring(source, path))
                local modEnv = setmetatable({{ require = __makeRequire(__dirname(path)) }}, {{ __index = env }})
                __MODULE_ENVS[path] = modEnv
                setfenv(chunk, modEnv)

                local result = chunk()
                if result == nil then
                        result = true
                end
                __MODULE_CACHE[path] = result
                return result
        end
end

env.require = __makeRequire("")
"""


def stub_source() -> str:
    """The stub with its trailing `return` removed so `env` stays in scope."""
    stub_src = STUB.read_text().rstrip()
    marker = "return setmetatable(env, { __index = _G })"
    assert stub_src.endswith(marker), "unexpected stub ending"
    return stub_src[: -len(marker)] + "setmetatable(env, { __index = _G })"


def build_source_mode(example_src: str, example_name: str) -> str:
    return f"""{stub_source()}

{source_mode_prelude(example_src)}

env.game.HttpGet = function(_, url) return "" end
env.game.GetObjects = function() return {{}} end
env.isfile = function(path) return tostring(path):find("%.key$") ~= nil end
env.readfile = function(path) return "1234" end

local __realLoadString = loadstring
local function __sandboxed(chunk, name)
        local fn = __realLoadString(chunk, name)
        if fn then setfenv(fn, env) end
        return fn
end
env.loadstring = __sandboxed
env.load = __sandboxed

local __runExample = assert(__realLoadString(__MODULES[{json.dumps("src/__example")}], {long_string(example_name, "name")}))
setfenv(__runExample, env)
-- Run on a scheduled thread so top-level task.wait yields instead of erroring.
env.__spawn(__runExample)
print("EXAMPLE RAN OK: {example_name}")
"""


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: run_harness.py <example.lua> [--source]")
        return 2

    args = [a for a in sys.argv[1:] if a != "--source"]
    source_mode = "--source" in sys.argv

    example = pathlib.Path(args[0])
    if not example.is_absolute():
        example = ROOT / example

    if source_mode:
        combined = build_source_mode(example.read_text(), example.name)
    else:
        combined = build_bundle_mode(example, example.read_text())

    out = ROOT / ".harness" / "combined.luau"
    out.write_text(combined)

    result = subprocess.run([str(LUAU), str(out)], capture_output=True, text=True)
    output = ((result.stdout or "") + (result.stderr or "")).strip()
    print(output[-5000:] if output else "(no output)")
    return result.returncode


def build_bundle_mode(example: pathlib.Path, example_src: str) -> str:
    stub_src = STUB.read_text()
    # The stub's final line returns the environment; keep the metatable that
    # exposes the standard library, but drop the `return`.
    stub_src = stub_src.rstrip()
    marker = "return setmetatable(env, { __index = _G })"
    assert stub_src.endswith(marker), "unexpected stub ending"
    stub_src = stub_src[: -len(marker)] + "setmetatable(env, { __index = _G })"

    bundle_src = BUNDLE.read_text()

    return f"""{stub_src}

local __BUNDLE = {long_string(bundle_src, "bundle")}
local __EXAMPLE = {long_string(example_src, "example")}

-- Serve the built bundle from game:HttpGet, exactly like a real script would.
env.game.HttpGet = function(_, url) return __BUNDLE end
env.game.GetObjects = function() return {{}} end

-- Simulate a previously saved key so the example skips the key prompt, which
-- would otherwise block on user input.
env.isfile = function(path) return tostring(path):find("%.key$") ~= nil end
env.readfile = function(path) return "1234" end

-- Executor-style loadstring that inherits the stubbed globals.
local __realLoadString = loadstring
local function __sandboxed(chunk, name)
        local fn = __realLoadString(chunk, name)
        if fn then setfenv(fn, env) end
        return fn
end
env.loadstring = __sandboxed
env.load = __sandboxed

local __runExample = assert(__realLoadString(__EXAMPLE, {long_string(example.name, "name")}))
setfenv(__runExample, env)

-- Run on a scheduled thread so top-level task.wait yields instead of erroring.
env.__spawn(__runExample)

print("EXAMPLE RAN OK: {example.name}")
"""


if __name__ == "__main__":
    sys.exit(main())
