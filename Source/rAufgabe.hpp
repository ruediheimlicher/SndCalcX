/*
 *  BB.h
 *  CC
 *
 *  Created by Sysadmin on 15.10.05.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

//#include <Carbon/Carbon.h>
#include <stdlib.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


#ifdef __cplusplus

const short 	kMaxVariablen=6;
const short 	kMaxOperationen=4;
//*********************************************
class rAufgabendaten
{
public:
short aktuelleAufgabennummer;
short 				var[kMaxVariablen];
short 				op[kMaxOperationen];
rAufgabendaten();
};
//*********************************************
//*********************************************
class	rAufgabe
{
short 				var[6];
short 				op[3];
short					Ergebnispos;

public:
short					getVariable(short);
short					getOperation(short);
short					getErgebnis();

short 				aktuelleAufgabennummer;
rAufgabe	* 	nextAufgabe;
rAufgabe();
void				IAufgabe(rAufgabendaten	dieDaten);
void 				Aufgabeweg();
void				Aufgabeschreiben();
void				zeichnen();
};
#endif
//*********************************************
//*********************************************

@interface rObjcAufgabe : NSObject
{
   short 				var[6];
   short 				op[3];
   short					Ergebnispos;
   short 				aktuelleAufgabennummer;
}
- (void)setAufgabendaten:(NSDictionary*)daten;
- (int)getVariable:(int)var;
- (int)getOperation:(int)op;
- (int)getErgebnis;
- (void)initWithData:(NSDictionary*)dieDaten;


@end
