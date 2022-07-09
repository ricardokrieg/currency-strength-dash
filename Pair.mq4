#include "Pair.mqh"

Pair::Pair(string newSymbol, double newScore) {
   this.symbol = newSymbol;
   this.score  = newScore;
}

void Pair::updateScore(double value, double s) {
   this.score = value;
   this.slope = s;
   
   if (CheckPointer(this.observer) == POINTER_INVALID) {
      Print("[Pair]: " + this.symbol + " has invalid pointer.");
   } else {
      this.observer.update(this.score, this.slope);
   }
}

void Pair::setObserver(PairDesigner *o) {
   this.observer = o;
}
