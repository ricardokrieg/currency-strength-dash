class CurrencyDesigner {
   public:
   
   string symbol;
   string symbolID;
   string scoreID;
   string pairGroupID;
   color currencyColor;
   
   CurrencyDesigner(string, int);
   
   void update(double);
   void updatePairGroup(int, int);
   void setPosition(int);
   void filter(string);
   
   private:
   
   string getSymbolID(int);
   string getScoreID(int);
   string getPairGroupID(int);
   string getID(string, int);
};
