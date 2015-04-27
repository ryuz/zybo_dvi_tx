

all: devicetree.dtb

devicetree.dtb: zynq-zybo.dts
	../../Linux-Digilent-Dev/scripts/dtc/dtc -I dts -O dtb -o devicetree.dtb zynq-zybo.dts


get_digilent:
	pushd ../..
	git clone -b master-next https://github.com/DigilentInc/u-boot-Digilent-Dev.git
	git clone -b master-next https://github.com/DigilentInc/Linux-Digilent-Dev.git
	popd

build_linux:
	make -C ../../Linux-Digilent-Dev ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- xilinx_zynq_defconfig
	make -C ../../Linux-Digilent-Dev ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi-
	make -C ../../Linux-Digilent-Dev ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- UIMAGE_LOADADDR=0x8000 uImage


build_uboot:
	make -C ../../boot ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- zynq_zybo_config
	make -C ../../boot ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi-

