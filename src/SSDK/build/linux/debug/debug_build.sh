#!/bin/bash

declare projectName=$1 #项目名称, 如"SDK"
declare buildType=$2  #编译模式, 如"debug"
declare includeDirPath="../../../../../include/$projectName"
declare libDirPath="../../../../../lib/$buildType/"
echo $libDirPath

#注意：
#    1.如果没有找到一个需要打包的.hpp/.h，脚本会报“谨慎地拒绝创建空归档文件”
#      的错误
#    2.

#把.hpp后缀的打包到t1
find ../../../ -name '*.hpp' |xargs tar czf t1.tgz
#把.h后缀的打包到t2
find ../../../ -name '*.h' |xargs tar czf t2.tgz

#判断包含目录是否存在, 若不存在则创建目录
if [ ! -d "$includeDirPath" ]; then 
	mkdir "$includeDirPath" 
fi 

#删除include/projectName
rm -f -R $includeDirPath/*

#判断压缩文件是否存在，存在的话进行解压
if [ -a "t1.tgz" ];then
	tar xzvf t1.tgz -C $includeDirPath
fi

if [ -a "t2.tgz" ];then
	tar xzvf t2.tgz -C $includeDirPath
fi

#删除压缩包
rm -f t1.tgz
rm -f t2.tgz

#判断库生成目录是否存在, 若不存在则创建目录
if [ ! -d "$libDirPath" ]; then 
	mkdir "$libDirPath" 
fi 

#拷贝所有的.so文件到debug目录
#注意：
#	1.如果是静态库，win下是.lib， linux下就是.a
#	2.如果是动态库，win下是.dll,  linux下就是.so
#	3.如果是debug就到debug，如果是release就到release目录
cp -rf *.so* $libDirPath
