//
//  rRechnung.h
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 15.04.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

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




@interface rRechnungDaten : NSDictionary
{
   
}

@end

const short 	kMaxVariablen=6;
const short 	kMaxOperationen=4;


@interface rRechnung : NSObject
{
   short 				var[6];
//   NSMutableArray* 		varArray;
   short 				op[3];
   short					Ergebnispos;
   int                 aktuelleAufgabennummer;
   
}
@property int                 aktuelleAufgabennummer;
@property NSMutableArray* 		varArray;
@property NSMutableArray*		opArray;


- (int)getVariable:(int)var;
- (int)getOperation:(int)op;
- (int)getErgebnis;
- (void)initWithData:(NSDictionary*)dieDaten;

void 				Aufgabeweg();
void				Aufgabeschreiben();
void				zeichnen();

@end
