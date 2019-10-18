# Android Killer shell

shell script to decode and build apk

## extract apk

```sh Android_Killer.sh -e com.test test```

## decode apk

```sh Android_Killer.sh -d test.apk```

``` shell
projects
   └── test
       ├── bin
       │   └── test.apk  <-- origin apk
       ├── project
       │   ├── AndroidManifest.xml
       │   ├── apktool.yml
       │   ├── assets
       │   ├── lib
       │   ├── original
       │   ├── res
       │   ├── smali
       │   └── unknown
       └── projectSrc
           ├── classes-dex2jar.jar
           └── smali

```

## build apk

```sh Android_Killer.sh -b test```

``` shell
projects
   └──test
       ├── bin
       │   ├── test.apk  <- origin apk
       │   ├── test_killer.apk  <- unsinged apk
       │   └── test_killer_signed.apk  <- signed apk
```
