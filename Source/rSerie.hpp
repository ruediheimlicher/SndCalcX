/*
 *  rSerie.h
 *  SndCalcII
 *
 *  Created by Sysadmin on 15.10.05.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

//#include <Carbon/Carbon.h>
#include <stdlib.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


//#ifdef __cplusplus


//*********************************************
const short 	kArraygrenze=48;
const short 	kMaxAnzahlAufgaben=24;
const short 	kMaxAnzahlReihen=30;
const short 	kMaxAnzReihen=30;
const short 	kMaxAnzahlReihentasten=25;
const short 	kMaxAnzahlTests=10;
const short 	kMaxAnzahlNamen=10;
const short 	kMaxAnzahlResultate=100;


//*********************************************
static __inline__ int SSRandomIntBetween(int a, int b)
{
    int range = b - a < 0 ? b - a - 1 : b - a + 1; 
    int value = (int)(range * ((float)random() / (float) LONG_MAX));
    return value == range ? a : a + value;
}

const	short 	kAdd=1;
const	short 	kSub=2;
const	short 	kMult=3;
const	short 	kDiv=4;
//*********************************************
const short 	kRichtig=1;
const short 	kFalsch=0;
//const kNochmals=2;
//*********************************************
const short 	kEinerZahlen=1;
const short 	kZehnerZahlen=2;
const	short 	kHunderterZahlen=3;
const short 	kNie=1;
const short 	kImmer=2;
const	short 	kOffen=3;
const short 	kBisZehn=1;
const short 	kBisZwanzig=2;
const	short 	kZehnbisZwanzig=3;
const short 	kZweistellig=4;
const	short 	kDreistellig=5;
//*********************************************
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
//public:
char CUsername[32];
char CVorname[32];
short Usernummer;
Resultatrecord ResultatArray[kMaxAnzahlResultate];

}UserdatenRecord;
//**********************************************************************************

//**********************************************************************************
typedef struct
{
	short	AnzahlAufgaben;
	
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
//**********************************************************************************
typedef struct 
{
short          AnzahlNamen;
short          fileRefNum;
FSSpec			fileFSSpec;
UInt32 RefCon;
ProgPrefsRecord	SerieDaten;

UserdatenRecord  UserDaten[kMaxAnzahlNamen];

}SndCalcPrefsRecord,*SndCalcPrefsP,**SndCalcPrefsH;

//**********************************************************************************
//**********************************************************************************
const short 	kMaxAnzVariablen=6;
const short 	kMaxAnzOperationen=4;
//*********************************************
typedef struct 
{

short				aktuelleAufgabennummer;
short 			var[kMaxAnzVariablen];
short 			op[kMaxAnzOperationen];

}AufgabenDatenRecord;

//*********************************************

//*********************************************
class rNummervektor
{
public: short Platz,aktuelleAufgabennummer;
};
//*********************************************
//*********************************************
class 	rSeriedaten
{
public:
	short 	AnzahlAufgaben,AnzahlReihen;
	
	short 	Addition,Subtraktion,Multiplikation,Division;
	short 	ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
	short	ASmaxZahlVorn;
	
	short	Reihenliste[kMaxAnzahlReihen];
	
	short	MultDivmitAdd,MultDivmitSub,MultDivErgkleiner20;
	short 	MultDivZehnerpotenz1,MultDivZehnerpotenz2;

	short 	Variante,Zeit,Volume;
rSeriedaten();
};
//*********************************************
class rAufgabe;
//*********************************************

class	rSerie
{
short mitEinleitung;
short	Listennummer;
short		AddobereGrenze,SubobereGrenze;
short	 	AdduntereGrenze,SubuntereGrenze;
friend short anzahlStellen(long);
short	Repvektor[kArraygrenze];
public:
rAufgabe	*ersteAufgabe, *aktuelleAufgabe;
short		 *Nummernvektor;

ProgPrefsRecord				SerieDaten;

rSerie(short dieAnzahl);
void						ISerie();
void						setSeriedaten(ProgPrefsRecord dieSeriedaten);
rSeriedaten			*		getDaten();
short						getaktuelleNummer();
void						setDaten(rSeriedaten	*);
void						setOperation(short);
void						Aufgabenbestimmen();
void						AddSubBereichbestimmen();
void						Zahlenverteilen(short * derVektor,short	n);
void						Zahlenverteilenab1(short * derVektor,short	n);
void						Zahlenverteilenab2(short * derVektor,short	n);
void						Zahlenvektorbestimmen(short * derVektor,short	untereGrenze, short obereGrenze,short n=0);

void						neueSerie(ProgPrefsRecord dieSeriedaten,AufgabenDatenRecord* derAufgabenDatenArray);
void 						Serieweg();
short							Randomzahl(short dasMin,short dasMax);
void 						Operationenverteilen(short*);
void 						Reihenfolgebestimmen(short*,short,short);
void 						Reihenfolgebestimmenab1(short*,short,short);
void 						Reihenfolgebestimmenab2(short*,short,short);
void						AufgabeinListe(rAufgabe *	);
void						Aufgabenlisteleeren();
short						getAktuellesErgebnis();
short						getAnzahlAufgaben();
short 					Seriefertig();
short 					RepTest(short *, short dieZahl);
void						RepSet(short *, short dieZahl);
void 						RepReset(short *);
void						Serieschreiben();
};



/********************************************************************************/
short		string2int(char *	derString);
/********************************************************************************/
long Zehnerpot(short diePot);
/********************************************************************************/
/********************************************************************************/
short Maxvon(short ersteZahl, short zweiteZahl);
short Minvon(short ersteZahl, short zweiteZahl);

/********************************************************************************/
//#endif