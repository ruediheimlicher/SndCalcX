/* rEinstellungen */

#import <Cocoa/Cocoa.h>

@interface rEinstellungenPanel : NSWindowController
{
    IBOutlet id AdminTimeoutTaste;
    IBOutlet id CancelTaste;
    IBOutlet id RecPlayIcon;
    IBOutlet id SchliessenTaste;
    IBOutlet id UserTimeoutTaste;
    IBOutlet id FarbigTaste;
    IBOutlet id ErgebnisseBehaltenTaste;
    IBOutlet id CleanTaste;
   IBOutlet NSTextView* AnzahlFeld;
   IBOutlet NSTextView*  ZeitFeld;
}
- (void) setUserTimeout:(int)dieZeit;
- (void) setAdminTimeout:(int)dieZeit;
- (IBAction)reportAdminTimeout:(id)sender;
- (IBAction)reportCancel:(id)sender;
- (IBAction)reportClose:(id)sender;
- (IBAction)reportUserTimout:(id)sender;
- (void) setFarbig:(BOOL)farbigDrucken;
- (void)setzeAnzahlFeld:(NSArray*)anzArray;
- (void)setzeZeitFeld:(NSArray*)anzArray;
- (int)cleanOK;
- (int)AnzahlBehalten;

@end
