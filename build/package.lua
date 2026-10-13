-- Generated from package.json | build/build.sh

return [[
{
    "name": "nevaui",
    "version": "1.6.66",
    "main": "./dist/main.lua",
    "repository": "https://github.com/SCOPE03/NEVAUI",
    "discord": "https://discord.gg/ycajkk7Mc7",
    "author": "NEVA",
    "description": "NevaUI Roblox UI Library",
    "license": "MIT",
    "scripts": {
        "dev": "bash build/build.sh dev $INPUT_FILE",
        "build": "bash build/build.sh build $INPUT_FILE",
        "live": "python3 -m http.server 8642",
        "watch": "chokidar . -i 'node_modules' -i 'dist' -i 'build' -c 'npm run dev --'",
        "live-build": "concurrently \"npm run live\" \"npm run watch --\"",
        "example-live-build": "INPUT_FILE=main_example.lua npm run live-build",
        "updater": "python3 updater/main.py"
    },
    "keywords": [
        "ui-library",
        "ui-design",
        "script",
        "script-hub",
        "exploiting"
    ],
    "devDependencies": {
        "chokidar-cli": "^3.0.0",
        "concurrently": "^9.2.0"
    }
}
]]
