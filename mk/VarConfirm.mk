# PROJECT_ROOT_DIR: 整个项目的根目录路径
PROJECT_ROOT_DIR = .
BUILD_ROOT_DIR = obj
BIN_ROOT_DIR = bin

# 检测 BUILD_ROOT_DIR, BIN_ROOT_DIR 路径是否存在, 如果不存在, 创建
ifneq ($(wildcard $(BUILD_ROOT_DIR)),)
else
    $(shell mkdir -p $(BUILD_ROOT_DIR))
endif
ifneq ($(wildcard $(BIN_ROOT_DIR)),)
else
    $(shell mkdir -p $(BIN_ROOT_DIR))
endif

# ALL_INC_PATH: 整个项目中只要有头文件的文件夹, 将其路径加入到这个变量中
# EXCLUDE_INC_PATH: 如果有头文件不想纳入搜索中, 将其所在文件夹路径加入到这个变量中, 以 ./ 开头, 结尾不带 /
# INC_PATH: 从 ALL_INC_PATH 中过滤掉 EXCLUDE_INC_PATH 中的文件夹
# 比如: \
	ALL_INC_PATH = ./include ./include/xxx \
	EXCLUDE_INC_PATH = ./include \
	INC_PATH = ./include/xxx
ALL_INC_PATH += $(shell find $(PROJECT_ROOT_DIR) -type f -name "*.h" -exec dirname {} \; | sort -u)
EXCLUDE_INC_PATH +=
INC_PATH += $(filter-out $(EXCLUDE_INC_PATH),$(ALL_INC_PATH))

# *ALL_CFILE_PATH: 整个项目中所有 .C 文件所在的文件夹路径
# *EXCLUDE_CFILE_PATH: 如果有整个文件夹的 .c 文件都不想纳入编译中, 将其所在文件夹路径加入到这个变量中
# !注意: 不光会排除这个文件夹路径, 还会将这个文件夹的子文件夹也排除
# *ONLY_INCLUDE_CFILE_PATH: 如果有整个文件夹的 .c 文件想纳入编译中, 将其所在文件夹路径加入到这个变量中
# !注意: 只会将这个文件夹路径纳入 C 文件的搜索, 并不会将这个文件夹的子文件夹也纳入后续 C 文件的搜索
# *CFILE_PATH: 从 ALL_CFILE_PATH 中过滤掉 EXCLUDE_CFILE_PATH 后剩下的文件夹路径
# 比如: \
	ALL_CFILE_PATH = ./src ./src/bsp/uart ./src/bsp/gpio \
	EXCLUDE_CFILE_PATH = ./src/bsp \
	ONLY_INCLUDE_CFILE_PATH = ./src/bsp/uart \
	CFILE_PATH = ./src ./src/bsp/uart
ALL_CFILE_PATH += $(shell find $(PROJECT_ROOT_DIR) -type f -name "*.c" -exec dirname {} \; | sort -u)
EXCLUDE_CFILE_PATH +=
ONLY_INCLUDE_CFILE_PATH +=
ifeq ($(strip $(EXCLUDE_CFILE_PATH)),)
	CFILE_PATH += $(ALL_CFILE_PATH)
else
	CFILE_PATH += $(shell echo $(ALL_CFILE_PATH) | tr ' ' '\n' | grep -v "$(EXCLUDE_CFILE_PATH)" | tr '\n' ' ')
endif
CFILE_PATH += $(ONLY_INCLUDE_CFILE_PATH)
# 去除重复的文件夹路径
CFILE_PATH := $(sort $(CFILE_PATH))

# ALL_CFILE: 整个项目中(已经排除掉指定文件夹)所有 .c 文件, 将其文件路径加入到这个变量中
# EXCLUDE_CFILE: 如果有源文件不想被编译, 将其文件路径加入到这个变量中
# BUILD_CFILE: 从 ALL_CFILE 中过滤掉 EXCLUDE_CFILE 后的文件路径
# 比如:  \
	CFILE_PATH = ./src ./src/bsp/uart \
  	ALL_CFILE = ./src/main.c ./src/bsp/uart/uart.c \
	EXCLUDE_CFILE = ./src/main.c \
	BUILD_CFILE := ./src/bsp/uart/uart.c
ALL_CFILE     += $(foreach dir, $(CFILE_PATH), $(wildcard $(dir)/*.c))
EXCLUDE_CFILE +=
BUILD_CFILE   += $(filter-out $(EXCLUDE_CFILE),$(ALL_CFILE))

# *ALL_SFILE_PATH: 整个项目中所有 .s 文件所在的文件夹路径
# *EXCLUDE_SFILE_PATH: 如果有整个文件夹的 .s 文件都不想纳入编译中, 将其所在文件夹路径加入到这个变量中
# !注意: 不光会排除这个文件夹路径, 还会将这个文件夹的子文件夹也排除
# *ONLY_INCLUDE_SFILE_PATH: 如果有整个文件夹的 .c 文件想纳入编译中, 将其所在文件夹路径加入到这个变量中
# !注意: 只会将这个文件夹路径纳入 .s 文件的搜索, 并不会将这个文件夹的子文件夹也纳入后续 .s 文件的搜索
# *SFILE_PATH: 从 ALL_SFILE_PATH 中过滤掉 EXCLUDE_SFILE_PATH 后剩下的文件夹路径
# 比如: \
	ALL_SFILE_PATH = ./src ./src/bsp/uart ./src/bsp/gpio \
	EXCLUDE_SFILE_PATH = ./src/bsp \
	ONLY_INCLUDE_SFILE_PATH = ./src/bsp/uart \
	SFILE_PATH = ./src ./src/bsp/uart
ALL_SFILE_PATH += $(shell find $(PROJECT_ROOT_DIR) -type f -name "*.[sS]" -exec dirname {} \; | sort -u)
EXCLUDE_SFILE_PATH +=
ONLY_INCLUDE_SFILE_PATH +=
ifeq ($(strip $(EXCLUDE_SFILE_PATH)),)
	SFILE_PATH += $(ALL_SFILE_PATH)
else
	SFILE_PATH += $(shell echo $(ALL_SFILE_PATH) | tr ' ' '\n' | grep -v "$(EXCLUDE_SFILE_PATH)" | tr '\n' ' ')
endif
SFILE_PATH += $(ONLY_INCLUDE_SFILE_PATH)
# 去除重复的文件夹路径
SFILE_PATH := $(sort $(SFILE_PATH))

# ALL_SFILE:     整个项目中(已经排除掉指定文件夹)所有 .s 源文件, 将其文件路径加入到这个变量中
# EXCLUDE_SFILE: 如果有源文件不想被编译, 将其文件路径加入到这个变量中
# BUILD_SFILE:   从 ALL_SFILE 中过滤掉 EXCLUDE_SFILE 后的文件路径
# 比如:  \
	SFILE_PATH    := ./src \
  	ALL_SFILE     := ./src/start.S ./src/init.s \
	EXCLUDE_SFILE := ./src/start.S \
	BUILD_SFILE   := ./src/init.s
ALL_SFILE	  += $(foreach dir, $(SFILE_PATH), $(wildcard $(dir)/*.[sS]))
EXCLUDE_SFILE +=
BUILD_SFILE	  += $(filter-out $(EXCLUDE_SFILE),$(ALL_SFILE))

# COBJFILE: 取出 BUILD_CFILE 中的值, 剔除路径, 剔除文件名后缀, 增加 .o 文件名后缀
# SOBJFILE: 取出 BUILD_SFILE 中的值, 剔除路径, 剔除文件名后缀, 增加 .o 文件名后缀
# OBJFILE: 取出 COBJFILE 和 SOBJFILE 中的值放入这个变量
# 比如: \
	BUILD_CFILE := ./src/bsp/uart/uart.c ./src/main.c \
	BUILD_SFILE := ./src/init.s \
	COBJFILE	:= uart.o main.o \
	SOBJFILE    := init.o \
	OBJFILE     := uart.o main.o init.o
TMP		 := $(notdir  $(BUILD_CFILE))
COBJFILE += $(patsubst %, %, $(TMP:.c=.o))
TMP		 := $(notdir  $(BUILD_SFILE))
SOBJFILE += $(shell echo $(TMP) | sed 's/\.[sS]/\.o/g')
OBJFILE  += $(COBJFILE) $(SOBJFILE)

# BUILD_COBJ: 给 COBJFILE 加上构建路径
# BUILD_SOBJ: 给 SOBJFILE 加上构建路径
# BUILD_OBJ: 取出 BUILD_COBJ 和 BUILD_SOBJ 中的值放入这个变量
# 比如: \
	COBJFILE := uart.o main.o \
	SOBJFILE := init.o \
	BUILD_COBJ	  := obj/uart.o obj/main.o \
	BUILD_SOBJ    := obj/init.o \
	BUILD_OBJ     := obj/uart.o obj/main.o obj/init.o
BUILD_COBJ		:= $(patsubst %, $(BUILD_ROOT_DIR)/%, $(COBJFILE))
BUILD_SOBJ		:= $(patsubst %, $(BUILD_ROOT_DIR)/%, $(SOBJFILE))
BUILD_OBJ       := $(BUILD_COBJ) $(BUILD_SOBJ)

# VPATH: Makefile 中的特殊变量, 用于指定额外的搜索路径, 使得 Make 在这些路径下查找文件
# ! 必须给这个变量赋值
VPATH := $(CFILE_PATH) $(SFILE_PATH)
# 去除重复的文件夹路径
VPATH := $(sort $(VPATH))
