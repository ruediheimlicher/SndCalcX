/* rNamenPanel */

#import <Cocoa/Cocoa.h>


@interface rNamenPanel : NSWindowController <NSTableViewDelegate,NSTableViewDataSource>
{
   IBOutlet NSTextField* NamenFeld;
   IBOutlet NSTextField* VornamenFeld;
   IBOutlet NSTextField* PasswortFeld;
   
   IBOutlet NSTextField*      ConfirmFeld;
   IBOutlet NSTextView*        NamenView;
   IBOutlet NSTableView*      NamenTable;
   NSMutableArray*				NamenArray;
   NSMutableArray*				NamenDicArray;
   
   NSMutableDictionary*		NamenDic;
   
   NSString* neuerName;
   IBOutlet id		IconFeld;
}
- (BOOL)doesMatchRegStringExp:(NSString *)string;
- (IBAction)reportCancel:(id)sender;
- (IBAction)reportEntfernen:(id)sender;
- (IBAction)reportClose:(id)sender;
- (NSString*)neuerName;
- (NSArray*)getNamenArray;
- (NSArray*)NamenArray;
- (NSArray*)holeNamenDicArray;
- (NSArray*)NamenDicArray;
- (void)setNamenDicArray:(NSArray*)derDicArray;

- (NSString*)stringSauberVon:(NSString*)derString;
@end
