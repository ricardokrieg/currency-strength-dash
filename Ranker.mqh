#include "PairDesigner.mqh"
#include "EventManager.mqh"

class Ranker {
   public:
   
   Pair pairs[];
   Currency currencies[];
   
   PairDesigner *pairDesigners[];
   CurrencyDesigner *currencyDesigners[];
   
   int nPairs, nCurrencies;
   string currentFilter;
   
   ~Ranker();
   void initialize(int, int);
   void update(string, double);
   void postUpdate();
   void filterCurrency(string);
   
   private:
   
   int findPairIndex(string);
   int findCurrencyIndex(string);
   double calculateSlope(int);
};
