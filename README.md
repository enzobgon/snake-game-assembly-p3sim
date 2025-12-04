# Snake Game - Assembly P3

This project is a low-level implementation of the classic **Snake Game**, developed as a final assignment for the **Computer Architecture** course.

It is written entirely in *Assembly P3*, a language designed for the educational 16-bit P3 processor. The goal of this project is to demonstrate a solid understanding of fundamental hardware concepts, including:
* Direct memory management.
* Hardware Interrupts (IVT - Interrupt Vector Table).
* Input/Output (Memory Mapped I/O).
* Stack manipulation and subroutine calls.
* ALU operations and flags.

## The Game
The game follows the classic rules:
1.  **Objective:** Eat the food (`*`) to grow the snake and increase your score.
2.  **Movement:** The snake moves constantly; you control the direction.
3.  **Lose Conditions:** The game ends if you hit the walls or bite your own tail.

## Features
* **Real-time movement** powered by hardware timer interrupts.
* **Pseudo-Random Number Generation (RNG)** using prime numbers and modular arithmetic to spawn food.
* **Score tracking** updated dynamically on the UI header.
* **Circular Buffer logic** to efficiently manage the snake's growing body in memory.
* **Collision Detection** (Walls, Self, and Food).

## How to Run

To build and run this project, you need the following files (included in the root directory):
* `p3as-linux`: The Assembler (converts `.as` code to `.exe`).
* `p3sim.jar`: The Simulator (runs the P3 processor virtually). 

1. Setup Permissions:
   
Before running the assembler for the first time, ensure it has execution permissions:
```bash
chmod +x p3as-linux
```
2. Quick Start:

You can assemble and run the simulator immediately using the following command:
```
./p3as-linux snake-game.as
java -jar p3sim.jar snake-game.exe
```
