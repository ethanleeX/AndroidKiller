#!/bin/sh
ANDROID_KILLER_ROOT=$(pwd)
D2J_PATH=${ANDROID_KILLER_ROOT}/dex-tools
#APKTOOL_PATH=

function initApkDir() {
    if [ ! -d projects ]; then
        mkdir projects
    fi
    cd projects
    if [[ -d $1 ]]; then
        rm -r $1
    fi
    mkdir $1
    cd $1
    mkdir bin
    mkdir project
    mkdir projectSrc
    cd ${ANDROID_KILLER_ROOT}
}

if [[ $1 == '-d' || $1 == 'd' ]]; then
    echo 'decode apk waiting...'
    file_name=$(basename $2 .apk)
    initApkDir ${file_name}
    project_home=${ANDROID_KILLER_ROOT}/projects/${file_name}
    cp $2 ${project_home}/bin
    cd ${project_home}/bin
    apktool d ${file_name}.apk
    cp -r ${file_name}/smali ${project_home}/projectSrc
    cp -r ${file_name}/* ${project_home}/project/
    tmp_file_name=${file_name}_tmp
    cp ${file_name}.apk ${tmp_file_name}.zip
    unzip -d ${tmp_file_name} ${tmp_file_name}.zip
    dex_files=$(find ${tmp_file_name} -name "*.dex")
    echo ${dex_files}
    # todo: multidex
    dex_name=$(basename ${dex_files} .dex)
    sh ${D2J_PATH}/d2j-dex2jar.sh -o ${project_home}/projectSrc/${dex_name}-dex2jar.jar $dex_files
    # clear tmp file
    rm -r ${file_name}
    rm -r ${tmp_file_name}
    rm ${tmp_file_name}.*
    echo 'decode apk finish excited!'
elif [[ $1 == '-b' || $1 == 'b' ]]; then
    echo 'build apk waiting...'
    echo 'build'$2
else
    echo 'need help'
fi
