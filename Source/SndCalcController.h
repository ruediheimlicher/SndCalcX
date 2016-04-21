//
//  AA.h
//  CC
//
//  Created by Sysadmin on 15.10.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//
//#import <QuickTime/QuickTime.h>

#import <Cocoa/Cocoa.h>
#include <Carbon/Carbon.h>
#import "rAufgabe.h"
#import "rSerie.h"
#import "rReihenSettings.h"
#import "rAddSubSettings.h"
#import "rSpeaker.h"
#import "rAufgabenzeiger.h"
#import "rZeitanzeige.h"
//#import "rErgebnisView.h"
#import "rErgebnisFeld.h"
#import "rRahmen.h"
#import "rDiplomFenster.h"
#import "rNamenPanel.h"
#import "rTestPanel.h"
#include <stdlib.h>
#import "rStatistik.h"
#import "rUtils.h"
#import "rVolumes.h"
#import "rPasswortRequest.h"
#import "rPWTimeout.h"
#import "rSessionDS.h"
#import "rEinstellungenPanel.h"



@interface SndCalcController : NSWindowController {
	//NSWindow*					window;
	rAufgabe	*                 Aufgabe;
	rUtils*                    Utils;
	NSMutableArray*				VolumesArray;
	rSerie*                    AufgabenSerie;
	ProgPrefsRecord				SerieDaten;
	rReihenSettings*           ReihenSettings;
	rAddSubSettings*           AddSubSettings;
	rSpeaker*                  Speaker;
	rAufgabenzeiger*           Aufgabenzeiger;
	rZeitanzeige*              Zeitanzeige;
	
	rDiplomFenster*				DiplomFenster;
	rStatistik*                Statistik;
	//rDruckStatistik*			DruckStatistik;
	rTestPanel*                TestPanel;
	rVolumes*                  VolumesPanel;
	rNamenPanel*               NamenPanel;
	NSPopUpButton*             NamenPopKnopf;
	NSArray*                   AufgabenArray;
	NSDrawer*                  AufgabenDrawer;
	NSTextView*                DrawerView;
	IBOutlet NSMenu*           AblaufMenu;
	IBOutlet NSPopUpButton*		ZeitPopKnopf;
	IBOutlet NSPopUpButton*		AnzahlPopKnopf;
	IBOutlet NSTextField*		AnzahlFeld;

	IBOutlet NSButton *			OKTaste;
	IBOutlet NSButton *			ErgebnisseTaste;
	IBOutlet NSImage *			IconFeld;
	IBOutlet NSView *          IconView;

	IBOutlet NSButton *			StartTaste;
	IBOutlet NSButton *			neueSerieTaste;
	
	IBOutlet NSButton *			SettingsPfeil;
	IBOutlet NSDrawer *			SettingsDrawer;
	IBOutlet NSTabView *       SettingsBox;
	IBOutlet NSButton *			SettingAlsTestSichernTaste;
	IBOutlet NSButton *			DrawerSchliessenTaste;
	//IBOutlet NSTextField *	ErgebnisFeld;
//	IBOutlet rErgebnisView *	ErgebnisView;
	IBOutlet rErgebnisFeld *	ErgebnisFeld;
	IBOutlet rRahmen *			ErgebnisRahmenFeld;
	IBOutlet NSBox*				RechnungsBox;
	IBOutlet NSBox*				AufgabenBox;
	IBOutlet NSBox*				ZeitBox;
	IBOutlet NSTextField*		ZeitFeld;
	IBOutlet NSTextField*		ZeitLimiteFeld;
	IBOutlet NSTextField*		AufgabenNummerFeld;
	NSTimer*                   AblaufzeitTimer;
	NSTimer*                   DiplomTimer;
	NSTimer*                   TimeoutTimer;			
	IBOutlet NSPopUpButton*		TestPopKnopf;
	IBOutlet	NSComboBox*       NamenCombo;
	IBOutlet NSSlider *			VolumeSchieber;
	IBOutlet NSMatrix *			ModusOption;
	
	NSDrawer*					SessionDrawer;
	NSTableView*				SessionTable;
	rSessionDS*					SessionDS;
	IBOutlet	id				SessionDatumFeld;
	NSTimer*					SessionTimer;
	IBOutlet	id				ToggleSessionKnopf;
	IBOutlet	id				SessionDrawerTaste;
	NSMutableDictionary*		PListDic;
	NSMutableDictionary*		UserDatenDic;
	NSMutableDictionary*		SerieDatenDic;
	
	rEinstellungenPanel*		EinstellungenPanel;
	
	NSString*				SndCalcPfad;
	IBOutlet NSButton *		goToBeginningButton;
    IBOutlet NSButton *		goToEndButton;
    IBOutlet QTMovieView *	movieViewObject;
    IBOutlet NSMenuItem *	moviePropertiesMenuItem;
    IBOutlet NSWindow *		moviePropertiesWindow;
    IBOutlet NSWindow *		movieWindow;
    IBOutlet NSButton *		playButton;
    IBOutlet NSSlider *		setVolumeSlider;
    IBOutlet NSButton *		stepBackButton;
    IBOutlet NSButton *		stepForwardButton;
    IBOutlet NSTableView *	movieTrackMediaTypes;
    IBOutlet NSMenuItem *	menuItem_New;
	
	IBOutlet NSButton *		LogoutKnopf;
    
    IBOutlet NSTextField *	autoPlayEnabled;
    IBOutlet NSTextField *	trackCount;
    IBOutlet NSTextField *	movieTimeScale;
    IBOutlet NSTextField *	movieDuration;

    NSMutableArray	*		movieTrackMediaTypesArray;
 	// QTKit
	NSString*				SndCalcDatenPfad;
	int						SndCalcDatenDa;
	int						AnzahlAufgaben;
	int						abgelaufeneZeit;
	int						teilZeit;
	int						MaximalZeit;
	int						aktuelleAufgabenNummer;
	int						anzRichtig;
	int						anzFehler;
	BOOL					verify;
	NSImageView*			Bild;
	int						Modus;
	int						Status;
	BOOL					OK;
	float					Volume;
	BOOL					TimerValid;
	int						UserTimeout;
	int						AdminTimeout;
	int						farbig;
	
	NSTimer*				AdminTimeoutTimer;
	rPasswortRequest*		PasswortRequest;
	BOOL					mitAdminPasswort;
	BOOL					AdminPWOK;
	NSMutableDictionary*	AdminPasswortDic;
	NSTimer*				TeminateAdminPWTimer;
	NSDate*					SessionDatum;
	NSString*				Stimme;
	NSMutableDictionary*	QuittungDic;
	
	NSTimer* falschesZeichenTimer;
}
- (NSWindow*)window;
- (NSString*)chooseSndCalcPfadMitUserArray:(NSArray*)derUserArray;

- (BOOL)updatePList;
- (void)setSettings:(NSDictionary*)dieSettings;
- (void)setTestPop;
- (void)setTestPopKnopfMitArray:(NSArray*)derTestDicArray;
- (void)setTestPopKnopfForUser:(NSString*)derUser;
- (IBAction)neueSerie:(id)sender;
- (NSDictionary*)SerieDatenDicVonScratch;
- (NSDictionary*)PListDicVonSettings;
- (NSDictionary*)SerieDatenDicVon:(ProgPrefsRecord)dieSerieDaten;
- (ProgPrefsRecord)SerieDatenVonDic:(NSDictionary*)derSerieDatenDic;
- (NSDictionary*)SerieDatenDicAusSettings;
- (ProgPrefsRecord)SerieDatenVonSettings;
- (void)SerieDatenSichernVon:(NSString*)derRechner;
- (void)SessionDatumSichernVon:(NSString*)derRechner;
- (void)initAddSubSettings;
- (void)initReihenSettings;
- (BOOL)checkSettings;
- (void)ClearSettings;
- (NSDictionary*)SerieDatenStatus;
- (NSDictionary*)SettingStatus;
- (NSDictionary*)StatusVonSerieDatenDic:(NSDictionary*)derSerieDatenDic;
- (BOOL)checkSerieDatenDic:(NSDictionary*)derSerieDatenDic vonTest:(NSString*)derTestName;
- (IBAction)toggleDrawer:(id)sender;
- (IBAction)closeDrawer:(id)sender;
- (IBAction)reportSettingAlsTestSichern:(id)sender;
- (void)setSettingsMitDic:(NSDictionary*)derSettingDic;
- (void)selectSettingsTab:(int)derTab;
- (void)toggleAufgabenDrawer:(id)sender;
- (void)openAufgabenDrawer:(id)sender;
- (BOOL)readZahlen;
//- (IBAction)StimmeAktion:(id)sender;
- (void)closeAufgabenDrawer:(id)sender;
- (void)setupAufgabenDrawer;
- (void)showAufgaben;
- (IBAction)showEinstellungen:(id)sender;

- (IBAction)AufgabeAb:(id)sender;
- (void)FalschesZeichenFunktion:(NSTimer*)derTimer;
- (void)nextAufgabeAbTimerFunktion:(NSTimer*)TestTimer;
- (void)AufgabeFertigAktion:(NSNotification*)note;
- (void)AufgabeBereitAktion:(NSNotification*)note;
- (void)setTestVonTestname:(NSString*)derTest;
- (BOOL)checkAufgabe;
- (void)RichtigSoundAb;
- (void)FalschSoundAb;
- (void)FertigSoundAb;
- (void)markRichtig;
- (void)markFalsch;
- (void)markReset;
- (int)SerieFertig:(NSDictionary*) dasErgebnis;
- (void)showDiplomFensterMitErgebnis:(NSDictionary*) derErgebnisDic;
- (void)setTest:(id)sender;
- (void)resetTest;
- (void)saveTest:(id)sender;
- (void)showTestPanel:(id)sender;
- (void)showTestSheet:(id)sender;
- (void)updateTestPanel;
- (void)showNamenPanel:(id)sender;
- (void)setNamenPopKnopfMitDicArray:(NSArray*)derDicArray;
- (void)toggleSessionDrawer:(id)sender;
- (void)openSessionDrawer:(id)sender;

- (void)closeSessionDrawer:(id)sender;
- (void)setupSessionDrawer;
- (IBAction)neueSession:(id)sender;
- (IBAction)SessionAktualisieren:(id)sender;
- (void)showStatistik:(id)sender;
- (void)showStatistikFor:(NSString*)derName mitDic:(NSDictionary*)derDic;
- (IBAction)goToBeginning:(id)sender;
- (IBAction)goToEnd:(id)sender;
- (IBAction)movieProperties:(id)sender;
- (IBAction)newWindow:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)setVolume:(id)sender;
- (IBAction)stepBack:(id)sender;
- (IBAction)stepForward:(id)sender;

- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn
    row:(int)rowIndex;
- (void)resetPlayButtonForMovieStopState:(id)sender;
//- (void)buildTrackMediaTypesArray:(Movie)qtmovie;
- (void)saveCurrentMoviePlayingState;
- (void)restoreMoviePlayingState:(id)sender;
- (void)showTheWindow:(NSWindow *)window;
- (void)restoreMoviePlayCompleteCallBack;
//- (void)setMoviePropertyWindowControlValues:(Movie)qtmovie;
//- (void)setupMoviePlayingCompleteCallback:(Movie)theMovie callbackUPP:(QTCallBackUPP) callbackUPP;
- (BOOL)GetZahlTrack;
- (void)stopTimeout;
- (void)startTimeout;
- (void)startAdminTimeout;
- (void)stopAdminTimeout;
- (BOOL)checkAdminZugang;
- (void)showChangeAdminPasswort:(id)sender;
- (IBAction)reportLogout:(id)sender;

- (void)terminate:(id)sender;
- (void)BeendenAktion:(id)sender;
- (void)savePListAktion:(NSNotification*)note;
- (void)setOK:(BOOL)derStatus;
- (void)DebugStep:(NSString*)dieWarnung;

- (BOOL)drawerShouldOpen:(NSDrawer *)sender;
- (void)drawerWillOpen:(NSNotification *)notification;
- (NSSize)drawerWillResizeContents:(NSDrawer *)sender toSize:(NSSize)contentSize;
- (void)drawerDidOpen:(NSNotification *)notification;
- (BOOL)drawerShouldClose:(NSDrawer *)sender;
- (BOOL)drawerShouldOpen:(NSDrawer *)sender;
- (void)drawerWillClose:(NSNotification *)notification;


@end

//pascal void MyCallBackProc (QTCallBack cb, long refcon);
//void adjustPlayButtonForMyMovieControllerObject(void);
void saveObjectForCallback(void *theObject);


