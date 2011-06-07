CC        := g++ -Wall -O -g3
LD        := ar rc

MODULES   := zxing zxing/common zxing/common/reedsolomon zxing/datamatrix zxing/datamatrix/decoder zxing/datamatrix/detector zxing/oned zxing/qrcode zxing/qrcode/detector zxing/qrcode/decoder
SRC_DIR   := $(addprefix core/src/,$(MODULES))
BUILD_DIR := $(addprefix build/,$(MODULES))

SRC       := $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/*.cpp))
OBJ       := $(patsubst core/src/%.cpp,build/%.o,$(SRC))
INCLUDES  := -Icore/src/ $(addprefix -I,$(SRC_DIR))
# INCLUDES  := -Icore/src/

vpath %.cpp $(SRC_DIR)

define make-goal
$1/%.o: %.cpp
	$(CC) $(INCLUDES) -c $$< -o $$@
endef

.PHONY: all checkdirs clean

all: checkdirs build/zxing.a

build/zxing.a: $(OBJ)
	$(LD) $@ $^
	ranlib $@

checkdirs: $(BUILD_DIR)

$(BUILD_DIR):
	@mkdir -p $@

clean:
	@rm -rf $(BUILD_DIR)

$(foreach bdir,$(BUILD_DIR),$(eval $(call make-goal,$(bdir))))
