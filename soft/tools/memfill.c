
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>


void MemFill(unsigned char *pBase, unsigned long ulAddr, unsigned long ulSize, unsigned long ulData, int iWidth);


/* メイン関数 */
int main(int argc, char *argv[])
{
	char			fname[64];
	int				fd;
	unsigned char	*buf;
	int				iDevNum    = 0;
	unsigned long	ulAddr     = 0;
	unsigned long	ulSize     = 256;
	unsigned long	ulData     = 0;
	int				iWidth     = 'w';
	unsigned long	ulAreaSize = 0x1000;
	
	if ( argc < 2 )
	{
		printf(
				"<usage>\n"
				" %s [devnum] [addrress] [size] [data] [b|h|w] [area size]\n\n",
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
		ulSize = strtoul(argv[3], 0, 0);
	}
	if ( argc >= 5 ) {
		ulData = strtoul(argv[4], 0, 0);
	}
	if ( argc >= 6 )
	{
		iWidth = argv[5][0];
	}
	
	if ( ulAreaSize < ulAddr + ulSize ) {
		ulAreaSize = ulAddr + ulSize;
	}
	if ( argc >= 7 )
	{
		ulAreaSize = strtoul(argv[6], 0, 0);
	}
	
	/* UIOオープン */
	sprintf(fname, "/dev/uio%d", iDevNum);
	fd = open(fname, O_RDWR);
	if (fd == -1) {
		printf("open error: %s\n", fname);
		return 1;
	}
	printf("<%s>\n", fname);
	
	/* メモリマップ */
	buf = (unsigned char*)mmap(NULL, ulAreaSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if ( buf == MAP_FAILED) {
		printf("mmap error\n");
		return 1;
	}
	
	/* メモリダンプ */
	MemFill(buf, ulAddr, ulSize, ulData, iWidth);
	
	/* クローズ */
	munmap(buf, ulAreaSize);
	close(fd);
	
	
	return 0;
}




void MemFill(unsigned char *pBase, unsigned long ulAddr, unsigned long ulSize, unsigned long ulData, int iWidth)
{
	unsigned long	i;
	
	switch ( iWidth )
	{
	case 'b':
		for ( i = 0; i < ulSize; i++ )
		{
			*(unsigned char *)&pBase[ulAddr] = ulData;
			ulAddr += 1;
		}
		break;
		
	case 'h':
		for ( i = 0; i < (ulSize+1)/2; i++ )
		{
			*(unsigned short *)&pBase[(ulAddr & 0xfffffffe)] = ulData;
			ulAddr += 2;
		}
		break;

	case 'w':
		for ( i = 0; i < (ulSize+3)/4; i++ )
		{
			if ( i == 0 ) {
				printf("%08x <= %08x\n", ulAddr, ulData);
			}
			*(unsigned long *)&pBase[(ulAddr & 0xfffffffc)] = ulData;
			ulAddr += 4;
		}
		break;
	}
}

