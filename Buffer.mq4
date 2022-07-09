#include "Buffer.mqh"

void Buffer::set(int i, string s, bool visible=true) {
   this.index = i;
   this.symbol = s;

   SetIndexBuffer(this.index, this.buffer);
   SetIndexLabel(this.index, this.symbol);
   
   if (visible) {
      this.bufferColor = COLORS[this.index];
      SetIndexStyle(this.index, DRAW_LINE, STYLE_SOLID, 2, this.bufferColor);
   }
}

void Buffer::setColor(color c) {
   this.bufferColor = c;
   
   SetIndexStyle(this.index, DRAW_LINE, STYLE_SOLID, 2, this.bufferColor);
}
