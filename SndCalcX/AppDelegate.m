//
//  AppDelegate.m
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 14.04.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end


enum
{
   kTrainingModus,
   kTestModus};

enum
{
   kAblaufMenuTag=20000,
   kNeuerNameTag,
   kTestListeTag,
   kPasswortListeTag,
   kNeueSessionTag,
   kSessionAktualisierenTag,
   kStimmeTag=20008,
   kChangePasswortTag=20010
};

enum
{
   kLogoutTag=10005
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


@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
   
   char	s[16]={""},  p[16];
   short zeile=3;
   short spalte=420;
   
   //char * 		p="\0";
   strcpy(s,"  \0");

   // Insert code here to initialize your application
   // init
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(AufgabelesenFertigAktion:)
              name:@"AufgabelesenFertig"
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
   
   
   [nc addObserver:self
          selector:@selector(EinstellungenAktion:)
              name:@"Einstellungen"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(TestPanelSchliessenAktion:)
              name:@"TestPanelSchliessen"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(VertipperAktion:)
              name:@"Vertipper"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(OKAktion:)
              name:@"oktaste"
            object:nil];
   
   
   [nc addObserver:self
          selector:@selector(WeiterfahrenAktion:)
              name:@"Weiterfahren"
            object:nil];
   
   /*
    [nc addObserver:self
    selector:@selector(QTKitQuittungFertigAktion:)
    name:@"QTKitQuittungFertig"
    object:self];
    */
   
   Utils=[[rUtils alloc]init];
   
   PListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   UserDatenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   
   SerieDatenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   QuittungDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   Volume=80;
   UserTimeout=20;
   AdminTimeout=60;
   
   srand(time(NULL));
   
   Modus=kTestModus;
   Status=0;
   AufgabeOK = 1;
   mitAdminPasswort=YES;
   //	[Stimme=[NSString alloc]initWithString:@""];
   Stimme=[NSString string];
   // end init

   // awake
   {
      
      [[AblaufMenu itemWithTag:10001] setTarget:self];//
      
      NSString* HomeDatenPfad=[Utils HomeSndCalcDatenPfad];
      NSLog(@"HomeDatenPfad; %@",HomeDatenPfad);
      //NSArray*  NetzwerkVolumesArray = [Utils NetzwerkVolumesArray];
      //NSLog(@"NetzwerkVolumesArray: %@",[NetzwerkVolumesArray description]);
      NSArray* NetworkDatenArray=[Utils UsersMitSndCalcDatenArray];
     // NSLog(@"NetworkDatenArray: %@",[NetworkDatenArray description]);
      
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
     // NSLog(@"awake: SndCalcPfad: %@",SndCalcPfad);
      BOOL PListBusy=YES;
      int runde=0;
      while (PListBusy)
      {
         runde++;
         BOOL PListOK=[self readPListAnPfad:SndCalcPfad];
         
         
         PListBusy=!PListOK;
         PListBusy=0;
         if (runde==2)
         {
            
         }
      }//while
      
      
      
      //if (![self readPListAnPfad:SndCalcPfad])
      //{
      //NSLog(@"SndCalcPfad: keine PList gefunden");
      //}
      
       //[self DebugStep:@"nach readPListAnPfad"];
      
      //NSLog(@"SndCalcPfad: %@\nPListDic: %@",SndCalcPfad,[PListDic description]);
      
      //	NSLog(@"SndCalcPfad: %@\nPListDic: %@",SndCalcPfad,[PListDic description]);
      
      NSColor* HintergrundFarbe=[NSColor colorWithDeviceRed:220.0/255.0 green:255.0/255.0 blue:234.0/255.0 alpha:1.0];
      
      
      [[self window]setBackgroundColor:HintergrundFarbe];
      //[[self window]setBackgroundColor:[NSColor redColor]];
      
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
      
      
      [[RechnungsBox contentView]addSubview:ErgebnisFeld];
      [[[self window]contentView]addSubview:RechnungsBox ];
      
      [[RechnungsBox contentView]addSubview:ErgebnisRahmenFeld];
      
      
      NSImage* myImage = [NSImage imageNamed: @"Duerer"];
      [NSApp setApplicationIconImage: myImage];
      
    //  [Bild setImage: [NSImage imageNamed: @"duerergrau"]];
      
      
      /* we must initialize the movie toolbox before calling
       any of it's functions */
      //		[self DebugStep:@"vor EnterMovies"];
      //	EnterMovies();
      //[self DebugStep:@"nach EnterMovies"];
      
      //	saveObjectForCallback(self);
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
      
      //	[[[self window]contentView]addSubview:[Speaker AufgabenPlayer]];
      
       Aufgabe = [[rAufgabe alloc ]init];
      
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
      ZeitBoxRect.size.width-=75;
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
      
      
      //[ErgebnisFeld setAction:NULL];
      verify=NO;
      [ErgebnisFeld setErgebnisFeld];
      [ErgebnisFeld setAction:@selector(ErgebnisFeldAktion:)];
      //	[ErgebnisFeld setAction:NULL];
      //	[ErgebnisFeld setDelegate:self];
      [ErgebnisFeld setTarget:self];
      rEingabeCheck* EingabeTest=[[rEingabeCheck alloc]init];
      [ErgebnisFeld setFormatter:EingabeTest];
      
      [TestPopKnopf removeAllItems];
      //[TestPopKnopf addItemWithTitle:@"Training"];
      
      NSArray* rawTestDicArray;
      if ([PListDic objectForKey:@"testarray"]&&[[PListDic objectForKey:@"testarray"] count])
      {
         rawTestDicArray=[PListDic objectForKey:@"testarray"];
      }
      else
      {
         NSMutableDictionary* tempTestDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempTestDic setObject:[self SerieDatenDicVonScratch] forKey:@"seriedatendic"];
         [tempTestDic setObject:[NSNumber numberWithBool:YES] forKey:@"aktiv"];
         [tempTestDic setObject:@"Kleines 1*1 Starter" forKey:@"testname"];
         [tempTestDic setObject:[NSNumber numberWithInt:12] forKey:@"anzahlaufgaben"];
         [tempTestDic setObject:[NSNumber numberWithInt:1] forKey:@"alle"];
         [tempTestDic setObject:[NSNumber numberWithInt:120] forKey:@"zeit"];
         rawTestDicArray=[NSArray arrayWithObject:tempTestDic];
         [PListDic setObject:rawTestDicArray forKey:@"testarray"];
         [self savePListAktion:nil];
      }
      //NSLog(@"awake: PListDic: %@",[PListDic description]);
      NSMutableArray* TestDicArray=[[NSMutableArray alloc]initWithCapacity:0];
      NSEnumerator* TestEnum=[rawTestDicArray objectEnumerator];
      id einTestDic;
      while (einTestDic=(NSMutableDictionary*)[TestEnum nextObject])
      {
         NSLog(@"TestDic: ",[einTestDic description]);
         
         if ([einTestDic objectForKey:@"seriedatendic"])
         {
            //NSLog(@"Test  geladen: %@",[einTestDic description]);
            
            BOOL statusOK=[[[self StatusVonSerieDatenDic:[einTestDic objectForKey:@"seriedatendic"]]objectForKey:@"complete"]boolValue];
            //NSLog(@"Test  geladen: %@",[einTestDic description]);
            //NSLog(@"Test  geladen: statusOK: %d",statusOK);
            if (statusOK)
            {
               [TestDicArray addObject:einTestDic];
            }
         }
         else	//cSeriedaten unvollständig
         {
            NSLog(@"Test nicht geladen %@:",[einTestDic description]);
            [einTestDic setObject:[NSNumber numberWithBool:NO]forKey:@"aktiv"];
            [Utils setAktivInPList:[NSNumber numberWithBool:NO] forTest:[einTestDic objectForKey:@"testname"]anPfad:SndCalcPfad];
         }
         
      }//while
      
      //NSMutableArray* TestDicArray=(NSMutableArray*)
      
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
      //NSLog(@"awake: SndCalcPfad: %@",SndCalcPfad);
      NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
      //NSLog(@"awake: tempNamenDicArray %@",[[tempNamenDicArray valueForKey:@"name"]description]);
      
      if (tempNamenDicArray && [tempNamenDicArray count])
      {
         [self setNamenPopKnopfMitDicArray:[tempNamenDicArray copy]];
      }
      else
      {
         
         //NSLog(@"NamenDicArray leer");
         [NamenPopKnopf removeAllItems];
         NSDictionary* firstItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
         NSAttributedString* firstItem=[[NSAttributedString alloc]initWithString:NSLocalizedString(@"Choose Name",@"Namen wählen") attributes:firstItemAttr];
         [NamenPopKnopf insertItemWithTitle:@""atIndex:0];
         [[NamenPopKnopf itemAtIndex:0]setAttributedTitle:firstItem];
         
         //	[self showNamenPanel:NULL];
         
      }
      
      //NSLog(@"awake D");
      if ([TestPopKnopf numberOfItems]&&[TestPopKnopf titleOfSelectedItem])
      {
         //	NSLog(@"%awake	%@",[TestPopKnopf titleOfSelectedItem]);
         [self setTestVonTestname:[TestPopKnopf titleOfSelectedItem]];
      }
      [NamenPopKnopf selectItemAtIndex:0];
      [ErgebnisseTaste setEnabled:NO];
      //NSLog(@"awake NamenPop: %@",[[NamenPopKnopf itemArray] description]);
      
      //	[LogoutKnopf
      
      
      
      //	[self DebugStep:@"vor Menu Validation"];
      
      [[AblaufMenu itemWithTag:kNeuerNameTag] setTarget:self];//
      [[AblaufMenu itemWithTag:kTestListeTag] setTarget:self];//
      [[AblaufMenu itemWithTag:kChangePasswortTag] setTarget:self];//
      [[AblaufMenu itemWithTag:kNeueSessionTag] setTarget:self];//
      [[AblaufMenu itemWithTag:kNeueSessionTag] setToolTip:NSLocalizedString(@"Begin a new session of tests for all members of the list.",@"Neue Session")];
      [[AblaufMenu itemWithTag:kSessionAktualisierenTag] setToolTip:NSLocalizedString(@"Synchronize session list with other computers logged in",@"Sessionsliste mit andern eingeloggten Computern synchronisieren")];
      
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
      //	[ErgebnisView setToolTip:NSLocalizedString(@"Input field",@"Eingabefeld")];
      [ErgebnisFeld setToolTip:NSLocalizedString(@"Input field",@"Eingabefeld")];
      [AufgabenNummerFeld setToolTip:NSLocalizedString(@"Task number",@"Aufgabennummer")];
      [SettingsPfeil setToolTip:NSLocalizedString(@"Settings are only available in Training Modus",@"Die Einstellungen sind nur im Trainigsmodus zugänglich")];
      [ToggleSessionKnopf setToolTip:NSLocalizedString(@"Userlist with marked users having done the test in the current session.",@"Liste mit markierten Usern")];
      [IconView setToolTip:NSLocalizedString(@"Magic from the painting 'Melencholia I' of Leonardo",@"Leonardo")];
      
      
      
      //	[Utils deleteInvalidTestsAnPfad:SndCalcPfad];
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
      //NSLog(@"wake end");
   }
   
  
   NSArray* varArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
   [Aufgabe setAufgabendaten:[NSDictionary dictionaryWithObjectsAndKeys:varArray, @"var",nil]];
   int var1 = [Aufgabe getVariable:0];
   //end awake
   RechnungSeriedaten = [[rSeriedaten alloc]init];
   RechnungSeriedaten.AnzahlReihen=0;
   RechnungSeriedaten.AnzahlAufgaben = kMaxAnzahlAufgaben;
   RechnungSeriedaten.ASBereich = kBisZehn;
   RechnungSeriedaten.ASBereich=kZehnbisZwanzig;
   RechnungSeriedaten.ASBereich=kZweistellig;
   RechnungSeriedaten.ASzweiteZahl=kBisZehn;
   //ASzweiteZahl=kZehnbisZwanzig;
   RechnungSeriedaten.ASZehnerU=kImmer;
   for (short i=0;i<kMaxAnzahlReihen;i++)
   {
      RechnungSeriedaten->Reihenliste[i]=0;
   }

}


- (BOOL)readPListAnPfad:(NSString*)derSndCalcPfad
{
   
   //NSLog(@"    **  readPListAnPfad: %@",derSndCalcPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSCalendarDate* Heute=[NSCalendarDate date];
   NSInteger HeuteTag=[Heute dayOfMonth];
   NSInteger HeuteMonat=[Heute monthOfYear];
   NSInteger HeuteJahr=[Heute yearOfCommonEra];
   //NSLog(@"Heute: %d %d %d",HeuteTag,HeuteMonat,HeuteJahr);
   [Heute setCalendarFormat:@"%d.%m.%Y"];
   NSLog(@"Heute: %@",[Heute description]);
   NSString* SCVersionString=[NSString stringWithFormat:@"%d.%d",HeuteJahr%2000,HeuteMonat];
   //NSLog(@"SCVersionString: %@",SCVersionString);
   //	NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources"];
   NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents"];
   //NSLog(@"ResourcenPfad: %@ Inhalt: %@",ResourcenPfad,[Filemanager directoryContentsAtPath:ResourcenPfad]);
   NSString* InfoPlistPfad=[ResourcenPfad stringByAppendingPathComponent:@"Info.plist"];
   //NSLog(@"Info.plist: %@",[NSString stringWithContentsOfFile:InfoPlistPfad]);
   
   //Aboutfenster: Version setzen
   if ([Filemanager fileExistsAtPath:InfoPlistPfad])
   {
      //NSLog(@"InfoPlistPfad: %@ Inhalt: %@",InfoPlistPfad,[[Filemanager directoryContentsAtPath:InfoPlistPfad]description]);
      NSMutableDictionary* InfoDic=[NSMutableDictionary dictionaryWithContentsOfFile:InfoPlistPfad];
      //NSLog(@"InfoDic: %@",[InfoDic description]);
      
      NSString* SCDictionaryVersionString=[NSString stringWithFormat:@"%d.%d",HeuteJahr%2000,HeuteMonat];
      [InfoDic setObject:SCDictionaryVersionString forKey:@"CFBundleInfoDictionaryVersion"];
      
      NSString* SCShortVersionString=[NSString stringWithFormat:@"%d.%d",HeuteMonat,HeuteTag];
      [InfoDic setObject:SCShortVersionString forKey:@"CFBundleVersion"];
      [InfoDic writeToFile:InfoPlistPfad atomically:YES];
      
   }
   
   //Informationsfenster: Version und Copyright setzen
   NSString* InfoPlistStringPfad=[ResourcenPfad stringByAppendingPathComponent:@"Resources/German.lproj/InfoPlist.strings"];
   if ([Filemanager fileExistsAtPath:InfoPlistStringPfad])
   {
      NSString* InfString=[NSString stringWithContentsOfFile:InfoPlistStringPfad encoding: NSMacOSRomanStringEncoding error:NULL];
      //NSLog(@"InfString: %@",InfString);
      NSMutableDictionary* InfoStringDic=[NSMutableDictionary dictionaryWithContentsOfFile:InfoPlistStringPfad];
      //NSLog(@"InfoStringDic: %@",[InfoStringDic description]);
      [InfoStringDic setObject:SCVersionString forKey:@"CFBundleShortVersionString"];
      
      NSString* SCCopyrightString=[NSString stringWithFormat:@"SndCalc Version %@, Copyright %d Ruedi Heimlicher.",SCVersionString,HeuteJahr];
      [InfoStringDic setObject:SCCopyrightString forKey:@"CFBundleGetInfoString"];
      
      [InfoStringDic writeToFile:InfoPlistStringPfad atomically:YES];
      
      
   }
   
   
   BOOL istOrdner=NO;
   if ([Filemanager fileExistsAtPath:derSndCalcPfad isDirectory:&istOrdner]&&istOrdner)
   {
      BOOL neuePList=NO;
      //NSLog(@"SndCalcDaten da. Pfad: %@",[derSndCalcPfad stringByAppendingPathComponent:PListName]);
      NSDictionary*tempPListDic=[NSDictionary dictionaryWithContentsOfFile:[derSndCalcPfad stringByAppendingPathComponent:PListName]];
      if (tempPListDic)
      {
         // 4.8.08 PListDic=[tempPListDic mutableCopy];
         //NSLog(@"readPListAnPfad: PList: %@",[tempPListDic description]);
         if ([tempPListDic objectForKey:@"busy"])
         {
            if ([[tempPListDic objectForKey:@"busy"]boolValue])//Besetzt
            {
               NSAlert *Warnung = [[NSAlert alloc] init];
               [Warnung addButtonWithTitle:@"Nochmals versuchen"];
               //[Warnung addButtonWithTitle:@""];
               //[Warnung addButtonWithTitle:@""];
               [Warnung addButtonWithTitle:@"Beenden"];
               NSString* MessageString=@"Datenordner besetzt";
               [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
               
               NSString* s1=NSLocalizedString(@"The data folder cannot be opened.",@"Der Datenordner kann nicht geöffnet werden");
               NSString* s2=NSLocalizedString(@"It is momentarly used by annother user.",@"Er wird im Moment von einem anderen Computer benutzt");
               NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
               [Warnung setInformativeText:InformationString];
               [Warnung setAlertStyle:NSWarningAlertStyle];
               
               //[Warnung setIcon:RPImage];
               NSInteger antwort=[Warnung runModal];
               
               switch (antwort)
               {
                  case NSAlertFirstButtonReturn://	1000
                  {
                     NSLog(@"NSAlertFirstButtonReturn: Nochmals versuchen");
                     return NO;
                     
                  }break;
                     
                  case NSAlertSecondButtonReturn://1001
                  {
                     NSLog(@"NSAlertSecondButtonReturn: Beenden");
                     //User fragen, ob busy zurückgesetzt werden soll. Notmassnahme
                     NSAlert *BusyWarnung = [[NSAlert alloc] init];
                     [BusyWarnung addButtonWithTitle:NSLocalizedString(@"Reset Data Folder",@"Datenordner zurücksetzen")];
                     //[BusyWarnung addButtonWithTitle:@""];
                     //[BusyWarnung addButtonWithTitle:@""];
                     [BusyWarnung addButtonWithTitle:NSLocalizedString(@"Just terminate",@"Sofort beenden")];
                     NSString* MessageString=NSLocalizedString(@"Data Folder Busy",@"Datenordner besetzt");
                     [BusyWarnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
                     
                     NSString* s1=NSLocalizedString(@"There is a problem with the state of thedata folder.",@"Es gibt ein Problem mit dem Status des Datenordners.");
                     NSString* s2=NSLocalizedString(@"Do you want to reset its state before terminating?",@"Soll sein Status vor dem Beenden zurückgesetzt werden?");
                     NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
                     [BusyWarnung setInformativeText:InformationString];
                     [BusyWarnung setAlertStyle:NSWarningAlertStyle];
                     
                     //[Warnung setIcon:RPImage];
                     NSInteger antwort=[BusyWarnung runModal];
                     
                     switch (antwort)
                     {
                        case NSAlertFirstButtonReturn://	1000
                        {
                           NSLog(@"NSAlertFirstButtonReturn: Reset");
                           if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
                           {
                              [Utils setPListBusy:NO anPfad:SndCalcPfad];
                           }
                           
                           
                        }break;
                           
                        case NSAlertSecondButtonReturn://1001
                        {
                           NSLog(@"NSAlertSecondButtonReturn: Beenden");
                           
                           
                        }break;
                           
                     }//switch
                     
                     [NSApp terminate:self];
                  }break;
                  case NSAlertThirdButtonReturn://
                  {
                     NSLog(@"NSAlertThirdButtonReturn");
                     
                  }break;
                  case NSAlertThirdButtonReturn+1://
                  {
                     NSLog(@"NSAlertThirdButtonReturn+1");
                     
                  }break;
                     
               }//switch
               
               //				return NO;//warten
            }
            else
            {
               
            }
         }
         else
         {
            
         }
         
         
         
         
         //			[Utils setPListBusy:YES anPfad:SndCalcPfad]; 25.10.07 verschoben vor Abfrage busy: pwdic für checkadminzugang bereitstellen
         
         //			NSLog(@"readPListAnPfad: tempPListDic: %@",[tempPListDic description]);
         
         PListDic=[tempPListDic mutableCopy];
         
         
      }
      else //Noch keine PList
      {
         neuePList=YES;
         
      }
      
      //NSLog(@"PListDic Begin: %@",[PListDic description]);
      
      if ([PListDic objectForKey:@"seriedatendic"])
      {
         [SerieDatenDic addEntriesFromDictionary:[PListDic objectForKey:@"seriedatendic"]];
         NSLog(@"SerieDatenDic Aus PList: %@",[SerieDatenDic description]);
         
      }
      else
      {
         NSLog(@"readPListAnPfad:	SerieDatenDic FromScratch: %@",[[self SerieDatenDicVonScratch]description]);
         [SerieDatenDic addEntriesFromDictionary:[self SerieDatenDicVonScratch]];
         [PListDic setObject:[self SerieDatenDicVonScratch] forKey:@"seriedatendic"];
         //NSLog(@"readPListAnPfad:	PListDic mit SerieDatenDic FromScratch: %@",[PListDic description]);
      }
      
     // SerieDatenDic=[self SerieDatenVonDic:PListDic];
      
      if ([PListDic objectForKey:@"volume"])
      {
         Volume=[[PListDic objectForKey:@"volume"]floatValue];
         //				NSLog(@"Volume Aus PList: %f",Volume);
         
      }
      else
      {
         Volume=80.0;
         [PListDic setObject:[NSNumber numberWithFloat:Volume]forKey:@"volume"];
      }
      
      
      if ([PListDic objectForKey:@"admintimeout"])
      {
         int timeOut=[[PListDic objectForKey:@"admintimeout"]intValue];
         if (timeOut==0)
         {
            timeOut=60;
         }
         AdminTimeout=timeOut;
         //NSLog(@"AdminTimeout Aus PList: %d",AdminTimeout);
         
      }
      else
      {
         AdminTimeout=60;
         [PListDic setObject:[NSNumber numberWithInt:AdminTimeout]forKey:@"admintimeout"];
      }
      
      
      if ([PListDic objectForKey:@"usertimeout"])
      {
         UserTimeout=[[PListDic objectForKey:@"usertimeout"]intValue];
         //NSLog(@"UserTimeout Aus PList: %d",UserTimeout);
         
      }
      else
      {
         UserTimeout=60;
         [PListDic setObject:[NSNumber numberWithInt:UserTimeout]forKey:@"usertimeout"];
      }
      
      if ([PListDic objectForKey:@"testarray"])
      {
         //				NSLog(@"TestArray da");
      }
      else
      {
         NSLog(@"TestArray nicht da");
         NSMutableArray* tempTestArray=[[NSMutableArray alloc]initWithCapacity:0];
         NSMutableDictionary* tempTestDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempTestDic setObject:[self SerieDatenDicVonScratch] forKey:@"seriedatendic"];
         [tempTestDic setObject:[NSNumber numberWithInt:1] forKey:@"aktiv"];
         [tempTestDic setObject:[NSNumber numberWithInt:1] forKey:@"alle"];
         [tempTestDic setObject:[NSNumber numberWithInt:12] forKey:@"anzahlaufgaben"];
         [tempTestDic setObject:[NSNumber numberWithInt:120] forKey:@"zeit"];
         [tempTestDic setObject:@"Kleines 1*1 Starter" forKey:@"testname"];
         [tempTestArray addObject:tempTestDic];
         [PListDic setObject:tempTestArray forKey:@"testarray"];
         
      }
      //NSLog(@"readPListAnPfad:	%@ PListDic mit Testarray FromScratch: %@",SndCalcPfad,[PListDic description]);
      NSDate* last=[Utils SessionDatumAnPfad:SndCalcPfad];
      
      if ([PListDic objectForKey:@"sessiondatum"])
      {
         SessionDatum=[PListDic objectForKey:@"sessiondatum"];
         NSLog(@"SessionDatum: %@",[SessionDatum description]);
         NSCalendarDate* heute=[NSCalendarDate date];
         NSCalendarDate* lastSession=[[NSCalendarDate alloc]initWithString:[SessionDatum description]];
         NSInteger lastSessionTag=[lastSession dayOfYear];
         double lastSessionInterval=[SessionDatum timeIntervalSinceReferenceDate];
         double heuteInterval=[heute timeIntervalSinceReferenceDate];
         NSInteger lastJahr=[lastSession yearOfCommonEra];
         NSInteger heuteJahr=[heute yearOfCommonEra];
         //(@"lastSessionInterval: %f		heuteInterval: %f",lastSessionInterval,heuteInterval);
         //NSLog(@"lastJahr: %d		heuteJahr: %d",lastJahr,heuteJahr);
         
         NSInteger heuteTag=[heute dayOfYear];
         if (lastJahr<heuteJahr)//Datum vom letzten Jahr, Tag des Jahres kann höher sein)
         {
            lastSessionTag=1;
         }
         NSLog(@"lastSessionTag: %d		heute: %d",lastSessionTag,heuteTag);
         BOOL SessionBehalten=[Utils SessionBehaltenAnPfad:SndCalcPfad];
         int SessionBehaltenTag=[Utils SessionBehaltenTagAnPfad:SndCalcPfad];
         
         if ((heuteTag>lastSessionTag)&&(SessionBehaltenTag<heuteTag))	//letzteSession ist mindestens von gestern
         {																//SessionBehaltenTag ist von gestern
            [Utils saveSessionBehaltenTag:heuteTag anPfad:SndCalcPfad];//SessionBehaltenTag ist heute, nicht mehr nach Session fragen
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"Neue Session"];
            [Warnung addButtonWithTitle:@"Session weiterführen"];
            [Warnung setMessageText:[NSString stringWithFormat:@"Neue Session?"]];
            NSString* s1=@"Die aktuelle Session ist mehr als einen Tag alt.";
            NSString* s2=@"Wie weiterfahren?";
            NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
            [Warnung setInformativeText:InformationString];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            //[Warnung setIcon:RPImage];
            NSInteger antwort=[Warnung runModal];
            
            switch (antwort)
            {
               case NSAlertFirstButtonReturn://neue Session starten
               {
                  NSLog(@"neue Session");
                  [self neueSession:NULL];
                  BOOL SessionbehaltenOK=[Utils saveSessionBehalten:NO anPfad:SndCalcPfad];
               }break;
                  
               case NSAlertSecondButtonReturn://alte Session weiterführen
               {
                  NSLog(@"Session behalten");
                  //24.3.				heuteTag=lastSessionTag;
                  //				SessionDatum=[NSDate date];
                  //				BOOL SessionOK=[Utils saveSessionDatum:[NSDate date] anPfad:SndCalcPfad];
                  //				NSLog(@"readPList	SessionOK: %d",SessionOK);
                  //				[PListDic setObject:[NSDate date] forKey:@"sessiondatum"];
                  BOOL SessionbehaltenOK=[Utils saveSessionBehalten:YES anPfad:SndCalcPfad];
               }break;
            }//switch
         }
      }
      else
      {
         SessionDatum=[NSDate date];
         BOOL SessionOK=[Utils saveSessionDatum:[NSDate date] anPfad:SndCalcPfad];
         //				NSLog(@"readPList	SessionOK: %d",SessionOK);
         [PListDic setObject:[NSDate date] forKey:@"sessiondatum"];
         BOOL SessionbehaltenOK=[Utils saveSessionBehalten:NO anPfad:SndCalcPfad];
      }
      
      
      if ([PListDic objectForKey:@"stimmenname"]&&[[PListDic objectForKey:@"stimmenname"] length])
      {
         Stimme=[PListDic objectForKey:@"stimmenname"];
      }
      else
      {
         Stimme =@"home";
         [PListDic setObject:Stimme forKey:@"stimmenname"];
      }
      
      if ([PListDic objectForKey:@"farbig"])
      {
         //NSLog(@"farbig: %@",[PListDic objectForKey:@"farbig"]);
         farbig=[[PListDic objectForKey:@"farbig"]boolValue];
      }
      else
      {
         NSLog(@"kein farbig");
         farbig=YES;
         [PListDic setObject:[NSNumber numberWithBool:farbig] forKey:@"farbig"];
      }
      
      //		NSLog(@"SndCalcController readPList: Stimme: %@",Stimme);
      //		NSLog(@"SndCalcController readPList: Quittungdic: %@",[PListDic objectForKey:@"quittungdic"]);
      
      if ([PListDic objectForKey:@"quittungdic"])
      {
         QuittungDic=[PListDic objectForKey:@"quittungdic"];
      }
      BOOL quittungdicOK=YES;
      
      //			NSLog(@"readPListAnPfad nach lesen aus PListDic	 QuittungDic: %@",[QuittungDic description]);
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
         //				NSLog(@"readPListAnPfad:	!quittungdicOK QuittungDic: %@",[QuittungDic description]);
         [PListDic setObject:QuittungDic forKey:@"quittungdic"];
      }
      if (neuePList)
      {
         Status=1;
         //		NSLog(@"readPListAnPfad:	PListDic vor save: %@",[PListDic description]);
         NSString* PListPfad=[SndCalcPfad stringByAppendingPathComponent:PListName];
         //		NSLog(@"readPListAnPfad: PListPfad: %@ ",PListPfad);
         [PListDic writeToFile:PListPfad atomically:YES];
      }
      
      /* 4.8.08			
       
       }//if PList
       else
       {
       NSLog(@"init: tempPListDic nicht da");
       [QuittungDic setObject:@"home" forKey:@"seriefertig"];
       [QuittungDic setObject:@"home" forKey:@"falscheszeichen"];
       [QuittungDic setObject:@"home" forKey:@"falsch"];
       [QuittungDic setObject:@"home" forKey:@"richtig"];
       
       
       PListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
       //			NSLog(@"SerieDatenDic From Scratch");
       [PListDic setObject:QuittungDic forKey:@"quittungdic"];
       [SerieDatenDic addEntriesFromDictionary:[self SerieDatenDicVonScratch]];
       Volume=80;
       
       }
       
       */		
   }
   else
   {
      //NSLog(@"SndCalcDaten nicht da");
      
      //BOOL OrdnerOK=[Filemanager createDirectoryAtPath:SndCalcPfad attributes:NULL];
      
      BOOL OrdnerOK = [Filemanager createDirectoryAtPath:SndCalcPfad withIntermediateDirectories:NO attributes:NULL error:NULL];
      
      return NO;
   }
   //	NSLog(@"readPListAnPfad: PListDic: %@",[PListDic description]);
   // NSLog(@"init: SerieDatenDic: %@\n",[SerieDatenDic description]);
   [PListDic setObject:[NSNumber numberWithBool:NO] forKey:@"busy"];
   [PListDic setObject:@"home" forKey:@"stimmenname"];
   [Utils setPListBusy:NO anPfad:SndCalcPfad];
   //	[Utils savePListAnPfad:SndCalcPfad];
   //NSLog(@"readPListAnPfad end");
   return YES;
}


- (BOOL)updatePList
{
   
   //	NSLog(@"updatePList: %@",SndCalcPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   if ([Filemanager fileExistsAtPath:SndCalcPfad isDirectory:&istOrdner]&&istOrdner)
   {	
      //		NSLog(@"SndCalcDaten da");
      NSDictionary*tempPListDic=[NSDictionary dictionaryWithContentsOfFile:[SndCalcPfad stringByAppendingPathComponent:PListName]];
      if (tempPListDic)
      {
         //NSLog(@"updatePList: tempPListDic: %@",[tempPListDic description]);
         PListDic=(NSMutableDictionary*)tempPListDic;
         //			NSLog(@"updatePList: PListDic testarray: %@",[[PListDic objectForKey:@"testarray"]description]);
      }
   }
   return YES;
}

- (NSString*)chooseSndCalcPfadMitUserArray:(NSArray*)derUserArray
{
   NSArray* tempUserArray=[NSArray arrayWithArray:derUserArray];
   //NSLog(@"vor Dialog in chooseLeseboxPfadMitUserArray :derUserArray: %@",[derUserArray description]);
   
   //return [NSString string];
   if ([derUserArray count]==0)
   {
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      //	[Warnung addButtonWithTitle:@""];
      //	[Warnung addButtonWithTitle:@""];
      //	[Warnung addButtonWithTitle:@"Abbrechen"];
      NSString* MessageString=@"Es sind keine Datenordner zu finden";
      [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
      
      NSString* s1=@"Das Programm wird beendet";
      NSString* s2=@"";
      NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      
      //[Warnung setIcon:RPImage];
      int antwort=[Warnung runModal];
      
      switch (antwort)
      {
         case NSAlertFirstButtonReturn://	1000
         {
            NSLog(@"NSAlertFirstButtonReturn");
            [NSApp terminate:self];
         }break;
            
         case NSAlertSecondButtonReturn://1001
         {
            NSLog(@"NSAlertSecondButtonReturn");
            
         }break;
         case NSAlertThirdButtonReturn://
         {
            NSLog(@"NSAlertThirdButtonReturn");
            
         }break;
         case NSAlertThirdButtonReturn+1://
         {
            NSLog(@"NSAlertThirdButtonReturn+1");
            
         }break;
            
      }//switch
      
      
      
   }
   
   NSModalSession VolumeSession=[NSApp beginModalSessionForWindow:[VolumesPanel window]];
   
   //in VolumesPanel Daten einsetzen
   [VolumesPanel setUserArray:tempUserArray];
   
   
   int modalAntwort = [NSApp runModalForWindow:[VolumesPanel window]];
   //NSLog(@"beginSheet: Antwort: %d",modalAntwort);
   
   //SndCalcDatenPfad aus Panel abfragen
   NSString* tempSndCalcDatenPfad=[NSString stringWithString:[VolumesPanel SndCalcDatenPfad]];
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
      NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
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
   //NSLog(@"setTestPopKnopfForUser  tempUserTestArray: %@",[tempUserTestArray description]);
   NSMutableArray* TestDicArray=(NSMutableArray*)[Utils TestArrayAusPListAnPfad:SndCalcPfad];
   //NSLog(@"setTestPopKnopfForUser  TestDicArray: %@",[TestDicArray description]);
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
         
      case kSessionAktualisierenTag:
      {
         return YES;
      }break;
         
      case kStimmeTag:
      {
         return YES;
      }break;
         
         
      case kLogoutTag:
      {
         return YES;
      }break;
         
   }//switch
   return YES;
}




- (BOOL)readZahlen
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSLog(@"\n\nreadZahlen start");
   NSString* ZahlenPfad=[SndCalcPfad stringByAppendingPathComponent:@"Zahlen_2/Finish.aiff"];
   NSArray* tempHanniZahlenArray=[Filemanager contentsOfDirectoryAtPath:ZahlenPfad error:NULL];
   NSLog(@"tempHanniZahlenArray: %@",[tempHanniZahlenArray description]);
   NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources"];
   NSString* APfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources/A"];
   NSString* FinishPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources/Finish.aiff"];
   //	BOOL copyOK=[Filemanager removeFileAtPath:APfad handler:NULL];
   //	NSLog(@"copyOK: %d",copyOK);
   NSArray* BundleArray=[Filemanager contentsOfDirectoryAtPath:ResourcenPfad error:NULL];
   NSLog(@"BundleArray path: %@	Array: %@",[[NSBundle mainBundle]bundlePath],[BundleArray description]);
   
   NSArray* tempZahlenArray=[Filemanager contentsOfDirectoryAtPath:ResourcenPfad error:NULL];
   
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
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
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

- (BOOL)checkSettings
{
   BOOL checkOK=YES;
   int multOK=[ReihenSettings checkSettings];
   int addsubOK=[AddSubSettings checkSettings];
   NSLog(@"\ncheckSettings                                      multOK: %d          addsubOK: %d",multOK,addsubOK);
   
   if (multOK+addsubOK==0)
   {
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      [Warnung setMessageText:NSLocalizedString(@"No Operation Choosed.",@"Keine Operation ausgewählt")];
      NSString* InformationString=NSLocalizedString(@"At least one operation must be choosed.",@"Mindestens eine Operation muss ausgewähltsein.");
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      
      //[Warnung setIcon:RPImage];
      int antwort=[Warnung runModal];
      checkOK=NO;
   }
   else
   {
      if (multOK==1)
      {
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung addButtonWithTitle:@"OK"];
         [Warnung setMessageText:NSLocalizedString(@"No Row Choosed",@"Keine Reihe ausgewählt")];
         NSString* InformationString=NSLocalizedString(@"At least one row must be choosed.",@"Mindestens eine Reihe muss ausgewählt sein.");
         [Warnung setInformativeText:InformationString];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         int antwort=[Warnung runModal];
         [self selectSettingsTab:0];
         checkOK=NO;
      }
      if (addsubOK==1)
      {
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung addButtonWithTitle:@"OK"];
         [Warnung setMessageText:NSLocalizedString(@"No Operation Choosed.",@"Keine Operation ausgewählt")];
         NSString* InformationString=NSLocalizedString(@"Addition and/or subtraction must be choosed.",@"Addition und/oder Subtraktion muss ausgewählt sein.");
         [Warnung setInformativeText:InformationString];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         int antwort=[Warnung runModal];
         [self selectSettingsTab:1];
         checkOK=NO;
      }
      
   }
   return checkOK;
}

- (void)ClearSettings
{
   
}

- (NSDictionary*)SettingStatus
{
   //Verschoben in Testpanel 20.12.06
   NSMutableDictionary* returnStatusDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   int multOK=[ReihenSettings checkSettings];
   [returnStatusDic setObject:[NSNumber numberWithInt:multOK] forKey:@"multok"];
   int addsubOK=[AddSubSettings checkSettings];
   [returnStatusDic setObject:[NSNumber numberWithInt:addsubOK] forKey:@"addsubok"];
   
   NSLog(@"SerieDatenStatus    returnStatusDic: %@",[returnStatusDic description]);
   return returnStatusDic;
}

- (NSDictionary*)StatusVonSerieDatenDic:(NSDictionary*)derSerieDatenDic
{
   //Verschoben in Testpanel 20.12.06
   NSMutableDictionary* returnStatusDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   int complete=0;
   //	NSLog(@"StatusVonSerieDatenDic: derSerieDatenDic: %@",[derSerieDatenDic description]);
   if ([derSerieDatenDic objectForKey:@"addsubein"])
   {
      [returnStatusDic setObject:[derSerieDatenDic objectForKey:@"addsubein"]forKey:@"addsubein"];
      if ([[derSerieDatenDic objectForKey:@"addsubein"]boolValue])//AddSub aktiviert
      {
         if ([[derSerieDatenDic objectForKey:@"addition"]boolValue]||[[derSerieDatenDic objectForKey:@"subtraktion"]boolValue])
         {
            complete++;
            [returnStatusDic setObject:[NSNumber numberWithBool:YES]forKey:@"addsubok"];
         }
      }
   }//addsubein
   
   if ([derSerieDatenDic objectForKey:@"reihenein"])
   {
      [returnStatusDic setObject:[derSerieDatenDic objectForKey:@"reihenein"]forKey:@"reihenein"];
      if ([[derSerieDatenDic objectForKey:@"reihenein"]boolValue])//Reihen aktiviert
      {
         
         if ([derSerieDatenDic objectForKey:@"reihenarray"])
         {
            [returnStatusDic setObject:[NSNumber numberWithInt:[[derSerieDatenDic objectForKey:@"reihenarray"]count]]forKey:@"anzreihen"];
            if ([[derSerieDatenDic objectForKey:@"reihenarray"]count])
            {
               [returnStatusDic setObject:[NSNumber numberWithBool:YES]forKey:@"reihenok"];
               complete+=10;
            }
            
         }
      }
   }
   if ([derSerieDatenDic objectForKey:@"testname"]&&[[derSerieDatenDic objectForKey:@"testname"]length])
   {
      [returnStatusDic setObject:[NSNumber numberWithBool:YES]forKey:@"testnameok"];
   }
   else
   {
      [returnStatusDic setObject:[NSNumber numberWithBool:NO]forKey:@"testnameok"];
   }
   
   [returnStatusDic setObject:[NSNumber numberWithInt:complete]forKey:@"complete"];
   return returnStatusDic;
}

- (BOOL)checkSerieDatenDic:(NSDictionary*)derSerieDatenDic vonTest:(NSString*)derTestName
{
   //Verschoben in Testpanel 20.12.06
   BOOL SeriedatenOK=YES;
   NSDictionary* tempStatusDic=[self StatusVonSerieDatenDic:derSerieDatenDic];
   //NSLog(@"checkSerieDatenDic complete: %d",[[tempStatusDic objectForKey:@"complete"]intValue]);
   //NSLog(@"checkSerieDatenDic complete: %@",[tempStatusDic description]);
   
   if 	(derTestName&&[derTestName length])
   {
      
   }
   else//Keine Reihe
   {
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      NSString* t0=NSLocalizedString(@"Settings for test: %@ incorrect",@"Einstellungen für Test: '%@' sind nicht korrekt");
      NSString* t1=[NSString stringWithFormat:t0,derTestName];
      [Warnung setMessageText:t1];
      NSString* s2=NSLocalizedString(@"No Name for Test.",@"Der Test hat keinen Namen.");
      NSString* s3=NSLocalizedString(@"The settings are deleted.",@"Die Einstellungen werden gelöscht.");
      NSString* s1=NSLocalizedString(@"Error:",@"Fehler:");
      NSString* InformationString=[NSString stringWithFormat:@"%@\n%@\n%@",s1,s2,s3];
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      
      int antwort=[Warnung runModal];
      
      return NO;
      
      
   }
   
   
   
   
   if ([[tempStatusDic objectForKey:@"complete"]intValue])
   {
      
      if ([[tempStatusDic objectForKey:@"addsubein"]boolValue])//Add oder Sub aktiviert
      {
         if ([[tempStatusDic objectForKey:@"addsubok"]boolValue])
         {
         }
         else
         {
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"OK"];
            NSString* t0=NSLocalizedString(@"Settings for test: %@ incorrect",@"Einstellungen für Test: '%@' sind nicht korrekt");
            NSString* t1=[NSString stringWithFormat:t0,derTestName];
            [Warnung setMessageText:t1];
            NSString* s2=NSLocalizedString(@"No Operation Choosed.",@"Keine Operation ausgewählt.");
            NSString* s3=NSLocalizedString(@"Addition and/or subtraction must be choosed.",@"Addition und/oder Subtraktion muss ausgewählt sein.");
            NSString* s1=NSLocalizedString(@"Error:",@"Fehler:");
            NSString* InformationString=[NSString stringWithFormat:@"%@\n%@\n%@",s1,s2,s3];
            [Warnung setInformativeText:InformationString];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            //[Warnung setIcon:RPImage];
            int antwort=[Warnung runModal];
            return NO;
            
         }
         
      }//addsubok
      if ([[tempStatusDic objectForKey:@"reihenein"]boolValue])
      {
         if 	([[tempStatusDic objectForKey:@"reihenok"]boolValue])
         {
            
         }
         else//Keine Reihe
         {
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"OK"];
            NSString* t0=NSLocalizedString(@"Settings for test: %@ incorrect",@"Einstellungen für Test: '%@' sind nicht korrekt");
            NSString* t1=[NSString stringWithFormat:t0,derTestName];
            [Warnung setMessageText:t1];
            NSString* s2=NSLocalizedString(@"No Row Choosed.",@"Keine Reihe ausgewählt.");
            NSString* s3=NSLocalizedString(@"At least one row must be choosed.",@"Mindestens eine Reihe muss ausgewählt sein.");
            NSString* s1=NSLocalizedString(@"Error:",@"Fehler:");
            NSString* InformationString=[NSString stringWithFormat:@"%@\n%@\n%@",s1,s2,s3];
            [Warnung setInformativeText:InformationString];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            int antwort=[Warnung runModal];
            return NO;
            
            
         }
      }
      
      
   }//mind 1 Operation
   else
   {
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      NSString* t0=NSLocalizedString(@"Settings for test: %@ incorrect",@"Einstellungen für Test: '%@' sind nicht korrekt");
      NSString* t1=[NSString stringWithFormat:t0,derTestName];
      [Warnung setMessageText:t1];
      NSString* s2=NSLocalizedString(@"No Operation Choosed.",@"Keine Operation ausgewählt");
      NSString* s3=NSLocalizedString(@"At least one operation must be choosed.",@"Mindestens eine Operation muss ausgewähltsein.");
      NSString* s1=NSLocalizedString(@"Error:",@"Fehler:");
      NSString* InformationString=[NSString stringWithFormat:@"%@\n%@\n%@",s1,s2,s3];
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      
      //[Warnung setIcon:RPImage];
      int antwort=[Warnung runModal];
      return NO;
      
      
   }
   
   return SeriedatenOK;
}

- (rRechnungserie*)neueSerieMitSeriedaten:(rSeriedaten*) seriedaten
{
   NSLog(@"\neueSerieMitSeriedaten: %d",seriedaten.AnzahlAufgaben);
// /*
   int multOK=[ReihenSettings checkSettings];
   int addsubOK=[AddSubSettings checkSettings];
   NSLog(@"\neueSerieMitSeriedaten                                      multOK: %d          addsubOK: %d",multOK,addsubOK);

   [self closeSessionDrawer:NULL];
   [ErgebnisRahmenFeld setHidden:YES];
   //	[ErgebnisView setMark:0];
   //	[ErgebnisView setString:@""];
   [ErgebnisFeld setMark:0];
   [ErgebnisFeld setStringValue:@""];
   [self closeAufgabenDrawer:NULL];
   NSDictionary* tempStatusDic=[self StatusVonSerieDatenDic:SerieDatenDic];
   if ([TestPopKnopf numberOfItems])
   {
      BOOL SerieDatenOK=[self checkSerieDatenDic:SerieDatenDic vonTest:[TestPopKnopf titleOfSelectedItem]];
      //NSLog(@"tempStatusDic: %@ SerieDatenOK: %d",[tempStatusDic description],SerieDatenOK);
      if(SerieDatenOK==NO)
      {
         return nil;
      }
      
      switch ([[tempStatusDic objectForKey:@"complete"]intValue])
      {
         case 0://keine Operation aktiviert
         {
            NSLog(@"neueSerie: ex");
         }break;
            
            
      }//switch
      
      
   }//if numberOfItems
   
   [AblaufzeitTimer invalidate];
   //NSLog(@"timeIntervalSince1970: %f",[[NSDate date] timeIntervalSince1970]);
   //srand(time(NULL));
   //srand([[NSDate date] timeIntervalSince1970]);
   srandom((unsigned int)[[NSDate date] timeIntervalSince1970]);
   //srand(time(0));
   //NSLog(@"timeIntervalSinceNow: %qi",[[NSDate date] timeIntervalSinceNow]);
   
   //NSLog(@"neueSerie: random: %d ",random());
 
 // */
   NSLog(@"neueSerieMitSeriedaten: SerieDatenDic: %@ ",SerieDatenDic);
  // RechnungSeriedaten=[self SerieDatenVonDic:SerieDatenDic];
   
   //RechnungSeriedaten = seriedaten;
   
   NSLog(@"RechnungSeriedaten AnzahlAufgaben: %d",RechnungSeriedaten.AnzahlAufgaben);
   NSLog(@"RechnungSeriedaten MDKleines1Mal1: %d",RechnungSeriedaten.MDKleines1Mal1);
   
   
   
   if (Modus==kTrainingModus)
   {
      RechnungSeriedaten.AnzahlAufgaben=[[AnzahlPopKnopf selectedItem]tag];
      RechnungSeriedaten.Zeit=[[ZeitPopKnopf selectedItem]tag];
      [ZeitPopKnopf setHidden:NO];
      [AnzahlPopKnopf setHidden:NO];
      [ZeitLimiteFeld setHidden:YES];
      [AnzahlFeld setHidden:YES];
      
   }
   else
   {
      [ZeitPopKnopf setHidden:YES];
      [AnzahlPopKnopf setHidden:YES];
      [ZeitLimiteFeld setHidden:NO];
      [AnzahlFeld setHidden:NO];
      
   }
   
   abgelaufeneZeit=0;
   anzRichtig=0;
   anzFehler=0;
   MaximalZeit=RechnungSeriedaten.Zeit;
   //NSLog(@"neue Serie: Zeit: %d",MaximalZeit);
   AnzahlAufgaben=RechnungSeriedaten.AnzahlAufgaben;
   
   [AnzahlPopKnopf selectItemAtIndex:[AnzahlPopKnopf indexOfItemWithTag:RechnungSeriedaten.AnzahlAufgaben]];
   [ZeitPopKnopf selectItemAtIndex:[ZeitPopKnopf indexOfItemWithTag:RechnungSeriedaten.Zeit]];
   //AnzahlAufgaben=[[AnzahlPopKnopf titleOfSelectedItem]intValue];
   //NSLog(@"					AnzahlAufgaben: %d",AnzahlAufgaben);
   //MaximalZeit=[[ZeitPopKnopf titleOfSelectedItem]intValue];
   aktuelleAufgabenNummer=1;
   [StartTaste setTitle:NSLocalizedString(@"Start",@"Start")];
   [AufgabenNummerFeld setIntValue:1];
   [ZeitFeld setIntValue:MaximalZeit];
   NSString* ZeitLimiteString=[NSString stringWithFormat:@"%d Sekunden",MaximalZeit];
   [ZeitLimiteFeld setStringValue:ZeitLimiteString];
   
   [Zeitanzeige setMax:MaximalZeit];
   [Zeitanzeige setZeit:0];
   //[Aufgabenzeiger setAnzAufgaben:[[AnzahlPopKnopf titleOfSelectedItem]intValue]];
   [Aufgabenzeiger setAnzAufgaben:AnzahlAufgaben];
   NSString* AnzahlString=[NSString stringWithFormat:@"%d Aufgaben",AnzahlAufgaben];
   
   [AnzahlFeld setStringValue:AnzahlString];
   [Aufgabenzeiger setAnzahl:0];
   [ErgebnisRahmenFeld setMark:-1];
   
   
   AufgabenSerie = [[rRechnungserie alloc]initWithAnzahl:RechnungSeriedaten.AnzahlAufgaben];
   
   
   AufgabenArray = [[NSArray alloc]initWithArray:[AufgabenSerie neueRechnungserie:RechnungSeriedaten]]; // NSArray
   
   
   //rAufgabenDaten*  AufgabenDatenArray[kMaxAnzahlAufgaben];
   
   //NSLog(@"neueSerie: Add: %d  Sub: %d  Mult: %d",SerieDaten.Addition,RechnungSeriedaten.Subtraktion,SerieDaten.Multiplikation);
   
   
   //   AufgabenSerie->neueSerie(SerieDaten,AufgabenDatenArray);
   
   
   
   NSMutableArray* tempAufgabenArray=[[NSMutableArray alloc]initWithCapacity:0];
   //NSLog(@"tempAufgabenDatenArray: nach neueSerie");
   int zeile;
   for (zeile=0;zeile<RechnungSeriedaten.AnzahlAufgaben;zeile++)
   {
      rAufgabenDaten* tempAufgabendaten = [AufgabenArray objectAtIndex:zeile];
      //NSLog(@"neueSerie: zeile: %d",zeile);
      //NSLog(@"neueSerie: nummer: %d var 0: %d op 0: %d var 1: %d var 2: %d",AufgabenDatenArray[zeile].aktuelleAufgabennummer,AufgabenDatenArray[zeile].var[0],AufgabenDatenArray[zeile].op[0],AufgabenDatenArray[zeile].var[1],AufgabenDatenArray[zeile].var[2]);
      //AufgabenNummer
      
      //AufgabenDatenArray[zeile] = [[rAufgabenDaten alloc]init];
      
      NSMutableDictionary* tempAufgabenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      int nr =tempAufgabendaten.aktuelleAufgabennummer;
      
      [tempAufgabenDic setObject:[NSNumber numberWithInt:tempAufgabendaten.aktuelleAufgabennummer] forKey:@"aufgabennummer"];
      
      //Var 0
      
      [tempAufgabenDic setObject:[NSNumber numberWithInt:tempAufgabendaten->var[0]]
                          forKey:@"var0"];
      
      //Var 1
      [tempAufgabenDic setObject:[NSNumber numberWithInt:tempAufgabendaten->var[1]]
                          forKey:@"var1"];
      
      //AufgabenDatenArray[zeile].aktuelleAufgabennummer = zeile;
   
      
      //Op
      NSString* Operator;
      int op0 = tempAufgabendaten->op[0];
      
      switch(op0)
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
      
      [tempAufgabenDic setObject:[NSNumber numberWithInt:op0+2000]
                          forKey:@"op0"];
      
      //Ergebnis
      [tempAufgabenDic setObject:[NSNumber numberWithInt:tempAufgabendaten->var[2]]
                          forKey:@"var2"];
      NSLog(@"tempAufgabenDic: %@",[tempAufgabenDic description]);
      [tempAufgabenArray addObject:tempAufgabenDic];
      
   }
   
   	NSLog(@"tempAufgabenArray: %@",[tempAufgabenArray description]);
   
   
   //AufgabenArray=[tempAufgabenArray copy];
   AufgabenArray=[NSArray arrayWithArray:tempAufgabenArray];
   [StartTaste setEnabled:YES];
   [StartTaste setKeyEquivalent:@"\r"];
   [[self window]makeFirstResponder:StartTaste];
   [ErgebnisFeld resetFalschesZeichen];
   //[self startTimeout];
   //NSLog(@"neue Serie ende");
   return nil;
}

/*
- (rSeriedaten*)SerieDatenVonDic:(NSDictionary*)derSerieDatenDic
{
   int DatenOK=0;
   rSeriedaten* tempSerieDaten = [[rSeriedaten alloc]init];
   NSLog(@"tempSerieDaten AnzahlAufgaben: %d",tempSerieDaten.AnzahlAufgaben);
   NSIndexSet* BoolBereich=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)];
   
   NSIndexSet* AnzBereich=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,24)];
   NSNumber* tempAnzNumber=[derSerieDatenDic objectForKey:@"anzahlaufgaben"];
   if (tempAnzNumber&&[AnzBereich containsIndex:[tempAnzNumber intValue]])
   {
      [tempSerieDaten setzeAnzahlAufgaben:[tempAnzNumber intValue]];
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
            tempSerieDaten->Reihenliste[i]=[[tempReihenArray objectAtIndex:i]intValue];
         }
         else
         {
            tempSerieDaten->Reihenliste[i]=0;
         }
      }//for i
   }
   else//Keine Reihen
   {
      for (int i=0;i<kMaxAnzReihen;i++)
      {
         if (i<tempSerieDaten.AnzahlReihen)
         {
            tempSerieDaten->Reihenliste[i]=i+1;
         }
         else
         {
            tempSerieDaten->Reihenliste[i]=0;
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
   NSLog(@"tempSerieDaten AnzahlAufgaben: %d",tempSerieDaten.AnzahlAufgaben);
   NSLog(@"tempSerieDaten MDKleines1Mal1: %d",tempSerieDaten.MDKleines1Mal1);
   
   NSLog(@"SerieDateVonDic tempSerieDaten : %@",[tempSerieDaten description]);
   return tempSerieDaten;
   
   return nil;
}
*/

- (IBAction)neueSerie:(id)sender
{
   
   
   int multOK=[ReihenSettings checkSettings];
   int addsubOK=[AddSubSettings checkSettings];
   //NSLog(@"\nneueSerie                                      multOK: %d          addsubOK: %d",multOK,addsubOK);
   
   
   [self closeSessionDrawer:NULL];
   //NSLog(@"neue Serie begin");
   //NSLog(@"neueSerie Anfang: SeriedatenDic: %@\n",[SerieDatenDic description]);
   [ErgebnisRahmenFeld setHidden:YES];
   //	[ErgebnisView setMark:0];
   //	[ErgebnisView setString:@""];
   [ErgebnisFeld setMark:0];
   [ErgebnisFeld setStringValue:@""];
   [self closeAufgabenDrawer:NULL];
   /*
    if ([SettingsDrawer state]==NSDrawerOpenState)
    {
    //NSLog(@"neueSerie: SettingsDrawer =NSDrawerOpenState");
    [SerieDatenDic setObject:@"Training" forKey:@"testname"];
    [SerieDatenDic addEntriesFromDictionary:[self SerieDatenDicAusSettings]];
    [self closeDrawer:NULL];
    //NSLog(@"neueSerie nach closeDrawer: SeriedatenDic: %@\n",[SerieDatenDic description]);
    }
    */
   NSDictionary* tempStatusDic=[self StatusVonSerieDatenDic:SerieDatenDic];
   if ([TestPopKnopf numberOfItems])
   {
      BOOL SerieDatenOK=[self checkSerieDatenDic:SerieDatenDic vonTest:[TestPopKnopf titleOfSelectedItem]];
      //NSLog(@"tempStatusDic: %@ SerieDatenOK: %d",[tempStatusDic description],SerieDatenOK);
      if(SerieDatenOK==NO)
      {
         return;
      }
      
      switch ([[tempStatusDic objectForKey:@"complete"]intValue])
      {
         case 0://keine Operation aktiviert
         {
            NSLog(@"neueSerie: ex");
         }break;
            
            
      }//switch
      
      
   }//if numberOfItems
   
   [AblaufzeitTimer invalidate];
   //NSLog(@"timeIntervalSince1970: %f",[[NSDate date] timeIntervalSince1970]);
   //srand(time(NULL));
   //srand([[NSDate date] timeIntervalSince1970]);
   srandom((unsigned int)[[NSDate date] timeIntervalSince1970]);
   //srand(time(0));
   //NSLog(@"timeIntervalSinceNow: %qi",[[NSDate date] timeIntervalSinceNow]);
   
   //NSLog(@"neueSerie: random: %d ",random());
   RechnungSeriedaten=[self SerieDatenVonDic:SerieDatenDic];
   NSLog(@"RechnungSeriedaten AnzahlAufgaben: %d",RechnungSeriedaten.AnzahlAufgaben);
   NSLog(@"RechnungSeriedaten MDKleines1Mal1: %d",RechnungSeriedaten.MDKleines1Mal1);

   
   
   if (Modus==kTrainingModus)
   {
      RechnungSeriedaten.AnzahlAufgaben=[[AnzahlPopKnopf selectedItem]tag];
      RechnungSeriedaten.Zeit=[[ZeitPopKnopf selectedItem]tag];
      [ZeitPopKnopf setHidden:NO];
      [AnzahlPopKnopf setHidden:NO];
      [ZeitLimiteFeld setHidden:YES];
      [AnzahlFeld setHidden:YES];
      
   }
   else
   {
      [ZeitPopKnopf setHidden:YES];
      [AnzahlPopKnopf setHidden:YES];
      [ZeitLimiteFeld setHidden:NO];
      [AnzahlFeld setHidden:NO];
      
   }
   
   abgelaufeneZeit=0;
   anzRichtig=0;
   anzFehler=0;
   MaximalZeit=RechnungSeriedaten.Zeit;
   //NSLog(@"neue Serie: Zeit: %d",MaximalZeit);
   AnzahlAufgaben=RechnungSeriedaten.AnzahlAufgaben;
   
   [AnzahlPopKnopf selectItemAtIndex:[AnzahlPopKnopf indexOfItemWithTag:RechnungSeriedaten.AnzahlAufgaben]];
   [ZeitPopKnopf selectItemAtIndex:[ZeitPopKnopf indexOfItemWithTag:RechnungSeriedaten.Zeit]];
   //AnzahlAufgaben=[[AnzahlPopKnopf titleOfSelectedItem]intValue];
   //NSLog(@"					AnzahlAufgaben: %d",AnzahlAufgaben);
   //MaximalZeit=[[ZeitPopKnopf titleOfSelectedItem]intValue];
   aktuelleAufgabenNummer=1;
   [StartTaste setTitle:NSLocalizedString(@"Start",@"Start")];
   [AufgabenNummerFeld setIntValue:1];
   [ZeitFeld setIntValue:MaximalZeit];
   NSString* ZeitLimiteString=[NSString stringWithFormat:@"%d Sekunden",MaximalZeit];
   [ZeitLimiteFeld setStringValue:ZeitLimiteString];
   
   [Zeitanzeige setMax:MaximalZeit];
   [Zeitanzeige setZeit:0];
   //[Aufgabenzeiger setAnzAufgaben:[[AnzahlPopKnopf titleOfSelectedItem]intValue]];
   [Aufgabenzeiger setAnzAufgaben:AnzahlAufgaben];
   NSString* AnzahlString=[NSString stringWithFormat:@"%d Aufgaben",AnzahlAufgaben];
   
   [AnzahlFeld setStringValue:AnzahlString];
   [Aufgabenzeiger setAnzahl:0];
   [ErgebnisRahmenFeld setMark:-1];
   
   /*
   if (!AufgabenSerie)
   {
      AufgabenSerie = malloc(size(rAufgabenSerie));
      AufgabenSerie=new rSerie(SerieDaten.AnzahlAufgaben);
   }
   */
   //NSLog(@"neueSerie: %d",SerieDaten.AnzahlAufgaben);
   
   
   rAufgabenDaten*  AufgabenDatenArray[kMaxAnzahlAufgaben];
 
   
   //NSLog(@"neueSerie: Add: %d  Sub: %d  Mult: %d",SerieDaten.Addition,RechnungSeriedaten.Subtraktion,SerieDaten.Multiplikation);
//   AufgabenSerie->neueSerie(SerieDaten,AufgabenDatenArray);
   
 // Ersatz:
   
// - (rSeriedaten*)neueSerie:(ProgPrefsRecord)dieSeriedaten AufgabenDaten:(cAufgabendaten*) derAufgabenDatenArray
   
   AufgabenSerie = [self neueSerieMitSeriedaten:RechnungSeriedaten]; //
   
   return;
   
   //NSLog(@"neueSerie: nummer: %d var 0: %d op 0: %d var 1: %d var 2: %d",AufgabenDatenArray[0].aktuelleAufgabennummer,AufgabenDatenArray[0].var[0],AufgabenDatenArray[0].op[0],AufgabenDatenArray[0].var[1],AufgabenDatenArray[0].var[2]);
   
  
   NSMutableArray* tempAufgabenArray=[[NSMutableArray alloc]initWithCapacity:0];
   //NSLog(@"tempAufgabenDatenArray: nach neueSerie");
   int zeile;
   for (zeile=0;zeile<RechnungSeriedaten.AnzahlAufgaben;zeile++)
   {
      //NSLog(@"neueSerie: zeile: %d",zeile);
      //NSLog(@"neueSerie: nummer: %d var 0: %d op 0: %d var 1: %d var 2: %d",AufgabenDatenArray[zeile].aktuelleAufgabennummer,AufgabenDatenArray[zeile].var[0],AufgabenDatenArray[zeile].op[0],AufgabenDatenArray[zeile].var[1],AufgabenDatenArray[zeile].var[2]);
      //AufgabenNummer
      
      AufgabenDatenArray[zeile] = [[rAufgabenDaten alloc]init];
      NSMutableDictionary* tempAufgabenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [tempAufgabenDic setObject:[NSNumber numberWithInt:AufgabenDatenArray[zeile].aktuelleAufgabennummer]
                          forKey:@"aufgabennummer"];
      
      //Var 0
      [tempAufgabenDic setObject:[NSNumber numberWithInt:AufgabenDatenArray[zeile]->var[0]]
                          forKey:@"var0"];
      
      //Var 1
      [tempAufgabenDic setObject:[NSNumber numberWithInt:AufgabenDatenArray[zeile]->var[1]]
                          forKey:@"var1"];
      
      AufgabenDatenArray[zeile].aktuelleAufgabennummer = zeile;
      //Op
      NSString* Operator;
      int op0 = AufgabenDatenArray[zeile]->op[0];
      switch(AufgabenDatenArray[zeile]->op[0])
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
      
      [tempAufgabenDic setObject:[NSNumber numberWithInt:AufgabenDatenArray[zeile]->op[0]+2000]
                          forKey:@"op0"];
      
      //Ergebnis
      [tempAufgabenDic setObject:[NSNumber numberWithInt:AufgabenDatenArray[zeile]->var[2]]
                          forKey:@"var2"];
      //NSLog(@"tempAufgabenDic: %@",[tempAufgabenDic description]);
      [tempAufgabenArray addObject:tempAufgabenDic];
      
   }
   
   //	NSLog(@"tempAufgabenArray: %@",[tempAufgabenArray description]);
   
   
   //AufgabenArray=[tempAufgabenArray copy];
   AufgabenArray=[NSArray arrayWithArray:tempAufgabenArray];
   [StartTaste setEnabled:YES];
   [StartTaste setKeyEquivalent:@"\r"];
   [[self window]makeFirstResponder:StartTaste];
   [ErgebnisFeld resetFalschesZeichen];
   //[self startTimeout];
   //NSLog(@"neue Serie ende");
}

- (rSeriedaten*)SerieDatenVonDic:(NSDictionary*)derSerieDatenDic
{
   int DatenOK=0;
   rSeriedaten* tempSerieDaten = [[rSeriedaten alloc]init];
   NSLog(@"tempSerieDaten AnzahlAufgaben: %d",tempSerieDaten.AnzahlAufgaben);
   NSIndexSet* BoolBereich=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)];
   
   NSIndexSet* AnzBereich=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,24)];
   NSNumber* tempAnzNumber=[derSerieDatenDic objectForKey:@"anzahlaufgaben"];
   if (tempAnzNumber&&[AnzBereich containsIndex:[tempAnzNumber intValue]])
   {
      [tempSerieDaten setzeAnzahlAufgaben:[tempAnzNumber intValue]];
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
            tempSerieDaten->Reihenliste[i]=[[tempReihenArray objectAtIndex:i]intValue];
         }
         else
         {
            tempSerieDaten->Reihenliste[i]=0;
         }
      }//for i
   }
   else//Keine Reihen
   {
      for (int i=0;i<kMaxAnzReihen;i++)
      {
         if (i<tempSerieDaten.AnzahlReihen)
         {
            tempSerieDaten->Reihenliste[i]=i+1;
         }
         else
         {
            tempSerieDaten->Reihenliste[i]=0;
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
    NSLog(@"tempSerieDaten AnzahlAufgaben: %d",tempSerieDaten.AnzahlAufgaben);
   NSLog(@"tempSerieDaten MDKleines1Mal1: %d",tempSerieDaten.MDKleines1Mal1);

    NSLog(@"SerieDateVonDic tempSerieDaten : %@",[tempSerieDaten description]);
   return tempSerieDaten;
}

- (rSeriedaten*)SerieDatenVonSettings
{
   int SettingsOK=0;
   rSeriedaten* tempSerieDaten;
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
            tempSerieDaten->Reihenliste[i]=[[tempReihenArray objectAtIndex:i]intValue];
         }
         else
         {
            tempSerieDaten->Reihenliste[i]=0;
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


- (NSDictionary*)SerieDatenDicVon:(rSeriedaten*)dieSerieDaten
{
   NSMutableDictionary* tempDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.AnzahlAufgaben] forKey:@"anzahlaufgaben"];
   [tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.Zeit] forKey:@"zeit"];
   
   //Multiplikation
   [tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.Multiplikation] forKey:@"multiplikation"];
   [tempDic setObject:[NSNumber numberWithInt:dieSerieDaten.AnzahlReihen] forKey:@"anzahlreihen"];
   NSMutableArray* tempReihenArray=[[NSMutableArray alloc]initWithCapacity:0];
   for (int i=0;i<dieSerieDaten.AnzahlReihen;i++)
   {
      [tempReihenArray addObject:[NSNumber numberWithInt:RechnungSeriedaten->Reihenliste[i]]];
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
   NSMutableDictionary* tempDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [tempDic setObject:[NSNumber numberWithInt:12] forKey:@"anzahlaufgaben"];
   [tempDic setObject:[NSNumber numberWithInt:120] forKey:@"zeit"];
   
   //Multiplikation
   [tempDic setObject:[NSNumber numberWithInt:1] forKey:@"multiplikation"];
   [tempDic setObject:[NSNumber numberWithInt:8] forKey:@"anzahlreihen"];
   NSMutableArray* tempReihenArray=[[NSMutableArray alloc]initWithCapacity:0];
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
   NSMutableDictionary* tempDic=[[NSMutableDictionary alloc]initWithCapacity:0];
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

- (IBAction)AufgabeAb:(id)sender
{
   //[self markReset];
   [self closeSessionDrawer:NULL];
   //NSLog(@"nextAufgabe Ab: Start");
   if (([NamenPopKnopf indexOfSelectedItem]==0)&&(Modus==kTestModus))//Kein Name
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
   AufgabeOK=0;
   //[self setOK:NO];
   [ErgebnisRahmenFeld setHidden:YES];
   //	[ErgebnisView setMark:0];
   [ErgebnisFeld setMark:0];
   //[StartTaste setEnabled:NO];
   BOOL AufgabeOK=YES;
   //[ErgebnisFeld setStringValue:@""];
   //	[ErgebnisView setString:@""];
   [ErgebnisFeld setStringValue:@""];
   
   //	NSLog(@"\n									NextAufgabeAb: Titel: %@ aktuelleAufgabenNummer: %d\n",[sender title],aktuelleAufgabenNummer);
   //NSLog(@"Loc: %@",NSLocalizedString(@"End",@"Fertig"));
   
   if ((aktuelleAufgabenNummer==1)&&[NamenPopKnopf indexOfSelectedItem])
   {
      [self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];//VOLUME SICHERN
      [self SessionDatumSichernVon:[NamenPopKnopf titleOfSelectedItem]];
      
   }
   else
   {
      //	return;
   }
   
   if (aktuelleAufgabenNummer>AnzahlAufgaben)
   {
      //[sender setTitle:NSLocalizedString(@"End",@"Fertig")];
      //NSLog(@"AufgabeAb: aktuelleAufgabenNummer==AnzahlAufgaben");
   }
   
   else
   {
      [NamenPopKnopf setEnabled: NO];
      //[TestPopKnopf setEnabled: NO];
      [neueSerieTaste setEnabled: (Modus==kTrainingModus)];//nur im Testmodus abschalten
      [ModusOption setEnabled: (Modus==kTrainingModus)];
      [ErgebnisseTaste setEnabled: NO];
      [ToggleSessionKnopf setEnabled: NO];
      //		NSLog(@"AufgabeAb: AufgabenArray count: %d nummer: %d",[AufgabenArray count],aktuelleAufgabenNummer);
      //NSLog(@"AufgabeAb: AufgabenArray : %@ ",[AufgabenArray description]);
      
      NSDictionary* tempAufgabenDic=[AufgabenArray objectAtIndex:aktuelleAufgabenNummer-1];
      if(tempAufgabenDic)
      {
         NSLog(@"tempAufgabenDic: %@",[tempAufgabenDic description]);
         //[Aufgabenzeiger setAnzahl:aktuelleAufgabenNummer];
         [[self window]makeFirstResponder:self];
         AufgabeOK=[Speaker AufgabeAb:tempAufgabenDic];
         
         // Play wird im Speaker aufgerufen
         
         // Movie von Speaker holen
         //			[AufgabenQTKitPlayer setMovie:[Speaker AufgabenQTKitMovie]];
         //[AufgabenQTKitPlayer setControllerVisible:YES];
         //			[AufgabenQTKitPlayer play:NULL];
      }
   }
   //aktuelleAufgabenNummer++;
   verify=YES;
   
   TimerValid=YES;
   
   
   
   
   [ErgebnisFeld setEditable:YES];
   [ErgebnisFeld setSelectable:YES];
   [ErgebnisFeld selectText:NULL];
   [ErgebnisFeld setReady:YES];
   [[self window]makeFirstResponder:ErgebnisFeld];
   
   //	NSLog(@"NextAufgabeAb end\n\n");
}

- (void)keyDown:(NSEvent *)theEvent
{
   NSString* c=[theEvent characters];
   NSLog(@"Controller keyDown: c: %@  code: %d ",c,[theEvent keyCode]);
}

- (void)FalschesZeichenAktion:(NSNotification*)note
{
   //NSLog(@"FalschesZeichenAktion: note: %@",[[note userInfo]description]);
   BOOL Warnzeichen=NO;
   if ([note userInfo]&&[[note userInfo] objectForKey:@"anzfalscheszeichen"])
   {
      int anzFalschesZeichen=[[[note userInfo] objectForKey:@"anzfalscheszeichen"] intValue];
      NSString* InfText=@"Es sind nur die Ziffern von 0 bis 9 erlaubt";
      int delay=2.5;
      //	NSLog(@"FalschesZeichenAktion: anzFalschesZeichen: %d",anzFalschesZeichen);
      
      switch (anzFalschesZeichen)
      {
         case 1:
         case 2:
         {
            
            InfText=[InfText stringByAppendingString:[NSString stringWithFormat:@"\nBisher hast du dich %d mal vertippt",anzFalschesZeichen]];
         }break;
         case 3:
         {
            
            NSMutableDictionary* tempQuittungDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            
            //Falsches Zeichen
            [tempQuittungDic setObject:[NSNumber numberWithInt:kFalschesZeichen]
                                forKey:@"quittung"];
            BOOL QuittungOK=[Speaker QuittungAb:tempQuittungDic];
            
            NSString* s1=@"\nDu hast dich zu oft vertippt.";
            NSString* s2=@"\n\nVon jetzt an werden dir jedesmal 10 s abgezogen!";
            InfText=[InfText stringByAppendingString:[NSString stringWithFormat:@"%@ %@",s1,s2]];
            NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"Vertipper" object:self userInfo:NULL];
            delay=5.0;
         }break;
         default:
         {
            NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"Vertipper" object:self userInfo:NULL];
            delay=0.1;
         }
      }//switch
      
      
      falschesZeichenTimer=[NSTimer scheduledTimerWithTimeInterval:delay
                                                             target:self
                                                           selector:@selector(FalschesZeichenFunktion:)
                                                           userInfo:nil
                                                            repeats:NO];
      
      if (anzFalschesZeichen<=3)
      {
         NSAlert * FalschesZeichenAlert=[NSAlert alertWithMessageText:@"Falsches Zeichen!"
                                                        defaultButton:NULL
                                                      alternateButton:NULL
                                                          otherButton:NULL
                                            informativeTextWithFormat:@"%@",InfText];
         
         
         [[NSRunLoop currentRunLoop] addTimer: falschesZeichenTimer forMode:NSModalPanelRunLoopMode];
         
         [FalschesZeichenAlert runModal];
      }
      //	NSLog(@"Falsches ZeichenAktion");
      
      
   }
   
   if (Warnzeichen)
   {
      
      NSMutableDictionary* tempQuittungDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
      //Falsches Zeichen
      [tempQuittungDic setObject:[NSNumber numberWithInt:kFalschesZeichen]
                          forKey:@"quittung"];
      BOOL QuittungOK=[Speaker QuittungAb:tempQuittungDic];
   }//if
}


- (void)FalschesZeichenFunktion:(NSTimer*)derTimer
{
   //NSLog(@"FalschesZeichenFunktion : info: %@",[derTimer userInfo]);
   [falschesZeichenTimer invalidate];
   //	[NSApp stopModalWithCode:0];
   [NSApp abortModal];
   
}

- (void)WeiterfahrenAktion:(NSNotification*)note
{
   NSLog(@"WeiterfahrenAktion");
   [TestPopKnopf setEnabled:YES];
   
}

- (void)OKAktion:(NSNotification*)note
{
   //NSLog(@"OKAktion");
   [OKTaste setEnabled:YES];
}


- (void)VertipperAktion:(NSNotification*)note
{
   //	NSLog(@"VertipperAktion: abgelaufeneZeit: %d max: %d", abgelaufeneZeit/10,MaximalZeit);
   abgelaufeneZeit+=100.0;
   if (abgelaufeneZeit/10>=MaximalZeit)
   {
      abgelaufeneZeit=10*(MaximalZeit);
   }
   
   {
      [Zeitanzeige setZehntelZeit:abgelaufeneZeit];
   }
}

- (void)QTKitQuittungFertigAktion:(NSNotification*)note
{
   NSLog(@"SndCalcController QTKitQuittungFertigAktion note: %@",[[note userInfo]description]);
   {
      
   }
}


- (void)AufgabelesenFertigAktion:(NSNotification*)note
{
   
   [ErgebnisRahmenFeld setHidden:YES];
   //NSLog(@"SndCalcController AufgabelesenFertigAktion: note: %@",[[note userInfo]description]);
   NSNumber* AufgabenStatusNumber=(NSNumber*)[[note userInfo]objectForKey:@"fertig"];
   int status=(int)[AufgabenStatusNumber intValue];
   
   //	[[self window]makeFirstResponder:ErgebnisView];
   //	[ErgebnisView setEditable:YES];
   //	[ErgebnisView setSelectable:YES];
   //	[ErgebnisView selectAll:NULL];
   
   
   
   //verify=YES;
   if ([AblaufzeitTimer isValid])
   {
      //NSLog(@"AufgabelesenFertigAktion AblaufzeitTimer invalidate");
      [AblaufzeitTimer invalidate];
   }
   AblaufzeitTimer=[NSTimer scheduledTimerWithTimeInterval:0.1
                                                     target:self
                                                   selector:@selector(AblaufzeitTimerFunktion:)
                                                   userInfo:nil
                                                    repeats:YES];
   //NSLog(@"AufgabelesenFertigAktion AblaufzeitTimer gestartet");
   TimerValid=YES;
   AufgabeOK=YES;
   [self setOK:YES];
   
   [StartTaste setTitle:NSLocalizedString(@"Repeat",@"Wiederholen")];
   
}



- (NSDictionary*)SerieErgebnisDic
{
   NSMutableDictionary* tempDic=[[NSMutableDictionary alloc]initWithCapacity:0];
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
      if (abgelaufeneZeit/10>=MaximalZeit)
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
   //[ErgebnisView setEditable:NO];
   
   [ErgebnisFeld setEditable:NO];
   [[self window]makeFirstResponder:StartTaste];
   [StartTaste setKeyEquivalent:@"\r"];
   
   
   [TestPopKnopf setEnabled:YES];
   //NSLog(@"SerieFertig: Ergebnis: %@",[derErgebnisDic description]);
   if ([AblaufzeitTimer isValid])
   {
      [AblaufzeitTimer invalidate];
   }
   
   [self showDiplomFensterMitErgebnis:derErgebnisDic];
   
   return antwort;
}

- (void)saveErgebnisVon:(NSString*)derBenutzer mitErgebnis:(NSDictionary*) derErgebnisDic
{
   int tempOK=[Utils setDatenDic:derErgebnisDic forUser:derBenutzer anPfad:SndCalcPfad];
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
   NSMutableDictionary* tempErgebnisDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   tempErgebnisDic=[derErgebnisDic mutableCopy];
   NSModalSession PasswortSession=[NSApp beginModalSessionForWindow:[DiplomFenster window]];
   
   [DiplomFenster setDiplomMit:derErgebnisDic];
   
   //BOOL TastenStatus=((Status==kBenutzer)&&(Modus=kTestModus));//
   BOOL TastenStatus=(([NamenPopKnopf indexOfSelectedItem])&&(Modus=kTestModus));//
   //	NSLog(@"Status: %d index: %d TastenStatus: %d",Status, [TestPopKnopf indexOfSelectedItem],TastenStatus);
   [DiplomFenster setTastenStatus:TastenStatus];
   //Tasten zum Sichern der Ergebnisse nur im Testmodus und Benutzerstatus zeigen
   int modalAntwort = [NSApp runModalForWindow:[DiplomFenster window]];
   //[DiplomFenster setDiplomMit:derErgebnisDic];
   [NSApp endModalSession:PasswortSession];
   
   //NSLog(@"showDiplomFensterMitErgebnis nach endModalSession	: Antwort: %d	Status: %d",modalAntwort,Status);
   
   if ([NamenPopKnopf indexOfSelectedItem]&&[DiplomFenster TestSichernOK])//nicht Gast
   {
      NSMutableDictionary* tempDatenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
      NSMutableDictionary* returnDatenDic=(NSMutableDictionary*)[[Utils DatenDicForUser:[NamenPopKnopf titleOfSelectedItem] anPfad:SndCalcPfad]objectForKey:@"userplist"];
      
      //NSLog(@"returnDatenDic nature: %@\n\n",[returnDatenDic description]);
      if (!returnDatenDic)
      {
         returnDatenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      }
      
      if (![returnDatenDic objectForKey:@"name"])
      {
         [returnDatenDic setObject:[NamenPopKnopf titleOfSelectedItem] forKey:@"name"];
      }
      
      [returnDatenDic setObject:[TestPopKnopf titleOfSelectedItem]forKey:@"lasttest"];
      
      if (![returnDatenDic objectForKey:@"ergebnisdicarray"])
      {
         //NSLog(@"returnDatenDic ohne ergebnisdicarray: %@",[returnDatenDic description]);
         
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
      
      BOOL tempOK=[Utils setDatenDic:returnDatenDic forUser:[NamenPopKnopf titleOfSelectedItem] anPfad:SndCalcPfad];
      
      
      
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
         if ([AufgabenNummerFeld intValue]>1)//Schon eine Aufgabe gemacht, also Session erfüllt
         {
            //[self SessionDatumSichernVon:[NamenPopKnopf titleOfSelectedItem]];
         }
         
         [self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
         //22.09		[self SessionDatumSichernVon:[NamenPopKnopf titleOfSelectedItem]];
      }
      //NSImage* SessionYESImg=[NSImage imageNamed:@"MarkOnImg.tif"];
      //[[NamenPopKnopf selectedItem]setImage:SessionYESImg];
      [self SessionAktualisieren:NULL];
   }//if ! Gast
   
   
   [NamenPopKnopf setEnabled: YES];
   [TestPopKnopf setEnabled: YES];
   [neueSerieTaste setEnabled: YES];
   [ModusOption setEnabled: YES];
   [ErgebnisseTaste setEnabled: [NamenPopKnopf indexOfSelectedItem]];
   [ToggleSessionKnopf setEnabled: [NamenPopKnopf indexOfSelectedItem]];
   
   switch (modalAntwort)
   {
      case 0://Aufhören
      {
         //			NSLog(@"showDiplomFensterMitErg: Aufhoeren");
         [NamenPopKnopf selectItemAtIndex:0];
         [ErgebnisseTaste setEnabled:NO];
         [self neueSerie:NULL];
         
         //[self BeendenAktion:NULL];
      }break;
      case 1://Weiterfahren
      {
         //			NSLog(@"showDiplomFensterMitErg: Weiterfahren");
         [self neueSerie:NULL];
         
         //[self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
      }break;
         
      case 2://Ergebnisse anschauen
      {
         //			NSLog(@"\nshowDiplomFensterMitErg: Ergebnisse anschauen\n");
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
         //			NSLog(@"\nshowDiplomFensterMitErg: Abbruch durch Timer\n");
         //			[self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
         //			[self SessionDatumSichernVon:[NamenPopKnopf titleOfSelectedItem]];
         [NamenPopKnopf selectItemAtIndex:0];
         [ErgebnisseTaste setEnabled:NO];
         [self neueSerie:NULL];
         
      }
   }//switch
   
   [NamenPopKnopf setEnabled:YES];
   
}


- (IBAction)OKTastenAktion:(id)sender
{
   
   [OKTaste setEnabled:NO];
   NSLog(@"Controller OKTastenAktion");
   
   [ErgebnisFeld setSelectable:NO];
   [ErgebnisFeld setEditable:NO];
   
   // Timer fuer Rechnungszeit anhalten
   if ([AblaufzeitTimer isValid])
   {
      [AblaufzeitTimer invalidate];
   }
   
   
   //[ErgebnisFeld display];
   NSLog(@"OKTastenAktion: verify: %d",verify);
   if (verify)
   {
      BOOL tempOK=[self checkAufgabe];
      //[StartTaste setEnabled:YES];
      [StartTaste setKeyEquivalent:@"\r"];
      //[[self window]makeFirstResponder:StartTaste];
      [[self window]makeFirstResponder:[self window]];
      verify=NO;
   }
}

- (void)ErgebnisFeldAktion:(id)sender
{
   //NSLog(@"Controller  ErgebnisFeldAktion: %@ verify: %d",[ErgebnisFeld stringValue],verify);
   
   // Timer fuer Rechnungszeit anhalten
   if ([AblaufzeitTimer isValid])
   {
      [AblaufzeitTimer invalidate];
   }
   
   
   [ErgebnisFeld setSelectable:NO];
   [ErgebnisFeld setEditable:NO];
   [ErgebnisFeld display];
   if (verify)
   {
      // ERgebnis testen und naechste Aufgabe ab
      BOOL tempOK=[self checkAufgabe];
      //		NSLog(@"ErgebnisFeldAktion nach checkAufgabe");
      verify=NO;
      //[StartTaste setEnabled:YES];
      [StartTaste setKeyEquivalent:@"\r"];
      //[[self window]makeFirstResponder:StartTaste];
   }
   
}


- (void)ErgebnisFertigAktion:(NSNotification*)note
{
   NSLog(@"Controller ErgebnisFertigAktion: note: %@ verify: %d: ",[[note userInfo]description],verify);
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
      BOOL tempOK=[self checkAufgabe];
      //verify=NO;
      NSLog(@"ErgebnisFertigAktion:nach self checkAufgabe");
   }
}

- (void)textDidChange:(NSNotification *)aNotification

{
   //- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
   NSLog(@"ErgebnisFeld: textDidChangeAktion: %@",[ErgebnisFeld stringValue]);
   
   [OKTaste setEnabled:YES];
   
}

- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
{
   NSLog(@"controlTextDidBeginEditing: %@",[[aNotification object]stringValue]);
   
   
}


- (void)controlTextDidChange:(NSNotification *)aNotification

{
   NSLog(@"SndCalccontroller: controlTextDidChange: %@",[aNotification description]);
   
}


- (void)controlTextShouldEndEditing:(NSNotification *)aNotification
{
   NSLog(@"controlTextShouldEndEditing verify: %d",verify);
   
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
   //Nicht verwendet
   NSLog(@"controlTextDidEndEditing verify: %d",verify);
   [AblaufzeitTimer invalidate];
   
   
   [ErgebnisFeld setSelectable:NO];
   [ErgebnisFeld setEditable:NO];
   [ErgebnisFeld display];
   if (verify)
   {
      BOOL tempOK=[self checkAufgabe];
      //		NSLog(@"controlTextDidEndEditing nach checkAufgabe");
      verify=NO;
      //[StartTaste setEnabled:YES];
      [StartTaste setKeyEquivalent:@"\r"];
      //[[self window]makeFirstResponder:StartTaste];
   }
   
}

- (void)nextAufgabeAbTimerFunktion:(NSTimer*)TestTimer
{
   //NSLog(@"nextAufgabeAbTimerFunktion");
   [TestTimer invalidate];
   
   [self AufgabeAb:NULL];
   [[self window]makeFirstResponder:ErgebnisFeld];
   [ErgebnisFeld setEditable:YES];
   [ErgebnisFeld setSelectable:YES];
   [ErgebnisFeld selectText:NULL];
   [ErgebnisFeld setReady:YES];
   
   //verify=YES;
   //NSLog(@"nextAufgabeAbTimerFunktion nach nextAufgabeAb");
}

- (BOOL)checkAufgabe
{
   //NSLog(@"checkAufgabe Nummer: %d",aktuelleAufgabenNummer);
   BOOL checkOK=NO;
   //NSLog(@"checkAufgabe  AufgabenArray: %@",[AufgabenArray description]);
   
   NSDictionary* tempAufgabenDic=[AufgabenArray objectAtIndex:aktuelleAufgabenNummer-1];
   //NSLog(@"checkAufgabe  tempAufgabenDic: %@",[tempAufgabenDic description]);
   if (verify&&tempAufgabenDic)
   {
      
      NSNumber* sollNumber=[tempAufgabenDic objectForKey:@"var2"];
      
      if (sollNumber)
      {
         int soll=[sollNumber intValue];
         //			int ist=[[ErgebnisView string]intValue];
         int ist=[ErgebnisFeld intValue];
         //NSLog(@"checkAufgabe: soll: %d  ist: %d",soll,ist);
         if (soll==ist)
         {
            //NSLog(@"checkAufgabe: richtig: Nummer: %d",aktuelleAufgabenNummer);
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
               //NSLog(@"checkAufgabe: 3");
               [self RichtigSoundAb];
               //NSLog(@"checkAufgabe: 4");
               [AufgabenNummerFeld setIntValue:aktuelleAufgabenNummer+1];
               aktuelleAufgabenNummer++;
               [ErgebnisRahmenFeld setMark:1];
               [ErgebnisRahmenFeld setHidden:NO];
               //NSLog(@"checkAufgabe: richtig");
               //		//		NSLog(@"checkAufgabe: valid: %d",[AblaufzeitTimer isValid]);
               
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
                     //	NSLog(@"checkAufgabe: 4");
                     [StartTaste setTitle:NSLocalizedString(@"Next",@"Weiter")];
                     [OKTaste setEnabled:NO];
                     //							NSLog(@"checkAufgabe: vor Timer");
                     
                     
                     NSTimer* DelayTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                                                           target:self
                                                                         selector:@selector(nextAufgabeAbTimerFunktion:)
                                                                         userInfo:nil
                                                                          repeats:NO];
                     //							NSLog(@"checkAufgabe: nach Timer");
                     
                     
                     //verify=YES;
                     
                  }break;
                     
               }//modus
               
            }
            
         }
         else
         {
            //NSLog(@"checkAufgabe: vor FalschSoundAb");
            [self FalschSoundAb];
            //NSLog(@"checkAufgabe: nach FalschSoundAb");
            [ErgebnisRahmenFeld setMark:2];
            [ErgebnisRahmenFeld setHidden:NO];
            [TestPopKnopf setEnabled:YES];
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
                  NSTimer* DelayTimer=[NSTimer scheduledTimerWithTimeInterval:1.5
                                                                        target:self
                                                                      selector:@selector(nextAufgabeAbTimerFunktion:)
                                                                      userInfo:nil
                                                                       repeats:NO];
                  
                  //in TestTimerFunktion:
                  //							[self xxAufgabeAb:NULL];
                  //verify=YES;
                  
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
   //NSLog(@"checkAufgabe end");
   return checkOK;
}


- (void)RichtigSoundAb
{
   NSMutableDictionary* tempQuittungDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   //Richtig
   [tempQuittungDic setObject:[NSNumber numberWithInt:kAufgabeRichtig]
                       forKey:@"quittung"];
   //NSLog(@"RichtigSoundAb: tempQuittungDic: %@ ",[tempQuittungDic description]);
   BOOL QuittungOK=[Speaker QuittungAb:tempQuittungDic];
   
   //	[AufgabenQTKitPlayer setMovie:[Speaker QuittungenQTKitMovie]];
   //	[AufgabenQTKitPlayer play:NULL];
   
   //NSLog(@"RichtigSoundAb: end");
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
   NSMutableDictionary* tempQuittungDic=[[NSMutableDictionary alloc]initWithCapacity:0];
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
   NSMutableDictionary* tempQuittungDic=[[NSMutableDictionary alloc]initWithCapacity:0];
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
   //NSLog(@"toggleDrawer state: %d  OK: %d  Modus: %d",[sender state],OK,Modus);
   [self closeSessionDrawer:NULL];
   if (AufgabeOK)
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
               //NSLog(@"SettingsDrawer is opening");
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
               //NSLog(@"SettingsDrawer is closing");
               [StartTaste setEnabled:YES];
               [neueSerieTaste  setEnabled:YES];
               [SettingsPfeil setKeyEquivalent:@""];
               [StartTaste setKeyEquivalent:@"\r"];
               [[self window]makeFirstResponder:StartTaste];
               
               {
                  [SerieDatenDic addEntriesFromDictionary:[self SerieDatenDicAusSettings]];
                  //NSLog(@"SettingsDrawer is closing: SerieDatenDic: %@",[SerieDatenDic description]);
                  [SerieDatenDic setObject:@"Training" forKey:@"testname"];
                  
                  [self neueSerie:NULL];
               }
            }
         }break;
            
         case kTestModus:
         {
            break;//Nur im trainigMdus
            //				NSLog(@"SettingsDrawer testModus");
            [AblaufzeitTimer invalidate];
            
            if (([SettingsDrawer state]==NSDrawerClosedState))
            {
               if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
               {
                  [SettingAlsTestSichernTaste setHidden:NO];
                  [SettingsDrawer toggle:sender];
                  [self startTimeout];
                  //NSLog(@"toggleDrawer SettingsDrawer is opening");
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
               //NSLog(@"SettingsDrawer is closing");
               [StartTaste setEnabled:YES];
               [neueSerieTaste  setEnabled:YES];
               [SettingsPfeil setKeyEquivalent:@""];
               [StartTaste setKeyEquivalent:@"\r"];
               [[self window]makeFirstResponder:StartTaste];
               
               {
                  [SerieDatenDic addEntriesFromDictionary:[self SerieDatenDicAusSettings]];
                  //NSLog(@"SettingsDrawer is closing: SerieDatenDic: %@",[SerieDatenDic description]);
                  [self neueSerie:NULL];
                  [self stopTimeout];
               }
               
            }
         }break;
            
      }//switch Modus
   }//if OK
   //NSLog(@"toggleDrawer end");
}

-(IBAction)closeDrawer:(id)sender
{
   [SettingsDrawer close:NULL];
   [SettingsPfeil setState:NO];
   
}

-(IBAction)openDrawer:(id)sender
{
   if (AufgabeOK)
   {
      //	NSLog(@"SettingsDrawer testModus");
      [AblaufzeitTimer invalidate];
      [SettingsDrawer open:NULL];
      //[SettingsPfeil setState:YES];
      [AblaufzeitTimer invalidate];
      [SettingAlsTestSichernTaste setHidden:(!(sender==NULL))];
      [DrawerSchliessenTaste setHidden:(!(sender==NULL))];
      //[SettingsDrawer toggle:sender];
      //				[self startTimeout];
      //	NSLog(@"openDrawer  SettingsDrawer is opening");
      [StartTaste setEnabled:NO];
      [neueSerieTaste  setEnabled:YES];
      [AnzahlPopKnopf  setEnabled:YES];
      [ZeitPopKnopf  setEnabled:YES];
      [StartTaste setKeyEquivalent:@""];
      [SettingAlsTestSichernTaste setKeyEquivalent:@"\r"];
      [[self window]makeFirstResponder:SettingAlsTestSichernTaste];
      
      [self setSettingsMitDic:SerieDatenDic];
      //	[SerieDatenDic setObject:@"Training" forKey:@"testname"];
      
   }//if OK
   //	NSLog(@"openDrawer  end");
}

- (IBAction)reportSettingAlsTestSichern:(id)sender
{
   //NSLog(@"reportSettingAlsTestSichern");
   SerieDatenDic=(NSMutableDictionary*)[self SerieDatenDicAusSettings];
   //NSLog(@"reportSettingAlsTestSichern: SerieDatenDic: %@",[SerieDatenDic description]);
   
   //[self closeDrawer:NULL];
   
   [self showTestPanel:NULL];
   [TestPanel selectEingabeFeld];
   [TestPanel setAnzahl:[AnzahlPopKnopf indexOfSelectedItem]];
   [TestPanel setZeit:[ZeitPopKnopf indexOfSelectedItem]];
   
}

- (void)setupAufgabenDrawer
{
   [self closeSessionDrawer:NULL];
   NSSize contentSize = NSMakeSize(180, 150);
   AufgabenDrawer = [[NSDrawer alloc] initWithContentSize:contentSize preferredEdge:NSMaxXEdge];
   [AufgabenDrawer setParentWindow:[self window]];
   // [AufgabenDrawer setDelegate:self];
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



- (void)showAufgaben//:(cAufgabendaten*)  AufgabenDatenArray
{
   [self closeSessionDrawer:NULL];
   //NSLog(@"showAufgaben: AufgabenArray: %@",[AufgabenArray description]);
   NSMutableParagraphStyle* TitelStil=[[NSMutableParagraphStyle alloc]init];
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
   
   NSMutableParagraphStyle* AufgabenStil=[[NSMutableParagraphStyle alloc]init];
   [AufgabenStil setTabStops:[NSArray array]];//default weg
   int tab=40;
   NSTextTab* NRTab=[[NSTextTab alloc]initWithType:NSRightTabStopType location:tab];
   [AufgabenStil addTabStop:NRTab];
   
   tab+=15;
   NSTextTab* OpTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:tab];
   [AufgabenStil addTabStop:OpTab];
   
   tab+=30;
   NSTextTab* Var2Tab=[[NSTextTab alloc]initWithType:NSRightTabStopType location:tab];
   [AufgabenStil addTabStop:Var2Tab];
   
   tab+=15;
   NSTextTab* GleichTab=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:tab];
   [AufgabenStil addTabStop:GleichTab];
   
   tab+=40;
   NSTextTab* ResTab=[[NSTextTab alloc]initWithType:NSRightTabStopType location:tab];
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


- (IBAction)setMaxZeit:(id)sender
{
   [self closeSessionDrawer:NULL];
   int maxZeit=[[sender titleOfSelectedItem]intValue];
   NSLog(@"setMaxZeit: maxZeit: %d",maxZeit);
   
   [Zeitanzeige setMax:maxZeit];
   [ZeitFeld setIntValue:maxZeit];
   
   if  (Modus==kTrainingModus)
   {
      if (AufgabeOK)
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




- (IBAction)setAnzahlAufgaben:(id)sender
{
   AnzahlAufgaben=[[sender titleOfSelectedItem]intValue];
   [Aufgabenzeiger setAnzAufgaben:AnzahlAufgaben];
   
   if (Modus==kTrainingModus)
   {
      if (AufgabeOK)
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
   if (AufgabeOK)
   {
      Status=1;
      
      //		NSLog(@"setTest: %@",[sender titleOfSelectedItem]);
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
}

- (void)resetTest
{
   //Nach Einschalten des TestModus den eingestellten Test aktivieren
   //	[self closeSessionDrawer:NULL];
   if (AufgabeOK)
   {
      
      //		NSLog(@"resetTest: %@",[TestPopKnopf titleOfSelectedItem]);
      [AblaufzeitTimer invalidate];
      if ([ModusOption selectedRow]==0)//nicht Training
      {
         [ErgebnisseTaste setEnabled: [NamenPopKnopf indexOfSelectedItem]];
         
         
         Modus=kTestModus;
         [self closeDrawer:NULL];
         //			[SettingsPfeil setEnabled:NO];
         NSArray* TestDicArray=[PListDic objectForKey:@"testarray"];
         //			NSLog(@"resetTest: TestDicArray: %@",[TestDicArray description]);
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
   
   if (AufgabeOK)
   {
      Status=1;
      //NSLog(@"setTestVonTestname: %@",derTest);
      [AblaufzeitTimer invalidate];
      if ([ModusOption selectedRow]==0)//nicht Training
      {
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
                  if ([[TestDicArray objectAtIndex:Testindex]objectForKey:@"seriedatendic"])
                  {
                     SerieDatenDic=[[[TestDicArray objectAtIndex:Testindex]objectForKey:@"seriedatendic"]mutableCopy];
                     
                     //SerieDatenDic im TestDatenDic
                     //NSLog(@"setTest	\n							SerieDatenDic: %@",[SerieDatenDic description]);
                     
                     [self neueSerie:NULL];
                     
                     
                  }
                  else //Kein SeriedatenDic im TestDic
                  {
                     NSString* tempTestName=[[TestDicArray objectAtIndex:Testindex]objectForKey:@"testname"];
                     NSAlert *Warnung = [[NSAlert alloc] init];
                     [Warnung addButtonWithTitle:@"OK"];
                     NSString* t0=NSLocalizedString(@"Settings for test: %@ incorrect",@"Einstellungen für Test: '%@' sind nicht korrekt");
                     NSString* t1=@"";
                     
                     if (tempTestName)
                     {
                        t1=tempTestName;
                     }
                     NSString* MessageString=[NSString stringWithFormat:@"%@",t0,t1];
                     [Warnung setMessageText:[NSString stringWithFormat:NSLocalizedString(@"Settings for test: %@ incorrect",@"Einstellungen für Test: '%@' sind nicht korrekt"),t1]];
                     NSString* s2=NSLocalizedString(@"No data for serie.",@"Keine cSeriedaten vorhanden.");
                     NSString* s1=NSLocalizedString(@"Error:",@"Fehler:");
                     NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
                     [Warnung setInformativeText:InformationString];
                     [Warnung setAlertStyle:NSWarningAlertStyle];
                     
                     //[Warnung setIcon:RPImage];
                     int antwort=[Warnung runModal];
                     return;
                  }
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
      [ZeitPopKnopf setHidden:YES];
      [AnzahlPopKnopf setHidden:YES];
      [ZeitLimiteFeld setHidden:NO];
      [AnzahlFeld setHidden:NO];
      
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
      [ZeitPopKnopf setHidden:NO];
      [AnzahlPopKnopf setHidden:NO];
      [ZeitLimiteFeld setHidden:YES];
      [AnzahlFeld setHidden:YES];
      
      
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
   //NSLog(@"setNamenPopKnopfMitDicArray: derDicArray %@",[[derDicArray valueForKey:@"name"]description]);
   //NSLog(@"setNamenPopKnopfMitDicArray		derDicArray: %@",[derDicArray description]);
   NSEnumerator* NamenEnum=[derDicArray objectEnumerator];
   id einDic;
   NSColor* itemColor=[NSColor blackColor];
   //NSLog(@"*\n");
   //NSLog(@"NamenPop: SessionDatum: %@",SessionDatum);
   while (einDic=[NamenEnum nextObject])
   {
      if ([[einDic objectForKey:@"name"]length])
      {
         //NSLog(@"NamenPop Name: %@",[einDic objectForKey:@"name"]);
         NSNumber* aktivNumber=[einDic objectForKey:@"aktiv"];
         if (aktivNumber && [aktivNumber boolValue])
         {
            [NamenPopKnopf addItemWithTitle:[einDic objectForKey:@"name"]];
            if ([einDic objectForKey:@"lastdate"])
            {
               NSDate* tempDatum=[einDic objectForKey:@"lastdate"];
               //NSLog(@"NamenPop Name: %@ *** tempDatum: %@ **  SessionDatum: %@",[einDic objectForKey:@"name"],tempDatum,SessionDatum);
               if (([tempDatum compare:SessionDatum]== NSOrderedDescending))//lastDate ist nach SessionDatum
               {
                  //NSLog(@"Name: %@ tempDatum: %@ ",[einDic objectForKey:@"name"],tempDatum);
                  //itemColor=[NSColor greenColor];
                  NSColor* SessionColor=[NSColor colorWithDeviceRed:20.0/255 green:150.0/255 blue:80.0/255 alpha:1.0];
                  itemColor=SessionColor;
                  
                  //		NSLog(@"setNamenPopKnopfMitDicArray		einDic: %@	Sessiondatum: %@",[einDic description],SessionDatum);
                  //NSImage* SessionYESImg=[NSImage imageNamed:@"SessionYESImg.tif"];
                  //NSImage* SessionYESImg=[NSImage imageNamed:@"MarkOnImg.tif"];
                  //[[NamenPopKnopf itemWithTitle:[einDic objectForKey:@"name"]]setImage:SessionYESImg];
                  //		[[NamenPopKnopf cell]setImageAlignment:NSImageAlignRight ];
                  
               }//	if session
               else
               {
                  itemColor=[NSColor blackColor];
                  //NSImage* SessionNOImg=[NSImage imageNamed:@"MarkOffImg.tif"];
                  //NSImage* SessionNOImg=[NSImage imageNamed:@"SessionNOImg.tif"];
                  //[[NamenPopKnopf itemWithTitle:[einDic objectForKey:@"name"]]setImage:SessionNOImg];
               }
            }
            else
            {
               itemColor=[NSColor blackColor];
               //NSImage* SessionNOImg=[NSImage imageNamed:@"MarkOffImg.tif"];
               //NSImage* SessionNOImg=[NSImage imageNamed:@"SessionNOImg.tif"];
               //					[[NamenPopKnopf itemWithTitle:[einDic objectForKey:@"name"]]setImage:SessionNOImg];
               
            }
            NSDictionary* tempItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:itemColor, NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
            NSAttributedString* tempNamenItem=[[NSAttributedString alloc]initWithString:[einDic objectForKey:@"name"] attributes:tempItemAttr];
            [[NamenPopKnopf itemAtIndex:[NamenPopKnopf numberOfItems]-1]setAttributedTitle:tempNamenItem];
            if ([NamenPopKnopf numberOfItems]>2)
            {
               //				[[NamenPopKnopf itemAtIndex:ItemIndex]setAttributedTitle:tempNamenItem];
            }
            
         }//if aktiv
         
      }//	if name length
      
   }//while
   //	[NamenPopKnopf insertItemWithTitle:@"Namen wählen" atIndex:0];
   //NSLog(@"NamenPop Namen: %@",[[NamenPopKnopf itemTitles]description]);
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

- (IBAction)showAdminStatistik:(id)sender
{
   [self closeSessionDrawer:NULL];
   if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
   {
      [self stopTimeout];
      [self stopAdminTimeout];
      NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
      //Array mit DatenDics aus den Ordnern auf der HD
      //NSLog(@"showAdminStatistik	tempNamenDicArray: %@",[tempNamenDicArray description]);
      if (tempNamenDicArray&&[tempNamenDicArray count])//schon Namen vorhanden
      {
         
         
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
         
         NSMutableArray* AdminTestNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
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
         
         
         [Statistik setAdminTestNamenPop:AdminTestNamenArray];//Testnamen in Pop setzen
         //		[Statistik setAdminTestTableForTest:[TestPopKnopf titleOfSelectedItem]];
         [Statistik setAdminTestTableForAllTests];
         
         //		[Statistik setAdminTestTableForAllTests];
         [Statistik setAdminOK:YES];
         {
            //NSLog(@"showAdminStatistik:	farbig: %d",farbig);
         }
         [Statistik setFarbig:farbig];
         //NSLog(@"tempNamenDicArray: %@",[tempNamenDicArray description]);
         
         //Testnamen in Statistik setzen
         
         //		[Statistik setTestPopForAdminMitStringArray:AdminTestNamenArray];
         
         //StatistikTable laden für Ausgewählten Rechner
         //NSArray* tempNamenArray=[tempNamenDicArray valueForKey:@"name"];//Namenarray der Rechner
         
         NSMutableArray* tempNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
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
               
               //		[Statistik setTableVonTest:[TestPopKnopf titleOfSelectedItem]];
               
               [Statistik setAdminTestTableForAllTests];
            }
            
            //
            int modalAntwort = [NSApp runModalForWindow:[Statistik window]];
            
            
            //				NSLog(@"showStatistik: Antwort: %d",modalAntwort);
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
         [self startAdminTimeout];
      }
      else
      {
         //NSLog(@"showTestPanel: Kein NamenDicArray");
         NSAlert *Warnung = [[NSAlert alloc] init];
         
         [Warnung addButtonWithTitle:NSLocalizedString(@"Open NameList",@"Namenliste öffnen")];
         [Warnung addButtonWithTitle:@"OK"];
         //[Warnung addButtonWithTitle:@""];
         //[Warnung addButtonWithTitle:@"Abbrechen"];
         NSString* MessageString=@"Noch kein Name definiert";
         [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
         
         NSString* s1=NSLocalizedString(@"At least one name must be defined in menu Options > Namelist.",@"Es muss im Menü Ablauf-> Namenliste zuerst mindestens ein Name angegeben werden.");
         NSString* s2=@"";
         NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
         [Warnung setInformativeText:InformationString];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         
         //[Warnung setIcon:RPImage];
         int antwort=[Warnung runModal];
         
         switch (antwort)
         {
            case NSAlertFirstButtonReturn://	1000	
            { 
               //NSLog(@"NSAlertFirstButtonReturn");
               [self showNamenPanel:NULL];
            }break;
               
            case NSAlertSecondButtonReturn://1001
            {
               //NSLog(@"NSAlertSecondButtonReturn");
               
            }break;
         }//switch antwort
      }
      
      
   }//if checkAdminZugang
} // showAdminStatistik

- (IBAction)setName:(id)sender
{
   if ([TestPopKnopf numberOfItems])
   {
      [self closeSessionDrawer:NULL];
      if ([sender indexOfSelectedItem])//nicht Gast
      {
         [self startTimeout];
         
         //NSLog(@"setName: %@		startTimeout",[sender titleOfSelectedItem]);
         //NSLog(@"setName Anzahl Rechner: %@",[sender stringValue]);
         Status=(([sender indexOfSelectedItem]>0)&&([TestPopKnopf numberOfItems]));//Gast hat index 0
         //[TestPopKnopf selectItemAtIndex:0];//Training
         
         [StartTaste setEnabled:NO];
         [ErgebnisseTaste setEnabled:[NamenPopKnopf indexOfSelectedItem]];
         [AufgabenNummerFeld setStringValue:@""];
         
         NSDictionary* tempNamenDic=[Utils DatenDicForUser:[sender titleOfSelectedItem] anPfad:SndCalcPfad];
         //NSLog(@"setName: tempNamenDic: %@",[tempNamenDic description]);
         NSString* lastTest=@"";
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
            else if ([TestPopKnopf numberOfItems])
            {
               lastTest=[TestPopKnopf titleOfSelectedItem];
            }
            
         }
         NSString* tempUser=[NamenPopKnopf titleOfSelectedItem];
         NSArray* tempUserTestArray=[Utils UserTestArrayVonUser:tempUser anPfad:SndCalcPfad];
         
         
         //NSLog(@"setName: User: %@	lastTest: %@		Testarray: %@",tempUser,lastTest,[tempUserTestArray description]);
         if ([tempUserTestArray count])
         {
            //*
            [self setTestPopKnopfForUser:tempUser];
            
            
            //NSLog(@"setName:	nach setTestPopKnopfForUser: Item titles: %@ lastTest: %@",[TestPopKnopf itemTitles],lastTest);
            
            if ([lastTest length]&&[[TestPopKnopf itemTitles]containsObject:lastTest])
            {
               //NSLog(@"containsObject");
               [TestPopKnopf selectItemWithTitle:lastTest];
            }
            else if ([TestPopKnopf numberOfItems])
            {
               //NSLog(@"not containsObject");
               [TestPopKnopf selectItemAtIndex:0];
            }
            
            //NSLog(@"setName:	nach selectItemAtIndex");
            if ([[TestPopKnopf titleOfSelectedItem]length])
            {
               [self setTestVonTestname:[TestPopKnopf titleOfSelectedItem]];
            }
            
            
            [StartTaste setEnabled:YES];
            [TestPopKnopf setEnabled:YES];
            //		[StartTaste setKeyEquivalent:@"\r"];
            [[self window] makeFirstResponder:StartTaste];
         }//if count
         else
         {
            [TestPopKnopf removeAllItems];
            [TestPopKnopf addItemWithTitle:@"Kein Test"];
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"OK"];
            NSString* MessageString=NSLocalizedString(@"No Test",@"Kein Test");
            [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
            
            NSString* s1=NSLocalizedString(@"No test is selected for you.",@"Für dich ist kein Test ausgewählt.");
            NSString* s2=@"";
            NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
            [Warnung setInformativeText:InformationString];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            //[Warnung setIcon:RPImage];
            int antwort=[Warnung runModal];
            [NamenPopKnopf selectItemAtIndex:0];
            [neueSerieTaste setEnabled:NO];
            [ErgebnisseTaste setEnabled:NO];
            [self stopTimeout];
         }
         
      }
      else if ([sender numberOfItems]==1)
      {
         //NSLog(@"setName: kein Name");
         NSLog(@"setName: Kein NamenDicArray");
         NSAlert *Warnung = [[NSAlert alloc] init];
         
         [Warnung addButtonWithTitle:NSLocalizedString(@"Open NameList",@"Namenliste öffnen")];
         [Warnung addButtonWithTitle:@"OK"];
         //[Warnung addButtonWithTitle:@""];
         //[Warnung addButtonWithTitle:@"Abbrechen"];
         NSString* MessageString=@"Noch kein Name definiert";
         [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
         
         NSString* s1=NSLocalizedString(@"At least one name must be defined in menu Options > Namelist.",@"Es muss im Menü Ablauf-> Namenliste zuerst mindestens ein Name angegeben werden.");
         NSString* s2=@"";
         NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
         [Warnung setInformativeText:InformationString];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         
         //[Warnung setIcon:RPImage];
         int antwort=[Warnung runModal];
         
         switch (antwort)
         {
            case NSAlertFirstButtonReturn://	1000
            {
               NSLog(@"NSAlertFirstButtonReturn");
               [self showNamenPanel:NULL];
            }break;
               
            case NSAlertSecondButtonReturn://1001
            {
               NSLog(@"NSAlertSecondButtonReturn");
               
            }break;
         }//switch antwort
      }
   }//if tests
   else
   {
      //NSLog(@"setName: Name");
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      NSString* MessageString=@"Noch kein Test definiert.";
      [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
      
      NSString* s1=@"Im Menu 'Ablauf>Neuer Test' muss zuerst ein Test definiert werden.";
      NSString* s2=@"";
      NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      
      //[Warnung setIcon:RPImage];
      int antwort=[Warnung runModal];
      [self showNamenPanel:NULL];
   }
   //NSLog(@"setName:													end");
   
}

- (void)showNamenPanel:(id)sender
{
   NSLog(@"showNamenPanel:		start");
   if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
   {
      [self stopTimeout];
      [self stopAdminTimeout];
      
      NSArray* NamenDicArrayAusPList=[Utils NamenDicArrayAnPfad:SndCalcPfad];
      //NSLog(@"showNamenPanel:NamenDicArrayAusPList: %@",[NamenDicArrayAusPList description]);
      
      
      
      if (!NamenPanel)
      {
         NSLog(@"init NamenPanel");
         NamenPanel=[[rNamenPanel alloc]init];
      }
      
      NSModalSession NamenSession=[NSApp beginModalSessionForWindow:[NamenPanel window]];
      //Array der vorhandenen Namen
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
          //  NSArray* tempArray = [NamenPanel getNamenDicArray];
            NSMutableArray* tempNamenDicArray=[[NSMutableArray alloc]initWithArray:[NamenPanel NamenDicArray]];
            //eventuell Aenderung in "aktiv"
            
            //NSLog(@"tempNamenDicArray aus NamenPanel nach Antwort: NamenDicArray %@",[tempNamenDicArray description]);
            //NSLog(@"\n\n");
            
            //NSArray* NamenArray=[NamenDicArray valueForKey:@"name"];
            NSArray* NamenArray=[NamenPanel NamenArray];
            //eventuell neue Namen
            
            //NSLog(@"showNamenPanel nach Antwort: NamenPanel %@",[ NamenArray description]);
            
            if ([NamenArray count])
            {
               //NSLog(@"NamenDicArray valueForKey:name: %@",[[NamenDicArray valueForKey:@"name"]description]);
               int i;
               for (i=0;i<[NamenArray count];i++)
                  
                  if ([[NamenArray objectAtIndex:i]length])
                  {
                     NSMutableDictionary* neuerNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
                     NSString* tempName=[ NamenArray objectAtIndex:i];
                     //NSLog(@"index: %d ein tempName da: %@",i,tempName);
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
                     
                     //NSLog(@"showNamenPanel: PListDic: %@",[PListDic description]);
                     NSArray* TestDicArray;
                     if ([PListDic objectForKey:@"testarray"])
                     {
                        TestDicArray=[PListDic objectForKey:@"testarray"];
                     }
                     else
                     {
                        NSLog(@"Noch kein Testarray");
                     }
                     NSMutableArray* tempTestArray=[[NSMutableArray alloc]initWithCapacity:0];
                     if ([TestDicArray count])
                     {
                        
                        
                        NSEnumerator* DicEnum=[TestDicArray objectEnumerator];
                        id einDic;
                        while (einDic=[DicEnum nextObject])
                        {
                           if ([[einDic objectForKey:@"aktiv"]boolValue])
                           {
                              [tempTestArray addObject:[einDic objectForKey:@"testname"]];
                           }
                        }//while
                        
                        //
                        //[neuerNamenDic setObject:tempTestArray forKey:@"testarray"];
                        //
                     }
                     [neuerNamenDic setObject:tempTestArray forKey:@"testarray"];
                     
                     //NSLog(@"showNamenPanel: neuerNamenDic: %@",[neuerNamenDic description]);
                     //NSLog(@"4");
                     
                     
                     NSMutableArray* tempNamenArray=[[tempNamenDicArray valueForKey:@"name"]mutableCopy];
                     //[tempNamenArray removeObject:@" "];
                     int DoppelIndex=[tempNamenArray indexOfObject:[neuerNamenDic objectForKey:@"name"]];
                     if (DoppelIndex==NSNotFound)//Name noch nicht da
                     {
                        [tempNamenDicArray addObject:neuerNamenDic];
                        [neuerNamenDic setObject:[NSDate date] forKey:@"lastdate"];// letzter Test:
                        
                        //NSLog(@"Neuer Name noch nicht da: %@",[neuerNamenDic description]);
                        //NSLog(@"NamenPanel antwort: NamenDicArray: %@",[NamenDicArray description]);
                        
                     }
                     else
                     {
                        //NSLog(@"Neuer Name schon da: index: %@",[neuerNamenDic description]);
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
               
               //NSLog(@"									showStatistikAktion	nach showStatistikFor");
               
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
                  
                  
                  
                  NSMutableArray* TestNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
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
                  
                  [Statistik setAdminOK:NO];
                  
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
   NSLog(@"**\n");
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
         NSMutableArray* TestNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
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
         //NSLog(@"showStatistikFor	modalAntwort: %d",modalAntwort);
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
         //NSLog(@"showStatistikFor			nach Statistik endModalSession: reset Namen");
         
         
         
         
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
         NSMutableDictionary* tempDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempDictionary setObject:[einObjekt objectForKey:@"name"] forKey:@"name"];
         if ([einObjekt objectForKey:@"ergebnisdicarray"])
         {
            [tempDictionary setObject:[einObjekt objectForKey:@"ergebnisdicarray"] forKey:@"ergebnisdicarray"];
         }
         [tempDictionary setObject:[TestPopKnopf titleOfSelectedItem] forKey:@"lasttest"];
         [tempDictionary setObject:[NSNumber numberWithFloat:[VolumeSchieber floatValue]] forKey:@"lastvolume"];
         [tempDictionary setObject:[NSNumber numberWithInt:1] forKey:@"aktiv"];
         //[tempDictionary setObject:[NSDate date] forKey:@"lastdate"];
         BOOL tempOK=[Utils setDatenDic:tempDictionary forUser:[einObjekt objectForKey:@"name"] anPfad:SndCalcPfad];
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
   [self reportLogout:NULL];
   
   if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
      
      
   {
      [self stopTimeout];
      if (!TestPanel)
      {
         //NSLog(@"init TestPanel");
         TestPanel=[[rTestPanel alloc]init];
         
      }
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
         [PListDic setObject:TestDicArray forKey:@"testarray"];
      }
      //[TestPanel setAnzahlItems:[AnzahlPopKnopf itemTitles] mitItem:0];
      
      //NSLog(@"showTestPanel nach TestDicArray");
      [TestPanel resetTestTabFeld];
      NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
      if (tempNamenDicArray&&[tempNamenDicArray count])
      {
         [TestPanel setNamenDicArray:tempNamenDicArray];
         //		NSLog(@"showTestPanel nach setNamenDicArray");
         NSString* tempName=[[tempNamenDicArray objectAtIndex:0]objectForKey:@"name"];
         //		NSLog(@" %@",tempName);
         [TestPanel setNamenWahlTasteMitNamen:tempName];//ersten Namen auswaehlen
         //		NSLog(@"showTestPanel nach setNamenWahlTasteMitNamen");
         [TestPanel setTestWahlTasteMitTest:NULL];//ersten Namen auswaehlen
         //		NSLog(@"showTestPanel nach setTestWahlTasteMitTest");
         //	int modalAntwort = [NSApp runModalForWindow:[TestPanel window]];
         //		NSModalSession TestLauf=[NSApp beginModalSessionForWindow:[TestPanel window]];
         
         int modalAntwort=0;
         //		modalAntwort=[NSApp runModalForWindow:[TestPanel window]];
         [TestPanel showWindow:NULL];
         [TestPanel setAnzahlItems:[AnzahlPopKnopf itemTitles] mitItem:[AnzahlPopKnopf indexOfSelectedItem]];
         [TestPanel setZeitItems:[ZeitPopKnopf itemTitles] mitItem:[ZeitPopKnopf indexOfSelectedItem]];
         [[TestPanel window] makeKeyAndOrderFront:NULL];
         
         //		[NSApp endModalSession:TestLauf];
         
         //		[self startTimeout];
      }//Kein NamenDicArray
      else
      {
         NSLog(@"showTestPanel: Kein NamenDicArray");
         NSAlert *Warnung = [[NSAlert alloc] init];
         
         [Warnung addButtonWithTitle:NSLocalizedString(@"Open NameList",@"Namenliste öffnen")];
         [Warnung addButtonWithTitle:@"OK"];
         //[Warnung addButtonWithTitle:@""];
         //[Warnung addButtonWithTitle:@"Abbrechen"];
         NSString* MessageString=@"Noch kein Name definiert";
         [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
         
         NSString* s1=NSLocalizedString(@"At least one name must be defined in menu Options > Namelist.",@"Es muss im Menü Ablauf-> Namenliste zuerst mindestens ein Name angegeben werden.");
         NSString* s2=@"";
         NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
         [Warnung setInformativeText:InformationString];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         
         //[Warnung setIcon:RPImage];
         int antwort=[Warnung runModal];
         
         switch (antwort)
         {
            case NSAlertFirstButtonReturn://	1000
            {
               NSLog(@"NSAlertFirstButtonReturn");
               [self showNamenPanel:NULL];
            }break;
               
            case NSAlertSecondButtonReturn://1001
            {
               NSLog(@"NSAlertSecondButtonReturn");
               [self startAdminTimeout];
            }break;
         }//switch antwort
      }
   }//passwort
}

- (void)updateTestPanel
{
   NSArray* tempNamenDicArray=[Utils NamenDicArrayAnPfad:SndCalcPfad];
   [TestPanel setNamenDicArray:tempNamenDicArray];
   NSArray* tempTestDicArray=[Utils TestArrayAusPListAnPfad:SndCalcPfad];
   //NSLog(@"showTestPanel \n\n\n********************************");
   //NSLog(@"showTestPanel	tempTestDicArray : %@",[tempTestDicArray description]);
   
   [TestPanel setTestDicArray:tempTestDicArray];
   //NSLog(@"updateTestPanel nach setTestDicArray");
   //NSLog(@"updateTestPanel end");
   
}


- (void)NeuerTestnameAktion:(NSNotification*)note
{
   
   NSMutableDictionary* neuerTestDic=[[NSMutableDictionary alloc]initWithCapacity:0];
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
            NSArray* TestDicArray=[NSArray arrayWithArray:[TestPanel TestDicArray]];
            NSLog(@"\n NeuerTestnameAktion	aus TestPanel	TestDicArray: %@",[TestDicArray description]);
            Modus=kTestModus;
            [ModusOption selectCellAtRow:0 column:0];
            [AnzahlPopKnopf setEnabled:NO];
            [ZeitPopKnopf setEnabled:NO];
            
            
            
            
            /*				//Version vor 20.12.06. SETTINGS NOCH AN HAUPTFENSTER
             //Settings Testen
             //NSLog(@"neuerTestnameAktion	nach	Close");
             
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
             //					[neuerTestDic setObject:neuerSerieDatenDic forKey:@"seriedatendic"];
             
             [neuerTestDic setObject:[[[note userInfo]objectForKey:@"seriedatendic"]copy] forKey:@"seriedatendic"];
             
             NSLog(@"TestPanel neuerTestDic: %@nn",[neuerTestDic description]);
             
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
             
             */
            //NSLog(@"NeuerTestnameAktion:	PListDic		TestDicArray: %@  ",[TestDicArray description]);
            [PListDic setObject:TestDicArray forKey:@"testarray"];
            
            [Utils saveTestArray:TestDicArray anPfad:SndCalcPfad];
            
            [self setTestPopKnopfMitArray:TestDicArray];
            
            if ([[neuerTestDic objectForKey:@"testname"]length])
            {
               [TestPopKnopf selectItemWithTitle:[neuerTestDic objectForKey:@"testname"]];
               [self setTestVonTestname:[neuerTestDic objectForKey:@"testname"]];
               RechnungSeriedaten=[self SerieDatenVonDic:neuerTestDic];
            }
            else
            {
               [self setTestVonTestname:[TestPopKnopf titleOfSelectedItem]];
            }
         }break;//case 1
      }//switch aktionCode
      
      //		[TestPanel setTestDicArray:TestDicArray];
      //		NSLog(@"NeuerTestNameAktion nach setTestDicArray");
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
   BOOL en=YES;
   [StartTaste setEnabled:en];
   [neueSerieTaste setEnabled:en];
   [NamenPopKnopf setEnabled:en];
   [ErgebnisseTaste setEnabled:en];
   
   //	[self startAdminTimeout];
   
}

- (void)TestBearbeitenAktion:(NSNotification*)note
{
   
   NSLog(@"TestBearbeitenAktion: note: %@",[[note userInfo]description]);
   
   
   NSDictionary* tempSeriedatenDic;
   if ([[note userInfo]objectForKey:@"testname"])
   {
      [self openDrawer:self];
      //		[self stopAdminTimeout];
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
      if ([[note userInfo]objectForKey:@"anzahlaufgaben"])
      {
         [AnzahlPopKnopf selectItemWithTitle:[[note userInfo]objectForKey:@"anzahlaufgaben"]];
         [Aufgabenzeiger setAnzAufgaben:[[[note userInfo]objectForKey:@"anzahlaufgaben"] intValue]];
      }
      
      if ([[note userInfo]objectForKey:@"zeit"])
      {
         NSString* ZeitString=[[note userInfo]objectForKey:@"zeit"];
         [ZeitPopKnopf selectItemWithTitle:[[note userInfo]objectForKey:@"zeit"]];
         [ZeitFeld setIntValue:[ZeitString intValue]];
      }
      
      
      [self setSettingsMitDic:tempSeriedatenDic];
   }
   if ([[note userInfo]objectForKey:@"namenschreiben"])
   {
      [self openDrawer:self];
   }
   
   [TestPanel setZeitItems:[ZeitPopKnopf itemTitles] mitItem:[ZeitPopKnopf indexOfSelectedItem]];
   [TestPanel setAnzahlItems:[AnzahlPopKnopf itemTitles] mitItem:[AnzahlPopKnopf indexOfSelectedItem]];
   
   BOOL en=NO;
   [StartTaste setEnabled:en];
   [neueSerieTaste setEnabled:en];
   [NamenPopKnopf setEnabled:en];
   [ErgebnisseTaste setEnabled:en];
   
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
   //	NSLog(@"\n\nUserTestArrayChangedAktion: note: %@",[[note userInfo]description]);
   
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
               //					NSLog(@"UserTestArrayChangedAktion setTest: tempTestName: %@ forUser: %@",tempTestName,tempUserName);
               [Utils setTestInUserTestArray:tempTestName forUser:tempUserName anPfad:SndCalcPfad];
            }
            else
            {
               //					NSLog(@"UserTestArrayChangedAktion clearTest: tempTestName: %@ forUser: %@",tempTestName,tempUserName);
               [Utils deleteTestInUserTestArray:tempTestName forUser:tempUserName anPfad:SndCalcPfad];
            }
         }
         
         //NamenDicArray updaten
         [self updatePList];
         NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
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
   //NSLog(@"NeuerUserTestArrayAktion: note: %@",[[note userInfo]description]);
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
      //		NSLog(@"	setTestForAllAktion  tempTestDicArray nach set: %@d",[tempTestDicArray description]);
      [self updatePList];
      [TestPanel updateTestDicArrayMitArray:tempTestDicArray];
      
      //NSLog(@"setTestForAllAktion  nach updateTestDicArrayMitArray");
      
      
      NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
      [TestPanel setNamenDicArray:tempNamenDicArray];
      
      
   }//if tempuser
}


- (void)ClearTestForAllAktion:(NSNotification*)note
{
   //Entfernen eines Tests in UserData > usertestarray für alle User
   NSLog(@"ClearTestForAllAktion: note: %@",[[note userInfo]description]);
   NSString* tempTestName=[[note userInfo]objectForKey:@"testforall"];
   if (tempTestName)
   {
      NSLog(@"clearTestForAllAktion: tempTestName: %@",tempTestName);
      [Utils clearTestForAll:tempTestName nurAktiveUser:YES anPfad:SndCalcPfad];
      [Utils setAlle:NO forTest:tempTestName anPfad:SndCalcPfad];
      //		[self updateTestPanel];
      
      NSArray* tempTestDicArray=[Utils TestArrayAusPListAnPfad:SndCalcPfad];
      //		NSLog(@"clearTestForAllAktion  tempTestDicArray retainCount: %d",[tempTestDicArray retainCount]);
      
      //		NSLog(@"clearTestForAllAktion  TestPanel retainCount: %d",[TestPanel retainCount]);
      
      //		 retainCount]);
      //		NSArray* tempTestDicArray=[PListDic objectForKey:@"testarray"];
      //		NSLog(@"clearTestForAllAktion  tempTestDicArray: %@d",[tempTestDicArray description]);
      //		[TestPanel setTestDicArray:tempTestDicArray];
      [self updatePList];
      [TestPanel updateTestDicArrayMitArray:tempTestDicArray];
      
      
      NSLog(@"													clearTestForAllAktion  nach setTestDicArray");
      
      
      NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
      [TestPanel setNamenDicArray:tempNamenDicArray];
      
   }//if tempuser
}

- (void)TestAktivAktion:(NSNotification*)note
{
   
   //Setzen des Aktiv-Bits
   //	NSLog(@"TestAktivAktion: note: %@",[[note userInfo]description]);
   NSString* tempTestName=[[note userInfo]objectForKey:@"testname"];
   if (tempTestName)
   {
      int derStatus=[[[note userInfo]objectForKey:@"aktiv"]intValue];
      BOOL aktivStatus=(derStatus==1);//alter Status
      //		NSLog(@"TestAktivAktion: tempTestName: %@",tempTestName);
      [Utils setAktivInPList:[NSNumber numberWithBool:(!aktivStatus)] forTest:tempTestName anPfad:SndCalcPfad];
      
      [self updatePList];
      
      NSMutableArray* tempNamenDicArray=(NSMutableArray*)[Utils NamenDicArrayAnPfad:SndCalcPfad];
      [TestPanel setNamenDicArray:tempNamenDicArray];
      //***
      
      //		[self updateTestPanel];
      //return;
      //
      //		NSLog(@"TestAktivAktion: tempTestName: nach UpdateTestPanel");
      NSMutableArray* TestDicArray;
      if ([PListDic objectForKey:@"testarray"])
      {
         //	//		NSLog(@"TestAktivAktion	PListDic objectForKey: testarray : %@",[[PListDic objectForKey:@"testarray"] description]);
         
         //16.8.		TestDicArray=(NSMutableArray*)[PListDic objectForKey:@"testarray"];
         TestDicArray=[[PListDic objectForKey:@"testarray"]mutableCopy];
         //			[self setTestPopKnopfForUser:[NamenPopKnopf titleOfSelectedItem]];
         //		NSLog(@"TestAktivAktion	TestDicArray : %@",[TestDicArray description]);
         [TestPanel updateTestDaten:TestDicArray];
         //		NSLog(@"TestAktivAktion: tempTestName: nach updateTestDaten");
         
      }
   }//if tempuser
   //	NSLog(@"TestAktivAktion: END");
}

- (void)TestPanelSchliessenAktion:(NSNotification*)note
{
   [self closeDrawer:NULL];
   //NSLog(@"TestPanelSchliessenAktion: note: %@",[[note userInfo]objectForKey:@"schliessen"]);
   NSString* tempLastTest=[TestPopKnopf titleOfSelectedItem];
   if ([[note userInfo]objectForKey:@"testdicarray"])//modifizierter TestDicarray aus TestPanel
   {
      //NSLog(@"TestPanelSchliessenAktion: note: Testdicarray da: %@",[[[note userInfo]objectForKey:@"testdicarray"]description]);
      [Utils saveTestArray:[[note userInfo]objectForKey:@"testdicarray"] anPfad:SndCalcPfad];
      [self updatePList];
   }
   
   if ([NamenPopKnopf indexOfSelectedItem])
   {
      //NSLog(@"TestPanelSchliessenAktion: TestPop anpassen");
      NSString* tempUser=[NamenPopKnopf titleOfSelectedItem];
      NSArray* tempUserTestArray=[Utils UserTestArrayVonUser:tempUser anPfad:SndCalcPfad];
      
      //NSLog(@"TestPanelSchliessenAktion: User: %@	tempLastTest: %@	Testarray; %@",tempUser,tempLastTest,[tempUserTestArray description]);
      if ([tempUserTestArray count])
      {
         [self setTestPopKnopfForUser:tempUser];
         
         //		NSLog(@"setName:	nach setTestPopKnopfForUser");
         
      }
      
      if ([tempLastTest length]&&[[TestPopKnopf itemTitles]containsObject:tempLastTest])
      {
         [TestPopKnopf selectItemWithTitle:tempLastTest];
      }
      else
      {
         [TestPopKnopf selectItemAtIndex:0];
         
      }
      if ([[TestPopKnopf titleOfSelectedItem]length])
      {
         [self setTestVonTestname:[TestPopKnopf titleOfSelectedItem]];
      }
   }//if Namen ausgewählt
   [self startAdminTimeout];
}

- (void)EinstellungenAktion:(NSNotification*)note
{
   NSLog(@"EinstellungenAktion: note: %@",[[note userInfo]description]);
   if ([[note userInfo]objectForKey:@"admintimeout"])
   {
      [PListDic setObject:[[note userInfo]objectForKey:@"admintimeout"]forKey:@"admintimeout"];
      AdminTimeout=[[[note userInfo]objectForKey:@"admintimeout"]intValue];
   }
   if ([[note userInfo]objectForKey:@"usertimeout"])
   {
      [PListDic setObject:[[note userInfo]objectForKey:@"usertimeout"]forKey:@"usertimeout"];
      UserTimeout=[[[note userInfo]objectForKey:@"usertimeout"]intValue];
   }
   if ([[note userInfo]objectForKey:@"farbig"])
   {
      [PListDic setObject:[[note userInfo]objectForKey:@"farbig"]forKey:@"farbig"];
      farbig=[[[note userInfo]objectForKey:@"farbig"]boolValue];
   }
   
}

- (IBAction)showEinstellungen:(id)sender
{
   NSLog(@"showEinstellungenPanel");
   
   [self closeSessionDrawer:NULL];
   
   
   if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
   {
      [self stopTimeout];
      if (!EinstellungenPanel)
      {
         NSLog(@"init EinstellungenPanel");
         EinstellungenPanel=[[rEinstellungenPanel alloc]init];
         
      }
      //NSLog(@"EinstellungenPanel window: %d",[[EinstellungenPanel window] description]);
      [self stopAdminTimeout];
      NSModalSession EinstellungenSession=[NSApp beginModalSessionForWindow:[EinstellungenPanel window]];
      //Array der vorhandenen Namen
      
      
      //	NSArray* NamenDicArrayAusPList=[Utils NamenDicArrayAnPfad:SndCalcPfad];
      
      
      
      [EinstellungenPanel setAdminTimeout:AdminTimeout];
      [EinstellungenPanel setUserTimeout:UserTimeout];
      [EinstellungenPanel setFarbig:farbig];
      
      
      int modalAntwort = [NSApp runModalForWindow:[EinstellungenPanel window]];
      [NSApp endModalSession:EinstellungenSession];
      NSLog(@"showEinstellungenPanel: Antwort: %d",modalAntwort);
      //	[self startTimeout];
      switch (modalAntwort)
      {
         case 0://Abbrechen
         {
            
         }break;
         case 1://Schliessen
         {
            //NSLog(@"\n\n");NSLog(@"\n\n");
         }break;
      }//switch antwort
      [self startTimeout];
   }
   
}

//////////
//
// goToBeginning
//
// Called when the go to beginning button is pressed
// We call the QTMovieView gotoBeginning method here
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
   // stop the movie */
   //    [movieViewObject stop:sender];
   // adjust the play button state */
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
   [self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
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
   [movieViewObject stepBackward:sender];
   
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
   //  if (IsMovieDone(gMovie))
   {
      /* yes, so go to beginning */
      // GoToBeginningOfMovie(gMovie);
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
   RechnungSeriedaten.AnzahlReihen=0;
   RechnungSeriedaten.AnzahlAufgaben=kMaxAnzahlAufgaben;
   //Reihenliste=new short[kMaxAnzahlReihen];
   for (short i=0;i<kMaxAnzahlReihen;i++)
   {
      RechnungSeriedaten->Reihenliste[i]=0;
   }
   RechnungSeriedaten.ASBereich =kBisZehn;
   RechnungSeriedaten.ASBereich=kZehnbisZwanzig;
   RechnungSeriedaten.ASBereich=kZweistellig;
   RechnungSeriedaten.ASzweiteZahl=kBisZehn;
   RechnungSeriedaten.ASzweiteZahl=kZehnbisZwanzig;
   RechnungSeriedaten.ASZehnerU=kImmer;
   
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

//- (void)setMoviePropertyWindowControlValues:(Movie)qtmovie
//{
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
// [trackCount setIntValue:GetMovieTrackCount(qtmovie)];

//   [self buildTrackMediaTypesArray:qtmovie];

//[movieTimeScale setStringValue:GetMovieTimeScaleAsString(qtmovie)];
//[movieDuration setStringValue:GetMovieDurationAsString(qtmovie)];
//}

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
/*
 - (void)buildTrackMediaTypesArray:(Movie)qtmovie
 {
 short i;
 
 for (i = 0; i < GetMovieTrackCount(qtmovie); ++i)
 {
 Str255			mediaName;
 OSErr			myErr;
 //       Track			movieTrack = GetMovieIndTrack(qtmovie, i+1); // tracks start at index 1 
 //        Media			trackMedia = GetTrackMedia(movieTrack);
 MediaHandler	trackMediaHandler = GetMediaHandler(trackMedia);
 
 // get the text of the media type
 myErr = MediaGetName(trackMediaHandler, mediaName, 0, NULL);
 
 // add the media type string to our array (as an NSString)
 //[movieTrackMediaTypesArray insertObject:[NSString stringWithCString:&mediaName[1] length:mediaName[0]] atIndex:i];
 }
 
 }
 */

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

//////////
//
// restoreMoviePlayCompleteCallBack
//
// Once our movie callback is called, QuickTime removes us from the
// callback chain - therefore, we must specify the callback
// again or QuickTime won't call us.
//
//////////


//////////
//
// setupMoviePlayingCompleteCallback
//
// Here we specify QuickTime call us when the movie stops playing. This
// is necessary so we can adjust our play button to the proper settings.
//
//////////



- (BOOL)GetZahlTrack
{
   OSErr err=0;
   NSLog(@"GetZahlTrack start");
   /*
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
    */
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
   [Speaker deleteMovieFiles];
   [NSApp terminate:self];
}

- (void)SessionDatumSichernVon:(NSString*)derRechner
{
   //	NSLog(@"SessionDatumSichernVon: %@",derRechner);
   NSMutableDictionary* tempDic=(NSMutableDictionary*)[Utils DatenDicForUser:derRechner anPfad:SndCalcPfad] ;
   if (tempDic)
   {
      [[tempDic objectForKey:@"userplist"] setObject:[NSDate date] forKey:@"lastdate"];
      //NSLog(@"tempDic: %@",[tempDic description]);
      [Utils setDatenDic:[tempDic objectForKey:@"userplist"]forUser:derRechner anPfad:SndCalcPfad];
      
   }
   
}

- (IBAction)neueSession:(id)sender
{
   //NSLog(@"neueSession");
   if (AdminPWOK || [self checkAdminZugang])//PW schon angegeben innerhalb Timeout
   {
      if (EinstellungenPanel)
      {
         NSLog(@"AnzahlBehalten: %d",[EinstellungenPanel AnzahlBehalten]);
         int anz=[EinstellungenPanel AnzahlBehalten];
         if (anz&&anz<99)
         {
            
            [Utils ErgebnisseBehaltenBisAnzahl:anz anPfad:SndCalcPfad];
         }
         
         NSLog(@"Clean: %d",[EinstellungenPanel cleanOK]);
         if ([EinstellungenPanel cleanOK])
         {
            
            [Utils deleteInvalidTestsAnPfad:SndCalcPfad];
         }
      }
      [self stopTimeout];
      [self startAdminTimeout];
      [self closeSessionDrawer:NULL];
      SessionDatum=[NSDate date];
      BOOL SessionOK=[Utils saveSessionDatum:[NSDate date] anPfad:SndCalcPfad];
      [PListDic setObject:[NSDate date] forKey:@"sessiondatum"];
      
      [self setNamenPopKnopfMitDicArray:[Utils NamenDicArrayAnPfad:SndCalcPfad]];
      [NamenPopKnopf selectItemAtIndex:0];
   }
}



- (IBAction)SessionAktualisieren:(id)sender
{
   //NSLog(@"SessionAktualisieren");
   //
   [self stopTimeout];
   NSString* momentanerUser;
   if ([NamenPopKnopf indexOfSelectedItem])
   {
      momentanerUser=[NamenPopKnopf titleOfSelectedItem];
   }
   
   //NSLog(@"SessionAktualisieren momentanerUser: %@",momentanerUser);
   [ErgebnisseTaste setEnabled:NO];
   
   
   [self setNamenPopKnopfMitDicArray:[Utils NamenDicArrayAnPfad:SndCalcPfad]];
   if ([[NamenPopKnopf itemTitles]containsObject:momentanerUser])
   {
      //NSLog(@"SessionAktualisieren Name da");
      [NamenPopKnopf selectItemWithTitle:momentanerUser];
   }
   else
   {
      NSLog(@"SessionAktualisieren Name nicht da");
      [NamenPopKnopf selectItemAtIndex:0];
      [self neueSerie:NULL];
   }
   [NamenPopKnopf setEnabled:YES];
   //[self reportLogout:sender];
}



- (void)SerieDatenSichernVon:(NSString*)derRechner
{
   //	NSLog(@"SerieDatenSichernVon: %@",derRechner);
   NSMutableDictionary* tempDic=(NSMutableDictionary*)[Utils DatenDicForUser:derRechner anPfad:SndCalcPfad] ;
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
      if ([AufgabenNummerFeld intValue]>1)//Schon eine Aufgabe gemacht, also Session erfüllt
      {
         //		[self SessionDatumSichernVon:[NamenPopKnopf titleOfSelectedItem]];
         //22.09	
      }
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

- (IBAction)reportLogout:(id)sender
{
   if([NamenPopKnopf indexOfSelectedItem])
   {
      if ([AufgabenNummerFeld intValue]>1)//Schon eine Aufgabe gemacht, also Session erfüllt
      {
         //[self SessionDatumSichernVon:[NamenPopKnopf titleOfSelectedItem]];
      }
      //21.09		[self SessionDatumSichernVon:[NamenPopKnopf titleOfSelectedItem]];
      [self SerieDatenSichernVon:[NamenPopKnopf titleOfSelectedItem]];
      [self setNamenPopKnopfMitDicArray:[Utils NamenDicArrayAnPfad:SndCalcPfad]];
      
      //[self SessionAktualisieren:NULL];
   }
   
   [self stopTimeout];
   //NSLog(@"reportLogout");
   [NamenPopKnopf setEnabled:YES];
   [NamenPopKnopf selectItemAtIndex:0];
   //NSLog(@"TimeoutTimerFunktion fire 3");
   [ErgebnisseTaste setEnabled:NO];
   [SessionDrawerTaste setEnabled:YES];
   //NSLog(@"TimeoutTimerFunktion fire 4");
   [self neueSerie:NULL];
   //NSLog(@"TimeoutTimerFunktion fire end");
   
}

- (void)startTimeout
{
   //NSLog(@"startTimeout");
   if ([TimeoutTimer isValid])
   {
      [TimeoutTimer invalidate];
   }
   TimeoutTimer=[NSTimer scheduledTimerWithTimeInterval:UserTimeout
                                                  target:self 
                                                selector:@selector(TimeoutTimerFunktion:) 
                                                userInfo:nil 
                                                 repeats:NO];
   
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
   //NSLog(@"AdminTimeoutTimerFunktion");
   //NSLog(@"Beenden");
   if ([TeminateAdminPWTimer isValid])
   {
      [TeminateAdminPWTimer invalidate];
   }		
   AdminPWOK=NO;
   return;
   
   TeminateAdminPWTimer=[NSTimer scheduledTimerWithTimeInterval:15.0
                                                          target:self 
                                                        selector:@selector(TerminateTimeoutFunktion:) 
                                                        userInfo:nil 
                                                         repeats:NO];
   
   NSAlert *Warnung = [[NSAlert alloc] init];
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
      [AdminTimeoutTimer invalidate];
   }
   NSLog(@"startAdminTimeout AdminTimeoutTimer Zeit: %d",AdminTimeout);
   AdminTimeoutTimer=[NSTimer scheduledTimerWithTimeInterval:AdminTimeout 
                                                       target:self 
                                                     selector:@selector(AdminTimeoutTimerFunktion:) 
                                                     userInfo:nil 
                                                      repeats:NO];
   
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
   NSLog(@"DeleteTestAktion: userInfo: %@",[[note userInfo]description]);
   NSString* tempName=[[note userInfo] objectForKey:@"testname"];
   NSString* tempDatum=[[note userInfo] objectForKey:@"datum"];
   NSLog(@"DeleteTestAktion: tempName: %@	tempDatum: %@",tempName,tempDatum);
   
   if (tempName&&tempDatum)
   {
      NSLog(@"deleteTest");
      [Utils deleteTestMitDatum:tempDatum forUser:tempName anPfad:SndCalcPfad];
      [self updatePList];
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
         //			NSLog(@"tempTestNamenArray: %@",[tempTestNamenArray description]);
         int index=[tempTestNamenArray indexOfObject:tempTestName];
         if (!(index==NSNotFound))
         {
            NSLog(@"deleteTest: %@",tempTestName);
            [tempTestDicArray removeObjectAtIndex:index];
            NSLog(@"deleteTest nach remove");
            [Utils deleteTestName:tempTestName  anPfad:SndCalcPfad];
         }
         NSMutableArray* tempAktivTestArray=[[NSMutableArray alloc]initWithCapacity:0];
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
         //			NSLog(@"deleteTestNameAktion nach setTestDicArray");
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
   [PListDic setObject:[NSNumber numberWithInt:AdminTimeout] forKey:@"admintimeout"];
   [PListDic setObject:[NSNumber numberWithInt:UserTimeout] forKey:@"usertimeout"];
   //	[PListDic setObject:[NSNumber numberWithInt:0] forKey:@"busy"];
   
   
   //	NSLog(@"savePListAktion: PListDic: %@",[PListDic description]);
   //	NSLog(@"savePListAktion: PListDic: Testarray:  %@",[[PListDic objectForKey:@"testarray"]description]);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   
   NSString* PListPfad;
   //NSLog(@"\n\n");
   //NSLog(@"savePListAktion: SndCalcPfad: %@ ",SndCalcPfad);
   PListPfad=[SndCalcPfad stringByAppendingPathComponent:PListName];
   //NSLog(@"savePListAktion: PListPfad: %@ ",PListPfad);
   if (PListPfad)
      
   {
      //NSLog(@"savePListAktion: PListPfad: %@ ",PListPfad);
      //NSLog(@"savePListAktion: PListDic: %@ ",[PListDic description]);
      
      NSMutableDictionary* tempPListDic;//=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      if ([Filemanager fileExistsAtPath:PListPfad])
      {
         tempPListDic=[NSMutableDictionary dictionaryWithContentsOfFile:PListPfad];
         //NSLog(@"savePListAktion: tempPListDic: %@",[tempPListDic description]);
         if (!tempPListDic)
         {
            tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         }
         //[tempPListDic setObject:[NSNumber numberWithInt:AnzahlAufgaben] forKey:@"anzahlaufgaben"];
         //[tempPListDic setObject:[NSNumber numberWithInt:MaximalZeit] forKey:@"zeit"];
         [tempPListDic setObject:[NSNumber numberWithInt:AdminTimeout] forKey:@"admintimeout"];
         [tempPListDic setObject:[NSNumber numberWithInt:UserTimeout] forKey:@"usertimeout"];
         
         
         BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
         //NSLog(@"PListOK: %d",PListOK);
      }
   }
   //
   
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
      NSMutableDictionary* tempAdminPWDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      //NSLog(@"checkAdminZugang	PListDic: %@",[PListDic description]);
      if ((![PListDic objectForKey:@"pwdic"])||([[[PListDic objectForKey:@"pwdic"]objectForKey:@"pw"]length]==0))//kein Eintrag da
      {
         //NSLog(@"kein PW-Eintrag in PList");
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
         NSLog(@"checkAdminZugang pw="": neues Passwort eingeben");
         NSDictionary* tempNeuesPWDic=[Utils changePasswort:[tempAdminPWDic copy]];
         //NSLog(@"tempNeuesPWDic: %@",[tempNeuesPWDic description]);
         if ([[tempNeuesPWDic objectForKey:@"pw"]length])//neues PW ist da
         {
            //NSLog(@"tempNeuesPWDic: %@",[tempNeuesPWDic description]);
            //[PListDic setObject:AdminPasswortDic forKey:@"adminpw"];
            [PListDic setObject:[tempNeuesPWDic copy] forKey:@"pwdic"];
            
            AdminPasswortDic =[tempNeuesPWDic copy];
            
            NSLog(@"PListDic in checkAdminZugang: %@",[PListDic description]);
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
   NSAlert *Warnung = [[NSAlert alloc] init];
   [Warnung addButtonWithTitle:@"OK"];
   [Warnung setMessageText:dieWarnung];
   int antwort=[Warnung runModal];
}




- (void)applicationWillTerminate:(NSNotification *)aNotification {
   // Insert code here to tear down your application
}

@end
