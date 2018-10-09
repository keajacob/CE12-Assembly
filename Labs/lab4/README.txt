****************************
Author: Kyle O'Rourke
Email: Ktorourk@ucsc.edu
ID #: 1596630
Lab 4
Section 2
****************************

Description:
----------------------
In this lab, I learned how to create a prime number finder using nested loops and a 'brute force'
approach. The task was to take an integer input and output all the prime numbers less than or equal
to the input number. I was able to successfully get every prime number up to input 10,000 after
that, the processing time became very slow.


Methods:
--------
To get the user input I used syscall 5. I then ran it through a parsing script that would check
if the number was greater than or equal to 2. If it was less than 2 it would output a cheeky message
and restart the program. I used two loops to cycle through every number up to the given number while
the second loop checked if the number was divisable by any number less than half the current number.


Challenges:
-----------
This lab was less challenging than the previous lab, but I was able to make it harder by using the
stack. (I had never used the stack before so this made the lab more educational.)