# 符号表问题

gdb调试碰到的符号表问题

进入~/glibc-all-in-one/libs/目录
![image-20250403162311117](./patchelf之后如何自动加载符号表.assets/image-20250403162311117.png)

进去需要的libc版本目录下(以2.23为例)，显示隐藏文件.debug,这里面是符号表信息

![image-20250403162358182](./patchelf之后如何自动加载符号表.assets/image-20250403162358182.png)

进入.debug/lib/x86_64-linuxgnu/

![image-20250403162509081](./patchelf之后如何自动加载符号表.assets/image-20250403162509081.png)

找到libc-2.23.so文件，复制到.debug根目录下

![image-20250403162612797](./patchelf之后如何自动加载符号表.assets/image-20250403162612797.png)

就可以不用gdb的命令情况下，super_libc更改好文件libc后, pwndbg打开文件，直接就能加载好符号表。

2.23.2.27都跟上面一样

2.31版本符号表改动，在下面的文件夹里面

![image-20250403165221389](./patchelf之后如何自动加载符号表.assets/image-20250403165221389.png)

将里面的文件复制到debug根目录

### 2.34，2.35之后，将所有的文件复制到debug根目录就行，符号表太多了
在.build-id目录下执行cp ./*/* ../
