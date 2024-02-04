# dd

dd 是 device driver 的缩写，它用来读取设备、文件中的内容，并原封不动地复制到指定位置。

补充说明

dd命令 用于复制文件并对原文件的内容进行转换和格式化处理。dd命令功能很强大的，对于一些比较底层的问题，使用dd命令往往可以得到出人意料的效果。用的比较多的还是用dd来备份裸设备。但是不推荐，如果需要备份oracle裸设备，可以使用rman备份，或使用第三方软件备份，使用dd的话，管理起来不太方便。

建议在有需要的时候使用dd 对物理磁盘操作，如果是文件系统的话还是使用tar backup cpio等其他命令更加方便。另外，使用dd对磁盘操作时，最好使用块设备文件。

## 语法

> dd(选项)

### 选项

* bs=<字节数>：将ibs（输入）与obs（输出）设成指定的字节数；
* cbs=<字节数>：转换时，每次只转换指定的字节数；
* conv=<关键字>：指定文件转换的方式；
* count=<区块数>：仅读取指定的区块数；
* ibs=<字节数>：每次读取的字节数；
* obs=<字节数>：每次输出的字节数；
* of=<文件>：输出到文件；
* seek=<区块数>：一开始输出时，跳过指定的区块数；
* skip=<区块数>：一开始读取时，跳过指定的区块数；
* --help：帮助；
* --version：显示版本信息。

## 简单实例

```shell
# dd if=/dev/zero of=sun.txt bs=1M count=1
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 0.006107 seconds, 172 MB/s

# du -sh sun.txt
1.1M    sun.txt
```

该命令创建了一个1M大小的文件sun.txt，其中参数解释：

* if 代表输入文件。如果不指定if，默认就会从stdin中读取输入。
* of 代表输出文件。如果不指定of，默认就会将stdout作为默认输出。
* bs 代表字节为单位的块大小。
* ount 代表被复制的块数。
* /dev/zero 是一个字符设备，会不断返回0值字节（\0）。


块大小可以使用的计量单位表

| 单元大小         | 代码 |
| ---------------- | ---- |
| 字节（1B）       | c    |
| 字节（2B）       | w    |
| 块（512B）       | b    |
| 千字节（1024B）  | k    |
| 兆字节（1024KB） | M    |
| 吉字节（1024MB） |      |


## 备份磁盘并恢复

硬盘基本都是使用 hda、hdb 这种 IDE 接口的硬盘，现在的主流硬盘是 SATA 接口，下面要备份的硬盘是 dev/sda，它就是块 SATA 盘。

```shell
# dd if=/dev/sda of=/root/sda.img
```
这个命令将 sda 盘备份到指定文件 /root/sda.img 中去，其中用到了如下两个选项：
- if=文件名：指定输入文件名或者设备名，如果省略“if=文件名”，则表示从标准输入读取。
- of=文件名：指定输出文件名或者设备名，如果省略“of=文件名”，则表示写到标准输出。

通过上面的 dd 命令，我们得到了 sda.img 文件，它就是已经备份好了的磁盘映像文件，里面存储着 /dev/sda 整块硬盘的内容。

在某天，假如 /dev/sda 硬盘出现了故障，就可以将曾经备份的 sda.img 复制到另一台电脑上，并将其恢复到指定的 sdb 盘中去。

```shell
# dd if=/root/sda.img of=/dev/sdb
```

如果能把目标硬盘直接连接到现在的电脑上，并让系统识别到这块新硬盘，例如识别成 /dev/sdc，那么可以直接使用 dd 命令将 sda 盘复制到 sdc 中去。这种用法既可以用来整盘备份，也可以用来快速复制系统环境。下面来看具体的命令：

```shell
# dd if=/dev/sda of=/dev/sdc
```

对 dd 来说，所有设备和文件都一视同仁，所谓的“备份”和“恢复”，就是一种内容的复制。


## 分区、内存、软盘备份

在上面的内容中，介绍的都是备份整盘的知识，那如果只是想备份某一个分区的数据，应该如何操作呢？

dd 命令备份整盘和备份分区，在命令形式上并没有区别，来看示例：
```shell
# dd if=/dev/sda2 of=/root/sda_part1.img
```

同理，将内存中的数据整体备份，命令如下：
```shell
# dd if=/dev/mem of=/root/mem.img
```

接下来要介绍的软盘、光盘备份法，权当是追忆过去吧，谨以此内容来怀念我们逝去的青春。
```shell
#备份软盘
# dd if=/dev/fd0 of=/root/fd0.img count=1 bs=1440k

#备份光盘
# dd if=/dev/cdrom of=/root/cdrom.img
```
对于 dd 命令来说，除了 if、of 两个选项之外，还有下面两个重要选项：
* bs=N：设置单次读入或单次输出的数据块（block）的大小为 N 个字节。当然也可以使用 ibs 和 obs 选项来分别设置。
* bibs=N：单次读入的数据块（block）的大小为 N 个字节，默认为 512 字节。
* obs=N：单次输出的数据块（block）的大小为 N 个字节，默认为 512 字节。
* count=N：表示总共要复制 N 个数据块（block）。

## 备份磁盘MBR

MBR，是 Master Boot Record，即硬盘的主引导记录，MBR 一旦损坏，分区表也就被破坏，数据大量丢失，系统就再也无法正常引导！所以，对 MBR 的定期备份是十分必要的。

一块磁盘的第一个扇区的 512 个字节存储就是这块磁盘的 MBR 信息，用 dd 命令备份 MBR：
```shell
# dd if=/dev/sda of=/root/sda_mbr.img count=1 bs=512
```

如果未来遇到分区表损坏的情况，用备份的 MBR 信息写回磁盘，就能恢复。恢复 MBR 写回硬盘命令如下：
```shell
# dd if=/root/sda_mbr.img of=/dev/sda
```


## 使用 /dev/zero 和 /dev/null 来测试磁盘

* /dev/null，也叫空设备，小名“无底洞”。任何写入它的数据都会被无情抛弃。
* /dev/zero，可以产生连续不断的 null 的流（二进制的零流），用于向设备或文件写入 null 数据，一般用它来对设备或文件进行初始化。

我们可以观察下面两个命令的执行时间，来计算出硬盘的读、写性能：

#向磁盘上写一个大文件, 来看写性能
```shell
# dd if=/dev/zero bs=1024 count=1000000 of=/root/tmp.file
```
#从磁盘上读取一个大文件, 来看读性能
```shell
# dd if=/root/tmp.file bs=64k | dd of=/dev/null
```

上面命令生成了一个 1GB 的文件 tmp.file，配合 time 命令，可以看出不同的块大小的写入时间，从而可以测算出块大小为多少时，写入性能最佳。
```shell
# time dd if=/dev/zero bs=1024 count=1000000 of=/root/tmp.file
# time dd if=/dev/zero bs=2048 count=500000 of=/root/tmp.file
# time dd if=/dev/zero bs=4096 count=250000 of=/root/tmp.file
# time dd if=/dev/zero bs=8192 count=125000 of=/root/tmp.file
```

利用 /dev/urandom 进行格式化


## 生成随机字符串

除了 /dev/null 和 /dev/zero 之外，还有一个很重要的文件，即 /dev/urandom，它是“随机数设备”，它的本领就是可以生成理论意义上的随机数。

我们甚至可以使用 /dev/urandom 设备配合 dd 命令 来获取随机字符串。

[root@localhost ~]# dd if=/dev/urandom bs=1 count=15|base64 -w 0
15+0 records in
15+0 records out
15 bytes (15 B) copied, 0.000111993 s, 134 kB/s
wFRAnlkXeBXmWs1MyGEs