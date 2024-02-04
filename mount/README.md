# Linux系统利用mount命令用来挂载文件系统

mount 命令用来挂载文件系统。其基本命令格式为：
>mount -t type [-o options] device dir
- device：指定要挂载的设备，比如磁盘、光驱等。
- dir：指定把文件系统挂载到哪个目录。
- type：指定挂载的文件系统类型，一般不用指定，mount 命令能够自行判断。
- options：指定挂载参数，比如 ro 表示以只读方式挂载文件系统。

## Help

可以通过 man page 和 -h 选项来获得最直接的帮助文档：

> $ man mount
> 
> $ mount -h

### 文件系统的类型

虽然多数情况下我们不用指定 -t 参数显式地说明文件系统的类型，但文件系统的类型对 mount 命令来说确实是非常重要的。原因是假如你要挂载一个当前系统不支持的文件系统，它是没办法工作的。

当前系统支持的文件系统类型是由内核来决定的，比如 ext2、ext3、ext4、sysfs 和 proc 等常见的文件系统默认都是被支持的。我们可以通过查看 /proc/filesystems 文件来观察当前系统具体都支持哪些文件系统：

```shell
$ cat /proc/filesystems
nodev   sysfs
nodev   rootfs
nodev   ramfs
nodev   bdev
nodev   proc
nodev   cgroup
nodev   cpuset
nodev   tmpfs
nodev   devtmpfs
nodev   debugfs
nodev   securityfs
nodev   sockfs
nodev   dax
nodev   bpf
nodev   pipefs
nodev   configfs
nodev   devpts
nodev   hugetlbfs
nodev   autofs
nodev   pstore
nodev   mqueue
        xfs
nodev   overlay
```

第一列说明文件系统是否需要挂载在一个块设备上， nodev 表明后面的文件系统不需要挂接在块设备上。 

第二列是内核支持的文件系统。

## 输出的文件系统信息

通过 mount 命令查看已挂载的文件系统，会输出丰富的信息，如下所示：

```shell
[root@Docker ~]# mount
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
......
```
解释输出格式和含义。输出的每行代表挂载的一个文件系统，其格式为：
> fs_spec on fs_file type fs_vfstype (fs_mntopts)
* fs_spec：挂载的块设备或远程文件系统
* fs_file：文件系统的挂载点
* fs_vfstype：文件系统的类型
* fs_mntopts：与文件系统相关的更多选项，不同的文件系统其选项也不太一样

上述，第一行含义：

> 挂载的设备为 sysfs，挂载点为 /sys，文件系统的类型为 sysfs。括号中的 rw 表示以可读写的方式挂载文件系统，noexec 表示不能在该文件系统上直接运行程序。

与 mount 命令相关的文件

```shell
/etc/fstab
/etc/mtab
/proc/mounts
```

mount -a 会将 /etc/fstab 中定义的所有挂载点都挂上(一般是在系统启动时的脚本中调用，自己最好别用！)。

mount 和 umount 命令会在 /etc/mtab 文件中维护当前挂载的文件系统的列表，这个文件在目前的系统中还是被支持的。但是更好的方式是用链接文件 /proc/mounts 代替 /etc/mtab 文件。这是因为在用户空间中维护的普通文件 /etc/mtab 很难稳定可靠的与 namespaces、containers 等 Linux 的高级功能协作。在 ubuntu 16.04 上， /etc/mtab 和  /proc/mounts 一样，都是指向 /proc/self/mounts 的链接文件。

下面我们介绍一些 mount 命令的常见用例。


## 输出系统挂载的所有文件系统

如果执行 mount 命令时不加任何参数，就会输出系统挂载的所有文件系统：

```shell
$ mount
```
## 输出指定类型的文件系统

通过 -t 参数可以只输出指定类型的文件系统，比如下面的命令只会输出 tmpfs 类型的文件系统：

```shell
$ mount -t tmpfs
```

## 格式化并挂载磁盘

对于一个磁盘分区，我们可以使用 mkfs 命令把磁盘分区格式化为指定的文件系统，比如 ext4：

```shell
$ sudo mkfs -t ext4 /dev/sdb1
```

然后把该分区挂载到 /mnt 目录：
```shell
$ sudo mount /dev/sdb1 /mnt
```

## 挂载光驱

现在偶尔还还需要使用一下光驱，挂载光驱的命令如下：

```shell
$ sudo mount /dev/cdrom /mnt
```
该命令把设备 /dev/cdrom 挂载在 /mnt 目录中，然后我们就可以在 /mnt 目录下访问光驱中的内容。在哪种场景使用呢？比如：我想定制自己的镜像，可以通过这种方式实现。

## 以只读的方式挂载

可以把文件系统挂载为只读模式，从而保护数据。比如将 /dev/sdb1 用只读模式挂在 /mnt 目录：

```shell
$ sudo mount -o ro /dev/sdb1 /mnt
```

这样 /mnt 目录下的文件都是只读的。

## 把只读的挂载重新挂载为读写模式

当系统出现故障进入单用户模式时，通常 / 根目录会以只读方式挂载，这时如果想要修改文件，会发现所有文件都是只读状态，无法修改。好在 Linux 下的 mount 命令支持一个remount 选项，只需要执行如下命令：

```shell
$ mount / -o rw,remount
```

就可以将根分区重新挂载为读写状态。

除了根目录，重新挂载其它挂载点也是一样的，比如我们把前面挂载的 sdb1 分区重新挂载为读写模式：

```shell
$ sudo mount /mnt -o rw,remount
```

## Linux挂载 windows 共享文件

局域网中一般都是 windows 系统和 Linux 系统共存的，如何从 Linux 系统中访问 windows 的文件呢？其实这也很简单，在 windows 上通过cifs协议，共享文件时指定一个本机用户，然后在 mount 命令中指定这个用户及其密码就可以了：

```shell
$ sudo mount -t cifs -o username=nick,password=Test123456 //10.32.2.30/doc /mnt
```
注意：
- -t cifs 是可以省略的，mount 命令能够自动识别。
- `//WINDOWS_MACHINE_IP_ADDRESS/SHARE_DIR`，一定要使用 IP 代替 windows 主机的名称，否则，用主机名无法连接成功。
- username和password分别是连接windows的用户名和密码
- /mnt 是linux的挂载点

Reference

[How to Mount Remote Windows Share on Linux](https://tecadmin.net/mount-remote-windows-share-on-linux/)

## Linux挂载windows nfs文件夹

NFS允许一个系统在网络上与他人共享目录和文件。通过使用NFS，用户和程序可以像访问本地文件一样访问远端系统上的文件。

```shell
mount -t nfs 10.32.2.30:/doc/nfs /mnt
```

## 挂载虚拟文件系统

proc、tmpfs、sysfs、devpts 等都是 Linux 内核映射到用户空间的虚拟文件系统，它们不和具体的物理设备关联，但它们具有普通文件系统的特征，应用层程序可以像访问普通文件系统一样来访问他们。
比如内核的 proc 文件系统默认被挂载到了 /proc 目录，当然我们也可以再把它挂载到其它的目录，比如 /mnt 目录下：

```shell
$ sudo mount -t proc none /mnt
```

由于 proc 是内核虚拟的一个文件系统，并没有对应的设备，所以这里的 -t 参数不能省略。由于没有对应的源设备，这里的 none 可以是任意字符串，取个有意义的名字就可以了，因为用 mount 命令查看挂载点信息时第一列显示的就是这个字符串。

在 Linux 上我们还可以通过 tmpfs 文件系统轻松地构建出内存磁盘来。比如在内存中创建一个 512M 的 tmpfs 文件系统，并挂载到 /mnt 下，这样所有写到 /mnt 目录下的文件都存储在内存中，速度非常快，不过要注意，由于数据存储在内存中，所以断电后数据会丢失掉：

```shell
$ sudo mount -t tmpfs -o size=512m tmpfs /mnt
```

## 挂载 loop 设备

在 Linux中，硬盘、光盘、软盘等都是常见的块设备，他们在 Linux 下的目录一般是 /dev/sda1、/dev/cdrom、 /dev/fd0 这样的。而 loop device 是虚拟的块设备，主要目的是让用户可以像访问上述块设备那样访问一个文件。 loop device 设备的路径一般是 /dev/loop0、dev/loop1 等，具体的个数跟内核的配置有关。

## 挂载 ISO 文件

需要用到 loop device 的最常见场景是挂载一个 ISO 文件。比如将 tmpcentos7.iso 这个光盘镜像文件使用 loop 模式挂载到 /opt 下。
```shell
$ dd if=/dev/cdrom of=/root/tmpcentos7.iso
```

然后把这个 ISO 文件挂载到 /opt 目录下：

```shell
$ mount tmpcentos7.iso /opt/
mount: /dev/loop0 is write-protected, mounting read-only
```

挂载 test.iso 文件使用了虚拟设备 /dev/loop0，并且是只读的模式。

## 虚拟硬盘

loop 设备另一种常见用法是虚拟一块硬盘，比如我想用一个 btrfs 文件系统，但系统中目前的所有分区都已经用了，里面都是有用的数据，不想格式化，这时虚拟硬盘就有用武之地了。

我们先通过 dd 命令创建一个 512M 的文件：

```shell
$ dd if=/dev/zero bs=1M count=512 of=./vdisk.img
```

然后在这个文件里面创建 btrfs 文件系统：
```shell
$ sudo apt install btrfs-progs
$ mkfs.btrfs vdisk.img
```

最后把它挂载到 /mnt ：

```shell
$ sudo mount vdisk.img /mnt
```

## 把多个设备挂载到同一个目录

在 Linux 中可以把多个设备挂载到同一个目录。默认后面挂载的内容会让前面挂载的内容隐藏掉，只有 unmount 了后面挂载的内容，才会显示原来的内容。

## 挂载一个设备到多个目录

我们也可以把同一个设备挂载到不同的目录，这样在不同的目录中看到的是同样的内容。还可以在不同的目录中控制挂载的权限，比如以只读方式挂载：

```shell
$ sudo mount -o ro vdisk.img ./testdir
```

这样从不同的目录访问相同的文件系统时就具有了不同的访问权限。

# 总结
