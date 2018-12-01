TARGET		:= Example_01
BUILD_DIR	:= build
SOURCE_DIR	:= src 
#-------------------------------------------------------------------------------
LDSCRIPT = stm32_flash.ld

AS := arm-none-eabi-as
CC := arm-none-eabi-gcc
LD := arm-none-eabi-ld
CP := arm-none-eabi-objcopy

LIBSPEC += -L/usr/lib/arm-none-eabi/newlib
LIBSPEC += -L/usr/lib/gcc/arm-none-eabi/5.4.1

LDFLAGS += -T $(LDSCRIPT)
LDFLAGS += -lgcc -lm -lc

INCLUDE_DIRS := include

DEFINES += STM32F10X_MD
DEFINES += USE_STDPERIPH_DRIVER
DEFINES += SYSCLK_FREQ_72MHz

CFLAGS += $(addprefix -I, $(INCLUDE_DIRS))
CFLAGS += $(addprefix -D, $(DEFINES))

CFLAGS += -mcpu=cortex-m3
CFLAGS += -mfloat-abi=soft
CFLAGS += -mthumb
CFLAGS += --specs=nosys.specs
CFLAGS += -O0
CFLAGS += -Wall -pedantic

#OBJS := $(patsubst %.c, %.o, $(wildcard  $(addsuffix /*.c, $(SOURCE_DIR))))
#OBJS += $(patsubst %.s, %.o, $(wildcard  $(addsuffix /*.s, $(SOURCE_DIR))))

SRC		:= $(shell find $(SOURCE_DIR) -type f -iname *.c)
SRC		+= $(shell find $(SOURCE_DIR) -type f -iname *.cpp)
SRC		+= $(shell find $(SOURCE_DIR) -type f -iname *.s)

OBJS	:= $(patsubst %.c,   %.o, $(SRC))
OBJS	+= $(patsubst %.cpp, %.o, $(SRC))
OBJS	+= $(patsubst %.s,   %.o, $(SRC))

DIRS	:= $(addprefix $(BUILD_DIR)/, $(shell find $(SOURCE_DIR) -type d))

#-------------------------------------------------------------------------------
all: configure compiler linker binary
#-------------------------------------------------------------------------------
configure:
	@mkdir -pv $(DIRS)
	@echo
#-------------------------------------------------------------------------------
compiler: $(OBJS)

%.o: %.c
	@$(CC) $(CFLAGS) $< -o $(BUILD_DIR)/$@

%.o: %.cpp
	@$(CC) $(CFLAGS) $< -o $(BUILD_DIR)/$@

%.o: %.s
	@$(AS) $< -o $(BUILD_DIR)/$@
#-------------------------------------------------------------------------------
linker:
	@$(LD) $(LIBSPEC) $(LDFLAGS) $(shell find $(BUILD_DIR) -type f -iname *.o) -o $(BUILD_DIR)/$(TARGET).elf
#-------------------------------------------------------------------------------
binary:
	@$(CP) -O binary $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).bin
	@rm -rf $(BUILD_DIR)/$(TARGET).elf
#-------------------------------------------------------------------------------
clean:
	@echo "clean"
	@rm -rf $(BUILD_DIR)
#-------------------------------------------------------------------------------
