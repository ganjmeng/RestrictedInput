#!/bin/bash


currentDir=$(cd "$(dirname "$0")"; pwd)
cd ${currentDir}


echo "\033[32m请输入提交信息：🙃 ====================================================\033[0m"
read commitInfo


echo "\033[32mgit 开始更新....🙃 ==================================================\033[0m"
git add .
git commit -m $commitInfo
git push -u origin master


echo "\033[32mgit 推送完毕🙃 ======================================================\033[0m"
