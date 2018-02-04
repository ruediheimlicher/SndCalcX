//
//  rStatistikDS.h
//  SndCalcII
//
//  Created by Sysadmin on 18.03.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface rGrafikCell : NSCell
{
int art;
int b,h;
NSRect GrafikRahmen;
NSRect Anzeigebalken;
int anzAufgaben, anzRichtig, anzFehler;
int zeit,maxzeit;
NSColor* Balkenfarbe;
NSString* GrafikTextString;
BOOL		farbig;
}
- (void)setGrafikDaten:(NSDictionary*)derGrafikDic;
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end


@interface rFehlerCell : NSCell
{
int art;
int b,h;
NSRect GrafikRahmen;
NSRect Anzeigebalken;
int anzAufgaben, anzRichtig, anzFehler;
int zeit,maxzeit;
NSImage* FehlerBild;
BOOL AlleZeigen;
BOOL		farbig;
}
- (void)setGrafikDaten:(NSDictionary*)derGrafikDic;
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end



@interface rStatistikDS : NSObject <NSTableViewDataSource,NSTableViewDelegate>
{
NSTableView*			TestTable;
NSPopUpButton*			TestPopMenu;
IBOutlet id				mitMittelwertCheck;
IBOutlet id				mitBestmarkeCheck;
NSPopUpButton*			AnzeigenOptionPop;
IBOutlet id				MittelwertOptionRadio;
NSArray*				AdminStatistikDicArray;
NSMutableArray*			ErgebnisDicArray;
BOOL					farbig;
}
- (void)setAdminStatistikDicArray:(NSArray*)derAdminStatistikDicArray;
//- (void)setErgebnisDicArray:(NSArray*)derErgebnisdicArray;
- (void)setFarbig:(BOOL)farbigDrucken;
- (void)printTestTable;
- (NSDictionary*)DicForRow:(int)dieZeile;

- (void)markNoteChanged:(NSString*)dieNote forRow:(int)dieZeile;
- (NSArray*)NoteChangedDicArray;
- (NSArray*)ClearNoteDicArray;
@end
