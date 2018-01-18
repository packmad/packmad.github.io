---
layout: post
title: Debug Android smali code (without repackaging)
tags: [android, debug, smali]
---

Download an [Android Studio](https://developer.android.com/studio/index.html) version greater than 3, because Google added a very useful feature: [Profile and Debug Pre-built APKs](https://developer.android.com/studio/debug/apk-debugger.html).

This new feature needs to attach the Java source code for setting breakpoints, but [smalidea](https://github.com/JesusFreke/smali/wiki/smalidea) allow us to do it directly on [smali code](https://github.com/JesusFreke/smali/wiki)!

[Download](https://bitbucket.org/JesusFreke/smali/downloads/) the latest version of smalidea, then install it from Android Studio (from now on AS):

* File -> Settings -> Plugins -> Install plugin from disk...

Restart AS and open your apk:

* File -> Profile or debug APK...

Now, on your emulator (I didn't test it on a real device, but surely you need root permissions) choose your target APK:

* Settings -> Developer options -> Select debug app
  * Flag "Wait for debugger"

Start your app!

Let's get back to AS. Browse the class/method that you want to debug using the left panel and set the breakpoints.

* Tools -> Android -> Android Device Monitor
  * If you see nothing in the  Android Device Monitor panel:
    * Window -> Rest perspective

In the **Devices** panel you will see a three column matrix:

1. package name
2. pid
3. port

Click your app and take care that in the last column is confirmed that the port on your emulator is mapped with the local 8700 port, as shown in the image.

![Android Device Monitor screenshot](https://packmad.github.io/images/postimgs/adm.png)

Last step:

* Run -> Edit configurations
  * Click on the green + button
  * Choose "Remote"
    * Port: 8700

Click the debug icon and... there you are!

If you want to explore the content of a register you need to add a new watch (shortcut: Ins) and type the name of the register.

Everything else works like a normal debug session.
