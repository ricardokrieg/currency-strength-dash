class PairDesigner {
   public:

   string symbol;   
   string scoreID;
   string symbolID;
   string rankID;
   string slopeID;
   color pairColor;
   
   PairDesigner(string, int, color);
   void update(double, double);
   void setPosition(int);
   void filter(string);
   
   private:
   
   string getSymbolID(int);
   string getScoreID(int);
   string getRankID(int);
   string getSlopeID(int);
   string getID(string, int);
   string getArrowCode(double);
   bool includeSymbol(string);
};
