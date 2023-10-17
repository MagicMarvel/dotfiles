#!/bin/bash

files=$(ls -a $1 | grep -E '.[^.]+' |grep -v .git|grep -v nvim|grep -v autoconfig.sh)

for file in `echo $files`; do
    ln -s $1/$file ~/$file # 创建软链接
done

# 配置nvim
ln -sf ~/.config/nvim ./nvim
