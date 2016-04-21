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
}
- (void) setUserTimeout:(int)dieZeit;
- (void) setAdminTimeout:(int)dieZeit;
- (IBAction)reportAdminTimeout:(id)sender;
- (IBAction)reportCancel:(id)sender;
- (IBAction)reportClose:(id)sender;
- (IBAction)reportUserTimout:(id)sender;
- (void) setFarbig:(BOOL)farbigDrucken;
- (int)cleanOK;
- (int)AnzahlBehalten;

@end
