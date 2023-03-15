# CSCI 2021 Project 2, part 1 Makefile

AN = p2
CLASS = 2021

# -Wno-comment: disable warnings for multi-line comments, present in some tests
CFLAGS = -Wall -Wno-comment -Werror -g 
CC     = gcc $(CFLAGS)
SHELL  = /bin/bash
CWD    = $(shell pwd | sed 's/.*\///g')

PROGRAMS = \
	batt_main \
	test_batt_update \


all : $(PROGRAMS)

clean :
	rm -f $(PROGRAMS) *.o

help :
	@echo 'Typical usage is:'
	@echo '  > make                          # build all programs'
	@echo '  > make clean                    # remove all compiled items'
	@echo '  > make test testnum=5           # run test #5 only'
	@echo '  > make test                     # run all tests'

zip :
	@echo 'ERROR: The zip file must be made in the project_2 directory!'

################################################################################
# battery problem (C)
batt : batt_main

batt_main : batt_main.o batt_update.o batt_sim.o
	$(CC) -o $@ $^

batt_main.o : batt_main.c batt.h
	$(CC) -c $<

batt_sim.o : batt_sim.c batt.h
	$(CC) -c $<

batt_update.o : batt_update.c batt.h
	$(CC) -c $<

test_batt_update : test_batt_update.o batt_sim.o batt_update.o
	$(CC) -o $@ $^

test_batt_update.o : test_batt_update.c
	$(CC) -c $<

################################################################################
# Testing Targets
test-setup :
	@chmod u+rx testy

test: test-batt

test-batt: test-setup batt test_batt_update
	./testy test_batt_update.org $(testnum)

clean-tests : 
	rm -rf test-results/ 


