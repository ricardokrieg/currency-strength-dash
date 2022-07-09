Ranker::~Ranker() {
   for (int i = 0; i < this.nPairs; i++) {
      delete this.pairDesigners[i];
   }
   
   for (int i = 0; i < this.nCurrencies; i++) {
      delete this.currencyDesigners[i];
   }
}

void Ranker::initialize(int maxPairs, int maxCurrencies) {
   this.nPairs      = maxPairs;
   this.nCurrencies = maxCurrencies;

   ArrayResize(this.pairs, this.nPairs);
   ArrayResize(this.pairDesigners, this.nPairs);
   
   for (int i = 0; i < this.nPairs; i++) {
      this.pairs[i] = Pair(PAIRS[i], 0);
      
      PairDesigner *pairDesigner = new PairDesigner(PAIRS[i], i + 1, COLORS[i]);
      this.pairs[i].setObserver(pairDesigner);
      eventManager.addObserver(new EventManagerPairDesignerObserver(pairDesigner));
      
      this.pairDesigners[i] = pairDesigner;
   }
   
   ArrayResize(this.currencies, this.nCurrencies);
   ArrayResize(this.currencyDesigners, this.nCurrencies);
   
   for (int i = 0; i < this.nCurrencies; i++) {
      this.currencies[i] = Currency(CURRENCIES[i], this.nCurrencies - 1);
      
      CurrencyDesigner *currencyDesigner = new CurrencyDesigner(CURRENCIES[i], i + 1);
      this.currencies[i].setObserver(currencyDesigner);
      eventManager.addObserver(new EventManagerCurrencyDesignerObserver(currencyDesigner));
      
      this.currencyDesigners[i] = currencyDesigner;
   }
   
   this.currentFilter = "";
}

void Ranker::update(string symbol, double value) {
   int pairIndex = this.findPairIndex(symbol);
   
   if (pairIndex != -1) {
      double slope = this.calculateSlope(pairIndex);
      this.pairs[pairIndex].updateScore(value, slope);
   }
   
   string baseCurrencySymbol = StringSubstr(symbol, 0, 3);
   int baseCurrencyIndex = this.findCurrencyIndex(baseCurrencySymbol);
   
   string quoteCurrencySymbol = StringSubstr(symbol, 3, 3);
   int quoteCurrencyIndex = this.findCurrencyIndex(quoteCurrencySymbol);
   
   if (baseCurrencyIndex != -1 && quoteCurrencyIndex != -1) {
      this.currencies[baseCurrencyIndex].updateScore(quoteCurrencySymbol, value);
      this.currencies[quoteCurrencyIndex].updateScore(baseCurrencySymbol, -value);
   }
}

void Ranker::postUpdate() {
   for (int i = 0; i < this.nCurrencies; i++) {
      this.currencies[i].updatePairGroup();
   }

   double scores[];
   ArrayResize(scores, this.nPairs);
   
   for (int i = 0; i < this.nPairs; i++) {
      scores[i] = MathAbs(this.pairs[i].score);
   }
   
   ArraySort(scores);
   
   for (int i = 0; i < this.nPairs; i++) {
      int index = ArrayBsearch(scores, MathAbs(this.pairs[i].score));
      
      this.pairDesigners[i].setPosition(this.nPairs - index);
   }
   
   ArrayResize(scores, this.nCurrencies);
   
   for (int i = 0; i < this.nCurrencies; i++) {
      scores[i] = this.currencies[i].score();
   }
   
   ArraySort(scores);
   
   for (int i = 0; i < this.nCurrencies; i++) {
      int index = ArrayBsearch(scores, this.currencies[i].score());
      
      this.currencyDesigners[i].setPosition(this.nCurrencies - index);
   }
}

void Ranker::filterCurrency(string symbol) {
   string filter = symbol == this.currentFilter ? "" : symbol;
   this.currentFilter = filter;

   for (int i = 0; i < this.nPairs; i++) {
      this.pairDesigners[i].filter(filter);
   }
   
   for (int i = 0; i < this.nCurrencies; i++) {
      this.currencyDesigners[i].filter(filter);
   }
}

int Ranker::findPairIndex(string symbol) {
   for (int i = 0; i < this.nPairs; i++) {
      if (StringCompare(this.pairs[i].symbol, symbol) == 0) {
         return i;
      }
   }
   
   return -1;
}

int Ranker::findCurrencyIndex(string symbol) {
   for (int i = 0; i < this.nCurrencies; i++) {
      if (StringCompare(this.currencies[i].symbol, symbol) == 0) {
         return i;
      }
   }
   
   return -1;
}

double Ranker::calculateSlope(int pairIndex) {
   int slopePeriod = Input_PairSlopePeriod;
   int slopeSum = (slopePeriod + 1) * (slopePeriod / 2);

   double slope = 0.0;

   int n = Bars - IndicatorCounted() - 1;
   int i = 0;

   if (Bars < (slopePeriod + 1)) return slope;
   
   int weight = slopePeriod;
   while (i < slopePeriod) {
      double value     = pairBuffers[pairIndex].buffer[i];
      double nextValue = pairBuffers[pairIndex].buffer[i + 1];

      slope += (value - nextValue) * weight;
      
      i++;
      weight--;
   }
   
   return MathArctan(slope / slopeSum) / M_PI * 180;
}