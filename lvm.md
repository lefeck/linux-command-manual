
常用命令
查看磁盘
#小于2T
fdisk -l
#大于2T
parted -l

查看卷
#查看物理卷
pvdisplay
#查看卷组
vgdisplay
#查看逻辑卷
lvdisplay

普通挂载
创建分区
fdisk /dev/sdb
n，一直默认，直到：Command (m for help)输入：w

格式化分区
mkfs.xfs /dev/sdb1
#创建挂载文件夹
mkdir /data
#临时挂载到指定文件夹
mount /dev/sdb1 /data
#查看是否挂载成功
df -h
#自动挂载
vim /etc/fstab
#追加内容如下
/dev/sdb1 /data xfs defaults 0 0



# LVM小于2T磁盘fdisk分区

## LVM小于2T磁盘fdisk方式挂载

创建分区

```
fdisk /dev/sdb
n，一直默认，直到：Command (m for help)输入：w
```

创建物理卷PV

```
pvcreate /dev/sdb1
```

创建卷组VG

```
vgcreate myvg1 /dev/sdb1
```

创建逻辑卷LV，将vg所有空间分配给lv

```
lvcreate -l +100%VG -n mylv1 myvg1
```

格式化逻辑卷

```
mkfs.xfs /dev/myvg1/mylv1
```

创建挂载文件夹

```
mkdir /data
```

临时挂载

```
mount /dev/myvg1/mylv1 /data
```

查看是否挂载成功

```
df -h
```

开机自动挂载

```
vim /etc/fstab #追加内容如下
/dev/myvg1/mylv1 /data xfs defaults 0 0
```



## LVM小于2T磁盘fdisk方式扩容

#查看是否有新磁盘

```sh
fdisk -l
```

对新磁盘sdc进行操作

```sh
fdisk /dev/sdc
# 输入n，一直默认，直到：Command (m for help)输入：t，8e，w
```

创建物理卷（PV）

```
pvcreate /dev/sdc1
```

将物理卷（PV）加入到卷组（VG）

```
vgextend myvg1 /dev/sdc1
```

给卷组（VG）分配全部容量，固定容量方式：lvextend -L +5G -n /dev/myvg1/mylv1

```
lvextend -l +100%FREE /dev/myvg1/mylv1
```

使LVM扩容生效

```
xfs_growfs /data
```





# 大于2T的磁盘使用GPT分区

在Linux中，由于ext3文件系统不支持大于2TB的分区，所以要使用GPT分区格式。

可利用parted命令来完成分区。fdisk 只能分区小于2T的磁盘，大于2T就要用到parted。

先把大容量的磁盘进行转换，转换为GPT格式。由于GPT格式的磁盘相当于原来MBR磁盘中原来保留4个 partition table的4*16个字节只留第一个16个字节，其它的类似于扩展分区，真正的partition table在512字节之后，所以对GPT磁盘表来讲没有四个主分区的限制。 



## LVM大于2T磁盘parted方式挂载

使用`lsblk`查看新挂载的磁盘

```sh
[root@localhost ~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0     11:0    1 1024M  0 rom
sda      8:0    0   50G  0 disk
├─sda1   8:1    0    1G  0 part /boot
├─sda2   8:2    0    2G  0 part [SWAP]
└─sda3   8:3    0   47G  0 part /
sdb      8:16   0    2T  0 disk # 新挂载的sdb磁盘，容量为2TB。
```

创建分区

```sh
[root@19 ~]# parted /dev/vdb
(parted) mklabel #输入mklabel
New disk label type? gpt #输入类型为gpt
Warning: The existing disk label on /dev/vdb will be destroyed and all data on this disk will be lost. Do you want to continue?
Yes/No? yes #输入yes
(parted) mkpart #创建part
Partition name?  []? #回车
File system type?  [ext2]? #回车
Start? 0 #从0%开始
End? 100% #到100%结束
Warning: The resulting partition is not properly aligned for best performance.
Ignore/Cancel? Ignore #忽略
(parted) p #查看详细信息，看到已经创建了5T的磁盘
Number  Start   End     Size    File system  Name  Flags
 1      17.4kB  5369GB  5369GB
(parted) quit #退出parted分区工具
```

创建物理卷（PV）

```sh
[root@19 ~]# pvcreate /dev/vdb1
  Physical volume "/dev/vdb1" successfully created.
```

查看物理卷

```sh
[root@19 ~]# pvs
  PV         VG Fmt  Attr PSize   PFree
  /dev/vda2  ao lvm2 a--  <79.00g    0
  /dev/vda3  ao lvm2 a--  <20.00g    0
  /dev/vdb1     lvm2 ---    4.88t 4.88t
```

创建卷组（VG）

```shell
[root@19 ~]# vgcreate vg1 /dev/vdb1
  Volume group "vg1" successfully created
```

创建逻辑卷（LV）

```sh
[root@19 ~]# lvcreate -l +100%VG -n lv1 vg1
  Logical volume "lv1" created.
```

格式化分区

```sh
[root@19 ~]# mkfs.xfs /dev/vg1/lv1
meta-data=/dev/vg1/lv1           isize=512    agcount=5, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=1310718976, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

创建挂载文件夹

```sh
[root@19 ~]# mkdir /data
```

挂载到/data文件夹

```sh
[root@19 ~]# mount /dev/vg1/lv1 /data
```

查看vg1-lv1的UUID

```sh
[root@19 ~]# blkid
/dev/mapper/ao-root: UUID="9a986b97-621b-4409-9f8e-0ea34dbaaa72" TYPE="xfs"
/dev/vda2: UUID="S0LP8k-Xq5J-z2rp-Q97r-ueuM-WS63-Gm4Z9o" TYPE="LVM2_member"
/dev/vda3: UUID="7F40G6-2ahp-20td-2UZU-ntRX-5bbi-orNhnK" TYPE="LVM2_member"
/dev/vda1: UUID="8b2c50f9-da3c-4de2-b46e-88e945aae8b1" TYPE="xfs"
/dev/vdb1: UUID="S4R8UD-9Dzf-pg20-qahW-8YH7-CR8G-Ngytmv" TYPE="LVM2_member" PARTUUID="9907e560-7ae8-49a7-bc6c-580b2a815cb0"
/dev/sr1: UUID="2022-05-31-10-50-30-00" LABEL="config-2" TYPE="iso9660"
/dev/mapper/ao-swap: UUID="f401c393-72e1-4641-9c6a-82953084d34a" TYPE="swap"
/dev/mapper/ao-home: UUID="ba8134db-bf64-4a79-9dec-de5704678147" TYPE="xfs"
/dev/mapper/vg1-lv1: UUID="d5e6921f-244f-49f7-98d0-e5fc3fb441fa" TYPE="xfs"
```

LVM持久化，这里的UUID是上面查出来的

```
[root@19 ~]# vim /etc/fstab
UUID="d5e6921f-244f-49f7-98d0-e5fc3fb441fa" /data xfs defaults        0 0
```

刷新挂载

```
[root@19 ~]# mount -a
```



## LVM大于2T磁盘parted方式扩容

使用`lsblk`查看新挂载的磁盘

```sh
[root@localhost ~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0     11:0    1 1024M  0 rom
sda      8:0    0   50G  0 disk
├─sda1   8:1    0    1G  0 part /boot
├─sda2   8:2    0    2G  0 part [SWAP]
└─sda3   8:3    0   47G  0 part /
sdb      8:16   0    2T  0 disk # 新挂载的sdb磁盘，容量为2TB。
```

创建分区

```sh
[root@localhost ~]# parted /dev/sdc
(parted) mklabel #输入mklabel
New disk label type? gpt #输入类型为gpt
Warning: The existing disk label on /dev/sdc will be destroyed and all data on this disk will be lost. Do you want to continue?
Yes/No? yes #输入yes
(parted) mkpart #创建part
Partition name?  []? #回车
File system type?  [ext2]? #回车
Start? 0 #从0%开始
End? 100% #到100%结束
Warning: The resulting partition is not properly aligned for best performance.
Ignore/Cancel? Ignore #忽略
(parted) p #查看详细信息，看到已经创建了5T的磁盘
Number  Start   End     Size    File system  Name  Flags
 1      17.4kB  5369GB  5369GB
(parted) quit #关闭
```

创建物理卷PV

```
pvcreate /dev/sdc1
```

将物理卷（PV）加入到卷组（VG）

```
vgextend centos /dev/sdc1
```

给卷组（VG）分配全部容量，固定容量方式：`lvextend -L +5G -n /dev/mapper/centos-root`

```
lvextend -l +100%FREE /dev/mapper/centos-root 
```

使LVM扩容生效

```
xfs_growfs /data
```







