/* rTestPanel */

#import <Cocoa/Cocoa.h>
#import "rTestZuNamenDS.h"
#import "rNamenZuTestDSX.h"
#import "rReihenSettings.h"
#import "rAddSubSettings.h"

@interface rTestPanel : NSWindowController <NSTableViewDataSource,NSTableViewDelegate>
{
    IBOutlet	id						EingabeFeld;
    IBOutlet	id						SchliessenTaste;
	IBOutlet	id						aktivCheckbox;
	IBOutlet	id						TestTable;
	IBOutlet	id						DeleteTaste;
	IBOutlet	id						EinsetzenTaste;
	IBOutlet	id						BearbeitenTaste;
	IBOutlet	id						IconFeld;
	IBOutlet	id						AnzahlPopTaste;
	IBOutlet	id						ZeitPopTaste;
	IBOutlet	id						TestForAllTaste;
	IBOutlet	id						TestForNoneTaste;
	IBOutlet	id						SaveTestTaste;
	
	IBOutlet	NSTableView*		TestZuNamenTable;
	IBOutlet	NSPopUpButton*		NamenWahlTaste;
	IBOutlet	id						TestTabFeld;
	IBOutlet	id						forAllCheckbox;
	IBOutlet	id						TestInAlleEinsetzenTaste;
	IBOutlet	id						TestAusAllenEntfernenTaste;
	IBOutlet	id						SetTestForAllTaste;
	IBOutlet	id						UpDownTaste;
	
	IBOutlet	NSTableView*		NamenZuTestTable;
	IBOutlet	NSPopUpButton*		TestWahlTaste;
	IBOutlet	id						AnzahlAufgabenFeld;
	IBOutlet	id						ZeitFeld;
						
	NSMutableString*				aktuellerUser;
	NSMutableString*				aktuellerTest;
	NSMutableArray*				NamenDicArray;
	rTestZuNamenDS*				TestZuNamenDS;
	rNamenZuTestDS*				NamenZuTestDS;
	NSMutableArray*				TestDicArray;
	NSArray*							userOKArray;
	BOOL								dirty;
	BOOL								busy;
	BOOL								TestChanged;
	BOOL								OK;

	
	rReihenSettings*				ReihenSettings;
	rAddSubSettings*				AddSubSettings;
	NSMutableDictionary*			SerieDatenDic;

	NSTextView*						DrawerView;
	IBOutlet NSDrawer *			SettingsDrawer;
	IBOutlet NSTabView *			SettingsBox;
	IBOutlet NSButton *			closeDrawerTaste;
	IBOutlet NSButton *			DrawerSchliessenTaste;
	IBOutlet	id						SettingsPfeil;
}
- (NSArray*)TestNamenArray;
- (NSArray*)TestDicArray;
- (void)resetTestTabFeld;
- (void)setTestDicArray:(NSArray*)derTestDicArray;
- (void)updateTestDicArrayMitArray:(NSArray*)derTestDicArray;
- (void)updateTestDaten:(NSArray*)derTestDicArray;
- (void)setAnzahlItems:(NSArray*)derArray mitItem:(int)derIndex;
- (void)setZeitItems:(NSArray*)derArray mitItem:(int)derIndex;
- (void)setNamenWahlTasteMitNamen:(NSString*)derName; 
- (void)setNamenDicArray:(NSArray*)derNamenDicArray;
- (int)anzTestForUser:(NSString*)derUser;

- (IBAction)reportBearbeiten:(id)sender;
- (IBAction)reportCancel:(id)sender;
- (IBAction)reportClose:(id)sender;
- (IBAction)reportSaveTest:(id)sender;
- (IBAction)reportNamen:(id)sender;
- (IBAction)reportForAll:(id)sender;
- (IBAction)reportForNone:(id)sender;

- (IBAction)reportTestInAlleEinsetzen:(id)sender;
- (IBAction)reportTestAusAllenEntfernen:(id)sender;
- (IBAction)reportUpDown:(id)sender;
- (void)TestUp;
- (void)TestDown;
- (void)setAnzahl:(int)derIndex;
- (void)setZeit:(int)derIndex;
- (void)selectEingabeFeld;

- (void)saveTest;
- (void)setTestForAll:(NSString*)derTest;
- (void)clearTestForAll:(NSString*)derTest;
- (void)saveUserTestArray;

- (void)setTestWahlTasteMitTest:(NSString*)derTest; 
- (void)setTestZuNamenDSForUser:(NSString*)derUser;
- (void)setNamenZuTestDSForTest:(NSString*)derTest;

-(IBAction)closeDrawer:(id)sender;
-(IBAction)openDrawer:(id)sender;

- (void)reportSaveTestTaste:(id)sender;
- (void)initAddSubSettings;
- (void)initReihenSettings;
- (void)SettingChangedAktion:(NSNotification*)note;
- (void)clearSettings;
- (BOOL)checkSettings;
- (BOOL)checkSerieDatenDic:(NSDictionary*)derSerieDatenDic vonTest:(NSString*)derTestName;
- (NSDictionary*)StatusVonSerieDatenDic:(NSDictionary*)derSerieDatenDic;
- (NSDictionary*)SettingStatus;

- (void)selectSettingsTab:(int)derTab;
- (void)setSettingsMitDic:(NSDictionary*)derSettingDic;
- (NSDictionary*)SerieDatenDicAusSettings;
- (NSDictionary*)SerieDatenDic;

@end
