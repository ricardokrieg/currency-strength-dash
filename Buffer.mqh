class Buffer {
   public:

   int index;
   double buffer[];
   string symbol;
   color bufferColor;

   void set(int, string, bool);
   void setColor(color);
};
