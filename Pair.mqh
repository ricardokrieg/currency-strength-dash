#include "PairDesigner.mqh"

class Pair {
   public:
   
   string symbol;
   double score;
   double slope;
   
   PairDesigner *observer;
   
   Pair(string newSymbol, double newScore);
   
   void updateScore(double, double);
   void setObserver(PairDesigner*);
};
