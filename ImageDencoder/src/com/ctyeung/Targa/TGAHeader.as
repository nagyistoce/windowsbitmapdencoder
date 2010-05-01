// ==================================================================
// Module:		TGAHeader.as
//
// Description:	Targa Header class
// 				- bitmapheader 
//
// Author(s):	C.T. Yeung 	(cty)
//
// History:
// 29Apr10		start working on this 							cty
//
// Copyright (c) 2010 C.T.Yeung

// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:

// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// ==================================================================
package com.ctyeung.Targa
{
	import flash.utils.ByteArray;

	public class TGAHeader
	{
		public var lenID:int;			// length of image ID, 1 byte: 0 - 255 bytes (0=no id)
		public var clrMapType:Boolean;	// Color map type, 1 byte: 	0 (no color map) 
										//							1 (color map included)
		public var imgType:int;			// Image type, 1 byte:		0 no image data in file
										//							1 color map image, uncompressed
										//							2 RGB image (24bpp) uncompressed
										//							3 Monochrome image uncompressed
										//							9 Color map image, RLE-encoding
										// 						   10 RGB image (24bpp) RLE-encoding
										//						   11 Monochrome image, RLE-encoding
										// 						   32 Color map image, Huffman, delta and RLE-encoding
										//						   33 Color map image, Huffman, delta, RLE, 4 pass quad tree
		public var clrMapOrgn:int;		// Color map origin, 2 bytes
		public var clrMapLen:int;		// Color map length, 2 bytes
		public var clrMapEntrySze:int;	// Color map entry size (16, 24, 32), 1 byte
		public var xOrgn:int;			// X-coordinate origin, 2 bytes
		public var yOrgn:int;			// Y-coordinate origin, 2 bytes
		public var imgWid:int;			// image width in pixels, 2 bytes
		public var imgLen:int;			// image height in pixels, 2 bytes
		public var bpp:int;				// bits per pixel, 1 byte
		public var imgIDField:Array;	// image identification field
		public var scrnOrgn:int;		// screen origin
		public var dataInterleave:int	// data storage interleave
		public var attrBpp:int;			// Attribute bits per pixel
		
		public function TGAHeader()
		{
		}
		
		public function isEmpty():Boolean {
			if(imgWid&&imgLen)
				return true;
			return false;
		}
		
		public function dispose():void {
			
		}

/////////////////////////////////////////////////////////////////////
// decoding
		
		public function decode(bytes:ByteArray):Boolean {
			lenID	  		=  bytes[0];
			clrMapType 		= (bytes[1])?true:false;
			imgType			=  byte[2];
			clrMapOrgn		=  uint(bytes[3]);
			clrMapOrgn		+= uint(bytes[4])<<8;
			clrMapLen		=  uint(bytes[5]);
			clrMapLen		+= uint(bytes[6])<<8;
			clrMapEntrySze	= byte[7];
			xOrgn			= uint(bytes[8]);
			xOrgn			+= uint(bytes[9])<<8;
			yOrgn			= uint(bytes[10]);
			yOrgn			+= uint(bytes[11])<<8;
			imgWid			= uint(bytes[12]);
			imgWid			+= uint(bytes[13])<<8;
			imgLen			= uint(bytes[14]);
			imgLen			+= uint(bytes[15])<<8;
			bpp				= bytes[16];
			imageDescriptor	= bytes[17];
			
			if(lenID) {
				
			}
		}
		
		// image descriptor byte, 1 byte
		protected function set imageDescriptor(value:int):void {
			dataInterleave 	= (value&C0)>>6;
			scrnOrgn		= (value&30)>>3;
			attrBpp			= value&0F;
		}
		
/////////////////////////////////////////////////////////////////////
// Encoding
		
		public function encode(byte:ByteArray):Boolean {
			return true;
		}
		
		protected function get imageDescriptor():int {
			
		}
	}
}