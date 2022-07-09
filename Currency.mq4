Currency::Currency(string newSymbol, int maxScores) {
   this.symbol = newSymbol;
   
   ArrayResize(this.scores, maxScores);
   this.nScores = 0;
}

void Currency::updateScore(string otherSymbol, double value) {
   int scoreIndex = this.findScoreIndex(otherSymbol);
   
   if (scoreIndex == -1) {
      this.scores[this.nScores++] = Score(otherSymbol, value);
   } else {
      this.scores[scoreIndex].value = value;
   }

   if (CheckPointer(this.observer) == POINTER_INVALID) {
      Print("[Currency]: " + this.symbol + " has invalid pointer.");
   } else {
      this.observer.update(this.score());
   }
}

double Currency::score() {
   double value = 0;
   
   for (int i = 0; i < this.nScores; i++) {
      value += this.scores[i].value;
   }
   
   return value;
}

void Currency::setObserver(CurrencyDesigner *o) {
   this.observer = o;
}

void Currency::updatePairGroup() {
   this.pairsUp = this.pairsDown = 0;

   for (int i = 0; i < this.nScores; i++) {
      if (this.scores[i].value > Input_StrengthThreshold) {
         this.pairsUp++;
      }
      
      if (this.scores[i].value < Input_StrengthThreshold * -1) {
         this.pairsDown++;
      }
   }
   
   this.observer.updatePairGroup(this.pairsUp, this.pairsDown);
}

int Currency::findScoreIndex(string otherSymbol) {
   for (int i = 0; i < this.nScores; i++) {
      if (StringCompare(this.scores[i].symbol, otherSymbol) == 0) {
         return i;
      }
   }
   
   return -1;
}
