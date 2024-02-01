#!/bin/bash

# 定义公共路径
PROJECT_PATH="/home/sub-web"
DIST_PATH="${PROJECT_PATH}/dist"
TARGET_PATH="/opt/1panel/apps/openresty/openresty/www/sites/sub.lainbo.com"
TARGET_FOLDER="index"

# 进入项目目录
cd $PROJECT_PATH

# 从远程仓库拉取最新代码
git pull

# 安装项目依赖
yarn install

# 构建项目
yarn build

# 检查目标路径是否存在index文件夹，如果存在则删除
if [ -d "${TARGET_PATH}/${TARGET_FOLDER}" ]; then
    rm -rf "${TARGET_PATH}/${TARGET_FOLDER}"
fi

# 将构建好的dist文件夹移动到目标路径，并重命名为index
mv $DIST_PATH "${TARGET_PATH}/${TARGET_FOLDER}"
echo "已经拉取最新代码, 并且将构建产物移动到1Panel目标路径"
