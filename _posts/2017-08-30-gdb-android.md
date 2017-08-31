---
layout: post
title: Debug Android native code with gdb
tags: [ android, gdb]
---

Requisites:
* Root permissions needed
* Android sdk with ndk

In this example the packname of the app is: "_saonzo.it.testcpp_"

Push the gdbserver executable on the device:

`adb push ~/android-sdk-linux/ndk-bundle/prebuilt/android-arm/gdbserver/gdbserver /data/local/tmp`

Start the app but do not trigger the execution of the native code.

Become root, disable SELinux and attach gdb to the running process:

```
adb shell
su
setenforce 0
/data/local/tmp/gdbserver :1337 --attach $(ps | grep saonzo.it.testcpp | awk '{print $2}')
```

Download locally the shared libraries of your Android os, forward the right port and start gdb:

```
mkdir -p ~/dbgtmp/system_lib
adb pull /system/lib ~/dbgtmp/system_lib/
adb forward tcp:1337 tcp:1337
~/android-sdk-linux/ndk-bundle/prebuilt/linux-x86_64/bin/gdb
```

Specifies directories where GDB will search for shared libraries with symbols and connect to the gdbserver instance:

```
(gdb) set solib-search-path ~/dbgtmp/system_lib/
(gdb) target remote :1337
```

I set a break point on a function of mine:

```
(gdb) break Java_saonzo_it_testcpp_MainActivity_readTxtFile
(gdb) continue
```

Now trigger the execution of your native function and I wish you an happy debugging!
