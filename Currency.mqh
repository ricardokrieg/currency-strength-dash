#include "Score.mqh"

#include "CurrencyDesigner.mqh"

class Currency {
   public:
   
   string symbol;
   Score scores[];
   int nScores;
   int pairsUp;
   int pairsDown;
   
   CurrencyDesigner *observer;
   
   Currency(string, int);
   
   void updateScore(string, double);
   double score();
   void setObserver(CurrencyDesigner*);
   void updatePairGroup();
   
   private:
   
   int findScoreIndex(string);
};
