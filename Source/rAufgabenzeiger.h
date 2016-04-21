/* rLevelmeter */

#import <Cocoa/Cocoa.h>

@interface rAufgabenzeiger : NSView
{
	//NSColor* penColour;
	float Feldbreite;
	int Feldhoehe;
	int AnzFelder;
	int AnzAufgaben;
	int Grenze;
	int Level;
	int	Abstand;
	int max;
	int lastLevel;
	int lastMax;
	BOOL maxSet;
	BOOL delaySet;
	float fixTime;
	int holdMax;
	NSRect	Rahmen;
	//NSTimer* fixTimer;
	
}
- (void)setAnzahl:(int)dieAnzahl;
- (void)setAnzAufgaben:(int)derLevel;
- (void)drawAufgabenzeiger;

@end
