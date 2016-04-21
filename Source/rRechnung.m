//
//  rRechnung.m
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 15.04.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#import "rRechnung.h"

@implementation rRechnung


//*********************************************
- (void)setAufgabendaten:(NSDictionary*)daten
{
   if ([daten objectForKey:@"var"])
   {
      NSArray* varArray =[daten objectForKey:@"var"];
   }
}
- (id)init
{
   if ([super init])
   {
      aktuelleAufgabennummer=0;
      for(short i=0;i<kMaxVariablen;i++)
         var[i]=0;
      for(short i=0;i<kMaxOperationen;i++)
         op[i]=-1;
      Ergebnispos=2;//pos des Ergebnisses in var
  //    nextAufgabe=NULL;

      return self;
   }
   return nil;
}

- (int)getVariable:(int)variable
{
   return [[_varArray objectAtIndex:variable]intValue];
}


- (int)getOperation:(int)operator
{
   return op[operator];
}

- (int)getErgebnis
{
   return var[Ergebnispos];
}
//*********************************************


//*********************************************
//*********************************************
//*********************************************

@end
