
#include <stdlib.h>
#include "graphics.h"



void Graphics_Clear(T_IMGBUF *img, T_COLOR col)
{
	int x, y;
	for ( y = 0; y < img->uiHeight; y++ ) {
		for ( x = 0; x < img->uiWidth; x++ ) {
			Graphics_SetPixel(img, x, y, col);
		}
	}
}


void Graphics_Line(T_IMGBUF *img, int x1, int y1, int x2, int y2, T_COLOR col)
{
	int dx, dy, s, step;
	
	dx = abs(x2 - x1);
	dy = abs(y2 - y1);
	
	if ( dx > dy )
	{
		if ( x1 > x2 )
		{
			step = (y1 > y2) ? 1 : -1;
			s = x1;  x1 = x2;  x2 = s;  y1 = y2;
		}
		else
		{
			step = (y1 < y2) ? 1: -1;
		}
		Graphics_SetPixel(img, x1, y1, col);
		s = dx >> 1;
		while ( ++x1 <= x2 )
		{
			if ( (s -= dy) < 0 )
			{
				s += dx;  y1 += step;
			}
			Graphics_SetPixel(img, x1, y1, col);
		}
	}
	else
	{
		if ( y1 > y2 )
		{
			step = (x1 > x2) ? 1 : -1;
			s = y1; y1 = y2;  y2 = s;  x1 = x2;
		}
		else
		{
			step = (x1 < x2) ? 1 : -1;
		}
		Graphics_SetPixel(img, x1, y1, col);
		s = dy >> 1;
		while ( ++y1 <= y2 )
		{
			if ( (s -= dx) < 0 )
			{
				s += dy;  x1 += step;
			}
			Graphics_SetPixel(img, x1, y1, col);
		}
	}
}


void Graphics_Circle(T_IMGBUF *img, int xc, int yc, int r, T_COLOR col)
{
	int x, y;
	
	x = r;
	y = 0;
	
	while ( x >= y )
	{
		Graphics_SetPixel(img, xc + x, yc + y, col);
		Graphics_SetPixel(img, xc + x, yc - y, col);
		Graphics_SetPixel(img, xc - x, yc + y, col);
		Graphics_SetPixel(img, xc - x, yc - y, col);
		Graphics_SetPixel(img, xc + y, yc + x, col);
		Graphics_SetPixel(img, xc + y, yc - x, col);
		Graphics_SetPixel(img, xc - y, yc + x, col);
		Graphics_SetPixel(img, xc - y, yc - x, col);
		if ( (r -= (y++ << 1) - 1) < 0 )
		{
			r += (x-- - 1) << 1;
		}
	}

}


