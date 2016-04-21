//
//  rErgebnisView.h
//  SndCalcII
//
//  Created by Sysadmin on 03.11.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rErgebnisView : NSTextView 
{
NSCharacterSet *				DezimalZahlen;
int mark;
int anzFalschesZeichen;
BOOL ready;
NSTimer* falschesZeichenTimer;
}
- (id)initWithFrame:(NSRect)frame;
- (void)setErgebnisView;
- (void)setMark:(int)dieMarke;
- (void)setReady:(BOOL)derStatus;
- (void)resetFalschesZeichen;
@end
