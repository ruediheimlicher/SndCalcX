//
//  rRechnungserie.h
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 16.04.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "rRechnung.h"


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

/********************************************************************************/
//*****************************************************************
//char	OpZeichen[4]={'+','-','*','/'};

//**********************************************************************************
//**********************************************************************************
//**********************************************************************************
//**********************************************************************************

//**********************************************************************************
@interface rSeriedaten : NSObject
{
   //short		AnzahlAufgaben,AnzahlReihen;
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
   short             Reihenliste[MAXANZREIHEN];
}
@property short      AnzahlAufgaben,AnzahlReihen;
@property short		Addition,Subtraktion,Multiplikation,Division;
@property short		MDZehnerReihen,MDHunderterReihen;
@property short		MDKleines1Mal1,MDGrosses1Mal1;
@property short		ASBereich, ASzweiteZahl, ASZehnerU, ASHunderterU;
@property short	 	ASmaxZahlVorn;

@property short		MultDivZehnerpotenz1,MultDivZehnerpotenz2;

@property short		MultDivmitAdd,MultDivmitSub,MultDivErgkleiner20;

@property short		Variante,Zeit,Volume;


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
