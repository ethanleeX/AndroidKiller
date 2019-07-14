#!/bin/sh
function checkDir() {
    if [ ! -d $1 ]; then
        mkdir projects
    fi
}

if [ $1 = 'd' ]; then
    echo 'decode apk waiting...'
    apktool d $2
    flie_name=$(basename $2 .apk)
    checkDir ./projects
    mv ${flie_name} ./projects
    tmp_file_name=${flie_name}_tmp
    cp $2 ${tmp_file_name}.zip
    unzip -d ${tmp_file_name} ${tmp_file_name}.zip
    dex_files=$(find ${tmp_file_name} -name "*.dex")
    echo ${dex_files}
    # todo: multidex
    current_dir=$(pwd)
    dex_name=$(basename ${dex_files} .dex)
    # sh ./dex-tools/d2j-dex2jar.sh -o ../ $dex_files
    sh ./dex-tools/d2j-dex2jar.sh -o ${current_dir}/${dex_name}-dex2jar.jar $dex_files
    echo 'decode apk finish excited!'
elif [ $1 = 'b' ]; then
    echo 'build apk waiting...'
    echo 'build'$2
else
    echo 'need help'
fi
