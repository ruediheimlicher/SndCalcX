//
//  rResultatFeld.m
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 27.04.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#import "rResultatFeld.h"


@implementation rResultatEingabeCheck: NSFormatter

- (id)init
{
   DezimalZahlen=[NSCharacterSet decimalDigitCharacterSet];
   //[DezimalZahlen retain];
   anzStellen=0;
   anzFalschesZeichen=0;
   return [super init];
}

- (void)resetZahl
{
   anzStellen=0;
}

- (void)resetAnzFalschesZeichen
{
   anzFalschesZeichen=0;
   
}



- (BOOL)isPartialStringValid:(NSString *)partialString
            newEditingString:(NSString **)newString
            errorDescription:(NSString **)error
{
   BOOL EingabeOK=YES;
   //NSLog(@"isPartialStringValid partialString: %@ anzStellen: %d length: %d",partialString,anzStellen,[partialString length]);
   
   if ([partialString length])//Eingabe vorhanden
   {
      //		NSLog(@"isPartialStringValid partialString: %@ anzStellen: %d length: %d",partialString,anzStellen,[partialString length]);
      //[*newString setStringValue:@"Hallo"];
      //		const char* code=[[partialString substringFromIndex:[partialString length]-1] UTF8String];
      //		int c=(int)[partialString characterAtIndex:[partialString length]-1];
      //	NSLog(@"isPartialStringValid partialString code: %c int: %d",code,c);
      //		int DezimalOK=[DezimalZahlen  characterIsMember:[partialString characterAtIndex:[partialString length]-1]];
      //		NSLog(@"Zeichen: %c DezimalOK: %d",[partialString characterAtIndex:[partialString length]-1],DezimalOK);
      //		NSLog(@"Zeichen: %c DezimalOK: %d",c,DezimalOK);
      EingabeOK=([partialString length]<4&&[DezimalZahlen  characterIsMember:[partialString characterAtIndex:[partialString length]-1]]);
      //		NSLog(@"isPartialStringValid partialString EingabeOK: %d anzFalschesZeichen: %d",EingabeOK,anzFalschesZeichen);
      if (!EingabeOK)
      {
         anzFalschesZeichen++;
         //		}
         //		if (anzFalschesZeichen)// daneben gehackt
         //		{
         //			NSLog(@"isPartialStringValid: daneben gehackt");
         
         NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
         [NotificationDic setObject:[NSNumber numberWithInt:anzFalschesZeichen] forKey:@"anzfalscheszeichen"];
         [nc postNotificationName:@"FalschesZeichen" object:self userInfo:NotificationDic];
         
      }
      anzStellen=(int)[partialString length];
      
   }
   return EingabeOK;
}

- (NSString *)stringForObjectValue:(id)anObject
{
   //	NSLog(@"stringForObjectValue anObject: %@",[anObject description]);
   
   if (![anObject isKindOfClass:[NSString class]])
   {
      NSLog(@"stringForObjectValue: Kein Objekt der Klasse");
      return nil;
   }
   int a=[anObject intValue];
   if ([anObject length])
   {
      //	NSLog(@"stringForObjectValue: a: %d",a);
      NSString* returnString=[[NSNumber numberWithInt:a]stringValue];
      //	NSLog(@"stringForObjectValue: returnString: %@",returnString);
      
      return returnString;
   }
   else
   {
      return @"";
   }
   
   //    return [NSString stringWithFormat:@"Korrigiert:%@", anObject ];
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString  **)error
{
   //NSLog(@"getObjectValue");
   *anObject=string;
   //NSLog(@"getObjectValue string: %@",string);
   return YES;
}


@end


@implementation rResultatFeld

- (id)initWithFrame:(NSRect)frame
{
   self=[super initWithFrame:frame];
   DezimalZahlen=[NSCharacterSet decimalDigitCharacterSet];
   anzStellen=0;
   anzFalschesZeichen=0;

  // NSLog(@"rRahmen initWithFrame");
   //NSLog(@"rRahmen: \nx: %d y: %d\nb: %d h: %d",frame.origin.x,frame.origin.y,frame.size.width, frame.size.height);
   
   return self;
}

- (void)setResultatFeld
{
   //NSLog(@"setResultatFeld");
   //NSRect Rahmen=[self bounds];
   //NSLog(@"setErgebnisFeld: Rahmen: \nx: %d y: %d\nb: %d h: %d",Rahmen.origin.x,Rahmen.origin.y,Rahmen.size.width, Rahmen.size.height);
   //[self setFieldEditor:YES];
  // [self setBackgroundColor:[NSColor whiteColor]];
   [self setTextColor:[NSColor blackColor]];
   [self setAlignment:NSTextAlignmentCenter];
   //[self addToolTip:@"Ergebnis"];
   NSFont* ErgebnisFont=[NSFont fontWithName:@"Helvetica" size: 28];
   [self setEditable:YES];
   [self setDrawsBackground:NO];
   [self setSelectable:NO];
   [self setStringValue:@""];
   [self setFont:ErgebnisFont];
   //[self setTag:1];
   //NSLog(@"setErgebnisFeld Ende");
}


- (void)FalschesZeichenFunktion:(NSTimer*)derTimer
{
   NSLog(@"FalschesZeichenFunktion : info: %@",[derTimer userInfo]);
   [falschesZeichenTimer invalidate];
   //	[NSApp stopModalWithCode:0];
   [NSApp abortModal];
   
}
- (void)setMark:(int)dieMarke
{
   mark=dieMarke;
}

- (void)setReady:(BOOL)derStatus;
{
   ready=derStatus;
}

- (void)resetFalschesZeichen
{
   //NSLog(@"ErgebnisFeld resetFalschesZeichen: anzFalschesZeichen: %d",anzFalschesZeichen);
   anzFalschesZeichen=0;
   [[self formatter]resetAnzFalschesZeichen];
}




- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
