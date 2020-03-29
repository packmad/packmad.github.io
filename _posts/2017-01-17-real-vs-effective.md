---
title: Real (U|G)ID vs Effective (U|G)ID
tags: [uid, gid, real, effective]
---
### Background

In *nix systems the **User Id Number** (<span style="color: #0000ff;">UID</span>) and the **Group Id Number** (<span style="color: #0000ff;">GID</span>) are integers used for identifying uniquely users and groups. Take a look at [_/etc/passwd_](https://www.cyberciti.biz/faq/understanding-etcpasswd-file-format/) and [_/etc/group_](https://www.cyberciti.biz/faq/understanding-etcgroup-file/) files (follow the links for more details about these files):


```
simo@xps:~$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
[...]
simo:x:1000:1000:simo,,,:/home/simo:/bin/bas\h
debian-tor:x:121:133::/var/lib/tor:/bin/false
```

We can infer:

| **User**    | **UID**  	| **GID (primary)** 	|
|------------	|----------	|-------------------	|
| simo       	| 1000 	| 1000 	|
| debian-tor 	| 121  	| 133  	|

Their counterparts in the group file:

```
simo@xps:~$ cat /etc/group
root:x:0:
[...]
simo:x:1000:
vboxusers:x:130:simo
debian-tor:x:133:
```

Moreover you can see that the user _"simo"_ belong also to the _"vboxusers"_ group.

### Real (U|G)ID vs Effective (U|G)ID

Every running process has at least 4 ID numbers associated with it:

*   the <span style="color: #000000;">**Real UID** (<span style="color: #0000ff;">RUID</span>) identifies the user who launched the process.</span>
*   <span style="color: #000000;">the **Real GID** (<span style="color: #0000ff;">RGID</span>) identifies the primary group of the user that launched the process.</span>
*   <span style="color: #000000;">the **Effective UID** (<span style="color: #0000ff;">EUID</span>) and the **Effective GID** (<span style="color: #0000ff;">EGID</span>) are used to determine what resources the process can access.</span>

These information can be found programmatically:

```
simo@xps:~/example$ cat ids.c
#include
#include
int main()
{
 uid_t real_uid = getuid();
 uid_t effect_uid = geteuid();
 gid_t real_gid = getgid();
 gid_t effect_gid = getegid();
 printf("ruid=%d euid=%d\n", real_uid, effect_uid);
 printf("rgid=%d egid=%d\n", real_gid, effect_gid);
}
```

Usually the various ID have the same value when you run a program, but sometimes happens that a computer system needs to run programs with temporarily elevated privileges in order to perform a specific task.

The **setuid** (set user id) is a permission bit, that **allows the users to exec a program with the permissions of its owner.** The **setgid** (set group id) is a bit that **allows the user to exec a program with the permissions of the group owner.**

The s(u|g)id bit on executables only changes the E(U|G)ID the executable will run as, and not the real(U|G)ID. 
Let's take a closer look:

```
$ gcc -Wall ids.c -o example
$ sudo chown root.root example
$ ls -l
total 16
-rw-rw-r-- 1 simo simo 294  gen 17 16:21 ids.c
-rwxrwxr-x 1 root root 8816 gen 17 16:28 example
$ ./example
ruid=1000 euid=1000
rgid=1000 egid=1000
$ sudo chmod 6771 example
$ ls -l
total 16
-rw-rw-r-- 1 simo simo 294 gen 17 16:21 ids.c
-rwsrws--x 1 root root 8816 gen 17 16:29 example
$ ./example
ruid=1000 euid=0
rgid=1000 egid=0
```

1.  I compiled the example;
2.  I changed the owner and the group from "simo" to "root";
3.  I ran the program and I got the same ids;
4.  I set the setuid and the setgid, pay attention to the `s` here 
```
-rwsrws--x 1 root root 8816 gen 17 16:29 example
```
5.  Ids changes accordingly!

**Hint**: in addition to the restriction on `s(u|g)id` interpreted scripts (any executable text file beginning with "#!"), some shells (like bash) as an extra safety measure will set the EUID back to the RUID; in this case, you will need to wrap the call to the script within a C program and setuid(...) before executing the script.
