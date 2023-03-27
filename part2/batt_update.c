#include "batt.h"


// Uses the two global variables (ports) BATT_VOLTAGE_PORT and
// BATT_STATUS_PORT to set the fields of the parameter 'batt'.  If
// BATT_VOLTAGE_PORT is negative, then battery has been wired wrong;
// no fields of 'batt' are changed and 1 is returned to indicate an
// error.  Otherwise, sets fields of batt based on reading the voltage
// value and converting to percent using the provided formula. Returns
// 0 on a successful execution with no errors. This function DOES NOT
// modify any global variables but may access global variables.
//
// CONSTRAINT: Avoids the use of the division operation as much as
// possible. Makes use of shift operations in place of division where
// possible.
//
// CONSTRAINT: Uses only integer operations. No floating point
// operations are used as the target machine does not have a FPU.
// 
// CONSTRAINT: Limit the complexity of code as much as possible. Do
// not use deeply nested conditional structures. Seek to make the code
// as short, and simple as possible.
/* int set_batt_from_ports(batt_t* batt) {
    if(BATT_VOLTAGE_PORT>=0){
        batt->mlvolts = BATT_VOLTAGE_PORT >> 1;
        batt->percent = ((batt->mlvolts) - 3000) >> 3;
        if((batt->mlvolts) - 3000 < 0){
            batt->percent = 0;
        }
        if(batt->percent > 100){
            batt->percent = 100;
        }
        unsigned char b = BATT_STATUS_PORT << 3;
        b = b >> 7;
        batt->mode = 2 - b;
        return 0;
    }
    return 1;
}
*/

/*int seven_segment_bitmask[10] = {
                        0b0111111,
                        0b0000110,
                        0b1011011,
                        0b1001111,
                        0b1100110,
                        0b1101101,
                        0b1111101,
                        0b0000111,
                        0b1111111,
                        0b1101111,
                        };*/

// Alters the bits of integer pointed to by 'display' to reflect the
// data in struct param 'batt'.  Does not assume any specific bit
// pattern stored at 'display' and completely resets all bits in it on
// successfully completing.  Selects either to show Volts (mode=1) or
// Percent (mode=2). If Volts are displayed, only displays 3 digits
// rounding the lowest digit up or down appropriate to the last digit.
// Calculates each digit to display changes bits at 'display' to show
// the volts/percent according to the pattern for each digit. Modifies
// additional bits to show a decimal place for volts and a 'V' or '%'
// indicator appropriate to the mode. In both modes, places bars in
// the level display as indicated by percentage cutoffs in provided
// diagrams. This function DOES NOT modify any global variables but
// may access global variables. Always returns 0.
// 
// CONSTRAINT: Limit the complexity of code as much as possible. Do
// not use deeply nested conditional structures. Seek to make the code
// as short, and simple as possible.

/*int set_display_from_batt(batt_t batt, int* display) {
    // Percent
    if (batt.mode == 1) {
        *display = 0b1;

        int nums = batt.percent;

        // Right
        *display += seven_segment_bitmask[nums % 10] << 3;
        nums /= 10;

        // Middle
        if (nums % 10 != 0 || nums / 10 == 1) {
            *display += seven_segment_bitmask[nums % 10] << 10;
            nums /= 10;
        }

        // Left
        if (nums % 10 != 0) {
            *display += seven_segment_bitmask[nums % 10] << 17;
        }
    }
    // Voltage
    else if (batt.mode == 2) {
        *display = 0b110;

        int nums = batt.mlvolts;

        if (nums % 10 >= 5) {
            nums += 10;
        }

        nums /= 10;

        // Right
        *display += seven_segment_bitmask[nums % 10] << 3;
        nums /= 10;

        // Middle
        *display += seven_segment_bitmask[nums % 10] << 10;
        nums /= 10;

        // Left
        *display += seven_segment_bitmask[nums % 10] << 17;
    }

    // Battery level
    *display += (batt.percent >= 5) << 24;
    *display += ((1 << ((batt.percent - 30) / 20 + 1)) - 1) << 25;

    return 0;
}*/


// Called to update the battery meter display.  Makes use of
// set_batt_from_ports() and set_display_from_batt() to access battery
// voltage sensor then set the display. Checks these functions and if
// they indicate an error, does NOT change the display.  If functions
// succeed, modifies BATT_DISPLAY_PORT to show current battery level.
// 
// CONSTRAINT: Does not allocate any heap memory as malloc() is NOT
// available on the target microcontroller.  Uses stack and global
// memory only.
/*int batt_update() {
    batt_t batt;
    int ret = set_batt_from_ports(&batt);
    if(ret == 0){
        set_display_from_batt(batt, &BATT_DISPLAY_PORT);
        return ret;
    }
    return ret;
}*/
