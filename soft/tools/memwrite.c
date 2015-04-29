
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>


void MemDump(unsigned char *pBase, unsigned long ulAddr, unsigned long ulSize, int iWidth);


/* メイン関数 */
int main(int argc, char *argv[])
{
	char			fname[64];
	int				fd;
	unsigned char	*pBase;
	int				iDevNum    = 0;
	unsigned long	ulAddr;
	unsigned long	ulData;
	int				iWidth     = 'w';
	unsigned long	ulAreaSize = 0x1000;
	
	if ( argc < 4 )
	{
		printf(
				"<usage>\n"
				" %s [devnum] [addrress] [data] [b|h|w] [area size]\n\n",
				argv[0]
			);
		return 1;
	}
	
	/* コマンドライン解析 */
	if ( argc >= 2 ) {
		iDevNum = strtol(argv[1], NULL, 0);
	}
	if ( argc >= 3 ) {
		ulAddr = strtol(argv[2], NULL, 0);
	}
	if ( argc >= 4 ) {
		ulData = strtoul(argv[3], 0, 0);
	}
	if ( argc >= 5 )
	{
		iWidth = argv[4][0];
	}
	if ( argc >= 6 )
	{
		ulAreaSize = strtoul(argv[5], 0, 0);
	}
	
	/* UIOオープン */
	sprintf(fname, "/dev/uio%d", iDevNum);
	fd = open(fname, O_RDWR);
	if (fd == -1) {
		printf("open error: %s\n", fname);
		return 1;
	}
	
	/* メモリマップ */
	pBase = (unsigned char*)mmap(NULL, ulAreaSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if ( pBase == MAP_FAILED) {
		printf("mmap error\n");
		return 1;
	}
	
	/* 書き込み */
	switch ( iWidth )
	{
	case 'b':
		ulData &= 0xff;
		*(unsigned char *)&pBase[ulAddr & 0xffffffff] = (unsigned char)ulData;
		printf("<%s> (unsigned char *)0x%08lx <= 0x%02x (%d)\n", fname, ulAddr, (int)ulData, (int)ulData);
		break;

	case 'h':
		ulData &= 0xffff;
		*(unsigned short *)&pBase[ulAddr & 0xfffffffe] = (unsigned short)ulData;
		printf("<%s> (unsigned short *)0x%08lx <= 0x%04x (%d)\n", fname, ulAddr, (int)ulData, (int)ulData);
		break;

	case 'w':
		*(unsigned long *)&pBase[ulAddr & 0xfffffffc] = ulData;
		printf("<%s> (unsigned long *)0x%08lx <= 0x%08lx (%ld)\n", fname, ulAddr, ulData, (long)ulData);
		break;
	}
	
	
	/* クローズ */
	munmap(pBase, ulAreaSize);
	close(fd);
	
	
	return 0;
}

