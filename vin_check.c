//
//  vin_check
//  Translated from http://en.wikipedia.org/wiki/Vehicle_Identification_Number
//
//  Created by Bryan Cribbs on 4/16/11.
//  Copyright 2011 OJC Technologies. All rights reserved.
//

#include "vin_check.h"

static int vin_check_transliterate(char);

static int
vin_check_transliterate(char c)
{
	if ('0' <= c && c <= '9')
		return c - '0';
	if ('a' <= c && c <= 'z')
		c = c - 'a' + 'A';
	switch (c) {
	case 'A': case 'J':
		return 1;
	case 'B': case 'K': case 'S':
		return 2;
	case 'C': case 'L': case 'T':
		return 3;
	case 'D': case 'M': case 'U':
		return 4;
	case 'E': case 'N': case 'V':
		return 5;
	case 'F':           case 'W':
		return 6;
	case 'G': case 'P': case 'X':
		return 7;
	case 'H':           case 'Y':
		return 8;
	          case 'R': case 'Z':
		return 9;
	default:
		return -1;
	}
}

vin_check_result_t
vin_check(const char *vin)
{
	int i, t, calculated, actual, sum = 0;
	static const int w[18] =
	    {8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2};

	for (i = 0; i < 18 && vin[i] != '\0'; i++) {
		t = vin_check_transliterate(vin[i]);
		if (t < 0)
			return VIN_CHECK_INVALID_CHAR;
		sum += t * w[i];
	}

	if (i > 17)
		return VIN_CHECK_TOO_LONG;
	if (i < 10)
		return VIN_CHECK_TOO_SHORT;
	if (i < 17)
		return VIN_CHECK_TEN_PLUS_CHARS;

	calculated = sum % 11;
	if (vin[8] == 'X' || vin[8] == 'x')
		actual = 10;
	else if ('0' <= vin[8] && vin[8] <= '9')
		actual = vin[8] - '0';
	else
		return VIN_CHECK_MISMATCH;	/* actually, invalid checksum */

	return (calculated == actual) ? VIN_CHECK_VALID : VIN_CHECK_MISMATCH;
}
