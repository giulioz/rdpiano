ROOT=$(cd "$(dirname "$0")/.."; pwd)

# Resave jucer files
"$ROOT/build/bin/JUCE/Projucer" --resave "$ROOT/rdpiano_juce.jucer"

cd "$ROOT/Builds/LinuxMakefile"
make CONFIG=Release
