#!/bin/sh

tw() {
    echo "Building Tailwind CSS to $(pwd)/dist/index.css"
    ./node_modules/.bin/tailwindcss -i ./src/index.css -o ./dist/index.css --minify
}

html() {
    echo "Building HTML files to $(pwd)/dist"
    python src/build.py --output dist --no-clean
}

static() {
    echo "Copying files from $(pwd)/public to $(pwd)/dist"
    cp -r public/* dist/
}

opt_imgs() {
    ./src/optimize-images.sh
}

html_static() {
    html &
    hpid=$!

    static &
    spid=$!

    wait $hpid $spid
    opt_imgs &
}

tw &
html_static &

wait