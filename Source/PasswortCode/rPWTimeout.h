/* rPWTimeout */

#import <Cocoa/Cocoa.h>

@interface rPWTimeout : NSWindowController
{
    IBOutlet id DialogTextString1;
    IBOutlet id DialogTextString2;
    IBOutlet id DialogTitelString;
}
- (void)setTitelString:(NSString*)derTextString;
- (void)setTextString1:(NSString*)derTextString;
- (void)setTextString2:(NSString*)derTextString;
- (IBAction)reportContinue:(id)sender;
- (IBAction)reportStop:(id)sender;
@end
