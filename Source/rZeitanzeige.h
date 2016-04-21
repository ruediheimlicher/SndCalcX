/* rZeitanzeige */

#import <Cocoa/Cocoa.h>

@interface rZeitanzeige : NSView
{
	float Max;
	int Rahmenhoehe, Rahmenbreite;
	float Feldbreite;
	int Feldhoehe;
	//int AnzFelder;
	float Level;
	//int Grenze;
}
- (void)setZeit:(int) dieZeit;
- (void)setZehntelZeit:(int) dieZeit;
- (void)drawLevelmeter;
- (void)setMax:(int)dasMax;
@end
