/* rDiplomFenster */

#import <Cocoa/Cocoa.h>

@interface rDiplomFenster : NSWindowController
{
    IBOutlet id AnzahlString;
    IBOutlet id FehlerString;
    IBOutlet id FinishTaste;
    IBOutlet id TitelString;
	IBOutlet id ZeitString;
    IBOutlet id WeiterfahrenString;
    IBOutlet id WeiterTaste;
	IBOutlet id AnschauenTaste;
	IBOutlet id SichernCheckbox;

    
	IBOutlet id ZielImage;
	
	NSDictionary*	DiplomDic;
	NSTimer*		DiplomTimer;
}
- (void)setDiplomMit:(NSDictionary*)derDiplomDic;
- (void)setTastenStatus:(BOOL)derStatus;
- (void)reportFinish:(id)sender;
- (void)reportWeiterfahren:(id)sender;
- (BOOL)TestSichernOK;
- (void)DiplomTimerFunktion:(NSTimer*)derTimer;
- (void)setDiplomTimerMitIntervall:(float)dasIntervall;
@end
