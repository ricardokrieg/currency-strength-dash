PairDesigner::PairDesigner(string s, int i, color c) {
   this.symbol = s;

   this.slopeID = this.getSlopeID(i);
   this.scoreID = this.getScoreID(i);
   this.symbolID = this.getSymbolID(i);
   this.rankID = this.getRankID(i);
   this.pairColor = c;
   
   double xMargin = Input_PairXMargin;
   ObjectCreate(this.slopeID, OBJ_LABEL, window, 0, 0);
   ObjectSet(this.slopeID, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSet(this.slopeID, OBJPROP_XDISTANCE, xMargin);
   ObjectSet(this.slopeID, OBJPROP_COLOR, this.pairColor);
   ObjectSet(this.slopeID, OBJPROP_SELECTABLE, 0);
   ObjectSet(this.slopeID, OBJPROP_SELECTED, 0);
   
   xMargin += Input_PairXPadding + (Input_PairFontSize * 3);
   ObjectCreate(this.scoreID, OBJ_LABEL, window, 0, 0);
   ObjectSet(this.scoreID, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSet(this.scoreID, OBJPROP_XDISTANCE, xMargin);
   ObjectSet(this.scoreID, OBJPROP_COLOR, this.pairColor);
   ObjectSet(this.scoreID, OBJPROP_SELECTABLE, 0);
   ObjectSet(this.scoreID, OBJPROP_SELECTED, 0);
   
   xMargin += Input_PairXPadding + (Input_PairFontSize * 4);
   ObjectCreate(this.symbolID, OBJ_LABEL, window, 0, 0);
   ObjectSet(this.symbolID, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSet(this.symbolID, OBJPROP_XDISTANCE, xMargin);
   ObjectSet(this.symbolID, OBJPROP_COLOR, this.pairColor);
   ObjectSet(this.symbolID, OBJPROP_SELECTABLE, 0);
   ObjectSet(this.symbolID, OBJPROP_SELECTED, 0);
   ObjectSetText(this.symbolID, this.symbol, Input_PairFontSize, "Arial Black");
   
   xMargin += Input_PairXPadding + (Input_PairFontSize * 10);
   ObjectCreate(this.rankID, OBJ_LABEL, window, 0, 0);
   ObjectSet(this.rankID, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSet(this.rankID, OBJPROP_XDISTANCE, xMargin);
   ObjectSet(this.rankID, OBJPROP_COLOR, this.pairColor);
   ObjectSet(this.rankID, OBJPROP_SELECTABLE, 0);
   ObjectSet(this.rankID, OBJPROP_SELECTED, 0);
}

void PairDesigner::update(double value, double slope) {
   ObjectSetText(this.slopeID, this.getArrowCode(slope), Input_PairFontSize, "wingdings");
   ObjectSetText(this.scoreID, DoubleToStr(value, 0), Input_PairFontSize, "Arial Black");
}

void PairDesigner::setPosition(int position) {
   int yPosition = Input_PairYMargin + (position * Input_PairYPadding);
   
   ObjectSet(this.slopeID, OBJPROP_YDISTANCE, yPosition);
   ObjectSet(this.scoreID, OBJPROP_YDISTANCE, yPosition);
   ObjectSet(this.symbolID, OBJPROP_YDISTANCE, yPosition);
   ObjectSet(this.rankID, OBJPROP_YDISTANCE, yPosition);
   
   ObjectSetText(this.rankID, IntegerToString(position), Input_PairFontSize, "Arial Black");
}

void PairDesigner::filter(string s) {
   color c = s == "" || this.includeSymbol(s) ? this.pairColor : clrNONE;
   
   ObjectSet(this.slopeID, OBJPROP_COLOR, c);
   ObjectSet(this.scoreID, OBJPROP_COLOR, c);
   ObjectSet(this.symbolID, OBJPROP_COLOR, c);
   ObjectSet(this.rankID, OBJPROP_COLOR, c);
   
   for (int i = 0; i < N_PAIR_BUFFERS; i++) {
      if (pairBuffers[i].symbol == this.symbol) {
         pairBuffers[i].setColor(c);
         break;
      }
   }
}

string PairDesigner::getSymbolID(int i) {
   return this.getID("symbol", i);
}

string PairDesigner::getScoreID(int i) {
   return this.getID("score", i);
}

string PairDesigner::getRankID(int i) {
   return this.getID("rank", i);
}

string PairDesigner::getSlopeID(int i) {
   return this.getID("slope", i);
}

string PairDesigner::getID(string type, int i) {
   return SHORT_NAME + ":PairDesigner:" + type + ":" + IntegerToString(i);
}

string PairDesigner::getArrowCode(double slope) {
   int code;
   
   if (slope > Input_ArrowUpThreshold) code = 233; // up
   else if (slope > Input_ArrowAlmostUpThreshold) code = 236; // almost up
   else if (slope > -1 * Input_ArrowAlmostUpThreshold) code = 232; // straight
   else if (slope > -1 * Input_ArrowUpThreshold) code = 238; // almost down
   else code = 234; // down

   return CharToStr((char)code);
}

bool PairDesigner::includeSymbol(string s) {
   return StringSubstr(this.symbol, 0, 3) == s || StringSubstr(this.symbol, 3, 3) == s;
}
