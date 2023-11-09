# 声明的变量, 标准: 一个变量一个确定的含义
include mk/Vars.mk

# EXCLUDE_INC_PATH: 如果有头文件不想纳入搜索中, 将其所在文件夹路径加入到这个变量中, 以 ./ 开头, 结尾不带 /
# 比如: EXCLUDE_INC_PATH = ./include
EXCLUDE_INC_PATH +=

# ONLY_INCLUDE_CFILE_PATH: 如果有整个文件夹的 .c 文件想纳入编译中, 将其所在文件夹路径加入到这个变量中 \
  以 ./ 开头, 结尾不带 /
# 注意: 只会将这个文件夹路径纳入 C 文件的搜索, 并不会将这个文件夹的子文件夹也纳入后续 C 文件的搜索
# 比如: ONLY_INCLUDE_CFILE_PATH = ./src
ONLY_INCLUDE_CFILE_PATH +=

EXCLUDE_CFILE_PATH += ./src

all:
	@echo "ALL_CFILE_PATH: \t"$(ALL_CFILE_PATH)
	@echo "EXCLUDE_CFILE_PATH: \t"$(EXCLUDE_CFILE_PATH)
	@echo "ONLY_INCLUDE_CFILE_PATH: \t"$(ONLY_INCLUDE_CFILE_PATH)
	@echo "CFILE_PATH: \t"$(CFILE_PATH)
	@echo "BUILD_CFILE: \t"$(BUILD_CFILE)


# FOLDERS := $(shell find $(ha) -type f -name "*.h" -exec dirname {} \; | sort -u)

# 伪目标
include mk/Phonys.mk
