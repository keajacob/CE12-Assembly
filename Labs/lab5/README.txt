****************************
Author: Kyle O'Rourke
Email: Ktorourk@ucsc.edu
ID #: 1596630
Lab 5
Section 2
****************************

Description:
----------------------
In this lab, I learned how to create a Vigenère cipher in assembly. I had to create two functions an pass
three variables to each of them. The functions were Encoding a given string, and Decoding the encoded
string. The function arguments that I had to pass were: address of cipher key, an address of clear text, 
and the address of ciphertext. The text input that I was given was expected to be two strings no greater
than 100 chars long.


Methods:
--------
To encode the string, I would add the decimal ASCII value of the current key location to the current
string location. I had a subroutine that would also check if the encoding would push the value past
126 ASCII (max printable ASCII character). If it found that it would go past 126, I would have it divide
the value by 126 and use the HI address to get a modulo remainder of the value. Then I would iterate through 
a loop doing the same for each character in the string. After the string was encoded, I made sure to add a 
null terminator to the end so that the syscall for printing a string would print just the text and nothing else.

To decode the string, I would run through a very similar loop structure as the encoding function. The
main differences between the two functions are the algebraic steps to manipulate the characters into
the desired form. Unlike the encoding function that required addition and division, decoding only required
subtraction.

Both functions only needed the arguments that were listed above to work correctly. So in the future if
I have to create a function that uses this cipher I could just copy the functions into my code. (I would
need to save everything to the stack before implementing the functions, however.)

Challenges:
-----------
This lab was much more challenging than I thought it would be. I was surprised at how long it took to
create flowcharts for the encryption and decryption arithmetic. The hardest part of the lab was learning
how to manipulate the strings and save them to the desired array addresses.