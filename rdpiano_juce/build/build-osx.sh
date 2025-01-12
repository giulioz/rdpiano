ROOT=$(cd "$(dirname "$0")/.."; pwd)

# Resave jucer files
"$ROOT/build/bin/JUCE/Projucer.app/Contents/MacOS/Projucer" --resave "$ROOT/rdpiano_juce.jucer"

cd "$ROOT/Builds/MacOSX"
xcodebuild -configuration Release || exit 1
