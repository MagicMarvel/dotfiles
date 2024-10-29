#!/bin/bash

files=$(ls -a $1 | grep -E '.[^.]+' |grep -v .git|grep -v nvim|grep -v autoconfig.sh)

# 检查 $1 是否为空
if [ -z "$1" ]; then
    # 如果 $1 为空，则将 current_dir 设置为当前工作目录
    current_dir=$(pwd)
else
    # 如果 $1 不为空，则将 current_dir 设置为 $1
    current_dir=$1
fi

for file in `echo $files`; do
    ln -f -s $current_dir/$file ~/$file # 创建软链接
done

# 配置nvim
ln -sf ~/.config/nvim ./nvim
