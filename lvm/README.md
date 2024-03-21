# LVM

## **背景** 
MBR（Master Boot Record）（主引导记录）和GPT（GUID Partition Table）（GUID意为全局唯一标识符）是在磁盘上存储分区信息的两种不同方式

对于传统的MBR分区方式，有很多的限制： 

1：最多4个主分区（3个主分区+1个扩展分区(扩展分区里面可以放多个逻辑分区)），无法创建大于2TB的分区，使用fdisk分区工具，而GPT分区方式不受这样的限制。  

2：GPT分区方式将不会有这种限制，使用的工具是parted；  

逻辑卷管理(LVM)，是 Logical Volume Manager（逻辑卷管理）的简写，lvm是卷的一种管理方式，并不是分区工具（也可不采用这种LVM管理方式）。

## **LVM管理导图**

   Physical volume (PV物理卷)、Volume group (VG卷组)、Logical volume(LV逻辑卷)，通过图解更容易理解物理磁盘、磁盘分区、物理卷、卷组、逻辑卷之间的关系。

![img](../../linuxbasic/img/lvm.png)

## 硬盘扩容的方式：
- 新添加硬盘扩容（lvm）
- 在原有的硬盘上扩容（lvm）
- 非lvm硬盘扩容


## 硬盘扩容（新添加硬盘）

LVM扩容思维流程：创建一个物理分区 –-> 将这个物理分区转换为物理卷 –-> 把这个物理卷添加到要扩展的卷组中 -–> 然后才能用extend命令扩展此卷组中的逻辑卷。
```
#操作系统
[root@localhost ~]# cat /etc/redhat-release 
CentOS Linux release 7.4.1708 (Core) 
[root@localhost ~]# uname -r
3.10.0-693.el7.x86_64
```

## **硬盘做成逻辑卷**

**操作步骤：**

> 新添加硬盘-->fdisk -l查看硬盘状态-->fdisk创建磁盘分区-->修改分区类型8e-->更新内核分区表-->创建物理分区-->创建卷组-->创建逻辑卷-->格式化逻辑卷-->挂载lv（挂载目录事先存在，不存在创建）-->永久挂载

新添加两块磁盘sdb和sdc

```shell
[root@localhost ~]# fdisk -l
Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0000457f

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200    41943039    19921920   8e  Linux LVM

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk /dev/sdc: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk /dev/mapper/centos-root: 18.2 GB, 18249416704 bytes, 35643392 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk /dev/mapper/centos-swap: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

### 磁盘分区

第一块磁盘，做磁盘分区

```shell
[root@localhost ~]# fdisk /dev/sdb
Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p #创建主分区1
Partition number (1-4, default 1): 
First sector (2048-41943039, default 2048): 
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039): +10G
Partition 1 of type Linux and of size 10 GiB is set

Command (m for help): n
Partition type:
   p   primary (1 primary, 0 extended, 3 free)
   e   extended
Select (default p): p #创建主分区2
Partition number (2-4, default 2): 
First sector (20973568-41943039, default 20973568): 
Using default value 20973568
Last sector, +sectors or +size{K,M,G} (20973568-41943039, default 41943039): 
Using default value 41943039
Partition 2 of type Linux and of size 10 GiB is set

Command (m for help): p #第一块磁盘划分两个主分区

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xfba75d9e

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    20973567    10485760   83  Linux
/dev/sdb2        20973568    41943039    10484736   83  Linux
Command (m for help): t   #做LVM管理，需要修改分区类型为Linux LVM
Partition number (1,2, default 2): 1
Hex code (type L to list all codes): 8e 
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): t
Partition number (1,2, default 2): 2
Hex code (type L to list all codes): 8e
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): p # 打印硬盘分区

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xfba75d9e

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    20973567    10485760   8e  Linux LVM
/dev/sdb2        20973568    41943039    10484736   8e  Linux LVM
Command (m for help): w #保存分区信息
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
```
更新内核分区表

```shell
[root@localhost ~]# partprobe /dev/sdb #更新内核分区表
[root@localhost ~]# ls -l /dev/sdb*
brw-rw----. 1 root disk 8, 16 Oct 13 11:30 /dev/sdb
brw-rw----. 1 root disk 8, 17 Oct 13 11:30 /dev/sdb1
brw-rw----. 1 root disk 8, 18 Oct 13 11:30 /dev/sdb2
[root@localhost ~]#
[root@localhost ~]# mkfs -t xfs /dev/sdb1 /dev/sdb2
```
第二块磁盘，做磁盘分区

创建一个主分区和一个逻辑分区，用来测试扩展分区和逻辑分区是否能够创建PV物理卷并加入VG卷组，实验证明，扩展分区是无法创建PV和加入VG，主分区和逻辑分区可以。

```shell
[root@localhost ~]# fdisk /dev/sdc
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x5d61bb7c.

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p #主分区
Partition number (1-4, default 1): 
First sector (2048-41943039, default 2048): 
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039): +10G
Partition 1 of type Linux and of size 10 GiB is set

Command (m for help): n
Partition type:
   p   primary (1 primary, 0 extended, 3 free)
   e   extended
Select (default p): e #扩展分区，要创建扩展分区之后，才能创建逻辑分区；扩展分区只能创建一个，分区表支持创建最多四分主分区，如果想要创建4个以上的分区，必须创建扩展分区，然后创建逻辑分区
Partition number (2-4, default 2): 
First sector (20973568-41943039, default 20973568): 
Using default value 20973568
Last sector, +sectors or +size{K,M,G} (20973568-41943039, default 41943039): 
Using default value 41943039
Partition 2 of type Extended and of size 10 GiB is set

Command (m for help): n
Partition type:
   p   primary (1 primary, 1 extended, 2 free)
   l   logical (numbered from 5)
Select (default p): l #创建逻辑分区
Adding logical partition 5
First sector (20975616-41943039, default 20975616): 
Using default value 20975616
Last sector, +sectors or +size{K,M,G} (20975616-41943039, default 41943039): 
Using default value 41943039
Partition 5 of type Linux and of size 10 GiB is set

Command (m for help): p

Disk /dev/sdc: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x5d61bb7c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048    20973567    10485760   83  Linux
/dev/sdc2        20973568    41943039    10484736    5  Extended
/dev/sdc5        20975616    41943039    10483712   83  Linux

Command (m for help): t #修改分区类型
Partition number (1,2,5, default 5): 1
Hex code (type L to list all codes): 8e
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): t
Partition number (1,2,5, default 5): 2 
Hex code (type L to list all codes): 8e

You cannot change a partition into an extended one or vice versa.
Delete it first.

Type of partition 2 is unchanged: Extended

Command (m for help): t
Partition number (1,2,5, default 5): 5
Hex code (type L to list all codes): 8e
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): p

Disk /dev/sdc: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x5d61bb7c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048    20973567    10485760   8e  Linux LVM
/dev/sdc2        20973568    41943039    10484736    5  Extended
/dev/sdc5        20975616    41943039    10483712   8e  Linux LVM

Command (m for help): w #保存分区表信息
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
```
重新读取分区表

```shell
[root@localhost ~]# partprobe /dev/sdc
[root@localhost ~]# mkfs -t xfs /dev/sdc1 /dev/sdc2 /dev/sdc5
[root@localhost ~]# ls -l /dev/sdc*
brw-rw----. 1 root disk 8, 32 Oct 13 11:35 /dev/sdc
brw-rw----. 1 root disk 8, 33 Oct 13 11:35 /dev/sdc1
brw-rw----. 1 root disk 8, 34 Oct 13 11:35 /dev/sdc2
brw-rw----. 1 root disk 8, 37 Oct 13 11:35 /dev/sdc5
```
### 创建PV物理卷

```shell
[root@localhost ~]# pvcreate /dev/sdc2 #证明sdc2是扩展分区，无法做成物理卷PV
  Device /dev/sdc2 not found (or ignored by filtering).
[root@localhost ~]# pvcreate /dev/sdb1 #把sdb1做成物理卷PV，也可以用下面的写法，一次性把所有主分区或逻辑分区做成物理卷PV
  Physical volume "/dev/sdb1" successfully created.
[root@localhost ~]# pvcreate /dev/sdb2 /dev/sdc1 /dev/sdc5
  Physical volume "/dev/sdb2" successfully created.
  Physical volume "/dev/sdc1" successfully created.
  Physical volume "/dev/sdc5" successfully created.
[root@localhost ~]# pvdisplay  #查看物理卷详细信息
  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               centos
  PV Size               <19.00 GiB / not usable 3.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              4863
  Free PE               0
  Allocated PE          4863
  PV UUID               610jgI-z9pr-N5H1-R1Qv-jVMh-cMOD-2VKNm5

  "/dev/sdb1" is a new physical volume of "10.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb1
  VG Name               
  PV Size               10.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               l65LfK-FxkO-I8ux-0Lj6-jQB1-ev6d-jl4D8v

  "/dev/sdc1" is a new physical volume of "10.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdc1
  VG Name               
  PV Size               10.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               olFzUh-w2jf-sK32-i4lr-oYHP-zWTf-dKmgYw

  "/dev/sdc5" is a new physical volume of "<10.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdc5
  VG Name               
  PV Size               <10.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               54wYXO-sN3e-Lyc6-2ZQg-YMkH-6khg-TqbKOA

  "/dev/sdb2" is a new physical volume of "<10.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb2
  VG Name               
  PV Size               <10.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               aqkWHa-RIxf-15Y9-mgLw-x82r-thpL-kxzYhc

[root@localhost ~]# pvs #显示所有的物理卷，大小都是10G（分区的时候分配的）
  PV         VG     Fmt  Attr PSize   PFree  
  /dev/sda2  centos lvm2 a--  <19.00g      0 
  /dev/sdb1         lvm2 ---   10.00g  10.00g
  /dev/sdb2         lvm2 ---  <10.00g <10.00g
  /dev/sdc1         lvm2 ---   10.00g  10.00g
  /dev/sdc5         lvm2 ---  <10.00g <10.00g

```
### 创建卷组
```shell
[root@localhost ~]# vgcreate VGtest1 /dev/sdb1 /dev/sdc1 #创建卷组1，卷组的PV物理卷，可以是不同磁盘，即整合了所有磁盘分区做成资源池
  Volume group "VGtest1" successfully created
[root@localhost ~]# vgcreate VGtest2 /dev/sdb2 /dev/sdc5 #创建卷组2
  Volume group "VGtest2" successfully created
[root@localhost ~]# vgs #显示所有卷组信息
  VG      #PV #LV #SN Attr   VSize   VFree 
  VGtest1   2   0   0 wz--n-  19.99g 19.99g
  VGtest2   2   0   0 wz--n-  19.99g 19.99g
  centos    1   2   0 wz--n- <19.00g     0 
[root@localhost ~]# vgdisplay #查看所有卷组的详细信息
  --- Volume group ---
  VG Name               centos
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <19.00 GiB
  PE Size               4.00 MiB
  Total PE              4863
  Alloc PE / Size       4863 / <19.00 GiB
  Free  PE / Size       0 / 0   
  VG UUID               FjdwU1-IYgt-Q6r2-uGm7-q1de-g0yh-EsGm64

  --- Volume group ---
  VG Name               VGtest1
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               19.99 GiB
  PE Size               4.00 MiB
  Total PE              5118
  Alloc PE / Size       0 / 0   
  Free  PE / Size       5118 / 19.99 GiB
  VG UUID               pk62Bc-lRQW-iXim-VUng-PrIk-s9WR-10uctH

  --- Volume group ---
  VG Name               VGtest2
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               19.99 GiB
  PE Size               4.00 MiB
  Total PE              5118
  Alloc PE / Size       0 / 0   
  Free  PE / Size       5118 / 19.99 GiB
  VG UUID               XsUyyE-1OSa-Xbno-L0W3-cL3E-XmeH-qb3QWW
```
### 创建逻辑卷并添加卷组

```shell
# -n 表示创建逻辑卷名，-L 表示分配逻辑卷的空间大小，VGtest1表示在卷组VGtest1上创建逻辑卷LVtest1
[root@localhost ~]# lvcreate -n LVtest1 -L 1G VGtest1 
  Logical volume "LVtest1" created.
[root@localhost ~]# lvcreate -n LVtest2 -L 1G VGtest2
  Logical volume "LVtest2" created.
[root@localhost ~]# lvs #显示逻辑卷的信息（大小为1G，上面分配的）
  LV      VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  LVtest1 VGtest1 -wi-a-----   1.00g                                                    
  LVtest2 VGtest2 -wi-a-----   1.00g                                                    
  root    centos  -wi-ao---- <17.00g                                                    
  swap    centos  -wi-ao----   2.00g                                                    
[root@localhost ~]# lvdisplay #显示逻辑卷的详细信息
  --- Logical volume ---
  LV Path                /dev/centos/swap
  LV Name                swap
  VG Name                centos
  LV UUID                gS0ted-R1jU-NKWR-rpFb-quUd-Yu7w-c0VfGz
  LV Write Access        read/write
  LV Creation host, time localhost, 2018-09-14 09:38:10 -0400
  LV Status              available
  # open                 2
  LV Size                2.00 GiB
  Current LE             512
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:1

  --- Logical volume ---
  LV Path                /dev/centos/root
  LV Name                root
  VG Name                centos
  LV UUID                LTcnK5-ufCZ-5Cwx-Lpfi-Frgo-NMBm-OEE73C
  LV Write Access        read/write
  LV Creation host, time localhost, 2018-09-14 09:38:10 -0400
  LV Status              available
  # open                 1
  LV Size                <17.00 GiB
  Current LE             4351
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:0

  --- Logical volume ---
  LV Path                /dev/VGtest1/LVtest1
  LV Name                LVtest1
  VG Name                VGtest1
  LV UUID                PMv1Zv-WtJy-13v4-1GBc-5WaB-mcpk-f7dN22
  LV Write Access        read/write
  LV Creation host, time localhost.localdomain, 2018-10-13 11:48:28 -0400
  LV Status              available
  # open                 0
  LV Size                1.00 GiB
  Current LE             256
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:2

  --- Logical volume ---
  LV Path                /dev/VGtest2/LVtest2
  LV Name                LVtest2
  VG Name                VGtest2
  LV UUID                HCk2OB-3iVy-Ryma-rKeH-kIie-NYKr-ZVkiIf
  LV Write Access        read/write
  LV Creation host, time localhost.localdomain, 2018-10-13 11:48:47 -0400
  LV Status              available
  # open                 0
  LV Size                1.00 GiB
  Current LE             256
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:3
会创建对应的目录和文件
[root@localhost ~]# ls -l /dev/VGtest1/LVtest1 
lrwxrwxrwx. 1 root root 7 Oct 13 11:48 /dev/VGtest1/LVtest1 -> ../dm-2
[root@localhost ~]# ls -l /dev/d
disk/   dm-0    dm-1    dm-2    dm-3    dmmidi  dri/    
[root@localhost ~]# ls -l /dev/dm-2
brw-rw----. 1 root disk 253, 2 Oct 13 11:48 /dev/dm-2
```

### 格式化LV逻辑卷
```shell
[root@localhost ~]# mke2fs -t ext4 /dev/VGtest1/LVtest1 #物理卷需要格式化之后才能使用，格式化为ext4格式
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
65536 inodes, 262144 blocks
13107 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268435456
8 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

[root@localhost ~]# mkfs.ext4 /dev/VGtest2/LVtest2 #也可以使用这种方式格式化
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
65536 inodes, 262144 blocks
13107 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268435456
8 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done
```
### 挂载LV逻辑卷
```shell
[root@localhost ~]# mkdir /appdata
[root@localhost ~]# mkdir /applog
[root@localhost ~]# mount /dev/VGtest1/LVtest1 /appdata #把LV逻辑卷挂载到实际的目录
[root@localhost ~]# mount /dev/VGtest2/LVtest2 /applog
[root@localhost ~]# df -h
Filesystem                   Size  Used Avail Use% Mounted on
/dev/mapper/centos-root       17G  1.2G   16G   7% /
devtmpfs                     482M     0  482M   0% /dev
tmpfs                        493M     0  493M   0% /dev/shm
tmpfs                        493M  6.8M  486M   2% /run
tmpfs                        493M     0  493M   0% /sys/fs/cgroup
/dev/sda1                   1014M  125M  890M  13% /boot
tmpfs                         99M     0   99M   0% /run/user/0
/dev/mapper/VGtest1-LVtest1  976M  2.6M  907M   1% /appdata
/dev/mapper/VGtest2-LVtest2  976M  2.6M  907M   1% /applog
[root@localhost ~]# mount |grep VGtest
/dev/mapper/VGtest1-LVtest1 on /appdata type ext4 (rw,relatime,seclabel,data=ordered)
/dev/mapper/VGtest2-LVtest2 on /applog type ext4 (rw,relatime,seclabel,data=ordered)
```

### 永久挂载LV逻辑卷

```shell
[root@localhost ~]# vim /etc/fstab 
#
# /etc/fstab
# Created by anaconda on Fri Sep 14 09:38:12 2018
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/centos-root /                       xfs     defaults        0 0
UUID=944557a0-3f7c-434d-8202-c960db70b860 /boot                   xfs     defaults        0 0
/dev/mapper/centos-swap swap                    swap    defaults        0 0
# 永久挂载lvm
/dev/VGtest1/LVtest1 /appdata                   ext4    defaults        0 0
/dev/VGtest2/LVtest2 /applog                    ext4    defaults        0 0
                                                            
[root@localhost ~]# mount -a  #重新加载/etc/fstab文件
```

## **卷组扩容**

**vg扩容步骤：**

新建一个PV物理卷，然后加入VG即可（fdisk创建分区-->修改分区类型Linux LVM-->向内核注册新分区-->创建物理卷-->把物理卷加入需要扩容的卷组）。

发现卷组pv空间不够，我们需要扩大卷组空间，现在系统上新增了一块20G的硬盘/dev/sdd。

```shell
[root@localhost ~]# fdisk /dev/sdd #把新添加的磁盘进行分区
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0xc29c0ac3.

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p #主分区
Partition number (1-4, default 1): 
First sector (2048-41943039, default 2048): 
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039): +5G
Partition 1 of type Linux and of size 5 GiB is set

Command (m for help): t #修改分区类型
Selected partition 1
Hex code (type L to list all codes): 8e
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): p

Disk /dev/sdd: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xc29c0ac3

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1            2048    10487807     5242880   8e  Linux LVM
Command (m for help): w #保存分区信息
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
[root@localhost ~]# partprobe /dev/sdd #更新内核分区表
[root@localhost ~]# pvcreate /dev/sdd1 #创建物理卷PV
  Physical volume "/dev/sdd1" successfully created.
[root@localhost ~]# pvs
  PV         VG      Fmt  Attr PSize   PFree  
  /dev/sda2  centos  lvm2 a--  <19.00g      0 
  /dev/sdb1  VGtest1 lvm2 a--  <10.00g  <9.00g
  /dev/sdb2  VGtest2 lvm2 a--  <10.00g  <9.00g
  /dev/sdc1  VGtest1 lvm2 a--  <10.00g <10.00g
  /dev/sdc5  VGtest2 lvm2 a--  <10.00g <10.00g
  /dev/sdd1          lvm2 ---    5.00g   5.00g
[root@localhost ~]# vgextend VGtest1 /dev/sdd1 #扩展VG卷组容量，把物理卷加入卷组
  Volume group "VGtest1" successfully extended
[root@localhost ~]# vgs
  VG      #PV #LV #SN Attr   VSize   VFree  
  VGtest1   3   1   0 wz--n- <24.99g <23.99g
  VGtest2   2   1   0 wz--n-  19.99g  18.99g
  centos    1   2   0 wz--n- <19.00g      0 
[root@localhost ~]# pvs
  PV         VG      Fmt  Attr PSize   PFree  
  /dev/sda2  centos  lvm2 a--  <19.00g      0 
  /dev/sdb1  VGtest1 lvm2 a--  <10.00g  <9.00g
  /dev/sdb2  VGtest2 lvm2 a--  <10.00g  <9.00g
  /dev/sdc1  VGtest1 lvm2 a--  <10.00g <10.00g
  /dev/sdc5  VGtest2 lvm2 a--  <10.00g <10.00g
  /dev/sdd1  VGtest1 lvm2 a--   <5.00g  <5.00g
```



## **逻辑卷扩容**

**操作步骤：**

lv扩容-->查看lv容量-->增加lv容量-->确认对lv增加容量-->查看容量是否增加

在线将/dev/VGtest/LVtest1 扩展到3G，并且要求数据可以正常访问
```shell
#在挂载的逻辑卷里添加数据，用来测试在逻辑卷扩容是否会破坏原有数据
[root@localhost ~]# echo "this is a test for LVM" >/appdata/test
[root@localhost ~]# cat /appdata/test 
this is a test for LVM
[root@localhost ~]# lvs
  LV      VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  LVtest1 VGtest1 -wi-ao----   1.00g                                                    
  LVtest2 VGtest2 -wi-ao----   1.00g                                                    
  root    centos  -wi-ao---- <17.00g                                                    
  swap    centos  -wi-ao----   2.00g                                                    
```
扩容逻辑卷LVtest1，增加2G空间容量（从对应的卷组中划分空间容量）
```shell
[root@localhost ~]# lvextend -L +2G /dev/VGtest1/LVtest1  
  Size of logical volume VGtest1/LVtest1 changed from 1.00 GiB (256 extents) to 3.00 GiB (768 extents).
  Logical volume VGtest1/LVtest1 successfully resized.
[root@localhost ~]# lvs
  LV      VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  LVtest1 VGtest1 -wi-ao----   3.00g   #已经增加2G空间容量                                                 
  LVtest2 VGtest2 -wi-ao----   1.00g                                                    
  root    centos  -wi-ao---- <17.00g                                                    
  swap    centos  -wi-ao----   2.00g                                                    
```
注意：不同的分区格式，使用的命令不同。

基本分为2种：resize2fs或xfs_growfs 对挂载目录在线扩容，使用方法如下：
```shell
ext2/ext3/ext4文件系统的调整命令是resize2fs（增大和减小都支持）
		lvextend -L 120G /dev/mapper/centos-home     //增大至120G
		lvextend -L +20G /dev/mapper/centos-home     //增加20G
		lvreduce -L 50G /dev/mapper/centos-home      //减小至50G
		lvreduce -L -8G /dev/mapper/centos-home      //减小8G
		resize2fs /dev/mapper/centos-home            //执行调整

xfs文件系统的调整命令是xfs_growfs（只支持增大）
		lvextend -L 120G /dev/mapper/centos-home    //增大至120G
		lvextend -L +20G /dev/mapper/centos-home    //增加20G
		xfs_growfs /dev/mapper/centos-home          //执行调整
```
使用resize2fs命令来进行确认增加容量，前面的步骤只是初步分配，还不能实际使用，需要此步骤来确定实际分配使用
```shell
[root@localhost ~]# resize2fs /dev/VGtest1/LVtest1 
resize2fs 1.42.9 (28-Dec-2013)
Filesystem at /dev/VGtest1/LVtest1 is mounted on /appdata; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 1
The filesystem on /dev/VGtest1/LVtest1 is now 786432 blocks long.
```
注意：xfs系统确认实际使用的命令

```shell
xfs_growfs /dev/VGtest1/LVtest1
```

查看挂载目录的空间容量大小
```shell
[root@localhost ~]# df -h| grep VGtest
/dev/mapper/VGtest2-LVtest2  976M  2.6M  907M   1% /applog
/dev/mapper/VGtest1-LVtest1  3.0G  3.1M  2.8G   1% /appdata

#查看数据依然正常
[root@localhost ~]# cat /appdata/test 
this is a test for LVM
```

## **缩减逻辑卷**

**操作步骤：**

LV缩容-->查看lv空间-->取消逻辑卷挂载-->检查逻辑卷-->确定缩减逻辑卷到指定的空间容量-->再进行逻辑卷LV容量缩减-->重新挂载逻辑卷-->查看逻辑卷的大小

**注意事项：**

 	1. 查看逻辑卷使用空间状况
 	2. 不能在线缩减，得先卸载切记
 	3. 确保缩减后的空间大小依然能存原有的所有数据
 	4. 在缩减之前应该先强行检查文件，以确保文件系统处于一至性状态

**示例:**

```shell
[root@localhost ~]# e2fsck -f /dev/VGtest1/LVtest1 #处于挂载状态的LV逻辑卷无法强制检查
e2fsck 1.42.9 (28-Dec-2013)
/dev/VGtest1/LVtest1 is mounted.
e2fsck: Cannot continue, aborting.
[root@localhost ~]# umount /appdata #取消逻辑卷挂载
[root@localhost ~]# e2fsck -f /dev/VGtest1/LVtest1 #检查逻辑卷
e2fsck 1.42.9 (28-Dec-2013)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/VGtest1/LVtest1: 12/196608 files (0.0% non-contiguous), 21309/786432 blocks
[root@localhost ~]# resize2fs /dev/VGtest1/LVtest1 1G #首先需要确定缩减逻辑卷到多大空间容量，-1G表示缩减1G大小，1G表示缩减至1G（原来空间是3G）
resize2fs 1.42.9 (28-Dec-2013)
Resizing the filesystem on /dev/VGtest1/LVtest1 to 262144 (4k) blocks.
The filesystem on /dev/VGtest1/LVtest1 is now 262144 blocks long.

[root@localhost ~]# lvreduce -L 1G /dev/VGtest1/LVtest1 #再进行逻辑卷LV容量缩减
  WARNING: Reducing active logical volume to 1.00 GiB.
  THIS MAY DESTROY YOUR DATA (filesystem etc.)
Do you really want to reduce VGtest1/LVtest1? [y/n]: y
  Size of logical volume VGtest1/LVtest1 changed from 3.00 GiB (768 extents) to 1.00 GiB (256 extents).
  Logical volume VGtest1/LVtest1 successfully resized.
[root@localhost ~]# mount /dev/VGtest1/LVtest1 /appdata #重新挂载逻辑卷
[root@localhost ~]# lvs
  LV      VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  LVtest1 VGtest1 -wi-ao----   1.00g  #lvtest1卷是1g                                                   
  LVtest2 VGtest2 -wi-ao---- 500.00m                                                    
  root    centos  -wi-ao---- <17.00g                                                    
  swap    centos  -wi-ao----   2.00g                                                    
[root@localhost ~]# df -h|grep VGtest
/dev/mapper/VGtest2-LVtest2  460M  1.6M  424M   1% /applog
/dev/mapper/VGtest1-LVtest1  976M  2.6M  914M   1% /appdata
[root@localhost ~]# cat /appdata/test 
this is a test for LVM
```

其实卷组的空间缩小就是把已经加入卷组的物理卷删除，先来查看卷组中目前有的物理卷，如下：

![TSET](http://www.ilanni.com/wp-content/uploads/2014/08/lip_image011_thumb.png)

通过上图，我们可以很明显的看到目前系统中两个物理卷/dev/sda5/、/dev/sda6，而且这两个物理卷已经都加入到卷组vg1中。

这个我们是通过图中标记出来的黄色部分知道的，同时我们也知道这两个物理卷的大小都是1000M，卷组vg1的大小为2000M。

我们现在要把物理卷/dev/sda6删除，这个就相当于缩小了卷组vg1的大小。我们可以通过vgreduce命令来实现，如下：

```
[root@localhost ~]# vgreduce vg1 /dev/sda6
[root@localhost ~]# vgs
[root@localhost ~]# vgdisplay
[root@localhost ~]# pvs
```

通过上图，我们可以很明显的看到卷组vg1现在的大小已经是1000M。而且物理卷/dev/sda6目前不属于任何一个卷组。

**注意：卷组缩小空间，一定要要卷组的空闲空间大小大于删除的物理卷的空间大小。**


## 硬盘扩容(在原有硬盘上扩容)



一、环境
虚拟机软件：VMware 14
系统版本：CentOS 7

二、扩容步骤

1、VM上修改磁盘信息
将虚拟机关机，然后点击VM顶部菜单栏中的显示或隐藏控制台视图按钮来显示已建立的虚拟机的配置信息

![harddisk1](https://www.linuxidc.com/upload/2019_04/1904271736910816.png)

然后左边菜单栏点击硬盘，在弹出的对话框选中硬盘，并点击扩展按钮，然后在弹出框中的最大磁盘大小修改未所需要的磁盘大小，比如我现在需要扩容30G，原本的磁盘大小是20G，所以我这里将原本的20G修改成50G，然后点击扩展

![harddisk2](https://www.linuxidc.com/upload/2019_04/190427173691084.png)

然后开启虚拟机，对磁盘进行进一步的配置

2、在系统中挂载磁盘
开启虚拟机并登录后，使用命令查看当磁盘状态
```
# df -h
```
![harddisk2](https://www.linuxidc.com/upload/2019_04/190427173691088.png)

可看到当前还是原本的20G，并未扩容
首先先通过命令查看到新磁盘的分区
```
# fdisk -l
```
![harddisk2](https://www.linuxidc.com/upload/2019_04/1904271736910813.png)

然后对新加的磁盘进行分区操作：
```
# fdisk /dev/sda
```
![harddisk3](https://www.linuxidc.com/upload/2019_04/190427173691083.png)

![harddisk4](https://www.linuxidc.com/upload/2019_04/190427173691082.png)

期间，如果需要将分区类型的Linux修改为Linux LVM的话需要在新增了分区之后，选择t，然后选择8e，之后可以将新的分区修改为linux LVM
之后我们可以再次用以下命令查看到磁盘当前情况
```
# fdisk -l
```
![harddisk4](https://www.linuxidc.com/upload/2019_04/190427173691081.png)

重启虚拟机格式化新建分区
```
# reboot
```
然后将新添加的分区添加到已有的组实现扩容
首先查看卷组名
```
# vgdisplay
```

初始化刚刚的分区
```
# pvcreate /dev/sda3
```

将初始化过的分区加入到虚拟卷组名
```
# vgextend 虚拟卷组名 新增的分区
# vgextend centos /dev/sda3
```

再次查看卷组情况
```
# vgdisplay
```
这里可以看到，有30G的空间是空闲的
查看当前磁盘情况并记下需要扩展的文件系统名，我这里因为要扩展根目录，所以我记下的是 /dev/mapper/centos-root
```
# df -h
```

扩容已有的卷组容量（这里有个细节，就是不能全扩展满，比如空闲空间是30G，然后这里的话30G不能全扩展上，这里我扩展的是29G）
```
# lvextend -L +需要扩展的容量 需要扩展的文件系统名 
# lvextend -L +29G /dev/mapper/centos-root
```

然后我们用命令查看当前卷组
```
# pvdisplay
```

这里可以看到，卷组已经扩容了
以上只是卷的扩容，然后我们需要将文件系统扩容
```
# resize2fs 文件系统名
# resize2fs /dev/mapper/centos-root
```



解决办法是，首先查看文件系统的格式
```
# cat /etc/fstab | grep centos-root
```

这里可以看到，文件系统是xfs，所以需要xfs的命令来扩展磁盘空间
```
# xfs_growfs 文件系统名
# xfs_growfs /dev/mapper/centos-root
```

之后我们再次用命令查看磁盘状态
```
# df -h
```
可以看到，现在已经扩容成功了！



## **非LVM根分区扩容**

**Tip：**

首先，这种分区格式是不被推荐的。因为它只针对，具体的某个目录做的扩容，局限性比较大；而lvm扩容，在整个操作系统的根路径做的扩容，所有的目录都可以使用。

操作步骤：

1.查看现有的分区大小

```shell
[root@localhost ~]# df -Th
Filesystem               Size  Used Avail Use% Mounted on
devtmpfs                 9.6G     0  9.6G   0% /dev
tmpfs                    9.6G     0  9.6G   0% /dev/shm
tmpfs                    9.6G  514M  9.1G   6% /run
tmpfs                    9.6G     0  9.6G   0% /sys/fs/cgroup
/dev/sda3                 17G   1.3G   16G  8% /
/dev/sda1               1014M  260M  755M  26% /boot
tmpfs                    2.0G     0  2.0G   0% /run/user/0
```

2.关机给虚拟机增加磁盘大小10G, 在原来有的硬盘上，讲容量增大10G

3.查看添加磁盘扩容后状态

```shell
[root@localhost ~]#lsblk  
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   30G  0 disk 
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   2G  0 part [SWAP]
└─sda3            8:3    0   17G  0 part /
sr0              11:0    1  942M  0 rom  
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on 
/dev/sda3  17G 1.3G   16G  8%  /
tmpfs      477M 477M  0    0%  /dev 
tmpfs      488M 0    488M  0%  /dev/shm 
tmpfs      488M 7.7M 480M  2%  /run 
tmpfs      488M 488M  0     0% /sys/fs/cgroup
/dev/sda1  1014M 130M 885M 13% /boot 
tmpfs      98M  98M   0    0%  /run/user/0
[root@localhost ~]#
```

4.进行分区扩展磁盘，**记住根分区起始位置和结束位置**

> fdisk /dev/sda

5.删除根分区，切记不要保存退出

6.创建分区，分区起始位置是删除分区的开头,结束为默认即可,保存退出

7.保存退出并刷新分区

> partprobe /dev/sda

8.刷新根分区并查看状态

> xfs_growfs /dev/sda3 (这里先看自己的文件系统是xfs，还是ext4...)

使用 resize2fs或xfs_growfs 对挂载目录在线扩容 ：

- resize2fs 针对文件系统ext2 ext3 ext4 （我在本地用ubuntu18是ext4，我用的是resize2fs /dev/sda3）
- xfs_growfs 针对文件系统xfs

9.查看分区状态

> dh -TH 





**问题总结:**

1. **Vmware Esxi 支持硬盘热加载，不需要重启虚拟机，在虚拟机上就是可以见的。如果添加硬盘方式是在原来的硬盘基础上扩大容量，需要重新启动虚拟机。否则，硬盘增加的容量不显示。**



2. **在用Centos 7 重启系统出现如下提示:**

> welcome to emergency mode！：after logging in ，type “journalctl -xb” to view system logs，“systemctl reboot” to reboot ，“systemctl default” to try again to boot into default mode。 give root password for maintenance （？？ Control-D？？？）

按照页面操作：Control-D 、systemctl reboot 命令户依然如此；考虑到当时新增硬盘的原因，移除硬盘；重启系统依然出现如此界面；

经过排查是因为我之前在/etc/fstab写入了sdb1、swap的挂载，但开机有没有挂载成功导致的。处理办法：自动挂载的那个fstab文件有问题，你在这个界面直接输入密码，然后把你增加的删除，重启就OK

```sh
#root密码登入系统；
vi /etc/fstab
#注释/删除新增的内容
reboot
```

报这个错误多数情况下是因为/etc/fstab文件的错误。注意一下是不是加载了外部硬盘、存储器或者是网络共享空间，在重启时没有加载上导致的。



3. **Centos7 虚拟机环境下断电后进入dracut模式**

Vmware虚拟机环境下的Centos7，系统掉电后，无法重启，直接进入的dracut。因匆忙之中，没有来得及抓图。但记得系统提示：

```sh
Warning: /dev/centos/root does not exist
Warning: /dev/centos/swap does not exist
Warning: /dev/mapper/centos-root does not exist
```

然后就是提示输入journalctl查看日志。日志中主要内容也是提示以上三问题。
操作步骤:

```sh
dracut# lvm vgscan
dracut# lvm vgchange -ay 
dracut# exit
```

系统引导成功！进入登录界面。

4. **遇到硬盘无法挂载到linux系统，先格式化硬盘，可能会报错，需要加-f参数，强制格式化，之后才能挂载。**
```
mkfs.xfs /dev/sdb1 -f
mount /dev/sdb1 /mnt/
```
