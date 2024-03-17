#  Raccoon Idle

This is my attempt at a Idle game using SwiftUI stuff (sort of), spritekit, and
coredata. It's a work in progress, and some parts are just badly thought out. 

## How Does it work?

Badly, I built this in a crunch month. I made many bad choices that I just had to live with, but there's enough there I think it's worth sharing.

there's probably too much component crosstalk, but most of it could be sorted out relatively quickly.

known issues (less than there are)
- __some magical OBOE in the texture atlas loading. either in the chunked extension, or a race condition? (fixed) 1 != 0


Things I'd like to ad
individual timer start offsets for relaunching
