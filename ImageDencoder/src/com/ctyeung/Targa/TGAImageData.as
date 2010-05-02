// ==================================================================
// Module:		TGAImageData.as
//
// Description:	Targa Image Data class
// 				- image pixel data
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
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public class TGAImageData
	{
		public var bmd:BitmapData;
		public var hdr:TGAHeader;
		public var pal:TGAPalette;
		protected var offset:uint;
		
		public function TGAImageData(hdr:TGAHeader,
									 pal:TGAPalette) {
			this.hdr = hdr;
			this.pal = pal;
		}
		
		public function dispose():void {
			hdr = null;
			pal = null;
			empty();
		}
		
		public function empty():void {
			if(bmd) {
				bmd.dispose();
				bmd = null;
			}
		}
		
		public function get bitmapData():BitmapData {
			return bmd;
		}
		
		public function set bitmapData(bmd:BitmapData):void {
			this.bmd = bmd;
		}
		
		public function decode(bytes:ByteArray):Boolean {
			empty();
			offset = hdr.length + pal.length;
			switch(hdr.bpp) {
				case TGATypeEnum.BPP_1:
					return decodeMono(bytes);
				
				case TGATypeEnum.BPP_8:
					return decode8(bytes);
					
				case TGATypeEnum.BPP_24:
					return decode24(bytes);
			}
			empty();
			return false;
		}
		
		// 1 bpp
		protected function decodeMono(bytes:ByteArray):Boolean {
			var mask:uint=0x80;
			var index:uint = offset;
			bmd = new BitmapData(hdr.imgWid, hdr.imgWid);
			
			for(var y:uint=0; y<hdr.imgLen; y++) {
				for(var x:uint=0; x<hdr.imgWid; x++) {
					var clr:uint = (mask&bytes[index])?0xFFFFFF:0x0;
					bmd.setPixel(x,y,clr);
					mask = (mask>0x1)?mask>>1:0x80;
					index ++;
				}
			}
			return true;
		}

/////////////////////////////////////////////////////////////////////
// 8 bpp image
		
		protected function decode8(bytes:ByteArray):Boolean {
			switch(hdr.imgType) {
				case TGATypeEnum.IMG_TYPE_MONO_NO_CMP:
					return decode8Mono(bytes);
					
				case TGATypeEnum.IMG_TYPE_CLR_MAP_NO_CMP:
					return decode8ClrMap(bytes);
					
				case TGATypeEnum.IMG_TYPE_CLR_RMAP_RLE:
				case TGATypeEnum.IMG_TYPE_CLR_MAP_HUFF:
				case TGATypeEnum.IMG_TYPE_CLR_MAP_HUFFQUAD:
					break;
			}
			return false;
		}
		
		protected function decode8Mono(bytes:ByteArray):Boolean {
			bmd = new BitmapData(hdr.imgWid, hdr.imgWid);
			for(var y:uint=0; y<hdr.imgLen; y++) {
				var index:uint = y*hdr.imgWid+offset;
				for(var x:uint=0; x<hdr.imgWid; x++) {
					var clr:uint = bytes[index++];
					clr = (clr<<16) +
						  (clr<<8) + 
						  clr;
					
					bmd.setPixel(x,y,clr);
				}
			}
			return true;
		}
		
		// 8 bpp, only 16 entries of color in palette
		protected function decode8ClrMap(bytes:ByteArray):Boolean {
			bmd = new BitmapData(hdr.imgWid, hdr.imgWid, true);
			for(var y:uint=0; y<hdr.imgLen; y++) {
				var index:uint = y*hdr.imgWid+offset;
				for(var x:uint=0; x<hdr.imgWid; x++) {
					var clr:uint = bytes[index++];
					clr = pal.palette[clr];
					bmd.setPixel32(x,y,clr);
				}
			}
			return true;
		}

/////////////////////////////////////////////////////////////////////
// decode 24 bpp image
		
		protected function decode24(bytes:ByteArray):Boolean {
			switch(hdr.imgType) {
				case TGATypeEnum.IMG_TYPE_CLR_MAP_NO_CMP:	// type 1
				case TGATypeEnum.IMG_TYPE_RGB_RLE:
					break;
					
				case TGATypeEnum.IMG_TYPE_MONO_NO_CMP:		// type 3
				case TGATypeEnum.IMG_TYPE_RGB_NO_CMP:		// type 2
					return decode24RGB(bytes);
			}
			return false;
		}
		
		protected function decode24RGB(bytes:ByteArray):Boolean {
			bmd = new BitmapData(hdr.imgWid, hdr.imgWid);
			for(var y:uint=0; y<hdr.imgLen; y++) {
				var index:uint = y*hdr.imgWid*3+offset;
				for(var x:uint=0; x<hdr.imgWid; x++) {
					var clr:uint = 	(bytes[index++])+
									(bytes[index++]<<8)+
									(bytes[index++]<<16);
					
					bmd.setPixel(x,y,clr);
				}
			}
			return true;
		}
							   
	}
}