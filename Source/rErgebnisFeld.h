//
//  rErgebnisFeld.h
//  SndCalcII
//
//  Created by Sysadmin on 03.11.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface rEingabeCheck: NSFormatter
{
NSCharacterSet *				DezimalZahlen;
int								anzStellen;
int								anzFalschesZeichen;
}

- (BOOL)isPartialStringValid:(NSString *)partialString
			newEditingString:(NSString **)newString 
			errorDescription:(NSString **)error;
- (void)resetAnzFalschesZeichen;

@end


@interface rErgebnisFeld : NSTextField <NSTextFieldDelegate,NSTextDelegate>
{
NSCharacterSet *				DezimalZahlen;
int mark;
int anzFalschesZeichen;
BOOL ready;
NSTimer* falschesZeichenTimer;
}
- (id)initWithFrame:(NSRect)frame;
- (void)setErgebnisFeld;
- (void)setMark:(int)dieMarke;
- (void)setReady:(BOOL)derStatus;
- (void)resetFalschesZeichen;
@end
