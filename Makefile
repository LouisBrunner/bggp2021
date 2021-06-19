SRCDIR = src
BUILD = build

# Final file
SRC = $(SRCDIR)/pog.asm
OBJ = $(BUILD)/pog.zip

# Intermediate
FILE2INC = $(SRCDIR)/test
FILE2INC_NAME = abc.txt
FILE2INC_DATE = 1993-04-30
FILE2INC_TIME = 20:13:37
F2I_NAME = $(BUILD)/test.name
F2I_META = $(BUILD)/test.meta
F2I_COMP = $(BUILD)/test.deflated
F2I = $(F2I_META) $(F2I_COMP) $(F2I_NAME)

# Workflow
all: $(OBJ) audit
.PHONY: all

audit: $(OBJ)
	$(eval SIZE=$(shell stat -c '%s' $<))
	@stat $< > /dev/null 2>&1 || exit 1
	@echo Size: $(SIZE)
	@test $(SIZE) -le 4096 || echo 'Warning: too big ($(SIZE))'
	$(eval RES=$(shell $(OBJ); echo $$? && true))
	@test $(RES) -eq 2 || echo 'Warning: wrong result ($(RES))'
.PHONY: audit

clean:
	rm -rf $(BUILD)
.PHONY: clean

re: clean all
.PHONY: re

# Compilation
$(F2I_NAME): Makefile
	echo 'db "$(FILE2INC_NAME)"' > $@

$(F2I_COMP): $(FILE2INC)
	cat $< | zlib-flate -compress=9 > $@

$(F2I_META): $(FILE2INC) $(F2I_COMP) Makefile
	: > $@
	( echo -n 'dw '; $(SRCDIR)/msdos-date.py --mode time --thing $(FILE2INC_TIME) ) >> $@
	( echo -n 'dw '; $(SRCDIR)/msdos-date.py --mode date --thing $(FILE2INC_DATE) ) >> $@
	( echo -n 'dd 0x'; crc32 $(FILE2INC) ) >> $@
	( echo -n 'dd '; stat -c '%s' $(F2I_COMP) ) >> $@
	( echo -n 'dd '; stat -c '%s' $(FILE2INC) ) >> $@

$(OBJ): $(SRC) $(BUILD) $(F2I)
	nasm -f bin -o $@ $<
	chmod +x $@

$(BUILD):
	mkdir -p $@
