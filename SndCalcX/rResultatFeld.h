//
//  rResultatFeld.h
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 27.04.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface rResultatEingabeCheck: NSFormatter
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



@interface rResultatFeld : NSTextField <NSTextFieldDelegate>
{
   NSCharacterSet *				DezimalZahlen;
   int mark;
   int anzFalschesZeichen;
   BOOL ready;
   NSTimer* falschesZeichenTimer;

}

- (id)initWithFrame:(NSRect)frame;
- (void)setResultatFeld;
- (void)setMark:(int)dieMarke;
- (void)setReady:(BOOL)derStatus;
- (void)resetFalschesZeichen;

@end
