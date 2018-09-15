---
layout: post
title: Enable core dumps (for every user) in Raspbian|Debian 
tags: [core dumps, raspbian, debian]
---

Create file:
```
/etc/sysctl.d/core.conf:
```

With this content:
```
kernel.core_pattern = /var/lib/coredumps/core-%e-sig%s-user%u-group%g-pid%p-time%t
kernel.core_uses_pid = 1
fs.suid_dumpable = 2
```

Create such a folder, and set permissions:
```
mkdir /var/lib/coredumps/
chmod 777 /var/lib/coredumps/
```

Edit file:
```
/etc/security/limits.conf
```

Add this content:
```
*  soft  core  unlimited
```

Logoff and logon, then:
```
ulimit -c unlimited
```

Check if it worked:
```
$ ulimit -a
core file size          (blocks, -c) unlimited
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 7345
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 7345
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
```

Memento gdb core dump analysis:
```
gdb <executable> <core_dump_file>
``` 


Install gdb 8.1
```
apt install texinfo python2.7-dev python3-dev
wget http://ftp.gnu.org/gnu/gdb/gdb-8.1.1.tar.xz
tar xf gdb-8.1.1.tar.xz
cd gdb-8.1/
./configure --with-python && make && make install
```