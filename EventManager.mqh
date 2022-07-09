#include "PairDesigner.mqh"
#include "CurrencyDesigner.mqh"

class EventManagerObserver {
   public:
   
   string virtual getName() = 0;
   void virtual click() = 0;
};

class EventManagerPairDesignerObserver : public EventManagerObserver {
   public:
   
   PairDesigner* observer;
   
   EventManagerPairDesignerObserver(PairDesigner*);
   
   string getName();
   void click();
};

class EventManagerCurrencyDesignerObserver : public EventManagerObserver {
   public:
   
   CurrencyDesigner* observer;
   
   EventManagerCurrencyDesignerObserver(CurrencyDesigner*);
   
   string getName();
   void click();
};

class EventManager {
   public:
   
   EventManagerObserver *observers[];
   int nObservers;
   
   EventManager();
   ~EventManager();
   
   void addObserver(EventManagerObserver*);
   void OnChartEvent(const int, const long&, const double&, const string&);
};