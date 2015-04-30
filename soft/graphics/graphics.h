

#ifndef __GRAPHICS_H__
#define __GRAPHICS_H__


// 色形式
typedef	union t_color {
	unsigned char	ubData;
	unsigned short	uhData;
	unsigned long	uwData;
	struct {
		unsigned char	ubB;
		unsigned char	ubG;
		unsigned char	ubR;
		unsigned char	ubA;
	} bgra;
	struct {
		unsigned char	ubA;
		unsigned char	ubR;
		unsigned char	ubG;
		unsigned char	ubB;
	} argb;
} T_COLOR;


// 画像バッファ
typedef struct t_imgbuf
{
	int					iFormat;
	unsigned char		*pData;
	unsigned	int		uiStride;	// バイトサイズ
	unsigned	int		uiWidth;	// ピクセル幅
	unsigned	int		uiHeight;	// ピクセル高さ
} T_IMGBUF;



static inline void Graphics_SetPixel(T_IMGBUF *img, int x, int y, T_COLOR col)
{
	// 範囲チェック
	if ( (unsigned int)x >= img->uiWidth || (unsigned int)y >= img->uiHeight ) {
		return;
	}
	
	// ひとまずフォーマットは32bit幅限定
	*(unsigned long *)&img->pData[y*img->uiStride + x*4] = col.uwData;
}


void Graphics_Clear(T_IMGBUF *img, T_COLOR col);
void Graphics_Line(T_IMGBUF *img, int x1, int y1, int x2, int y2, T_COLOR col);
void Graphics_Circle(T_IMGBUF *img, int xc, int yc, int r, T_COLOR col);


#endif	/* __GRAPHICS_H__ */


