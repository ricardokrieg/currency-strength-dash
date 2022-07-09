CurrencyDesigner::CurrencyDesigner(string s, int i) {
   this.symbol = s;

   this.symbolID = this.getSymbolID(i);
   this.scoreID = this.getScoreID(i);
   this.pairGroupID = this.getPairGroupID(i);

   this.currencyColor = clrNONE;
   
   double xMargin = Input_CurrencyXMargin;
   ObjectCreate(this.pairGroupID, OBJ_LABEL, window, 0, 0);
   ObjectSet(this.pairGroupID, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSet(this.pairGroupID, OBJPROP_XDISTANCE, xMargin);
   ObjectSet(this.pairGroupID, OBJPROP_SELECTABLE, 0);
   ObjectSet(this.pairGroupID, OBJPROP_SELECTED, 0);
   
   xMargin += Input_CurrencyXPadding + (Input_CurrencyFontSize * 3);
   ObjectCreate(this.scoreID, OBJ_LABEL, window, 0, 0);
   ObjectSet(this.scoreID, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSet(this.scoreID, OBJPROP_XDISTANCE, xMargin);
   ObjectSet(this.scoreID, OBJPROP_SELECTABLE, 0);
   ObjectSet(this.scoreID, OBJPROP_SELECTED, 0);
   
   xMargin += Input_CurrencyXPadding + (Input_CurrencyFontSize * 4);
   ObjectCreate(this.symbolID, OBJ_LABEL, window, 0, 0);
   ObjectSet(this.symbolID, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSet(this.symbolID, OBJPROP_XDISTANCE, xMargin);
   ObjectSet(this.symbolID, OBJPROP_SELECTABLE, 0);
   ObjectSet(this.symbolID, OBJPROP_SELECTED, 0);
   ObjectSetText(this.symbolID, this.symbol, Input_CurrencyFontSize, "Arial Black");
}

void CurrencyDesigner::update(double value) {
   ObjectSetText(this.scoreID, DoubleToStr(value, 0), Input_CurrencyFontSize, "Arial Black");

   if (value >= 0) {
      this.currencyColor = Input_PositiveColor;
   } else {
      this.currencyColor = Input_NegativeColor;
   }
   
   ObjectSet(this.symbolID, OBJPROP_COLOR, this.currencyColor);
   ObjectSet(this.scoreID, OBJPROP_COLOR, this.currencyColor);
   ObjectSet(this.pairGroupID, OBJPROP_COLOR, this.currencyColor);
}

void CurrencyDesigner::updatePairGroup(int up, int down) {
   string text = IntegerToString(up) + "/" + IntegerToString(down);
   ObjectSetText(this.pairGroupID, text, Input_CurrencyFontSize, "Arial Black");
}

void CurrencyDesigner::setPosition(int position) {
   int yPosition = Input_CurrencyYMargin + (position * Input_CurrencyYPadding);
   
   ObjectSet(this.symbolID, OBJPROP_YDISTANCE, yPosition);
   ObjectSet(this.scoreID, OBJPROP_YDISTANCE, yPosition);
   ObjectSet(this.pairGroupID, OBJPROP_YDISTANCE, yPosition);
}

void CurrencyDesigner::filter(string s) {
   if (this.symbol == s) {
      ObjectSet(this.symbolID, OBJPROP_COLOR, clrWhite);
   } else {
      ObjectSet(this.symbolID, OBJPROP_COLOR, this.currencyColor);
   }
}

string CurrencyDesigner::getSymbolID(int i) {
   return this.getID("symbol", i);
}

string CurrencyDesigner::getScoreID(int i) {
   return this.getID("score", i);
}

string CurrencyDesigner::getPairGroupID(int i) {
   return this.getID("pairgroup", i);
}

string CurrencyDesigner::getID(string type, int i) {
   return SHORT_NAME + ":CurrencyDesigner:" + type + ":" + IntegerToString(i);
}
