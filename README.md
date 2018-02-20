[TOC]
## 项目概述
1.项目名称	: SPC_PCBView<br>
2.创建时间	: 20180209<br>
3.创建人    : peter<br>

## 项目根目录结构：
./
├── debug 调试项目目录<br>
├── lib   每个子项目编译后的动态库目录<br>
├── include 所有子项目的头文件目录<br>
├── src 存放整个项目的代码文件目录<br>
└── README.md 当前阅读文档<br>

#### 创建文件夹
根目录下创建以下文件夹<br>
/debug/config<br>
/lib/debug<br>
/data<br>
/include/Job<br>
/include/SSDK
>LinuxTerminal中使用以下命令直接创建:<br>
mkdir -p lib/debug data debug/config include/Job include/SSDK

## 配置说明:
#### APP
1. 打开qtCreator软件
2. 打开项目:
    - 依次点击Welcome->OpenProject->(SPC_PCBView项目路径) SPC_PCBView/src/APP/APP.pro
    - 将 Build directory 设置为: ../../debug
3. 配置完成

#### Job
1. 打开项目:
    - 依次点击Welcome->OpenProject->(SPC_PCBView项目路径) SPC_PCBView/src/Job/Job.pro
    - 将 Build directory 设置为: ./build/linux/debug
2. 设置Build Steps:
    - 依次点击Projects->BuildSteps->AddBuildStep->CustomProcessStep
    - 将Command修改为:./debug_build.sh
3. 配置完成

#### SSDK
1. 打开项目:
    - 依次点击Welcome->OpenProject->(SPC_PCBView项目路径) SPC_PCBView/src/SSDK/SSDK.pro
    - 将 Build directory 设置为: ./build/linux/debug
2. 设置Build Steps:
    - 依次点击Projects->BuildSteps->AddBuildStep->CustomProcessStep
    - 将Command修改为:./debug_build.sh
3. 配置完成