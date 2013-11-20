//
//  vin_check
//  Translated from http://en.wikipedia.org/wiki/Vehicle_Identification_Number
//
//  Created by Bryan Cribbs on 4/16/11.
//  Copyright 2011 OJC Technologies. All rights reserved.
//

enum vin_check_result {
	  VIN_CHECK_VALID = 0
	, VIN_CHECK_MISMATCH
	, VIN_CHECK_TEN_PLUS_CHARS
	, VIN_CHECK_TOO_SHORT
	, VIN_CHECK_TOO_LONG
	, VIN_CHECK_INVALID_CHAR
};

typedef enum vin_check_result vin_check_result_t;

vin_check_result_t vin_check(const char *);
