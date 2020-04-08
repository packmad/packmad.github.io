---
title: How many bits are there in a Byte?
tags: [bit, byte]
---

8\. Yes, sometimes... whereas the bit is [well defined](https://en.wikipedia.org/wiki/Bit):

*   a bit is the basic unit of information in computing and digital communications;
*   a bit can have only one of two values, and may, therefore, be physically implemented with a two-state device;
*   the values of a bit are most commonly represented as either a 0 or 1.

Instead, the size of one Byte, as described [in the Jargon file](http://catb.org/~esr/jargon/html/B/byte.html), is architecture-dependent and, more precisely, is a unit of memory or data equal to the amount used to represent one character. In the same link, or in [the wiki page](https://en.wikipedia.org/wiki/Byte), is also explained that there was architecture with 6, 7, or 9 bits... or they operated on bit fields [from 1 to 36](https://en.wikipedia.org/wiki/PDP-10)!

Obviously, it is extremely convenient that, from the architecture/hardware perspective, a Byte is the smallest addressable unit of memory: for this reason every operation that involves data exchange between the CPU and the RAM is made with Byte sizes or its multiples (Word, Double Word, and Quad Word).

We agree that the popularity of major commercial computing architectures has aided in the ubiquitous acceptance that _a Byte is 8-bit size_, but we must remember that it is only a de facto standard. You can see it by yourself.

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
