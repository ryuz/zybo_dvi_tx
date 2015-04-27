connect arm hw
rst -slcr
fpga -f top.bit
source ps7_init.tcl
ps7_init
ps7_post_config
source stub.tcl
targets 64
dow -data devicetree.dtb 0x02A00000
dow -data u-boot.bin 0x04000000
con 0x04000000
