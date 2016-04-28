//
//  rResultatFeld.m
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 27.04.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#import "rResultatFeld.h"

@implementation rResultatFeld

- (id)initWithFrame:(NSRect)frame
{
   self=[super initWithFrame:frame];
   NSLog(@"rRahmen initWithFrame");
   //NSLog(@"rRahmen: \nx: %d y: %d\nb: %d h: %d",frame.origin.x,frame.origin.y,frame.size.width, frame.size.height);
   return self;
}

- (void)setResultatFeld
{
   NSLog(@"setResultatFeld");
   NSRect Rahmen=[self bounds];
   //NSLog(@"setErgebnisFeld: Rahmen: \nx: %d y: %d\nb: %d h: %d",Rahmen.origin.x,Rahmen.origin.y,Rahmen.size.width, Rahmen.size.height);
   //[self setFieldEditor:YES];
   [self setBackgroundColor:[NSColor whiteColor]];
   [self setTextColor:[NSColor blackColor]];
   [self setAlignment:NSCenterTextAlignment];
   //[self addToolTip:@"Ergebnis"];
   NSFont* ErgebnisFont=[NSFont fontWithName:@"Helvetica" size: 28];
   [self setEditable:YES];
   [self setDrawsBackground:YES];
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
