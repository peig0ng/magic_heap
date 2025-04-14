# super_libc 🔧
```tex
> 一款用于CTF Pwn挑战的自动化GLIBC切换脚本，支持交互式版本选择和路径自动检测
以及通过操作glibc-all-in-one每次调试自带符号表，详细操作见md文件

## 功能特性 ✨

- 🚀 自动检测glibc-all-in-one安装路径
- 📂 交互式GLIBC版本选择菜单
- ✅ ELF文件验证
- 🔍 支持环境变量指定路径
- 💻 兼容各版本Ubuntu系统
- 🛠️ 自动依赖检查与错误提示

## 安装指南 📦

### 前置要求
- Ubuntu系统（推荐20.04/22.04）
- `patchelf`工具
- glibc-all-in-one

```

首先安装glibc-all-in-one，patchelf

glibc-all-in-one

```sh
cd ~/
git clone https://github.com/matrix1001/glibc-all-in-one
cd ~/glibc-all-in-one
sudo python3 update_list
cd ..
```

在glibc-all-in-one中

```sh
cd ~/
cd glibc-all-in-one
chmod +x update-list
cat list
sudo ./download <需要的libc版本>
```

patchelf

```sh
cd ~/
sudo apt install patchelf
```

super_libc

```sh
cd ~/
git clone https://github.com/peig0ng/super_libc.git
```



## 使用方法 🛠️

### 基本命令

```
./super_libc.sh <binary>
```

### 选项说明

- 设置环境变量（可选）：

  ```
  export GLIBC_ALL_IN_ONE_PATH=/path/to/your/glibc-all-in-one
  ```

### 操作流程

1. 运行脚本指定目标ELF文件
2. 选择glibc版本（自动列出可用版本）
3. 自动完成修补操作
4. 验证结果

## 使用示例 📝

```sh
$ ./super_libc.sh ./magicheap

Available glibc versions:
 0) 2.23-0ubuntu11.3_amd64
 1) 2.27-3ubuntu1.6_amd64
 2) 2.31-0ubuntu9.9_amd64

Select version (0-2): 0

Patching with:
Interpreter: /home/user/glibc-all-in-one/libs/2.23-0ubuntu11.3_amd64/ld-2.23.so
RPATH:      /home/user/glibc-all-in-one/libs/2.23-0ubuntu11.3_amd64/

Patch successful!
Verify with:
  file ./magicheap
  ldd ./magicheap
```

## 注意事项 ⚠️

1. 确保目标ELF文件具有可写权限

2. glibc-all-in-one需要预先下载完整版本

3. 如果遇到路径问题，可手动指定：

   ```
   GLIBC_ALL_IN_ONE_PATH=/custom/path ./glibc-patcher.sh <ELF>
   ```

4. 修补后建议使用`ldd`命令验证结果

------

⭐ 如果觉得本项目有帮助，欢迎Star支持！
