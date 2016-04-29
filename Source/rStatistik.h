/* rStatistik */

#import <Cocoa/Cocoa.h>
#import "rStatistikDS.h"

/*
@interface rGrafikCell : NSCell
{
int art;
int b,h;
NSRect GrafikRahmen;
NSRect Anzeigebalken;
int anzAufgaben, anzRichtig, anzFehler;
int zeit,maxzeit;
NSColor* Balkenfarbe;

}
- (void)setGrafikDaten:(NSDictionary*)derGrafikDic;
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end
*/
@interface rStatistikTable:NSTableView <NSTableViewDataSource,NSTableViewDelegate>
{
}
- (void)adjustPageHeightNew:(float *)newBottom top:(float)top bottom:(float)proposedBottom limit:(float)bottomLimit;
@end

@interface rDruckView:NSTextView 
{
NSDictionary*		TabDic;
NSString*		TestName;
NSRect			TabellenFeld;
NSArray*		TabArray;
NSArray*		SeitenArray;
BOOL			farbig;
}
- (void)drawRect:(NSRect)aRect;
- (void)setTabelleMitDic:(NSDictionary*)derTabDic mitFeld:(NSRect)dasFeld;

- (void)drawTabelle;
- (void)printZeilenDic:(NSDictionary*)derZeilenDic
			   inFeld:(NSRect)dasFeld
			mitSchnitt:(int)dieSchriftgroesse
		  mitFormatDic:(NSDictionary*)derFormatDic;

@end

@interface rGrafikView:NSView 
{
int art;
int b,h;
NSRect GrafikRahmen;
NSRect Anzeigebalken;
int anzAufgaben, anzRichtig, anzFehler;
int zeit,maxzeit;
NSColor* Balkenfarbe;
BOOL	farbig;
NSString* GrafikTextString;
}
- (void)setGrafikDaten:(NSDictionary*)derGrafikDic;
- (void)drawRect:(NSRect)aRect;

@end


@interface rFehlerView:NSView 
{
int art;
int b,h;
NSRect GrafikRahmen;
NSRect Anzeigebalken;
int anzAufgaben, anzRichtig, anzFehler;
int zeit,maxzeit;
NSImage* FehlerBild;
BOOL		farbig;
}
- (void)setGrafikDaten:(NSDictionary*)derGrafikDic;
- (void)drawRect:(NSRect)aRect;

@end



@interface rStatistik : NSWindowController <NSComboBoxDataSource,NSTableViewDataSource,NSTableViewDelegate>
{
    IBOutlet	id                      CancelTaste;
    IBOutlet	id                      SchliessenTaste;
	IBOutlet	id                         PrintTaste;
    IBOutlet	id                      TestNamenPopKnopf;
	IBOutlet	id                         AnzahlForNameZeigenPopKnopf;
    IBOutlet	id                      StatistikTab;
    IBOutlet	NSTableView *				StatistikTable;
	IBOutlet	id                         NamenFeld;
	IBOutlet	id                         NamenPopMenu;
	IBOutlet	id                         AnzahlFeld;
	IBOutlet	id				MaxZeitFeld;
	IBOutlet	id				TestAnzahlFeld;
	IBOutlet	id				TestMaxZeitFeld;
	
	
	IBOutlet	id				NoteCombo;
	IBOutlet	id				NoteLabel;
	IBOutlet	id				ZeitProAufgabeFeld;
	IBOutlet	id				MittelwertOptionRadio;
	NSMutableArray*				StatistikDicArray;
	NSMutableArray*				TestDicArray;
	IBOutlet id					IconFeld;
	IBOutlet		NSTabView *	TestTab;
	IBOutlet	id				DeleteTestKnopf;	
	IBOutlet NSTableView *            TestTable;
	IBOutlet id					AnzahlZeigenPopKnopf;
	IBOutlet NSButton *			mitNoteCheck;
	NSPopUpButton*				AdminTestNamenPopKnopf;
	NSArray*					AdminStatistikDicArray;
	NSMutableArray*				ErgebnisDicArray;
	rStatistikDS*				DatenQuelle;
	BOOL						AdminOK;
	//rStatistikTable*			DruckTable;
	NSTableView*				DruckTable;
	NSMutableDictionary*		NoteDic;
	NSMutableArray*				NoteChangedDicArray;
	NSTimer*					StatistikTimer;
	int							AusDiplomOK;
	BOOL						farbig;
	NSDate*						SessionDatum;
}
- (IBAction)reportCancel:(id)sender;
- (IBAction)reportClose:(id)sender;
- (IBAction)reportTestNamen:(id)sender;
- (void)setStatistikDicArray:(NSArray*)derDicArray;
- (void)setTestPop:(NSArray*)derTestArray;
- (void)setTestPopMitStringArray:(NSArray*)derTestStringArray;
- (void)setBenutzer:(NSString*)derBenutzer;
- (void)selectBenutzer:(NSString*)derBenutzer;
- (void)setBenutzerPop:(NSArray*)derBenutzerArray;
- (NSArray*)ErgebnisDicArrayForTest:(NSString*)derTest;
- (NSArray*)ErgebnisDicArrayForAllTests;

- (void)setAdminOK:(BOOL)derStatus;
- (BOOL)AdminOK;
- (void)setAdminTestNamenPop:(NSArray*)derTestArray;
- (void)setTestPopForAdminMitStringArray:(NSArray*)derTestStringArray;

- (IBAction)reportAdminTestNamen:(id)sender;
- (void)reportPrint:(id)sender;
- (void)printDicArray:(NSArray*)derDicArray  forTest:(NSString*)derTest;
- (void)setTableVonTest:(NSString*)derTest;
- (void)setTableVonTest:(NSString*)derTest forUser:(NSString*)derName;
- (void)setTableForAllTestsForUser:(NSString*)derName;
- (void)setAdminTestTableForTest:(NSString*)derTest;
- (void)setAdminTestTableForAllTests;
- (void)setFarbig:(BOOL)farbigDrucken;
- (void)updateAdminStatistikDicArrayMitNoteChangedArray:(NSArray*)derNoteArray;
- (void)updateAdminStatistikDicArrayMitNoteChangedDic:(NSDictionary*)derNoteChangedDic;

- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(int)rowIndex;
			
- (NSArray*)ErgebnisDicArrayForAllTestsForUser: (NSString*)derUser;
			
- (void)setAdminStatistikDicArray:(NSArray*)derAdminStatistikDicArray mitSessionDatum:(NSDate*)dasDatum;

- (void)printDicArray:(NSArray*)derDicArray;
- (void)printDicArray:(NSArray*)derDicArray forTest:(NSString*)derTest;
- (void)printDicArrayForAllTests:(NSArray*)derDicArray;
- (void)printDicArray:(NSArray*)derDicArray forTest:(NSString*)derTest forUser:(NSString*)derUser;

- (void)printDicArrayForAllTests:(NSArray*)derDicArray forUser:(NSString*)derUser;

//- (void)printDicArray:(NSArray*)derDicArray forTest:(NSString*)derTest forUser:(NSString*)derUser;


- (rStatistikTable*)ErgebnisTableMitFeld:(NSRect)dasFeld
						   mitZeilen:(int)anzZeilen
					  mitZeilenhoehe:(int)dieZeilenhoehe;

- (void)setTabelleMitDicArray:(NSArray*)derDicArray
							   forTest:(NSString*)derTest
							   mitFeld:(NSRect)dasFeld;
//mehrere Tests
- (rDruckView*)setDruckViewMitDicArray:(NSArray*)derDicArray	
							   mitFeld:(NSRect)dasFeld;

- (rDruckView*)setDruckViewMitDicArray:(NSArray*)derDicArray
							   forTest:(NSString*)derTest
							   mitFeld:(NSRect)dasFeld;
							   
//nur ein Test
- (rDruckView*)setDruckViewMitDicArray:(NSArray*)derDicArray	
							   forTest:(NSString*)derTest
							   forUser:(NSString*)derUser
							   mitFeld:(NSRect)dasFeld;

- (rDruckView*)setDruckViewMitDicArray:(NSArray*)derDicArray	
							   forUser:(NSString*)derUser
							   mitFeld:(NSRect)dasFeld;

							   
- (NSView*)ZeilenViewMitDic:(NSDictionary*)derZeilenDic
			   inFeld:(NSRect)dasFeld
			mitSchnitt:(int)dieSchriftgroesse
		  mitFormatDic:(NSDictionary*)derFormatDic
				farbig:(BOOL)mitFarbe;

- (void)NoteCellAktion:(id)sender;

- (void)setStatistikTimerMitIntervall:(float)dasIntervall mitInfo:(NSString*)dieInfo;

@end

