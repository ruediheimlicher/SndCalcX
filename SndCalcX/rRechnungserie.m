//
//  rRechnungserie.m
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 16.04.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#import "rRechnungserie.h"
#include <stdio.h>
#define  kArraygrenze 48

#define GRENZE 48



#define kDreistellig 5
//*********************************************


//*********************************************
//const short 	kArraygrenze=48;



int rand_between(int l, int r)
{
   return (int)( (rand() / (RAND_MAX * 1.0f)) * (r - l) + l);
}

//*********************************************
static __inline__ int SSRandomIntBetween(int a, int b)
{
   int range = b - a < 0 ? b - a - 1 : b - a + 1;
   int value = (int)(range * ((float)random() / (float) LONG_MAX));
   return value == range ? a : a + value;
}

//**********************************************************************************
//**********************************************************************************



//**********************************************************************************
//**********************************************************************************
//*********************************************
//*********************************************
typedef struct
{
   
   short aktuelleAufgabennummer;
   short 				var[kMaxVariablen];
   short 				op[kMaxOperationen];
}Aufgabendaten;
//*********************************************
//**********************************************************************************
//**********************************************************************************
//**********************************************************************************
//*********************************************


//*********************************************
typedef struct
{
   short Platz,aktuelleAufgabennummer;
}Nummernvektor;
//*********************************************

/********************************************************************************/
short		string2int(char *	derString);
/********************************************************************************/
long Zehnerpot(short diePot);
/********************************************************************************/
/********************************************************************************/
short Maxvon(short ersteZahl, short zweiteZahl);
short Minvon(short ersteZahl, short zweiteZahl);



/********************************************************************************/
@implementation rAufgabenDaten : NSObject


- (id)init
{
   if ([super init])
   {
      for(short i=0;i<kMaxVariablen;i++)
         var[i]=i;
      for(short i=0;i<kMaxOperationen;i++)
         op[i]=-1;
      
      return self;
   }
   return nil;
}

@end





/********************************************************************************/
@implementation rSeriedaten : NSObject
@synthesize AnzahlAufgaben;
@synthesize AnzahlReihen;
- (id)init
{
   if ([super init])
   {
      //AnzahlAufgaben = 13;

      return self;
   }
   return nil;
}
- (void)setzeAnzahlAufgaben:(short)anzaufgaben
{
   self.AnzahlAufgaben = anzaufgaben;
   //AnzahlAufgaben = 13;
}
@end
/********************************************************************************/
//*********************************************
@implementation rObjcAufgabendaten

@end
//*********************************************
//*********************************************
@implementation rAufgabe

- (void)initWithData:(NSDictionary*)dieDaten
{
   
}

- (id)init
{
   if ([super init])
   {
   self.aktuelleAufgabennummer=0;
   for(short i=0;i<kMaxVariablen;i++)
      var[i]=i;
   for(short i=0;i<kMaxOperationen;i++)
      op[i]=-1;
   Ergebnispos=2;//pos des Ergebnisses in var
   }
   return self;
}

- (void)setAufgabendaten:(NSDictionary*)daten
{
   if ([daten objectForKey:@"var"])
   {
      NSArray* varArray =[daten objectForKey:@"var"];
      
   }
}

- (int)getVariable:(int)variable
{
   return var[variable];
}


- (int)getErgebnis
{
   return 0;
}


- (int)getOperation:(int)operation
{
   return op[operation];
}

- (void)Aufgabeweg
{
   var[0]=0;
   var[1]=0;
   var[2]=0;
   op[0]=0;
   
}
//*********************************************
//*********************************************
//*********************************************

@end


/********************************************************************************/



@implementation rRechnungserie
- (id)initWithAnzahl:(int)anzAufgaben
{
   if ([super init])
   {
      if (anzAufgaben<kMaxAnzahlAufgaben)
      {
         RechnungSeriedaten.AnzahlAufgaben=anzAufgaben;
      }
      else
      {
         RechnungSeriedaten.AnzahlAufgaben=kMaxAnzahlAufgaben;
      }
      AddobereGrenze=89;
      AdduntereGrenze=10;
      SubobereGrenze=99;
      SubuntereGrenze=19;
      
      ersteAufgabe=NULL;
      aktuelleAufgabe=NULL;
      mitEinleitung=0;
      
      return self;
   }
   
   return nil;
}



- (void)setSeriedaten:(cSeriedaten) dieSeriedaten
{
   printf("rSerie::setSeriedaten \n");
   printf("dieSeriedaten:Addition:%d\n",dieSeriedaten.Addition);
   printf("dieSeriedaten:Addition:%d\n",dieSeriedaten.Subtraktion);
   printf("dieSeriedaten:Addition:%d\n",dieSeriedaten.Multiplikation);
   printf("dieSeriedaten:Addition:%d\n",dieSeriedaten.Division);
   
   cRechnungSeriedaten = dieSeriedaten;
   printf("dieSeriedaten:Addition:%d\n",dieSeriedaten.Subtraktion);
   printf("dieSeriedaten:Addition:%d\n",dieSeriedaten.Multiplikation);
   printf("dieSeriedaten:Addition:%d\n",dieSeriedaten.Division);

   //for (int i=0;
}

- (cSeriedaten)getcSeriedaten
{
   cSeriedaten tempSeriedaten;
   
   return tempSeriedaten;
}

- (cSeriedaten)Objc2CmitSeriedaten:(rSeriedaten*)seriedaten
{
   cSeriedaten tempdaten;
   tempdaten.AnzahlAufgaben = seriedaten.AnzahlAufgaben;

   tempdaten.Addition = seriedaten.Addition;
   tempdaten.Subtraktion = seriedaten.Subtraktion;
   tempdaten.Multiplikation = seriedaten.Multiplikation;
   tempdaten.ASBereich = seriedaten.ASBereich;
   tempdaten.ASzweiteZahl = seriedaten.ASzweiteZahl;
   tempdaten.ASZehnerU = seriedaten.ASZehnerU;
   tempdaten.ASHunderterU = seriedaten.ASHunderterU;
   tempdaten.ASmaxZahlVorn = seriedaten.ASmaxZahlVorn;
   tempdaten.MultDivmitAdd = seriedaten.MultDivmitAdd;
   tempdaten.MultDivmitSub = seriedaten.MultDivmitSub;
   tempdaten.MultDivErgkleiner20 = seriedaten.MultDivErgkleiner20;
   tempdaten.MultDivZehnerpotenz1 = seriedaten.MultDivZehnerpotenz1;
   tempdaten.MultDivZehnerpotenz2 = seriedaten.MultDivZehnerpotenz2;
   
   tempdaten.Variante = seriedaten.Variante;
   tempdaten.Zeit = seriedaten.Zeit;
   tempdaten.Volume = seriedaten.Volume;
   
   for(int i=0;i<kMaxAnzahlReihen;i++)
   {
      tempdaten.Reihenliste[i] = seriedaten->Reihenliste[i];
   }

   
   return tempdaten;
}



- (void)AddSubBereichbestimmenMitSeriedaten:(rSeriedaten*)dieSeriedaten
{
  // printf("rSerie: SerieDaten.ASBereich: %d\n",cRechnungSeriedaten.ASBereich);
   //switch (cRechnungSeriedaten.ASBereich)
   //switch (RechnungSeriedaten.ASBereich)
   switch (dieSeriedaten.ASBereich)
   
   {
      case kBisZehn:
         AdduntereGrenze=2;
         AddobereGrenze=9;
         SubuntereGrenze=1;
         SubobereGrenze=9;
         break;
      case kBisZwanzig:
         AdduntereGrenze=2;
         AddobereGrenze=19;
         SubuntereGrenze=1;
         SubobereGrenze=19;
         
         break;
      case kZehnbisZwanzig:
         AdduntereGrenze=11;
         AddobereGrenze=19;
         SubuntereGrenze=11;
         SubobereGrenze=19;
         
         break;
      case kZweistellig:
         AdduntereGrenze=21;
         AddobereGrenze=99;
         
         SubuntereGrenze=11;
         SubobereGrenze=19;
         break;
      case kDreistellig:
         AdduntereGrenze=121;
         AddobereGrenze=999;
         
         SubuntereGrenze=11;
         SubobereGrenze=19;
         break;
         
   }//switch ASErgebnis
   //printf("AdduntereGrenze: %d AddobereGrenze: %d SubuntereGrenze: %d SubobereGrenze: %d\n",AdduntereGrenze,AddobereGrenze,SubuntereGrenze,SubobereGrenze);
   
   return;
}// AddSubBereichbestimmen

//*****************************************************************



//*****************************************************************
- (void)AufgabeinListe:(rAufgabe *)	dieAufgabe
{
   rAufgabe	*vorherigeAufgabe,*	dieseAufgabe;
   short		dieseNummer,neueNummer,tempanzahl=0;
   short 	count=0;
   short		erste=TRUE;
   
   if (ersteAufgabe==0)
      
   {
      ersteAufgabe=dieAufgabe;
      aktuelleAufgabe=dieAufgabe;
      Listennummer=1;
      dieAufgabe.aktuelleAufgabennummer=1;
      return;
   }
   dieseAufgabe=ersteAufgabe;
   while ((dieseAufgabe.nextAufgabe))
   {
      erste=FALSE;//nicht erstesObjekt in der Liste
      vorherigeAufgabe=dieseAufgabe;//Lage in der Liste sichern
      dieseAufgabe=dieseAufgabe.nextAufgabe;
   }//while
   //if (!erstes)
   //dieseAufgabe->nextObjekt=dieAufgabe;
   dieseAufgabe.nextAufgabe=dieAufgabe;
   Listennummer++;
   dieAufgabe.aktuelleAufgabennummer=Listennummer;
   
}
//*****************************************************************

- (NSMutableArray*)neueRechnungserie:(rSeriedaten*)dieSeriedaten ;
{
   NSMutableArray* returnAufgabenArray = [[NSMutableArray alloc]initWithCapacity:0];
//   printf("neueRechnungserie Start anz: %d\n",dieSeriedaten.AnzahlAufgaben);
//   cRechnungSeriedaten = [self Objc2CmitSeriedaten:dieSeriedaten];
   //cRechnungSeriedaten.AnzahlAufgaben=dieSeriedaten.AnzahlAufgaben;
   //srand([[NSDate date] timeIntervalSince1970]);
   //printf("neueSerie 1\n");
   //int anzahl=10;
   int anzaufgaben = dieSeriedaten.AnzahlAufgaben;
   //NSLog(@"Rechnungserie neueRechnungserie dieSeriedaten \nanz: %d \nAdd: %d \nSub: %d \nMult: %d\n",
   //      anzaufgaben,
   //      dieSeriedaten.Addition,
   //      dieSeriedaten.Subtraktion,
   //      dieSeriedaten.Multiplikation );
 //ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
   //NSLog(@"\nASBereich: %d \nASzweiteZahl: %d \nASZehnerU: %d \nASHunderterU: %d\n",
   
    //     dieSeriedaten.ASBereich,
    //     dieSeriedaten.ASzweiteZahl,
    //     dieSeriedaten.ASZehnerU,
    //     dieSeriedaten.ASHunderterU);

   
   
   short Einer=0, Zehner=0,Hunderter=0;

   short	AddResultatvektor[kArraygrenze];		//?
   short	SubResultatvektor[kArraygrenze]={0};		//?
   
   short 	AddSubResultatvektor[kArraygrenze]={0};
   short	AddSubVar1vektor[kArraygrenze]={0};
   short	AddSubResultatRepvektor[kArraygrenze];
   short	AddSubVar1Repvektor[kArraygrenze];
   
   short		MultVar0vektor[kArraygrenze]={0};
   short		MultVar1vektor[kArraygrenze]={0};
   short	*	MultResultatvektor={0};
   short	*	Operation1vektor={0};
   
   //printf("A\n");
   RepReset(AddSubResultatRepvektor);
   // printf("B\n");
   RepReset(AddSubVar1Repvektor);
   // printf("C\n");
   //GetDateTime((unsigned long *) &qd.randSeed);
   
   typedef short Reihenfaktor[10];
//   short tempVar1vektor[kArraygrenze]={0};
   //printf("SerieDaten.Multiplikation: %d\n",dieSeriedaten.Multiplikation);
   if  (!dieSeriedaten.Addition && !dieSeriedaten.Subtraktion && ! dieSeriedaten.Multiplikation)
   {
      printf("neueSerie: keine Operation 2\n");
      //SysBeep(8);
      //short Fehler=FehlermitOK(kSeriedatenfehler,kMindestenseineOperation);
   }
   else
   {
      //printf("neueSerie 2\n");
      //										aktuelleAufgabennummern verteilen
      
   //   short tempNummernvektor[48]={0};
  //    Zahlenverteilen(tempNummernvektor,dieSeriedaten.AnzahlAufgaben);
      short AaKontrollvektor[kArraygrenze]={0};
      long AlKontrollvektor[kArraygrenze]={0};
      
      Zahlenverteilen(AaKontrollvektor,kArraygrenze);
      
      short ** Reihenfaktorarray;
      short	*	ReihenposArray={0};
      //																				1.Variable:		Faktoren der Reihenaufgaben
      
      struct rAddSubDaten{short UGrenze,OGrenze,Bereich, Summand, Ergebnis;}	AddSubDaten[kArraygrenze];
      
      //printf("neueRechnungSerie Add: %d  Sub: %d  Mult: %d\n",dieSeriedaten.Addition,dieSeriedaten.Subtraktion,dieSeriedaten.Multiplikation);
      
      if ((dieSeriedaten.Addition==1) ||(dieSeriedaten.Subtraktion==1))
      {
         //printf("Addition oder Subtraktion\n");
         //AddSubResultatvektor=new short[kArraygrenze];
         //AddSubVar1vektor=malloc(sizeof(short[kArraygrenze]));
         
         // 1. Obere und untere Grenze der Ergebnisse bestimmen
         
         [self AddSubBereichbestimmenMitSeriedaten:dieSeriedaten];
         
         // 2. Resultate fuer alle Aufgaben bestimmen
     //    printf("AdduntereGrenze %d  AddobereGrenze: %d\n",AdduntereGrenze,  AddobereGrenze);
         Zahlenvektorbestimmen(AddSubResultatvektor,	AdduntereGrenze,  AddobereGrenze, kArraygrenze);
         //Zahlenvektorbestimmen(AddSubResultatvektor,	10,  99, 48);
         
         //printf("Rechnungserie neueSerie: AddSubResultatvektor\n");
         for (int i=0;i<kArraygrenze;i++)
         {
            //printf("%d\t%d\n",i,AddSubResultatvektor[i]);
         }

         //printf("neueSerie: 2\n");
         
         // 3. Generelle Grenzen der zweiten Zahl bestimmen
         short i=0;
         for (i=0;i<kArraygrenze;i++)
         {
            AaKontrollvektor[i]=AddSubResultatvektor[i];
         }
         //for (short i=0;i<kArraygrenze;i++)
         {
            //printf("%d\t AddSubResultatvektor: %d \tAaKontrollvektor: %d\n",i,AddSubResultatvektor[i],AaKontrollvektor[i]);
         }

         short minVar1=1,maxVar1=1;
         switch (dieSeriedaten.ASzweiteZahl)
         {
            case kBisZehn:
               maxVar1=9;
               break;
            case kBisZwanzig:
               maxVar1=19;
               break;
            case kZehnbisZwanzig:
               minVar1=11;
               maxVar1=19;
               break;
            case kZweistellig:
               minVar1=11;
               maxVar1=99;
               break;
            case kDreistellig:
               minVar1=111;
               maxVar1=999;
               break;
         }//switch ASzweiteZahl
         //printf("neueSerie: 4\n");
         //printf("minVar1: %d \t maxVar1 %d\n",minVar1,maxVar1);
         //5.	Fuer jede Aufgabe die Grenzen korrigieren, sofern noetig
         short hoppla=0;
         
         /*
          Fuer jede Aufgabe ein Ergebnis und einen passsenden Bereich generieren, in dem die zweite Variable liegen kann
          */

         for (short nummer=0;nummer<kArraygrenze;nummer++)
         {
            //printf("%d\t AddSubResultatvektor(nummer): %d \n",nummer,AddSubResultatvektor[nummer]);
            short tempErgebnis=AddSubResultatvektor[nummer];
            //printf("%d\t tempErgebnis: %d \n",nummer,tempErgebnis);
            short einer=tempErgebnis%10;
            short zehner=tempErgebnis/10;
            short tempvar0=0;
            
            short tempmaxVar1=Minvon(maxVar1,tempErgebnis-1);
            short tempminVar1=minVar1;
            
            if (einer==0)								//Zehnerzahl, 1 dazu
            {
               tempErgebnis+=1;
               einer+=1;
            }
            if ((dieSeriedaten.ASBereich>kBisZehn)&&(dieSeriedaten.ASzweiteZahl==kBisZehn))//Bereich min bis 20
               //if ((SerieDaten.ASBereich>kZehnbisZwanzig)&&(SerieDaten.ASzweiteZahl==kBisZehn))
               
            switch(dieSeriedaten.ASZehnerU)					//Bereich bei Zehneruebergang anpassen
            {
               case kNie:
                  if (einer==1)			//Bereich vergroessern
                  {
                     einer+=1;
                     tempErgebnis+=1;
                  }
                  tempmaxVar1=einer;//zurueck auf den Zehner
                  tempminVar1=1;
                  break;//ohneZehnerU
                  
               case kImmer:
                  if (einer==9)			//Bereich verkleinern
                  {
                     einer-=1;
                     
                     //tempmaxVar1-=1;
                     tempErgebnis-=1;
                  }
                  if (zehner>0)
                  {
                     tempminVar1=einer+1;	//
                  }
                  
                  if (tempminVar1>tempmaxVar1)
                  {
                     hoppla++;
                  }
                  break;//kImmer
                  
               case kOffen:
                  tempmaxVar1=Minvon(tempmaxVar1,tempErgebnis-1);
                  tempminVar1=1;
                  break;//kOffen
            }//switch ASZehnerU
            
            //
            //tempminVar1=Minvon(minVar1,tempErgebnis-1);
            //printf("neueSerie: nr:  %d	tempminVar1: %d tempmaxVar1: %d  tempErgebnis: %d\n",nummer,tempminVar1,tempmaxVar1,tempErgebnis);
            
            // AddSub-Daten fuer Aufgabe eintragen
            AddSubDaten[nummer].OGrenze=tempmaxVar1;  //OGrenze fuer 2. Zahl
            AddSubDaten[nummer].UGrenze=tempminVar1;	//UGrenze fuer 2. Zahl
            AddSubDaten[nummer].Bereich=tempmaxVar1-tempminVar1+1; //moeglicher Variationsbereich des Summanden fuer die Vorgaben (Bsp. ZehnerU)
            AddSubDaten[nummer].Summand=0;
            AddSubDaten[nummer].Ergebnis=tempErgebnis;
            
         }//for nummer
         
         //printf("neueSerie: 5\n");
         for (short ii=0;ii<kArraygrenze;ii++)
         {
            //printf("%d\t OGrenze: %d\t UGrenze: %d\t Bereich: %d\t Ergebnis: %d\n",ii,AddSubDaten[ii].OGrenze,AddSubDaten[ii].UGrenze,AddSubDaten[ii].Bereich,AddSubDaten[ii].Ergebnis);
            
            //AaKontrollvektor[ii]=AddSubDaten[ii].Ergebnis*1000+AddSubDaten[ii].Bereich;
            AlKontrollvektor[ii]=(long)AddSubDaten[ii].Ergebnis*1000+AddSubDaten[ii].Bereich;
         }
         
         /*
          Jede Aufgabe hat jetzt ein Ergebnis und einen passsenden Bereich, in dem die zweite Variable
          liegen kann
          */
         
         short tempBereich=maxVar1;								//max moeglicher Bereich, bei erster Var ist er 1
         
        // printf("neueSerie  anzaufgaben: %d tempBereich: %d\n",anzaufgaben,tempBereich);
         
         //Kleinsten Bereich in Array AddSubDaten suchen. Das ist die Aufgabe mit kleinsten Auswahlmöglichkeiten

         for (short k=0;k<anzaufgaben;k++)                                                                                {
            if (AddSubDaten[k].Bereich<=tempBereich)
            {
               tempBereich=AddSubDaten[k].Bereich;
            //printf("%d\t tempBereich: %d\n",k,tempBereich);
            }
            //ergibt Startbereich fuer while, meistens 1
         }
         //printf("maxVar1: %d\t tempBereich: %d\n",maxVar1,tempBereich);
         
         short DatenimBereich=0;							//Anzahl der im tempbereich liegenden Datensaetze
         short AufgabenNrvektor[kArraygrenze]={0};	//Aufgabennummern der im tempbereich liegenden Datensaetze
         short tempSummandvektor[kArraygrenze]={0};
         short Aufgabennummer=0,Laufnummer=0,Durchgang=0;
         short schonDa=0;										//
         short tempSummand=0;
         short tempErgebnis=0;
         short tempUGrenze=0;
         
        /*
         AufgabenNrVektor enthaelt die Nummern der Aufgaben am index 'DatenimBereich'
         */
       
         while (tempBereich<=(maxVar1)) // nach oben abtasten
         {
            for (short ii=0;ii<kArraygrenze;ii++)//Vektor leeren
            {
               AufgabenNrvektor[ii]=0;
            }
            
            DatenimBereich=0;  // gibt es moegliche Werte im Bereich?
           // for (short tempNummer=0;tempNummer<dieSeriedaten.AnzahlAufgaben;tempNummer++)	//Bereiche abfragen
 for (short tempNummer=0;tempNummer<kArraygrenze;tempNummer++)	//Bereiche abfragen
            {
               //printf("AddSubDaten(%d):\t AddSubDaten.Bereich: %d Ergebnis: %d\n",tempNummer,AddSubDaten[tempNummer].Bereich,AddSubDaten[tempNummer].Ergebnis);
               if (AddSubDaten[tempNummer].Bereich==tempBereich)			//Aufgabe mit gleichem Bereich
               {
                  //printf("\tim Bereich:tempNummer: %d\t DatenimBereich: %d\n",tempNummer,DatenimBereich);
                  AufgabenNrvektor[DatenimBereich]=tempNummer;			//Aufgabennummer merken
                  
                  //14.9.06
                  DatenimBereich++;
                  
               }
            }//for tempNummer
            
            //printf("Anzahl Daten im Bereich %d: %d\n",tempBereich,DatenimBereich);
            if (DatenimBereich) // Es hat Aufgaben im tempbereich
            {
               for (short ii=0;ii<kArraygrenze;ii++)
               {
                  tempSummandvektor[ii]=0;								//Vektor leeren
               }
               
               //Reihenfolgebestimmen(tempSummandvektor,tempBereich,DatenimBereich);
               
               Zahlenvektorbestimmen(tempSummandvektor,0,tempBereich-1,DatenimBereich); // tempBereich 1: Keine Aktion
               
               for (short i=0;i<DatenimBereich;i++)
               {
                  //printf("tempBereich: %d ASZehnerU: %d \n",tempBereich,dieSeriedaten.ASZehnerU);
                  switch (dieSeriedaten.ASZehnerU)
                  {
                     case kImmer:
                     case kOffen:
                        if ((dieSeriedaten.ASBereich>kBisZwanzig)&&(dieSeriedaten.ASzweiteZahl==kBisZehn))
                        {
                           tempSummandvektor[i]=maxVar1-tempSummandvektor[i];
                        }
                        break;
                     case kNie:
                        break;
                        //					case kOffen:
                        //						break;
                  }
                  //printf("ASzweiteZahl: %d \n",dieSeriedaten.ASzweiteZahl);
                  switch (dieSeriedaten.ASzweiteZahl)
                  {
                     case kBisZehn:
                        //if (tempSummandvektor[i]==0)
                        //{tempSummandvektor[i]=1;}
                        break;
                     case kZehnbisZwanzig:
                        tempSummandvektor[i]+=10;
                        break;
                     case kZweistellig:
                        tempSummandvektor[i]+=11;
                        break;
                     case kDreistellig:
                        tempSummandvektor[i]+=101;
                        break;
                        
                  }//switch zweiteZahl
                  
               }//for
               
               //Zahlenverteilen(tempSummandvektor,DatenimBereich);
            }//if tempBereich
            
            else							//keine Auswahl
            {
               for (short i=0;i<DatenimBereich;i++)
               {
                  
                  tempSummandvektor[i]=AddSubResultatvektor[AufgabenNrvektor[i]]%10;
               }
            }//else
            //printf("neueSerie: 9\n");
            
            for (short ii=0;ii<anzaufgaben;ii++)
            {
               //printf("%d\t tempSummandvektor: %d\n",ii,tempSummandvektor[ii]);
               if (ii<DatenimBereich)
                  AaKontrollvektor[ii]=tempSummandvektor[ii];
               else
                  AaKontrollvektor[ii]=0;
            }
            
            for (short i=0;i<DatenimBereich;i++)
            {
               //printf("%d\t tempSummandvektor: %d\n",i,tempSummandvektor[i]);

               AddSubDaten[AufgabenNrvektor[i]].Summand=tempSummandvektor[i];
            }
            //delete[] tempSummandvektor;
            
            tempBereich++;
            //Laufnummer++;Aufgabennummer++;
         }//while tempBereich<10)
         
         
         
         //printf("AddSubResultatvektor 2\n");
         //for (short i=0;i<dieSeriedaten.AnzahlAufgaben;i++)
         //for (short i=0;i<kArraygrenze;i++)
         {
            //printf("%d\t tempSummandvektor: %d\t",i,tempSummandvektor[i]);
            //printf(" AddSubResultatvektor: %d\n",AddSubResultatvektor[i]);
         }
  
         
         //printf("neueSerie: 10\n");
         Aufgabennummer=0,Laufnummer=0,Durchgang=0;
         schonDa=0;
         tempSummand=0;
         tempErgebnis=0;
         
         while ((Aufgabennummer < dieSeriedaten.AnzahlAufgaben)&&(Laufnummer<kArraygrenze))
         {
            //printf("neueSerie:Aufgabennummer: %d Laufnummer: %d\n",Aufgabennummer,Laufnummer);
            tempSummand=AddSubDaten[Laufnummer].Summand;
            tempErgebnis=AddSubDaten[Laufnummer].Ergebnis;
            if (tempSummand)
            {
               //printf("neueSerie:Aufgabennummer: %d Laufnummer: %d\t tempSummand: %d tempErgebnis: %d\n",Aufgabennummer,Laufnummer,tempSummand,tempErgebnis);
               if ((!RepTest(AddSubVar1Repvektor,tempSummand))&&(!RepTest(AddSubResultatRepvektor,tempErgebnis)))
               {
                  AddSubResultatvektor[Aufgabennummer]=tempErgebnis;
                  AddSubVar1vektor[Aufgabennummer]=tempSummand;
                  //printf("L\n");
                  // Summand im AddSubVar1Repvektor speichern, soll wiederholung verhindern
                  RepSet(AddSubVar1Repvektor,tempSummand);
                  //printf("M\n");
                  RepSet(AddSubResultatRepvektor,tempErgebnis);
                  //printf("N\n");
                  
                  Aufgabennummer++;
               }
               else
               {
                  
               }
               Laufnummer++;
               if ((Laufnummer==kArraygrenze)&&(Aufgabennummer-1<=dieSeriedaten.AnzahlAufgaben))
               {
                  
                  //printf("U\tlaufnummer: %d \n",Laufnummer);
                  RepReset(AddSubVar1Repvektor);
                  //printf("V\n");
                  RepReset(AddSubResultatRepvektor);
                  //printf("W\n");
                  Laufnummer=Aufgabennummer;
               }
            }
            else
            {
               break;;
            }
         }//while Aufgabennummer
         
         
         //printf("neueSerie: 12\n");
      }//Add oder Sub
      
      //printf("AddSubResultatvektor 3\n");
      for (short i=0;i<dieSeriedaten.AnzahlAufgaben;i++)
      {
         //printf("%d\t AddSubResultatvektor: %d\n",i,AddSubResultatvektor[i]);
      }

      //printf("neueSerie: 13\n");
      
      
      if (dieSeriedaten.Multiplikation &&dieSeriedaten.AnzahlReihen)
      {
         //printf("neueSerie 14\n");
         struct rRep{short ersteVar,zweiteVar;}	MultRep[GRENZE];
         
         for (short i=0;i<kArraygrenze;i++)
         {
            MultRep[i].ersteVar=0;MultRep[i].zweiteVar=0;
         }
         //																				F√ºr jede ausgew√§hlte Reihe wird eine Zeile angelegt
         //Reihenfaktorarray= new short * [dieSeriedaten.AnzahlReihen];
         //Reihenfaktorarray = malloc(sizeof(short[dieSeriedaten.AnzahlReihen]));
         
         short Reihenfaktorarray[kArraygrenze][kArraygrenze]={0};
         for (short zeile=0;zeile<dieSeriedaten.AnzahlReihen;zeile++)
         {
            //Reihenfaktorarray[zeile]=malloc(sizeof(short[kArraygrenze]));	//Randomzahlen f√ºr die erste Variable
            
            // 7.12.2011: Grenze auf 8 red, 10* xy fällt weg
            
            Reihenfolgebestimmenab2(Reihenfaktorarray[zeile],8,kArraygrenze);
         }
         //																		2. Varilable:		Reihenfolge der Reihen bestimmen
         short ReihenposArray[kArraygrenze] = {0};
         Reihenfolgebestimmen(ReihenposArray,dieSeriedaten.AnzahlReihen,kArraygrenze);
         
         for (short i=0;i<kArraygrenze;i++)
         {AaKontrollvektor[i]=Reihenfaktorarray[0][i];}
         for (short i=0;i<kArraygrenze;i++)
         {AaKontrollvektor[i]=ReihenposArray[i];}
         
         //MultVar0vektor=new short[cRechnungSeriedaten.AnzahlAufgaben];
         //MultVar0vektor= malloc(sizeof(short[dieSeriedaten.AnzahlAufgaben]));
         //short MultVar0vektor[kArraygrenze]={0};

         //MultVar1vektor=new short[cRechnungSeriedaten.AnzahlAufgaben];
        // MultVar1vektor= malloc(sizeof(short[dieSeriedaten.AnzahlAufgaben]));
         //short MultVar1vektor[kArraygrenze]={0};
         
         short Aufgabennummer=0,Laufnummer=0,Durchgang=0;;
         short schonDa=0;
         short	tempPos=0;
         short	tempFaktor=0;
         short tempReihe=0;
         
         while ((Aufgabennummer<dieSeriedaten.AnzahlAufgaben)&&(Laufnummer<kMaxAnzahlAufgaben)
                &&(Durchgang<10))
         {
            schonDa=0;
            tempPos=ReihenposArray[Laufnummer];
            tempReihe=dieSeriedaten->Reihenliste[tempPos];
            tempFaktor=Reihenfaktorarray[tempPos][Laufnummer];
            
            for (short k=0;k<Aufgabennummer;k++)
            {
               if ((tempFaktor==MultVar0vektor[k])&&(tempReihe==MultVar1vektor[k]))
               {
                  if (dieSeriedaten.AnzahlReihen>1)
                  {schonDa=1;}
               }
            }//for k
            
            if (schonDa)
            {
               //Laufnummer=0;
               Durchgang++;
            }
            else
            {
               MultVar0vektor[Aufgabennummer]=tempFaktor;
               MultVar1vektor[Aufgabennummer]=tempReihe*Zehnerpot(dieSeriedaten.MultDivZehnerpotenz2);
               Aufgabennummer++;
            }
            Laufnummer++;
            if (Laufnummer==kMaxAnzahlAufgaben)
            {
               for (short zeile=0;zeile<cRechnungSeriedaten.AnzahlReihen;zeile++)
               {
                  Reihenfolgebestimmenab2(Reihenfaktorarray[zeile],9,kArraygrenze);
               }
               //																		2. Varilable:		Reihenfolge der Reihen bestimmen
               Reihenfolgebestimmen(ReihenposArray,dieSeriedaten.AnzahlReihen,kArraygrenze);
               Laufnummer=0;
            }
         }//while
      }//if SerieDaten.AnzahlReihen
      
      //																							Resultate f√ºr Add und Sub verteilen
      //AddResultatvektor=new short[SerieDaten.AnzahlAufgaben];
      //SubResultatvektor=new short[SerieDaten.AnzahlAufgaben];
      
      //printf("neueSerie 15\n");
      Zahlenvektorbestimmen(AddResultatvektor,	AdduntereGrenze,  AddobereGrenze,	dieSeriedaten.AnzahlAufgaben);
      Zahlenvektorbestimmen(SubResultatvektor,	AdduntereGrenze,  AddobereGrenze,	dieSeriedaten.AnzahlAufgaben);
      //for (short i=0;i<dieSeriedaten.AnzahlAufgaben;i++)
      {
         //printf("%d\t AddResultatvektor: %d\tSubResultatvektor: %d \tAddSubResultatvektor: %d\n",i,AddResultatvektor[i],SubResultatvektor[i],AddSubResultatvektor[i]);
      }
      
      
      for (short i=0;i<dieSeriedaten.AnzahlAufgaben;i++)
      {AaKontrollvektor[i]=AddResultatvektor[i];}
      
      //																				Reihenfolge der gew√§hlten Operationen bestimmen
      //Operation1vektor=new short[dieSeriedaten.AnzahlAufgaben];
      //Operation1vektor= malloc(sizeof(short[dieSeriedaten.AnzahlAufgaben]));
      //Operation1vektor= malloc(sizeof(short[kArraygrenze]));
#pragma mark cSeriedaten
      
      short Operation1vektor[kArraygrenze]={0};
      cSeriedaten tempseriedaten = [self  Objc2CmitSeriedaten:dieSeriedaten]; // Uebergabe in C-Struct
      Operationenverteilen(Operation1vektor,tempseriedaten);
      
      for (short i=0;i<dieSeriedaten.AnzahlAufgaben;i++)
      {AaKontrollvektor[i]=Operation1vektor[i];}
      
      //cAufgabendaten tempADat;
      rAufgabenDaten* tempADat = [[rAufgabenDaten alloc]init];
      rAufgabe * tempAufgabe ;
      
      char z;short n;
      short tempvar0=0,tempvar1=0,tempErgebnis=0;
      //printf("neueSerie 16\n");
      
      int anz=dieSeriedaten.AnzahlAufgaben;
      //printf("neueSerie 4: anz: %d\n",anz);
      
      
      for (int nummer=0;nummer<dieSeriedaten.AnzahlAufgaben;nummer++)
      {
         //printf("neueSerie: Nummer: %d\n",nummer);	
         tempADat.aktuelleAufgabennummer=nummer+1;
         tempADat->op[0]=Operation1vektor[nummer];
         
         tempvar0=0;
         tempvar1=0;
         tempErgebnis=0;
         switch (tempADat->op[0])
         {
            case kAdd:
               tempErgebnis=AddSubResultatvektor[nummer];
               tempvar1=AddSubVar1vektor[nummer];
 
               tempvar0=tempErgebnis-tempvar1;
               tempADat->var[2]=tempErgebnis;
               tempADat->var[0]=tempvar0;
               tempADat->var[1]=tempvar1;
           //    printf("Add nr: %d \t var 0: %d  \t  var 1: %d \t  var 2: %d\n",nummer,tempADat->var[0],tempADat->var[1],tempADat->var[2]);

               break;//Add
               
               
            case kSub:
               tempvar0=AddSubResultatvektor[nummer];
               tempvar1=AddSubVar1vektor[nummer];
               tempErgebnis=tempvar0-tempvar1;
               tempADat->var[2]=tempErgebnis;
               tempADat->var[0]=tempvar0;
               tempADat->var[1]=tempvar1;
           //    printf("Sub nr: %d \t var 0: %d  \t  var 1: %d \t  var 2: %d\n",nummer,tempADat->var[0],tempADat->var[1],tempADat->var[2]);
               
               break;
            case kMult:
               
               tempvar0=MultVar0vektor[nummer];
               tempvar1=MultVar1vektor[nummer];
               tempADat->var[0]=tempvar0;
               tempADat->var[1]=tempvar1;
               tempADat->var[2]=tempvar0*tempvar1;
               break;
               
               //}//switch (Operation1vektor[nummer])
               break;//if opzeichen<2 (add oder sub)
         }//switch tempADat.op[0]
         
         
   //      rAufgabe*  tempAufgabe;
         
   //      AufgabeinListe(tempAufgabe);
         
    //     printf("nr: %d var 0: %d op: %d var 1: %d var 2: %d\n",nummer,tempADat->var[0],tempADat->op[0],tempADat->var[1],tempADat->var[2]);
         
         // Return Value derAufgabenDatenArray
         
       //  rRechnungserie* tempRechnungserie = [[rRechnungserie alloc]init];
         
         rAufgabenDaten* tempAufgabendaten = [[rAufgabenDaten alloc]init];
         
         tempAufgabendaten.aktuelleAufgabennummer = nummer + 1;
         tempAufgabendaten->op[0]=tempADat->op[0];
         tempAufgabendaten->var[0]=tempADat->var[0];
         tempAufgabendaten->var[1]=tempADat->var[1];
         tempAufgabendaten->var[2]=tempADat->var[2];
        
         //printf("neueSerie: Nummer Ende: %d\n",nummer);
         [returnAufgabenArray addObject:tempAufgabendaten];

      }//for nummer
      //for (short i=0;i<SerieDaten.AnzahlAufgaben;i++)
      //{AaKontrollvektor[i]=Operation1vektor[i];}
      
      //fprintf(stderr,"neueSerie Ende\n");
      
      
      //delete[]	AddResultatvektor;
      //free	(Operation1vektor);
      //delete[]	Nummernvektor;
      
   }//if (SerieDaten.Addition && SerieDaten.Subtraktion &&  SerieDaten.Multiplikation)
   
   //NSLog(@"returnAufgabenArray: %@",returnAufgabenArray);
  // for (short i=0;i < [returnAufgabenArray  count];i++)
   {
      
      //rAufgabenDaten* tempAufgabendaten =[returnAufgabenArray objectAtIndex:i];
      //printf("neueSerie %d returnAufgabenArray var0: %d,\n",i,tempAufgabendaten->var[0]);
   }
  // free (Operation1vektor);
   //printf("neueSerie ganz zu Ende\n");
   return returnAufgabenArray ;
}
//*****************************************************************
//*****************************************************************
   void	Zahlenverteilen(short * derVektor,short	n)
   {
      /*
       Zahlen 0-n zufällig im vektor verteilen. Ergibt zB. zufaellig verteilte aufgabennummern
       */
      short tausch=TRUE;
      typedef struct
      {
         int a,b;
         
      }Element;
      Element Elementvektor[kArraygrenze];
      
      Element tempElement;
      
      if (n>kArraygrenze)
      {n=kArraygrenze;}
      
      //printf("Zahlenverteilen: %d\n",n);
      for (short i=0;i<kArraygrenze;i++)
      {
         Elementvektor[i].a=i;
         if (i<n)
         {
            
            //int t=arc4random();
            //int t=arc4random_uniform(1234);
            //int r =arc4random_uniform(10);
            //Elementvektor[i].b=abs((int)random());
            //
            Elementvektor[i].b= arc4random_uniform(1234);
            //printf("vektor: i; %d t: %d  Zahl:%d r: %d\n",i,t,Elementvektor[i].b,r);
            //printf("vektor: i; %d a: %d Zahl:%d\n",i,Elementvektor[i].a,Elementvektor[i].b);
         }
         else
         {
            Elementvektor[i].b=0;
         }
      }//for
      while(tausch)
      {
         tausch=FALSE;
         //printf("\n");
         for (short k=0;k<n-1;k++)
         {
            
            //printf("vor: %d \tEk a: %d  \tEk b: %d \t\tEk+1 a: %d\tEk+1 b: %d\n",k,Elementvektor[k].a,Elementvektor[k].b,Elementvektor[k+1].a,Elementvektor[k+1].b);
            
            if (Elementvektor[k].b>Elementvektor[k+1].b)
            {
               
               tempElement=Elementvektor[k];
               Elementvektor[k]=Elementvektor[k+1];
               Elementvektor[k+1]=tempElement;
               tausch=TRUE;
            }
            //printf("nach: %d Ek: %d Ek+1: %d\n",k,Elementvektor[k].b,Elementvektor[k+1].b);

         }//for k
      }//while tausch
      //printf("nach tausch \n");
      /*
      for (short k=0;k<n;k++)
      {
         printf("%d a: %d Ek:%d\n",k,Elementvektor[k].a,Elementvektor[k].b);
      }
      */
      for (short k=0;k<n;k++)
      {

         derVektor[k]=Elementvektor[k].a;
         
         
         //printf("dervektor: i; %d Zahl:%d a: %d\n",k,derVektor[k],Elementvektor[k].b);
         //printf("dervektor: i; %d Zahl:%d\n",k,derVektor[k]);
      }
   }
   //*****************************************************************
//*****************************************************************

void Zahlenverteilenab1(short * derVektor,short	n)
{
   short tausch=TRUE;
   typedef struct
   {
      short a,b;
      
   }Element;
   Element Elementvektor[kArraygrenze];
   
   Element tempElement;
   
   for (short i=0;i<kArraygrenze;i++)
   {
      Elementvektor[i].a=i;
      if (i<n)
      {
         Elementvektor[i].b=arc4random_uniform(1234);
      }
      else
      {
         Elementvektor[i].b=0;
      }
   }//for
   
   while(tausch)
   {
      tausch=FALSE;
      for (short k=0;k<n-1;k++)
      {
         if (Elementvektor[k].b>Elementvektor[k+1].b)
         {
            tempElement=Elementvektor[k];
            Elementvektor[k]=Elementvektor[k+1];
            Elementvektor[k+1]=tempElement;
            tausch=TRUE;
         }
      }//for k
   }//while tausch
   
   short einsda=0;
   for (short k=0;k<n;k++)
   {
      derVektor[k]=Elementvektor[k].a+1;
      //printf("k: %d	derVektor: %d\n",k,derVektor[k]);
      
   }
   //printf("\n");
}
//*****************************************************************
//*****************************************************************

void Zahlenverteilenab2(short * derVektor,short	n)
{
   short tausch=TRUE;
   typedef struct
   {
      short a,b;
      
   }Element;
   Element Elementvektor[kArraygrenze];
   
   Element tempElement;
   
   for (short i=0;i<kArraygrenze;i++)
   {
      Elementvektor[i].a=i;
      if (i<n)
      {
         Elementvektor[i].b=arc4random_uniform(1234);
      }
      else
      {
         Elementvektor[i].b=0;
      }
   }//for
   while(tausch)
   {
      tausch=FALSE;
      for (short k=0;k<n-1;k++)
      {
         if (Elementvektor[k].b>Elementvektor[k+1].b)
         {
            tempElement=Elementvektor[k];
            Elementvektor[k]=Elementvektor[k+1];
            Elementvektor[k+1]=tempElement;
            tausch=TRUE;
         }
      }//for k
   }//while tausch
   short einsda=0;
   for (short k=0;k<n;k++)
   {
      derVektor[k]=Elementvektor[k].a+2;
   }
}
//*****************************************************************
//*****************************************************************
void 	Operationenverteilen(short *	derVektor, cSeriedaten seriedaten)
{
   short tempvektor[kArraygrenze]={0};
   short		Operationen[4]={0};
   short 	op=0;
   if (seriedaten.Addition)// Die ausgewaehlten Operationen in Operation-Vektor eintragen
   {
      Operationen[op]=kAdd;
      op++;
   }
   if (seriedaten.Subtraktion)
   {
      Operationen[op]=kSub;
      op++;
   }
   if (seriedaten.Multiplikation)
   {
      Operationen[op]=kMult;
      op++;
   }
   if (seriedaten.Division)
   {
      Operationen[op]=kDiv;
      op++;
   }
   
   short i=0;
   short opvektor[4]={1};
   for (short nr=0;nr<seriedaten.AnzahlAufgaben;nr++)
   {
      i=nr%op;	//Start einer neuen Runde beim Verteilen der Pl√§tze im Operationen-Vektor
      if (i==0)	// In opvektor die Pl√§tze im Operationen-Vektor neu verteilen
      {
         if ((op>1) )
         {
            Zahlenverteilenab1(opvektor, op);
         }
         else
         {
            //opvektor[i]=Operationen[op-1];
            opvektor[i]=1;
         }//if op>1
         
      }//i==0
      tempvektor[nr]=opvektor[i];
			}//for nr
			//tempvektor enth√§lt eine Liste mit den Nummern der Pl√§tze im Operationen-Vektor
   short testvektor[24]={0};
   for (short n=0;n<seriedaten.AnzahlAufgaben;n++)
   {
      
      //testvektor[n]=Operationen[tempvektor[n]-1];
      derVektor[n]=Operationen[tempvektor[n]-1];
   }
}//derVektor enthaelt eine Liste mit verteilten Nummern der ausgewaehlten Operationen
//*****************************************************************


//*****************************************************************

//*****************************************************************
//********************************************************************
short	 Randomzahl(short dasMin,short dasMax)
{
   const 	short 	kMinRand = -32767.0;
   const		short 	kMaxRand = 32767.0;
   short 		myRand;
   double 	x;
   int y;
   long			rand,exprand;				//Random scaled to [0..1]
   
   //y=SSRandomIntBetween(dasMin,dasMax);
   y = rand_between(dasMin,dasMax);
   //printf("dasMin: %x			dasMax: %X			Randomzahl: %d\n",dasMin,dasMax,y);
   return y;
   
   //die Funktion :  GetDateTime(qd.randSeed) jedesmal vorher aufrufen;
   //find random number, and scale it to [0.0..1.0]
   //double r=fabs(random());
   //	printf("dasMin: %d							dasMax: %d",dasMin,dasMax);
   //
   double r=labs(random());
   
   //
   double rr=labs(random());
   
   //printf("\n\nrandom(): %u								fabs(Random()): %u\n",rr,r);
   
   y=(rr - kMinRand) / (kMaxRand + 1.0 - kMinRand);
   
   y=	(float)random() / RAND_MAX * (dasMax + 1);
   
   
   int range = dasMax - dasMin < 0 ? dasMax - dasMin - 1 : dasMax - dasMin + 1;
   int value = (int)(range * ((float)random() / (float) LONG_MAX));
   y=( value == range ? dasMin : dasMin + value);
   
   return y;
   
   
   
   x = (r - kMinRand) / (kMaxRand + 1.0 - kMinRand);
   
   //printf("experiment:y: %d								standard:x: %u\n",y,x);
   
   exprand= (short)(y * (dasMax + 1.0 - dasMin) + dasMin);
   
   //scale x to [min, max + 1.0], truncate, and return result
   rand = (short)(x * (dasMax + 1.0 - dasMin) + dasMin);
   
   
   //printf("ergebnis experiment: %u							standard: %u\n\n",exprand,rand);
   return rand;
}



//*****************************************************************

//*****************************************************************
void 	Reihenfolgebestimmen(short * derVektor,short AnzahlPos,short AnzahlElemente)
{
   /*
    AnzahlElemente wird in Pakete der L√§nge AnzahlPos geteilt. Wenn ein Paket neu anf√§ngt,
    werden auf eine Paketl√§nge die Nummern verteilt. Diese werden in tempVektor fortlaufend
    eingetragen.
    
    */
   short i=0;
   short tempvektor[kArraygrenze]={0};
   short posvektor[kArraygrenze]={0};
   if (AnzahlPos)
   {
      for (short n=0;n<AnzahlElemente;n++)
      {
         i=n%AnzahlPos;
         if ((AnzahlPos>1) &&(i==0))
         {
            Zahlenverteilen(posvektor, AnzahlPos);
         }//if
         tempvektor[n]=posvektor[i];
      }//for n
      for (short k=0;k<AnzahlElemente;k++)
      {
         derVektor[k]=tempvektor[k];
      }
   }//if AnzahlPos
}
//*****************************************************************
//*****************************************************************
void Reihenfolgebestimmenab1(short * derVektor,short AnzahlPos,short AnzahlElemente)
{
   /*
    AnzahlAufgaben wird in Pakete der L√§nge AnzahlPos geteilt. Wenn ein Paket neu anf√§ngt,
    werden auf eine Paketl√§nge die Nummern verteilt. Diese werden in tempVektor fortlaufend
    eingetragen.
    
    */
   short i=0;
   short tempvektor[kArraygrenze]={0};
   short posvektor[kArraygrenze]={0};
   if (AnzahlPos)
   {
      for (short n=0;n<AnzahlElemente;n++)
         //for (short n=0;n<SerieDaten.AnzahlAufgaben;n++)
      {
         i=n%AnzahlPos;
         if ((AnzahlPos>1) &&(i==0))
         {
            Zahlenverteilenab1(posvektor, AnzahlPos);
         }//if
         tempvektor[n]=posvektor[i];
      }//for n
      for (short k=0;k<AnzahlElemente;k++)
      {
         derVektor[k]=tempvektor[k];
      }
   }//if AnzahlPos
}//*****************************************************************
void 	Reihenfolgebestimmenab2(short * derVektor,short AnzahlPos,short AnzahlElemente)
{
   /*
    AnzahlAufgaben wird in Pakete der L√§nge AnzahlPos geteilt. Wenn ein Paket neu anf√§ngt,
    werden auf eine Paketl√§nge die Nummern verteilt. Diese werden in tempVektor fortlaufend
    eingetragen.
    
    */
   short i=0;
   short tempvektor[kArraygrenze]={0};
   short posvektor[kArraygrenze]={0};
   if (AnzahlPos)
   {
      for (short n=0;n<AnzahlElemente;n++)
         //for (short n=0;n<SerieDaten.AnzahlAufgaben;n++)
      {
         i=n%AnzahlPos;
         if ((AnzahlPos>1) &&(i==0))
         {
            Zahlenverteilenab2(posvektor, AnzahlPos);
         }//if
         tempvektor[n]=posvektor[i];
      }//for n
      for (short k=0;k<AnzahlElemente;k++)
      {
         derVektor[k]=tempvektor[k];
      }
   }//if AnzahlPos
}
//*****************************************************************
//*****************************************************************

void Zahlenvektorbestimmen(short * derVektor,short	untereGrenze, short obereGrenze,short AnzahlElemente)
{
   //printf("Zahlenvektorbestimmen untereGrenze: %d\t obereGrenze: %d \t AnzahlElemente: %d\n",untereGrenze,obereGrenze,AnzahlElemente);

   short randEiner[10]={0}, randZehner[10]={0},randHunderter[10]={0};
   short 	randomVektor[kArraygrenze]={0};
   short tempAnzahlElemente;
   
   
   if (AnzahlElemente)
   {
      tempAnzahlElemente=AnzahlElemente;
   }
   else
   {
      tempAnzahlElemente=48;
   }
   //printf("Zahlenvektorbestimmen tempAnzahlElemente: %d\n",tempAnzahlElemente);
   
   //randomVektor=malloc(sizeof( short[tempAnzahlElemente]));
   if (untereGrenze>obereGrenze)
   {
      obereGrenze=untereGrenze+1;//Schutz vor Fehleingabe
   }
   short intervall=obereGrenze-untereGrenze;
   
   //short AaKontrollvektor[kArraygrenze];
   //intervall=4;
   
   if (intervall<tempAnzahlElemente)
   {
      if (intervall)
      {
     //    160426 malloc entfernt
    //     short* 	AngebotVektor;
    //     AngebotVektor= malloc(sizeof( short[intervall]));
         short 	AngebotVektor[kArraygrenze] = {0};
         short nr=0;
         short voll=0;
         while(voll==0)
         {
            Zahlenverteilen(AngebotVektor,intervall);
            for (short ii=0;ii<intervall;ii++)
            {
               if (nr<tempAnzahlElemente)
               {
                  randomVektor[nr]=AngebotVektor[ii];
                  nr++;
               }
            }//for
            if (nr>=tempAnzahlElemente)
            {voll=1;}
         }//voll
         for (short nummer=0;nummer<tempAnzahlElemente;nummer++)
         {
            derVektor[nummer]=untereGrenze+randomVektor[nummer];
         }
 //        free (AngebotVektor);
      }
      else
      {
         for (short nummer=0;nummer<tempAnzahlElemente;nummer++)
         {
            derVektor[nummer]=untereGrenze;
         }
      }
   }//intervall<SerieDaten.AnzahlAufgaben]
   else
      
   {
      
      short Einer=0, Zehner=0,Hunderter=0;
      short tempZahl=0;
      Einer=intervall%10;
      Zahlenverteilen(randEiner, Einer+1);
      for (short nummer=0;nummer<Einer+1;nummer++)
      {
         //printf("randEiner %d\t randEiner(i): %d\n",nummer,randEiner[nummer]);
      }

      intervall/=10;
      if (intervall)
      {
         Zehner=intervall%10;
         Zahlenverteilen(randZehner, Zehner+1);
         for (short nummer=0;nummer<Zehner+1;nummer++)
         {
            //printf("randZehner %d\t randZehner(i): %d\n",nummer,randZehner[nummer]);
         }

      }
      intervall/=10;
      if (intervall)
      {
         Hunderter=intervall%10;
         Zahlenverteilen(randHunderter, Hunderter+1);
      }
      short Einerplatz=0,Zehnerplatz=0, Hunderterplatz=0;
      for (short nummer=0;nummer<tempAnzahlElemente;nummer++)
      {
         if (Einerplatz>Einer)
         {
            Einerplatz-=Randomzahl(1,Einer);
         }//Verschiebung des Neubeginns
         if ((Zehner>0)&&(Zehnerplatz>Zehner-1))
         {
            Zehnerplatz-=Randomzahl(1,Zehner);
         }
         if ((Hunderter>0)&&(Hunderterplatz>Hunderter-1))
         {
            Hunderterplatz-=Randomzahl(1,Hunderter);
         }
         
         tempZahl=randEiner[Einerplatz]+10*randZehner[Zehnerplatz]+100*randHunderter[Hunderterplatz];
         if (Einer)
         {Einerplatz++;}
         if (Zehner)
         {Zehnerplatz++;}
         if (Hunderter)
         {Hunderterplatz++;}
         //randomVektor[nummer]=tempZahl;
         derVektor[nummer]=untereGrenze+tempZahl;
      }//for nummer
   }
   
   //for (short nummer=0;nummer<tempAnzahlElemente;nummer++)
   {
      //printf("%d\t derVektor(i): %d\n",nummer,derVektor[nummer]);
      //derVektor[nummer]=untereGrenze+randomVektor[nummer];
      //AaKontrollvektor[nummer]=derVektor[nummer];
   }
//   free(randomVektor);
   
   
}
//*****************************************************************
//*****************************************************************
short RepTest(short * derVektor, short dieZahl)
{
   for (short k=0;k<kArraygrenze;k++)
   {
      if (dieZahl==derVektor[k])
      {
         return 1;
      }
      
   }//for k
   return 0;
}//RepTest

//*****************************************************************
//*****************************************************************
void RepSet(short * derVektor,short dieZahl)
{
   short k=0;
   short ok=0;
   while (!ok)
   {
      if (derVektor[k]==0)
      {
         derVektor[k]=dieZahl;
         //printf("RepSet dieZahl: %d pos: %d\n",dieZahl, k);
         ok=1;
      }//if
      k++;
      if (k==kArraygrenze)
      {ok=1;}
   }//while
}//RepSet

//*****************************************************************
void RepReset(short * derVektor)
{
   //short x=0;
   //int l= sizeof(derVektor);
   //printf("represet l: %d\n",l);
   for (short k=0;k<kArraygrenze;k++)
   {derVektor[k]=0;}
   
}
//*****************************************************************


/********************************************************************************/
short		string2int(char *	derString)
{
   short len=0;
   while (*(derString++)!='\0')
      len++;
   return len;
}

/********************************************************************************/
/********************************************************************************/
long Zehnerpot(short diePot)
{
   long temp=1;
   for (short i=0;i<diePot;i++)
   {temp*=10;}
   return temp;
}
/********************************************************************************/
/********************************************************************************/
short Maxvon(short ersteZahl, short zweiteZahl)
{
   short tempmax=ersteZahl;
   if (zweiteZahl>ersteZahl)
      tempmax=zweiteZahl;
   return tempmax;
}
/********************************************************************************/
/********************************************************************************/
short Minvon(short ersteZahl, short zweiteZahl)
{
   short tempmin=ersteZahl;
   if (zweiteZahl<ersteZahl)
      tempmin=zweiteZahl;
   return tempmin;
}
/********************************************************************************/

@end

/*

*/