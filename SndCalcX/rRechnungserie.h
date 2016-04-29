//
//  rRechnungserie.h
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 16.04.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "rRechnung.h"

#define kMaxAnzVariablen   4
#define	kMaxVariablen     6
#define 	kMaxOperationen   4

#define 	kMaxAnzOperationen   4

#define MAXANZREIHEN 48
#define  	kBisZehn 1

#define  	 	kAdd  1
#define  	 	kSub  2
#define  	 	kMult 3
#define        kDiv  4

#define  	 	kEinerZahlen      1
#define  	 	kZehnerZahlen     2
#define  	 	kHunderterZahlen  3
#define  	 	kNie              1
#define        kImmer            2
#define  	 	kOffen            3
#define  	 	kBisZwanzig       2
#define  		kZehnbisZwanzig   3
#define  	 	kZweistellig      4
#define  	 	kDreistellig      5

#define  	 	kMaxAnzahlAufgaben      24
#define  	 	kMaxAnzahlReihen        30
#define  	 	kMaxAnzReihen           30
#define  	 	kMaxAnzahlReihentasten  25
#define  	 	kMaxAnzahlTests         10
#define  	 	kMaxAnzahlNamen         10
#define  	 	kMaxAnzahlResultate     100


//*********************************************
/********************************************************************************/
short		string2int(char *	derString);
/********************************************************************************/
long Zehnerpot(short diePot);
/********************************************************************************/
/********************************************************************************/
short Maxvon(short ersteZahl, short zweiteZahl);
short Minvon(short ersteZahl, short zweiteZahl);
//**********************************************************************************

//**********************************************************************************
//const short 	kMaxAnzVariablen=6;

/********************************************************************************/
//*****************************************************************
//char	OpZeichen[4]={'+','-','*','/'};

//**********************************************************************************
//**********************************************************************************
typedef struct
{
   char 		Testname[32];
   short	Testnummer;
   short 	AnzahlAufgaben,AnzahlReihen;
   
   short 	Addition,Subtraktion,Multiplikation,Division;
   short 	ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
   short	ASmaxZahlVorn;
   
   short		Reihenliste[kMaxAnzReihen];
   
   //short	MultDivmitAdd,MultDivmitSub,MultDivErgkleiner20;
   short 	MultDivZehnerpotenz1,MultDivZehnerpotenz2;
   
   short 	Zeit;
   
}TestRecord;
//**********************************************************************************

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
//*********************************************
typedef struct
{
   
   short				aktuelleAufgabennummer;
   short 				var[kMaxAnzVariablen];
   short 				op[kMaxAnzOperationen];
   
}cAufgabendaten;

//*********************************************
//*********************************************
typedef struct seriedaten
{
   short 	AnzahlAufgaben,AnzahlReihen;
   
   short 	Addition,Subtraktion,Multiplikation,Division;
   short 	ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
   short    ASmaxZahlVorn;
   
   short    Reihenliste[kMaxAnzahlReihen];
   
   short    MultDivmitAdd,MultDivmitSub,MultDivErgkleiner20;
   short 	MultDivZehnerpotenz1,MultDivZehnerpotenz2;
   
   short 	Variante,Zeit,Volume;
   
}cSeriedaten;


//**********************************************************************************
//**********************************************************************************
//**********************************************************************************

//**********************************************************************************
@interface rSeriedaten : NSObject
{
   int		AnzahlAufgaben,AnzahlReihen;
   cSeriedaten Seriedaten;
   /*
   short		Addition,Subtraktion,Multiplikation,Division;
   short		MDZehnerReihen,MDHunderterReihen;
   short		MDKleines1Mal1,MDGrosses1Mal1;
   short		ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
   short	 	ASmaxZahlVorn;
   
   
   short		MultDivZehnerpotenz1,MultDivZehnerpotenz2;
   
   short		MultDivmitAdd,MultDivmitSub,MultDivErgkleiner20;
   
   short		Variante,Zeit,Volume;
    */
@public
   int             Reihenliste[MAXANZREIHEN];
}
@property (nonatomic )int      AnzahlAufgaben,AnzahlReihen;
@property short		Addition,Subtraktion,Multiplikation,Division;
@property short		MDZehnerReihen,MDHunderterReihen;
@property short		MDKleines1Mal1,MDGrosses1Mal1;
@property short		ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
@property short	 	ASmaxZahlVorn;

@property short		MultDivZehnerpotenz1,MultDivZehnerpotenz2;

@property short		MultDivmitAdd,MultDivmitSub,MultDivErgkleiner20;

@property short		Variante,Zeit,Volume;

- (void)setzeAnzahlAufgaben:(short)anzaufgaben;
- (cSeriedaten)getcSeriedaten;
- (cSeriedaten)Objc2CmitSeriedaten:(rSeriedaten*)seriedaten;
@end

/* *******************************************************************************/



@interface rAufgabenDaten : NSObject
{
   @public
   short 				var[6];
   short 				op[3];

}
@property short aktuelleAufgabennummer;
@end

@interface rObjcAufgabendaten : NSObject



@end
/********************************************************************************/

@interface rAufgabe : NSObject
{
   short 				var[6];
   short 				op[3];
   short					Ergebnispos;
   //short 				aktuelleAufgabennummer;
   
}
@property short aktuelleAufgabennummer;
@property rAufgabe* nextAufgabe;
@property short letzteAufgabennummer;

- (void)setAufgabendaten:(NSDictionary*)daten;
- (int)getVariable:(int)var;
- (int)getOperation:(int)op;
- (int)getErgebnis;
- (void)initWithData:(NSDictionary*)dieDaten;


@end
/********************************************************************************/
/********************************************************************************/
@interface rRechnungserie : NSObject
{
   short    mitEinleitung;
   short    Listennummer;
   short		AddobereGrenze,SubobereGrenze;
   short	 	AdduntereGrenze,SubuntereGrenze;
   short    anzahlStellen;
   short    Repvektor[48];
   
   rAufgabe	*ersteAufgabe, *aktuelleAufgabe;
   short		*Nummernvektor;

   cSeriedaten cRechnungSeriedaten;
   rSeriedaten* RechnungSeriedaten;
}
- (id)initWithAnzahl:(int)anzAufgaben;
- (void)setSeriedaten:(rSeriedaten*)dieSeriedaten;
- (NSArray*)neueRechnungserie:(rSeriedaten*)dieSeriedaten ;
- (cSeriedaten*)getDaten;
//- (void)					AddSubBereichbestimmen;
- (void)AddSubBereichbestimmenMitSeriedaten:(rSeriedaten*)dieSeriedaten;

- (void)AufgabeinListe:(rAufgabe *)	dieAufgabe;


// C-Funktionen
short						getaktuelleNummer();
void						setDaten(cSeriedaten);
void						setOperation(short);
void						Aufgabenbestimmen();

void						Zahlenverteilen(short * derVektor,short	n);
void						Zahlenverteilenab1(short * derVektor,short	n);
void						Zahlenverteilenab2(short * derVektor,short	n);
void						Zahlenvektorbestimmen(short * derVektor,short	untereGrenze, short obereGrenze,short n);

//void						neueSerie(ProgPrefsRecord dieSeriedaten,cAufgabendaten* derAufgabenDatenArray);
void 						Serieweg();
short						Randomzahl(short dasMin,short dasMax);
void                 Operationenverteilen(short *	, cSeriedaten);
void 						Reihenfolgebestimmen(short*,short,short);
void 						Reihenfolgebestimmenab1(short*,short,short);
void 						Reihenfolgebestimmenab2(short*,short,short);
//void						AufgabeinListe(rAufgabe *	);
void						Aufgabenlisteleeren();
short						getAktuellesErgebnis();
short						getAnzahlAufgaben();
short 					Seriefertig();
short 					RepTest(short *, short dieZahl);
void						RepSet(short *, short dieZahl);
void 						RepReset(short *);
void						Serieschreiben();

@end

/********************************************************************************/

/********************************************************************************/
