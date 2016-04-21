//
//  AA.m
//  CC
//
//  Created by Sysadmin on 15.10.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "SndCalcController.h"
#include <QuickTime/QuickTime.h>

//#import "QTUtils.h"


static void * gMyMovieControllerObject;

typedef struct
{
short Operation;
short Rechenzeit;
short AnzahlFehler;
long Datum;

}Settingrecord;

enum {
kTrainingModus,
kTestModus};

enum
{
kAblaufMenuTag=20000,
kNeuerNameTag,
kTestListeTag,
kPasswortListeTag,
kNeueSessionTag,
kNeuerTestTag,
kStimmeTag=20008,
kChangePasswortTag=20010
};

enum
{
kGast,
kBenutzer
};

const short     kAufgabeFalsch = 5002; 
const short     kFalschesZeichen = 5005; 
const short     kAufgabeRichtig = 5001; 
const short     kSerieFertig = 5003; 


@implementation SndCalcController
/*
- (NSWindow*)window
{
return window;
}
*/


- (id)init
{
	self =[super init];
    /* allocate an array to store the track media types for
	our movie - these will be displayed in our NSTableView
	control in our movie properties window */
    movieTrackMediaTypesArray=[[NSMutableArray alloc] init];
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(AufgabeFertigAktion:)
			   name:@"AufgabeFertig"
			 object:nil];
	
	[nc addObserver:self
		   selector:@selector(ErgebnisFertigAktion:)
			   name:@"ErgebnisFertig"
			 object:nil];
	
	[nc addObserver:self
		   selector:@selector(FalschesZeichenAktion:)
			   name:@"FalschesZeichen"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(showStatistikAktion:)
			   name:@"showStatistik"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(VolumeWahlAktion:)
			   name:@"VolumeWahl"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(DeleteNamenAktion:)
			   name:@"DeleteName"
			 object:nil];
			 
	[nc addObserver:self
		   selector:@selector(NotenUpdateAktion:)
			   name:@"NotenUpdate"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(NeuerTestnameAktion:)
			   name:@"NeuerTestname"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(TestBearbeitenAktion:)
			   name:@"TestBearbeiten"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(DeleteTestAktion:)
			   name:@"DeleteTest"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(TestResetAktion:)
			   name:@"TestReset"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(NeuerUserTestArrayAktion:)
			   name:@"NeuerUserTestArray"
			 object:nil];


	[nc addObserver:self
		   selector:@selector(DeleteTestNameAktion:)
			   name:@"DeleteTestName"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(setTestForAllAktion:)
			   name:@"setTestForAll"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(ClearTestForAllAktion:)
			   name:@"clearTestForAll"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(TestAktivAktion:)
			   name:@"TestAktiv"			 
			 object:nil];
	
	[nc addObserver:self
		   selector:@selector(UserTestArrayChangedAktion:)
			   name:@"UserTestArrayChanged"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(NeueStimmeAktion:)
			   name:@"neueStimme"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(StimmeAktion:)
			   name:@"Stimme"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(NeueQuittungAktion:)
			   name:@"neueQuittung"
			 object:nil];
	
	[nc addObserver:self
		   selector:@selector(QuittungAktion:)
			   name:@"Quittung"
			 object:nil];
	
	

	Utils=[[rUtils alloc]init];

	PListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[PListDic retain];
	UserDatenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[UserDatenDic retain];
	
	
	SerieDatenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[SerieDatenDic retain];
	
	QuittungDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[QuittungDic retain];
	
	Volume=80;

	srand(time(NULL));

	Modus=kTestModus;
	Status=kGast;
	OK=YES;
	mitAdminPasswort=YES;
//	[Stimme=[NSString alloc]initWithString:@""];
	Stimme=[NSString string];
	[Stimme retain];
	return self;
	
}

- (BOOL)readPListAnPfad:(NSString*)derSndCalcPfad
{
	
	NSLog(@"readPListAnPfad: %@",derSndCalcPfad);
	NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	BOOL istOrdner=NO;
	if ([Filemanager fileExistsAtPath:derSndCalcPfad isDirectory:&istOrdner]&&istOrdner)
	{	
		NSLog(@"SndCalcDaten da. Pfad: %@",[derSndCalcPfad stringByAppendingPathComponent:PListName]);
		NSDictionary*tempPListDic=[NSDictionary dictionaryWithContentsOfFile:[derSndCalcPfad stringByAppendingPathComponent:PListName]];
		if (tempPListDic)
		{
//			NSLog(@"init: tempPListDic: %@",[tempPListDic description]);
			PListDic=[tempPListDic mutableCopy];
			if ([PListDic objectForKey:@"seriedatendic"])
			{
				[SerieDatenDic addEntriesFromDictionary:[PListDic objectForKey:@"seriedatendic"]];
//				NSLog(@"SerieDatenDic Aus PList: %@",[SerieDatenDic description]);
				
			}
			else
			{
				NSLog(@"readPListAnPfad:	FromScratch");
				[SerieDatenDic addEntriesFromDictionary:[self SerieDatenDicVonScratch]];
				[PListDic setObject:SerieDatenDic forKey:@"seriedatendic"];
			}
			[SerieDatenDic retain];
			//SerieDaten=[self SerieDatenVonDic:PListDic];
			if ([PListDic objectForKey:@"volume"])
			{
				Volume=[[PListDic objectForKey:@"volume"]floatValue];
				NSLog(@"Volume Aus PList: %f",Volume);
				
			}
			else
			{
				Volume=80.0;
				[PListDic setObject:[NSNumber numberWithFloat:Volume]forKey:@"volume"];
			}

			
			
			if ([PListDic objectForKey:@"sessiondatum"])
			{
				SessionDatum=[PListDic objectForKey:@"sessiondatum"];
				NSLog(@"SessionDatum: %@",[SessionDatum description]);
				NSCalendarDate* heute=[NSCalendarDate date];
				NSCalendarDate* lastSession=[[NSCalendarDate alloc]initWithString:[SessionDatum description]];
				int lastSessionTag=[lastSession dayOfYear];
				int heuteTag=[heute dayOfYear];
				//NSLog(@"lastSessionTag: %d		heute: %d",lastSessionTag,heuteTag);
				if (heuteTag>lastSessionTag)
				{
					NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
					[Warnung addButtonWithTitle:@"Neue Session"];
					[Warnung addButtonWithTitle:@"Session weiterführen"];
					[Warnung setMessageText:[NSString stringWithFormat:@"Neue Session?"]];
					
					NSString* s1=@"Die aktuelle Session ist mehr als einen Tag alt.";
					NSString* s2=@"Wie weiterfahren?";
					NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
					[Warnung setInformativeText:InformationString];
					[Warnung setAlertStyle:NSWarningAlertStyle];
					
					//[Warnung setIcon:RPImage];
					int antwort=[Warnung runModal];
					
					switch (antwort)
					{
						case NSAlertFirstButtonReturn://Papierkorb
						{ 
							NSLog(@"neue Session");
							[self neueSession:NULL];
						}break;
							
						case NSAlertSecondButtonReturn://Magazin
						{
							NSLog(@"Session behalten");
							
						}break;
					}//switch
				}
			}
			else
			{
				SessionDatum=[NSDate date];
				BOOL SessionOK=[Utils saveSessionDatum:[NSDate date] anPfad:SndCalcPfad];
				NSLog(@"readPList	SessionOK: %d",SessionOK);
				[PListDic setObject:[NSDate date] forKey:@"sessiondatum"];
			}
			[SessionDatum retain];
			
			if ([PListDic objectForKey:@"stimmenname"]&&[[PListDic objectForKey:@"stimmenname"] length])
			{
				Stimme=[PListDic objectForKey:@"stimmenname"];
			}
			else
			{
				Stimme =@"home";
				[PListDic setObject:Stimme forKey:@"stimmenname"];
			}
			[Stimme retain];
			NSLog(@"SndCalcController readPList: Stimme: %@",Stimme);
	//		NSLog(@"SndCalcController readPList: Quittungdic: %@",[PListDic objectForKey:@"quittungdic"]);
			
			if ([PListDic objectForKey:@"quittungdic"])
			{
				QuittungDic=[PListDic objectForKey:@"quittungdic"];
				[QuittungDic retain];
			}
			BOOL quittungdicOK=YES;

			if (![QuittungDic objectForKey:@"richtig"])
			{
				[QuittungDic setObject:@"home" forKey:@"richtig"];
				quittungdicOK=NO;
			}
			
			if (![QuittungDic objectForKey:@"falsch"])
			{
				[QuittungDic setObject:@"home" forKey:@"falsch"];
				quittungdicOK=NO;
			}
			if (![QuittungDic objectForKey:@"seriefertig"])
			{
				[QuittungDic setObject:@"home" forKey:@"seriefertig"];
				quittungdicOK=NO;
			}
			if (![QuittungDic objectForKey:@"falscheszeichen"])
			{
				[QuittungDic setObject:@"home" forKey:@"falscheszeichen"];
				quittungdicOK=NO;
			}
			
		if (!quittungdicOK)
		{
			//NSLog(@"readPListAnPfad:	!quittungdicOK QuittungDic: %@",[QuittungDic description]);
			[PListDic setObject:QuittungDic forKey:@"quittungdic"];
		}
			
		}//if PList
		else
		{
			NSLog(@"init: tempPListDic nicht da");
			PListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			NSLog(@"SerieDatenDic From Scratch");
			[SerieDatenDic addEntriesFromDictionary:[self SerieDatenDicVonScratch]];
			Volume=80;
			[SerieDatenDic retain];

		}
	}
	else
	{
		NSLog(@"SndCalcDaten nicht da");
	
		BOOL OrdnerOK=[Filemanager createDirectoryAtPath:SndCalcPfad attributes:NULL];
		return NO;
	}
//	NSLog(@"init: PListDic: %@",[PListDic description]);
	//NSLog(@"init: SerieDatenDic: %@\n",[SerieDatenDic description]);
	return YES;
}

- (BOOL)updatePList
{
	
	NSLog(@"updatePList: %@",SndCalcPfad);
	NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	BOOL istOrdner=NO;
	if ([Filemanager fileExistsAtPath:SndCalcPfad isDirectory:&istOrdner]&&istOrdner)
	{	
		NSLog(@"SndCalcDaten da");
		NSDictionary*tempPListDic=[NSDictionary dictionaryWithContentsOfFile:[SndCalcPfad stringByAppendingPathComponent:PListName]];
		if (tempPListDic)
		{
			//NSLog(@"updatePList: tempPListDic: %@",[tempPListDic description]);
			PListDic=(NSMutableDictionary*)tempPListDic;
//			NSLog(@"updatePList: PListDic testarray: %@",[[PListDic objectForKey:@"testarray"]description]);
			[PListDic retain];
		}
	}
	return YES;
}

- (void)awakeFromNib
{
	
	[[AblaufMenu itemWithTag:10001] setTarget:self];//

	NSString* HomeDatenPfad=[Utils HomeSndCalcDatenPfad];
	//NSLog(@"HomeDatenPfad; %@",HomeDatenPfad);
	NSArray* NetworkDatenArray=[Utils UsersMitSndCalcDatenArray];
	//NSLog(@"NetworkDatenArray: %@",[NetworkDatenArray description]);
	
	if ([NetworkDatenArray count]==1)//Noch nicht eingeloggt
	{
		NSAlert* LoginWarnung=[[NSAlert alloc]init];
		[LoginWarnung setMessageText:@"Du bist noch nicht angemeldet." ];
		[LoginWarnung addButtonWithTitle:@"Zuerst anmelden"];
		[LoginWarnung addButtonWithTitle:@"Hier arbeiten"];
		NSString* i1=@"Du kannst dich zuerst im Netzwerk anmelden oder auf diesem Computer arbeiten";
		[LoginWarnung setInformativeText:i1];
		//[LoginWarnung setInformativeText:@"Du musst dich einloggen, bevor du anfangen kannst."];
		int modalAntwort=1;//[LoginWarnung runModal];
		switch (modalAntwort)
		{
		case NSAlertFirstButtonReturn:
		{
		NSLog(@"terminate");
		[NSApp terminate:self];
		}

		case NSAlertSecondButtonReturn:
		{
		NSLog(@"lokal");

		}
		
		}//switch
		
	}//if count==1: nur Home
	else
	{
	
	}

NSFileManager* Filemanager=[NSFileManager defaultManager];

VolumesPanel=[[rVolumes alloc]init];

SndCalcPfad=[self chooseSndCalcPfadMitUserArray:NetworkDatenArray];
[SndCalcPfad retain];

if (![self readPListAnPfad:SndCalcPfad])
{
NSLog(@"SndCalcPfad: keine PList gefunden");
}
					
//[self DebugStep:@"nach readPListAnPfad"];

//NSLog(@"SndCalcPfad: %@\nPListDic: %@",SndCalcPfad,[PListDic description]);

//NSLog(@"SndCalcPfad: %@\nPListDic: %@",SndCalcPfad,[PListDic description]);

NSColor* HintergrundFarbe=[NSColor colorWithDeviceRed:220.0/255.0 green:255.0/255.0 blue:234.0/255.0 alpha:1.0];
[[self window]setBackgroundColor:HintergrundFarbe];
//[self DebugStep:@"nach setBgColor"];
srand((unsigned int)[[NSDate date] timeIntervalSince1970]);
//NSLog(@"timeIntervalSince1970: %d",[[NSDate date] timeIntervalSince1970]);

//[self DebugStep:@"nach srand"];

//[SettingsDrawer setMinContentSize:NSMakeSize(100,100)];
//[SettingsDrawer setMaxContentSize:NSMakeSize(100,100)];
//[self DebugStep:@"vor initReihenSettings"];
[self initReihenSettings];
//[self DebugStep:@"nach initReihenSettings"];
[self initAddSubSettings];

//[self DebugStep:@"nach initSettings"];
[self setSettings:SerieDatenDic];

[[[self window]contentView]addSubview:RechnungsBox];
[[RechnungsBox contentView]addSubview:ErgebnisView];
//[ErgebnisFeld setTag:0];
[[RechnungsBox contentView]addSubview:ErgebnisView];
//[ErgebnisFeld setEditable:NO];
[[RechnungsBox contentView]addSubview:ErgebnisRahmenFeld];


NSImage* myImage = [NSImage imageNamed: @"Duerer"];
[NSApp setApplicationIconImage: myImage];

[Bild setImage: [NSImage imageNamed: @"duerergrau"]];

    
    /* we must initialize the movie toolbox before calling
        any of it's functions */
//		[self DebugStep:@"vor EnterMovies"];
EnterMovies();
//[self DebugStep:@"nach EnterMovies"];

	saveObjectForCallback(self);
//[self DebugStep:@"nach saveObjectForCallback"];
	
	Speaker=[[rSpeaker alloc]init];
	if (Speaker)
{
		[Speaker setVolume:Volume];
		[VolumeSchieber setFloatValue:Volume];
		[Speaker setStimme:Stimme];
		//NSLog(@"awake	SndCalcPfad: %@\nPListDic: %@",SndCalcPfad,[PListDic description]);
		
		[Speaker setQuittungSelektionDic:[PListDic objectForKey:@"quittungdic"]];
		//NSLog(@"\nawake: Speaker setzen OK\n\n");
}

//[self DebugStep:@"nach Speaker"];

	[[[self window]contentView]addSubview:[Speaker AufgabenPlayer]];
	

	BOOL ZahlenOK=[Speaker readZahlen];
	//NSLog(@"awake: nach readZahlen    ZahlenOK: %d",ZahlenOK);
//	[self DebugStep:@"nach Speaker readZahlen"];
	BOOL QuittungenOK=[Speaker readQuittungen];
	//NSLog(@"awake: nach readQuittungen     QuittungenOK: %d",QuittungenOK);
//	[self DebugStep:@"nach Speaker readQuittungen"];
	AnzahlAufgaben=24;
	anzRichtig=0;
	anzFehler=0;
	NSRect AufgabenBoxRect=[AufgabenBox frame];
	AufgabenBoxRect.origin=NSMakePoint(15,10);
	AufgabenBoxRect.size.width-=20;
	AufgabenBoxRect.size.height=20;
	Aufgabenzeiger=[[rAufgabenzeiger alloc]initWithFrame:AufgabenBoxRect];
	[AufgabenBox addSubview:Aufgabenzeiger];
	[Aufgabenzeiger setAnzAufgaben:AnzahlAufgaben];
	[Aufgabenzeiger setAnzahl:0];
	
	NSRect ZeitBoxRect=[ZeitBox frame];
	ZeitBoxRect.origin=NSMakePoint(15,10);
	ZeitBoxRect.size.width-=80;
	ZeitBoxRect.size.height=20;
	Zeitanzeige=[[rZeitanzeige alloc]initWithFrame:ZeitBoxRect];
	[ZeitBox addSubview:Zeitanzeige];
	[Zeitanzeige setMax:120];
	[Zeitanzeige setZeit:0];
	NSPoint ZeitFeldEcke;
	ZeitFeldEcke.x=ZeitBoxRect.origin.x+ZeitBoxRect.size.width;
	ZeitFeldEcke.y=ZeitBoxRect.origin.y-1;
	[ZeitFeld setFrameOrigin:ZeitFeldEcke];
	[ZeitFeld setStringValue:@"0"];
	[ZeitFeld display];
	[ZeitFeld setToolTip:@"Restzeit"];
	//[OKTaste setToolTip:@"Eingabe fertig"];
	//[StartTaste setToolTip:@"Aufgabe ausgeben"];
	//[ErgebnisFeld setDelegate:self];
	//[ErgebnisFeld setTarget:self];

	//[ErgebnisFeld setAction:@selector(ErgebnisFeldAktion:)];
	//[ErgebnisFeld setAction:NULL];
	verify=0;
	[ErgebnisView setErgebnisView];
	[ErgebnisView setDelegate:self];
	//[ErgebnisView setTarget:self];
	[TestPopKnopf removeAllItems];
	//[TestPopKnopf addItemWithTitle:@"Training"];
	NSMutableArray* TestDicArray=(NSMutableArray*)[PListDic objectForKey:@"testarray"];

	//NSLog(@"ZeitArray aus Pop: %@",[[ZeitPopKnopf itemArray] description]);
	NSArray* ZeitArray=[NSArray arrayWithObjects:@"120 s",@"90 s",@"60 s",@"30 s",@"10 s",nil];
	//NSLog(@"ZeitArray: %@",[ZeitArray description]);
	
	[ZeitPopKnopf removeAllItems];
	[ZeitPopKnopf addItemsWithTitles:ZeitArray];
//	[self DebugStep:@"nach ZeitPopKnopf"];
	NSEnumerator* ItemEnum=[[ZeitPopKnopf itemArray] objectEnumerator];
	id einItem;
	while (einItem=[ItemEnum nextObject])
	{
	int tempTag=[[einItem title]intValue];
	[einItem setTag:[[einItem title]intValue]];
	//NSLog(@"Titel: %@ tag neu: %d",[einItem title],[einItem tag]);
	}//while
	
	NSArray* AnzahlArray=[NSArray arrayWithObjects:@"24",@"16",@"12",@"6",@"2",nil];
	//NSLog(@"AnzahlArray: %@",[AnzahlArray description]);
	
	[AnzahlPopKnopf removeAllItems];
	[AnzahlPopKnopf addItemsWithTitles:AnzahlArray];
	
	NSEnumerator* AnzItemEnum=[[AnzahlPopKnopf itemArray] objectEnumerator];
	id einAnzItem;
	while (einAnzItem=[AnzItemEnum nextObject])
	{
	int tempTag=[[einAnzItem title]intValue];
	[einAnzItem setTag:[[einAnzItem title]intValue]];
	//NSLog(@"Titel: %@ tag neu: %d",[einAnzItem title],[einAnzItem tag]);
	}//while
	
	
	
	//NSLog(@"ZeitArray aus Pop nach load: %@",[[ZeitPopKnopf itemArray] description]);
	[ZeitPopKnopf selectItemAtIndex:0];
	
	if (TestDicArray &&[TestDicArray count])
	{
		int i;
		for (i=0;i<[TestDicArray count];i++)
		{
			//NSLog(@"TestDic: %@",[[TestDicArray objectAtIndex:i]description]);
			if ([[[TestDicArray objectAtIndex:i]objectForKey:@"aktiv"]intValue])
			{
				//NSLog(@"addieren: TestDic: %@",[[TestDicArray objectAtIndex:i]objectForKey:@"testname"]);
				if ([[TestDicArray objectAtIndex:i]objectForKey:@"testname"])
				{
				[TestPopKnopf addItemWithTitle:[[TestDicArray objectAtIndex:i]objectForKey:@"testname"]];
				}
				else if ([[TestDicArray objectAtIndex:i]objectForKey:@"name"])
				{
				[TestPopKnopf addItemWithTitle:[[TestDicArray objectAtIndex:i]objectForKey:@"name"]];
				}
				
			}
		}
//		[TestPopKnopf setEnabled: YES];
		[ModusOption selectCellAtRow:0 column:0];
	}
	else
	{
		[TestPopKnopf setEnabled: NO];
		[ModusOption selectCellAtRow:1 column:0];
		[ZeitPopKnopf setEnabled:YES];
		[AnzahlPopKnopf setEnabled:YES];

	
	}

//[self DebugStep:@"nach setTestPopKnopf"];
	NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];


	if (tempNamenDicArray && [tempNamenDicArray count])
	{
		[self setNamenPopKnopfMitDicArray:[tempNamenDicArray copy]];
	}
	
	if ([TestPopKnopf numberOfItems]&&[TestPopKnopf titleOfSelectedItem])
	{
	NSLog(@"%awake	%@",[TestPopKnopf titleOfSelectedItem]);
	[self setTestVonTestname:[TestPopKnopf titleOfSelectedItem]];	
	}
	[NamenPopKnopf selectItemAtIndex:0];
	[ErgebnisseTaste setEnabled:NO];
	//NSLog(@"awake NamenPop: %@",[[NamenPopKnopf itemArray] description]);
	
//	[self DebugStep:@"vor Menu Validation"];

	[[AblaufMenu itemWithTag:kNeuerNameTag] setTarget:self];//
	[[AblaufMenu itemWithTag:kTestListeTag] setTarget:self];//
	[[AblaufMenu itemWithTag:kChangePasswortTag] setTarget:self];//
	[[AblaufMenu itemWithTag:kNeueSessionTag] setTarget:self];//
	[[AblaufMenu itemWithTag:kNeuerTestTag] setTarget:self];
	
	[[AblaufMenu itemWithTag:kStimmeTag] setTarget:Speaker];//
	
	[[AblaufMenu itemWithTag:kStimmeTag] setAction:@selector(showStimmenPanel:)];
	
	[NamenPopKnopf setToolTip:NSLocalizedString(@"Choose a name.",@"Einen Namen auswählen.")];
	[ZeitPopKnopf setToolTip:NSLocalizedString(@"Only in training mode:\n Maximal amount of time for a serie.",@"Zeit wählen.")];
	[AnzahlPopKnopf setToolTip:NSLocalizedString(@"Only in training mode:\n Numer of tasks in a serie.",@"Anzahl wählen.")];
	[OKTaste setToolTip:NSLocalizedString(@"Check the result.",@"Ergebnis testen.")];
	[StartTaste setToolTip:NSLocalizedString(@"Start the serie of tasks.",@"Die Aufgabenserie starten.")];
	[SettingsPfeil setToolTip:NSLocalizedString(@"Open settingwindow for tasks.",@"Einstellungsfenster für die Aufgaben öffnen.")];
	[neueSerieTaste setToolTip:NSLocalizedString(@"Create a new serie of tasks.",@"Eine neue Aufgabenserie bereitstellen.")];
	[TestPopKnopf setToolTip:NSLocalizedString(@"Choose a test.",@"Einen Test auswählen.")];
	[VolumeSchieber setToolTip:NSLocalizedString(@"Choose the volume of the speaker.",@"Die Lautstärke einstellen.")];
	[ErgebnisseTaste setToolTip:NSLocalizedString(@"Show my results.",@"Meine Ergebnisse zeigen.")];
	[ZeitFeld setToolTip:NSLocalizedString(@"Time remaining.",@"Verbleibende Zeit.")];
	[Aufgabenzeiger setToolTip:NSLocalizedString(@"Number of tasks in the choosen serie.",@"Anzahl Aufgaben der gewählten Serie.")];
	[Zeitanzeige setToolTip:NSLocalizedString(@"Elapsed time.",@"Abgelaufene Zeit.")];
	[ModusOption setToolTip:NSLocalizedString(@"Chose mode.",@"Modus einstellen.")];
	[ErgebnisView setToolTip:NSLocalizedString(@"Input field",@"Eingabefeld")];
	[AufgabenNummerFeld setToolTip:NSLocalizedString(@"Task number",@"Aufgabennummer")];
	[SettingsPfeil setToolTip:NSLocalizedString(@"Settings are only available in Training Modus",@"Die Einstellungen sind nur im Trainigsmodus zugänglich")];
	[ToggleSessionKnopf setToolTip:NSLocalizedString(@"Userlist with marked users having done the test in the current session.",@"Liste mit markierten Usern")];
	[IconView setToolTip:NSLocalizedString(@"Magic from the painting 'Melencholia I' of Leonardo",@"Leonardo")];

//[self DebugStep:@"awake Schluss "];

/*
	NSData *daten = [[NSData alloc] init];
	NSURLResponse *resultat = [[NSURLResponse alloc] init];
			
	NSURL *	localHostAdresse = [NSURL URLWithString: @"http://www.compi.freaks.ch.vu"];
	NSURL *	url = [NSURL URLWithString: @"http://www.apple.com/"];
	
	NSURLRequest *	anfrage = [NSURLRequest requestWithURL: localHostAdresse];
	
	NSURLConnection *	anfrageSenden = [NSURLConnection connectionWithRequest: anfrage delegate: resultat]; 
	NSLog(@"anfrageSenden: %@",[anfrageSenden description]);
//	NSString *urlContent = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
	NSString *urlContent = [NSString stringWithContentsOfURL:url];

NSLog(@"urlContent: %@",urlContent);
*/
}


- (NSString*)chooseSndCalcPfadMitUserArray:(NSArray*)derUserArray
{
	NSArray* tempUserArray=[NSArray arrayWithArray:derUserArray];
	[tempUserArray retain];
	[derUserArray release];
	//NSLog(@"vor Dialog in chooseLeseboxPfadMitUserArray :derUserArray: %@",[derUserArray description]);

	//return [NSString string];

	
	NSModalSession VolumeSession=[NSApp beginModalSessionForWindow:[VolumesPanel window]];

	//in VolumesPanel Daten einsetzen
	[VolumesPanel setUserArray:tempUserArray];

	int modalAntwort = [NSApp runModalForWindow:[VolumesPanel window]];
	//NSLog(@"beginSheet: Antwort: %d",modalAntwort);

	//SndCalcDatenPfad aus Panel abfragen
	NSString* tempSndCalcDatenPfad=[NSString stringWithString:[VolumesPanel SndCalcDatenPfad]];
	[tempSndCalcDatenPfad retain];
	//istSystemVolume=[VolumesPanel istSystemVolume];
	
	//Für Volumes mit System zeigt der SndCalcDatenPfad auf einen Ordner in Documents
	//Für Externe HDs zeigt der SndCalcDatenPfad auf einen Ordner direkt auf der HD. 
	//Die PList wird im Ordner 'Data' in der Lesebox abgelegt.
	
	
	//NSLog(@"chooseSndCalcPfadMitUserArray: Antwort: %d  SndCalcDatenPfad: %@",modalAntwort,tempSndCalcDatenPfad);
	//NSLog(@"chooseSndCalcPfadMitUserArray: SndCalcDatenPfad: %@",tempSndCalcDatenPfad);

	[NSApp endModalSession:VolumeSession];

	[[VolumesPanel window] orderOut:NULL];   
	//NSLog(@"VolumesPanel: Antwort: %d",modalAntwort);

	return tempSndCalcDatenPfad;
	
}//chooseSndCalcPfadVon

- (void)VolumeWahlAktion:(NSNotification*)note
{
	//NSLog(@"VolumeWahlAktion: note: %@",[[note userInfo]description]);
	//NSLog(@"VolumesAktion");
	NSNumber* SndCalcDatenDaNumber=[[note userInfo]objectForKey:@"SndCalcDatenDa"];
	SndCalcDatenDa=[SndCalcDatenDaNumber boolValue];
	if (SndCalcDatenDa==0)//Abbrechen
	{
		[self terminate:NULL];
		//NSLog(@"VolumesAktion: number=0 %d   ",[SndCalcDatenDa intValue]);
		//Beenden
		NSMutableDictionary* BeendenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		[BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
		NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
		[beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
	}
	//NSLog(@"VolumesAktion: number %d   ",[n intValue]);
	
}

- (void)setTestPop
{
	[TestPopKnopf removeAllItems];
	//[TestPopKnopf addItemWithTitle:@"Training"];
//	NSMutableArray* TestDicArray=(NSMutableArray*)[PListDic objectForKey:@"testarray"];
	NSMutableArray* TestDicArray=(NSMutableArray*)[Utils TestArrayAusPListAnPfad:SndCalcPfad];
	
	if (TestDicArray &&[TestDicArray count])
	{
		int i;
		for (i=0;i<[TestDicArray count];i++)
		{
			//NSLog(@"TestDic: %@",[[TestDicArray objectAtIndex:i]description]);
			if ([[[TestDicArray objectAtIndex:i]objectForKey:@"aktiv"]intValue])
			{
				//NSLog(@"addieren: TestDic: %@",[[TestDicArray objectAtIndex:i]objectForKey:@"testname"]);
				[TestPopKnopf addItemWithTitle:[[TestDicArray objectAtIndex:i]objectForKey:@"testname"]];
				
			}
		}
	}

}

- (void)setTestPopKnopfForUser:(NSString*)derUser
{
	[TestPopKnopf removeAllItems];
	//[TestPopKnopf addItemWithTitle:@"Training"];
//	NSMutableArray* TestDicArray=(NSMutableArray*)[PListDic objectForKey:@"testarray"];
	NSArray* tempUserTestArray=[Utils UserTestArrayVonUser:derUser anPfad:SndCalcPfad];
	//NSLog(@"tempUserTestArray: %@",[tempUserTestArray description]);
	NSMutableArray* TestDicArray=(NSMutableArray*)[Utils TestArrayAusPListAnPfad:SndCalcPfad];
	//NSLog(@"TestDicArray: %@",[TestDicArray description]);
	if (TestDicArray &&[TestDicArray count]&&[tempUserTestArray count])
	{
		int i;
		for (i=0;i<[TestDicArray count];i++)
		{
			//NSLog(@"TestDic: %@",[[TestDicArray objectAtIndex:i]description]);
			if ([[[TestDicArray objectAtIndex:i]objectForKey:@"aktiv"]intValue])
			{
				if ([tempUserTestArray containsObject:[[TestDicArray objectAtIndex:i]objectForKey:@"testname"]])
				{
					//NSLog(@"addieren: TestDic: %@",[[TestDicArray objectAtIndex:i]objectForKey:@"testname"]);
					[TestPopKnopf addItemWithTitle:[[TestDicArray objectAtIndex:i]objectForKey:@"testname"]];
				}
				
			}
		}
		if ([TestPopKnopf numberOfItems]==0)//Keine Tests für denUser vorhanden
		{
		NSLog(@"Fuer %@ sind keine passenden Tests vorhanden",derUser);
		[TestPopKnopf addItemsWithTitles:[TestDicArray valueForKey:@"testname"]];
		}
	}

}

- (void)setTestPopKnopfMitArray:(NSArray*)derTestDicArray
{
	[TestPopKnopf removeAllItems];
	//[TestPopKnopf addItemWithTitle:@"Training"];
	
	if (derTestDicArray &&[derTestDicArray count])
	{
		int i;
		for (i=0;i<[derTestDicArray count];i++)
		{
			//NSLog(@"TestDic: %@",[[TestDicArray objectAtIndex:i]description]);
			if ([[[derTestDicArray objectAtIndex:i]objectForKey:@"aktiv"]intValue])
			{
				//NSLog(@"addieren: TestDic: %@",[[derTestDicArray objectAtIndex:i]objectForKey:@"testname"]);
				[TestPopKnopf addItemWithTitle:[[derTestDicArray objectAtIndex:i]objectForKey:@"testname"]];
				
			}
		}
	}

}




- (BOOL)validateMenuItem:(NSMenuItem*)anItem 
{
	//NSLog(@"[anItem title]: %@  [anItem tag]: %d",[anItem title],[anItem tag]);
	switch ([anItem tag])
	{
		case kTestListeTag:
		{
			return YES;
		}break;

		case kNeuerNameTag:
		{
			//return (Modus==kTrainingModus);
			return YES;
		}break;
		
		case 10001:
		{
			//NSLog(@"validateMenuItem: Statistik: %d AdminOK %d",(!(Statistik==NULL)),[Statistik AdminOK]);
			return (Statistik &&[Statistik AdminOK]);
		}break;

		case kChangePasswortTag:
		case kNeueSessionTag:
		{
		//NSLog(@"validateMenuItem:kChangePasswortTag");
			return YES;
		}break;

		case kNeuerTestTag:
		{
			return YES;
		}break;
		
		case kStimmeTag:
		{
			return YES;
		}break;
		
		}//switch
	return YES;
}

- (IBAction)ClearAktion:(id)sender
{
NSLog(@"ClearAktion SC");
}



- (BOOL)readZahlen
{
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	NSLog(@"\n\nreadZahlen start");
	NSString* ZahlenPfad=[SndCalcPfad stringByAppendingPathComponent:@"Zahlen_2/Finish.aiff"];
	NSArray* tempHanniZahlenArray=[Filemanager directoryContentsAtPath:ZahlenPfad];
	NSLog(@"tempHanniZahlenArray: %@",[tempHanniZahlenArray description]);
	NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources"];
	NSString* APfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources/A"];
	NSString* FinishPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources/Finish.aiff"];
//	BOOL copyOK=[Filemanager removeFileAtPath:APfad handler:NULL];
//	NSLog(@"copyOK: %d",copyOK);
	NSArray* BundleArray=[Filemanager directoryContentsAtPath:ResourcenPfad];
//	NSLog(@"BundleArray path: %@	Array: %@",[[NSBundle mainBundle]bundlePath],[BundleArray description]);

	NSArray* tempZahlenArray=[Filemanager directoryContentsAtPath:ResourcenPfad];

NSString* BundlePfad=[[NSBundle mainBundle]bundlePath];

NSLog(@"BundlePfad: %@",BundlePfad);
NSLog(@"readZahlen end\n");
return YES;
}

- (void)setSettings:(NSDictionary*)dieSettings
{
[ReihenSettings setSettingsMit:dieSettings];
[AddSubSettings setSettingsMit:dieSettings];
[TestPopKnopf removeAllItems];
//[TestPopKnopf addItemWithTitle:@"Training"];
NSArray* TestDicArray=[dieSettings objectForKey:@"testarray"];
NSEnumerator* TestEnum=[TestDicArray objectEnumerator];
id einTestDic;
while (einTestDic=[TestEnum nextObject])
{
if ([[einTestDic objectForKey:@"aktiv"]intValue]) //Test ist aktiv
{
[TestPopKnopf addItemWithTitle:[[einTestDic objectForKey:@"testname"]stringValue]];
}
}//while

}

- (void)selectSettingsTab:(int)derTab
{
[SettingsBox selectTabViewItemAtIndex:derTab];
}


- (NSDictionary*)PListDicVonSettings
{
	NSMutableDictionary* tempPListDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	NSDictionary* ReihenSettingsDic=[ReihenSettings getSettings];
	//NSLog(@"ReihenSettingsDic: %@",[ReihenSettingsDic description]);
	[tempPListDic addEntriesFromDictionary:ReihenSettingsDic];
	//NSLog(@"tempPListDic mit Mult: %@",[tempPListDic description]);
	
	NSDictionary* AddSubSettingsDic=[AddSubSettings getSettings];
	//NSLog(@"AddSubSettingsDic: %@",[AddSubSettingsDic description]);
	[tempPListDic addEntriesFromDictionary:AddSubSettingsDic];
	//NSLog(@"tempPListDic mit Add: %@",[tempPListDic description]);
	[tempPListDic setObject:[NSNumber numberWithInt:[[AnzahlPopKnopf titleOfSelectedItem]intValue]] forKey:@"anzahlaufgaben"];
	[tempPListDic setObject:[NSNumber numberWithInt:[[ZeitPopKnopf titleOfSelectedItem]intValue]] forKey:@"zeit"];
	return  tempPListDic;
}

- (IBAction)neueSerie:(id)sender
{
	int multOK=[ReihenSettings checkSettings];
	int addsubOK=[AddSubSettings checkSettings];
	//NSLog(@"\n\n				neueSerie	multOK: %d		addsubOK: %d",multOK,addsubOK);

	if (multOK+addsubOK==0)
	{
	NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
	[Warnung addButtonWithTitle:@"OK"];
	[Warnung setMessageText:NSLocalizedString(@"No Operation Choosed",@"Keine Operation ausgewählt")];
	NSString* InformationString=NSLocalizedString(@"At least one operation must be choosed.",@"Mindestens eine Operation muss ausgewähltsein.");
	[Warnung setInformativeText:InformationString];
	[Warnung setAlertStyle:NSWarningAlertStyle];
	
	//[Warnung setIcon:RPImage];
	int antwort=[Warnung runModal];
	return;
	}
	else
	{
	if (multOK==1)
	{
		NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
		[Warnung addButtonWithTitle:@"OK"];
		[Warnung setMessageText:NSLocalizedString(@"No Row Choosed",@"Keine Reihe ausgewählt")];
		NSString* InformationString=NSLocalizedString(@"At least one row must be choosed.",@"Mindestens eine Reihe muss ausgewählt sein.");
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		int antwort=[Warnung runModal];
		[self selectSettingsTab:0];
		return;
	}
	if (addsubOK==1)
	{
		NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
		[Warnung addButtonWithTitle:@"OK"];
		[Warnung setMessageText:NSLocalizedString(@"No Operation Choosed",@"Keine Operation ausgewählt")];
		NSString* InformationString=NSLocalizedString(@"Addition and/or subtraction must be choosed.",@"Addition und/oder Subtraktion muss ausgewählt sein.");
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		int antwort=[Warnung runModal];
		[self selectSettingsTab:1];
		return;
	}

	}

	[self closeSessionDrawer:NULL];
	//NSLog(@"neue Serie begin");
	//NSLog(@"neueSerie Anfang: SeriedatenDic: %@\n",[SerieDatenDic description]);
	[ErgebnisRahmenFeld setHidden:YES];
	[ErgebnisView setMark:0];
	[ErgebnisView setString:@""];
	[self closeAufgabenDrawer:NULL];
	if ([SettingsDrawer state]==NSDrawerOpenState)
	{
		NSLog(@"neueSerie: SettingsDrawer =NSDrawerOpenState");
		[SerieDatenDic setObject:@"Training" forKey:@"testname"];
		[SerieDatenDic addEntriesFromDictionary:[self SerieDatenDicAusSettings]];
		[self closeDrawer:NULL];
		NSLog(@"neueSerie nach closeDrawer: SeriedatenDic: %@\n",[SerieDatenDic description]);
	}
	
	
	[AblaufzeitTimer invalidate];
	//NSLog(@"timeIntervalSince1970: %f",[[NSDate date] timeIntervalSince1970]);
	//srand(time(NULL));
	//srand([[NSDate date] timeIntervalSince1970]);
	srandom((unsigned int)[[NSDate date] timeIntervalSince1970]);
	//srand(time(0));
	//NSLog(@"timeIntervalSinceNow: %qi",[[NSDate date] timeIntervalSinceNow]);
	
	//	NSLog(@"neueSerie: random: %d ",random());
	SerieDaten=[self SerieDatenVonDic:SerieDatenDic];
	
	
	
	if (Modus==kTrainingModus)
	{
		SerieDaten.AnzahlAufgaben=[[AnzahlPopKnopf selectedItem]tag];
		SerieDaten.Zeit=[[ZeitPopKnopf selectedItem]tag];
		
	}
	abgelaufeneZeit=0;
	anzRichtig=0;
	anzFehler=0;
	MaximalZeit=SerieDaten.Zeit;
	//NSLog(@"neue Serie: Zeit: %d",MaximalZeit);
	AnzahlAufgaben=SerieDaten.AnzahlAufgaben;
	
	[AnzahlPopKnopf selectItemAtIndex:[AnzahlPopKnopf indexOfItemWithTag:SerieDaten.AnzahlAufgaben]];
	[ZeitPopKnopf selectItemAtIndex:[ZeitPopKnopf indexOfItemWithTag:SerieDaten.Zeit]];
	//AnzahlAufgaben=[[AnzahlPopKnopf titleOfSelectedItem]intValue];
	//NSLog(@"					AnzahlAufgaben: %d",AnzahlAufgaben);
	//MaximalZeit=[[ZeitPopKnopf titleOfSelectedItem]intValue];
	aktuelleAufgabenNummer=1;
	[StartTaste setTitle:NSLocalizedString(@"Start",@"Start")];
	[AufgabenNummerFeld setIntValue:1];
	[ZeitFeld setIntValue:MaximalZeit];
	[Zeitanzeige setMax:MaximalZeit];
	[Zeitanzeige setZeit:0];
	//[Aufgabenzeiger setAnzAufgaben:[[AnzahlPopKnopf titleOfSelectedItem]intValue]];
	[Aufgabenzeiger setAnzAufgaben:AnzahlAufgaben];
	[Aufgabenzeiger setAnzahl:0];
	[ErgebnisRahmenFeld setMark:-1];
	
	if (!AufgabenSerie)
	{
		
		AufgabenSerie=new rSerie(SerieDaten.AnzahlAufgaben);
	}
	//NSLog(@"neueSerie: %d",SerieDaten.AnzahlAufgaben);
	
	AufgabenDatenRecord  AufgabenDatenArray[kMaxAnzahlAufgaben];
	//NSLog(@"neueSerie: Add: %d  Sub: %d  Mult: %d",SerieDaten.Addition,SerieDaten.Subtraktion,SerieDaten.Multiplikation);
	
	
	AufgabenSerie->neueSerie(SerieDaten,AufgabenDatenArray);
	
	//NSLog(@"neueSerie: nummer: %d var 0: %d op 0: %d var 1: %d var 2: %d",AufgabenDatenArray[0].aktuelleAufgabennummer,AufgabenDatenArray[0].var[0],AufgabenDatenArray[0].op[0],AufgabenDatenArray[0].var[1],AufgabenDatenArray[0].var[2]);
	
	NSMutableArray* tempAufgabenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	//NSLog(@"tempAufgabenDatenArray: nach neueSerie");
	int zeile;
	for (zeile=0;zeile<SerieDaten.AnzahlAufgaben;zeile++)
	{
		//NSLog(@"neueSerie: zeile: %d",zeile);
		//NSLog(@"neueSerie: nummer: %d var 0: %d op 0: %d var 1: %d var 2: %d",AufgabenDatenArray[zeile].aktuelleAufgabennummer,AufgabenDatenArray[zeile].var[0],AufgabenDatenArray[zeile].op[0],AufgabenDatenArray[zeile].var[1],AufgabenDatenArray[zeile].var[2]);
		//AufgabenNummer
		NSMutableDictionary* tempAufgabenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		[tempAufgabenDic setObject:[NSNumber numberWithInt:AufgabenDatenArray[zeile].aktuelleAufgabennummer]
							forKey:@"aufgabennummer"];
		
		//Var 0
		[tempAufgabenDic setObject:[NSNumber numberWithInt:AufgabenDatenArray[zeile].var[0]]
							forKey:@"var0"];
		
		//Var 1
		[tempAufgabenDic setObject:[NSNumber numberWithInt:AufgabenDatenArray[zeile].var[1]]
							forKey:@"var1"];
		
		
		//Op
		NSString* Operator;
		switch(AufgabenDatenArray[zeile].op[0])
		{
			case 1://Plus
			{
				Operator=@"+";
			}break;
				
			case 2://Minus
			{
				Operator=@"-";
			}break;
				
				
			case 3://Mal
			{
				Operator=@"*";
			}break;
		}//switch
		[tempAufgabenDic setObject:Operator
							forKey:@"operatorzeichen"];
		
		[tempAufgabenDic setObject:[NSNumber numberWithInt:AufgabenDatenArray[zeile].op[0]+2000]
							forKey:@"op0"];
		
		//Ergebnis
		[tempAufgabenDic setObject:[NSNumber numberWithInt:AufgabenDatenArray[zeile].var[2]]
							forKey:@"var2"];
		//NSLog(@"tempAufgabenDic: %@",[tempAufgabenDic description]);
		[tempAufgabenArray addObject:tempAufgabenDic];
		
	}
	
	//NSLog(@"tempAufgabenArray: %@",[tempAufgabenArray description]);
	
	
	AufgabenArray=[tempAufgabenArray copy];
	[AufgabenArray retain];
	[StartTaste setEnabled:YES];
	[StartTaste setKeyEquivalent:@"\r"];
	[[self window]makeFirstResponder:StartTaste];
	
	//[self startTimeout];
	//NSLog(@"neue Serie ende");
}

- (ProgPrefsRecord)SerieDatenVonDic:(NSDictionary*)derSerieDatenDic
{
	int DatenOK=0;
	ProgPrefsRecord tempSerieDaten;
	NSIndexSet* BoolBereich=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)];
	
	NSIndexSet* AnzBereich=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,24)];
	NSNumber* tempAnzNumber=[derSerieDatenDic objectForKey:@"anzahlaufgaben"];
	if (tempAnzNumber&&[AnzBereich containsIndex:[tempAnzNumber intValue]])
	{
		tempSerieDaten.AnzahlAufgaben=[tempAnzNumber intValue];
	}
	else
	{
		tempSerieDaten.AnzahlAufgaben=12;
	}
	
	NSIndexSet* ZeitBereich=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(10,120)];	
	NSNumber* tempZeitNumber=[derSerieDatenDic objectForKey:@"zeit"];
	//NSLog(@"SerieDatenDic: tempZeitNumber: %@",[tempZeitNumber description]);
	if (tempZeitNumber&&[ZeitBereich containsIndex:[tempZeitNumber intValue]])
	{
		tempSerieDaten.Zeit=[tempZeitNumber intValue];
	}
	else
	{
		tempSerieDaten.Zeit=120;
	}
	
	//Multiplikation
	NSNumber* tempMultiplikationNumber=[derSerieDatenDic objectForKey:@"multiplikation"];
	if (tempMultiplikationNumber&&[BoolBereich containsIndex:[tempMultiplikationNumber intValue]])
	{
		tempSerieDaten.Multiplikation=[tempMultiplikationNumber intValue];
	}
	else
	{
		tempSerieDaten.Multiplikation=1;
	}
	
	NSIndexSet* AnzReihenBereich=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,30)];	
	NSNumber* tempAnzahlReihenNumber=[derSerieDatenDic objectForKey:@"anzahlreihen"];
	if (tempAnzahlReihenNumber&&[AnzReihenBereich containsIndex:[tempAnzahlReihenNumber intValue]])
	{
		tempSerieDaten.AnzahlReihen=[tempAnzahlReihenNumber intValue];
	}
	else
	{
		if (tempSerieDaten.Multiplikation)
		{
			tempSerieDaten.AnzahlReihen=8;
		}
	}
	
	NSArray* tempReihenArray=[derSerieDatenDic objectForKey:@"reihenarray"];
	if (tempReihenArray&&[tempReihenArray count])
	{
		for (int i=0;i<kMaxAnzReihen;i++)
		{
			if (i<[tempReihenArray count])
			{
				tempSerieDaten.Reihenliste[i]=[[tempReihenArray objectAtIndex:i]intValue];
			}
			else
			{
				tempSerieDaten.Reihenliste[i]=0;
			}
		}//for i
	}
	else//Keine Reihen
	{
	for (int i=0;i<kMaxAnzReihen;i++)
		{
			if (i<tempSerieDaten.AnzahlReihen)
			{
				tempSerieDaten.Reihenliste[i]=i+1;
			}
			else
			{
				tempSerieDaten.Reihenliste[i]=0;
			}
		}//for i

	}
	
	//ZehnerReihen
	NSNumber* tempZehnerReihenNumber=[derSerieDatenDic objectForKey:@"zehnerreihen"];
	if (tempZehnerReihenNumber &&[BoolBereich containsIndex:[tempZehnerReihenNumber intValue]])
	{
		tempSerieDaten.MDZehnerReihen=[tempZehnerReihenNumber intValue];
	}
	else
	{
		tempSerieDaten.MDZehnerReihen=0;
	}
	
	//HunderterReihen
	NSNumber* tempHunderterReihenNumber=[derSerieDatenDic objectForKey:@"hunderterreihen"];
	if (tempHunderterReihenNumber &&[BoolBereich containsIndex:[tempHunderterReihenNumber intValue]])
	{
		tempSerieDaten.MDHunderterReihen=[tempHunderterReihenNumber intValue];
	}
	else
	{
		tempSerieDaten.MDHunderterReihen=0;
	}
	
	//Kleines1Mal1
	NSNumber* tempKleines1Mal1Number=[derSerieDatenDic objectForKey:@"kleines1mal1"];
	if (tempKleines1Mal1Number  &&[BoolBereich containsIndex:[tempKleines1Mal1Number intValue]])
	{
		tempSerieDaten.MDKleines1Mal1=[tempKleines1Mal1Number intValue];
	}
	else
	{
		tempSerieDaten.MDKleines1Mal1=1;
	}
	
	//Grosses1Mal1
	NSNumber* tempGrosses1Mal1Number=[derSerieDatenDic objectForKey:@"grosses1mal1"];
	if (tempGrosses1Mal1Number  &&[BoolBereich containsIndex:[tempGrosses1Mal1Number intValue]])
	{
		tempSerieDaten.MDGrosses1Mal1=[tempGrosses1Mal1Number intValue];
	}
	else
	{
		tempSerieDaten.MDGrosses1Mal1=0;
	}
	tempSerieDaten.MultDivZehnerpotenz1=0;
	tempSerieDaten.MultDivZehnerpotenz2=0;
	tempSerieDaten.Division=0;
	tempSerieDaten.MultDivZehnerpotenz1=0;
	tempSerieDaten.MultDivZehnerpotenz2=0;
	tempSerieDaten.MultDivmitAdd=0;
	tempSerieDaten.MultDivmitSub=0;

	//Addition
	NSNumber* AddSubEin=[derSerieDatenDic objectForKey:@"addsubein"];
	if (AddSubEin&&[AddSubEin intValue]==1)//AddSub ist eingeschaltet
	{
	NSNumber* tempAdditionNumber=[derSerieDatenDic objectForKey:@"addition"];
	if (tempAdditionNumber &&[BoolBereich containsIndex:[tempAdditionNumber intValue]])
	{
		tempSerieDaten.Addition=[tempAdditionNumber intValue];
	}
	else
	{
		tempSerieDaten.Addition=0;
	}
	
	//Subtraktion
	NSNumber* tempSubtraktionNumber=[derSerieDatenDic objectForKey:@"subtraktion"];
	if (tempSubtraktionNumber &&[BoolBereich containsIndex:[tempSubtraktionNumber intValue]])
	{
		tempSerieDaten.Subtraktion=[tempSubtraktionNumber intValue];
	}
	else
	{
		tempSerieDaten.Subtraktion=0;
	}
	
	//Bereich
	NSIndexSet* AddSubBereichSet=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,6)];
	//NSLog(@"AddSubBereichSet: %@",[AddSubBereichSet description]);
	NSNumber* tempBereichNumber=[derSerieDatenDic objectForKey:@"bereich"];
	if (tempBereichNumber &&[AddSubBereichSet containsIndex:[tempBereichNumber intValue]])
	{
		tempSerieDaten.ASBereich=[tempBereichNumber intValue]+1;
	}
	else
	{
		tempSerieDaten.ASBereich=1;
	}
	
	//zweiteZahl
	NSNumber* tempZweiteZahlNumber=[derSerieDatenDic objectForKey:@"zweitezahl"];
	if (tempZweiteZahlNumber &&[AddSubBereichSet containsIndex:[tempZweiteZahlNumber intValue]])
	{
		tempSerieDaten.ASzweiteZahl=[tempZweiteZahlNumber intValue]+1;
	}
	else
	{
		tempSerieDaten.ASzweiteZahl=1;
	}
	
	//ZehnerU
	NSNumber* tempZehnerUNumber=[derSerieDatenDic objectForKey:@"zehneru"];
	if (tempZehnerUNumber &&[AddSubBereichSet containsIndex:[tempZehnerUNumber intValue]])
	{
		tempSerieDaten.ASZehnerU=[tempZehnerUNumber intValue]+1;
	}
	else
	{
		tempSerieDaten.ASZehnerU=1;
	}
	
	//ZehnerU
	NSNumber* tempHunderterUNumber=[derSerieDatenDic objectForKey:@"hunderteru"];
	if (tempHunderterUNumber &&[AddSubBereichSet containsIndex:[tempHunderterUNumber intValue]])
	{
		tempSerieDaten.ASHunderterU=[tempHunderterUNumber intValue]+1;
	}
	else
	{
		tempSerieDaten.ASHunderterU=1;
	}
	}//if AddSubEin
	else
	{
	tempSerieDaten.Addition=0;
	tempSerieDaten.Subtraktion=0;

	}
	
	return tempSerieDaten;
}

- (ProgPrefsRecord)SerieDatenVonSettings
{
	int SettingsOK=0;
	ProgPrefsRecord tempSerieDaten;
	tempSerieDaten.AnzahlAufgaben=[[AnzahlPopKnopf titleOfSelectedItem]intValue];
	
	tempSerieDaten.Zeit=[[ZeitPopKnopf titleOfSelectedItem]intValue];
	
	//Multiplikation
	NSDictionary* tempReihenSettingsDic=[ReihenSettings getSettings];
	//NSLog(@"neueSerie: SeriedatenDicVonSettings: %@",[tempReihenSettingsDic description]);
	
	NSNumber* tempMultNumber=[tempReihenSettingsDic objectForKey:@"multiplikation"];
	tempSerieDaten.Multiplikation=[tempMultNumber intValue];
	
	NSNumber* tempAnzahlReihenNumber=[tempReihenSettingsDic objectForKey:@"anzahlreihen"];
	tempSerieDaten.AnzahlReihen=[tempAnzahlReihenNumber intValue];
	
	NSArray* tempReihenArray=[tempReihenSettingsDic objectForKey:@"reihenarray"];
	if (tempReihenArray)
	{
		for (int i=0;i<kMaxAnzReihen;i++)
		{
			if (i<[tempReihenArray count])
			{
				tempSerieDaten.Reihenliste[i]=[[tempReihenArray objectAtIndex:i]intValue];
			}
			else
			{
				tempSerieDaten.Reihenliste[i]=0;
			}
		}//for i
		
	}
	
	//ZehnerReihen
	NSNumber* tempZehnerReihenNumber=[tempReihenSettingsDic objectForKey:@"zehnerreihen"];
	if (tempZehnerReihenNumber)
	{
		tempSerieDaten.MDZehnerReihen=[tempZehnerReihenNumber intValue];
	}
	else
	{
		tempSerieDaten.MDZehnerReihen=0;
	}
	
	//HunderterReihen
	NSNumber* tempHunderterReihenNumber=[tempReihenSettingsDic objectForKey:@"hunderterreihen"];
	if (tempHunderterReihenNumber)
	{
		tempSerieDaten.MDHunderterReihen=[tempHunderterReihenNumber intValue];
	}
	else
	{
		tempSerieDaten.MDHunderterReihen=0;
	}
	
	//Kleines1Mal1
	NSNumber* tempKleines1Mal1Number=[tempReihenSettingsDic objectForKey:@"kleines1mal1"];
	if (tempKleines1Mal1Number)
	{
		tempSerieDaten.MDKleines1Mal1=[tempKleines1Mal1Number intValue];
	}
	else
	{
		tempSerieDaten.MDKleines1Mal1=0;
	}
	
	//Grosses1Mal1
	NSNumber* tempGrosses1Mal1Number=[tempReihenSettingsDic objectForKey:@"grosses1mal1"];
	if (tempGrosses1Mal1Number)
	{
		tempSerieDaten.MDGrosses1Mal1=[tempGrosses1Mal1Number intValue];
	}
	else
	{
		tempSerieDaten.MDGrosses1Mal1=0;
	}
	tempSerieDaten.MultDivZehnerpotenz1=0;
	tempSerieDaten.MultDivZehnerpotenz2=0;
	tempSerieDaten.Division=0;
	tempSerieDaten.MultDivZehnerpotenz1=0;
	tempSerieDaten.MultDivZehnerpotenz2=0;
	tempSerieDaten.MultDivmitAdd=0;
	tempSerieDaten.MultDivmitSub=0;
	
	//Addition
	NSDictionary* tempASSettings=[AddSubSettings getSettings];
	//NSLog(@"SeriedatenVonSettings: %@",[tempASSettings description]);
	NSNumber* AddSubEin=[tempASSettings objectForKey:@"addsubein"];
	if (AddSubEin&&[AddSubEin intValue]==1)//AddSub ist eingeschaltet
	{
		NSNumber* tempAdditionNumber=[tempASSettings objectForKey:@"addition"];
		if (tempAdditionNumber)
		{
			tempSerieDaten.Addition=[tempAdditionNumber intValue];
		}
		else
		{
			tempSerieDaten.Addition=0;
		}
		
		//Subtraktion
		NSNumber* tempSubtraktionNumber=[tempASSettings objectForKey:@"subtraktion"];
		if (tempSubtraktionNumber)
		{
			tempSerieDaten.Subtraktion=[tempSubtraktionNumber intValue];
		}
		else
		{
			tempSerieDaten.Subtraktion=0;
		}
		
		//Bereich
		NSNumber* tempBereichNumber=[tempASSettings objectForKey:@"bereich"];
		if (tempBereichNumber)
		{
			tempSerieDaten.ASBereich=[tempBereichNumber intValue]+1;
		}
		else
		{
			tempSerieDaten.ASBereich=1;
		}
		
		//zweiteZahl
		NSNumber* tempZweiteZahlNumber=[tempASSettings objectForKey:@"zweitezahl"];
		if (tempZweiteZahlNumber)
		{
			tempSerieDaten.ASzweiteZahl=[tempZweiteZahlNumber intValue]+1;
		}
		else
		{
			tempSerieDaten.ASzweiteZahl=1;
		}
		
		//ZehnerU
		NSNumber* tempZehnerUNumber=[tempASSettings objectForKey:@"zehneru"];
		if (tempZehnerUNumber)
		{
			tempSerieDaten.ASZehnerU=[tempZehnerUNumber intValue]+1;
		}
		else
		{
			tempSerieDaten.ASZehnerU=1;
		}
		
		//ZehnerU
		NSNumber* tempHunderterUNumber=[tempASSettings objectForKey:@"hunderteru"];
		if (tempHunderterUNumber)
		{
			tempSerieDaten.ASHunderterU=[tempHunderterUNumber intValue]+1;
		}
		else
		{
			tempSerieDaten.ASHunderterU=1;
		}
	}
	else		
	{
		tempSerieDaten.Addition=0;
		tempSerieDaten.Subtraktion=0;
	}
	
	
	return tempSerieDaten;
}


- (NSDictionary*)SerieDatenDicVon:(ProgPrefsRecord)dieSerieDaten
{	
	NSMutableDictionary* tempDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.AnzahlAufgaben] forKey:@"anzahlaufgaben"];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.Zeit] forKey:@"zeit"];
	
	//Multiplikation
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.Multiplikation] forKey:@"multiplikation"];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.AnzahlReihen] forKey:@"anzahlreihen"];
	NSMutableArray* tempReihenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	for (int i=0;i<dieSerieDaten.AnzahlReihen;i++)
	{
	[tempReihenArray addObject:[NSNumber numberWithInt:SerieDaten.Reihenliste[i]]];
	}//for i
	[tempDic setObject:tempReihenArray forKey:@"reihenarray"];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.MDZehnerReihen] forKey:@"zehnerreihen"];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.MDHunderterReihen] forKey:@"hunderterreihen"];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.MDKleines1Mal1] forKey:@"kleines1mal1"];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.MDGrosses1Mal1] forKey:@"grosses1mal1"];

	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.Addition] forKey:@"addition"];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.Subtraktion] forKey:@"subtraktion"];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.ASBereich] forKey:@"bereich"];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.ASzweiteZahl] forKey:@"zweitezahl"];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.ASZehnerU] forKey:@"zehneru"];
	[tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.ASHunderterU] forKey:@"hunderteru"];


return tempDic;
}

- (NSDictionary*)SerieDatenDicVonScratch
{	
	NSMutableDictionary* tempDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[tempDic setObject:[NSNumber numberWithInt:12] forKey:@"anzahlaufgaben"];
	[tempDic setObject:[NSNumber numberWithInt:120] forKey:@"zeit"];
	
	//Multiplikation
	[tempDic setObject:[NSNumber numberWithInt:1] forKey:@"multiplikation"];
	[tempDic setObject:[NSNumber numberWithInt:8] forKey:@"anzahlreihen"];
	NSMutableArray* tempReihenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	for (int i=0;i<8;i++)
	{
	[tempReihenArray addObject:[NSNumber numberWithInt:i+2]];
	}//for i
	[tempDic setObject:tempReihenArray forKey:@"reihenarray"];
	[tempDic setObject:[NSNumber numberWithInt:0] forKey:@"zehnerreihen"];
	[tempDic setObject:[NSNumber numberWithInt:1] forKey:@"reihenein"];
	[tempDic setObject:[NSNumber numberWithInt:0] forKey:@"hunderterreihen"];
	[tempDic setObject:[NSNumber numberWithInt:1] forKey:@"kleines1mal1"];
	[tempDic setObject:[NSNumber numberWithInt:0] forKey:@"grosses1mal1"];
	
	[tempDic setObject:[NSNumber numberWithInt:0] forKey:@"addsubein"];
	[tempDic setObject:[NSNumber numberWithInt:0] forKey:@"addition"];
	[tempDic setObject:[NSNumber numberWithInt:0] forKey:@"subtraktion"];
	[tempDic setObject:[NSNumber numberWithInt:3] forKey:@"bereich"];
	[tempDic setObject:[NSNumber numberWithInt:0] forKey:@"zweitezahl"];
	[tempDic setObject:[NSNumber numberWithInt:1] forKey:@"zehneru"];
	[tempDic setObject:[NSNumber numberWithInt:0] forKey:@"hunderteru"];


return tempDic;
}

- (void)setSettingsMitDic:(NSDictionary*)derSettingDic
{
//Multiplikation
[ReihenSettings setSettingsMit:derSettingDic];
[AddSubSettings setSettingsMit:derSettingDic];
}


- (NSDictionary*)SerieDatenDicAusSettings
{	
	int multOK=[ReihenSettings checkSettings];
	int anzReihenOK=0;
	int addsubOK=[AddSubSettings checkSettings];
	int anzAddSubOK=0;
	
	//NSLog(@"SerieDatenDicAusSettings	multOK: %d		addsubOK: %d",multOK,addsubOK);
	NSMutableDictionary* tempDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[tempDic setObject:[NSNumber numberWithInt:[[AnzahlPopKnopf titleOfSelectedItem]intValue]] forKey:@"anzahlaufgaben"];
//	NSLog(@"SerieDatenDicAusSettings	1");
	[tempDic setObject:[NSNumber numberWithInt:[[ZeitPopKnopf titleOfSelectedItem]intValue]] forKey:@"zeit"];
//	NSLog(@"SerieDatenDicAusSettings	2");
	//Multiplikation
	NSDictionary* tempReihenSettingsDic=[ReihenSettings getSettings];
	//NSLog(@"SerieDatenDicAusSettings: tempReihenSettingsDic: %@",[tempReihenSettingsDic description]);
	NSNumber* tempReihenEinNumber=[tempReihenSettingsDic objectForKey:@"reihenein"];
	if (tempReihenEinNumber)
	{
	[tempDic setObject:tempReihenEinNumber forKey:@"reihenein"];
	multOK++;
	}
//	NSLog(@"SerieDatenDicAusSettings	3");
	NSNumber* tempMultNumber=[tempReihenSettingsDic objectForKey:@"multiplikation"];
	if (tempMultNumber)
	{
	[tempDic setObject:tempMultNumber forKey:@"multiplikation"];

	}
//NSLog(@"SerieDatenDicAusSettings	4");
	NSNumber* tempAnzahlReihenNumber=[tempReihenSettingsDic objectForKey:@"anzahlreihen"];
	if (tempAnzahlReihenNumber)
	{
	[tempDic setObject:tempAnzahlReihenNumber forKey:@"anzahlreihen"];
	anzReihenOK=[tempAnzahlReihenNumber intValue];//Anzahl Reihen dazuzählen
	}
//NSLog(@"SerieDatenDicAusSettings	5");
	NSArray* tempReihenArray=[tempReihenSettingsDic objectForKey:@"reihenarray"];
		if (tempReihenArray)
	{
	[tempDic setObject:tempReihenArray forKey:@"reihenarray"];

	}

	NSNumber* tempZehnerReihenNumber=[tempReihenSettingsDic objectForKey:@"zehnerreihen"];
	if (tempZehnerReihenNumber)
	{
	[tempDic setObject:tempZehnerReihenNumber forKey:@"zehnerreihen"];
	}

	NSNumber* tempHunderterReihenNumber=[tempReihenSettingsDic objectForKey:@"hunderterreihen"];
	if (tempHunderterReihenNumber)
	{
	[tempDic setObject:tempHunderterReihenNumber forKey:@"hunderterreihen"];
	}

	NSNumber* tempKleines1Mal1Number=[tempReihenSettingsDic objectForKey:@"kleines1mal1"];
	if (tempKleines1Mal1Number)
	{
	[tempDic setObject:tempKleines1Mal1Number forKey:@"kleines1mal1"];
	}

	NSNumber* tempGrosses1Mal1Number=[tempReihenSettingsDic objectForKey:@"grosses1mal1"];
	if (tempGrosses1Mal1Number)
	{
	[tempDic setObject:tempGrosses1Mal1Number forKey:@"grosses1mal1"];
	}

//NSLog(@"SerieDatenDicAusSettings	6");
	//Addition
	NSDictionary* tempASSettings=[AddSubSettings getSettings];
	//NSLog(@"SerieDatenDicAusSettings: tempASSettings: %@",[tempASSettings description]);
	NSNumber* tempAddSubEinNumber=[tempASSettings objectForKey:@"addsubein"];
	if (tempAddSubEinNumber)//AddSubEin ist vorhanden
	{
	[tempDic setObject:tempAddSubEinNumber forKey:@"addsubein"];
	addsubOK=[tempAddSubEinNumber intValue];
	}
	
	NSNumber* tempAdditionNumber=[tempASSettings objectForKey:@"addition"];
	if (tempAdditionNumber)
	{
	[tempDic setObject:tempAdditionNumber forKey:@"addition"];
	anzAddSubOK+=[tempAdditionNumber intValue];
	}
	
	NSNumber* tempSubtraktionNumber=[tempASSettings objectForKey:@"subtraktion"];
	if (tempSubtraktionNumber)
	{
	[tempDic setObject:tempSubtraktionNumber forKey:@"subtraktion"];
	anzAddSubOK+=[tempSubtraktionNumber intValue];
	}


	NSNumber* tempBereichNumber=[tempASSettings objectForKey:@"bereich"];
	if (tempBereichNumber)
	{
	[tempDic setObject:tempBereichNumber forKey:@"bereich"];
	}

	NSNumber* tempZweiteZahlNumber=[tempASSettings objectForKey:@"zweitezahl"];
	if (tempZweiteZahlNumber)
	{
	[tempDic setObject:tempZweiteZahlNumber forKey:@"zweitezahl"];
	}
	
	NSNumber* tempZehnerUNumber=[tempASSettings objectForKey:@"zehneru"];
	if (tempZehnerUNumber)
	{
	[tempDic setObject:tempZehnerUNumber forKey:@"zehneru"];
	}

	NSNumber* tempHunderterUNumber=[tempASSettings objectForKey:@"hunderteru"];
	if (tempHunderterUNumber)
	{
	[tempDic setObject:tempHunderterUNumber forKey:@"hunderteru"];
	}

//NSLog(@"SerieDatenDicAusSettings end: %@",[tempDic description]);
return tempDic;
}

- (void)setOK:(BOOL)derStatus
{
return;
[NamenPopKnopf setEnabled:derStatus];
[ZeitPopKnopf setEnabled:derStatus];
[AnzahlPopKnopf setEnabled:derStatus];
[OKTaste setEnabled:derStatus];
[StartTaste setEnabled:derStatus];
//[SettingsPfeil setEnabled:derStatus];
[TestPopKnopf setEnabled:(derStatus==1)];
}

- (IBAction)nextAufgabeAb:(id)sender
{
	//[self markReset];
	[self closeSessionDrawer:NULL];
	NSLog(@"nextAufgabeAb: Modus: %d",Modus);
	if (([NamenPopKnopf indexOfSelectedItem]==0)&&(Modus==kTestModus))
	{
		[ErgebnisseTaste setEnabled:NO];
		NSAlert* Warnung=[[NSAlert alloc]init];
		//NSString* t=NSLocalizedString(@"You Are here as a guest",@"Du bist als Gast hier");
		NSString* t=NSLocalizedString(@"Who are You?",@"Wer bist du?");
		//NSString* i1=NSLocalizedString(@"How do you want to continue?",@"Wie willst du weiterfahren?");
		NSString* i1=NSLocalizedString(@"You have to choose a name to continue",@"Du musst einen Namen wählen, um weiterzufahren");
		//NSString* b1=NSLocalizedString(@"Cancel",@"Abbrechen");
		NSString* b2=NSLocalizedString(@"Choose A Name",@"Einen Namen wählen");
		//[Warnung addButtonWithTitle:b1];
		[Warnung addButtonWithTitle:b2];
		[Warnung setMessageText:t];
		[Warnung setInformativeText:i1];
		
		int modalAntwort=[Warnung runModal];
		switch (modalAntwort)
		{
			case NSAlertFirstButtonReturn://Namen wählen
			{
				Status=0;
				return;				
			}break;
			case NSAlertSecondButtonReturn://Namen wählen
			{
				return;
			}break;
				
				
		}//switch

	}
	[self stopTimeout];
	OK=NO;
	//[self setOK:NO];
	[ErgebnisRahmenFeld setHidden:YES];
	[ErgebnisView setMark:0];
	//[StartTaste setEnabled:NO];
	BOOL AufgabeOK=YES;
	//[ErgebnisFeld setStringValue:@""];
	[ErgebnisView setString:@""];
	
	//NSLog(@"\n									NextAufgabeAb: Titel: %@ aktuelleAufgabenNummer: %d\n",[sender title],aktuelleAufgabenNummer);
	//NSLog(@"Loc: %@",NSLocalizedString(@"End",@"Fertig"));

	if ((aktuelleAufgabenNummer==1)&&[NamenPopKnopf indexOfSelectedItem])
	{
		[self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];//VOLUME SICHERN
	}
	
	if (aktuelleAufgabenNummer>AnzahlAufgaben)
	{
		//[sender setTitle:NSLocalizedString(@"End",@"Fertig")];
		//NSLog(@"nextAufgabeAb: aktuelleAufgabenNummer==AnzahlAufgaben");
	}
	
	else
	{
		[NamenPopKnopf setEnabled: NO];
		[TestPopKnopf setEnabled: NO];
		[neueSerieTaste setEnabled: (Modus==kTrainingModus)];//nur im Testmodus abschalten
		[ModusOption setEnabled: (Modus==kTrainingModus)];
		[ErgebnisseTaste setEnabled: NO];
		[ToggleSessionKnopf setEnabled: NO];
		//NSLog(@"nextAufgabeAb: AufgabenArray count: %d nummer: %d",[AufgabenArray count],aktuelleAufgabenNummer);
		//NSLog(@"nextAufgabeAb: AufgabenArray : %@ ",[AufgabenArray description]);
	
		NSDictionary* tempAufgabenDic=[AufgabenArray objectAtIndex:aktuelleAufgabenNummer-1];
		if(tempAufgabenDic)
		{
			//NSLog(@"tempAufgabenDic: %@",[tempAufgabenDic description]);
			//[Aufgabenzeiger setAnzahl:aktuelleAufgabenNummer];
			[[self window]makeFirstResponder:self];
			AufgabeOK=[Speaker AufgabeAb:tempAufgabenDic];
			
		}
	}
	//aktuelleAufgabenNummer++;
	verify=YES;
	
	TimerValid=YES;
	
	
	[[self window]makeFirstResponder:ErgebnisView];
	[ErgebnisView setEditable:YES];
	[ErgebnisView setSelectable:YES];
	[ErgebnisView selectAll:NULL];
	[ErgebnisView setReady:YES];

}

- (void)FalschesZeichenAktion:(NSNotification*)note
{
	NSLog(@"FalschesZeichenAktion: note: %@",[[note userInfo]description]);
	NSString* FalschesZeichenString=(NSString*)[[note userInfo]objectForKey:@"falscheszeichen"];
	if (FalschesZeichenString)
	{
	NSLog(@"FalschesZeichenString: %@",FalschesZeichenString);
	}
	NSMutableDictionary* tempQuittungDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		
	//Richtig
	[tempQuittungDic setObject:[NSNumber numberWithInt:kFalschesZeichen]
							forKey:@"quittung"];
	BOOL QuittungOK=[Speaker QuittungAb:tempQuittungDic];	

}

- (void)AufgabeFertigAktion:(NSNotification*)note
{
	[ErgebnisRahmenFeld setHidden:YES];
	//NSLog(@"AufgabeFertigAktion: note: %@",[[note userInfo]description]);
	//NSLog(@"AufgabeBereitAktion: note: %@",[[note userInfo]description]);
	NSNumber* AufgabenStatusNumber=(NSNumber*)[[note userInfo]objectForKey:@"fertig"];
	int status=(int)[AufgabenStatusNumber intValue];
	
//	[[self window]makeFirstResponder:ErgebnisView];
//	[ErgebnisView setEditable:YES];
//	[ErgebnisView setSelectable:YES];
//	[ErgebnisView selectAll:NULL];

	
	//verify=YES;
	if ([AblaufzeitTimer isValid])
	{
	//NSLog(@"AufgabeFertigAktion AblaufzeitTimer invalidate");
	[AblaufzeitTimer invalidate];
	}
	AblaufzeitTimer=[[NSTimer scheduledTimerWithTimeInterval:0.1 
													  target:self 
													selector:@selector(AblaufzeitTimerFunktion:) 
													userInfo:nil 
													 repeats:YES]retain];
	//NSLog(@"AufgabeFertigAktion AblaufzeitTimer gestartet");
	TimerValid=YES;
	OK=YES;
	[self setOK:YES];
	
	[StartTaste setTitle:NSLocalizedString(@"Repeat",@"Wiederholen")];

}



- (NSDictionary*)SerieErgebnisDic
{
	NSMutableDictionary* tempDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[tempDic setObject:[NSDate date] forKey:@"datum"];
	[tempDic setObject:[TestPopKnopf  titleOfSelectedItem]forKey:@"testname"];
	[tempDic setObject:[NSNumber numberWithInt:abgelaufeneZeit/10] forKey:@"abgelaufenezeit"];
	[tempDic setObject:[NSNumber numberWithInt:AnzahlAufgaben] forKey:@"anzahlaufgaben"];
	[tempDic setObject:[NSNumber numberWithInt:MaximalZeit] forKey:@"maximalzeit"];
	[tempDic setObject:[NSNumber numberWithInt:anzFehler] forKey:@"anzfehler"];
	[tempDic setObject:[NSNumber numberWithInt:anzRichtig] forKey:@"anzrichtig"];
	[tempDic setObject:[NSNumber numberWithInt:Modus] forKey:@"modus"];

	return tempDic;
}

- (void)AblaufzeitTimerFunktion:(NSTimer*)derTimer
{
	if (TimerValid)
	{
		abgelaufeneZeit+=1;
		teilZeit++;
		[Zeitanzeige setZehntelZeit:abgelaufeneZeit];
		//NSLog(@"Timer: %d valid: %d",abgelaufeneZeit,[derTimer isValid]);
		//if (abgelaufeneZeit%10==0)
		if (teilZeit==10)
		{	
			teilZeit=0;
			//NSLog(@"Timer Zehntel: %d valid: %d",abgelaufeneZeit,[derTimer isValid]);
			
			[ZeitFeld setIntValue:abgelaufeneZeit/10];
		}
		if (abgelaufeneZeit/10==MaximalZeit)
		{
			//[AblaufzeitTimer invalidate];
			[derTimer invalidate];
			[self FertigSoundAb];
			NSDictionary* ErgebnisDic=[self SerieErgebnisDic];
			[self SerieFertig:ErgebnisDic];
		}
	}
	else
	{
		[derTimer invalidate];
	}
}

- (int)SerieFertig:(NSDictionary*) derErgebnisDic
{
[AblaufzeitTimer invalidate];

int antwort=1;
[ErgebnisView setEditable:NO];
[[self window]makeFirstResponder:StartTaste];
[StartTaste setKeyEquivalent:@"\r"];
//NSLog(@"SerieFertig: Ergebnis: %@",[derErgebnisDic description]);
if ([AblaufzeitTimer isValid])
	{
	//NSLog(@"AufgabeFertigAktion AblaufzeitTimer invalidate");
	[AblaufzeitTimer invalidate];
	}

[self showDiplomFensterMitErgebnis:derErgebnisDic];

return antwort;
}

- (void)saveErgebnisVon:(NSString*)derBenutzer mitErgebnis:(NSDictionary*) derErgebnisDic
{
	BOOL OK=[Utils setDatenDic:derErgebnisDic forUser:derBenutzer anPfad:SndCalcPfad];
//	NSMutableArray* tempNamenArray=(NSMutableArray*)[[PListDic objectForKey:@"namendicarray"]valueForKey:@"name"];

	NSMutableArray* tempNamenArray=(NSMutableArray*)[[Utils NamenDicArrayAnPfad:SndCalcPfad]valueForKey:@"name"];
	
	
	int namenIndex=-1;
		if (tempNamenArray && [tempNamenArray count])//Es hat Namendics
		{
//			NSMutableArray* tempNamenDicArray=(NSMutableArray*)[PListDic objectForKey:@"namendicarray"];

			NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
			
			namenIndex=[tempNamenArray indexOfObject:derBenutzer];
			if (namenIndex<NSNotFound)//Name ist vorhanden
			{
				NSMutableArray* tempErgebnisDicArray=(NSMutableArray*)[[tempNamenDicArray objectAtIndex:namenIndex]objectForKey:@"ergebnisdicarray"];
				//NSLog(@"saveErgebnisVon: tempErgebnisDicArray: %@",[tempErgebnisDicArray description]);
				if (tempErgebnisDicArray&&[tempErgebnisDicArray count]) //tempErgebnisDicArray schon vorhanden
				{
					NSLog(@"tempErgebnisDicArray schon vorhanden");
					[tempErgebnisDicArray addObject:[derErgebnisDic copy]];
					NSLog(@"nach tempErgebnisDicArray addObject");
				}
				else //tempErgebnisDicArray anlegen
				{
					NSLog(@"saveErgebnis: tempErgebnisDicArray anlegen");

					NSMutableArray*tempneuerErgebnisDicArray=[NSMutableArray arrayWithObject:[derErgebnisDic copy]];
					[[tempNamenDicArray objectAtIndex:namenIndex]setObject:tempneuerErgebnisDicArray forKey:@"ergebnisdicarray"];
				
				}
				
			}
			else //Namendic anlegen
			{
				NSLog(@"Namendic anlegen");
				NSMutableArray*tempneuerErgebnisDicArray=[NSMutableArray arrayWithObject:[derErgebnisDic copy]];
				NSMutableDictionary* tempNamenDic=[NSMutableDictionary dictionaryWithObject:tempneuerErgebnisDicArray forKey:@"ergebnisdicarray"];
				[tempNamenDic setObject:[NamenPopKnopf titleOfSelectedItem] forKey:@"name"];
				[tempNamenDicArray addObject:[tempNamenDic copy]];
				NSLog(@"tempNamenDic: %@",[tempNamenDic description]);
			}
		//NSLog(@"tempNamenDicArray: %@",[tempNamenDicArray description]);
		}
		

	}


- (void)showDiplomFensterMitErgebnis:(NSDictionary*) derErgebnisDic
{
[self stopTimeout];
	if (!DiplomFenster)
	{
		//NSLog(@"init Diplom");
		DiplomFenster=[[rDiplomFenster alloc]init];
	}
	NSMutableDictionary* tempErgebnisDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	tempErgebnisDic=[derErgebnisDic mutableCopy];
	NSModalSession PasswortSession=[NSApp beginModalSessionForWindow:[DiplomFenster window]];
	
	[DiplomFenster setDiplomMit:derErgebnisDic];

	//BOOL TastenStatus=((Status==kBenutzer)&&(Modus=kTestModus));//
	BOOL TastenStatus=(([NamenPopKnopf indexOfSelectedItem])&&(Modus=kTestModus));//
	NSLog(@"Status: %d index: %d TastenStatus: %d",Status, [TestPopKnopf indexOfSelectedItem],TastenStatus);
	[DiplomFenster setTastenStatus:TastenStatus];
	//Tasten zum Sichern der Ergebnisse nur im Testmodus und Benutzerstatus zeigen
	int modalAntwort = [NSApp runModalForWindow:[DiplomFenster window]];
	//[DiplomFenster setDiplomMit:derErgebnisDic];
	[NSApp endModalSession:PasswortSession];
	
	//NSLog(@"showDiplomFensterMitErgebnis nach endModalSession	: Antwort: %d	Status: %d",modalAntwort,Status);
	
	if ([NamenPopKnopf indexOfSelectedItem]&&[DiplomFenster TestSichernOK])//nicht Gast
	{
		NSMutableDictionary* tempDatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		
		NSMutableDictionary* returnDatenDic=(NSMutableDictionary*)[[Utils DatenDicForUser:[NamenPopKnopf titleOfSelectedItem] anPfad:SndCalcPfad]objectForKey:@"userplist"];
		
		//NSLog(@"returnDatenDic nature: %@\n\n",[returnDatenDic description]);
		if (!returnDatenDic)
		{
			returnDatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		}
		
		if (![returnDatenDic objectForKey:@"name"])
		{
			[returnDatenDic setObject:[NamenPopKnopf titleOfSelectedItem] forKey:@"name"];
		}
		
		[returnDatenDic setObject:[TestPopKnopf titleOfSelectedItem]forKey:@"lasttest"];
		
		if (![returnDatenDic objectForKey:@"ergebnisdicarray"])
		{
			NSLog(@"returnDatenDic ohne ergebnisdicarray: %@",[returnDatenDic description]);
			
			NSMutableArray* tempErgebnisDicArray=[[NSMutableArray alloc]initWithCapacity:0];
			[tempErgebnisDicArray addObject:derErgebnisDic];
			[returnDatenDic setObject:tempErgebnisDicArray forKey:@"ergebnisdicarray"];
		}
		else
		{
			//NSLog(@"returnDatenDic ohne ergebnisdicarray vor add: %@",[returnDatenDic description]);
			[[returnDatenDic objectForKey:@"ergebnisdicarray"]addObject:derErgebnisDic];
			//NSLog(@"returnDatenDic nach add: %@",[returnDatenDic description]);
			
		}
		
		[returnDatenDic setObject:[NSNumber numberWithFloat:[VolumeSchieber floatValue]] forKey:@"lastvolume"];
		[returnDatenDic setObject:[NSNumber numberWithBool:YES] forKey:@"aktiv"];
		
		//NSLog(@"returnDatenDic vor set: %@",[returnDatenDic description]);
		
		BOOL OK=[Utils setDatenDic:returnDatenDic forUser:[NamenPopKnopf titleOfSelectedItem] anPfad:SndCalcPfad];
		
		
		
		[tempErgebnisDic setObject:[NSNumber numberWithBool:YES] forKey:@"neu"];
		//	NSMutableArray* tempNamenArray=(NSMutableArray*)[[PListDic objectForKey:@"namendicarray"]valueForKey:@"name"];
		
		NSMutableArray* tempNamenArray=(NSMutableArray*)[[Utils NamenDicArrayAnPfad:SndCalcPfad]valueForKey:@"name"];
		
		
		int namenIndex=-1;
		if (tempNamenArray && [tempNamenArray count])//Es hat Namendics
		{
			//			NSMutableArray* tempNamenDicArray=(NSMutableArray*)[PListDic objectForKey:@"namendicarray"];
			NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
			
			namenIndex=[tempNamenArray indexOfObject:[NamenPopKnopf titleOfSelectedItem]];
			if (namenIndex<NSNotFound)//Name ist vorhanden
			{
				NSMutableArray* tempErgebnisDicArray=(NSMutableArray*)[[tempNamenDicArray objectAtIndex:namenIndex]objectForKey:@"ergebnisdicarray"];
				//			[tempErgebnisDicArray setObject:[NSNumber numberWithBool:yes] forKey:@"neu"];
				//NSLog(@"tempErgebnisDicArray: %@",[tempErgebnisDicArray description]);
				if (tempErgebnisDicArray&&[tempErgebnisDicArray count]) //tempErgebnisDicArray schon vorhanden
				{
					//NSLog(@"showDiplomfensterMitErgebnis tempErgebnisDicArray schon vorhanden");
					
					//[tempErgebnisDicArray addObject:[derErgebnisDic copy]];
					
					[tempErgebnisDicArray addObject:tempErgebnisDic];
					
					//	[[[tempNamenDicArray objectAtIndex:namenIndex]objectForKey:@"ergebnisdicarray"]addObject:[derErgebnisDic copy]];
					
					
					//NSLog(@"nach tempErgebnisDicArray addObject");
				}
				else //tempErgebnisDicArray anlegen
				{
					//NSLog(@"tempErgebnisDicArray anlegen");
					
					NSMutableArray* tempneuerErgebnisDicArray=[NSMutableArray arrayWithObject:tempErgebnisDic];
					[[tempNamenDicArray objectAtIndex:namenIndex]setObject:tempneuerErgebnisDicArray forKey:@"ergebnisdicarray"];
					
				}
				
			}
			else //Namendic anlegen
			{
				NSLog(@"Namendic anlegen");
				NSMutableArray*tempneuerErgebnisDicArray=[NSMutableArray arrayWithObject:tempErgebnisDic];
				NSMutableDictionary* tempNamenDic=[NSMutableDictionary dictionaryWithObject:tempneuerErgebnisDicArray forKey:@"ergebnisdicarray"];
				[tempNamenDic setObject:[NamenPopKnopf titleOfSelectedItem] forKey:@"name"];
				[tempNamenDicArray addObject:[tempNamenDic copy]];
				//NSLog(@"tempNamenDic: %@",[tempNamenDic description]);
			}
			//NSLog(@"tempNamenDicArray: %@",[tempNamenDicArray description]);
		}
		
		if([NamenPopKnopf indexOfSelectedItem])
		{
		[self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
		[self SessionDatumSichernVon:[NamenPopKnopf titleOfSelectedItem]];
		}
		NSImage* SessionYESImg=[NSImage imageNamed:@"MarkOnImg.tif"];
		//[[NamenPopKnopf selectedItem]setImage:SessionYESImg];

	}//if ! Gast
	
	
		[NamenPopKnopf setEnabled: YES];
		[TestPopKnopf setEnabled: NO];
		[neueSerieTaste setEnabled: YES];
		[ModusOption setEnabled: YES];
		[ErgebnisseTaste setEnabled: [NamenPopKnopf indexOfSelectedItem]];
		[ToggleSessionKnopf setEnabled: [NamenPopKnopf indexOfSelectedItem]];
	
	switch (modalAntwort)
	{
		case 0://Aufhören
		{
			NSLog(@"showDiplomFensterMitErg: Aufhoeren");
			[NamenPopKnopf selectItemAtIndex:0];
			[ErgebnisseTaste setEnabled:NO];
			[self neueSerie:NULL];

			//[self BeendenAktion:NULL];
		}break;
		case 1://Weiterfahren
		{
			NSLog(@"showDiplomFensterMitErg: Weiterfahren");
			[self neueSerie:NULL];
			//[self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
		}break;
				
		case 2://Ergebnisse anschauen
		{
		NSLog(@"\nshowDiplomFensterMitErg: Ergebnisse anschauen\n");
			if ([NamenPopKnopf indexOfSelectedItem])
			{
				float StatistikTimeout=15.0;
				NSString* tempName=[NamenPopKnopf titleOfSelectedItem];
				NSDictionary* tempDic=[Utils DatenDicForUser:tempName anPfad:SndCalcPfad];
				NSMutableDictionary* tempErgebnisDic=[NSMutableDictionary dictionaryWithDictionary:[tempDic objectForKey:@"userplist"]];
				//NSLog(@"showStatistikAktion modus 0	tempErgebnisDic: %@",[tempErgebnisDic description]);
				//NSLog(@"showStatistikAktion 	diplomdic: %@",[[[note userInfo] objectForKey:@"diplomdic"] description]);
				
					if ([tempErgebnisDic objectForKey:@"ergebnisdicarray"])//ErgebnisDicArray da
					{
						//[[tempErgebnisDic objectForKey:@"ergebnisdicarray"]addObject:derErgebnisDic];
					}
					else
					{
					[tempErgebnisDic setObject:[NSArray arrayWithObjects:derErgebnisDic,nil] forKey:@"ergebnisdicarray"];
					}
			
					[tempErgebnisDic setObject:[NSNumber numberWithFloat:StatistikTimeout]forKey:@"timeout"];
					[tempErgebnisDic setObject:[NSNumber numberWithInt:1]forKey:@"ausdiplom"];

				//NSLog(@"tempErgebnisDic nach: %@",[tempErgebnisDic description]);
			[self showStatistikFor:tempName mitDic:tempErgebnisDic];
			}//if not gast
		}break;
		
		case NSRunAbortedResponse: //-1001: Abbruch durch Timer 
		{
			NSLog(@"\nshowDiplomFensterMitErg: Abbruch durch Timer\n");
//			[self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
//			[self SessionDatumSichernVon:[NamenPopKnopf titleOfSelectedItem]];
			[NamenPopKnopf selectItemAtIndex:0];
			[ErgebnisseTaste setEnabled:NO];
			[self neueSerie:NULL];

		}
	}//switch

[NamenPopKnopf setEnabled:YES];
	
}


- (void)OKTastenAktion:(id)sender
{
	
	[OKTaste setEnabled:NO];
	NSLog(@"OKTastenAktion");
	[ErgebnisView setSelectable:NO];
	[ErgebnisView setEditable:NO];
	//[ErgebnisFeld display];
	NSLog(@"OKTastenAktion: verify: %d",verify);
	if (verify)
	{
		BOOL OK=[self checkAufgabe];
		//[StartTaste setEnabled:YES];
		[StartTaste setKeyEquivalent:@"\r"];
		//[[self window]makeFirstResponder:StartTaste];
		[[self window]makeFirstResponder:[self window]];
		verify=NO;
	}
}

- (void)ErgebnisFertigAktion:(NSNotification*)note
{
	//NSLog(@"ErgebnisFertigAktion: note: %@ verify: %d: ",[[note userInfo]description],verify);
	NSNumber* KeyCodeNumber=[[note userInfo]objectForKey:@"key"];
	int TastenCode=(int)[KeyCodeNumber intValue];
	//NSLog(@"ErgebnisFertigAktion: note: %@ verify: %d: TastenCode: %d",[[note userInfo]description],verify,TastenCode);
	
	if (TastenCode==36 &&verify)
	{
		//NSLog(@"AblaufzeitTimer invalidate: Timer valid: %d",[AblaufzeitTimer isValid]);
		[AblaufzeitTimer invalidate];
		//NSLog(@"AblaufzeitTimer nach invalidate: Timer valid: %d",[AblaufzeitTimer isValid]);

		[OKTaste setEnabled:NO];
		TimerValid=NO;
		BOOL OK=[self checkAufgabe];
		//verify=NO;
	}
}

- (void)textDidChange:(NSNotification *)aNotification

{
//- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
//NSLog(@"ErgebnisView: textDidChange");
[OKTaste setEnabled:YES];

}

- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
{
NSLog(@"controlTextDidBeginEditing: %@",[[aNotification object]stringValue]);


}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
NSLog(@"controlTextDidEndEditing verify: %d",verify);
[AblaufzeitTimer invalidate];
/*

[ErgebnisFeld setSelectable:NO];
[ErgebnisFeld setEditable:NO];
[ErgebnisFeld display];
if (verify)
{
BOOL OK=[self checkAufgabe];

//[StartTaste setEnabled:YES];
[StartTaste setKeyEquivalent:@"\r"];
//[[self window]makeFirstResponder:StartTaste];
}
*/
}

- (void)nextAufgabeAbTimerFunktion:(NSTimer*)TestTimer
{
//NSLog(@"nextAufgabeAbTimerFunktion");
[TestTimer invalidate];

[self nextAufgabeAb:NULL];
}

- (BOOL)checkAufgabe
{
	//NSLog(@"checkAufgabe Nummer: %d",aktuelleAufgabenNummer);
	BOOL checkOK=NO;
	NSDictionary* tempAufgabenDic=[AufgabenArray objectAtIndex:aktuelleAufgabenNummer-1];
	if (verify&&tempAufgabenDic)
	{
	NSNumber* sollNumber=[tempAufgabenDic objectForKey:@"var2"];
		
		if (sollNumber)
		{
			int soll=[sollNumber intValue];
			int ist=[[ErgebnisView string]intValue];
			//NSLog(@"checkAufgabe: soll: %d  ist: %d",soll,ist);
			if (soll==ist)
			{
				//NSLog(@"checkAufgabe: mark richtig: Nummer: %d",aktuelleAufgabenNummer);
				checkOK=YES;
				[Aufgabenzeiger setAnzahl:aktuelleAufgabenNummer];
				anzRichtig++;
				
				//[StartTaste setTitle:NSLocalizedString(@"Next",@"Weiter")];
				
				if (aktuelleAufgabenNummer==AnzahlAufgaben)//Serie ist fertig
				{
					[self FertigSoundAb];
					[StartTaste setTitle:NSLocalizedString(@"End",@"Fertig")];
					[StartTaste setKeyEquivalent:@""];
					[[self window]makeFirstResponder:[self window]];
					[AblaufzeitTimer invalidate];
					
					NSDictionary* ErgebnisDic=[self SerieErgebnisDic];
					[self SerieFertig:ErgebnisDic];

				}
				else
				{
				[self RichtigSoundAb];
					//[Speaker setQuittungTrackVon:2001 mitOffset:0];
				[AufgabenNummerFeld setIntValue:aktuelleAufgabenNummer+1];
				aktuelleAufgabenNummer++;
				[ErgebnisRahmenFeld setMark:1];
				[ErgebnisRahmenFeld setHidden:NO];
				//NSLog(@"checkAufgabe: valid: %d",[AblaufzeitTimer isValid]);
				
					switch (Modus)
					{
						case kTrainingModus:
						{
							[StartTaste setTitle:NSLocalizedString(@"Next",@"Weiter")];
							[StartTaste setKeyEquivalent:@"\r"];
							[[self window]makeFirstResponder:StartTaste];
							verify=NO;
						}break;
						case kTestModus:
						{
							[StartTaste setTitle:NSLocalizedString(@"Next",@"Weiter")];
	//						[StartTaste setEnabled:NO];
							[OKTaste setEnabled:NO];
							NSTimer* DelayTimer=[[NSTimer scheduledTimerWithTimeInterval:0.5 
												  target:self 
												selector:@selector(nextAufgabeAbTimerFunktion:) 
												userInfo:nil 
												 repeats:NO]retain];

							//in TestTimerFunktion:
//							[self nextAufgabeAb:NULL];


							verify=YES;

						}break;
							
					}//modus
					
				}
				
			}
			else
			{
				[self FalschSoundAb];
				[ErgebnisRahmenFeld setMark:2];
				[ErgebnisRahmenFeld setHidden:NO];
				//
				[StartTaste setTitle:NSLocalizedString(@"Again",@"Nochmals")];
				anzFehler++;
				switch (Modus)
					{
						case kTrainingModus:
						{
							[StartTaste setEnabled:YES];
							[StartTaste setKeyEquivalent:@"\r"];
							[[self window]makeFirstResponder:StartTaste];
							verify=NO;
						}break;
						case kTestModus:
						{
							[StartTaste setEnabled:YES];
							[OKTaste setEnabled:NO];
							NSTimer* DelayTimer=[[NSTimer scheduledTimerWithTimeInterval:0.5 
												  target:self 
												selector:@selector(nextAufgabeAbTimerFunktion:) 
												userInfo:nil 
												 repeats:NO]retain];

							//in TestTimerFunktion:
//							[self nextAufgabeAb:NULL];
							verify=YES;

						}break;
							
					}//modus

				
				
				
				//
//				[StartTaste setEnabled:YES];
//				[StartTaste setKeyEquivalent:@"\r"];
//				[[self window]makeFirstResponder:StartTaste];
//				anzFehler++;
//				[StartTaste setTitle:NSLocalizedString(@"Again",@"Nochmals")];
			}
			//
			
		}
		
		
	}//if tempAufgabenDic
	
	 return checkOK;
}


- (void)RichtigSoundAb
{
	NSMutableDictionary* tempQuittungDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		
	//Richtig
	[tempQuittungDic setObject:[NSNumber numberWithInt:kAufgabeRichtig]
							forKey:@"quittung"];
	BOOL QuittungOK=[Speaker QuittungAb:tempQuittungDic];	

/*
	NSSound* RichtigSnd=[NSSound soundNamed:@"Richtig"];
	if (RichtigSnd)
	{
		[RichtigSnd play];
	}
*/
}

- (void)FalschSoundAb
{
	NSMutableDictionary* tempQuittungDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[tempQuittungDic setObject:[NSNumber numberWithInt:kAufgabeFalsch]
							forKey:@"quittung"];
	BOOL QuittungOK=[Speaker QuittungAb:tempQuittungDic];	

/*
	NSSound* FalschSnd=[NSSound soundNamed:@"Falsch"];
	if (FalschSnd)
	{
		[FalschSnd play];
	}
*/
}


- (void)FertigSoundAb
{
	NSMutableDictionary* tempQuittungDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[tempQuittungDic setObject:[NSNumber numberWithInt:kSerieFertig]
							forKey:@"quittung"];
	BOOL QuittungOK=[Speaker QuittungAb:tempQuittungDic];	
 /*
	NSSound* FertigSnd=[NSSound soundNamed:@"Fertig"];
	if (FertigSnd)
	{
		[FertigSnd play];
	}
*/
}



- (void)markRichtig
{
	//[ErgebnisRahmenFeld setHidden:NO];
	NSLog(@"markRichtig");
	[ErgebnisRahmenFeld lockFocus];
	[[NSColor greenColor]set];
	NSRect r=[ErgebnisRahmenFeld bounds];
	r.origin.x+=2;
	r.origin.y+=2;
	r.size.width-=4;
	r.size.height-=4;
	NSBezierPath* RahmenPath=[NSBezierPath bezierPathWithRect:r];
	[RahmenPath setLineWidth:3.0];
	[RahmenPath stroke];
	[ErgebnisRahmenFeld unlockFocus];
//[ErgebnisFeld setBackgroundColor:[NSColor greenColor]];
//[ErgebnisFeld setTextColor:[NSColor whiteColor]];
}

- (void)markFalsch
{
NSLog(@"markFalsch");
	[[RechnungsBox contentView]lockFocus];
	//[ErgebnisView lockFocus];
	[[NSColor redColor]set];
	NSBezierPath* RahmenPath=[NSBezierPath bezierPathWithRect:[ErgebnisRahmenFeld frame]];
	[RahmenPath setLineWidth:3.0];
	[RahmenPath stroke];
	NSBezierPath* KreuzPath=[NSBezierPath bezierPath];
	[KreuzPath setLineWidth:3.0];
	
	NSRect RahmenRect=[ErgebnisRahmenFeld frame];
	
	NSPoint a=RahmenRect.origin;
	NSPoint obenlinks=RahmenRect.origin;
	obenlinks.y+=RahmenRect.size.height-1;
	obenlinks.x+=1;
	
	NSPoint untenrechts=a;
	untenrechts.x+=RahmenRect.size.width-1;
	untenrechts.y+=1;
	NSPoint untenlinks=a;
	NSPoint obenrechts=a;
	obenrechts.x+=RahmenRect.size.width;
	obenrechts.y+=RahmenRect.size.height;
	[KreuzPath moveToPoint:obenlinks];
	[KreuzPath lineToPoint:untenrechts];
	//[[NSColor yellowColor]set];
	[KreuzPath moveToPoint:untenlinks];
	[KreuzPath lineToPoint:obenrechts];
	
	[KreuzPath stroke];
	
	NSPoint b=NSMakePoint(a.x+RahmenRect.size.width,a.y+RahmenRect.size.height);
	[NSBezierPath strokeLineFromPoint:a toPoint:b];
	float x=[RahmenPath currentPoint].x;
	float y=[RahmenPath currentPoint].y;
	//NSLog(@"currentPoint: x: %f   y: %f",x,y);
	[RahmenPath moveToPoint:[ErgebnisRahmenFeld frame].origin];
	x=[RahmenPath currentPoint].x;
	y=[RahmenPath currentPoint].y;
	
	//NSLog(@"currentPoint: x: %f   y: %f",x,y);
	
	[RahmenPath lineToPoint:NSMakePoint(10,10)];
	x=[RahmenPath currentPoint].x;
	y=[RahmenPath currentPoint].y;
	
	//NSLog(@"currentPoint: x: %f   y: %f",x,y);
	
	//[NSBezierPath strokeRect:[ErgebnisRahmenFeld frame]];
	[[RechnungsBox contentView] unlockFocus];
	

}

- (void)markReset
{
	NSLog(@"markReset");
	[ErgebnisRahmenFeld lockFocus];
	[[NSColor lightGrayColor]set];
	NSRect r=[ErgebnisRahmenFeld bounds];
	r.origin.x+=2;
	r.origin.y+=2;
	r.size.width-=4;
	r.size.height-=4;
	NSBezierPath* RahmenPath=[NSBezierPath bezierPathWithRect:r];
	[RahmenPath setLineWidth:3.0];
	[RahmenPath stroke];
	[ErgebnisRahmenFeld unlockFocus];

}

- (void)initReihenSettings
{
//[self DebugStep:@"initReihenSettings start"];
NSView* tempView=[[SettingsBox tabViewItemAtIndex:0]view];
//[self DebugStep:@"initReihenSettings nach tempView"];

//NSLog(@"[SettingsBox tabViewItemAtIndex:0]: %@",[[[SettingsBox tabViewItemAtIndex:0]view]description]);
NSRect r=[tempView frame];
//[self DebugStep:@"initReihenSettings nach vor initWithFrame"];

ReihenSettings=[[rReihenSettings alloc] initWithFrame:r];

//[self DebugStep:@"initReihenSettings nach initWithFrame"];

//[[[SettingsBox tabViewItemAtIndex:0]view]addSubview:[ReihenSettings TastenArray]];
//[[[SettingsBox tabViewItemAtIndex:0]view]setColor:[NSColor redColor]];
//[self DebugStep:@"initReihenSettings nach alloc"];
NSArray* tempArray=[ReihenSettings ReihenKnopfArray];
//[self DebugStep:@"initReihenSettings nach tempArray"];

NSEnumerator* KnopfEnum=[tempArray objectEnumerator];
id einKnopf;
//[self DebugStep:@"initReihenSettings vor while alloc"];

while (einKnopf=[KnopfEnum nextObject])
{
[[[SettingsBox tabViewItemAtIndex:0]view]addSubview:einKnopf];
}//while
//[self DebugStep:@"initReihenSettings nach while"];

NSArray* tempTastenArray=[ReihenSettings ReihenTastenArray];
//[self DebugStep:@"initReihenSettings nach tempTastenArray"];

NSEnumerator* TastenEnum=[tempTastenArray objectEnumerator];
id eineTaste;
//[self DebugStep:@"initReihenSettings vor while eineTaste "];

while (eineTaste=[TastenEnum nextObject])
{
[[[SettingsBox tabViewItemAtIndex:0]view]addSubview:eineTaste];
}//while
//[self DebugStep:@"initReihenSettings nachwhilw eineTaste"];

[[[SettingsBox tabViewItemAtIndex:0]view]addSubview:[ReihenSettings EinschaltTaste]];
//[self DebugStep:@"initReihenSettings nachaddEinschalt"];
[[[SettingsBox tabViewItemAtIndex:0]view]addSubview:[ReihenSettings ClearTaste]];
//[self DebugStep:@"initReihenSettings nach add Clear"];
//NSLog(@"tempView bounds: origin: %f %f size: %f %f ",r.origin.x,r.origin.y,r.size.height,r.size.width);

}

- (void)initAddSubSettings
{
//[self DebugStep:@"initAddSubSettings start"];
NSView* AddSubView=[[SettingsBox tabViewItemAtIndex:1]view];
//NSLog(@"[SettingsBox tabViewItemAtIndex:0]: %@",[[[SettingsBox tabViewItemAtIndex:1]view]description]);
NSRect r=[AddSubView frame];

AddSubSettings=[[rAddSubSettings alloc]initWithFrame:r];
[[[SettingsBox tabViewItemAtIndex:1]view]addSubview:[AddSubSettings EinschaltTaste]];
NSArray* tempTastenArray=[AddSubSettings AddSubTastenArray];
NSEnumerator* TastenEnum=[tempTastenArray objectEnumerator];
id eineTaste;
while (eineTaste=[TastenEnum nextObject])
{
[[[SettingsBox tabViewItemAtIndex:1]view]addSubview:eineTaste];
}//while

}
-(IBAction)toggleDrawer:(id)sender
{
NSLog(@"toggleDrawer state: %d  OK: %d  Modus: %d",[sender state],OK,Modus);
[self closeSessionDrawer:NULL];
	if (OK)
	{
		switch(Modus)
		{
			case kTrainingModus:
			{
				[SettingAlsTestSichernTaste setHidden:YES];
				[AblaufzeitTimer invalidate];
				[SettingsDrawer toggle:sender];
				if (([SettingsDrawer state]==NSDrawerOpenState))//	||([SettingsDrawer state]==NSDrawerOpeningState))
				{
					NSLog(@"SettingsDrawer is opening");
					[StartTaste setEnabled:NO];
					[neueSerieTaste  setEnabled:YES];
					[StartTaste setKeyEquivalent:@""];
					//[SettingsPfeil setKeyEquivalent:@"\r"];
					//[[self window]makeFirstResponder:SettingsPfeil];
					
					[self setSettingsMitDic:SerieDatenDic];
					[SerieDatenDic setObject:@"Training" forKey:@"testname"];
				}
				if (([SettingsDrawer state]==NSDrawerClosedState)||([SettingsDrawer state]==NSDrawerClosingState))
				{
					NSLog(@"SettingsDrawer is closing");
					[StartTaste setEnabled:YES];
					[neueSerieTaste  setEnabled:YES];
					[SettingsPfeil setKeyEquivalent:@""];
					[StartTaste setKeyEquivalent:@"\r"];
					[[self window]makeFirstResponder:StartTaste];
					
					{
						[SerieDatenDic addEntriesFromDictionary:[self SerieDatenDicAusSettings]];
						NSLog(@"SettingsDrawer is closing: SerieDatenDic: %@",[SerieDatenDic description]);
						[SerieDatenDic setObject:@"Training" forKey:@"testname"];

						[self neueSerie:NULL];
					}
				}
				}break;
				
			case kTestModus:
			{
				break;//Nur im trainigMdus
				NSLog(@"SettingsDrawer testModus");
				[AblaufzeitTimer invalidate];
				
				if (([SettingsDrawer state]==NSDrawerClosedState))
				{
					if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
					{
						[SettingAlsTestSichernTaste setHidden:NO];
						[SettingsDrawer toggle:sender];
						[self startTimeout];
						NSLog(@"toggleDrawer SettingsDrawer is opening");
						[StartTaste setEnabled:NO];
						[neueSerieTaste  setEnabled:YES];
						[AnzahlPopKnopf  setEnabled:YES];
						[ZeitPopKnopf  setEnabled:YES];
						[StartTaste setKeyEquivalent:@""];
//						[SettingsPfeil setKeyEquivalent:@"\r"];
//						[[self window]makeFirstResponder:SettingsPfeil];
						
						[self setSettingsMitDic:SerieDatenDic];
						[SerieDatenDic setObject:@"Training" forKey:@"testname"];
					}
				}
				
				if (([SettingsDrawer state]==NSDrawerOpenState))
				{
					[SettingsDrawer toggle:sender];
					[SettingAlsTestSichernTaste setHidden:YES];
					NSLog(@"SettingsDrawer is closing");
					[StartTaste setEnabled:YES];
					[neueSerieTaste  setEnabled:YES];
					[SettingsPfeil setKeyEquivalent:@""];
					[StartTaste setKeyEquivalent:@"\r"];
					[[self window]makeFirstResponder:StartTaste];
					
					{
						[SerieDatenDic addEntriesFromDictionary:[self SerieDatenDicAusSettings]];
						NSLog(@"SettingsDrawer is closing: SerieDatenDic: %@",[SerieDatenDic description]);
						[self neueSerie:NULL];
						[self stopTimeout];
					}
					
				}
			}break;	
				
		}//switch Modus
		}//if OK
NSLog(@"toggleDrawer end");
}

-(IBAction)closeDrawer:(id)sender
{
[SettingsDrawer close:NULL];
[SettingsPfeil setState:NO];
}

-(IBAction)openDrawer:(id)sender
{
if (OK)
{
	NSLog(@"SettingsDrawer testModus");
	[AblaufzeitTimer invalidate];
	[SettingsDrawer open:NULL];
	//[SettingsPfeil setState:YES];
	[AblaufzeitTimer invalidate];

						[SettingAlsTestSichernTaste setHidden:NO];
						//[SettingsDrawer toggle:sender];
		//				[self startTimeout];
						NSLog(@"openDrawer  SettingsDrawer is opening");
						[StartTaste setEnabled:NO];
						[neueSerieTaste  setEnabled:YES];
						[AnzahlPopKnopf  setEnabled:YES];
						[ZeitPopKnopf  setEnabled:YES];
						[StartTaste setKeyEquivalent:@""];
						[SettingAlsTestSichernTaste setKeyEquivalent:@"\r"];
						[[self window]makeFirstResponder:SettingAlsTestSichernTaste];
						
						[self setSettingsMitDic:SerieDatenDic];
			//			[SerieDatenDic setObject:@"Training" forKey:@"testname"];

}//if OK
NSLog(@"openDrawer  end");
}

- (IBAction)reportSettingAlsTestSichern:(id)sender
{
NSLog(@"reportSettingAlsTestSichern");
SerieDatenDic=(NSMutableDictionary*)[self SerieDatenDicAusSettings];
NSLog(@"reportSettingAlsTestSichern: SerieDatenDic: %@",[SerieDatenDic description]);
[self closeDrawer:NULL];
[self showTestPanel:NULL];
[TestPanel selectEingabeFeld];
[TestPanel setAnzahl:[AnzahlPopKnopf indexOfSelectedItem]];
[TestPanel setZeit:[ZeitPopKnopf indexOfSelectedItem]];

}

- (void)setupAufgabenDrawer 
{
	[self closeSessionDrawer:NULL];
    NSSize contentSize = NSMakeSize(180, 150);
    AufgabenDrawer = [[[NSDrawer alloc] initWithContentSize:contentSize preferredEdge:NSMaxXEdge]retain];
    [AufgabenDrawer setParentWindow:[self window]];
    [AufgabenDrawer setDelegate:self];
	NSSize DrawerSize=[AufgabenDrawer contentSize];
	NSRect DrawerRect;
	DrawerRect.origin=NSMakePoint(5,5);
	DrawerRect.size=DrawerSize;
	//DrawerRect=[[AufgabenDrawer contentView]frame];
	DrawerRect.size.height=308;
	DrawerRect.size.width-=5;
	if (!DrawerView)
	{
	//NSLog(@"DrawerView init");
	DrawerView=[[NSTextView alloc]initWithFrame:DrawerRect];
	}
	[[AufgabenDrawer contentView]addSubview:DrawerView];
	[DrawerView setEditable:NO];
	//[AufgabenDrawer setMinContentSize:contentSize];
	//[AufgabenDrawer setMaxContentSize:contentSize];
	//[AufgabenDrawer retain];
}

- (void)openAufgabenDrawer:(id)sender 
{
[self closeSessionDrawer:NULL];
[AufgabenDrawer openOnEdge:NSMaxXEdge];
}

- (void)closeAufgabenDrawer:(id)sender {[AufgabenDrawer close];}

- (void)toggleAufgabenDrawer:(id)sender 
{
	//NSLog(@"AufgabenDrawer");
	[self closeSessionDrawer:NULL];
	NSRect r=[[[self window]contentView]frame];
	NSPoint p=[[[self window]contentView]frame].origin;
	NSSize s=[[[self window]contentView]frame].size;
	//NSLog(@"AufgabenDrawer: dx: %f dy: %f b: %f h: %f",p.x,p.y, s.width, s.height);
    NSDrawerState state = (NSDrawerState)[AufgabenDrawer state];
    if (NSDrawerOpeningState == state || NSDrawerOpenState == state) {
        [AufgabenDrawer close];
    } else 
	{
		
		if (!AufgabenDrawer)
		{
		[self setupAufgabenDrawer];
		}
        [AufgabenDrawer openOnEdge:NSMaxXEdge];
		
		//NSLog(@"AufgabenDrawer canDraw?: %d",[[AufgabenDrawer contentView] canDraw]);
		
		//NSRect SettingsRect=[[AufgabenDrawer contentView]frame];
		//NSRect DrawerRect;
		/*
		[[AufgabenDrawer contentView]lockFocus];
		DrawerRect.origin=NSMakePoint(5,5);
		DrawerRect.size=DrawerSize;
		DrawerRect.size.height-=50;
		DrawerRect.size.width-=50;

		[[NSColor redColor]set];
		[NSBezierPath fillRect:DrawerRect];
		[[AufgabenDrawer contentView]unlockFocus];
		*/
		NSSize DrawerSize=[AufgabenDrawer contentSize];
		NSRect DrawerRect;
		DrawerRect.origin=NSMakePoint(5,5);
		DrawerRect.size=DrawerSize;
		//DrawerRect=[[AufgabenDrawer contentView]frame];
		DrawerRect.size.height-=5;
		DrawerRect.size.width-=5;
		if (!DrawerView)
		{
		//NSLog(@"DrawerView init");
		DrawerView=[[NSTextView alloc]initWithFrame:DrawerRect];
		}
		[[AufgabenDrawer contentView]addSubview:DrawerView];
		
	[self showAufgaben];
    }
}

- (void)SessionTimerFunktion:(NSTimer*)derTimer
{
[self closeSessionDrawer:NULL];

}

- (void)toggleSessionDrawer:(id)sender
{
NSDrawerState state = (NSDrawerState)[SessionDrawer state];
NSLog(@"toggleSessionDrawer state: %d",state);
    
    if (NSDrawerOpeningState == state || NSDrawerOpenState == state) 

	{
        [SessionDrawer close];
		[SessionDrawerTaste setState:NO];

		if ([SessionTimer isValid])
		{
		[SessionTimer invalidate];
		}
	

    } 
	else 
	{
		
		[self setupSessionDrawer];
		SessionTimer=[NSTimer scheduledTimerWithTimeInterval:10.0 
													  target:self 
													selector:@selector(SessionTimerFunktion:) 
													userInfo:nil 
													 repeats:NO];
		[SessionTimer retain];
			
        [SessionDrawer openOnEdge:NSMaxXEdge];
	}
}
- (void)openSessionDrawer:(id)sender
{

}

- (void)closeSessionDrawer:(id)sender
{
//NSLog(@"closeSessionDrawer state vorher: %d",[SessionDrawerTaste state]);

[SessionDrawer close];
[SessionDrawerTaste setState:NO];
//NSLog(@"toggleSessionDrawer state nachher: %d",[SessionDrawerTaste state]);
}

- (void)setupSessionDrawer
{
	//NSLog(@"setupSessionDrawer");
//    NSSize contentSize = NSMakeSize(180, 150);
//    SessionDrawer = [[[NSDrawer alloc] initWithContentSize:contentSize preferredEdge:NSMaxYEdge]retain];
//    [SessionDrawer setParentWindow:[self window]];
//    [SessionDrawer setDelegate:self];
//	NSSize DrawerSize=[SessionDrawer contentSize];
/*
	NSRect DrawerRect;
	DrawerRect.origin=NSMakePoint(5,5);
	DrawerRect.size=DrawerSize;
	//DrawerRect=[[AufgabenDrawer contentView]frame];
//	DrawerRect.size.height=308;
	DrawerRect.size.width-=5;
	*/
	if (SessionTable)
	{
	//NSLog(@"setupSessionDrawer1");
	SessionDS=[[rSessionDS alloc]init];
	rSessionCell* SessionCell=[[rSessionCell alloc]init];
	[[SessionTable tableColumnWithIdentifier:@"session"]setDataCell:SessionCell];
	[SessionTable setDataSource:SessionDS];
	[SessionTable setDelegate:SessionDS];
	//NSLog(@"setupSessionDrawer 2");
	[SessionDS setSessionDicArrayMitDicArray:[Utils NamenDicArrayAnPfad:SndCalcPfad] mitDatum:SessionDatum];
	//NSLog(@"setupSessionDrawer 3");
	[SessionTable reloadData];
	//NSLog(@"setupSessionDrawer 4");
	NSCalendarDate* tempDate=[[NSCalendarDate alloc]initWithString:[SessionDatum description]];

	int tag=[tempDate dayOfMonth];
	int monat=[tempDate monthOfYear];
	int jahr=[tempDate yearOfCommonEra];
	int stunde=[tempDate hourOfDay];
	int minute=[tempDate minuteOfHour];
	
	NSString* JahrString=[[NSNumber numberWithInt:jahr]stringValue];
	JahrString=[JahrString substringFromIndex:2];
	
	NSString* StundeString=[[NSNumber numberWithInt:stunde]stringValue];
	if (stunde<10)
	{
	StundeString=[@"0" stringByAppendingString:StundeString];
	}

	NSString* MinuteString=[[NSNumber numberWithInt:minute]stringValue];
	if (minute<10)
	{
	MinuteString=[@"0" stringByAppendingString:MinuteString];
	}

	NSString* Tag=[NSString stringWithFormat:@"%d.%d.%@   %@:%@",tag,monat,JahrString,StundeString,MinuteString];

	[SessionDatumFeld setStringValue:Tag];
	}
	//[[SessionDrawer contentView] setEditable:NO];
	//NSLog(@"setupSessionDrawer end");
}



- (void)showAufgaben//:(AufgabenDatenRecord*)  AufgabenDatenArray
{
	[self closeSessionDrawer:NULL];
	//NSLog(@"showAufgaben: AufgabenArray: %@",[AufgabenArray description]);
	NSMutableParagraphStyle* TitelStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	//[TitelStil setTabStops:[NSArray array]];//default weg
	//NSTextTab* TitelTab1=[[[NSTextTab alloc]initWithType:NSLeftTabStopType location:50]autorelease];
	//[TitelStil addTabStop:TitelTab1];
	
	//Attr-String für Titelzeile zusammensetzen
	NSString* KopfString=@"Aufgaben\n";
	NSMutableAttributedString* attrTitelString=[[NSMutableAttributedString alloc] initWithString:KopfString]; 
	[attrTitelString addAttribute:NSParagraphStyleAttributeName value:TitelStil range:NSMakeRange(0,[KopfString length])];
	//[attrTitelString addAttribute:NSFontAttributeName value:TitelFont range:NSMakeRange(0,[KopfString length])];
	//titelzeile einsetzen
	//[[DrawerView textStorage]setAttributedString:attrTitelString];
	
	NSMutableParagraphStyle* AufgabenStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	[AufgabenStil setTabStops:[NSArray array]];//default weg
	int tab=40;
	NSTextTab* NRTab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:tab]autorelease];
	[AufgabenStil addTabStop:NRTab];
	
	 tab+=15;
	NSTextTab* OpTab=[[[NSTextTab alloc]initWithType:NSLeftTabStopType location:tab]autorelease];
	[AufgabenStil addTabStop:OpTab];

	tab+=30;
	NSTextTab* Var2Tab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:tab]autorelease];
	[AufgabenStil addTabStop:Var2Tab];
	
	 tab+=15;
	NSTextTab* GleichTab=[[[NSTextTab alloc]initWithType:NSLeftTabStopType location:tab]autorelease];
	[AufgabenStil addTabStop:GleichTab];
	
	 tab+=40;
	NSTextTab* ResTab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:tab]autorelease];
	[AufgabenStil addTabStop:ResTab];

	//NSFontManager *fontManager = [NSFontManager sharedFontManager];

	NSFont* AufgabenFont;
	AufgabenFont=[NSFont fontWithName:@"Helvetica" size: 10];
	//[attrTitelString addAttribute:NSFontAttributeName value:AufgabenFont range:NSMakeRange(0,[KopfString length])];

	
	if ([AufgabenArray count])
	{
	[[DrawerView textStorage]setAttributedString:attrTitelString];

	int index=0;
	NSEnumerator* AufgabenEnum=[AufgabenArray objectEnumerator];
	id eineAufgabe;
	//NSLog(@"[AufgabenArray count]: %d" ,[AufgabenArray count]);
	//NSLog(@"showAufgaben: AufgabenArray: %@",[AufgabenArray description]);

	while (eineAufgabe=[AufgabenEnum nextObject])
	{
	//NSLog(@"index: %d" ,index);
	//NSLog(@"index: %d  object: %@",index,[[AufgabenArray objectAtIndex:index]description]);
	//NSLog(@"index: %d  object: %@",index,[[[AufgabenArray objectAtIndex:index]objectForKey:@"var1"]description]);
	NSString* tempAufgabenString=[NSString string];
	NSString* nr=[[[AufgabenArray objectAtIndex:index]objectForKey:@"aufgabennummer"]stringValue];
	tempAufgabenString=[[tempAufgabenString stringByAppendingString:nr]stringByAppendingString:@"\t"];

	NSString* var0=[[[AufgabenArray objectAtIndex:index]objectForKey:@"var0"]stringValue];
	//NSLog(@"index: %d  var0: %@",index,var0);
	tempAufgabenString=[[tempAufgabenString stringByAppendingString:var0]stringByAppendingString:@"\t"];


	NSString* op0=[[AufgabenArray objectAtIndex:index]objectForKey:@"operatorzeichen"];
	//NSLog(@"index: %d  op0: %@",index,op0);
	tempAufgabenString=[[tempAufgabenString stringByAppendingString:op0]stringByAppendingString:@"\t"];

	NSString* var1=[[[AufgabenArray objectAtIndex:index]objectForKey:@"var1"]stringValue];
	//NSLog(@"index: %d  var1: %@",index,var1);
	tempAufgabenString=[[tempAufgabenString stringByAppendingString:var1]stringByAppendingString:@"\t"];
	
	NSString* gleich=@"=";;
	//NSLog(@"index: %d  gleich: %@",index,gleich);
	tempAufgabenString=[[tempAufgabenString stringByAppendingString:gleich]stringByAppendingString:@"\t"];

	NSString* var2=[[[AufgabenArray objectAtIndex:index]objectForKey:@"var2"]stringValue];
	//NSLog(@"index: %d  var2: %@",index,var2);
	tempAufgabenString=[[tempAufgabenString stringByAppendingString:var2]stringByAppendingString:@"\n"];
	//NSLog(@"tempAufgabenString: %@",tempAufgabenString);

	NSMutableAttributedString*AufgabenString=[[NSMutableAttributedString alloc] initWithString:tempAufgabenString];
	//NSAttributedString* cr=[[NSAttributedString alloc] initWithString:@"\r"];
	
	//[AufgabenString appendAttributedString:cr];
	[AufgabenString addAttribute:NSParagraphStyleAttributeName value:AufgabenStil range:NSMakeRange(0,[AufgabenString length])];
	[AufgabenString addAttribute:NSFontAttributeName value:AufgabenFont range:NSMakeRange(0,[AufgabenString length])];
	
	[[DrawerView textStorage]appendAttributedString:AufgabenString];
	
	index++;
		}//while
	//NSLog(@"nach show: AufgabenString: %@",[AufgabenString description]);

}//AufgabenArray count
}











- (void)setMaxZeit:(id)sender
{
	[self closeSessionDrawer:NULL];
	int maxZeit=[[sender titleOfSelectedItem]intValue];
	NSLog(@"setMaxZeit: maxZeit: %d",maxZeit);

	[Zeitanzeige setMax:maxZeit];
	[ZeitFeld setIntValue:maxZeit];

	if  (Modus==kTrainingModus)
	{
		if (OK)
		{
			
			[self neueSerie:NULL];
			[StartTaste setEnabled:YES];
		}//if OK
		else
		{
		//Pop zurücksetzen
		}
	}//if Training
	
	return;//22.8.
//	else
	{
		NSAlert* TestWarnung=[[NSAlert alloc]init];
		NSString* t=NSLocalizedString(@"This is a Test",@"Das ist ein Test");
		NSString* i1=NSLocalizedString(@"You cannot change the time",@"Du kannst die Zeit nicht ändern.");
		//NSString* b1=NSLocalizedString(@"As A Guest",@"Als Gast");
		//NSString* b2=NSLocalizedString(@"Choose A Name",@"Einen Namen wählen");
		[TestWarnung addButtonWithTitle:@"OK"];
		//[TestWarnung addButtonWithTitle:b2];
		[TestWarnung setMessageText:t];
		[TestWarnung setInformativeText:i1];
		
		int modalAntwort=[TestWarnung runModal];
		
	}
}




- (void)setAnzahlAufgaben:(id)sender
{
	AnzahlAufgaben=[[sender titleOfSelectedItem]intValue];
	[Aufgabenzeiger setAnzAufgaben:AnzahlAufgaben];

	if (Modus==kTrainingModus)
	{
		if (OK)
		{
			[self neueSerie:NULL];
			[StartTaste setEnabled:YES];//es kann gleich losgehen
		}
	}//if OK
	return;//22.8.
	
	
//	else
	{
		NSAlert* TestWarnung=[[NSAlert alloc]init];
		NSString* t=NSLocalizedString(@"This is a Test",@"Das ist ein Test");
		NSString* i1=NSLocalizedString(@"You cannot change the count of tasks",@"Du kannst die Anzahl der Aufgaben nicht ändern.");
		//NSString* b1=NSLocalizedString(@"As A Guest",@"Als Gast");
		//NSString* b2=NSLocalizedString(@"Choose A Name",@"Einen Namen wählen");
		[TestWarnung addButtonWithTitle:@"OK"];
		//[TestWarnung addButtonWithTitle:b2];
		[TestWarnung setMessageText:t];
		[TestWarnung setInformativeText:i1];
		
//		int modalAntwort=[TestWarnung runModal];
	}
	
}







- (void)setLosTaste:(id)sender
{
   
    [StartTaste  setTitle:@"Weiter"];

}

- (IBAction)setTest:(id)sender
{	
	[self closeSessionDrawer:NULL];
	if (OK)
	{
		Status=1;
		
		NSLog(@"setTest: %@",[sender titleOfSelectedItem]);
		[AblaufzeitTimer invalidate];
		if ([ModusOption selectedRow]==0)//nicht Training
		{
		/*
			if ([NamenPopKnopf indexOfSelectedItem]==0)//Gast
			{
				//NSLog(@"Namen wählen");
				[ErgebnisseTaste setEnabled:NO];
				
				NSAlert* OrdnerWarnung=[[NSAlert alloc]init];
				//NSString* t=NSLocalizedString(@"You Are here as a guest",@"Du bist als Gast hier");
				NSString* t=NSLocalizedString(@"Who are You?",@"Wer bist du?");
				//NSString* i1=NSLocalizedString(@"How do you want to continue?",@"Wie willst du weiterfahren?");
				NSString* i1=NSLocalizedString(@"You have to choose a name to continue",@"Du musst einen Namen wählen, um weiterzufahren");
				NSString* b1=NSLocalizedString(@"Cancel",@"Abbrechen");
				NSString* b2=NSLocalizedString(@"Choose A Name",@"Einen Namen wählen");
				//[OrdnerWarnung addButtonWithTitle:b1];
				[OrdnerWarnung addButtonWithTitle:b2];
				[OrdnerWarnung setMessageText:t];
				[OrdnerWarnung setInformativeText:i1];
				
				int modalAntwort=[OrdnerWarnung runModal];
				switch (modalAntwort)
				{
					case NSAlertFirstButtonReturn://Gast
					{
						Status=0;
						//	[NSApp terminate:self];
						//Modus=kTrainingModus;
					
						return;
					}break;
					case NSAlertSecondButtonReturn://Namen wählen
					{
						return;
					}break;
						
						
				}//switch
				
			}//Gast
			else
			{
			//[ErgebnisseTaste setEnabled:YES];
				[ErgebnisseTaste setEnabled: [NamenPopKnopf indexOfSelectedItem]];
				Modus=kTestModus;
			}
			*/
			
			[self closeDrawer:NULL];
//			[SettingsPfeil setEnabled:NO];
			NSArray* TestDicArray=[PListDic objectForKey:@"testarray"];
			//NSLog(@"setTest: TestDicArray: %@",[TestDicArray description]);
			if (TestDicArray)
			{
				int Testindex=-1;
				
				NSArray* TestNamenArray=[TestDicArray valueForKey:@"testname"];
				if([TestNamenArray count])
				{
					Testindex=[TestNamenArray indexOfObject:[sender titleOfSelectedItem]];
					if (Testindex<NSNotFound)
					{
						SerieDatenDic=[[[TestDicArray objectAtIndex:Testindex]objectForKey:@"seriedatendic"]mutableCopy];
						
						//Zeit und anzahlaufgaben in den SeriedatenDic schreiben. 
						//Sie werden beim Sichern eines neuen Tests nur in den TestDic geschrieben
						
						if ([[TestDicArray objectAtIndex:Testindex]objectForKey:@"anzahlaufgaben"])
						{
				//		int anz=[[[TestDicArray objectAtIndex:Testindex]objectForKey:@"anzahlaufgaben"] intValue];
						[SerieDatenDic setObject:[[TestDicArray objectAtIndex:Testindex]objectForKey:@"anzahlaufgaben"]forKey: @"anzahlaufgaben"];
						}
						if ([[TestDicArray objectAtIndex:Testindex]objectForKey:@"zeit"])
						{
				//		int zeit=[[[TestDicArray objectAtIndex:Testindex]objectForKey:@"zeit"] intValue];
						[SerieDatenDic setObject:[[TestDicArray objectAtIndex:Testindex]objectForKey:@"zeit"]forKey: @"zeit"];
						}
						
						//SerieDatenDic im TestDatenDic
				//		NSLog(@"setTest	\n							SerieDatenDic: %@",[SerieDatenDic description]);
						[self neueSerie:NULL];
					}
				}
			}
		}
		else
		{
			Modus=kTrainingModus;
			[SettingsPfeil setEnabled:YES];
			[self neueSerie:NULL];
			
		}
	}//if OK
}

- (void)resetTest 
{	
	//Nach Einschalten des TestModus den eingestellten Test aktivieren
//	[self closeSessionDrawer:NULL];
	if (OK)
	{
		
		NSLog(@"resetTest: %@",[TestPopKnopf titleOfSelectedItem]);
		[AblaufzeitTimer invalidate];
		if ([ModusOption selectedRow]==0)//nicht Training
		{
			[ErgebnisseTaste setEnabled: [NamenPopKnopf indexOfSelectedItem]];

			
			Modus=kTestModus;
			[self closeDrawer:NULL];
//			[SettingsPfeil setEnabled:NO];
			NSArray* TestDicArray=[PListDic objectForKey:@"testarray"];
			NSLog(@"resetTest: TestDicArray: %@",[TestDicArray description]);
			if (TestDicArray)
			{
				int Testindex=-1;
				
				NSArray* TestNamenArray=[TestDicArray valueForKey:@"testname"];
				if([TestNamenArray count])
				{
					Testindex=[TestNamenArray indexOfObject:[TestPopKnopf titleOfSelectedItem]];
					if (Testindex<NSNotFound)
					{
						SerieDatenDic=[[[TestDicArray objectAtIndex:Testindex]objectForKey:@"seriedatendic"]mutableCopy];
						//SerieDatenDic im TestDatenDic
						NSLog(@"resetTest\n							SerieDatenDic: %@",[SerieDatenDic description]);
						[self neueSerie:NULL];
					}
				}
			}
		}
		else
		{
			Modus=kTrainingModus;
			[SettingsPfeil setEnabled:YES];
			[self neueSerie:NULL];
			
		}
	}//if OK
}

- (void)setTestVonTestname:(NSString*)derTest
{	
	if (OK)
	{
		Status=1;
		//NSLog(@"setTestVonTestname: %@",derTest);
		[AblaufzeitTimer invalidate];
		if ([ModusOption selectedRow]==0)//nicht Training
		{
			if ([NamenPopKnopf indexOfSelectedItem]==0)//Gast
			{
				NSLog(@"Namen wählen");
				//NSLog(@"Namen wählen");
				[ErgebnisseTaste setEnabled:NO];
				NSAlert* OrdnerWarnung=[[NSAlert alloc]init];
				//NSString* t=NSLocalizedString(@"You Are here as a guest",@"Du bist als Gast hier");
				NSString* t=NSLocalizedString(@"Who are You?",@"Wer bist du?");
				//NSString* i1=NSLocalizedString(@"How do you want to continue?",@"Wie willst du weiterfahren?");
				NSString* i1=NSLocalizedString(@"You have to choose a name to continue",@"Du musst einen Namen wählen, um weiterzufahren");
				NSString* b1=NSLocalizedString(@"Cancel",@"Abbrechen");
				NSString* b2=NSLocalizedString(@"Choose A Name",@"Einen Namen wählen");
				[OrdnerWarnung addButtonWithTitle:b1];
				[OrdnerWarnung addButtonWithTitle:b2];
				[OrdnerWarnung setMessageText:t];
				[OrdnerWarnung setInformativeText:i1];
			}//Gast
			else
			{
			[ErgebnisseTaste setEnabled:[NamenPopKnopf indexOfSelectedItem]];
			}
			
			Modus=kTestModus;
			[self closeDrawer:NULL];
//			[SettingsPfeil setEnabled:NO];
			NSArray* TestDicArray=[PListDic objectForKey:@"testarray"];
			//NSLog(@"setTest: TestDicArray: %@",[TestDicArray description]);
			if (TestDicArray)
			{
				int Testindex=-1;
				
				NSArray* TestNamenArray=[TestDicArray valueForKey:@"testname"];
				if([TestNamenArray count])
				{
					Testindex=[TestNamenArray indexOfObject:derTest];
					if (Testindex<NSNotFound)
					{
						SerieDatenDic=[[[TestDicArray objectAtIndex:Testindex]objectForKey:@"seriedatendic"]mutableCopy];
						//SerieDatenDic im TestDatenDic
						//NSLog(@"setTest	\n							SerieDatenDic: %@",[SerieDatenDic description]);
						[self neueSerie:NULL];
					}
				}
			}
		}
		else
		{
			Modus=kTrainingModus;
			[SettingsPfeil setEnabled:YES];
			[self neueSerie:NULL];
			
		}
	}//if OK
	//NSLog(@"setTestVonTestname:end");

}

- (void)saveTest:(id)sender
{
NSLog(@"saveTest");
}

- (void)setModus:(id)sender
{
	
	
	//NSLog(@"setModus Option: %d",[sender selectedRow]);
//	[TestPopKnopf setEnabled: ([sender selectedRow]==0)];
	if ([sender selectedRow]==0)
	{
		[self closeSessionDrawer:NULL];
		Modus=kTestModus;
		[AnzahlPopKnopf setEnabled:NO];
		[ZeitPopKnopf setEnabled:NO];
		[SettingsPfeil setEnabled: NO];
		[self closeDrawer:NULL];
		[self resetTest];
		[self neueSerie:NULL];
		[NamenPopKnopf setEnabled:YES];
		[TestPopKnopf setEnabled:NO];
	}
	else
	{
		Modus=kTrainingModus;
		[AnzahlPopKnopf setEnabled:YES];
		[ZeitPopKnopf setEnabled:YES];
		[SettingsPfeil setEnabled: YES];
		[NamenPopKnopf setEnabled:NO];
		[TestPopKnopf setEnabled:NO];
		[self stopTimeout];
		
	}
	if (Modus)
	{
		[TestPopKnopf selectItemWithTitle:[TestPopKnopf titleOfSelectedItem]];
	}
}



- (NSString*)Rechner
{
return [NamenPopKnopf titleOfSelectedItem];
}

- (void)setNamenPopKnopfMitDicArray:(NSArray*)derDicArray
{
	[NamenPopKnopf removeAllItems];
	//NSLog(@"setNamenPopKnopfMitDicArray		derDicArray: %@",[derDicArray description]);
	NSEnumerator* NamenEnum=[derDicArray objectEnumerator];
	id einDic;
	
	while (einDic=[NamenEnum nextObject])
	{
		if ([[einDic objectForKey:@"name"]length])
		{
			NSNumber* aktivNumber=[einDic objectForKey:@"aktiv"];
			if (aktivNumber && [aktivNumber boolValue])
			{
				[NamenPopKnopf addItemWithTitle:[einDic objectForKey:@"name"]];
				if ([einDic objectForKey:@"lastdate"])
				{
					NSDate* tempDatum=[einDic objectForKey:@"lastdate"];
					if ([tempDatum compare:SessionDatum]== NSOrderedDescending)//lastDate ist nach SessionDatum
					{
				//		NSLog(@"setNamenPopKnopfMitDicArray		einDic: %@	Sessiondatum: %@",[einDic description],SessionDatum);
						//NSImage* SessionYESImg=[NSImage imageNamed:@"SessionYESImg.tif"];
						NSImage* SessionYESImg=[NSImage imageNamed:@"MarkOnImg.tif"];
//						[[NamenPopKnopf itemWithTitle:[einDic objectForKey:@"name"]]setImage:SessionYESImg];
						//		[[NamenPopKnopf cell]setImageAlignment:NSImageAlignRight ];
						
					}//	if session
					else
					{
						NSImage* SessionNOImg=[NSImage imageNamed:@"MarkOffImg.tif"];
						//NSImage* SessionNOImg=[NSImage imageNamed:@"SessionNOImg.tif"];
//						[[NamenPopKnopf itemWithTitle:[einDic objectForKey:@"name"]]setImage:SessionNOImg];
					}
				}
				else
				{
					NSImage* SessionNOImg=[NSImage imageNamed:@"MarkOffImg.tif"];
					//NSImage* SessionNOImg=[NSImage imageNamed:@"SessionNOImg.tif"];
//					[[NamenPopKnopf itemWithTitle:[einDic objectForKey:@"name"]]setImage:SessionNOImg];
					
				}
				
			}//if aktiv
			
		}//	if name length
		
	}//while
//	[NamenPopKnopf insertItemWithTitle:@"Namen wählen" atIndex:0];
	NSDictionary* firstItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
	NSAttributedString* firstItem=[[NSAttributedString alloc]initWithString:NSLocalizedString(@"Choose Name",@"Namen wählen") attributes:firstItemAttr];
	[NamenPopKnopf insertItemWithTitle:@""atIndex:0];
	[[NamenPopKnopf itemAtIndex:0]setAttributedTitle:firstItem];

}


- (IBAction)setVolumeAufWert:(float)derWert
{
   [Speaker setVolume:derWert];
   Volume=derWert;
   
  // NSLog(@"setVolume: Volume: %f",Volume);
}


- (IBAction)setName:(id)sender
{
	[self closeSessionDrawer:NULL];
	if ([sender indexOfSelectedItem])//nicht Gast
	{
		[self startTimeout];
		
		NSLog(@"setName: %@		startTimeout",[sender titleOfSelectedItem]);
		//NSLog(@"setName Anzahl Rechner: %@",[sender stringValue]);
		Status=(([sender indexOfSelectedItem]>0)&&([TestPopKnopf numberOfItems]));//Gast hat index 0
																				  //[TestPopKnopf selectItemAtIndex:0];//Training
			
		[StartTaste setEnabled:NO];
			[ErgebnisseTaste setEnabled:[NamenPopKnopf indexOfSelectedItem]];
			[AufgabenNummerFeld setStringValue:@""];
			
			NSDictionary* tempNamenDic=[Utils DatenDicForUser:[sender titleOfSelectedItem] anPfad:SndCalcPfad];
			NSLog(@"setName: tempNamenDic: %@",[tempNamenDic description]);
			NSString* lastTest;
			if ([tempNamenDic objectForKey:@"userplist"])
			{
				if ([[tempNamenDic objectForKey:@"userplist"] objectForKey:@"lastvolume"])
				{
					Volume=[[[tempNamenDic objectForKey:@"userplist"] objectForKey:@"lastvolume"]floatValue];
					[VolumeSchieber setFloatValue:Volume];
					
					[self setVolumeAufWert:Volume];
				}
				if ([[tempNamenDic objectForKey:@"userplist"] objectForKey:@"lasttest"])
				{
					lastTest=[[tempNamenDic objectForKey:@"userplist"] objectForKey:@"lasttest"];
				}
				else
				{
				lastTest=[TestPopKnopf titleOfSelectedItem];
				}
				
			}
			
			NSString* tempUser=[NamenPopKnopf titleOfSelectedItem];
			NSArray* tempUserTestArray=[Utils UserTestArrayVonUser:tempUser anPfad:SndCalcPfad];
			
			
			//NSLog(@"setName: User: %@	lastTest: %@		Testarray; %@",tempUser,lastTest,[tempUserTestArray description]);
			if ([tempUserTestArray count])	
			{
			[self setTestPopKnopfForUser:tempUser];
			
			NSLog(@"setName:	nach setTestPopKnopfForUser");
			
			if ([lastTest length]&&[[TestPopKnopf itemTitles]containsObject:lastTest])
			{
				[TestPopKnopf selectItemWithTitle:lastTest];
			}
			else
			{
				[TestPopKnopf selectItemAtIndex:0];
			}
			NSLog(@"setName:	nach selectItemAtIndex");
			if ([[TestPopKnopf titleOfSelectedItem]length])
			{
				[self setTestVonTestname:[TestPopKnopf titleOfSelectedItem]];
			}
			}
			[StartTaste setEnabled:YES];
			[TestPopKnopf setEnabled:YES];
	//		[StartTaste setKeyEquivalent:@"\r"];
			[[self window] makeFirstResponder:StartTaste];
	}
	NSLog(@"setName:													end");
}

- (void)showNamenPanel:(id)sender
{
if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
{
	[self stopTimeout];
	[self stopAdminTimeout];

	if (!NamenPanel)
	{
		NSLog(@"init NamenPanel");
		NamenPanel=[[rNamenPanel alloc]init];
	}
	
	NSModalSession NamenSession=[NSApp beginModalSessionForWindow:[NamenPanel window]];
	//Array der vorhandenen Namen
	
	
	NSArray* NamenDicArrayAusPList=[Utils NamenDicArrayAnPfad:SndCalcPfad];
	
	
	
	if (NamenDicArrayAusPList&&[NamenDicArrayAusPList count])//Vorhandene Namen einsetzen
	{
	[NamenPanel setNamenDicArray:[NamenDicArrayAusPList copy]];
	}
	

	int modalAntwort = [NSApp runModalForWindow:[NamenPanel window]];
	[NSApp endModalSession:NamenSession];
	NSLog(@"showNamenPanel: Antwort: %d",modalAntwort);
//	[self startTimeout];
	switch (modalAntwort)
	{
		case 0://Abbrechen
		{
		
		}break;
		case 1://Schliessen
		{
		//NSLog(@"\n\n");NSLog(@"\n\n");
		//NSLog(@"vor");
		NSMutableArray* tempNamenDicArray=[[NSMutableArray alloc]initWithArray:[NamenPanel NamenDicArray]];
		//eventuell Aenderung in "aktiv"
		
		//NSLog(@"tempNamenDicArray aus NamenPanel nach Antwort: NamenDicArray %@",[tempNamenDicArray description]);
		//NSLog(@"\n\n");
		
		//NSArray* NamenArray=[NamenDicArray valueForKey:@"name"];
		NSArray* NamenArray=[NamenPanel NamenArray];
		//eventuell neue Namen
		
		NSLog(@"showNamenPanel nach Antwort: NamenPanel %@",[ NamenArray description]);
		
		if ([NamenArray count])
			{
				//NSLog(@"NamenDicArray valueForKey:name: %@",[[NamenDicArray valueForKey:@"name"]description]);
				int i;
				for (i=0;i<[NamenArray count];i++)
					
					if ([[NamenArray objectAtIndex:i]length])
					{
						NSMutableDictionary* neuerNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
						NSString* tempName=[ NamenArray objectAtIndex:i];
						NSLog(@"index: %d ein tempName da: %@",i,tempName);
						[neuerNamenDic setObject:tempName forKey:@"name"];//neuer Name
						//NSLog(@"1");
						[neuerNamenDic setObject:[NSNumber numberWithInt:1] forKey:@"aktiv"];//aktiv
						//NSLog(@"2");
						[neuerNamenDic setObject:[NSNumber numberWithFloat:80.00] forKey:@"lastvolume"];		
						//NSLog(@"3");
						if ([[TestPopKnopf selectedItem]title])
						{
						[neuerNamenDic setObject:[[TestPopKnopf selectedItem]title] forKey:@"lasttest"];//neuer Name
						}
						//NSLog(@"4");
						NSMutableArray* tempNamenArray=[[tempNamenDicArray valueForKey:@"name"]mutableCopy];
						//[tempNamenArray removeObject:@" "];
						int DoppelIndex=[tempNamenArray indexOfObject:[neuerNamenDic objectForKey:@"name"]];
						if (DoppelIndex==NSNotFound)//Name noch nicht da
						{
							[tempNamenDicArray addObject:neuerNamenDic];
							NSLog(@"Neuer Name noch nicht da: %@",[neuerNamenDic description]);
							//NSLog(@"NamenPanel antwort: NamenDicArray: %@",[NamenDicArray description]);
						
						}
						else
						{
							NSLog(@"Neuer Name schon da: index: %@",[neuerNamenDic description]);
							[tempNamenDicArray replaceObjectAtIndex:DoppelIndex withObject:neuerNamenDic];
						}
						//NSLog(@"ende schlaufe:i: %d",i);
					}
						
			}//count
		
			[NamenPopKnopf removeAllItems];
			//[NamenPopKnopf addItemWithTitle:@"Namen wählen"];
				
				
			if (tempNamenDicArray && [tempNamenDicArray count])
			{
				[NamenPopKnopf removeAllItems];
				
				//int i;
				for (int i=0;i<[[tempNamenDicArray valueForKey:@"name"]count];i++)
				{
					if ([[[tempNamenDicArray valueForKey:@"name"]objectAtIndex:i]length])
					{
						NSNumber* aktivNumber=[[tempNamenDicArray objectAtIndex:i]objectForKey:@"aktiv"];
						if (aktivNumber && [aktivNumber boolValue])
						{
						[NamenPopKnopf addItemWithTitle:[[tempNamenDicArray valueForKey:@"name"]objectAtIndex:i]];
						}
					}
				}
			}
			[NamenPopKnopf insertItemWithTitle:@"Namen wählen" atIndex:0];
			//NSLog(@"Nach Schliessen: NamenPanel tempNamenDicArray: %@",[tempNamenDicArray description]);
			//[PListDic setObject:NamenDicArray  forKey:@"namendicarray"];
			
			BOOL CheckOK=[Utils checkChangeNamenListe:tempNamenDicArray anPfad:SndCalcPfad];
			
			//[PListDic setObject:tempNamenDicArray  forKey:@"namendicarray"];
			
			
			
			
			//NSLog(@"NamenDicArray: %@  \n\nPListDic: %@\n",[NamenDicArray description],[PListDic description]);
		}break;
	}//switch
	[self startAdminTimeout];

	}//passwort
}

- (void)DeleteNamenAktion:(NSNotification*)note
{
	NSLog(@"DeleteNamenAktion: %@",[[note userInfo]description]);
	NSString* deleteName=[[note userInfo]objectForKey:@"deletename"];
	if (deleteName)
	{
		[Utils DeleteNamen:deleteName anPfad:SndCalcPfad];
	}
}


- (void)showStatistikAktion:(NSNotification*)note
{
	NSNumber* modusNumber =[[note userInfo] objectForKey:@"modus"];
	if (modusNumber)
	{
		int modus=[modusNumber intValue];
		if ([[note userInfo] objectForKey:@"diplomdic"]);
		{
		switch (modus)
		{
			case 0://Statistik nur zeigen
			{
				NSString* tempName=[NamenPopKnopf titleOfSelectedItem];
				NSDictionary* tempDic=[Utils DatenDicForUser:tempName anPfad:SndCalcPfad];
				NSMutableDictionary* tempErgebnisDic=[NSMutableDictionary dictionaryWithDictionary:[tempDic objectForKey:@"userplist"]];
				//NSLog(@"showStatistikAktion modus 0	tempErgebnisDic: %@",[tempErgebnisDic description]);
				//NSLog(@"showStatistikAktion 	diplomdic: %@",[[[note userInfo] objectForKey:@"diplomdic"] description]);
				
				if ([[note userInfo] objectForKey:@"diplomdic"])//Dic der neuen Serie
				{
					if ([tempErgebnisDic objectForKey:@"ergebnisdicarray"])//ErgebnisDicArray da
					{
						[[tempErgebnisDic objectForKey:@"ergebnisdicarray"]addObject:[[note userInfo] objectForKey:@"diplomdic"]];
					}
					else
					{
					[tempErgebnisDic setObject:[NSArray arrayWithObjects:[[note userInfo] objectForKey:@"diplomdic"],nil] forKey:@"ergebnisdicarray"];
					}

				}//if
				
				if ([[note userInfo] objectForKey:@"timeout"])
					{
					[tempErgebnisDic setObject:[[note userInfo] objectForKey:@"timeout"]forKey:@"timeout"];
					}

				//NSLog(@"tempErgebnisDic nach: %@",[tempErgebnisDic description]);
			[self showStatistikFor:tempName mitDic:tempErgebnisDic];
			
			NSLog(@"									showStatistikAktion	nach showStatistikFor");

			}break;
			case 1:
			{
			if([NamenPopKnopf indexOfSelectedItem])
				{
				[self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
				}
				//[self showStatistik:NULL];
				
			}break;
				
		}//switch
		}//if diplomdic
	}//if modusNumber
	 //NSString* tempRechner=[NamenPopKnopf titleOfSelectedItem];
	 //[self saveErgebnisVon:tempRechner mitErgebnis:[self SerieErgebnisDic]];
}


- (void)showStatistik:(id)sender
{
	//NSLog(@"\n\nshowStatistik\n");
	[self stopTimeout];
	[self closeSessionDrawer:NULL];
	NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
	//NSLog(@"tempNamenDicArray count: %d",[tempNamenDicArray count]);
	if (tempNamenDicArray)
	{
		if (Status)//nicht Gast
		{	
			//NSLog(@"tempNamenDicArray: %@",[tempNamenDicArray description]);
			NSArray* tempNamenArray=[tempNamenDicArray valueForKey:@"name"];//Namenarray der Rechner
			if (tempNamenArray)
			{
				//NSLog(@"tempNamenArray: %@",[tempNamenArray description]);
				int namenIndex=[tempNamenArray indexOfObject:[NamenPopKnopf titleOfSelectedItem]];
				//NSLog(@"tempNamenArray: namenIndex: %d",namenIndex);
				if ((namenIndex<NSNotFound)&&!(namenIndex==NSNotFound))//Name ist vorhanden
				{
					NSArray* tempErgebnisDicArray=[[tempNamenDicArray objectAtIndex:namenIndex]objectForKey:@"ergebnisdicarray"];
					if (tempErgebnisDicArray&&[tempErgebnisDicArray count]) //tempErgebnisDicArray schon vorhanden
					{
						//NSLog(@"tempErgebnisDicArray: %@",[tempErgebnisDicArray description]);
						if (!Statistik)
						{
							//NSLog(@"init Statistik");
							Statistik=[[rStatistik alloc]init];
						}
						NSModalSession StatistikSession=[NSApp beginModalSessionForWindow:[Statistik window]];
						//Array der vorhandenen Tests
						
						[Statistik setBenutzer:[NamenPopKnopf titleOfSelectedItem]];
						
						[Statistik setStatistikDicArray:[tempErgebnisDicArray copy]];
						
						
						NSMutableArray* TestNamenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
						NSArray* tempTestArray=[PListDic objectForKey:@"testarray"];
						//NSLog(@"tempTestArray: %@",[tempTestArray description]);
						if (tempTestArray && [tempTestArray count])
						{
							NSEnumerator* TestEnum=[tempTestArray objectEnumerator];
							id einTest;
							while(einTest=[TestEnum nextObject])
							{
								if ([[einTest objectForKey:@"aktiv"]boolValue])
								{
									if ([[einTest objectForKey:@"testname"] length])
									{
									[TestNamenArray addObject:[einTest objectForKey:@"testname"]];
									}
								}//if aktiv
							}//while
						}
						
					
						
						//NSArray* TestNamenArray=[[PListDic objectForKey:@"testarray"]valueForKey:@"testname"];
						
						
						//NSLog(@"showStatistik		TestNamenArray: %@",[TestNamenArray description]);
						[TestNamenArray retain];
						[Statistik setTestPopMitStringArray:TestNamenArray];
						
						//if ([TestPopKnopf indexOfSelectedItem])//nicht Training
						//if ([ModusOption selectedRow]==0)//Nicht Training
						
						

						{
							if ([[tempErgebnisDicArray valueForKey:@"testname"]containsObject:[TestPopKnopf titleOfSelectedItem]])
							{
								//NSLog(@"Test da: Name: %@",[TestPopKnopf titleOfSelectedItem]);
								[Statistik setTableVonTest:[TestPopKnopf titleOfSelectedItem]];
							}
							else
							{
							//NSLog(@"Test nicht da: Name: %@",[TestPopKnopf titleOfSelectedItem]);
							}
						}
						//NSLog(@"TestNamenArray: %@",[TestPopKnopf itemArray]);
						//[Statistik setTestPop:[TestPopKnopf itemArray]];
						
						[Statistik setAdminOK:NO];
						
						
						//if ([TestPopKnopf indexOfSelectedItem])
						if ([ModusOption selectedRow]==0)//nicht: Training
						{
							//[Statistik setTableVonTest:[TestPopKnopf titleOfSelectedItem]];
						}
						else
						{
							//[Statistik setTableVonTest:[[TestPopKnopf itemAtIndex:1]title]];
						}
						int modalAntwort = [NSApp runModalForWindow:[Statistik window]];
						
						[NSApp endModalSession:StatistikSession];
						
						//NSLog(@"showStatistik: Antwort: %d",modalAntwort);
						switch (modalAntwort)
						{
							case 0://Abbrechen
							{
								//NSLog(@"showStatistik modalAntwort 0 startTimeout");
							}break;
							case 1://Schliessen
							{
								//NSLog(@"showStatistik modalAntwort 1 startTimeout");
								[self startTimeout];
							}break;
							case -1001://abort
							{
								//NSLog(@"showStatistik modalAntwort -1001 startTimeout");
								[self startTimeout];
							}break;

						}//switch
						
					}
					else
					{
						NSLog(@"Noch keine Ergebnisse fuer: %@",[NamenPopKnopf titleOfSelectedItem]);
						NSAlert* OrdnerWarnung=[[NSAlert alloc]init];
						NSString* t=NSLocalizedString(@"No Results",@"Keine Ergebnisse");
						NSString* i1=NSLocalizedString(@"You have not yet passed a test.",@"Du hast noch keinen Test bestanden.");
						NSString* b1=@"OK";
						[OrdnerWarnung addButtonWithTitle:b1];
						[OrdnerWarnung setMessageText:t];
						[OrdnerWarnung setInformativeText:i1];
						
						int modalAntwort=[OrdnerWarnung runModal];
						//NSLog(@"showStatistik Noch keine Erg. Warnung startTimeout");
						[self startTimeout];
						return;
					}
				}
				
			
			}
		}//Status
	}
	
}

- (void)showStatistikFor:(NSString*)derName mitDic:(NSDictionary*)derErgebnisDic
{
	NSLog(@"\n");
	[self closeSessionDrawer:NULL];
	if (derErgebnisDic)
	{
		//NSLog(@"showStatistikFor: %@	mitErgebnisDic: %@\n",derName, [derErgebnisDic description]);
		NSArray* tempErgebnisDicArray=[derErgebnisDic objectForKey:@"ergebnisdicarray"];
		if (tempErgebnisDicArray&&[tempErgebnisDicArray count]) //tempErgebnisDicArray schon vorhanden
		{
			//NSLog(@"tempErgebnisDicArray: %@",[tempErgebnisDicArray description]);
			if (!Statistik)
			{
				//NSLog(@"init Statistik");
				Statistik=[[rStatistik alloc]init];
			}
			NSModalSession StatistikSession=[NSApp beginModalSessionForWindow:[Statistik window]];
			//Array der vorhandenen Tests
			
			[Statistik setBenutzer:derName];
			
			[Statistik setStatistikDicArray:[tempErgebnisDicArray copy]];
			NSMutableArray* TestNamenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
			NSArray* tempTestArray=[PListDic objectForKey:@"testarray"];
			if (tempTestArray && [tempTestArray count])
			{
				NSEnumerator* TestEnum=[tempTestArray objectEnumerator];
				id einTest;
				while(einTest=[TestEnum nextObject])
				{
					if ([[einTest objectForKey:@"aktiv"]boolValue])
					{
						if ([[einTest objectForKey:@"testname"] length])
						{
							[TestNamenArray addObject:[einTest objectForKey:@"testname"]];
						}
					}//if aktiv
				}//while
			}
			
			
			[Statistik setTestPopMitStringArray:TestNamenArray];
			
			[Statistik setAdminOK:NO];
			
			if ([[tempErgebnisDicArray valueForKey:@"testname"]containsObject:[TestPopKnopf titleOfSelectedItem]])
			{
				//NSLog(@"Test da: Name: %@",[TestPopKnopf titleOfSelectedItem]);
				[Statistik setTableVonTest:[TestPopKnopf titleOfSelectedItem]];
			}
			else
			{
				NSLog(@"Test nicht da: Name: %@",[TestPopKnopf titleOfSelectedItem]);
			}
			
			if ([derErgebnisDic objectForKey:@"timeout"])
			{
				[Statistik setStatistikTimerMitIntervall:[[derErgebnisDic objectForKey:@"timeout"]floatValue]
												 mitInfo:@"Diplom"];//Timer beendet Statistik mit antwort 2: Namen resetten 
			}
			
			
			if (Statistik)
			{
				//			[Statistik showWindow:NULL];
			}
			int modalAntwort = [NSApp runModalForWindow:[Statistik window]];
			
			[NSApp endModalSession:StatistikSession];
			NSLog(@"showStatistikFor	modalAntwort: %d",modalAntwort);
			if (modalAntwort==-1001)
			{
			if([NamenPopKnopf indexOfSelectedItem])
			{
			[self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
			}
				[NamenPopKnopf selectItemAtIndex:0];
				[ErgebnisseTaste setEnabled:NO];
				[self neueSerie:NULL];
				
			}
			else
			{
				[ErgebnisseTaste setEnabled:NO];
				[self neueSerie:NULL];
				[self startTimeout];
			}
			NSLog(@"showStatistikFor			nach Statistik endModalSession: reset Namen");
			
			
			
			
		}
	}
	
}

- (IBAction)updateUserdaten:(id)sender
{
	NSLog(@"updateUserdaten");
	NSMutableArray* tempOldNamenDicArray=(NSMutableArray*)[PListDic objectForKey:@"namendicarray"];
	//NSLog(@"showAdminStatistik	tempOldNamenDicArray: %@",[tempOldNamenDicArray description]);
	NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
	//NSLog(@"showAdminStatistik	tempNamenDicArray: %@",[tempNamenDicArray description]);
	if (tempNamenDicArray && tempOldNamenDicArray )
	{
	NSArray* NamenArray=[tempNamenDicArray valueForKey:@"name"];
	NSLog(@"NamenArray: %@",[NamenArray description]);//Neue Namen
	
	NSEnumerator* OldEnum=[tempOldNamenDicArray objectEnumerator];
	id einObjekt;
	while (einObjekt=[OldEnum nextObject])
	{
		NSLog(@"Name: %@",[einObjekt objectForKey:@"name"]);
		NSMutableDictionary* tempDictionary=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		[tempDictionary setObject:[einObjekt objectForKey:@"name"] forKey:@"name"];
		if ([einObjekt objectForKey:@"ergebnisdicarray"])
		{
		[tempDictionary setObject:[einObjekt objectForKey:@"ergebnisdicarray"] forKey:@"ergebnisdicarray"];
		}
		[tempDictionary setObject:[TestPopKnopf titleOfSelectedItem] forKey:@"lasttest"];
		[tempDictionary setObject:[NSNumber numberWithFloat:[VolumeSchieber floatValue]] forKey:@"lastvolume"];
		[tempDictionary setObject:[NSNumber numberWithInt:1] forKey:@"aktiv"];
		//[tempDictionary setObject:[NSDate date] forKey:@"lastdate"];
		BOOL OK=[Utils setDatenDic:tempDictionary forUser:[einObjekt objectForKey:@"name"] anPfad:SndCalcPfad];
	}//while

	}//if
}

/*
- (IBAction)updateUserdaten:(id)sender
{
NSLog(@"updateUserdaten");
	NSMutableArray* tempOldNamenDicArray=(NSMutableArray*)[PListDic objectForKey:@"namendicarray"];
	//NSLog(@"showAdminStatistik	tempOldNamenDicArray: %@",[tempOldNamenDicArray description]);
	NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
	//NSLog(@"showAdminStatistik	tempNamenDicArray: %@",[tempNamenDicArray description]);
	if (tempNamenDicArray && tempOldNamenDicArray )
	{
	NSArray* NamenArray=[tempNamenDicArray valueForKey:@"name"];
	NSLog(@"NamenArray: %@",[NamenArray description]);//Neue Namen
	
	NSEnumerator* OldEnum=[tempOldNamenDicArray objectEnumerator];
	id einObjekt;
	while (einObjekt=[OldEnum nextObject])
	{
		NSLog(@"Name: %@",[einObjekt objectForKey:@"name"]);
		if ([NamenArray containsObject:[einObjekt objectForKey:@"name"]])//es hat alte Daten zu diesem Namen
		{
		int index=[NamenArray indexOfObject:[einObjekt objectForKey:@"name"]];//index im neuen Array
		NSLog(@"name: %@ index: %d",[einObjekt objectForKey:@"name"],index);
		NSLog(@"ErgebnisDic Old: %@",[[einObjekt valueForKey:@"ergebnisdicarray"]description]);
		if ([[einObjekt valueForKey:@"ergebnisdicarray"]count])//es hat Daten
		{
		
		}//if count
		}
	}//while

	}//if
}
*/


- (void)showAdminStatistik:(id)sender
{
	[self closeSessionDrawer:NULL];
	if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
	{
	[self stopTimeout];
	[self stopAdminTimeout];
	NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
	//Array mit DatenDics aus den Ordnern auf der HD
	//NSLog(@"showAdminStatistik	tempNamenDicArray: %@",[tempNamenDicArray description]);
	if (tempNamenDicArray)
	{
		[tempNamenDicArray retain];
		
		
		//NSLog(@"tempNamenDicArray: %@",[tempNamenDicArray description]);
		if (!Statistik)
		{
				//NSLog(@"init Statistik");
				Statistik=[[rStatistik alloc]init];
		}
		NSModalSession StatistikSession=[NSApp beginModalSessionForWindow:[Statistik window]];

		[Statistik setAdminStatistikDicArray:tempNamenDicArray mitSessionDatum:SessionDatum];//DatenDic in Statistik setzen
		
		//NSArray* AdminTestNamenArray=[[PListDic objectForKey:@"testarray"]valueForKey:@"testname"];
		//Namen der Tests
		//NSLog(@"showAdminStatistik	TestNamenArray: %@",[AdminTestNamenArray description]);
		//[AdminTestNamenArray retain];
				
		NSMutableArray* AdminTestNamenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		NSEnumerator* TestEnum=[[PListDic objectForKey:@"testarray"] objectEnumerator];
		id einTestDic;
		while(einTestDic =[TestEnum nextObject])
		{
			if([[einTestDic objectForKey:@"aktiv"]boolValue])
			{
			if ([[einTestDic objectForKey:@"testname"] length])
			{
			[AdminTestNamenArray addObject:[einTestDic objectForKey:@"testname"]];
			}
			}//if aktiv
		}//while
		

		[AdminTestNamenArray retain];
		[Statistik setAdminTestNamenPop:AdminTestNamenArray];//Testnamen in Pop setzen
		[Statistik setAdminTestTableForTest:[TestPopKnopf titleOfSelectedItem]];
		[Statistik setAdminOK:YES];
		//NSLog(@"tempNamenDicArray: %@",[tempNamenDicArray description]);
		
		//Testnamen in Statistik setzen
		
//		[Statistik setTestPopForAdminMitStringArray:AdminTestNamenArray];

		//StatistikTable laden für Ausgewählten Rechner
		//NSArray* tempNamenArray=[tempNamenDicArray valueForKey:@"name"];//Namenarray der Rechner
		
		NSMutableArray* tempNamenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		NSEnumerator* NamenEnum=[tempNamenDicArray objectEnumerator];
		id einNamenDic;
		while(einNamenDic =[NamenEnum nextObject])
		{
			if([[einNamenDic objectForKey:@"aktiv"]boolValue])
			{
				[tempNamenArray addObject:[einNamenDic objectForKey:@"name"]];
			}//if aktiv
		}//while
		//NSLog(@"showAdminStatistik	tempNamenArray: %@",[tempNamenArray description]);
		
		if (tempNamenArray)//Es hat Namen
		{
		[Statistik setBenutzerPop: tempNamenArray];//Benutzer in NamenPop setzen
		int namenIndex=[tempNamenArray indexOfObject:[NamenPopKnopf titleOfSelectedItem]];
		if ((namenIndex<NSNotFound) &&!(namenIndex==NSNotFound))//Name ist vorhanden
		{
			
			NSArray* tempErgebnisDicArray=[[tempNamenDicArray objectAtIndex:namenIndex]objectForKey:@"ergebnisdicarray"];
			if (tempErgebnisDicArray && [tempErgebnisDicArray count]) //tempErgebnisDicArray schon vorhanden
			{
				//Array der vorhandenen Tests
				[Statistik setStatistikDicArray:[tempErgebnisDicArray copy]];
				
			if ([NamenPopKnopf indexOfSelectedItem])//nicht Gast
				{
				[Statistik selectBenutzer:[NamenPopKnopf titleOfSelectedItem]];
				
				}

				//if (([ModusOption selectedRow]==0)&&Status)//nicht Training und nicht Gast
				{
					if ([[tempErgebnisDicArray valueForKey:@"testname"]containsObject:[TestPopKnopf titleOfSelectedItem]])
					{
						//NSLog(@"Test da");
						[Statistik setTableVonTest:[TestPopKnopf titleOfSelectedItem]];
					}
				}
				//NSLog(@"TestNamenArray: %@",[TestPopKnopf itemArray]);
				//[Statistik setTestPop:[TestPopKnopf itemArray]];
				

				if ([ModusOption selectedRow]==0)//nicht: Training
				{
					//[Statistik setTableVonTest:[TestPopKnopf titleOfSelectedItem]];
				}
				else
				{
					//[Statistik setTableVonTest:[[TestPopKnopf itemAtIndex:1]title]];
				}

			}
			/*
			else
			{
				NSLog(@"Noch keine Ergebnisse fuer: %@",[NamenPopKnopf titleOfSelectedItem]);
				NSAlert* OrdnerWarnung=[[NSAlert alloc]init];
				NSString* t=NSLocalizedString(@"No Results",@"Keine Ergebnisse");
				NSString* i1=NSLocalizedString(@"You have not yet passed a test.",@"Du hast noch keinen Test bestanden.");
				NSString* b1=@"OK";
				[OrdnerWarnung addButtonWithTitle:b1];
				[OrdnerWarnung setMessageText:t];
				[OrdnerWarnung setInformativeText:i1];
				
				int modalAntwort=[OrdnerWarnung runModal];
				return;
			}
			*/
		}//if Namenindex
		else
		{
		//NSLog(@"Kein Rechner ausgewählt");
		
		[Statistik setTableVonTest:[TestPopKnopf titleOfSelectedItem]];

		}
		
	//
		int modalAntwort = [NSApp runModalForWindow:[Statistik window]];
				
				
				NSLog(@"showStatistik: Antwort: %d",modalAntwort);
				switch (modalAntwort)
				{
					case 0://Abbrechen
					{
						
					}break;
					case 1://Schliessen
					{
						[[Statistik window]orderOut:NULL];
						
						//Wirkung ??
						//[[self window]makeKeyAndOrderFront:NULL];
						
						//[[self window]makeFirstResponder: self];
					}break;
						
				}//switch
				
				[NSApp endModalSession:StatistikSession];
				
	
	//	
		
			}
			
	}
	[self startAdminTimeout];
	
	}//if checkAdminZugang
}

- (IBAction)neuerTest:(id)sender
{
//	if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
{

[self openDrawer:NULL];





}//if AdminPW
}


- (void)showTestPanel:(id)sender
{
	[self closeSessionDrawer:NULL];


//	if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout


	{
		[self stopTimeout];
		if (!TestPanel)
		{
			//NSLog(@"init TestPanel");
			TestPanel=[[rTestPanel alloc]init];
			
		}
		[TestPanel retain];
		//NSLog(@"TestPanel window: %d",[[TestPanel window] description]);
		[self stopAdminTimeout];
		
		//NSLog(@"TestPanel retainCount: %d",[TestPanel retainCount]);
		//NSLog(@"PListDic retainCount: %d",[PListDic retainCount]);
		//NSLog(@"showTestPanel vor TestSession");
//		NSModalSession TestLauf=[NSApp beginModalSessionForWindow:[TestPanel window]];
//		NSLog(@"showTestPanel nach TestSession");
		//Array der vorhandenen Tests
		NSMutableArray* TestDicArray;
		if ([PListDic objectForKey:@"testarray"])
		{
//			NSLog(@"showTestPanel	PListDic objectForKey: testarray : %@",[[PListDic objectForKey:@"testarray"] description]);
			TestDicArray=[[PListDic objectForKey:@"testarray"]mutableCopy];
			[TestDicArray retain];
			//NSLog(@"TestDicArray retainCount: %d",[TestDicArray retainCount]);
			//NSLog(@"showTestPanel	TestDicArray : %@",[TestDicArray description]);
			[TestPanel setTestDicArray:TestDicArray];
			
			if (Modus==kTrainingModus)
			{	
				[TestPanel setAnzahlItems:[AnzahlPopKnopf itemTitles] mitItem:[AnzahlPopKnopf indexOfSelectedItem]];	
			}
			else
			{
				[TestPanel setAnzahlItems:[AnzahlPopKnopf itemTitles] mitItem:0];	
			}
			
			
			
			if (Modus==kTrainingModus)
			{	
				[TestPanel setZeitItems:[ZeitPopKnopf itemTitles] mitItem:[ZeitPopKnopf indexOfSelectedItem]];	
			}
			else
			{
				[TestPanel setZeitItems:[ZeitPopKnopf itemTitles] mitItem:0];	
			}
			
		}
		
		else
		{
			NSLog(@"showTestPanel	kein testarray");
			TestDicArray=[[NSMutableArray alloc]initWithCapacity:0];
			[TestDicArray retain];
			[PListDic setObject:TestDicArray forKey:@"testarray"];
		}
//		NSLog(@"showTestPanel nach TestDicArray");
		[TestPanel resetTestTabFeld];
		NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
		[tempNamenDicArray retain];
		[TestPanel setNamenDicArray:tempNamenDicArray];
		NSLog(@"showTestPanel nach setNamenDicArray");
		NSString* tempName=[[tempNamenDicArray objectAtIndex:0]objectForKey:@"name"];
		NSLog(@" %@",tempName);
		[TestPanel setNamenWahlTasteMitNamen:tempName];//ersten Namen auswaehlen
		NSLog(@"showTestPanel nach setNamenWahlTasteMitNamen");
		[TestPanel setTestWahlTasteMitTest:NULL];//ersten Namen auswaehlen
		NSLog(@"showTestPanel nach setTestWahlTasteMitTest");
		//	int modalAntwort = [NSApp runModalForWindow:[TestPanel window]];

//		NSModalSession TestLauf=[NSApp beginModalSessionForWindow:[TestPanel window]];

		int modalAntwort=0;
//		modalAntwort=[NSApp runModalForWindow:[TestPanel window]];
		[TestPanel showWindow:NULL];
		[[TestPanel window] makeKeyAndOrderFront:NULL];

//		[NSApp endModalSession:TestLauf];

//		[self startTimeout];
		
	}//passwort
}

- (void)updateTestPanel
{
		NSArray* tempNamenDicArray=[Utils NamenDicArrayAnPfad:SndCalcPfad];
		[tempNamenDicArray retain];
		[TestPanel setNamenDicArray:tempNamenDicArray];
		NSArray* tempTestDicArray=[Utils TestArrayAusPListAnPfad:SndCalcPfad];
		[tempTestDicArray retain];
		NSLog(@"showTestPanel \n\n\n********************************");
		NSLog(@"showTestPanel	tempTestDicArray : %@",[tempTestDicArray description]);
		
		[TestPanel setTestDicArray:tempTestDicArray];
		NSLog(@"updateTestPanel nach setTestDicArray");
		NSLog(@"updateTestPanel end");

}


- (void)NeuerTestnameAktion:(NSNotification*)note
{
	NSLog(@"NeuerTestnameAktion: note: %@",[[note userInfo]description]);
	
	[self closeDrawer:NULL];
	
	NSMutableArray* TestDicArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	[TestDicArray setArray:[TestPanel TestDicArray]];

	//NSLog(@"\n\n				NeuerTestnameAktion		TestDicArray: %@",[TestDicArray description]);

	NSMutableDictionary* neuerTestDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	if ([[note userInfo]objectForKey:@"aktion"])
	{
	
		int aktionCode=[[[note userInfo]objectForKey:@"aktion"]intValue];
		switch (aktionCode)
		{
			case 0://cancel
			{
				NSLog(@"TestnameAktion Cancel");
			}break;
			case 1://Neuer Testname
			{
				//NSLog(@"neuerTestnameAktion	nach	Close");
				Modus=kTestModus;
				[ModusOption selectCellAtRow:0 column:0];
				[AnzahlPopKnopf setEnabled:NO];
				[ZeitPopKnopf setEnabled:NO];
				//[SettingsPfeil setEnabled: NO];
				[SettingsDrawer close:NULL];
				
				
				if ([[[note userInfo]objectForKey:@"testname"]length])
				{
					NSLog(@"neuer Name da: %@",[[note userInfo]objectForKey:@"testname"]);
					//[neuerTestDic addEntriesFromDictionary:[TestPanel neuerTestNamenDic]];//Name und 'aktiv'
					[neuerTestDic setObject:[[note userInfo]objectForKey:@"testname"]forKey:@"testname"];
					[neuerTestDic setObject:[[note userInfo]objectForKey:@"aktiv"]forKey:@"aktiv"];
					[neuerTestDic setObject:[[note userInfo]objectForKey:@"alle"]forKey:@"alle"];
					//Daten aus den Settings anfügen
					NSMutableDictionary* neuerSerieDatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
					[neuerSerieDatenDic addEntriesFromDictionary:[self SerieDatenDicAusSettings]];//Dic aus momentanen Settings
					[neuerSerieDatenDic setObject:[[note userInfo]objectForKey:@"anzahlaufgaben"]forKey:@"anzahlaufgaben"];//aus TestPanel
					[neuerTestDic setObject:[[note userInfo]objectForKey:@"anzahlaufgaben"]forKey:@"anzahlaufgaben"];//aus TestPanel
					
					[neuerSerieDatenDic setObject:[[note userInfo]objectForKey:@"zeit"]forKey:@"zeit"];//aus TestPanel
				
					[neuerTestDic setObject:[[note userInfo]objectForKey:@"zeit"]forKey:@"zeit"];//aus TestPanel
//					[neuerSerieDatenDic setObject:[ZeitPopTaste titleOfSelectedItem]forKey:@"zeit"];//aus TestPanel

					[neuerTestDic setObject:neuerSerieDatenDic forKey:@"seriedatendic"];
//					NSLog(@"TestPanel neuerTestDic: %@nn",[neuerTestDic description]);
					
					int DoppelIndex=[[TestDicArray valueForKey:@"testname"]indexOfObject:[neuerTestDic objectForKey:@"testname"]];
					if (DoppelIndex==NSNotFound)//Test noch nicht da
					{
						[TestDicArray addObject:neuerTestDic];
						//NSLog(@"TestPanel antwort: TestDicArray: %@",[TestDicArray description]);
					}
					else
					{
						NSLog(@"replaceObjectAtIndex: %d",DoppelIndex);
						[TestDicArray replaceObjectAtIndex:DoppelIndex withObject:neuerTestDic];
					}
					
								
				}//if name length
				
				//NSLog(@"NeuerTestnameAktion:	PListDic		TestDicArray: %@  ",[TestDicArray description]);
				[PListDic setObject:TestDicArray forKey:@"testarray"];
				
				[Utils saveTestArray:TestDicArray anPfad:SndCalcPfad];
				
				[self setTestPopKnopfMitArray:TestDicArray];
	//			[TestPopKnopf setEnabled: YES];
				
				if ([[neuerTestDic objectForKey:@"testname"]length])
				{
					[TestPopKnopf selectItemWithTitle:[neuerTestDic objectForKey:@"testname"]];
					[self setTestVonTestname:[neuerTestDic objectForKey:@"testname"]];
					SerieDaten=[self SerieDatenVonDic:neuerTestDic];
				}
				else
				{
					[self setTestVonTestname:[TestPopKnopf titleOfSelectedItem]];
				}
			}break;//case 1
		}//switch aktionCode
		
		[TestPanel setTestDicArray:TestDicArray];
		NSLog(@"NeuerTestNameAktion nach setTestDicArray");
		if ([[[note userInfo]objectForKey:@"alle"]intValue])
		{
		// Wenn forAll gesetzt ist, in Testpanel for All einsetzen
		[Utils setTestForAll:[[note userInfo]objectForKey:@"testname"] nurAktiveUser:YES anPfad:SndCalcPfad];
		//NamenDicArray neu setzen
		NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
//		[tempNamenDicArray retain];
		[TestPanel setNamenDicArray:tempNamenDicArray];

		}
			
			
	}//aktion
		
//		[self startAdminTimeout];
	
}

- (void)TestBearbeitenAktion:(NSNotification*)note
{
//	NSLog(@"TestBearbeitenAktion: note: %@",[[note userInfo]description]);
	NSDictionary* tempSeriedatenDic;
	if ([[note userInfo]objectForKey:@"testname"])
	{
		[self openDrawer:NULL];
		NSString* tempTestname=[[note userInfo]objectForKey:@"testname"];
		NSArray* tempTestArray=[PListDic objectForKey:@"testarray"];
		if (tempTestArray)
		{
		NSArray* tempTestnamenArray=[tempTestArray valueForKey:@"testname"];
		int index=[tempTestnamenArray indexOfObject:tempTestname];
		if (index<NSNotFound)
		{
			tempSeriedatenDic=[[tempTestArray objectAtIndex:index]objectForKey:@"seriedatendic"];
		}//Testname da
		
		
		}

		
		
		[self setSettingsMitDic:tempSeriedatenDic];
	}
	if ([[note userInfo]objectForKey:@"namenschreiben"])
	{
		[self openDrawer:NULL];
	}
	[TestPanel setZeitItems:[ZeitPopKnopf itemTitles] mitItem:0];
	[TestPanel setAnzahlItems:[AnzahlPopKnopf itemTitles] mitItem:0];
}


- (void)TestResetAktion:(NSNotification*)note
{

//Nicht verwendet
	NSLog(@"TestResetAktion");
	[NamenPopKnopf selectItemAtIndex:0];
	[ErgebnisseTaste setEnabled:NO];
	[self neueSerie:NULL];

}


- (void)UserTestArrayChangedAktion:(NSNotification*)note
{
	//Setzen des Tests im usertestarray des users
	NSLog(@"UserTestArrayChangedAktion: note: %@",[[note userInfo]description]);
	
	NSString* tempUserName=[[note userInfo]objectForKey:@"username"];
	if (tempUserName)
	{
		NSString* tempTestName=[[note userInfo]objectForKey:@"testname"];
		if (tempTestName)
		{
			if ([[note userInfo]objectForKey:@"usertestok"])
			{
				//note gibt den BISHERIGEN Status der Checkbox aus
				BOOL neuerStatus=[[[note userInfo]objectForKey:@"usertestok"]intValue]==0;//
				if (neuerStatus)
				{
					NSLog(@"UserTestArrayChangedAktion setTest: tempTestName: %@ forUser: %@",tempTestName,tempUserName);
					[Utils setTestInUserTestArray:tempTestName forUser:tempUserName anPfad:SndCalcPfad];
				}
				else
				{
					//NSLog(@"UserTestArrayChangedAktion clearTest: tempTestName: %@ forUser: %@",tempTestName,tempUserName);
					[Utils deleteTestInUserTestArray:tempTestName forUser:tempUserName anPfad:SndCalcPfad];
				}
			}
		
		//NamenDicArray updaten
		[self updatePList];
		NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
		[tempNamenDicArray retain];
//			NSLog(@"\n\n      UserTestArrayChangedAktion     tempNamenDicArray: %@\n\n",[tempNamenDicArray description]);

		[TestPanel setNamenDicArray:tempNamenDicArray];
//		[TestPanel setNamenWahlTasteMitNamen:tempUserName];
		[TestPanel setTestZuNamenDSForUser:tempUserName];
		[TestPanel setNamenZuTestDSForTest:tempTestName];

//		[self updateTestPanel];
		}//if temptestname
	}//if username
	
}


- (void)NeuerUserTestArrayAktion:(NSNotification*)note
{
//Update der Einstellungen für zugeteilte Tests in UserData
NSLog(@"NeuerUserTestArrayAktion: note: %@",[[note userInfo]description]);
NSString* tempUser=[[note userInfo]objectForKey:@"user"];
if (tempUser)
{
	//NSLog(@"user: %@",tempUser);
	
	NSArray* tempUserTestArray=[[note userInfo] objectForKey:@"usertestarray"];
	if (tempUserTestArray)
	{
//		NSLog(@"userTestArray: %@",tempUserTestArray);
		[Utils saveUserTestArray:tempUserTestArray forUser:tempUser anPfad:SndCalcPfad];
	}
	
}//if tempuser
}


- (void)setTestForAllAktion:(NSNotification*)note
{
	//Setzen eines Tests in UserData > usertestarray für alle User
	NSLog(@"setTestForAllAktion: note: %@",[[note userInfo]description]);
	NSString* tempTestName=[[note userInfo]objectForKey:@"testforall"];
	if (tempTestName)
	{
		NSLog(@"setTestForAllAktion: tempTestName: %@",tempTestName);
		[Utils setTestForAll:tempTestName nurAktiveUser:YES anPfad:SndCalcPfad];
		[Utils setAlle:YES forTest:tempTestName anPfad:SndCalcPfad];
		NSLog(@"vor updateTestPanel");
	//	

		NSArray* tempTestDicArray=[Utils TestArrayAusPListAnPfad:SndCalcPfad];
		[tempTestDicArray retain];
//		NSLog(@"	setTestForAllAktion  tempTestDicArray nach set: %@d",[tempTestDicArray description]);
		[self updatePList];
		[TestPanel updateTestDicArrayMitArray:tempTestDicArray];

		//NSLog(@"setTestForAllAktion  nach updateTestDicArrayMitArray");


		NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
		[tempNamenDicArray retain];
		[TestPanel setNamenDicArray:tempNamenDicArray];
		
//		[self updateTestPanel];

	}//if tempuser
}


- (void)ClearTestForAllAktion:(NSNotification*)note
{
	//Entfernen eines Tests in UserData > usertestarray für alle User
	NSLog(@"ClearTestForAllAktion: note: %@",[[note userInfo]description]);
	NSString* tempTestName=[[note userInfo]objectForKey:@"testforall"];
	if (tempTestName)
	{
		//NSLog(@"clearTestForAllAktion: tempTestName: %@",tempTestName);
		[Utils clearTestForAll:tempTestName nurAktiveUser:YES anPfad:SndCalcPfad];
		[Utils setAlle:NO forTest:tempTestName anPfad:SndCalcPfad];
//		[self updateTestPanel];

		NSArray* tempTestDicArray=[Utils TestArrayAusPListAnPfad:SndCalcPfad];
//		NSLog(@"clearTestForAllAktion  tempTestDicArray retainCount: %d",[tempTestDicArray retainCount]);
		
//		NSLog(@"clearTestForAllAktion  TestPanel retainCount: %d",[TestPanel retainCount]);
		
//		 retainCount]);
//		NSArray* tempTestDicArray=[PListDic objectForKey:@"testarray"];
		NSLog(@"clearTestForAllAktion  tempTestDicArray: %@d",[tempTestDicArray description]);
		[tempTestDicArray retain];
//		[TestPanel setTestDicArray:tempTestDicArray];
		[self updatePList];
		[TestPanel updateTestDicArrayMitArray:tempTestDicArray];


		NSLog(@"													clearTestForAllAktion  nach setTestDicArray");


		NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
		[tempNamenDicArray retain];
		[TestPanel setNamenDicArray:tempNamenDicArray];

	}//if tempuser
}

- (void)TestAktivAktion:(NSNotification*)note
{

	//Setzen des Aktiv-Bits
	NSLog(@"TestAktivAktion: note: %@",[[note userInfo]description]);
	NSString* tempTestName=[[note userInfo]objectForKey:@"testname"];
	if (tempTestName)
	{
		int derStatus=[[[note userInfo]objectForKey:@"aktiv"]intValue];
		BOOL aktivStatus=(derStatus==1);//alter Status
		NSLog(@"TestAktivAktion: tempTestName: %@",tempTestName);
		[Utils setAktivInPList:[NSNumber numberWithBool:(!aktivStatus)] forTest:tempTestName anPfad:SndCalcPfad];
		
		[self updatePList];
		
		NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
		[tempNamenDicArray retain];
		[TestPanel setNamenDicArray:tempNamenDicArray];
//***

//		[self updateTestPanel];
//return;
//
		NSLog(@"TestAktivAktion: tempTestName: nach UpdateTestPanel");
		NSMutableArray* TestDicArray;
		if ([PListDic objectForKey:@"testarray"])
		{
//			NSLog(@"TestAktivAktion	PListDic objectForKey: testarray : %@",[[PListDic objectForKey:@"testarray"] description]);
			
//16.8.		TestDicArray=(NSMutableArray*)[PListDic objectForKey:@"testarray"];
			TestDicArray=[[PListDic objectForKey:@"testarray"]mutableCopy];
			[TestDicArray retain];
//			[self setTestPopKnopfForUser:[NamenPopKnopf titleOfSelectedItem]];
			NSLog(@"TestAktivAktion	TestDicArray : %@",[TestDicArray description]);
			[TestPanel updateTestDaten:TestDicArray];
			NSLog(@"TestAktivAktion: tempTestName: nach updateTestDaten");
			
		}
	}//if tempuser
	NSLog(@"TestAktivAktion: END");
}



//////////
//
// goToBeginning
//
// Called when the go to beginning button is pressed
// We call the NSMovieView gotoBeginning method here
// to go to the beginning of the movie
//
//////////

- (IBAction)goToBeginning:(id)sender
{
    /* save current movie state */
    [self saveCurrentMoviePlayingState];
    
    /* go to the beginning of the movie */
    [movieViewObject gotoBeginning:sender];
    
    /* restore movie state */
    [self restoreMoviePlayingState:sender];
}

//////////
//
// goToEnd
//
// Called when the go to beginning button is pressed
// We call the NSMovieView goToEnd method here to go
// to the end of the movie
//
//////////

- (IBAction)goToEnd:(id)sender
{
    /* go to the end of the movie */
    [movieViewObject gotoEnd:sender];
}


//////////
//
// play
//
// Called when the play button is pressed.
// We call the NSMovieView start method to
// play the movie
//
//////////

- (IBAction)play:(id)sender
{
    /* has the movie just finished playing? */
    if (IsMovieDone(gMovie))
    {
        /* yes, so go to the beginning */
        [movieViewObject gotoBeginning:sender];
    }

    /* is the movie currently playing? */
    if ([movieViewObject isPlaying])
    {
        /* yes, so stop it */
        [movieViewObject stop:sender];
    }
    else	/* movie is not currently playing */
    {
        /* go ahead and start it playing */
        [movieViewObject start:sender];
    }
    
    /* change the button text to "pause" */
    [sender setTitle:@"||"];
    
    /* set the button action method so the next
        time it is invoked, our "stop" method
        will instead be called */
    [sender setAction:@selector(stop:)];
}


//////////
//
// stop
//
// Called when the stop button is pressed.
// We call the NSMovieView stop method to
// stop the movie
//
//////////

- (IBAction)stop:(id)sender
{
    /* stop the movie */
    [movieViewObject stop:sender];
    /* adjust the play button state */
    [self resetPlayButtonForMovieStopState:sender];
}

//////////
//
// setVolume
//
// Called when the volume slider is pressed.
// We call the Movie toolbox SetMovieVolume
// function method to adjust the movie volume.
//
//////////

- (IBAction)setVolume:(id)sender
{
    /* set the movie volume to correspond to the
        current value of the slider */
   // SetMovieVolume([[movieViewObject movie] QTMovie],[setVolumeSlider floatValue]);
   [Speaker setVolume:[sender floatValue]];
   Volume=[sender floatValue];
   //[self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
  // NSLog(@"setVolume: Volume: %f",Volume);
}

//////////
//
// stepBack
//
// Called when the step-back button is pressed.
// We call the NSMovieView function setpBack
// to step the movie.
//
//////////

- (IBAction)stepBack:(id)sender
{
    /* save the current movie play state */
    [self saveCurrentMoviePlayingState];

    /* step the movie back */
    [movieViewObject stepBack:sender];

    /* restore the movie play state */
    [self restoreMoviePlayingState:sender];
}

//////////
//
// stepForward
//
// Called when the step-forward button is pressed.
// We call the NSMovieView function stepForward
// to step the movie.
//
//////////

- (IBAction)stepForward:(id)sender
{
    /* has the movie just finished playing? */
    if (IsMovieDone(gMovie))
    {
        /* yes, so go to beginning */
        GoToBeginningOfMovie(gMovie);
    }

    /* save the current play state */
    [self saveCurrentMoviePlayingState];

    /* step the movie forward */
    [movieViewObject stepForward:sender];

    /* restore the movie play state */
    [self restoreMoviePlayingState:sender];
}

//////////
//
// resetPlayButtonForMovieStopState
//
// This method adjusts the play button text
// and action method so the next time it
// is pressed the "play" method is invoked
//
//////////

- (void)resetPlayButtonForMovieStopState:(id)sender
{
    /* reset button text to "play" text */
    [playButton setTitle:@">"];
    /* reset button action method to our "play" method
        so the next time the button is pressed this
        method will instead be invoked */
    [playButton setAction:@selector(play:)];

}

//////////
//
// showTheWindow
//
// This method is used to make a window
// visible and bring it to the front
//
//////////

- (void)showTheWindow:(NSWindow *)window
{
    /* is the window visible? */
    if (![window isVisible])
    {
        /* window is not visible, so let's make it visible */
        [window setFrame:[window frame] display:YES];
    }
    /* make the window accept keys, and make it the
        front window */
    [window makeKeyAndOrderFront:menuItem_New];

}

//////////
//
// movieProperties
//
// Called when the Properties menu item in the Movie
// menu is selected. We use the NSWindow class methods
// to show the movie properties window.
//
//////////

- (IBAction)movieProperties:(id)sender
{
    /* display the movie properties window */
    [self showTheWindow:moviePropertiesWindow];
}

//////////
//
// newWindow
//
// Called when the "New" menu item in the file
// menu is selected. We simply display the 
// window by making it visible and bringing it
// to the front.
//
//////////

- (IBAction)newWindow:(id)sender
{
    [self showTheWindow:movieWindow];
}

//////////
//
// awakeFromNib
//
// Called after all our objects are unarchived and
// connected but just before the interface is made visible
// to the user. We will do custom initialization of our
// objects here.   
//
//////////

- (void)setStartSerieDaten
{
SerieDaten.AnzahlReihen=0;
SerieDaten.AnzahlAufgaben=kMaxAnzahlAufgaben;
//Reihenliste=new short[kMaxAnzahlReihen];
for (short i=0;i<kMaxAnzahlReihen;i++)
	{SerieDaten.Reihenliste[i]=0;}
SerieDaten.ASBereich =kBisZehn;
SerieDaten.ASBereich=kZehnbisZwanzig;
SerieDaten.ASBereich=kZweistellig;
SerieDaten.ASzweiteZahl=kBisZehn;
SerieDaten.ASzweiteZahl=kZehnbisZwanzig;
SerieDaten.ASZehnerU=kImmer;

}



- (void)windowDidLoad
{
NSLog(@"windowDidLoad");
[ErgebnisRahmenFeld  lockFocus];
[[NSColor grayColor]set];
NSRect r=[ErgebnisRahmenFeld bounds];
r.origin.x+=2;
r.origin.y+=2;
r.size.width-=4;
r.size.height-=4;
NSBezierPath* RahmenPath=[NSBezierPath bezierPathWithRect:r];
[RahmenPath setLineWidth:3.0];
[RahmenPath stroke];
[ErgebnisRahmenFeld unlockFocus];

}
//////////
//
// setMoviePropertyWindowControlValues
//
// The movie properties window displays miscellaneous
// properties for the movie. Here we setup the values
// for each of the controls in our window.
//
//////////

- (void)setMoviePropertyWindowControlValues:(Movie)qtmovie
{
   /*
	 if (QTUtils_IsAutoPlayMovie (qtmovie))
    {
        [autoPlayEnabled setStringValue:@"Yes"];
    }
    else
    {
        [autoPlayEnabled setStringValue:@"No"];
    }
*/
    [trackCount setIntValue:GetMovieTrackCount(qtmovie)];

    [self buildTrackMediaTypesArray:qtmovie];
        
    //[movieTimeScale setStringValue:GetMovieTimeScaleAsString(qtmovie)];
    //[movieDuration setStringValue:GetMovieDurationAsString(qtmovie)];
}

//////////
//
// tableView
//
// Our movie properties window contains a NSTableView control.
// An NSTableView control must implement the routines
// defined in the NSTableDataSource protocol. This is our
// implementation of the tableView method for populating
// the NSTableView with data items.
//
//////////

- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn
    row:(int)rowIndex
{
    /* turn editing off for each cell */
    [aTableColumn setEditable:NO];
    
    /* populate the list with data from our movie track media types array */
    return ([movieTrackMediaTypesArray objectAtIndex:rowIndex]);
}

//////////
//
// numberOfRowsInTableView
//
// Our movie properties window contains a NSTableView control.
// An NSTableView control must implement the routines
// defined in the NSTableDataSource protocol. This is our
// implementation of the numberOfRowsInTableView method which
// returns a count of the number of data items in the table.
//
//////////

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [movieTrackMediaTypesArray count];
}


//////////
//
// dealloc
//
// Our controller's dealloc method. We'll dispose of
// any objects we created previously.
//
//////////

-(void)dealloc
{
    [movieTrackMediaTypesArray release];
    DisposeCallBack(gQtCallBack);
	[super dealloc];
}

//////////
//
// buildTrackMediaTypesArray
//
// Build an array of track media types for our movie. These
// will be displayed in our NSTableView control in our
// movie properties window.
//
//////////

- (void)buildTrackMediaTypesArray:(Movie)qtmovie
{
    short i;
    
    for (i = 0; i < GetMovieTrackCount(qtmovie); ++i)
    {
		Str255			mediaName;
        OSErr			myErr;
        Track			movieTrack = GetMovieIndTrack(qtmovie, i+1); /* tracks start at index 1 */
        Media			trackMedia = GetTrackMedia(movieTrack);
        MediaHandler	trackMediaHandler = GetMediaHandler(trackMedia);
		
        // get the text of the media type
		myErr = MediaGetName(trackMediaHandler, mediaName, 0, NULL);

        // add the media type string to our array (as an NSString)
        //[movieTrackMediaTypesArray insertObject:[NSString stringWithCString:&mediaName[1] length:mediaName[0]] atIndex:i];
    }

}

//////////
//
// saveCurrentMoviePlayingState
//
// Save the current movie playing state. This is
// necessary because certain operations (step
// forward, etc.) will stop the movie, and we
// want to preserve the state between these
// operations.
//
//////////

- (void)saveCurrentMoviePlayingState
{
    gIsMoviePlaying = [movieViewObject isPlaying];
    gMoviePlaybackRate = [movieViewObject rate];
}

//////////
//
// restoreMoviePlayingState
//
// Restore the current movie playing state. This is
// necessary because certain operations (step
// forward, etc.) will stop the movie, and we
// want to preserve the state between these
// operations.
//
//////////

- (void)restoreMoviePlayingState:(id)sender
{
    if (gIsMoviePlaying)
    {
        [movieViewObject start:sender];
    }
    [movieViewObject setRate:gMoviePlaybackRate];
}

//////////
//
// restoreMoviePlayCompleteCallBack
//
// Once our movie callback is called, QuickTime removes us from the
// callback chain - therefore, we must specify the callback
// again or QuickTime won't call us.
//
//////////

- (void)restoreMoviePlayCompleteCallBack
{
    [self setupMoviePlayingCompleteCallback:gMovie callbackUPP:gMoviePlayingCompleteCallBack];
}

//////////
//
// setupMoviePlayingCompleteCallback
//
// Here we specify QuickTime call us when the movie stops playing. This
// is necessary so we can adjust our play button to the proper settings.
//
//////////

- (void)setupMoviePlayingCompleteCallback:(Movie)theMovie callbackUPP:(QTCallBackUPP) callbackUPP
{
    TimeBase tb = GetMovieTimeBase (theMovie);
    OSErr err = noErr;
    
    gQtCallBack = NewCallBack (tb, callBackAtExtremes);
    if (gQtCallBack != NULL)
    {
        err = CallMeWhen (gQtCallBack, 
                        callbackUPP, 
                        NULL,			/* refCon */
                        triggerAtStop, 	/* flags - call us when stopped */
                        NULL, 			/* param2 - don't care */
                        NULL);			/* param3 - don't care */
    }
}


- (BOOL)GetZahlTrack
{
OSErr err=0;
NSLog(@"GetZahlTrack start");

long anzTracks=GetMovieTrackCount(gMovie);
NSLog(@"anzTracks: %d",anzTracks);
Track gTrack=GetMovieIndTrack(gMovie,1);
err =GetMoviesError();
NSLog(@"GetZahlTrack: err nach  GetMovieIndTrack: %d",err);

//SetTrackOffset(gTrack,4800);
TimeValue Trackdauer=GetTrackDuration(gTrack);
NSLog(@"Trackdauer: %d",Trackdauer);
TimeScale TimeSkala=GetMovieTimeScale(gMovie);
NSLog(@"TimeSkala: %d",TimeSkala);//600
TimeScale MediaSkala=GetMediaTimeScale(GetTrackMedia(gTrack));//22050
NSLog(@"MediaSkala: %d",MediaSkala);

float Dauer=Trackdauer/(float)TimeSkala;
NSLog(@"Dauer: %f",Dauer);

long anzhTracks=GetMovieTrackCount(hMovie);
NSLog(@"anzhTracks: %d",anzhTracks);
Track hTrack=GetMovieIndTrack(hMovie,1);
err =GetMoviesError();
NSLog(@"GetZahlTrack: err nach  GetMovieIndTrack: %d",err);
TimeValue Track2dauer=GetTrackDuration(hTrack);
NSLog(@"Track2dauer: %d",Track2dauer);

//SetTrackOffset(hTrack,2400);

BeginMediaEdits(GetTrackMedia(gTrack));
err=InsertTrackSegment(hTrack,gTrack,0,GetTrackDuration(hTrack),1200);
EndMediaEdits(GetTrackMedia(gTrack));


Movie TestMovie=NewMovie(newMovieActive);
SetMovieGWorld(TestMovie,NULL,NULL);
Track NeuerTrack=GetMovieIndTrack(TestMovie,1);


Track track =NewMovieTrack(gMovie,0,0,kFullVolume);

err =GetMoviesError();
//NSLog(@"GetZahlTrack: err nach  NewMovieTrack: %d",err);

Media media=NewTrackMedia(track, SoundMediaType,600,NULL,NULL);
err =GetMoviesError();
//NSLog(@"GetZahlTrack: err nach  NewTrackMedia: %d",err);

return err;
}

- (void)terminate:(id)sender
{
NSLog(@"terminate");
[self BeendenAktion:NULL];
}

- (void)BeendenAktion:(id)sender
{
[self savePListAktion:nil];

[NSApp terminate:self];
}

- (void)SessionDatumSichernVon:(NSString*)derRechner
{
	NSLog(@"SessionDatumSichernVon: %@",derRechner);
	NSMutableDictionary* tempDic=(NSMutableDictionary*)[[Utils DatenDicForUser:derRechner anPfad:SndCalcPfad]retain] ;
	if (tempDic)
	{
		[[tempDic objectForKey:@"userplist"] setObject:[NSDate date] forKey:@"lastdate"];
		//NSLog(@"tempDic: %@",[tempDic description]);
		[Utils setDatenDic:[tempDic objectForKey:@"userplist"]forUser:derRechner anPfad:SndCalcPfad];
	
	}
	
}

- (IBAction)neueSession:(id)sender
{
	NSLog(@"neueSession");
	if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
	{
	[self stopTimeout];
	[self startAdminTimeout];
	[self closeSessionDrawer:NULL];
	SessionDatum=[[NSDate date]retain];
	BOOL SessionOK=[Utils saveSessionDatum:[NSDate date] anPfad:SndCalcPfad];
	[PListDic setObject:[NSDate date] forKey:@"sessiondatum"];
//	[self setNamenPopKnopfMitDicArray:[Utils NamenDicArrayAnPfad:SndCalcPfad]];
//	[NamenPopKnopf selectItemAtIndex:0];
	}
}



- (IBAction)SessionAktualisieren:(id)sender
{
NSLog(@"SessionAktualisieren");

[self setNamenPopKnopfMitDicArray:[Utils NamenDicArrayAnPfad:SndCalcPfad]];
}



- (void)SerieDatenSichernVon:(NSString*)derRechner
{
	NSLog(@"SerieDatenSichernVon: %@",derRechner);
	NSMutableDictionary* tempDic=(NSMutableDictionary*)[[Utils DatenDicForUser:derRechner anPfad:SndCalcPfad]retain] ;
	if (tempDic)
	{
		if ([TestPopKnopf titleOfSelectedItem] &&[[TestPopKnopf titleOfSelectedItem]length])
		{
		[[tempDic objectForKey:@"userplist"]setObject:[TestPopKnopf titleOfSelectedItem] forKey:@"lasttest"];
		}
		[[tempDic objectForKey:@"userplist"] setObject:[NSNumber numberWithFloat:Volume] forKey:@"lastvolume"];
		//[[tempDic objectForKey:@"userplist"] setObject:[NSDate date] forKey:@"lastdate"];
		//NSLog(@"tempDic: %@",[tempDic description]);
		[Utils setDatenDic:[tempDic objectForKey:@"userplist"]forUser:derRechner anPfad:SndCalcPfad];
	
	}
	
	
	
}

- (void)NotenUpdateAktion:(NSNotification*)note
{
	//NSBeep();
	//NSLog(@"NoteUpdateAktion: userInfo: %@",[[note userInfo]description]);
	NSArray* tempUpdateArray=[[note userInfo]objectForKey:@"updatedicarray"];
	NSEnumerator* UpdateEnum=[tempUpdateArray objectEnumerator];
	id einDic;
	while (einDic=[UpdateEnum nextObject])
	{
		NSString* tempName=[einDic objectForKey:@"name"];
		NSString* tempNote=[einDic objectForKey:@"note"];
		
		//NSBeep();
		//NSLog(@"\nNoteUpdateAktion: tempName: %@	tempNote: %@",tempName,tempNote);
		
		if (tempName && tempNote)
		{
			//NSLog(@"NoteUpdateAktion	saveNote");
			[Utils saveNote:tempNote forUser:tempName anPfad:SndCalcPfad];
		}
		
	}//while
}

- (void)TimeoutTimerFunktion:(NSTimer*)derTimer
{
	//NSLog(@"TimeoutTimerFunktion fire");
		//NSLog(@"TimeoutTimerFunktion fire 1");
	if([NamenPopKnopf indexOfSelectedItem])
	{
	[self SessionDatumSichernVon:[NamenPopKnopf titleOfSelectedItem]];
	[self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
	}
	//NSLog(@"TimeoutTimerFunktion fire 2");
	[NamenPopKnopf selectItemAtIndex:0];
	//NSLog(@"TimeoutTimerFunktion fire 3");
	[ErgebnisseTaste setEnabled:NO];
	//NSLog(@"TimeoutTimerFunktion fire 4");
	[self neueSerie:NULL];
	//NSLog(@"TimeoutTimerFunktion fire end");
}

- (void)startTimeout
{
	//NSLog(@"startTimeout");
	if ([TimeoutTimer isValid])
	{
	//NSLog(@"AufgabeFertigAktion AblaufzeitTimer invalidate");
	[TimeoutTimer invalidate];
	}
	TimeoutTimer=[[NSTimer scheduledTimerWithTimeInterval:10.0 
													  target:self 
													selector:@selector(TimeoutTimerFunktion:) 
													userInfo:nil 
													 repeats:NO]retain];

}

- (void)stopTimeout
{
	if ([TimeoutTimer isValid])
	{
		[TimeoutTimer invalidate];
	}
}


- (void)TerminateTimeoutFunktion:(NSTimer*)derTimer
{
NSLog(@"TerminateTimeoutFunktion");
[[NSApp modalWindow]orderOut:NULL];
[NSApp abortModal];
AdminPWOK=NO;
}

- (void)AdminTimeoutTimerFunktion:(NSTimer*)derTimer
{
	NSLog(@"AdminTimeoutTimerFunktion");
	NSLog(@"Beenden");
	if ([TeminateAdminPWTimer isValid])
	{
	[TeminateAdminPWTimer invalidate];
	}		
	AdminPWOK=NO;
return;

	TeminateAdminPWTimer=[[NSTimer scheduledTimerWithTimeInterval:15.0 
																	target:self 
																  selector:@selector(TerminateTimeoutFunktion:) 
																  userInfo:nil 
																   repeats:NO]retain];
	
	NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
	[Warnung addButtonWithTitle:@"Admin beenden"];
	[Warnung addButtonWithTitle:@"Admin fortsetzen"];
	//[Warnung addButtonWithTitle:@"Sofort löschen"];
	//[Warnung addButtonWithTitle:@"Abbrechen"];
	//[Warnung setMessageText:[NSString stringWithFormat:@"Was soll mit dem  Ordner von %@ geschehen?",NamenEntfernenString]];
	[Warnung setMessageText:@"Timeout"];
	
	NSString* s1=@"Die Zeit für den Adminzugang ist abgelaufen.";
	NSString* s2=@"";
	NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
	[Warnung setInformativeText:InformationString];
	[Warnung setAlertStyle:NSWarningAlertStyle];
	rPWTimeout* AdminPWTimeoutPanel=[[rPWTimeout alloc]init];
	if (AdminPWTimeoutPanel)
	{
//	[AdminPWTimeoutPanel setTextString2:NSLocalizedString(@"Timeout For Admin",@"Timeout für Admin");
	NSModalSession PWSession=[NSApp beginModalSessionForWindow:[AdminPWTimeoutPanel window]];
	[AdminPWTimeoutPanel setTitelString:NSLocalizedString(@"Timeout For Admin",@"Timeout für Admin")];
	[AdminPWTimeoutPanel setTextString1:NSLocalizedString(@"The time for admin access is over.",@"Die Zeit für den Adminzugang ist abgelaufen.")];
	[AdminPWTimeoutPanel setTextString2:NSLocalizedString(@"How do you want to continue?",@"Wie weiterfahren?")];

	[[NSRunLoop currentRunLoop] addTimer: TeminateAdminPWTimer forMode:NSModalPanelRunLoopMode];
	int antwort=[NSApp runModalForWindow:[AdminPWTimeoutPanel window]];

	[NSApp endModalSession:PWSession];
	//NSNumber* EntfernenNumber=[NSNumber numberWithInt:antwort-1000];
	switch (antwort)
	  {
	  case 0://Beenden
		{ 
			NSLog(@"Beenden");
			if ([TeminateAdminPWTimer isValid])
			{
			[TeminateAdminPWTimer invalidate];
			}		
			AdminPWOK=NO;
		
		}break;
		
	  case 1://Fortsetzen
		{
			NSLog(@"Fortsetzen");
			if ([TeminateAdminPWTimer isValid])
			{
			[TeminateAdminPWTimer invalidate];
			}		

			[self startAdminTimeout];
		}break;

	  }//switch
	}//if
}

- (void)startAdminTimeout
{
	if ([AdminTimeoutTimer isValid])
	{
	//NSLog(@"AufgabeFertigAktion AblaufzeitTimer invalidate");
	[AdminTimeoutTimer invalidate];
	}
	AdminTimeoutTimer=[[NSTimer scheduledTimerWithTimeInterval:20.0 
													  target:self 
													selector:@selector(AdminTimeoutTimerFunktion:) 
													userInfo:nil 
													 repeats:NO]retain];

}

- (void)stopAdminTimeout
{
if ([AdminTimeoutTimer isValid])
{
[AdminTimeoutTimer invalidate];
}
}



- (void)DeleteTestAktion:(NSNotification*)note
{
//NSLog(@"DeleteTestAktion: userInfo: %@",[[note userInfo]description]);
NSString* tempName=[[note userInfo] objectForKey:@"testname"];
NSString* tempDatum=[[note userInfo] objectForKey:@"datum"];
//NSLog(@"DeleteTestAktion: tempName: %@	tempDatum: %@",tempName,tempDatum);

if (tempName&&tempDatum)
{
	//NSLog(@"deleteTest");
	[Utils deleteTestMitDatum:tempDatum forUser:tempName anPfad:SndCalcPfad];
	
}

}

- (void)DeleteTestNameAktion:(NSNotification*)note
{
	NSLog(@"DeleteTestNameAktion: userInfo: %@",[[note userInfo]description]);
	NSString* tempTestName=[[note userInfo] objectForKey:@"deletetestname"];
	
	if (tempTestName)
	{
	
	[Utils deleteErgebnisseVonTest:tempTestName anPfad:SndCalcPfad];
	
	
		NSMutableArray* tempTestDicArray=(NSMutableArray*)[PListDic objectForKey:@"testarray"];
		
		if (tempTestDicArray &&[tempTestDicArray count])
		{
			NSArray* tempTestNamenArray=[tempTestDicArray valueForKey:@"testname"];
			NSLog(@"tempTestNamenArray: %@",[tempTestNamenArray description]);
			int index=[tempTestNamenArray indexOfObject:tempTestName];
			if (!(index==NSNotFound))
			{
				NSLog(@"deleteTest: %@",tempTestName);
				[tempTestDicArray removeObjectAtIndex:index];
				[Utils deleteTestName:tempTestName  anPfad:SndCalcPfad];
			}
			NSMutableArray* tempAktivTestArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
			NSEnumerator* AktivEnum=[tempTestDicArray objectEnumerator];
			id einDic;
			while (einDic=[AktivEnum nextObject])
			{
				if ([einDic objectForKey:@"aktiv"]&&[[einDic objectForKey:@"aktiv"]boolValue])
				{
					[tempAktivTestArray addObject:[einDic objectForKey:@"testname"]];
				}
			}
			NSLog(@"DeleteTestNameAktion tempAktivTestArray: %@",[tempAktivTestArray description]);
			[self setTestPopKnopfMitArray:tempTestDicArray];
			[TestPanel setTestDicArray:tempTestDicArray];
			NSLog(@"deleteTestNameAktion nach setTestDicArray");
		}
		
		NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
		if (tempNamenDicArray)
		{
			[TestPanel setNamenDicArray:tempNamenDicArray];
		}
	
	}
	
}

- (void)NeueStimmeAktion:(NSNotification*)note
{
//	NSLog(@"NeueStimmeAktion:note userInfo: %@",[[note userInfo]description]);
	NSArray* tempStimmenArray=[[note userInfo]objectForKey:@"stimmentablearray"];
	NSString* neueStimme=[[note userInfo]objectForKey:@"neuestimme"];
	
//	[PListDic setObject:Stimme forKey:@"stimmenname"];
}

- (void)StimmeAktion:(NSNotification*)note
{
	//Ausgewählte Stimme bei close von StimmenPanel in PList sichern
	//NSLog(@"SndCalcController	StimmeAktion:note userInfo: %@",[[note userInfo]description]);
	NSArray* tempStimmenArray=[[note userInfo]objectForKey:@"stimmentablearray"];
	NSString* neueStimme=[[note userInfo]objectForKey:@"stimmenname"];
	if (neueStimme&&(![neueStimme isEqualToString:Stimme]))
	{
		[PListDic setObject:neueStimme forKey:@"stimmenname"];
	}

}


- (void)NeueQuittungAktion:(NSNotification*)note
{
	NSLog(@"NeueQuittungAktion:note userInfo: %@",[[note userInfo]description]);
	NSString* neueQuittung=[[note userInfo]objectForKey:@"neuequittung"];
	NSString* tempKlasse=[[note userInfo]objectForKey:@"klassename"];
	
//	[PListDic setObject:Stimme forKey:@"stimmenname"];
}

- (void)QuittungAktion:(NSNotification*)note
{
	//NSLog(@"\n\nController QuittungAktion:note userInfo: %@",[[note userInfo]description]);	
	NSDictionary* neueQuittungDic=[[note userInfo]objectForKey:@"quittungdic"];
	//if (neueStimme&&(![neueStimme isEqualToString:Stimme]))
	{
		[PListDic setObject:neueQuittungDic forKey:@"quittungdic"];
	}
	
}



- (void)savePListAktion:(NSNotification*)note
{
	
	switch (Status)
	{
		case kGast:
		{
			[PListDic setObject:[self SerieDatenDicVonScratch] forKey:@"seriedatendic"];
		}break;//Gast
			
		case kBenutzer:
		{	
			if ([NamenPopKnopf indexOfSelectedItem])
			{
			[self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
			}
			else
			{
				[PListDic setObject:[self SerieDatenDicAusSettings] forKey:@"seriedatendic"];
			}
			
		}break;//Benutzer
	}//switch Status
	
	[PListDic setObject:[self SerieDatenDicAusSettings] forKey:@"seriedatendic"];
	
	//NSLog(@"savePListAktion: tempPListDic: %@",[tempPListDic description]);
	
	
	
	[PListDic setObject:[NSNumber numberWithInt:AnzahlAufgaben] forKey:@"anzahlaufgaben"];
	[PListDic setObject:[NSNumber numberWithInt:MaximalZeit] forKey:@"zeit"];
	
	
//	NSLog(@"savePListAktion: PListDic: %@",[PListDic description]);
//NSLog(@"savePListAktion: PListDic: Testarray:  %@",[[PListDic objectForKey:@"testarray"]description]);
	NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
	
	NSString* PListPfad;
	//NSLog(@"\n\n");
	//NSLog(@"savePListAktion: SndCalcPfad: %@ ",SndCalcPfad);
	PListPfad=[SndCalcPfad stringByAppendingPathComponent:PListName];
	NSLog(@"savePListAktion: PListPfad: %@ ",PListPfad);
	//NSLog(@"savePListAktion: PListDic: %@ ",[PListDic description]);
	
	BOOL PListOK=[PListDic writeToFile:PListPfad atomically:YES];

//	NSLog(@"PListOK: %d",PListOK);
	
	//[tempUserInfo release];
}


- (void)printStatistik:(id)sender
{
if (Statistik &&[Statistik AdminOK])
{
[Statistik reportPrint:NULL];
}
}




- (BOOL)checkAdminZugang
{
	BOOL ZugangOK=NO;
	//NSLog(@"checkAdminZugang: mitAdminPasswort: %d",mitAdminPasswort);
	if (mitAdminPasswort)
	{
		NSMutableDictionary* tempAdminPWDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		//NSLog(@"checkAdminZugang	PListDic: %@",[PListDic description]);
		if ((![PListDic objectForKey:@"pwdic"])||([[[PListDic objectForKey:@"pwdic"]objectForKey:@"pw"]length]==0))//kein Eintrag da
		{
		NSLog(@"kein PW-Eintrag in PList");
			[tempAdminPWDic setObject:@"Admin" forKey:@"name"];
			[tempAdminPWDic setObject:[NSData data] forKey:@"pw"];
		}
		else
		{
			tempAdminPWDic=[PListDic objectForKey:@"pwdic"];
			//NSLog(@"Eintrag da: %@",[tempAdminPWDic description]);
		}

		
		NSData* tempPWData=[tempAdminPWDic objectForKey:@"pw"];
		if ([tempPWData length])//Passwort existiert
		{
			//NSLog(@"checkAdminZugang: Passwort abfragen");
			ZugangOK=[Utils confirmPasswort:[tempAdminPWDic copy]];
		}
		else//keinPasswort
		{
			//NSLog(@"checkAdminZugang pw="": neues Passwort eingeben");
			NSDictionary* tempNeuesPWDic=[Utils changePasswort:[tempAdminPWDic copy]];
			//NSLog(@"tempNeuesPWDic: %@",[tempNeuesPWDic description]);
			if ([[tempNeuesPWDic objectForKey:@"pw"]length])//neues PW ist da
			{
				//NSLog(@"tempNeuesPWDic: %@",[tempNeuesPWDic description]);
				//[PListDic setObject:AdminPasswortDic forKey:@"adminpw"];
				[PListDic setObject:[tempNeuesPWDic copy] forKey:@"pwdic"];
				
				AdminPasswortDic =[tempNeuesPWDic copy];
				
				//NSLog(@"PListDic in checkAdminZugang: %@",[PListDic description]);
				BOOL adminPWOK=[Utils saveAdminPW:tempNeuesPWDic anPfad:SndCalcPfad];
				ZugangOK=YES;				
			}
			else
			{
				//NSLog(@"checkAdminZugang: neues Passwort misslungen");
				//neues PW misslungen
			}
		}
		
		
	}//mitAdminPasswort
	else
	{
		ZugangOK=YES;
	}
	AdminPWOK=ZugangOK;
	return ZugangOK;
}


- (void)showChangeAdminPasswort:(id)sender
{
				
	//NSDictionary* neuesPWDic=[Utils changePasswort:AdminPasswortDic];
	NSDictionary* neuesPWDic=[Utils changePasswort:[[PListDic objectForKey:@"pwdic"]copy]];
	NSLog(@"neues admin PWDic: %@",[neuesPWDic description]);
	if (neuesPWDic)
	{
		[AdminPasswortDic setDictionary:neuesPWDic];
		[PListDic setObject:neuesPWDic forKey:@"pwdic"];
		[Utils saveAdminPW:neuesPWDic anPfad:SndCalcPfad];
	}

}








- (BOOL)windowShouldClose:(id)sender
{
	//NSLog(@"windowShouldClose");

	[self BeendenAktion:NULL];
	
	return YES;
}

- (void)DebugStep:(NSString*)dieWarnung
{
					NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
					[Warnung addButtonWithTitle:@"OK"];
					[Warnung setMessageText:dieWarnung];
					int antwort=[Warnung runModal];
}

@end


//////////
//
// adjustPlayButtonForMyMovieControllerObject
//
// Once the movie has stopped playing, QuickTime will call
// us so we can adjust our play button settings.
//
//////////

void adjustPlayButtonForMyMovieControllerObject()
{
    //[(SndCalcKontroller *)gMyMovieControllerObject setLosTaste:nil];
}

//////////
//
// MyCallBackProc
//
// This is our movie timebase callback routine. We'll tell
// QuickTime to call this routine whenever our movie has
// stopped playing.
//
//////////

pascal void MyCallBackProc (QTCallBack cb, long refcon)
{
    adjustPlayButtonForMyMovieControllerObject();
    [(SndCalcController *)gMyMovieControllerObject restoreMoviePlayCompleteCallBack];
}

//////////
//
// saveObjectForCallback
//
// This routine stores a reference to our MyMovieController object. We'll
// need this so we can call into methods in this class from outside the
// implementation of the class methods.
//
//////////

void saveObjectForCallback(void *theObject)
{
   gMyMovieControllerObject = theObject;
}




