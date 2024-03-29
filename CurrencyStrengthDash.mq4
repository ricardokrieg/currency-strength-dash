//+------------------------------------------------------------------+
//|                                           Currency Strength Dash |
//|                  Copyright 2020, George Olulana & Ricardo Franco |
//+------------------------------------------------------------------+

#define N_PAIR_BUFFERS 28
#define N_CURRENCY_BUFFERS 8
#define N_BUFFERS N_PAIR_BUFFERS + N_CURRENCY_BUFFERS + N_PAIR_BUFFERS + (2* N_CURRENCY_BUFFERS)
#define SHORT_NAME "CurrencyStrengthDash"

#property strict
#property indicator_buffers N_PAIR_BUFFERS

#include "Constants.mqh"
#include "Types.mqh"

#include "Buffer.mqh"
#include "Currency.mqh"
#include "CurrencyDesigner.mqh"
#include "Pair.mqh"
#include "PairDesigner.mqh"
#include "Ranker.mqh"
#include "Score.mqh"
#include "EventManager.mqh"

input int Input_LongTermMode = 0; // Long Term Mode
input int Input_TimeOffset   = 0; // Time Offset
input int Input_DaySpan      = 1; // Day Span

input int Input_PairSlopePeriod = 10; // Pair Slope Period
input int Input_ArrowUpThreshold = 80; // Arrow Up/Down Threshold
input int Input_ArrowAlmostUpThreshold = 45; // Arrow Almost Up/Down Threshold

input double Input_StrengthThreshold = 15; // Strength Threshold

sinput int Input_CurrencyXMargin  = 20;  // Currency X Margin
sinput int Input_CurrencyXPadding = 10;  // Currency X Padding
sinput int Input_CurrencyYMargin  = 0; // Currency Y Margin
sinput int Input_CurrencyYPadding = 20;  // Currency Y Padding
sinput int Input_CurrencyFontSize = 10;  // Currency Font Size

sinput int Input_PairXMargin  = 180; // Pair X Margin
sinput int Input_PairXPadding = 10;  // Pair X Padding
sinput int Input_PairYMargin  = 0; // Pair Y Margin
sinput int Input_PairYPadding = 20;  // Pair Y Padding
sinput int Input_PairFontSize = 10;  // Pair Font Size

sinput color Input_PositiveColor = clrLimeGreen; // Positive Color
sinput color Input_NegativeColor = clrTomato;    // Negative Color

sinput ENUM_TIMEFRAMES Input_OpenChartTimeFrame = PERIOD_CURRENT; // Time Frame for Open Chart
sinput string Input_OpenChartTemplate = ""; // Template for Open Chart

Buffer pairBuffers[N_PAIR_BUFFERS];
int nPairBuffers = 0;
Buffer currencyBuffers[N_CURRENCY_BUFFERS];
int nCurrencyBuffers = 0;
Buffer slopeBuffers[N_PAIR_BUFFERS];
int nSlopeBuffers = 0;
Buffer pairsUpBuffers[N_CURRENCY_BUFFERS];
int nPairsUpBuffers = 0;
Buffer pairsDownBuffers[N_CURRENCY_BUFFERS];
int nPairsDownBuffers = 0;

int pairsBaseIndex      = 0;
int currenciesBaseIndex = pairsBaseIndex + N_PAIR_BUFFERS;
int slopesBaseIndex     = currenciesBaseIndex + N_CURRENCY_BUFFERS;
int pairsUpBaseIndex    = slopesBaseIndex + N_PAIR_BUFFERS;
int pairsDownBaseIndex  = pairsUpBaseIndex + N_CURRENCY_BUFFERS;

int window = WindowFind(SHORT_NAME);

Ranker ranker = Ranker();
EventManager eventManager = EventManager();

int OnInit() {
   IndicatorBuffers(N_BUFFERS);
   IndicatorDigits(2);
   IndicatorShortName(SHORT_NAME);
   
   if (Input_StrengthThreshold != 0) {
      SetLevelValue(0, Input_StrengthThreshold);
      IndicatorSetString(INDICATOR_LEVELTEXT, 0, "Strength Up Threshold");
      SetLevelValue(1, Input_StrengthThreshold * -1);
      IndicatorSetString(INDICATOR_LEVELTEXT, 1, "Strength Down Threshold");
   }
   
   int nPairs      = sizeof(PAIRS) / sizeof(PAIRS[0]);
   int nCurrencies = sizeof(CURRENCIES) / sizeof(CURRENCIES[0]);

   for (int i = 0; i < nPairs; i++) {
      if (i >= N_PAIR_BUFFERS) break;
   
      string symbolName = PAIRS[i];
      
      pairBuffers[i].set(i + pairsBaseIndex, symbolName);
      nPairBuffers = i + 1;

      slopeBuffers[i].set(i + slopesBaseIndex, symbolName);
      nSlopeBuffers = i + 1;
   }
   
   for (int i = 0; i < nCurrencies; i++) {
      if (i >= N_CURRENCY_BUFFERS) break;
   
      string symbolName = CURRENCIES[i];
      
      currencyBuffers[i].set(i + currenciesBaseIndex, symbolName, false);
      nCurrencyBuffers = i + 1;
      
      pairsUpBuffers[i].set(i + pairsUpBaseIndex, symbolName, false);
      nPairsUpBuffers = i + 1;
      
      pairsDownBuffers[i].set(i + pairsDownBaseIndex, symbolName, false);
      nPairsDownBuffers = i + 1;
   }
   
   ranker.initialize(nPairs, nCurrencies);

   return(INIT_SUCCEEDED);
}

int start() {
   int i = Bars - IndicatorCounted() - 1;
   
   while (i >= 0) {
      datetime t1 = Time[i];
      // datetime t2 = (datetime)(MathFloor(t1 / 86400) * 86400);
      int daySeconds = Input_DaySpan * 86400;
      int timeOffsetSeconds = Input_TimeOffset * 60 * 60;
      datetime t2 = (datetime)MathFloor((Time[i] + timeOffsetSeconds) / daySeconds) * daySeconds - timeOffsetSeconds;
      
      if (TimeDayOfWeek(t2) == 0) {
         t2 -= 2 * 24 * 60 * 60;
      }
      
      if (Input_LongTermMode > 0) {
         t2 = Time[Input_LongTermMode];
      }
      
      for (int j = 0; j < nPairBuffers; j++) {
         string symbol = pairBuffers[j].symbol;
         double value = getVal(symbol, t1, t2);

         ranker.update(symbol, value);
         
         pairBuffers[j].buffer[i] = value;
         slopeBuffers[j].buffer[i] = ranker.pairs[j].slope;
      }
      
      if (i == 0) {
         ranker.postUpdate();

         for (int c = 0; c < nCurrencyBuffers; c++) {
            currencyBuffers[c].buffer[i] = ranker.currencies[c].score();
            
            pairsUpBuffers[c].buffer[i] = ranker.currencies[c].pairsUp;
            pairsDownBuffers[c].buffer[i] = ranker.currencies[c].pairsDown;
         }
      }
      
      i--;
   }

   return(0);
}

void OnDeinit(const int reason) {
   ObjectsDeleteAll(window, SHORT_NAME);
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   eventManager.OnChartEvent(id, lparam, dparam, sparam);
}

double getVal(string sym, datetime t1, datetime t2){
   if (t1 == t2) return EMPTY_VALUE;

   double v1 = iClose(sym, 0, iBarShift(sym, 0, t1));
   double v2 = iClose(sym, 0, iBarShift(sym, 0, t2));

   if (v2 == 0) return(0);
   
   return(MathLog(v1 / v2) * 10000);
}
