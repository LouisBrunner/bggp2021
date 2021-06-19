BUILD = build
SRC = src
POG = $(BUILD)/pog.zip

all: $(BUILD) $(POG) audit
.PHONY: all

audit:
# $(eval SIZE=$(shell stat -f '%z' $(POG)))
	$(eval SIZE=$(shell stat -c '%s' $(POG)))
	@stat $(POG) > /dev/null 2>&1 || exit 1
	@echo Size: $(SIZE)
	@test $(SIZE) -le 4096 || echo 'Warning: too big ($(SIZE))'
	$(eval RES=$(shell $(POG); echo $$? && true))
	@test $(RES) -eq 2 || echo 'Warning: wrong result ($(RES))'
.PHONY: audit

clean:
	rm -rf $(BUILD)
.PHONY: clean

re: clean all
.PHONY: re

# $(POG).o: $(SRC)/arm64.asm
# 	as -Oz -o $@ $<

# $(POG): $(POG).o
# 	ld -o $@ $< -e _start -static -no_uuid -macosx_version_min 11.0
# 	strip --strip-all $(POG)

$(POG): $(SRC)/nasm.asm
	@# cat $< | zlib-flate -compress=9 > $(POG).deflated
	nasm -f bin -o $@ $<
	chmod +x $@

$(BUILD):
	mkdir -p $@
