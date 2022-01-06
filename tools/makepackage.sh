#!/bin/bash
set -e

readonly BUILD_DIR="$PWD/build";

function changeDir()
{
    local target="$1"
    echo "更改当前目录到$target..."

    cd "$target"
}

function makepack()
{
    local directory="$1"
    local directoryName="${directory##*/}"
    local finalName="${directoryName//pack_/}"

    local option_gen="pack_directory = '$directory'
output_file_path = 'build/${directoryName//pack_/}.zip'
$(cat "$directory/config.toml")"

    echo "$option_gen" | tools/packsquash || echo "$option_gen"
    sha1sum "build/$finalName.zip" | cut -d ' ' -f1 > "build/$finalName"-sha1
}

for d in pack_* ;do
    makepack "$PWD/$d"
done;

echo "创建目录..."
if [ ! -d "$BUILD_DIR" ];then
    mkdir -vp "$BUILD_DIR"
fi

echo "创建压缩文档..."
#makepack "$PWD/pack_main" "xmzs-resources"
#makepack "$PWD/pack_empty" "empty"

echo "完成!"