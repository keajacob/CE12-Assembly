****************************
Author: Kyle O'Rourke
Email: Ktorourk@ucsc.edu
ID #: 1596630
Lab 2
Section 2
****************************

Description & Purpose:
----------------------
In this lab, I learned how to create a full adder and subtractor using logic gates,
the 2's complement, flip-flops, and more. I gained a greater understanding of how 
flip flops work and how addresses are used. 


Methods:
--------
To create the adder and subtractor I first had to create an input and output page.
Without knowing what I was going to put in and what I wanted to get out, it would
have been challenging even to start working on the circuit. I then built the 6-bit 
register using the flip-flop example from the starter parts file provided. Then I
built the adder, tested it, then started to work on the subtractor. While building
the subtractor, I had to do many reworks to the register and adder circuits.


Challenges:
-----------
It was very challenging to wrap my head around the idea of creating the calculator without
two 6-bit registers so that it could hold two numbers at the same time before adding
or subtracting them from each other. The main reason why I was having this issue
was partly that I had the idea that the keypad input should go into the register
first before the adder/subtractor circuit. (Input -> Save -> Operation) Rather than
(Input -> Operation -> Save). After I got over that hurdle everything else was very straight 
forward. I included a few LEDs and 7-Seg displays to make debugging the 2's complement 
subtraction circuit easier.

Questions:
----------
What happens when you subtract a larger number from a smaller number?:
The answer becomes a negative 2's complement number.

What happens when you add two numbers that won’t fit in 6 bits?:
The output loops back around in the maximum range possible. (Similar to the value wheel 
discussed in class).