/* rNamenPanel */

#import <Cocoa/Cocoa.h>

@interface rNamenPanel : NSWindowController
{
    IBOutlet id NamenFeld;
    IBOutlet id VornamenFeld;
	IBOutlet id PasswortFeld; 

	IBOutlet id ConfirmFeld;
	IBOutlet id NamenView;
	IBOutlet id NamenTable;
	NSMutableArray*				NamenArray;
	NSMutableArray*				NamenDicArray;

	NSMutableDictionary*		NamenDic;

	NSString* neuerName;
	IBOutlet id		IconFeld;
}
- (IBAction)reportCancel:(id)sender;
- (IBAction)reportEntfernen:(id)sender;
- (IBAction)reportClose:(id)sender;
- (NSString*)neuerName;
- (NSArray*)NamenArray;
- (NSArray*)NamenDicArray;
- (void)setNamenDicArray:(NSArray*)derDicArray;

- (NSString*)stringSauberVon:(NSString*)derString;
@end
