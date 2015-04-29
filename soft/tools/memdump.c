
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
	unsigned char	*buf;
	int				iDevNum    = 0;
	unsigned long	ulAddr     = 0;
	unsigned long	ulSize     = 256;
	int				iWidth     = 'w';
	unsigned long	ulAreaSize = 0x1000;
	
	if ( argc < 2 )
	{
		printf(
				"<usage>\n"
				" %s [devnum] [addrress] [size] [b|h|w] [area size]\n\n",
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
	printf("<%s>\n", fname);
	
	/* メモリマップ */
	buf = (unsigned char*)mmap(NULL, ulAreaSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if ( buf == MAP_FAILED) {
		printf("mmap error\n");
		return 1;
	}
	
	/*
	for ( i = 0; i < 16; i++ ) {
		printf("%08x ", buf[i]);
		if ( i % 4 == 3 ) { printf("\n"); }
	}
	printf("\n");
	*/
	
	
	/* メモリダンプ */
	MemDump(buf, ulAddr, ulSize, iWidth);
	
	/* クローズ */
	munmap(buf, ulAreaSize);
	close(fd);
	
	
	return 0;
}




void MemDump(unsigned char *pBase, unsigned long ulAddr, unsigned long ulSize, int iWidth)
{
	unsigned long	i;
	
	switch ( iWidth )
	{
	case 'b':
		{
			for ( i = 0; i < ulSize; i++ )
			{
				if ( i % 16 == 0 )
				{
					printf("%08lx: ", ulAddr);
				}
				printf("%02x ", *(unsigned char *)&pBase[ulAddr]);
				ulAddr += 1;
				if ( i % 16 == 15 )
				{
					printf("\n");
				}
			}
		}
		break;
		
	case 'h':
		{
			for ( i = 0; i < (ulSize+1)/2; i++ )
			{
				if ( i % 8 == 0 )
				{
					printf("%08lx: ", ulAddr);
				}
				printf("%04x ", *(unsigned short *)&pBase[(ulAddr & 0xfffffffe)]);
				ulAddr += 2;
				if ( i % 8 == 7 )
				{
					printf("\n");
				}
			}
		}
		break;

	case 'w':
		{
			for ( i = 0; i < (ulSize+3)/4; i++ )
			{
				if ( i % 4 == 0 )
				{
					printf("%08lx: ", ulAddr);
				}
				printf("%08x ", *(unsigned long *)&pBase[(ulAddr & 0xfffffffc)]);
				ulAddr += 4;
				if ( i % 4 == 3 )
				{
					printf("\n");
				}
			}
		}
		break;
	}
	
	printf("\n");
}

