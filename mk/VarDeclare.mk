# === 编译工具链相关的变量 Begin
ARCH =
CROSS_COMPILE =

CC      =
AS  	=
LD  	=
CC      =
CPP     =
AR      =
NM	    =
STRIP	=
OBJCOPY =
OBJDUMP =

# ALL_INC_PATH: 整个项目中只要有头文件的文件夹, 就将该文件夹路径加入到这个变量中
ALL_INC_PATH =
INC_FLAG =
C_FLAGS =
CPP_FLAGS =

LD_FLAGS =
# === 编译工具链相关的变量 End

# PROJECT_ROOT_DIR: 整个项目的根目录路径
PROJECT_ROOT_DIR = .

# ALL_INC_PATH: 整个项目中只要有头文件的文件夹, 将其路径加入到这个变量中
# 比如: ALL_INC_PATH = ./include ./include/xxx
ALL_INC_PATH := $(shell find $(PROJECT_ROOT_DIR) -type f -name "*.h" -exec dirname {} \; | sort -u)

# EXCLUDE_INC_PATH: 如果有头文件不想纳入搜索中, 将其所在文件夹路径加入到这个变量中, 以 ./ 开头, 结尾不带 /
# 比如: EXCLUDE_INC_PATH = ./include
EXCLUDE_INC_PATH :=

# INC_PATH: 从 ALL_INC_PATH 中过滤掉 EXCLUDE_INC_PATH 中的文件夹
INC_PATH = $(filter-out $(EXCLUDE_INC_PATH),$(ALL_INC_PATH))

# ALL_CFILE_PATH: 整个项目中所有 .C 文件所在的文件夹路径
# 比如: ALL_CFILE_PATH = ./src ./src/uart
ALL_CFILE_PATH := $(shell find $(PROJECT_ROOT_DIR) -type f -name "*.c" -exec dirname {} \; | sort -u)

# EXCLUDE_CFILE_PATH: 如果有整个文件夹的 .c 文件都不想纳入编译中, 将其所在文件夹路径加入到这个变量中 \
  以 ./ 开头, 结尾不带 /
# 注意: 不光会排除这个文件夹路径, 还会将这个文件夹的子文件夹也排除
# 比如: EXCLUDE_CFILE_PATH = ./src
EXCLUDE_CFILE_PATH =

# ONLY_INCLUDE_CFILE_PATH: 如果有整个文件夹的 .c 文件想纳入编译中, 将其所在文件夹路径加入到这个变量中 \
  以 ./ 开头, 结尾不带 /
# 注意: 只会将这个文件夹路径纳入 C 文件的搜索, 并不会将这个文件夹的子文件夹也纳入后续 C 文件的搜索
# 比如: ONLY_INCLUDE_CFILE_PATH = ./src
ONLY_INCLUDE_CFILE_PATH :=

# CFILE_PATH: 从 ALL_CFILE_PATH 中过滤掉 EXCLUDE_CFILE_PATH 中的文件夹
# 注意: 这里使用的变量赋值方式是延时赋值, 只有在使用这个变量的时候, 才会分析这个变量最终的值是什么
# 原因: 之所以使用延时赋值, 是因为 EXCLUDE_CFILE_PATH 是可能在后面发生变动的
ifeq ($(strip $(EXCLUDE_CFILE_PATH)),)
	CFILE_PATH = $(ALL_CFILE_PATH)
else
	CFILE_PATH = $(shell echo $(ALL_CFILE_PATH) | tr ' ' '\n' | grep -v "$(EXCLUDE_CFILE_PATH)" | tr '\n' ' ')
endif
CFILE_PATH += $(ONLY_INCLUDE_CFILE_PATH)

# ALL_CFILE: 整个项目中所有源文件, 将其文件路径加入到这个变量中
# 比如: ALL_CFILE = ./src/main.c ./src/uart/uart.c
ALL_CFILE := $(shell find $(CFILE_PATH) -type f -name "*.c")

# EXCLUDE_CFILE: 如果有源文件不想被编译, 将其文件路径加入到这个变量中, 以 ./ 开头
# 比如: EXCLUDE_CFILE = ./src/main.c
EXCLUDE_CFILE :=

# BUILD_CFILE: 从 ALL_CFILE 中过滤掉 EXCLUDE_CFILE 中的文件
# 注意: 这里使用的变量赋值方式是延时赋值, 只有在使用这个变量的时候, 才会分析这个变量最终的值是什么
# 原因: 之所以使用延时赋值, 是因为 EXCLUDE_CFILE 是可能在后面发生变动的
BUILD_CFILE = $(filter-out $(EXCLUDE_CFILE),$(ALL_CFILE))

# 导出所有声明的变量
export $(shell sed -n 's/^\([^#]*\) *=.*/\1/p' mk/VarDeclare.mk)

