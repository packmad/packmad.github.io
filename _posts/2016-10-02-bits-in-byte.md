---
layout: post
title: How many bits are there in a Byte?
tags: [bit, byte]
---

8\. Yes, sometimes... whereas the bit is [well defined](https://en.wikipedia.org/wiki/Bit):

*   A bit is the basic unit of information in computing and digital communications.
*   A bit can have only one of two values, and may therefore be physically implemented with a two-state device.
*   The values of a bit are most commonly represented as either a 0 or 1.

Instead the size of one Byte, as described [in the Jargon file](http://catb.org/~esr/jargon/html/B/byte.html), is architecture-dependent and, more precisely, is a unit of memory or data equal to the amount used to represent one character. In the same link, or in [the wiki page](https://en.wikipedia.org/wiki/Byte), is also explained that there were architecture with 6, 7, or 9 bits... or they operated on bit fields [from 1 to 36](https://en.wikipedia.org/wiki/PDP-10)!

Obviously is extremely convenient that, from the architecture/hardware prospective, a Byte is the smallest addressable unit of memory: for this reason every operation that involves data exchange between the CPU and the RAM is made with Byte sizes or its multiples (Word, Double Word and Quad Word).

We agree that the popularity of major commercial computing architectures has aided in the ubiquitous acceptance that _a Byte is 8-bit size_, but we must remember that it is only a standard (de facto). You can see it by yourself.

Compile this C code with gcc on your Linux machine:

```
#include<stdio.h>
#include<limits.h>

int main() {
    printf("%zu Byte = %d bits\n", sizeof(char), __CHAR_BIT__);
    printf("%lu Byte = %lu bits\n", sizeof(int), sizeof(int)*__CHAR_BIT__);
    return 0;
}
```

And run it:
```
$ gcc test.c
$ ./a.out
1 Byte = 8 bits
4 Byte = 32 bits

```

More in depth we can see that this program:

```
int main() {
    int n = 42;
    char buffer[64];
    return 0;
}
```

It becomes (compiled with gcc on a 32 bit machine without optimizations flags):

```
Dump of assembler code for function main:
0x08048394 <main+0>: push ebp
0x08048395 <main+1>: mov ebp,esp
0x08048397 <main+3>: sub esp,0x50
0x0804839a <main+6>: mov DWORD PTR [ebp-0x4],0x2a  ; 0x2a=42
0x080483a1 <main+13>: mov eax,0x0
0x080483a6 <main+18>: leave
0x080483a7 <main+19>: ret
End of assembler dump.
```

It needs 4 Byte = 32 bit (Double Word) for the int and 64 Byte = 512 bit for the buffer, so the instruction `sub esp,0x50` means that the ESP is moved `0x50=80` addresses downwards. `0x10=16` addresses and `0x40=64` respectively.

But if  the smallest addressable unit of memory (in this arch) is 8 bit this implies that for 32 bit we need also 4 addresses. So, why 16 addresses for an int? [Alignment](https://en.wikipedia.org/wiki/Data_structure_alignment#x86).
