#!/bin/bash

# 执行 Maven 构建（clean 和 package）
mvn clean package

# 检查构建是否成功
if [ $? -eq 0 ]; then
    echo "Maven 构建成功"

    # 获取最新生成的JAR文件的路径
    jar_file=$(find ./ -name "*.jar" | sort -n | tail -1)

    # 打印JAR文件路径
    echo "找到JAR文件: $jar_file"

    # 运行JAR文件
    java -jar "$jar_file"

else
    echo "Maven 构建失败"
fi

