# 声明的变量, 标准: 一个变量一个确定的含义
include mk/VarDeclare.mk

CROSS_COMPILE := arm-buildroot-linux-gnueabihf-
CC       := $(CROSS_COMPILE)gcc
LD       := $(CROSS_COMPILE)ld
OBJCOPY  := $(CROSS_COMPILE)objcopy
OBJDUMP  := $(CROSS_COMPILE)objdump

CFLAGS  += -Wall -fno-builtin  -O2
LDFLAGS  += -nostdlib

EXCLUDE_INC_PATH +=

EXCLUDE_CFILE_PATH      +=
ONLY_INCLUDE_CFILE_PATH += ./src/bsp/uart
ONLY_INCLUDE_SFILE_PATH +=

EXCLUDE_CFILE +=
EXCLUDE_SFILE +=

TARGET_NAME := test

include mk/VarConfirm.mk

all : $(BIN_ROOT_DIR)/$(TARGET_NAME).bin
	@echo $(TARGET_NAME).bin has been built!

$(BIN_ROOT_DIR)/$(TARGET_NAME).bin: $(BUILD_DIR_OBJ)
	@echo "Building executable: $@"
	$(LD) $(LDFLAGS) -o $(BIN_ROOT_DIR)/$(TARGET_NAME).elf $^
	$(OBJCOPY) -O binary -S $(BIN_ROOT_DIR)/$(TARGET_NAME).elf $@
	$(OBJDUMP) -D -m arm $(BIN_ROOT_DIR)/$(TARGET_NAME).elf > $(BIN_ROOT_DIR)/$(TARGET_NAME).dis

$(BUILD_DIR_SOBJ) : obj/%.o : %.S
	$(CC) $(CFLAGS) -nostdlib -c -o $@ $<

$(BUILD_DIR_COBJ): obj/%.o : %.c
	$(CC) $(CFLAGS) -nostdlib -c -o $@ $<

test:
	@echo "===================================================="
	@printf "%-20s" "VPATH:"
	@echo $(VPATH)
	@printf "%-20s" "PROJECT_ABS_ROOT_DIR:"
	@echo $(PROJECT_ABS_ROOT_DIR)
	@printf "%-20s" "DIR_COBJ:"
	@echo $(DIR_COBJ)
	@echo "===================================================="

info:
	@echo "===================================================="
	@printf "%-10s\n" "ALL_CFILE_PATH:"
	@$(foreach var,$(ALL_CFILE_PATH),         printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "EXCLUDE_CFILE_PATH:"
	@$(foreach var,$(EXCLUDE_CFILE_PATH),     printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "ONLY_INCLUDE_CFILE_PATH:"
	@$(foreach var,$(ONLY_INCLUDE_CFILE_PATH),printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "CFILE_PATH:"
	@$(foreach var,$(CFILE_PATH),             printf "\t%-20s\n" $(var);)
	@echo "===================================================="
	@echo
	@echo "===================================================="
	@printf "%-10s\n" "ALL_CFILE:"
	@$(foreach var,$(ALL_CFILE),     	printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "EXCLUDE_CFILE:"
	@$(foreach var,$(EXCLUDE_CFILE),    printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "BUILD_CFILE:"
	@$(foreach var,$(BUILD_CFILE),      printf "\t%-20s\n" $(var);)
	@echo "===================================================="
	@echo
	@echo "===================================================="
	@printf "%-10s\n" "ALL_SFILE_PATH:"
	@$(foreach var,$(ALL_SFILE_PATH),         printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "EXCLUDE_SFILE_PATH:"
	@$(foreach var,$(EXCLUDE_SFILE_PATH),     printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "ONLY_INCLUDE_SFILE_PATH:"
	@$(foreach var,$(ONLY_INCLUDE_SFILE_PATH),printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "SFILE_PATH:"
	@$(foreach var,$(SFILE_PATH),             printf "\t%-20s\n" $(var);)
	@echo "===================================================="
	@echo
	@echo "===================================================="
	@printf "%-10s\n" "ALL_SFILE:"
	@$(foreach var,$(ALL_SFILE),     	printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "EXCLUDE_SFILE:"
	@$(foreach var,$(EXCLUDE_SFILE),    printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "BUILD_SFILE:"
	@$(foreach var,$(BUILD_SFILE),      printf "\t%-20s\n" $(var);)
	@echo "===================================================="
	@echo
	@echo "===================================================="
	@printf "%-10s\n" "ALL_INC_PATH:"
	@$(foreach var,$(ALL_INC_PATH),			printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "EXCLUDE_INC_PATH:"
	@$(foreach var,$(EXCLUDE_INC_PATH),		printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "INC_PATH:"
	@$(foreach var,$(INC_PATH),   			printf "\t%-20s\n" $(var);)
	@echo "===================================================="
	@echo
	@echo "===================================================="
	@printf "%-10s\n" "TMP:"
	@$(foreach var,$(TMP),				printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "COBJFILE:"
	@$(foreach var,$(COBJFILE),			printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "SOBJFILE:"
	@$(foreach var,$(SOBJFILE),			printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "BUILD_DIR_COBJ:"
	@$(foreach var,$(BUILD_DIR_COBJ),			printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "BUILD_DIR_SOBJ:"
	@$(foreach var,$(BUILD_DIR_SOBJ),			printf "\t%-20s\n" $(var);)
	@printf "%-10s\n" "BUILD_DIR_OBJ:"
	@$(foreach var,$(BUILD_DIR_OBJ),			printf "\t%-20s\n" $(var);)
	@echo "===================================================="
# FOLDERS := $(shell find $(ha) -type f -name "*.h" -exec dirname {} \; | sort -u)

# 伪目标
include mk/Phonys.mk
