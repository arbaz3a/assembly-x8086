````markdown
# emmi DIGITAL STOP WATCH

A digital stopwatch built using Assembly language in emu8086.  
It demonstrates time counting, keyboard input handling, and screen display at the low-level 8086 architecture.

## Overview
This project simulates a working stopwatch that displays time in the format HH:MM:SS.  
The user can start, pause, resume, restart, or exit the stopwatch through keyboard commands.  
It is a simple yet complete example of using interrupts, loops, and basic real-time simulation in Assembly.

## Features
Start the stopwatch  
Pause and resume without losing the current time  
Restart to reset the timer back to 00:00:00  
Exit safely anytime  
Text-based interface using BIOS interrupts  

## Setup Guide

### Requirements
- emu8086 emulator  
- Windows Operating System  
- Basic understanding of 8086 Assembly  

### How to Run
1. Clone this repository  
   ```bash
   git clone https://github.com/arbaz3a/assembly-x8086.git
   cd assembly-x8086
````

2. Open the file `stop_watch_assembly.asm` in emu8086
3. Assemble and run the program
4. Use the following keys during execution:

   ```
   1  →  Open the stopwatch  
   S/s  →  Start  
   P/p  →  Pause  
   R/r  →  Resume  
   X/x  →  Restart  
   E/e  →  Exit  
   ```

## Notes

The stopwatch works through **software delay loops** instead of hardware timers.
Display and input operations are handled through:

* **INT 10h** for video/screen control
* **INT 21h** for keyboard input

### Adjusting Stopwatch Speed (Important)

If the stopwatch runs **too fast or too slow**, you can change the delay loop value to match one real second.
Locate this part of the code inside the `update_time:` label in your `.asm` file:

```asm
; delay control
mov cx, 20
delay:
    loop delay
```

* The value `20` controls how long one cycle lasts.
* To **slow down** the stopwatch (make each second longer), increase this value, e.g.:

  ```asm
  mov cx, 2000
  ```
* To **speed it up**, reduce the number.
* This helps balance timing differences based on your PC’s performance and emu8086 speed.

### Where This Section Starts and Ends in Code

The delay section begins after updating and displaying the time each loop and ends before checking for keyboard input.

Look for these lines in your code:

```asm
;display time
lea dx, time_format
mov ah, 09h
int 21h

;delay control starts here
mov cx, 20
delay:
    loop delay
;delay control ends here
```

That is the part where you adjust the value of CX.

## Purpose

This project was created for learning and demonstrating core Assembly concepts, including:

* Loops and counters
* Use of interrupts for I/O
* Real-time logic using software delays
* Modular structure using procedures

## Folder Structure

```
assembly-x8086/
│
├── stop_watch_assembly.asm       ← Main source code
└── README.md                     ← Documentation file
