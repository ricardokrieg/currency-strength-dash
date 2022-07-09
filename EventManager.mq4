#include "EventManager.mqh"

EventManager::EventManager() {
   ArrayResize(this.observers, N_BUFFERS);
   this.nObservers = 0;
}

EventManager::~EventManager() {
   for (int i = 0; i < this.nObservers; i++) {
      delete this.observers[i];
   }
}

void EventManager::OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   if (id == CHARTEVENT_OBJECT_CLICK) {
      for (int i = 0; i < this.nObservers; i++) {
         EventManagerObserver *observer = this.observers[i];
      
         if (observer.getName() == sparam) {
            observer.click();
            return;
         }
      }
   }
}

void EventManager::addObserver(EventManagerObserver *observer) {
   this.observers[this.nObservers++] = observer;
}

//=======================================================================================================

EventManagerPairDesignerObserver::EventManagerPairDesignerObserver(PairDesigner *o) {
   this.observer = o;
}

string EventManagerPairDesignerObserver::getName() {
   return this.observer.symbolID;
}

void EventManagerPairDesignerObserver::click() {
   long chartId = ChartOpen(this.observer.symbol, Input_OpenChartTimeFrame);
   
   if (chartId == 0) {
      Print("Error: Failed to open chart " + this.observer.symbol);
      return;
   }
   
   if (Input_OpenChartTemplate != "") {
      if (!ChartApplyTemplate(chartId, Input_OpenChartTemplate)) {
         Print("Error: Failed to load template " + Input_OpenChartTemplate);
      }
   }
}

//=======================================================================================================

EventManagerCurrencyDesignerObserver::EventManagerCurrencyDesignerObserver(CurrencyDesigner *o) {
   this.observer = o;
}

string EventManagerCurrencyDesignerObserver::getName() {
   return this.observer.symbolID;
}

void EventManagerCurrencyDesignerObserver::click() {
   ranker.filterCurrency(this.observer.symbol);
}