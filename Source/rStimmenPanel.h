/* rStimmenPanel */

#import <Cocoa/Cocoa.h>
#import "rQuittungDS.h"
@interface rStimmenPanel : NSWindowController
{
    IBOutlet id QuittungEntfernenTaste;
    IBOutlet id QuittungImportierenTaste;
	 IBOutlet NSPopUpButton* QuittungNamenPopTaste;
    IBOutlet id QuittungNameFeld;
    IBOutlet id QuittungOKTaste;
    IBOutlet id QuittungTable;
    IBOutlet id SchliessenTaste;
    IBOutlet id StimmeEntfernenTaste;
    IBOutlet id StimmeImportierenTaste;
    IBOutlet id StimmenNameFeld;
    IBOutlet id StimmenTable;
    IBOutlet id StimmeOKTaste;
	IBOutlet id DokumenteSucher;
	IBOutlet id StimmePlusMinusTaste;
	IBOutlet id QuittungPlusMinusTaste;
	
	NSMutableArray*			StimmenTableArray;
	NSMutableArray*			QuittungTableArray;
	NSString*				Stimme;
	NSMutableDictionary*	NeueStimmeDic;
	NSMutableDictionary*	NeueQuittungDic;
	rQuittungDS*			QuittungDS;
	NSMutableDictionary*	QuittungSelektionDic;
	NSMutableDictionary*	QuittungNamenArrayDic;
	
}
- (IBAction)reportCancel:(id)sender;
- (IBAction)reportClose:(id)sender;
- (IBAction)reportStimmeEntfernen:(id)sender;
- (IBAction)reportQuittungEntfernen:(id)sender;
- (IBAction)reportQuittungImportieren:(id)sender;
- (IBAction)reportQuittungOK:(id)sender;
- (IBAction)reportStimmeImportieren:(id)sender;
- (IBAction)reportStimmeOK:(id)sender;
- (IBAction)reportStimmePlusMinus:(id)sender;
- (IBAction)reportQuittungPlusMinus:(id)sender;
- (NSString*) StimmenName;
- (NSArray*)StimmenNamenArrayAusResources;
- (NSArray*)QuittungNamenArrayAusResourcesZuKlasse:(NSString*)dieKlasse;
//- (void)setStimmenPanelMitStimme:(NSString*)dieStimme;
- (void)setStimmenTableArrayMitStimmenNamenArray:(NSArray*)derDicArray mitStimme:(NSString*)dieStimme;
- (BOOL)checkStimmenArray:(NSArray*)derStimmenArray mitStimmenName:(NSString*)derStimmenName;
- (void)addStimmeZuDicArrayMitDic:(NSDictionary*)derStimmenDic;
- (NSDictionary*)copyZiffernToResources;
- (void)setQuittungNamenArrayDic:(NSDictionary*)derQuittungNamenArrayDic;
- (void)setQuittungSelektionDic:(NSDictionary*)derQuittungSelektionDic;
- (NSDictionary*)copyQuittungToResources;
- (BOOL)deleteStimme:(NSString*)derStimmenName;

@end
