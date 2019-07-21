#!/bin/sh
ANDROID_KILLER_ROOT=$(pwd)
D2J_PATH=${ANDROID_KILLER_ROOT}/dex-tools
APKTOOL_PATH=${ANDROID_KILLER_ROOT}/apktool.jar

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

# init dirs decode apk and move file
function decodeApk() {
    echo 'decode apk waiting...'
    file_name=$(basename $1 .apk)
    initApkDir ${file_name}
    project_home=${ANDROID_KILLER_ROOT}/projects/${file_name}
    cp $1 ${project_home}/bin
    cd ${project_home}/bin
    java -jar ${APKTOOL_PATH} d ${file_name}.apk
    cp -r ${file_name}/smali ${project_home}/projectSrc
    cp -r ${file_name}/* ${project_home}/project/
    tmp_file_name=${file_name}_tmp
    cp ${file_name}.apk ${tmp_file_name}.zip
    unzip -d ${tmp_file_name} ${tmp_file_name}.zip
    dex_files=$(find ${tmp_file_name} -name "*.dex")
    echo ${dex_files}
    for dex_file in ${dex_files}; do
        dex_name=$(basename ${dex_file} .dex)
        sh ${D2J_PATH}/d2j-dex2jar.sh -o ${project_home}/projectSrc/${dex_name}-dex2jar.jar ${dex_file}
    done
    # clear tmp file
    rm -r ${file_name}
    rm -r ${tmp_file_name}
    rm ${tmp_file_name}.*
    echo 'decode apk finish excited!'
}

# bulid apk
function buildApk() {
    project_home=${ANDROID_KILLER_ROOT}/projects/$1
    cd ${ANDROID_KILLER_ROOT}/projects
    if [ -d $1 ]; then
        echo 'build apk waiting...'
        java -jar ${APKTOOL_PATH} b ${project_home}/project -o ${project_home}/bin/$1_killer.apk
        echo 'build success wait for sign'
    else
        echo 'no such project' $1
    fi
}

# sign
function sign() {
    echo 'signing waiting...'
    project_home=${ANDROID_KILLER_ROOT}/projects/$1
    cd ${ANDROID_KILLER_ROOT}/projects/$1/bin
    jarsigner -verbose -keystore ${ANDROID_KILLER_ROOT}/key.keystore -storepass android_killer -signedjar $1_killer_signed.apk -digestalg SHA1 -sigalg MD5withRSA $1_killer.apk key.keystore
    echo 'sign success'
}

if [[ $1 == '-d' || $1 == 'd' ]]; then
    decodeApk $2
elif [[ $1 == '-b' || $1 == 'b' ]]; then
    buildApk $2
    sign $2
elif [[ $1 == 'e' || $1 == '-e' ]]; then
    echo 'extract' $2
    apk_path=$(adb shell pm path $2)
    # remove package: at start
    apk_path=${apk_path:8}
    echo $apk_path
    adb pull ${apk_path} .
    if [[ $3 != '' ]]; then
        apk_name=$(basename ${apk_path})
        mv $apk_name $3.apk
    fi
else
    echo 'no such command'
fi
