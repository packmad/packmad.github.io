---
title: "Debug Android native code with gdb"
date: 2017-08-31 T15:34:30-04:00
tags:
  - android
  - gdb
---

Requisites:
* Root permissions needed
* Android sdk with ndk
* [GDB Enhanced Features](https://github.com/hugsy/gef)

In this example the packname of the app is: `com.example.nativetest`

Find the right gdb executable for your architecture:
```
$ find ~/Android/Sdk/ -type f -name "gdbserver"
~/Android/Sdk/ndk-bundle/prebuilt/android-mips/gdbserver/gdbserver
~/Android/Sdk/ndk-bundle/prebuilt/android-x86/gdbserver/gdbserver
~/Android/Sdk/ndk-bundle/prebuilt/android-mips64/gdbserver/gdbserver
~/Android/Sdk/ndk-bundle/prebuilt/android-arm64/gdbserver/gdbserver
~/Android/Sdk/ndk-bundle/prebuilt/android-arm/gdbserver/gdbserver
~/Android/Sdk/ndk-bundle/prebuilt/android-x86_64/gdbserver/gdbserver
```

Copy the gdb server executable (w.r.t. your target architecture, in this example I am using the *arm* version) in a temporary folder and give to it full permissions:


```
adb push ~/Android/Sdk/ndk-bundle/prebuilt/android-arm/gdbserver/gdbserver /data/local/tmp/
adb shell "chmod 777 /data/local/tmp/gdbserver"
adb shell "ls -l /data/local/tmp/gdbserver"
```

In order to find debug information/symbols you'll need all libraries in  your device/emulator to be copied to your PC. 
Gdb will need them later on.
```
mkdir -p ~/dbgtmp/
adb pull /system/lib ~/dbgtmp/
ls -l ~/dbgtmp/lib/
```

You must also copy the native library `<NATIVELIBDBG>` (contained in your target apk `<TARGETAPK>`) you want to debug!
```
mkdir tmp
unzip <TARGETAPK> -d tmp
cp tmp/lib/<ARCH>/<NATIVELIBDBG> ~/dbgtmp/lib
```

Before continuing forward the port that will be used for the communication between gdb and gdbserver:
```
adb forward tcp:1337 tcp:1337
```

Launch the app, but do not trigger the execution of the native code.
Become root, disable SELinux and attach gdb to the running process of your app with packagename `<PACKAGENAME>`):

```
adb shell
# su
# setenforce 0
# /data/local/tmp/gdbserver :1337 --attach $(ps | grep <PACKAGENAME> | awk '{print $2}')
```

Start gdb and be careful: use the Android-SDK executable!
```
~/Android/Sdk/ndk-bundle/prebuilt/linux-x86_64/bin/gdb
```

Connect to the gdbserver instance, specify the directories where gdb must search for the symbols of shared libraries.
Then check if the operation has been successfully completed.
Lastly, you can tabbing the function name that you want to debug (usually you are looking for some `Java_*` entrypoint), and then you can set a break point on such function:
```
gef> gef-remote :1337
gef> set solib-search-path ~/dbgtmp/lib
gef> info sharedlibrary
gef> break Java_<TAB>
gef> continue
```

Now you can interact with your app and trigger the execution of the native function.
I wish you happy debugging!
