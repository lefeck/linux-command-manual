# lsblk

列出块设备信息

## 补充说明

lsblk命令 用于列出所有可用块设备的信息，而且还能显示他们之间的依赖关系，但是它不会列出RAM盘的信息。块设备有硬盘，闪存盘，cd-ROM等等。lsblk命令包含在util-linux-ng包中，现在该包改名为util-linux。这个包带了几个其它工具，如dmesg。要安装lsblk，请在此处下载util-linux包。Fedora用户可以通过命令sudo yum install util-linux-ng来安装该包。

## 选项

```shell
-a, --all            # 显示所有设备。
-b, --bytes          # 以bytes方式显示设备大小。
-d, --nodeps         # 不显示 slaves 或 holders。
-D, --discard        # print discard capabilities。
-e, --exclude <list> # 排除设备 (default: RAM disks)。
-f, --fs             # 显示文件系统信息。
-h, --help           # 显示帮助信息。
-i, --ascii          # use ascii characters only。
-m, --perms          # 显示权限信息。
-l, --list           # 使用列表格式显示。
-n, --noheadings     # 不显示标题。
-o, --output <list>  # 输出列。
-P, --pairs          # 使用key="value"格式显示。
-r, --raw            # 使用原始格式显示。
-t, --topology       # 显示拓扑结构信息。

```
实例

lsblk命令默认情况下将以树状列出所有块设备。打开终端，并输入以下命令：