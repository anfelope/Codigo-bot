//+------------------------------------------------------------------+
//|                                                         BOOM1000 |
//|                                           Copyright 2021, YUSAN. |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, YUSAN"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include <Trade/Trade.mqh>
CTrade   Trade;
CPositionInfo  m_position;                   // object of CPositionInfo class

input group    "VARIABLES GENERALES"
input int      InEMA1         =  45;      // EMA1
input int      InEMA2         =  253;     // EMA2
input int      InEMA3         =  101;     // EMA3
input int      InEMA4         =  290;     // EMA4
input int      InpMagicNumber =  071115;  //Magic Number

input group    "VARIABLES BUY"
input double   Inpsizebuy        =  0.3;    //Trade Volume
input double   InTPbuy           =  45;      // Profit Buy:
input double   InTPmaxnobuy      =  60;      // Profit Maximo no Buy:
input double   InTPmaxbuy        =  105;     // Asegura max Profit Buy:
input double   InLoss1buy        =  -10.5;    // Maxima perdida1 buy:
input double   InLoss2buy        =  -35.5;    // Maxima perdida2 buy:
input int      InIncEMA1buy      =  15;      // Inclinacion EMA1 buy:
input double   InIncEMA3buy      =  25;      // Inclinacion EMA3 buy:
input double   InTamanoNTbuy     =  12;      // Tamaño Vela NoTrade: - 20
input double   InTamanoVelaSL    =  4.5;     // Tamaño de la Vela Venta SL:

input group    "VARIABLES REFERENCIA"
input double   InRefEMA2EMA1buy  =  10;    // Referencia EMA2-EMA1 buy:

input group    "VARIABLES SELL"
input double   Inpsizesell    =  0.2;  //Trade Volume
input double   InTPsell       =  73.33333334;   // Profit Sell:
input double   InLosssell     =  -0.4; // Lost Sell:
input int      InPCMA1dis     =  85;    // Distancia PC - MA1
input double   InIncEMA1sell  =  7;   // Inclinacion EMA1 sell
input double   InIncEMA2sell  =  0;    // Inclinacion EMA2 sell
input double   InIncEMA3sell  =  0;    // Inclinacion EMA3 sell

// Variables SELL
double   PriceCurrentsell = 0;
double   PriceOpensell  = 0;
double   Angulosellm1   = 0;
double   Angulosellm2   = 0;
double   Angulosellm3   = 0;
double   Angulosellm4   = 0;
double   closeSell      = 0;
double   openSell       = 0;
double   openSell1      = 0;
double   MA1opens       = 0;
double   MA2opens       = 0;
double   MA3opens       = 0;
double   MA4opens       = 0;
double   SLsell         = 0;

string   Comment4       = "Sell-OPEN_0";     // Comment
string   Comment5       = "Sell-OPEN_1";     // Comment
string   Comment6       = "Sell-OPEN_2";     // Comment

int      SpikeSellCount = 0;
int      NoTradeSell    = 0;
int      SellCount      = 0;
int      ejeminsell     = 0;
int      ejemin2        = 0;
int      valvmax        = 0;
int      SO0            = 0;
int      SO1            = 0;
int      SO2            = 0;

// Variables BUY
double   PriceCurrentbuy = 0;
double   PriceOpenbuy   = 0;
double   Angulobuym1    = 0;
double   Angulobuym2    = 0;
double   Angulobuym3    = 0;
double   Angulobuym4    = 0;
double   openBuy        = 0;
double   MA1open        = 0;
double   MA2open        = 0;
double   MA3open        = 0;
double   MA4open        = 0;
double   SLbuy          = 0;

string   Comentario     = "0";
string   Comment0       = "BUY-OPEN_0";     // Comment
string   Comment1       = "BUY-OPEN_1";     // Comment
string   Comment2       = "BUY-OPEN_2";     // Comment
string   Comment3       = "BUY-OPEN_3";     // Comment
string   Comment8       = "BUY-OPEN_4";     // Comment

int      SpikeBuyCount  = 0;
int      NoTradeBuy     = 0;
int      NoTrade        = 0;
int      NoTrade1       = 0;
int      BuyCount       = 0;
int      ejemin1        = 0;
int      ntbo4          = 0;
int      BO0            = 0;
int      BO1            = 0;
int      BO2            = 0;
int      BO3            = 0;
int      BO4            = 0;

// Variables generales
double   InVresm1       = 3;        // VresMA1 buy
double   InVresm1Sell   = 3;        // VresMA1 Sell
double   InVresm2       = 1;        // VresMA2 buy
double   InVresm2Sell   = 3;        // VresMA2 Sell
double   InVresm3       = 1;        // VresMA3 buy
double   InVresm3Sell   = 3;        // VresMA3 Sell
double   InVresm4       = 1;        // VresMA4 buy
double   InVresm4Sell   = 3;        // VresMA4 Sell

double   PriceCurrent   = 0;
double   openCountBO4   = 0;
double   openCount      = 0;
double   TamanoCO       = 0;
double   Bajam1m4       = 0;
double   Subem4m1       = 0;
double   Vresm1         = 0;
double   Vresm2         = 0;
double   Vresm3         = 0;
double   Vresm4         = 0;
double   close          = 0;
double   open           = 0;
double   Vmax           = 0;
double   Vmin           = 0;

int      all_positions  = 0;
int      SpikeCountBO4  = 0;
int      SpikeCount     = 0;
int      minutos        = 0;
int      ejemin         = 0;
int      shift          = 0;
int      Tendb          = 0;
int      Tends          = 0;
int      M14            = 0;
int      M41            = 0;
int      nt             = 0;

// Promedios Moviles
double   MA1[];         // array for the indicator iMA
int      MA1_handle;    // handle of the indicator iMA
double   MA2[];         // array for the indicator iMA
int      MA2_handle;    // handle of the indicator iMA
double   MA3[];         // array for the indicator iMA
int      MA3_handle;    // handle of the indicator iMA
double   MA4[];         // array for the indicator iMA
int      MA4_handle;    // handle of the indicator iMA

// Variables de Tiempo
int      NewBar         = 0;
int      NewBar1        = 0;
int      NewBar2        = 0;
int      NewBar3        = 0;
int      NewBar4        = 0;
int      NewBar5        = 0;
int      NewBar6        = 0;

MqlDateTime stm;
datetime tm=0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   MA1_handle=iMA(Symbol(),0,InEMA1,0,MODE_SMA,PRICE_WEIGHTED);
   MA2_handle=iMA(Symbol(),0,InEMA2,0,MODE_LWMA,PRICE_LOW);
   MA3_handle=iMA(Symbol(),0,InEMA3,0,MODE_SMA,PRICE_CLOSE);
   MA4_handle=iMA(Symbol(),0,InEMA4,0,MODE_SMA,PRICE_CLOSE);
   Trade.SetExpertMagicNumber(InpMagicNumber);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//posicion();

   tm=TimeCurrent(stm);
   NewBar=stm.min;

   if((minutos!=stm.min)==true)
     {
      minutos=stm.min;
      ejemin++;
     }

   if(CopyBuffer(MA1_handle,0,0,100,MA1)<=0)
      return;
   ArraySetAsSeries(MA1,true);
   if(CopyBuffer(MA2_handle,0,0,100,MA2)<=0)
      return;
   ArraySetAsSeries(MA2,true);
   if(CopyBuffer(MA3_handle,0,0,100,MA3)<=0)
      return;
   ArraySetAsSeries(MA3,true);
   if(CopyBuffer(MA4_handle,0,0,100,MA4)<=0)
      return;
   ArraySetAsSeries(MA4,true);

   Vmax=mayor(MA1[0],MA2[0],MA3[0],MA4[0]);
   Vmin=menor(MA1[0],MA2[0],MA3[0],MA4[0]);

   Vresm1=(MA1[ArrayMaximum(MA1,10,60)]-MA1[ArrayMinimum(MA1,0,50)]);
   Vresm2=(MA2[ArrayMaximum(MA2)]-MA2[ArrayMinimum(MA2)]);
   Vresm3=(MA3[ArrayMaximum(MA3)]-MA3[ArrayMinimum(MA3)]);
   Vresm4=(MA4[ArrayMaximum(MA4,20,70)]-MA4[ArrayMinimum(MA4,0,70)]);

   PriceCurrent = (((SymbolInfoDouble(Symbol(), SYMBOL_BID))+(SymbolInfoDouble(Symbol(), SYMBOL_ASK)))/2);

   if(((BuyCount==1)||(BO4==1))==true)
     {
      Angulobuym1 = RadToDegrees(MathArctan2((PriceCurrent-MA1open),(ejemin-ejemin1)));
      Angulobuym2 = RadToDegrees(MathArctan2((MA2[0]-MA2open),(ejemin-ejemin1)));
      Angulobuym3 = RadToDegrees(MathArctan2((MA3[0]-MA3open),(ejemin-ejemin1)));
      Angulobuym4 = RadToDegrees(MathArctan2((MA4[0]-MA4open),(ejemin-ejemin1)));
     }

   if(((SellCount==1))==true)
     {
      Angulosellm1 = RadToDegrees(MathArctan2((PriceCurrent-MA1opens),(ejemin-ejemin2)));
      Angulosellm2 = RadToDegrees(MathArctan2((MA2[0]-MA2opens),(ejemin-ejemin2)));
      Angulosellm3 = RadToDegrees(MathArctan2((MA3[0]-MA3opens),(ejemin-ejemin2)));
      Angulosellm4 = RadToDegrees(MathArctan2((MA4[0]-MA4opens),(ejemin-ejemin2)));
     }

   all_positions=CalculateAllPositions(Comment0);
   if((all_positions==0)==true)
     {
      all_positions=CalculateAllPositions(Comment1);
      if((all_positions==0)==true)
        {
         all_positions=CalculateAllPositions(Comment2);
         if((all_positions==0)==true)
           {
            all_positions=CalculateAllPositions(Comment3);
            if((all_positions==0)==true)
              {
               SpikeBuyCount=0;
               PriceOpenbuy=0;
               SpikeCount=0;
               BuyCount=0;
               BO0=0;
               BO1=0;
               BO2=0;
               BO3=0;
               nt=0;
               all_positions=CalculateAllPositions(Comment4);
               if((all_positions==0)==true)
                 {
                  all_positions=CalculateAllPositions(Comment5);
                  if((all_positions==0)==true)
                    {
                     all_positions=CalculateAllPositions(Comment6);
                     if((all_positions==0)==true)
                       {
                        PriceOpensell=0;
                        SellCount=0;
                        valvmax=0;
                        SO0=0;
                        SO1=0;
                        SO2=0;
                       }
                    }
                 }
              }
           }
        }
     }

   all_positions=CalculateAllPositions(Comment8);
   if((all_positions==0)==true)
     {
      ntbo4=0;
      BO4=0;
     }

   if((Vmax==MA1[0])&&(Vmin==MA4[0])&&(close>MA3[0]))
     {
      NoTradeBuy=0;
     }

   int      count          =  PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket   =  PositionGetTicket(i);
      valpositionbuy();
      if((ticket>0)==true)
        {
         if(((close>open)&&(NewBar1!=NewBar))==true)
           {
            if(((PriceOpenbuy>PriceCurrentbuy)&&((PriceCurrentbuy-PriceOpenbuy)<-0.5)&&(MA2[0]>MA1[0])&&(Vmin==MA4[0])&&(close>MA4[0])&&((PriceCurrentbuy-open)<InTamanoNTbuy)&&(BO3==0))==true)
              {
               ApplyTrailingStopClose(Symbol(), InpMagicNumber, "**No Trade close");
               if(((PriceCurrentbuy-PriceOpenbuy)<-15)==true)
                 {
                  NoTrade1=1;
                 }
              }
           }
         if(((MA1[0]>MA2[0])&&(MA3[0]>MA2[0]))==true)
           {
            NoTrade1=0;
           }
        }
     }


//Cuenta Spikes en la venta
   valpositionsell();
   if(((close>open)&&(NewBar2!=NewBar)&&(SellCount==1))==true)
     {
      tm=TimeCurrent(stm);
      NewBar2=stm.min;
      SpikeSellCount++;
      openSell=open;
      closeSell=close;
     }
   else
      if((openSell>close)==true)
        {
         SpikeSellCount=0;
        }

//Cuenta Spikes en la compra
   valpositionbuy();
   if(((close>open)&&(NewBar3!=NewBar)&&((BuyCount==1)))==true)
     {
      tm=TimeCurrent(stm);
      NewBar3=stm.min;
      openBuy=open;
      SpikeBuyCount++;
     }

//Cuenta Spikes
   close = iClose(Symbol(),PERIOD_CURRENT,shift);
   open  = iOpen(Symbol(),Period(),shift);
   if(((close>open)&&(NewBar4!=NewBar)&&(SellCount==1))==true)
     {
      tm=TimeCurrent(stm);
      NewBar4=stm.min;
      SpikeCount++;
      openCount=open;
     }
   else
      if(((openCount>close))==true)
        {
         SpikeCount=0;
        }

//Cuenta Spikes
   close = iClose(Symbol(),PERIOD_CURRENT,shift);
   open  = iOpen(Symbol(),Period(),shift);
   if(((close>open)&&(NewBar5!=NewBar)&&(BuyCount==1))==true)
     {
      tm=TimeCurrent(stm);
      NewBar5=stm.min;
      SpikeCount++;
      openCount=open;
     }
   else
      if(((openCount>close))==true)
        {
         SpikeCount=0;
        }

//Cuenta Spikes
   close = iClose(Symbol(),PERIOD_CURRENT,shift);
   open  = iOpen(Symbol(),Period(),shift);
   if(((close>open)&&(NewBar6!=NewBar)&&(BO4==1))==true)
     {
      tm=TimeCurrent(stm);
      NewBar6=stm.min;
      SpikeCountBO4++;
      openCountBO4=open;
     }
   else
      if(((BO4==0))==true)
        {
         SpikeCountBO4=0;
        }

   if((close>open)==true)
     {
      TamanoCO = (close-open);
     }

   if(((MA2[0]>MA1[0])&&(MA2[0]>MA3[0])&&(MA3[0]>MA1[0]))==true)
     {
      NoTrade=0;
     }

   if(((NoTradeSell==1)&&((NoTrade==1)||(NoTrade1==1)))==true)
     {
      NoTradeSell=0;
     }

   if(((NoTradeSell==1)&&((NoTradeBuy==1)))==true)
     {
      NoTradeBuy=0;
     }

   if(((MA1[0]>MA3[0])&&(MA3[0]>MA2[0])&&(MA2[0]>MA4[0]))||(Tendb==1))
     {
      Tendb=1;
      if((Vmin==MA1[0])&&(Vmax==MA4[0]))
        {
         Bajam1m4=MA4[0];
         Tendb=0;
        }
     }

   if(((MA1[0]<MA3[0])&&(MA3[0]<MA2[0])&&(MA2[0]<MA4[0]))||(Tends==3))
     {
      Tends=3;
      if((Vmax==MA1[0])&&(Vmin==MA4[0]))
        {
         Subem4m1=MA4[0];
         ejeminsell=ejemin;
         Tends=0;
        }
     }

   PriceCurrent = (((SymbolInfoDouble(Symbol(), SYMBOL_BID))+(SymbolInfoDouble(Symbol(), SYMBOL_ASK)))/2);

   valpositionsell();
   if(((Bajam1m4-PriceCurrent)>90)&&(Bajam1m4!=0))
     {
      NoTradeSell=1;
      if((MA1[0]>MA4[0]))
        {
         NoTradeSell=0;
        }
     }

   valpositionbuy();
   if(((PriceCurrent-Subem4m1)>90)&&(Subem4m1!=0))
     {
      NoTradeBuy=1;
      if((MA4[0]>MA1[0]))
        {
         NoTradeBuy=0;
        }
     }

   Comment(StringFormat("Show prices\nNewBar = %G\nNoTrade = %G\nNoTrade1 = %G\nNoTradeBuy = %G\nNoTradeSell = %G\nCountSell = %G\nCountBuy = %G\nSpikeCount = %G\nSpikeSellCount = %G\nIncEMA1sell 15 = %G\nIncEMA2sell 0 = %G\nIncEMA3sell 0 = %G\n(MA4[24]-MA4[0]) = %G\nAngulobuym1 = %G\nBajam1m4 = %G\nSubem4m1 = %G\nB = %G\nS = %G\nPriceCurrent = %G\nVresm4 = %G\nnt = %G",stm.min,NoTrade,NoTrade1,NoTradeBuy,NoTradeSell,SellCount,BuyCount,SpikeCount,SpikeSellCount,(MA1[49]-MA1[0]),(MA2[25]-MA2[0]),(MA3[99]-MA3[0]),(MA4[24]-MA4[0]),Angulobuym1,Bajam1m4,Subem4m1,(Bajam1m4-PriceCurrent),(PriceCurrent-Subem4m1),PriceCurrent,Vresm4,nt));

//*************************************** ABRE BUY **************************************************//
   valpositionbuy();
   if((((MA3[99]-MA3[0])<InIncEMA3buy)&&(Vresm4>InVresm4)&&(Vresm1>InVresm1)&&(Vresm2>InVresm2)&&(Vresm3>InVresm3)&&(NoTrade1==0)&&(NoTrade==0)&&(((MA1[0]<close)||(MA2[0]<=close))&&(MA1[0]>MA1[3]))&&(close>open)&&((MA1[0]>MA2[0])||(MA2[0]<=close))&&(MA1[0]>MA1[InIncEMA1buy])&&((MA2[0]-MA1[0])<InRefEMA2EMA1buy)&&((MA1[0]-MA4[0])<100)&&(NoTradeBuy==0)&&(NewBar1!=NewBar))==true)
     {
      CreateTradesbuy(Symbol(), NormalizeDouble(Inpsizebuy,1), InpMagicNumber, "BUY-OPEN_0");
     }

   if(((MA4[0]>MA2[0])&&(MA2[0]>MA1[0])&&(MA1[0]>MA3[0])&&(close>open)&&(NoTradeBuy==0)&&(NewBar1!=NewBar)&&((MA1[49]-MA1[0])<-10))==true)
     {
      CreateTradesbuy(Symbol(), NormalizeDouble(Inpsizebuy,1), InpMagicNumber, "BUY-OPEN_3");
     }

   valpositionbuy();
   if(((Vmax<close)&&(Vmin>open)&&(close>open)&&(NewBar1!=NewBar)&&((Vmax-Vmin)<25))==true)
     {
      if(((PriceOpensell-PriceCurrentsell)>0)&&(SellCount==1))
        {
         ApplyTrailingStopsell(Symbol(), InpMagicNumber, "Sell-CLOSE-12");
        }
      CreateTradesbuy(Symbol(), NormalizeDouble(Inpsizebuy,1), InpMagicNumber, "BUY-OPEN_4");
     }

//*************************************** CIERRA BUY **************************************************//

   Cerrarbuy();

//*************************************** ABRE SELL **************************************************//

   valpositionsell();
   if(((((MA4[0]>MA1[0])&&((MA4[24]-MA4[0])>0)&&((MA3[99]-MA3[0])>InIncEMA3sell)&&((MA2[25]-MA2[0])>InIncEMA2sell)&&((MA1[49]-MA1[0])>InIncEMA1sell)&&(MA1[0]>close)))&&((Vresm4>InVresm4Sell)||((Vmax==MA4[0])&&(Vresm4>2)))&&(Vresm2>InVresm2Sell)&&(Vresm3>InVresm3Sell)&&(Vresm1>InVresm1Sell)&&(NoTradeSell==0))==true)
     {
      CreateTradessell(Symbol(), NormalizeDouble(Inpsizesell,1), InpMagicNumber, "Sell-OPEN_0");
      ApplyTrailingStopSLSell(Symbol(), InpMagicNumber, MA4[0], "Sell-SL-0");
     }

   valpositionsell();
   if(((((MA1[0]>MA2[0])&&(MA3[0]>MA1[0])&&(MA1[0]>close)))&&(Vresm4>2.1)&&(BuyCount==0))==true)
     {
      if((((PriceCurrentbuy-PriceOpenbuy)<0)||((PriceCurrentbuy-PriceOpenbuy)>30))&&(BO4==1))
        {
         ApplyTrailingStopClose(Symbol(), InpMagicNumber, "BUY-CLOSE-10");
        }
      CreateTradessell(Symbol(), NormalizeDouble(Inpsizesell,1), InpMagicNumber, "Sell-OPEN_1");
      ApplyTrailingStopSLSell(Symbol(), InpMagicNumber, MA3[0]+10, "Sell-SL-1");
     }

//*************************************** CIERRA SELL **************************************************//
   Cerrarsell();

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateTradesbuy(string symbol, double volume, int magicNumber, string tradeComment)
  {
   int buyCount   = 0;
   int count      = PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket>0)
        {
         if(PositionGetString(POSITION_SYMBOL)==symbol)
           {
            if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_BUY)
               buyCount++;
           }
        }
     }
   if(buyCount==0)
     {
      if(Trade.PositionOpen(symbol, ORDER_TYPE_BUY, volume, SymbolInfoDouble(symbol, SYMBOL_ASK), 0, 0, tradeComment)) {}
      tm=TimeCurrent(stm);
      NewBar1=stm.min;
      NoTradeSell=1;
      BuyCount=1;
      MA1open=MA1[0];
      MA2open=MA2[0];
      MA3open=MA3[0];
      MA4open=MA4[0];
      ejemin1=ejemin;
      nt=0;
      if(tradeComment=="BUY-OPEN_0")
        {
         BO0=1;
        }
      else
         if(tradeComment=="BUY-OPEN_1")
           {
            BO1=1;
           }
         else
            if(tradeComment=="BUY-OPEN_2")
              {
               BO2=1;
              }
            else
               if(tradeComment=="BUY-OPEN_3")
                 {
                  BO3=1;
                 }
               else
                  if(tradeComment=="BUY-OPEN_4")
                    {
                     BO4=1;
                    }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateTradessell(string symbol, double volume, int magicNumber, string tradeComment)
  {
   int sellCount  = 0;
   int count      = PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket>0)
        {
         if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_MAGIC)==magicNumber)
           {
            if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_SELL)
               sellCount++;
           }
        }
     }
   if(sellCount==0)
     {
      if(Trade.PositionOpen(symbol, ORDER_TYPE_SELL, volume, SymbolInfoDouble(symbol, SYMBOL_BID), 0, 0, tradeComment)) {}
      tm=TimeCurrent(stm);
      NewBar1=stm.min;
      MA1opens=MA1[0];
      MA2opens=MA2[0];
      MA3opens=MA3[0];
      MA4opens=MA4[0];
      ejemin2=ejemin;
      NoTradeBuy=1;
      SellCount=1;

      if(tradeComment=="Sell-OPEN_0")
        {
         SO0=1;
        }
      else
         if(tradeComment=="Sell-OPEN_1")
           {
            SO1=1;
           }
         else
            if(tradeComment=="Sell-OPEN_2")
              {
               SO2=1;
              }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  ApplyTrailingStop(string symbol, int magicNumber, string tradeComment)
  {
   int      count          =  PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket   =  PositionGetTicket(i);
      close = iClose(Symbol(),PERIOD_CURRENT,shift);
      valpositionbuy();
      if(((ticket>0)&&(((MA1[0]>=close)&&((PriceCurrentbuy-PriceOpenbuy)>0))||(((PriceCurrentbuy-PriceOpenbuy)<=InLoss1buy)&&(MA3[0]>=MA1[0]))))==true)
        {
         if(PositionGetString(POSITION_SYMBOL)==symbol)
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
              {
               valpositionbuy();
               if(((PriceCurrentbuy-PriceOpenbuy)>=InTPmaxnobuy)==true)
                 {
                  NoTrade = 1;
                  NoTradeSell=0;
                 }

               if((((PriceCurrentbuy-PriceOpenbuy)<=InLoss1buy)&&(MA3[0]>=MA1[0])&&(Vresm4>InVresm4)&&(BO1==1))==true)
                 {
                  CreateTradessell(Symbol(), NormalizeDouble(Inpsizesell,1), InpMagicNumber, "Sell-OPEN_2");
                 }

               Trade.PositionClose(ticket,0, tradeComment);
               BuyCount=0;
               NoTradeSell=0;
               tm=TimeCurrent(stm);
               NewBar1=stm.min;
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  ApplyTrailingStopClose(string symbol, int magicNumber, string tradeComment)
  {
   int      count          =  PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket   =  PositionGetTicket(i);
      if((ticket>0)==true)
        {
         if(PositionGetString(POSITION_SYMBOL)==symbol)
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
              {
               valpositionbuy();
               Trade.PositionClose(ticket,0, tradeComment);
               BuyCount=0;
               NoTradeSell=0;
               tm=TimeCurrent(stm);
               NewBar1=stm.min;
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  ApplyTrailingStopsell(string symbol, int magicNumber, string tradeComment)
  {
   int      count          =  PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket   =  PositionGetTicket(i);
      if(ticket>0)
        {
         if(PositionGetString(POSITION_SYMBOL)==symbol)
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
              {
               Trade.PositionClose(ticket,0, tradeComment);
               NoTrade1=0;
               SellCount=0;
               SpikeSellCount=0;
               tm=TimeCurrent(stm);
               NewBar1=stm.min;
               NoTradeBuy=0;
               valpositionbuy();
               if(((Vmax-Vmin)>30)&&(tradeComment=="Sell-CLOSE-4"))
                 {
                  CreateTradesbuy(Symbol(), NormalizeDouble(Inpsizebuy,1), InpMagicNumber, "BUY-OPEN_1");
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,openCount, "BUY-SL-5");
                 }
               if(((Vmax-Vmin)>30)&&(tradeComment=="Sell-CLOSE-9"))
                 {
                  CreateTradesbuy(Symbol(), NormalizeDouble(Inpsizebuy,1), InpMagicNumber, "BUY-OPEN_2");
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,openCount, "BUY-SL-5");
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void valpositionbuy()
  {
   int      count          =  PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket   =  PositionGetTicket(i);
      if(ticket>0)
        {
         if(PositionGetString(POSITION_SYMBOL)==Symbol())
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
              {
               PriceOpenbuy =  PositionGetDouble(POSITION_PRICE_OPEN);
               close = iClose(Symbol(),PERIOD_CURRENT,shift);
               open  = iOpen(Symbol(),Period(),shift);
               PriceCurrentbuy = SymbolInfoDouble(Symbol(), SYMBOL_BID);
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void valpositionsell()
  {
   int      count          =  PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket   =  PositionGetTicket(i);
      if(ticket>0)
        {
         if(PositionGetString(POSITION_SYMBOL)==Symbol())
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
              {
               PriceOpensell =  PositionGetDouble(POSITION_PRICE_OPEN);
               close = iClose(Symbol(),PERIOD_CURRENT,shift);
               open  = iOpen(Symbol(),Period(),shift);
               PriceCurrentsell = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  ApplyTrailingStopSL(string symbol, int magicNumber, double stopLoss, string tradeComment)
  {

   int      count          =  PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket   =  PositionGetTicket(i);
      if(ticket>0)
        {
         if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_MAGIC)==magicNumber)
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY && (PositionGetDouble(POSITION_SL)==0 || stopLoss>PositionGetDouble(POSITION_SL)))
              {
               Trade.PositionModify(ticket, stopLoss, PositionGetDouble(POSITION_TP), tradeComment);
              }
           }
        }
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  ApplyTrailingStopSLSell(string symbol, int magicNumber, double stopLoss, string tradeComment)
  {
   int      count          =  PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket   =  PositionGetTicket(i);
      if(ticket>0)
        {
         if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_MAGIC)==magicNumber)
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL && (PositionGetDouble(POSITION_SL)==0 || stopLoss<PositionGetDouble(POSITION_SL)))
              {
               Trade.PositionModify(ticket, stopLoss, PositionGetDouble(POSITION_TP), tradeComment);
              }
           }
        }
     }

  }


//+------------------------------------------------------------------+
//| Calculate all positions                                          |
//+------------------------------------------------------------------+
int CalculateAllPositions(const string &comment)
  {
   int total=0;
   for(int i=PositionsTotal()-1; i>=0; i--)
      if(m_position.SelectByIndex(i)) // selects the position by index for further access to its properties
         if(m_position.Comment()==comment)
            total++;
//---
   return(total);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double menor(double a, double b, double c, double d)
  {
   double m=0;
   if((a<b)&&(a<c)&&(a<d))
     {
      m=a;
     }
   else
      if((b<a)&&(b<c)&&(b<d))
        {
         m=b;
        }
      else
         if((c<a)&&(c<b)&&(c<d))
           {
            m=c;
           }
         else
            if((d<a)&&(d<b)&&(d<c))
              {
               m=d;
              }
   return (m);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double mayor(double e, double f, double g, double h)
  {
   double n=0;
   if((e>f)&&(e>g)&&(e>h))
     {
      n=e;
     }
   else
      if((f>e)&&(f>g)&&(f>h))
        {
         n=f;
        }
      else
         if((g>e)&&(g>f)&&(g>h))
           {
            n=g;
           }
         else
            if((h>e)&&(h>f)&&(h>g))
              {
               n=h;
              }
   return (n);
  }
//+------------------------------------------------------------------+
double RadToDegrees(double rad)                 //function name (passed radian value)
  {
   double degree = rad*180/M_PI;                  //actual conversion is done here
   return(degree);                                //value in degrees is returned
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void posicion(void)
  {
//--- buscaremos la posición por el símbolo del gráfico en el que trabaja el EA
   string symbol1=Symbol();
//--- intentar obtener la posición
   bool selected=PositionSelect(symbol1);
   if(selected) // si la posición está seleccionada
     {
      long pos_id            =PositionGetInteger(POSITION_IDENTIFIER);
      double price           =PositionGetDouble(POSITION_PRICE_OPEN);
      ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      long pos_magic         =PositionGetInteger(POSITION_MAGIC);
      Comentario             =PositionGetString(POSITION_COMMENT);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Cerrarbuy()
  {
   int      count          =  PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket   =  PositionGetTicket(i);
      if(ticket>0)
        {
         if(PositionGetString(POSITION_SYMBOL)==Symbol())
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
              {

               valpositionbuy();

               if(((((PriceCurrentbuy-PriceOpenbuy)>25)&&((PriceCurrentbuy-PriceOpenbuy)<45))||(nt==2))==true)
                 {
                  nt=2;
                 }

               //*************************************** BO1 **************************************************//

               if((((MA2[0]>MA1[0]) || ((PriceCurrentbuy-PriceOpenbuy)<InLoss2buy) || ((PriceCurrentbuy-PriceOpenbuy)>InTPbuy))&&(BO0==1)&&(BO4==0))==true)
                 {
                  ApplyTrailingStop(Symbol(), InpMagicNumber, "BUY-CLOSE-6");
                 }

               //*************************************** BO1 **************************************************//

               if(((((PriceCurrentbuy-PriceOpenbuy)>0)&&(close>MA4[0])&&(BO1==1))||(nt==17))==true)
                 {
                  nt=17;
                  SLbuy=(MA2[0]);
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,SLbuy, "BUY-SL-14");
                 }

               if(((((PriceCurrentbuy-PriceOpenbuy)>10) || ((PriceCurrentbuy-PriceOpenbuy)<-0.5))&&(BO1==1))==true)
                 {
                  ApplyTrailingStop(Symbol(), InpMagicNumber, "BUY-CLOSE-7");
                 }

               //*************************************** BO2 **************************************************//

               valpositionbuy();
               if((((PriceCurrentbuy-PriceOpenbuy)>0)&&(BO2==1))==true)
                 {
                  ApplyTrailingStopClose(Symbol(), InpMagicNumber, "BUY-CLOSE-0.1");
                 }

               //*************************************** BO3 **************************************************//

               if(((SpikeCount>=2)&&(SpikeCount<=3)&&((PriceCurrentbuy-PriceOpenbuy)>0)&&(BO3==1))==true)
                 {
                  SLbuy=PriceOpenbuy;
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,SLbuy, "BUY-SL-9");
                 }

               if(((SpikeCount>=3)&&((PriceCurrentbuy-PriceOpenbuy)>0)&&(MA1[0]>PriceOpenbuy)&&(BO3==1))==true)
                 {
                  SLbuy=MA1[0];
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,SLbuy, "BUY-SL-10");
                 }

               if(((((PriceCurrentbuy-PriceOpenbuy)<-25))&&(BO3==1))==true)
                 {
                  ApplyTrailingStopClose(Symbol(), InpMagicNumber, "BUY-CLOSE-4");
                 }

               //*************************************** BO4 **************************************************//


               if(((((PriceCurrentbuy-PriceOpenbuy)<-30)||((MA4[0]==Vmax)&&(PriceCurrentbuy<MA1[0])))&&(BO4==1))==true)
                 {
                  ApplyTrailingStop(Symbol(), InpMagicNumber, "BUY-CLOSE-2");
                 }

               if(((SpikeCountBO4>=3)&&((PriceCurrentbuy-PriceOpenbuy)>55)&&(BO4==1))==true)
                 {
                  SLbuy=(PriceOpenbuy);
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,SLbuy, "BUY-SL-0.2");
                 }

               if(((((PriceCurrentbuy-PriceOpenbuy)>45)&&(Angulobuym1>40)&&(BO4==1))||(ntbo4==1))==true)
                 {
                  ntbo4=1;
                  if((((PriceCurrentbuy-PriceOpenbuy)>0)&&(Angulobuym1<40)&&(open>close))==true)
                    {
                     SLbuy=(MA3[0]);
                     ApplyTrailingStopSL(Symbol(), InpMagicNumber,SLbuy, "BUY-SL-0.2");
                    }
                 }

               //*************************************** GRALES **************************************************//

               if(((Angulobuym1>35)||(nt==5))==true)
                 {
                  nt=5;
                  if((((PriceCurrentbuy-PriceOpenbuy)>0)&&(Angulobuym1<35)&&(open>close))==true)
                    {
                     SLbuy=(PriceOpenbuy+(open-PriceCurrentbuy)+0.05);
                     ApplyTrailingStopSL(Symbol(), InpMagicNumber,SLbuy, "BUY-SL-5");
                    }
                 }

               if(((PriceCurrentbuy-PriceOpenbuy)>150)==true)
                 {
                  ApplyTrailingStopClose(Symbol(), InpMagicNumber, "BUY-CLOSE-0");
                 }

               if((((PriceCurrentbuy-PriceOpenbuy)>InTPmaxbuy))==true)
                 {
                  nt=20;
                  SLbuy=(PriceOpenbuy+InTPmaxbuy);
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,SLbuy, "BUY-SL-0");
                 }

               if((nt==20)&&(MA1[0]>(PriceOpenbuy+InTPmaxbuy)))
                 {
                  SLbuy=(MA1[0]+5);
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,SLbuy, "BUY-SL-0.1");
                 }

               if((((PriceCurrentbuy-PriceOpenbuy)>0) && ((Vresm4<1.8)))==true)
                 {
                  ApplyTrailingStop(Symbol(), InpMagicNumber, "BUY-CLOSE-5");
                 }

               if((((Angulobuym1>=35)&&(Angulobuym2>10)&&(Angulobuym3>20)&&(Angulobuym4>0)&&(((PriceCurrentbuy-PriceOpenbuy)>0)&&(MA2[0]>PriceOpenbuy))))==true)
                 {
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,openBuy, "BUY-SL-7");
                 }

               if(((SpikeCount>=1)&&((PriceCurrentbuy-PriceOpenbuy)>0)&&(Angulobuym4>0)&&(Angulobuym4<5)&&(BO4==0))==true)
                 {
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,openCount, "BUY-SL-8");
                 }

               if(((((PriceCurrentbuy-PriceOpenbuy)>40)&&(TamanoCO>30)))==true)
                 {
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,openBuy, "BUY-SL-3");
                 }

               if((((((PriceCurrentbuy-PriceOpenbuy)>45)&&((PriceCurrentbuy-PriceOpenbuy)<60)))&&((MA1[49]-MA1[0])<-60))==true)
                 {
                  ApplyTrailingStopClose(Symbol(), InpMagicNumber, "BUY-CLOSE-3");
                 }

               if(((((PriceCurrentbuy-PriceOpenbuy)>75)&&((PriceOpenbuy-MA1open)>5)&&(PriceCurrentbuy>open))||(nt==3))==true)
                 {
                  nt=3;
                  SLbuy=(MA1[0]);
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,SLbuy, "BUY-SL-2");
                 }

               if(((((PriceCurrentbuy-PriceOpenbuy)<0)&&(MA3[0]>MA1[0])&&(MA1[0]>MA2[0])&&(MA2[0]>MA4[0]))||(nt==4))==true)
                 {
                  nt=4;
                  SLbuy=(MA2[0]-3.5);
                  ApplyTrailingStopSL(Symbol(), InpMagicNumber,SLbuy, "BUY-SL-4");
                 }

              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Cerrarsell()
  {
   int      count          =  PositionsTotal();
   for(int i=count-1; i>=0; i--)
     {
      ulong ticket   =  PositionGetTicket(i);
      if(ticket>0)
        {
         if(PositionGetString(POSITION_SYMBOL)==Symbol())
           {
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
              {
               valpositionsell();

               if(((MA2[0]>MA3[0])&&(MA4[0]>MA2[0])&&((PriceOpensell-PriceCurrentsell)>0)&&(SO1==1))==true)
                 {
                  if((PriceOpensell-PriceCurrentsell)>75)
                    {
                     SLsell=(MA1[0]);
                    }
                  else
                     if((PriceOpensell-PriceCurrentsell)>50)
                       {
                        SLsell=(MA3[0]);
                       }
                     else
                       {
                        SLsell=(MA2[0]+5.5);
                       }
                  ApplyTrailingStopSLSell(Symbol(), InpMagicNumber, SLsell, "Sell-SL-3");
                 }

               if((((PriceOpensell-PriceCurrentsell)<0)&&(close>Vmax))==true)
                 {
                  valvmax=1;
                 }

               if((((PriceOpensell-PriceCurrentsell)>35)&&(valvmax==1))==true)
                 {
                  ApplyTrailingStopsell(Symbol(), InpMagicNumber, "Sell-CLOSE-10");
                  valvmax=0;
                 }

               if((((PriceOpensell-PriceCurrentsell)>50)&&(SO1==0))==true)
                 {
                  SLsell=(MA3[0]);
                  ApplyTrailingStopSLSell(Symbol(), InpMagicNumber, SLsell, "Sell-SL-4");
                 }

               if(((((PriceOpensell-PriceCurrentsell)>=InTPsell)))==true)
                 {
                  ApplyTrailingStopsell(Symbol(), InpMagicNumber, "Sell-CLOSE-0");
                  NoTradeSell=1;
                  NoTradeBuy=0;
                 }

               if(((SpikeCount>=1)&&((PriceOpensell-PriceCurrentsell)<0)&&(Angulosellm4>0)&&(Angulosellm4<2))==true)
                 {
                  ApplyTrailingStopsell(Symbol(), InpMagicNumber, "Sell-CLOSE-1");
                 }

               if((((close>MA1[0])&&((PriceOpensell-PriceCurrentsell)>33.33333334)&&(close>open)&&((PriceCurrentsell-open)>10)))==true)
                 {
                  ApplyTrailingStopsell(Symbol(), InpMagicNumber, "Sell-CLOSE-3");
                 }

               if((((SpikeSellCount==2)&&((PriceOpensell-PriceCurrentsell)>3.33333334)&&(MA2[0]>close)&&(NoTradeSell==0)))==true)
                 {
                  ApplyTrailingStopsell(Symbol(), InpMagicNumber, "Sell-CLOSE-4");
                 }

               if((((PriceOpensell-PriceCurrentsell)>0) && (Vresm4<1.8))==true)
                 {
                  ApplyTrailingStopsell(Symbol(), InpMagicNumber, "Sell-CLOSE-5");
                 }

               if(((((PriceOpensell-PriceCurrentsell)>-40)&&((PriceOpensell-PriceCurrentsell)<NormalizeDouble(InLosssell,1))&&(MA1[0]>MA3[0])))==true)
                 {
                  ApplyTrailingStopsell(Symbol(), InpMagicNumber, "Sell-CLOSE-8");
                 }

               if((((SpikeSellCount>=2)&&(MA2[0]>close)&&((PriceOpensell-PriceCurrentsell)<-3.33333334)&&(TamanoCO>10)))==true)
                 {
                  ApplyTrailingStopsell(Symbol(), InpMagicNumber, "Sell-CLOSE-9");
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
