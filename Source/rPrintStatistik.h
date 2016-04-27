/* rPrintStatistik */

#import <Cocoa/Cocoa.h>
#import "rStatistik.h"

@interface rPrintStatistik : rStatistik <NSTableViewDataSource,NSTableViewDelegate>

{
NSTextField*		TitelFeld;
NSTextField*		DatumFeld;

}
- (void)printDicArray:(NSArray*)derDicArray;

- (NSTextView*)setDruckViewMitDicArray:(NSArray*)derDicArray
											 mitFeld:(NSRect)dasFeld;

@end
