---
layout: post
title: Debug Android native code with gdb
tags: [ android, gdb]
---

Requisites:
* Root permissions needed
* Android sdk with ndk
* [GDB Enhanced Features](https://github.com/hugsy/gef)

In this example the packname of the app is: `com.example.nativetest`

Find the right gdb executable for your architecture:
```
$ find ~/android-sdk-linux/ -type f -name "gdbserver"
~/android-sdk-linux/ndk-bundle/prebuilt/android-mips/gdbserver/gdbserver
~/android-sdk-linux/ndk-bundle/prebuilt/android-x86/gdbserver/gdbserver
~/android-sdk-linux/ndk-bundle/prebuilt/android-mips64/gdbserver/gdbserver
~/android-sdk-linux/ndk-bundle/prebuilt/android-arm64/gdbserver/gdbserver
~/android-sdk-linux/ndk-bundle/prebuilt/android-arm/gdbserver/gdbserver
~/android-sdk-linux/ndk-bundle/prebuilt/android-x86_64/gdbserver/gdbserver
```

Copy the gdb server executable (w.r.t. your target architecture) in a temporary folder and give to it full permissions:


```
adb push ~/android-sdk-linux/ndk-bundle/prebuilt/android-arm/gdbserver/gdbserver /data/local/tmp`
adb shell "chmod 777 /data/local/tmp/gdbserver"
adb shell "ls -l /data/local/tmp/gdbserver"
```

In order to be able to find debug information/symbols you'll need all libraries in  your device/emulator to be copied to your PC. Gdb will need them later on.
```
mkdir -p ~/dbgtmp/
adb pull /system/lib ~/dbgtmp/
ls -l ~/dbgtmp/lib/
```

Copy also the native library `<NATIVELIBDBG>` from your target apk `<TARGETAPK>` that you want to debug!
```
mkdir tmp
unzip <TARGETAPK> -d tmp
cp tmp/lib/<ARCH>/<NATIVELIBDBG> ~/dbgtmp/lib
```

Start the app but do not trigger the execution of the native code.
Before continuing forward the port:
```
adb forward tcp:1337 tcp:1337
```

Become root, disable SELinux and attach gdb to the running process (here I'm using `com.example.nativetest`):

```
adb shell
su
setenforce 0
/data/local/tmp/gdbserver :1337 --attach $(ps | grep com.example.nativetest | awk '{print $2}')
```

Start gdb and be careful: use the Android-SDK executable!

```
~/android-sdk-linux/ndk-bundle/prebuilt/linux-x86_64/bin/gdb
```

Connect to the gdbserver instance, specify the directories where GDB must search for shared libraries' symbols and take advantage tabbing the function name that you want to inspect:

```
gef> gef-remote :1337
gef> set solib-search-path ~/dbgtmp/lib
gef> info sharedlibrary
gef> break Java<TAB>
```

I set a break point on a function of mine:

```
(gdb) break Java_com_example_nativetest_MainActivity_readTxtFile
(gdb) continue
```

Now trigger the execution of your native function and I wish you an happy debugging!
