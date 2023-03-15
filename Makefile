# CSCI 2021 Makefile project 2

AN = p2
SHELL = /bin/bash
CWD = $(shell pwd | sed 's/.*\///g')

clean : 
	$(MAKE) -C part1 clean
	$(MAKE) -C part2 clean

zip: clean
	rm -f $(AN)-code.zip
	cd .. && zip "$(CWD)/$(AN)-code.zip" -r "$(CWD)" -x "$(CWD)/*/server_files/*"
	@echo Zip created in $(AN)-code.zip
	@if (( $$(stat -c '%s' $(AN)-code.zip) > 10*(2**20) )); then echo "WARNING: $(AN)-code.zip seems REALLY big, check there are no abnormally large test files"; du -h $(AN)-code.zip; fi
	@if (( $$(unzip -t $(AN)-code.zip | wc -l) > 256 )); then echo "WARNING: $(AN)-code.zip has 256 or more files in it which may cause submission problems"; fi

help :
	@echo 'Makefile for submission'
	@echo '  > make clean                    # remove all compiled items'
	@echo '  > make zip                      # make zip file for submission'