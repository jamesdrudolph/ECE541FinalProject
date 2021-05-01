/*
 * nios_knn.c
 *
 *  Created on: Apr 30, 2021
 *      Author: nothi
 */
#include <stdio.h>

//LEDS -> 10 bit output @ 0x21040
uint *leds = (uint*)0x21040;
//Switches -> 10 bit input @ 0x21030
uint *sw = (uint*)0x21030;
//Buttons -> 4 bit input @ 0x21020
uint *btns = (uint*)0x21020;
//General 32 bit input @ 0x21010
uint *nios_input = (uint*)0x21010;
//General 32 bit output @ 0x21000
uint *nios_output = (uint*)0x21000;

char* resolveToFlower(uint flower) {
	static char flowers[][16] = { "Iris-setosa", "Iris-versicolor", "Iris-virginica", "uh oh" };
	return flower > 2 ? flowers[3] : flowers[flower];
}

void printClassificationResult() {
	uint actual = 0xFF & *nios_input;
    uint classified = 0xFF & (*nios_input >> 8);

	if (actual == classified) {
		printf("Classification correct!\n");
	} else {
		printf("Classification wrong. :(\n");
	}

	printf("Actual: %s\nClassified as: %s\n\n", resolveToFlower(actual), resolveToFlower(classified));
}

int main()
{
  printClassificationResult();

  return 0;
}
