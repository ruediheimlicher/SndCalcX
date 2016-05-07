/* rVolumes */

#import <Cocoa/Cocoa.h>
//#import "rNetzwerkDrawer.h"
@interface rVolumes : NSWindowController <NSTableViewDelegate , NSTableViewDataSource>
{
	IBOutlet id window;
    IBOutlet id AbbrechenKnopf;
	IBOutlet id AuswahlenKnopf;
    IBOutlet id NetzwerkKnopf;
    IBOutlet id SuchenKnopf;
	IBOutlet id AnmeldenKnopf;
	IBOutlet id PrufenKnopf;
	IBOutlet NSTableView* UserTable;
	IBOutlet NSTableView* NetworkTable;

	IBOutlet id VolumesPop;
	IBOutlet id OderString;
	IBOutlet id ComputerimNetzString;	
	IBOutlet id TitelString;
	IBOutlet id DialogTitelSting;
	IBOutlet id StartString;
	IBOutlet id NetzwerkDrawer;

 
	NSMutableArray*			UserArray;
	NSMutableArray*			NetworkArray;
	NSMutableDictionary*	UserDic;
	NSString*				SndCalcDatenPfad;
	NSTextFieldCell*		NamenCell;
	NSImageCell*			RecPlayIcon;
	NSMutableString*		neuerHostName;
	
	BOOL					istSystemVolume;
}

- (IBAction)Abbrechen:(id)sender;
- (IBAction)HomeDirectory:(id)sender;
- (NSString*)chooseNetworkSndCalcDatenPfad;
- (IBAction)toggleDrawer:(id)sender;
- (IBAction)VolumeOK:(id)sender;
- (IBAction)reportAuswahlen:(id)sender;
- (IBAction)reportAnmelden:(id)sender;
- (IBAction)checkUser:(id)sender;
- (BOOL)checkUserAnPfad:(NSString*)derUserPfad;

- (long) anzVolumes;
- (void) setHomeStatus:(BOOL) derStatus;
- (void) setUserArray:(NSArray*) dieUser;
//- (void)setNetworkArray:(NSArray*) derNetworkArray;

- (NSString*)SndCalcDatenPfad;
- (BOOL)istSystemVolume;
@end
