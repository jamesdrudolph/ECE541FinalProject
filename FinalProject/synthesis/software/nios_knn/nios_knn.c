/*
 * nios_knn.c
 *
 *  Created on: Apr 30, 2021
 *      Author: nothi
 */
#include <stdio.h>
#include <stdlib.h>

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

int* getAttributesFromUser() {
    static char strs[][16] = { "Sepal length", "Sepal width", "Petal length", "Petal width" };
    static int attributes[4];

    printf("An Iris flower can be described using 4 attributes: sepal length and width, and petal length and width.\nPlease enter the 4 attributes in millimeters between 0 and 255.\n\n");

    for (int i = 0; i < 4; i++) {
        printf("%s: ", strs[i]);

        char buf[4];
        fgets(buf, 4, stdin);
        printf("You entered: %s\n", buf);
        attributes[i] = atoi(buf);
    }

    return attributes;
}

int main()
{
	int *a = getAttributesFromUser();

	for (int i = 0; i < 4; i++) {
		*(nios_output + i) = (char)*(a + i);
	}

	for (int i = 0; i < 4; i++) {
		printf("%u: %c\n", nios_output + i, *(nios_output + i));
	}

	return 0;
}
