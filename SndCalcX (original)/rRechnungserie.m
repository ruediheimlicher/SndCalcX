//
//  rRechnungserie.m
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 16.04.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#import "rRechnungserie.h"

#define  kArraygrenze 48

#define GRENZE 48



#define kDreistellig 5
//*********************************************

const short 	kMaxVariablen=6;
const short 	kMaxOperationen=4;

const short 	kMaxAnzOperationen=4;

//*********************************************
//const short 	kArraygrenze=48;





//*********************************************
static __inline__ int SSRandomIntBetween(int a, int b)
{
   int range = b - a < 0 ? b - a - 1 : b - a + 1;
   int value = (int)(range * ((float)random() / (float) LONG_MAX));
   return value == range ? a : a + value;
}

//**********************************************************************************
typedef 	struct
{
   short AnzahlAufgaben,Addition,Subtraktion,Multiplikation,Division;
   short ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
   
   
   short	MultDivmitAdd,MultDivmitSub,MultDivErgkleiner20;
   short	MultDivZehnerpotenz1,MultDivZehnerpotenz2;
   short	Reihe0,Reihe1,Reihe2,Reihe3,Reihe4,Reihe5,Reihe6,Reihe7,Reihe8,Reihe9,Reihe10,Reihe11;
   short Reihe12,Reihe13,Reihe14,Reihe15,Reihe16,Reihe17,Reihe18,Reihe19,Reihe20,Reihe21,Reihe22,Reihe23;
   short Reihe24,Reihe25,Reihe26,Reihe27,Reihe28,Reihe29;
   short Zeit;
   short Variante;
   short Volume;
}ResPrefRecord,*	ResPrefP,**	ResPrefH;
//**********************************************************************************
//**********************************************************************************
typedef struct
{
   short Testnummer;
   short Rechenzeit;
   short AnzahlFehler;
   long Datum;
   
}Resultatrecord,*ResultatP,**ResultatH;
//**********************************************************************************

//**********************************************************************************
typedef struct
{
   char CUsername[32];
   char CVorname[32];
   short Usernummer;
   Resultatrecord ResultatArray[kMaxAnzahlResultate];
   
}UserdatenRecord;
//**********************************************************************************

//**********************************************************************************
typedef struct
{
   short    AnzahlAufgaben;
   
   short 	Addition,Subtraktion,Multiplikation,Division;
   short 	ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
   short 	MultDivZehnerpotenz1,MultDivZehnerpotenz2;
   
   short	Reihe0,Reihe1,Reihe2,Reihe3,Reihe4,Reihe5,Reihe6;
   short Reihe7,Reihe8,Reihe9,Reihe10,Reihe11,Reihe12;
   short Zeit;
}TestPrefRecord,*TestPrefP,**TestPrefH;

//**********************************************************************************
//**********************************************************************************
typedef struct
{
   char 		Testname[32];
   short	Testnummer;
   short 	AnzahlAufgaben,AnzahlReihen;
   
   short 	Addition,Subtraktion,Multiplikation,Division;
   short 	ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
   short    ASmaxZahlVorn;
   
   short		Reihenliste[kMaxAnzReihen];
   
   //short	MultDivmitAdd,MultDivmitSub,MultDivErgkleiner20;
   short 	MultDivZehnerpotenz1,MultDivZehnerpotenz2;
   
   short 	Zeit;
   
}TestRecord;
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
typedef struct
{
   short		AnzahlAufgaben,AnzahlReihen;
   
   short		Addition,Subtraktion,Multiplikation,Division;
   short		MDZehnerReihen,MDHunderterReihen;
   short		MDKleines1Mal1,MDGrosses1Mal1;
   short		ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
   short	 	ASmaxZahlVorn;
   
   short		Reihenliste[kMaxAnzReihen];
   short		MultDivZehnerpotenz1,MultDivZehnerpotenz2;
   
   short		MultDivmitAdd,MultDivmitSub,MultDivErgkleiner20;
   
   short		Variante,Zeit,Volume;
   TestRecord	TestDaten[kMaxAnzahlTests];
}ProgPrefsRecord;
//**********************************************************************************
//**********************************************************************************
typedef struct
{
   short AnzahlNamen;
   short fileRefNum;
   ProgPrefsRecord	SerieDaten;
   
   UserdatenRecord  UserDaten[kMaxAnzahlNamen];
   
}SndCalcPrefsRecord,*SndCalcPrefsP,**SndCalcPrefsH;

//**********************************************************************************
//**********************************************************************************
//*********************************************
typedef struct
{
   
   short				aktuelleAufgabennummer;
   short 				var[kMaxVariablen];
   short 				op[kMaxAnzOperationen];
   
}AufgabenDatenRecord;

//*********************************************


//*********************************************
typedef struct
{
   short Platz,aktuelleAufgabennummer;
}Nummernvektor;
//*********************************************
//*********************************************
typedef struct seriedaten
{
   short 	AnzahlAufgaben,AnzahlReihen;
   
   short 	Addition,Subtraktion,Multiplikation,Division;
   short 	ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
   short	ASmaxZahlVorn;
   
   short	Reihenliste[kMaxAnzahlReihen];
   
   short	MultDivmitAdd,MultDivmitSub,MultDivErgkleiner20;
   short 	MultDivZehnerpotenz1,MultDivZehnerpotenz2;
   
   short 	Variante,Zeit,Volume;
   
}Seriedaten;

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
      AnzahlAufgaben = 13;

      return self;
   }
   return nil;
}
- (void)setzeAnzahlAufgaben:(short)anzaufgaben
{
   //self.AnzahlAufgaben = anzaufgaben;
   AnzahlAufgaben = 13;
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
- (id)init:(int)anzAufgaben
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



- (void)setSeriedaten:(ProgPrefsRecord) dieSeriedaten
{
   printf("rSerie::setSeriedaten \n");
   printf("dieSeriedaten:Addition:%d\n",dieSeriedaten.Addition);
   printf("dieSeriedaten:Addition:%d\n",dieSeriedaten.Subtraktion);
   printf("dieSeriedaten:Addition:%d\n",dieSeriedaten.Multiplikation);
   printf("dieSeriedaten:Addition:%d\n",dieSeriedaten.Division);
   
   //for (int i=0;
}

- (Seriedaten*)getDaten
{
   return 0;
}

- (NSArray*)neueSerie:(ProgPrefsRecord)dieSeriedaten AufgabenDaten:(AufgabenDatenRecord*) derAufgabenDatenArray;
{
  
   //fprintf(stderr,"neueSerie Start\n");
   RechnungSeriedaten = dieSeriedaten;
   //RechnungSeriedaten.AnzahlAufgaben=dieSeriedaten.AnzahlAufgaben;
   //srand([[NSDate date] timeIntervalSince1970]);
   //printf("neueSerie 1\n");
   //int anzahl=10;
   
   short Einer=0, Zehner=0,Hunderter=0;

   short	AddResultatvektor[48];		//?
   short	SubResultatvektor[48]={0};		//?
   
   short 	AddSubResultatvektor[48]={0};
   short	AddSubVar1vektor[48]={0};
   short	AddSubResultatRepvektor[48];
   short	AddSubVar1Repvektor[48];
   
   short	*	MultVar0vektor={0};
   short	*	MultVar1vektor={0};
   short	*	MultResultatvektor={0};
   short	*	Operation1vektor={0};
   
   RepReset(AddSubResultatRepvektor);
   RepReset(AddSubVar1Repvektor);
   //GetDateTime((unsigned long *) &qd.randSeed);
   
   typedef short Reihenfaktor[10];
   short tempVar1vektor[48]={0};
   //printf("SerieDaten.Multiplikation: %d\n",SerieDaten.Multiplikation);
   if  (!RechnungSeriedaten.Addition && !RechnungSeriedaten.Subtraktion && ! RechnungSeriedaten.Multiplikation)
   {
      //printf("neueSerie: keine Operation 2\n");
      //SysBeep(8);
      //short Fehler=FehlermitOK(kSeriedatenfehler,kMindestenseineOperation);
   }
   else
   {
      //printf("neueSerie 2\n");
      //										aktuelleAufgabennummern verteilen
      
      short Nummernvektor[48]={0};
      Zahlenverteilen(Nummernvektor,RechnungSeriedaten.AnzahlAufgaben);
      short AaKontrollvektor[48]={0};
      long AlKontrollvektor[48]={0};
      
      Zahlenverteilen(AaKontrollvektor,48);
      
      short ** Reihenfaktorarray;
      short	*	ReihenposArray={0};
      //																				1.Variable:		Faktoren der Reihenaufgaben
      
      struct rAddSubDaten{short UGrenze,OGrenze,Bereich, Summand, Ergebnis;}	AddSubDaten[48];
      
      //printf("rSerie::neueSerie Add: %d  Sub: %d  Mult: %d\n",SerieDaten.Addition,SerieDaten.Subtraktion,SerieDaten.Multiplikation);
      
      if ((RechnungSeriedaten.Addition==1) ||(RechnungSeriedaten.Subtraktion==1))
      {
         //printf("Addition oder Subtraktion\n");
         //AddSubResultatvektor=new short[kArraygrenze];
         //AddSubVar1vektor=new short[kArraygrenze];
         
         // 1. Obere und untere Grenze der Ergebnisse bestimmen
         
         [self AddSubBereichbestimmen];
         
         //printf("neueSerie: 1\n");
         // 2. Resultate fuer alle Aufgaben bestimmen
         Zahlenvektorbestimmen(AddSubResultatvektor,	AdduntereGrenze,  AddobereGrenze, 48);
         //printf("neueSerie: 2\n");
         
         // 3. Generelle Grenzen der zweiten Zahl bestimmen
         short i=0;
         for (i=0;i<48;i++)
         {AaKontrollvektor[i]=AddSubResultatvektor[i];}
         
         short minVar1=1,maxVar1=1;
         switch (RechnungSeriedaten.ASzweiteZahl)
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
         
         //5.	Fuer jede Aufgabe die Grenzen korrigieren, sofern noetig
         short hoppla=0;
         for (short nummer=0;nummer<48;nummer++)
         {
            short tempErgebnis=AddSubResultatvektor[nummer];
            
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
            if ((RechnungSeriedaten.ASBereich>kBisZehn)&&(RechnungSeriedaten.ASzweiteZahl==kBisZehn))//Bereich min bis 20
               //if ((SerieDaten.ASBereich>kZehnbisZwanzig)&&(SerieDaten.ASzweiteZahl==kBisZehn))
               
               switch(RechnungSeriedaten.ASZehnerU)					//Bereich bei Zehneruebergang anpassen
            {
               case kNie:
                  if (einer==1)			//Bereich vergr√∂ssern
                  {
                     einer+=1;
                     tempErgebnis+=1;
                  }
                  tempmaxVar1=einer;//zur√ºck auf den Zehner
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
            //		printf("neueSerie: nummer:  %d	tempminVar1: %d tempmaxVar1: %d  tempErgebnis: %d\n",nummer,tempminVar1,tempmaxVar1,tempErgebnis);
            AddSubDaten[nummer].OGrenze=tempmaxVar1;  //OGrenze fuer 2. Zahl
            AddSubDaten[nummer].UGrenze=tempminVar1;	//UGrenze fuer 2. Zahl
            AddSubDaten[nummer].Bereich=tempmaxVar1-tempminVar1+1; //moeglicher Variationsbereich des Summanden
            AddSubDaten[nummer].Summand=0;
            AddSubDaten[nummer].Ergebnis=tempErgebnis;
            
         }//for nummer
         
         //printf("neueSerie: 5\n");
         for (short ii=0;ii<48;ii++)
         {
            //AaKontrollvektor[ii]=AddSubDaten[ii].Ergebnis*1000+AddSubDaten[ii].Bereich;
            AlKontrollvektor[ii]=(long)AddSubDaten[ii].Ergebnis*1000+AddSubDaten[ii].Bereich;
         }
         //printf("neueSerie: 6\n");
         /*
          Jede Aufgabe hat jetzt ein Ergebnis und einen passsenden Bereich, in dem die zweite Variable
          liegen kann
          */
         
         short tempBereich=maxVar1;								//max m√∂glicher Bereich, bei erster Var=1
         for (short k=0;k<kArraygrenze;k++)
         {
            if (AddSubDaten[k].Bereich<=tempBereich)
            {tempBereich=AddSubDaten[k].Bereich;}			//Kleinsten Bereich in AddSubDaten suchen
            //ergibt Startbereich fuer while
         }
         //printf("neueSerie: 7\n");
         
         short DatenimBereich=0;									//Anzahl der im tempbereich liegenden Datensaetze
         short AufgabenNrvektor[kArraygrenze]={0};				//Aufgabennummern der im tempbereich liegenden Datensaetze
         short tempSummandvektor[kArraygrenze]={0};
         short Aufgabennummer=0,Laufnummer=0,Durchgang=0;
         short schonDa=0;										//
         short tempSummand=0;
         short tempErgebnis=0;
         short tempUGrenze=0;
         
         while (tempBereich<=(maxVar1))
         {
            DatenimBereich=0;
            for (short ii=0;ii<kArraygrenze;ii++)
            {AufgabenNrvektor[ii]=0;}									//Vektor leeren
            
            for (short tempNummer=0;tempNummer<kArraygrenze;tempNummer++)	//Bereiche abfragen
            {
               if (AddSubDaten[tempNummer].Bereich==tempBereich)			//Aufgabe mit gleichem Bereich
               {
                  AufgabenNrvektor[DatenimBereich++]=tempNummer;			//Aufgabennummer merken
                  
                  //14.9.06
                  //				DatenimBereich++;
                  
               }
            }//for tempNummer
            
            //printf("neueSerie: 8\n");
            if (DatenimBereich) //vorher (tempBereich)
            {
               
               for (short ii=0;ii<kArraygrenze;ii++)
               {
                  tempSummandvektor[ii]=0;								//Vektor leeren
               }
               
               //Reihenfolgebestimmen(tempSummandvektor,tempBereich,DatenimBereich);
               
               Zahlenvektorbestimmen(tempSummandvektor,0,tempBereich-1,DatenimBereich);
               for (short i=0;i<DatenimBereich;i++)
               {
                  
                  switch (RechnungSeriedaten.ASZehnerU)
                  {
                     case kImmer:
                     case kOffen:
                        if ((RechnungSeriedaten.ASBereich>kBisZwanzig)&&(RechnungSeriedaten.ASzweiteZahl==kBisZehn))
                           //						if ((SerieDaten.ASBereich>kBisZehn)&&(SerieDaten.ASzweiteZahl==kBisZehn))
                           tempSummandvektor[i]=maxVar1-tempSummandvektor[i];
                        break;
                     case kNie:
                        break;
                        //					case kOffen:
                        //						break;
                  }
                  switch (RechnungSeriedaten.ASzweiteZahl)
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
            
            for (short ii=0;ii<kArraygrenze;ii++)
            {
               if (ii<DatenimBereich)
                  AaKontrollvektor[ii]=tempSummandvektor[ii];
               else
                  AaKontrollvektor[ii]=0;
            }
            
            for (short i=0;i<DatenimBereich;i++)
            {
               AddSubDaten[AufgabenNrvektor[i]].Summand=tempSummandvektor[i];
            }
            //delete[] tempSummandvektor;
            tempBereich++;
            //Laufnummer++;Aufgabennummer++;
         }//while tempBereich<10)
         
         //printf("neueSerie: 10\n");
         Aufgabennummer=0,Laufnummer=0,Durchgang=0;
         schonDa=0;
         tempSummand=0;
         tempErgebnis=0;
         while ((Aufgabennummer<RechnungSeriedaten.AnzahlAufgaben)&&(Laufnummer<GRENZE))
         {
            //printf("neueSerie:Aufgabennummer: %d Laufnummer: %d\n",Aufgabennummer,Laufnummer);
            tempSummand=AddSubDaten[Laufnummer].Summand;
            tempErgebnis=AddSubDaten[Laufnummer].Ergebnis;
            if ((!RepTest(AddSubVar1Repvektor,tempSummand))&&(!RepTest(AddSubResultatRepvektor,tempErgebnis)))
            {
               AddSubResultatvektor[Aufgabennummer]=tempErgebnis;
               AddSubVar1vektor[Aufgabennummer]=tempSummand;
               RepSet(AddSubVar1Repvektor,tempSummand);
               RepSet(AddSubResultatRepvektor,tempErgebnis);
               Aufgabennummer++;
            }
            else
            {
            }
            Laufnummer++;
            if ((Laufnummer==kArraygrenze)&&(Aufgabennummer-1<=RechnungSeriedaten.AnzahlAufgaben))
            {
               RepReset(AddSubVar1Repvektor);
               RepReset(AddSubResultatRepvektor);
               Laufnummer=Aufgabennummer;
            }
            
         }//while Aufgabennummer
         //printf("neueSerie: 12\n");
      }//Add oder Sub
      
      //printf("neueSerie: 13\n");
      
      
      if (RechnungSeriedaten.Multiplikation &&RechnungSeriedaten.AnzahlReihen)
      {
         //printf("neueSerie 14\n");
         struct rRep{short ersteVar,zweiteVar;}	MultRep[GRENZE];
         
         for (short i=0;i<kArraygrenze;i++)
         {
            MultRep[i].ersteVar=0;MultRep[i].zweiteVar=0;
         }
         //																				F√ºr jede ausgew√§hlte Reihe wird eine Zeile angelegt
         //Reihenfaktorarray= new short * [RechnungSeriedaten.AnzahlReihen];
         Reihenfaktorarray = malloc(sizeof(short[RechnungSeriedaten.AnzahlReihen]));
         for (short zeile=0;zeile<RechnungSeriedaten.AnzahlReihen;zeile++)
         {
            Reihenfaktorarray[zeile]=malloc(sizeof(short[kArraygrenze]));	//Randomzahlen f√ºr die erste Variable
            
            // 7.12.2011: Grenze auf 8 red, 10* xy fällt weg
            
            Reihenfolgebestimmenab2(Reihenfaktorarray[zeile],8,kArraygrenze);
         }
         //																		2. Varilable:		Reihenfolge der Reihen bestimmen
         ReihenposArray=malloc(sizeof(short[kArraygrenze]));
         Reihenfolgebestimmen(ReihenposArray,RechnungSeriedaten.AnzahlReihen,kArraygrenze);
         
         for (short i=0;i<kArraygrenze;i++)
         {AaKontrollvektor[i]=Reihenfaktorarray[0][i];}
         for (short i=0;i<kArraygrenze;i++)
         {AaKontrollvektor[i]=ReihenposArray[i];}
         
         //MultVar0vektor=new short[RechnungSeriedaten.AnzahlAufgaben];
         MultVar0vektor= malloc(sizeof(short[RechnungSeriedaten.AnzahlAufgaben]));

         //MultVar1vektor=new short[RechnungSeriedaten.AnzahlAufgaben];
         MultVar1vektor= malloc(sizeof(short[RechnungSeriedaten.AnzahlAufgaben]));

         
         short Aufgabennummer=0,Laufnummer=0,Durchgang=0;;
         short schonDa=0;
         short	tempPos=0;
         short	tempFaktor=0;
         short tempReihe=0;
         
         while ((Aufgabennummer<RechnungSeriedaten.AnzahlAufgaben)&&(Laufnummer<kMaxAnzahlAufgaben)
                &&(Durchgang<10))
         {
            schonDa=0;
            tempPos=ReihenposArray[Laufnummer];
            tempReihe=RechnungSeriedaten.Reihenliste[tempPos];
            tempFaktor=Reihenfaktorarray[tempPos][Laufnummer];
            
            for (short k=0;k<Aufgabennummer;k++)
            {
               if ((tempFaktor==MultVar0vektor[k])&&(tempReihe==MultVar1vektor[k]))
               {
                  if (RechnungSeriedaten.AnzahlReihen>1)
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
               MultVar1vektor[Aufgabennummer]=tempReihe*Zehnerpot(RechnungSeriedaten.MultDivZehnerpotenz2);
               Aufgabennummer++;
            }
            Laufnummer++;
            if (Laufnummer==kMaxAnzahlAufgaben)
            {
               for (short zeile=0;zeile<RechnungSeriedaten.AnzahlReihen;zeile++)
               {
                  Reihenfolgebestimmenab2(Reihenfaktorarray[zeile],9,kArraygrenze);
               }
               //																		2. Varilable:		Reihenfolge der Reihen bestimmen
               Reihenfolgebestimmen(ReihenposArray,RechnungSeriedaten.AnzahlReihen,kArraygrenze);
               Laufnummer=0;
            }
         }//while
      }//if SerieDaten.AnzahlReihen
      
      //																							Resultate f√ºr Add und Sub verteilen
      //AddResultatvektor=new short[SerieDaten.AnzahlAufgaben];
      //SubResultatvektor=new short[SerieDaten.AnzahlAufgaben];
      
      //printf("neueSerie 15\n");
      Zahlenvektorbestimmen(AddResultatvektor,	AdduntereGrenze,  AddobereGrenze,	RechnungSeriedaten.AnzahlAufgaben);
      Zahlenvektorbestimmen(SubResultatvektor,	AdduntereGrenze,  AddobereGrenze,	RechnungSeriedaten.AnzahlAufgaben);
      
      
      
      for (short i=0;i<RechnungSeriedaten.AnzahlAufgaben;i++)
      {AaKontrollvektor[i]=AddResultatvektor[i];}
      
      //																				Reihenfolge der gew√§hlten Operationen bestimmen
      //Operation1vektor=new short[RechnungSeriedaten.AnzahlAufgaben];
      Operation1vektor= malloc(sizeof(short[RechnungSeriedaten.AnzahlAufgaben]));

 // ***     Operationenverteilen(Operation1vektor);
      
      for (short i=0;i<RechnungSeriedaten.AnzahlAufgaben;i++)
      {AaKontrollvektor[i]=Operation1vektor[i];}
      
      AufgabenDatenRecord tempADat;

      rAufgabe * tempAufgabe;
      
      char z;short n;
      short tempvar0=0,tempvar1=0,tempErgebnis=0;
      //printf("neueSerie 16\n");
      
      int anz=RechnungSeriedaten.AnzahlAufgaben;
      //printf("neueSerie 4: anz: %d\n",anz);
      
      
      for (int nummer=0;nummer<RechnungSeriedaten.AnzahlAufgaben;nummer++)
      {
         //printf("neueSerie: Nummer: %d\n",nummer);	
         tempADat.aktuelleAufgabennummer=nummer+1;
         tempADat.op[0]=Operation1vektor[nummer];
         
         tempvar0=0;
         tempvar1=0;
         tempErgebnis=0;
         switch (tempADat.op[0])
         {
            case kAdd:
               tempErgebnis=AddSubResultatvektor[nummer];
               tempvar1=AddSubVar1vektor[nummer];
               tempvar0=tempErgebnis-tempvar1;
               tempADat.var[2]=tempErgebnis;
               tempADat.var[0]=tempvar0;
               tempADat.var[1]=tempvar1;
               break;//Add
               
               
            case kSub:
               tempvar0=AddSubResultatvektor[nummer];
               tempvar1=AddSubVar1vektor[nummer];
               tempErgebnis=tempvar0-tempvar1;
               tempADat.var[2]=tempErgebnis;
               tempADat.var[0]=tempvar0;
               tempADat.var[1]=tempvar1;
               
               break;
            case kMult:
               
               tempvar0=MultVar0vektor[nummer];
               tempvar1=MultVar1vektor[nummer];
               tempADat.var[0]=tempvar0;
               tempADat.var[1]=tempvar1;
               tempADat.var[2]=tempvar0*tempvar1;
               break;
               
               //}//switch (Operation1vektor[nummer])
               break;//if opzeichen<2 (add oder sub)
         }//switch tempADat.op[0]
         
         
   //      rAufgabe*  tempAufgabe;
         
   //      AufgabeinListe(tempAufgabe);
         
         //printf("nummer: %d var 0: %d op: %d var 1: %d var 2: %d\n",nummer,tempADat.var[0],tempADat.op[0],tempADat.var[1],tempADat.var[2]);
         
         derAufgabenDatenArray[nummer].aktuelleAufgabennummer=nummer+1;
         
         derAufgabenDatenArray[nummer].op[0]=tempADat.op[0];
         derAufgabenDatenArray[nummer].var[0]=tempADat.var[0];
         derAufgabenDatenArray[nummer].var[1]=tempADat.var[1];
         derAufgabenDatenArray[nummer].var[2]=tempADat.var[2];
         //printf("neueSerie: Nummer Ende: %d\n",nummer);	
         
      }//for nummer
      //for (short i=0;i<SerieDaten.AnzahlAufgaben;i++)
      //{AaKontrollvektor[i]=Operation1vektor[i];}
      
      //fprintf(stderr,"neueSerie Ende\n");
      
      
      //delete[]	AddResultatvektor;
      //free	(Operation1vektor);
      //delete[]	Nummernvektor;
      
   }//if (SerieDaten.Addition && SerieDaten.Subtraktion &&  SerieDaten.Multiplikation)
   
   //printf("neueSerie ganz zu Ende\n");
   return nil;
}
//*****************************************************************
//*****************************************************************
   void	Zahlenverteilen(short * derVektor,short	n)
   {
      short tausch=TRUE;
      typedef struct
      {
         short a,b;
         
      }Element;
      Element Elementvektor[kArraygrenze];
      
      Element tempElement;
      
      if (n>kArraygrenze)
      {n=kArraygrenze;}
      
      for (short i=0;i<kArraygrenze;i++)
      {
         tempElement.a=i;
         if (i<n)
         {
            Elementvektor[i].b=random();
            //printf("vektor: i; %d Zahl:%d\n",i,vektor[i].b);
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
      for (short k=0;k<n;k++)
      {
         derVektor[k]=Elementvektor[k].a;
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
         Elementvektor[i].b=random();
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
         Elementvektor[i].b=random();
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
- (void)AddSubBereichbestimmen
{
   //printf("rSerie: SerieDaten.ASBereich: %d\n",SerieDaten.ASBereich);
   switch (RechnungSeriedaten.ASBereich)
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
   
   y=SSRandomIntBetween(dasMin,dasMax);
   //printf("dasMin: %x			dasMax: %X			Randomzahl: %d\n",dasMin,dasMax,y);
   return y;
   
   //die Funktion :  GetDateTime(qd.randSeed) jedesmal vorher aufrufen;
   //find random number, and scale it to [0.0..1.0]
   //double r=fabs(random());
   //	printf("dasMin: %d							dasMax: %d",dasMin,dasMax);
   //
   double r=fabs(random());
   
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
   short randEiner[10]={0}, randZehner[10]={0},randHunderter[10]={0};
   short* 	randomVektor;
   short tempAnzahlElemente;
   /*
   if (AnzahlElemente)
      tempAnzahlElemente=AnzahlElemente;
   else
      tempAnzahlElemente=RechnungSeriedaten.AnzahlAufgaben;
   randomVektor=new short[tempAnzahlElemente];
   */
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
         short* 	AngebotVektor;
         AngebotVektor= malloc(sizeof( short[intervall]));
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
         free (AngebotVektor);
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
      intervall/=10;
      if (intervall)
      {
         Zehner=intervall%10;
         Zahlenverteilen(randZehner, Zehner+1);
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
         {Einerplatz-=Randomzahl(1,Einer);}//Verschiebung des Neubeginns
         if ((Zehner>0)&&(Zehnerplatz>Zehner-1))
         {Zehnerplatz-=Randomzahl(1,Zehner);}
         if ((Hunderter>0)&&(Hunderterplatz>Hunderter-1))
         {Hunderterplatz-=Randomzahl(1,Hunderter);}
         
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
      //derVektor[nummer]=untereGrenze+randomVektor[nummer];
      //AaKontrollvektor[nummer]=derVektor[nummer];
   }
  // free( randomVektor[]);
   
   
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