/*
 *  BB.cpp
 *  CC
 *
 *  Created by Sysadmin on 15.10.05.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>
#include "rAufgabe.h"
#include <stdlib.h>

rAufgabendaten::rAufgabendaten()
{
for(short i=0;i<kMaxVariablen;i++)
	var[i]=0;
for(short i=0;i<kMaxOperationen;i++)
	op[i]=-1;;

}

//*********************************************

//*********************************************
rAufgabe::rAufgabe()
{
aktuelleAufgabennummer=0;
for(short i=0;i<kMaxVariablen;i++)
		var[i]=0;
for(short i=0;i<kMaxOperationen;i++)
		op[i]=-1;
Ergebnispos=2;//pos des Ergebnisses in var
nextAufgabe=NULL;


}
//*********************************************
//*********************************************
void	rAufgabe::IAufgabe(rAufgabendaten	dieDaten)
{
aktuelleAufgabennummer=dieDaten.aktuelleAufgabennummer;
var[0]=dieDaten.var[0];
var[1]=dieDaten.var[1];
var[2]=dieDaten.var[2];
op[0]=dieDaten.op[0]; 


}
//*********************************************
void 				rAufgabe::Aufgabeweg()
{
var[0]=0;
var[1]=0;
var[2]=0;
op[0]=0; 

}
//*********************************************
short					rAufgabe::getVariable(short	diePosition)
{
return var[diePosition];
}

//*********************************************
short					rAufgabe::getOperation(short	diePosition)
{
return op[diePosition];

}

//*********************************************
short				rAufgabe::getErgebnis()
{
return var[Ergebnispos];
}
//*********************************************
void 	rAufgabe::zeichnen()
{
Aufgabeschreiben();	
if (nextAufgabe&&aktuelleAufgabennummer<24)
	{
	nextAufgabe->zeichnen();
	}
}
//*********************************************
void 	rAufgabe::Aufgabeschreiben()
{
//SetPort(ABFenster->MacFenster);
//TextSize(8);
//s = new char[kLongestString + 1];// allocate
//*s=0; // initialize to null string

char	s[16]={""},  p[16];
short zeile=3+aktuelleAufgabennummer*9;
short spalte=420;

//char * 		p="\0";
strcpy(s,"  \0");
//strcat(s,int2string(long(aktuelleAufgabennummer)));

   /*
strcat(s,". \0");	
MoveTo(spalte,zeile);
short t=strlen(s);
if (strlen(s)==3)
	{
	Move(7,0);
	}
	//DrawChar(' ');
//DrawString(c2pstr(s));
//strcpy(s,"\0");
//strcpy(s,int2string(long(var[0])));
MoveTo(spalte+25+((3-strlen(s))*7),zeile);
//DrawString(c2pstr(s));
//strcpy(s,"\0");
DrawChar(' ');
MoveTo(spalte+48,zeile);
	
	switch (op[0])
		{
		case 1:
			strcpy(s," + \0");
			
			//DrawString(c2pstr(s));

			break;
		case 2:
			strcpy(s," - \0");
			//DrawString(c2pstr(s));
			break;
		case 3:
			strcpy(s," * \0");
			//DrawString(c2pstr(s));
			break;

		}//switch strcpy(s,"\0");

	//strcpy(s,int2string(long(var[1])));			
	MoveTo(spalte+68+((3-strlen(s))*7),zeile);
	//DrawString(c2pstr(s));

	strcpy(s," = \0");
	MoveTo(spalte+100,zeile);
	//DrawString(c2pstr(s));

	//strcpy(s,int2string(long(var[2])));
	MoveTo(spalte+120+((3-strlen(s))*7),zeile);
	//DrawString(c2pstr(s));
*/
}
//*********************************************
//*********************************************
- (void)setAufgabendaten:(NSDictionary*)daten
{
   if (daten.var)
   {
      NSArray* varArray =daten.var;
   }
}
- (id)init
{
   if ([[self super]init])
   {
      return self;
   }
   return nil;
}

- (int)getVariable:(int)var
{
   return var[var];
}


- (int)getOperation:(int)op
{
   return op[op];
}


//*********************************************
//*********************************************
//*********************************************



