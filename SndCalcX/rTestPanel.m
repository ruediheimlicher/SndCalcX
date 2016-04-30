#import "rTestPanel.h"

@implementation rTestPanel

- (id)init
{
   self = [super initWithWindowNibName:@"SCTestPanel"];
   TestDicArray=[[NSMutableArray alloc] initWithCapacity:0];
   NamenDicArray=[[NSMutableArray alloc] initWithCapacity:0];
   aktuellerUser=[[NSMutableString alloc]initWithCapacity:0];
   TestChanged=0;
   //OK=0;
   SerieDatenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   
   [nc addObserver:self
          selector:@selector(SettingChangedAktion:)
              name:@"SettingChanged"
            object:nil];
   
   return self;
}

- (void)awakeFromNib
{
   
   [EingabeFeld setDelegate:self];
   //	[[EingabeFeld cell]setSendsActionOnEndEditing:NO];
   [IconFeld setImage:[NSImage imageNamed:@"duerergrau"]];
   [[AnzahlPopTaste cell]setAlignment:NSRightTextAlignment];
   [[ZeitPopTaste cell]setAlignment:NSRightTextAlignment];
   [AnzahlPopTaste setEnabled:NO];
   [ZeitPopTaste setEnabled:NO];
   [TestForAllTaste setEnabled:NO];
   [forAllCheckbox setEnabled:NO];
   //NSLog(@"Testpanes awake begin");
   dirty=NO;
   [[[TestTable tableColumnWithIdentifier:@"aktiv"]dataCell]setAction:@selector(AktivCheckboxAktion:)];
   //[[[TestTable tableColumnWithIdentifier:@"alle"]dataCell]setButtonType:NSMomentaryPushInButton];
   
   [[[TestTable tableColumnWithIdentifier:@"alle"]dataCell]setAction:@selector(ForAllCheckboxAktion:)];
   
   TestZuNamenDS=[[rTestZuNamenDS alloc]init];
   [TestZuNamenTable setDataSource:TestZuNamenDS];
   [TestZuNamenTable setDelegate:TestZuNamenDS];
   [[[TestZuNamenTable tableColumnWithIdentifier:@"userok"]dataCell]setAction:@selector(TestZuNamenCheckboxAktion:)];
   
   
   NamenZuTestDS=[[rNamenZuTestDS alloc]init];
   [NamenZuTestTable setDataSource:NamenZuTestDS];
   [NamenZuTestTable setDelegate:NamenZuTestDS];
   [[[NamenZuTestTable tableColumnWithIdentifier:@"testok"]dataCell]setAction:@selector(NamenZuTestCheckboxAktion:)];
   [TestTabFeld setDelegate:self];//
   
   [TestTable setToolTip:NSLocalizedString(@"List of avalilable tests.\nOnly activated tests are shown to the user.", @"Testliste.")];
   [UpDownTaste setToolTip:NSLocalizedString(@"Shift clicked test up and down.",@"Verschieben eines angeklickten Tests nach oben oder unten")];
   [EingabeFeld setToolTip:NSLocalizedString(@"Enter a name for the test.",@"Einen Namen für den Test eingeben.")];
   [DeleteTaste setToolTip:NSLocalizedString(@"Delete clicked Test.",@"Angeklickten Test löschen")];
   [EinsetzenTaste setToolTip:NSLocalizedString(@"Append the new test to the list.",@"Den neuen Test in die Liste einsetzen.")];
   [BearbeitenTaste setToolTip:NSLocalizedString(@"Edit the clicked test.",@"Angeklickten Test bearbeiten.")];
   [TestForAllTaste setToolTip:NSLocalizedString(@"Append the clicked test for all users.",@"Angeklickten Test für alle Benutzer einsetzen.")];
   [TestForNoneTaste setToolTip:NSLocalizedString(@"Remove the clicked Test for all users.",@"Angeklickten Test bei allen Benutzern entfernen.")];
   [SaveTestTaste setToolTip:NSLocalizedString(@"Save the new or edited test.",@"Bearbeiteten Test wieder sichern.")];
   [aktivCheckbox setToolTip:NSLocalizedString(@"Active tests are shown to the user.",@"Aktive Tests sind für den Benutzer sichtbar.")];
   [forAllCheckbox setToolTip:NSLocalizedString(@"The test is set for all users",@"Der Test ist für alle Benutzer gesetzt.")];
   
   [TestZuNamenTable setToolTip:NSLocalizedString(@"Table of aktive tests with settings for the choosen user./nActive tests are shown to the user.",@"Liste der aktiven Tests für den ausgewählten Benutzer.\nActive Tests sind für den Benutzer wählbar.")];
   [NamenWahlTaste setToolTip:NSLocalizedString(@"Choose user whoose settings shall be shown.\nThe settings can be edited.",@"Benutzer wählen, für den die aktiven Tests angezeigt werden sollen.\nDie Einstellungen können angepasst werden.")];
   
   [NamenZuTestTable setToolTip:NSLocalizedString(@"Table of registered users and settings for the choosen test./nActive tests are shown to the choosen User.",@"Liste der Benutzer und der Einstellung für den gewählten Test.\nAktive Tests sind für den Benutzer wählbar")];
   [TestWahlTaste setToolTip:NSLocalizedString(@"Choose test whoose user settings shall be shown.\nThe settings can be edited.",@"Test wählen, für den die Einstellungen der Benutzer angezeigt werden sollen.\nDie Einstellungen können angepasst werden.")];
   [SetTestForAllTaste setToolTip:NSLocalizedString(@"Set or remove the choosen test for all users.",@"Den ausgewählten Test für alle Benutzer setzen oder entfernen.")];
   //NSLog(@"init vor init Reihensettings");
   [self initReihenSettings];
   //[self DebugStep:@"nach initReihenSettings"];
   [self initAddSubSettings];
   
   
}

- (void)updateTestDicArrayMitArray:(NSArray*)derTestDicArray
{
   //NSLog(@"updateTestDicArrayMitArray\n\n");
   NSArray* TestNamenArray=[TestDicArray valueForKey:@"testname"];
   [TestDicArray removeAllObjects];
   [TestTable reloadData];
   
   NSEnumerator* TestEnum=[derTestDicArray objectEnumerator];
   id einDic;
   while (einDic=[TestEnum nextObject])
   {
      NSMutableDictionary* tempDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      //NSLog(@"setTestDicArray:		einDic: %@",[einDic description]);
      if ([einDic objectForKey:@"testname"])
      {
         [tempDic setObject:[einDic objectForKey:@"testname"] forKey:@"testname"];
         if ([einDic objectForKey:@"zeit"])
         {
            [tempDic setObject:[einDic objectForKey:@"zeit"]forKey:@"zeit"];
         }
         else
         {
            [tempDic setObject:[NSNumber numberWithInt:120]forKey:@"zeit"];
         }
         
         if ([einDic objectForKey:@"anzahlaufgaben"])
         {
            [tempDic setObject:[einDic objectForKey:@"anzahlaufgaben"]forKey:@"anzahlaufgaben"];
         }
         else
         {
            [tempDic setObject:[NSNumber numberWithInt:12]forKey:@"anzahlaufgaben"];
         }
         if ([einDic objectForKey:@"aktiv"])
         {
            [tempDic setObject:[einDic objectForKey:@"aktiv"] forKey:@"aktiv"];
         }
         else
         {
            [tempDic setObject:[NSNumber numberWithBool:YES]forKey:@"aktiv"];
         }
         
         if ([einDic objectForKey:@"alle"])
         {
            [tempDic setObject:[einDic objectForKey:@"alle"] forKey:@"alle"];
         }
         else
         {
            [tempDic setObject:[NSNumber numberWithInt:1]forKey:@"alle"];
         }
         
         if ([einDic objectForKey:@"seriedatendic"])
         {
            [tempDic setObject:[einDic objectForKey:@"seriedatendic"] forKey:@"seriedatendic"];
         }
         
      }//if testname
      
      [TestDicArray addObject:tempDic];
   }//while
   
   //NSLog(@"TestDicArray nach set: %@\n",[TestDicArray description]);
   [TestZuNamenDS setTestZuNamenArrayMitDicArray:TestDicArray];
   //NSLog(@"setTestDicArray nach setTestZuNamenArrayMitDicArray");
   [TestZuNamenTable reloadData];
   [TestTable reloadData];
   
   [TestTable deselectAll:NULL];
   [self setTestWahlTasteMitTest:@""];
   [SchliessenTaste setTitle:NSLocalizedString(@"Close",@"Schliessen")];
   //NSLog(@"TestDicArray end\n\n");
   dirty=NO;
   
}

- (void)setTestDicArray:(NSArray*)derTestDicArray
{
   //NSLog(@"setTestDicArray");
   
   //Liste der Tests aus der PList
   //NSLog(@"setTestDicArray	derTestDicArray :anz: %d",[derTestDicArray count]);
   NSLog(@"setTestDicArray	derTestDicArray start: %@",[derTestDicArray description]);
   //	if ([TestDicArray count])
   {
      //		NSArray* TestNamenArray=[TestDicArray valueForKey:@"testname"];
      //		[TestNamenArray retain];
      //		NSLog(@"setTestDicArray: %@",[TestNamenArray description]);
      //20.7.
      //		NSLog(@"setTestDicArray vor remove");
      //TestDicArray =[NSMutableArray array];
      [TestDicArray removeAllObjects];
      [TestTable reloadData];
      
      //NSLog(@"setTestDicArray nach remove");
      
      NSEnumerator* TestEnum=[derTestDicArray objectEnumerator];
      id einDic;
      while (einDic=[TestEnum nextObject])
      {
         NSMutableDictionary* tempDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         //			NSLog(@"setTestDicArray:		einDic: %@",[einDic description]);
         
         //20.7.			if ([einDic objectForKey:@"testname"]&&!([TestNamenArray containsObject:[einDic objectForKey:@"testname"]]))
         
         if ([einDic objectForKey:@"testname"])
         {
            [tempDic setObject:[einDic objectForKey:@"testname"] forKey:@"testname"];
            
            if ([einDic objectForKey:@"seriedatendic"])
            {
               [tempDic setObject:[einDic objectForKey:@"seriedatendic"]forKey:@"seriedatendic"];
            }
            
            if ([einDic objectForKey:@"zeit"])
            {
               [tempDic setObject:[einDic objectForKey:@"zeit"]forKey:@"zeit"];
            }
            else
            {
               [tempDic setObject:[NSNumber numberWithInt:120]forKey:@"zeit"];
            }
            
            if ([einDic objectForKey:@"anzahlaufgaben"])
            {
               [tempDic setObject:[einDic objectForKey:@"anzahlaufgaben"]forKey:@"anzahlaufgaben"];
            }
            else
            {
               [tempDic setObject:[NSNumber numberWithInt:12]forKey:@"anzahlaufgaben"];
            }
            
            
            
            if ([einDic objectForKey:@"aktiv"])
            {
               [tempDic setObject:[einDic objectForKey:@"aktiv"] forKey:@"aktiv"];
            }
            else
            {
               [tempDic setObject:[NSNumber numberWithBool:YES]forKey:@"aktiv"];
            }
            
            if ([einDic objectForKey:@"alle"])
            {
               [tempDic setObject:[einDic objectForKey:@"alle"] forKey:@"alle"];
            }
            else
            {
               [tempDic setObject:[NSNumber numberWithInt:1]forKey:@"alle"];
            }
            //				NSLog(@"setTestDicArray:		tempDic: %@",[tempDic description]);
            [TestDicArray addObject:[tempDic mutableCopy]];
         }
      }//while
      
      [UpDownTaste setMaxValue:[TestDicArray count]-1];
      [TestZuNamenDS setTestZuNamenArrayMitDicArray:TestDicArray];
      //		NSLog(@"setTestDicArray nach setTestZuNamenArrayMitDicArray anz: %d max: %d",[TestDicArray count],[UpDownTaste maxValue]);
      [TestZuNamenTable reloadData];
   }
   //	else//TestDicArray ist noch leer
   {
      //		[TestDicArray addObjectsFromArray:[derTestDicArray copy]];
   }
   //	NSLog(@"\n\n\nTestDicArray nach set: %@\n\n",[TestDicArray description]);
   [TestTable reloadData];
   
   [TestTable deselectAll:NULL];
   [SchliessenTaste setTitle:NSLocalizedString(@"Close",@"Schliessen")];
   [SaveTestTaste setEnabled:YES];
   [SaveTestTaste setTitle:@"Neuer Test"];
   //NSLog(@"TestDicArray end");
   dirty=NO;
   
   
}

- (void)updateTestDaten:(NSArray*)derTestDicArray;
{
   
   //NSLog(@"updateTestDaten	derTestDicArray : %@",[derTestDicArray description]);
   //	if ([TestDicArray count])
   {
      NSArray* TestNamenArray=[TestDicArray valueForKey:@"testname"];
      //NSLog(@"TestNamenArray: %@",[TestNamenArray description]);
      NSEnumerator* TestEnum=[derTestDicArray objectEnumerator];
      id einDic;
      while (einDic=[TestEnum nextObject])
      {
         NSMutableDictionary* tempDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         
         
         if ([einDic objectForKey:@"testname"]&&!([TestNamenArray containsObject:[einDic objectForKey:@"testname"]]))
         {
            [tempDic setObject:[einDic objectForKey:@"testname"] forKey:@"testname"];
            
            if ([einDic objectForKey:@"aktiv"])
            {
               [tempDic setObject:[einDic objectForKey:@"aktiv"] forKey:@"aktiv"];
            }
            else
            {
               [tempDic setObject:[NSNumber numberWithBool:YES]forKey:@"aktiv"];
            }
            
            if ([einDic objectForKey:@"alle"])
            {
               [tempDic setObject:[einDic objectForKey:@"alle"] forKey:@"alle"];
            }
            else
            {
               [tempDic setObject:[NSNumber numberWithInt:1]forKey:@"alle"];
            }
            
            [TestDicArray addObject:[tempDic mutableCopy]];
         }
      }//while
      [TestZuNamenDS setTestZuNamenArrayMitDicArray:derTestDicArray];
      //NSLog(@"updateTestDaten nach setTestZuNamenArrayMitDicArray");
      [TestZuNamenTable reloadData];
   }
   //	NSLog(@"TestDicArray nach set: %@",[TestDicArray description]);
   [TestTable reloadData];
   
   [TestTable deselectAll:NULL];
   [SchliessenTaste setTitle:NSLocalizedString(@"Close",@"Schliessen")];
   //	NSLog(@"TestDicArray end");
   dirty=NO;
   //	[[self window]makeFirstResponder:[self window]];
   
}

- (void)setAnzahlItems:(NSArray*)derArray mitItem:(int)derIndex
{
   //NSLog(@"setAnzahlItems: %@",[derArray description]);
   [AnzahlPopTaste removeAllItems];
   
   [AnzahlPopTaste addItemsWithTitles:derArray];
   //[[AnzahlPopTaste cell]setAlignment:NSRightTextAlignment];
   
   [AnzahlPopTaste selectItemAtIndex:derIndex];
   dirty=NO;
}

- (void)setZeitItems:(NSArray*)derArray mitItem:(int)derIndex
{
   //NSLog(@"setZeitItems: %@",[derArray description]);
   [ZeitPopTaste removeAllItems];
   
   [ZeitPopTaste addItemsWithTitles:derArray];
   //[[ZeitPopTaste cell]setAlignment:NSRightTextAlignment];
   
   [ZeitPopTaste selectItemAtIndex:derIndex];
   dirty=NO;
}

- (void)resetTestTabFeld
{
   [NamenWahlTaste selectItemAtIndex:0];
   [TestWahlTaste selectItemAtIndex:0];
   [TestTabFeld selectFirstTabViewItem:NULL];
   [TestTable deselectAll:NULL];
}

- (void)setNamenDicArray:(NSArray*)derNamenDicArray
{
   //	NSLog(@"\n\n                                   setNamenDicArray: %@\n\n",[derNamenDicArray description]);
   NamenDicArray=(NSMutableArray*)derNamenDicArray; //Array in TestPanel setzen
   [NamenZuTestDS setNamenZuTestArrayMitDicArray:derNamenDicArray];
   [NamenZuTestTable reloadData];
   //NSLog(@"setNamenDicArray: %@",[[NamenDicArray valueForKey:@"lasttest"]description]);
   busy=NO;
   //
}//setNamenDicArray

- (void)setNamenWahlTasteMitNamen:(NSString*)derName;
{
   NSMutableArray* tempNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSDictionary* firstItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
   
   NSEnumerator* NamenEnum=[NamenDicArray objectEnumerator];
   id einNamenDic;
   while (einNamenDic=[NamenEnum nextObject])
   {
      //		NSLog(@"					setNamenWahlTaste: einNamenDic: %@",[einNamenDic description]);
      
      if ([einNamenDic objectForKey:@"aktiv"]&&[[einNamenDic objectForKey:@"aktiv"]boolValue])
      {
         [tempNamenArray addObject:[einNamenDic objectForKey:@"name"]];//Fuer NamenPopTaste
         NSMutableDictionary* tempUserTestDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempUserTestDic setObject:[einNamenDic objectForKey:@"name"] forKey:@"name"];
         if ([einNamenDic objectForKey:@"usertestarray"])
         {
            [tempUserTestDic setObject:[einNamenDic objectForKey:@"usertestarray"] forKey:@"usertestarray"];
         }
         else
         {
            [tempUserTestDic setObject:[NSArray array] forKey:@"usertestarray"];
         }
         //			NSLog(@"setNamenWahlTaste: tempUserTestDic: %@",[tempUserTestDic description]);
         if ([[einNamenDic objectForKey:@"name"]isEqualToString:derName])//aktueller Name
         {
            aktuellerUser=derName;
            //	[TestZuNamenDS setTestliste:[tempUserTestDic objectForKey:@"usertestarray"] zuNamen:derName];
         }
         [TestZuNamenTable reloadData];
         //[NamenDicArray addObject:tempUserTestDic];
      }
   }//while
   //	NSLog(@"setNamenWahlTaste: derNamenDicArray: %@ Name: %@",[tempNamenArray description],derName);
   //	NSLog(@"\n\nsetNamenWahlTaste: NamenDicArray erstesElement: %@ Name: %@",[[NamenDicArray objectAtIndex:0] description],derName);
   
   
   
   if ([tempNamenArray count])
   {
      [NamenWahlTaste removeAllItems];
      
      NSAttributedString* firstItem=[[NSAttributedString alloc]initWithString:NSLocalizedString(@"Choose Name",@"Namen wählen") attributes:firstItemAttr];
      [NamenWahlTaste addItemWithTitle:@""];
      [[NamenWahlTaste itemAtIndex:0]setAttributedTitle:firstItem];
      
      [NamenWahlTaste addItemsWithTitles:tempNamenArray];
      if ([derName length]&&[tempNamenArray containsObject:derName])
      {
         aktuellerUser=derName;
         
      }
      
      else
      {
         aktuellerUser=[tempNamenArray objectAtIndex:0];
      }
      if (derName &&[derName length])
      {
         [self setTestZuNamenDSForUser:derName];
      }
   }
}

- (void)setTestWahlTasteMitTest:(NSString*)derTest;
{
   //alle aktiven Tests einsetzen
   NSMutableArray* tempTestArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSDictionary* firstItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
   
   NSEnumerator* TestEnum=[TestDicArray objectEnumerator];
   id einTestDic;
   while (einTestDic=[TestEnum nextObject])
   {
      //		NSLog(@"		setTestWahlTasteMitTest: einTestDic: %@",[einTestDic description]);
      
      if ([einTestDic objectForKey:@"aktiv"]&&[[einTestDic objectForKey:@"aktiv"]boolValue])
      {
         [tempTestArray addObject:[einTestDic objectForKey:@"testname"]];//Fuer NamenPopTaste
         NSMutableDictionary* tempTestDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempTestDic setObject:[einTestDic objectForKey:@"testname"] forKey:@"testname"];
         
         //			NSLog(@"setTestWahlTaste: tempTestDic: %@",[tempTestDic description]);
         if ([[einTestDic objectForKey:@"testname"]isEqualToString:derTest])//aktueller Name
         {
            aktuellerTest=derTest;
            
         }
         
         
         [NamenZuTestTable reloadData];
         //[NamenDicArray addObject:tempUserTestDic];
      }
   }//while
   //	[NamenZuTestDS setNamenliste:tempTestArray zuTest:derTest];
   //	NSLog(@"setNamenWahlTaste: derNamenDicArray: %@ Name: %@",[tempNamenArray description],derName);
   //	NSLog(@"\n\nsetNamenWahlTaste: NamenDicArray erstesElement: %@ Name: %@",[[NamenDicArray objectAtIndex:0] description],derName);
   
   //	NSLog(@"setTestWahlTaste: tempTestArray: %@",[tempTestArray description]);
   
   if ([tempTestArray count])
   {
      [TestWahlTaste removeAllItems];
      //		NSString* firstItem=NSLocalizedString(@"Choose Test",@"Test wählen");
      //		[TestWahlTaste addItemWithTitle:firstItem];
      NSAttributedString* firstItem=[[NSAttributedString alloc]initWithString:NSLocalizedString(@"Choose Test",@"Test wählen") attributes:firstItemAttr];
      [TestWahlTaste addItemWithTitle:@""];
      [[TestWahlTaste itemAtIndex:0]setAttributedTitle:firstItem];
      
      [TestWahlTaste addItemsWithTitles:tempTestArray];
      [TestWahlTaste selectItemAtIndex:0];
      
      if ([derTest length]&&[tempTestArray containsObject:derTest])
      {
         aktuellerTest=derTest;
         
      }
      
      else
      {
         aktuellerTest=[tempTestArray objectAtIndex:0];
      }
   }
   //NSLog(@"setTestWahlTaste: nach set ");
   
}



- (NSArray*)TestDicArray
{
   //NSLog(@"TestPanel	TestDicArray: %@",[TestDicArray description]);
   return TestDicArray;
}


- (NSArray*)TestNamenArray
{
   NSMutableArray* tempArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSEnumerator* TestEnum=[TestDicArray objectEnumerator];
   id einDic;
   while (einDic=[TestEnum nextObject])
   {
      if ([einDic objectForKey:@"aktiv"]&&[[einDic objectForKey:@"testname"]state])
      {
         [tempArray addObject:[[einDic objectForKey:@"testname"] copy]];
      }
   }//while
   //NSLog(@"tempArray : %@",[tempArray description]);
   
   return tempArray;
}

- (IBAction)reportCancel:(id)sender
{
   NSMutableDictionary* neuerTestNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   [neuerTestNamenDic setObject:[NSNumber numberWithInt:0] forKey:@"aktion"];
   //NSLog(@"Cancel	neuerTestNamenDic: %@",[neuerTestNamenDic description]);
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"NeuerTestname" object:self userInfo:neuerTestNamenDic];
   
   [self closeDrawer:NULL];
   [AnzahlPopTaste setEnabled:NO];
   [ZeitPopTaste setEnabled:NO];
   [forAllCheckbox setState:0];
   [forAllCheckbox setEnabled:NO];
   [aktivCheckbox setState:1];
   [SchliessenTaste setTitle:NSLocalizedString(@"Close",@"Schliessen")];
   
   [EingabeFeld setStringValue:@""];
   [[self window]makeFirstResponder:[self window]];
   //	[NSApp stopModalWithCode:0];
   [[self window]orderOut:NULL];
   dirty=NO;
   busy=NO;
}

- (IBAction)reportClose:(id)sender
{
   //NSLog(@"reportClose anfang: TestDicArray: %@",[TestDicArray description]);
   
   NSMutableDictionary* neuerTestNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   //NSLog(@"close: AnzahlPopTaste: %@",[AnzahlPopTaste itemArray]);
   int tabindex=[[[TestTabFeld selectedTabViewItem]identifier]intValue];
   if ([TestZuNamenDS isDirty])//im TestZuNamenDS wurde etwas geändert
   {
      dirty=YES;
   }
   //NSLog(@"reportClose											dirty: %d:",dirty);
   switch (tabindex)
   {
      case 1://Neuer Test
      {
         if (dirty)
         {
            NSLog(@"reportClose: dirty=YES");
            //27.3.			[self reportSaveTestTaste:NULL];
         }//if dirty
         
         
         [EingabeFeld setStringValue:@""];
         [AnzahlPopTaste setEnabled:NO];
         [ZeitPopTaste setEnabled:NO];
         [forAllCheckbox setState:0];
         [forAllCheckbox setEnabled:NO];
         [aktivCheckbox setState:1];
         [SchliessenTaste setTitle:NSLocalizedString(@"Close",@"Schliessen")];
         dirty=NO;
      }break;//case 1
         
      case 2://TestZuNamen
      {
         [self saveUserTestArray];
         
      }break;//case 2
         
      case 3://NamenZuTest
      {
         [self saveUserTestArray];
         
      }break;//case 2
         
   }//switch tabindexindex
   
   //aufräumen
   
   [EingabeFeld setStringValue:@""];
   [AnzahlPopTaste setEnabled:NO];
   [ZeitPopTaste setEnabled:NO];
   [forAllCheckbox setState:0];
   [forAllCheckbox setEnabled:NO];
   [aktivCheckbox setState:1];
   [SchliessenTaste setTitle:NSLocalizedString(@"Close",@"Schliessen")];
   dirty=NO;
   [self closeDrawer:NULL];
   
   //	[[self window]makeFirstResponder:[self window]];
   //	[TestDicArray removeAllObjects];
   //	[NSApp stopModalWithCode:1];
   
   [[self window]orderOut:NULL];
   //NSLog(@"reportClose vor notific: TestDicArray: %@",[TestDicArray description]);
   
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"schliessen"];
   [NotificationDic setObject:TestDicArray forKey:@"testdicarray"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"TestPanelSchliessen" object:self userInfo:NotificationDic];
   busy=NO;
   NSLog(@"reportClose ende: TestDicArray: Anzahl Seriedatendics %d",[[TestDicArray valueForKey:@"seriedatendic"]count]);
   
}

- (IBAction)reportEinsetzen:(id)sender
{
   //NSLog(@"reportEinsetzen: String:%@",[EingabeFeld stringValue]);
   
   if ([[EingabeFeld stringValue] length])
   {
      
      [TestDicArray addObject:[EingabeFeld stringValue]];
      [TestTable reloadData];
      [EinsetzenTaste setEnabled:NO];
      [EingabeFeld setStringValue:@""];
      [AnzahlPopTaste setEnabled:NO];
      [ZeitPopTaste setEnabled:NO];
      [forAllCheckbox setEnabled:NO];
      [SaveTestTaste setEnabled:NO];
      [SchliessenTaste setTitle:NSLocalizedString(@"Close",@"Schliessen")];
      busy=NO;
   }
}


- (IBAction)reportDelete:(id)sender
{
   int index=[TestTable selectedRow];
   NSString* deleteTestName=[[TestDicArray objectAtIndex:index]valueForKey:@"testname"];
   NSLog(@"deleteTestName: %@	index: %d",deleteTestName,index);
   
   NSAlert *Warnung = [[NSAlert alloc] init];
   if ([TestTable numberOfRows]==1)//einzigen Test nicht löschen
   {
      [Warnung addButtonWithTitle:@"OK"];
      [Warnung setMessageText:NSLocalizedString(@"Delete Test?",@"Test löschen?")];
      NSString* InformationString=NSLocalizedString(@"At least one test must be present.",@"Mindestens ein Test muss vorhanden sein.");
      [Warnung setInformativeText:InformationString];
      int antwort=[Warnung runModal];
      return;
   }
   else
   {
      [Warnung addButtonWithTitle:NSLocalizedString(@"Delete Test",@"Test löschen")];
      [Warnung addButtonWithTitle:NSLocalizedString(@"Cancel",@"Abbrechen")];
      [Warnung setMessageText:NSLocalizedString(@"Delete Test?",@"Test löschen?")];
      
      NSString* s1=NSLocalizedString(@"The test and the results of all users with this test are deleted.",@"Der Test und die Ergebnisse aller Benutzer mit dem Test werden entfernt.");
      NSString* s2=NSLocalizedString(@"\nNote:\nDeactivating only hides the test and the results.",@"Anmerkung:\nDeaktivieren verbirgt lediglich den Test und die Ergebnisse.");
      NSString* s3=NSLocalizedString(@"Single results can be removed in the statistics window.",@"Einzelne Ergebnisse können im Statistikfenster entfernt werden.");
      
      NSString* InformationString=[NSString stringWithFormat:@"%@\n%@\n%@",s1,s2,s3];
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      
      int antwort=[Warnung runModal];
      
      switch (antwort)
      {
         case NSAlertFirstButtonReturn://Papierkorb
         {
            NSLog(@"Delete");
            
         }break;
            
         case NSAlertSecondButtonReturn://Magazin
         {
            NSLog(@"Cancel");
            return;
         }break;
      }//switch
      
      //**
      //NSLog(@"Delete ausgewählt");
      
      
      
      [TestDicArray removeObjectAtIndex:index];
      [TestTable reloadData];
      
   }//anz >1
   
   [AnzahlPopTaste setEnabled:NO];
   [ZeitPopTaste setEnabled:NO];
   [forAllCheckbox setEnabled:NO];
   [SaveTestTaste setEnabled:YES];
   [SchliessenTaste setTitle:NSLocalizedString(@"Close",@"Schliessen")];
   dirty=NO;
   NSMutableDictionary* deleteTestNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [deleteTestNamenDic setObject:deleteTestName forKey:@"deletetestname"];
   [deleteTestNamenDic setObject:[NSNumber numberWithInt:2] forKey:@"aktion"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"DeleteTestName" object:self userInfo:deleteTestNamenDic];
   [self setTestWahlTasteMitTest:NULL];
}


- (IBAction)reportUpDown:(id)sender
{
   NSLog(@"reportUpDown state: %d",[sender intValue]);
   if ([sender intValue]>[TestDicArray count]-1)
   {
      [sender setIntValue:[TestDicArray count]-1];
   }
   if ([sender intValue]<[TestTable selectedRow])
   {
      [self TestUp];
   }
   if ([sender intValue]>[TestTable selectedRow]&&[sender intValue]<[TestDicArray count])
   {
      [self TestDown];
   }
   [TestTable scrollRowToVisible:[sender intValue]];
}

- (void)TestUp
{
   int startPos=[TestTable selectedRow];
   if (startPos)//mindestens Item auf Zeile 2
   {
      [TestDicArray exchangeObjectAtIndex:startPos withObjectAtIndex:startPos-1];
      [TestTable selectRowIndexes:[NSIndexSet indexSetWithIndex:startPos-1] byExtendingSelection:NO];
      [TestTable reloadData];
      
      
   }
}
- (void)TestDown
{
   int startPos=[TestTable selectedRow];
   if (startPos<[TestDicArray count])//mindestens Item auf zweitunterster Zeile
   {
      [TestDicArray exchangeObjectAtIndex:startPos withObjectAtIndex:startPos+1];
      [TestTable selectRowIndexes:[NSIndexSet indexSetWithIndex:startPos+1] byExtendingSelection:NO];
      [TestTable reloadData];
      
      
   }
}


- (IBAction)reportBearbeiten:(id)sender
{
   
   int index=[TestTable selectedRow];//selektierte Zeile
   NSLog(@"reportBearbeiten    TestDic: %@",[[TestDicArray objectAtIndex:index]description]);
   NSDictionary* tempTestdatenDic=[TestDicArray objectAtIndex:index];
   
   NSString* tempTestNamenString=[tempTestdatenDic objectForKey:@"testname"];
   [EingabeFeld setStringValue:tempTestNamenString];
   //	[SaveTestTaste setEnabled:YES];
   
   if ([tempTestdatenDic objectForKey:@"aktiv"])//aktiv setzen
   {
      [aktivCheckbox setState:[[tempTestdatenDic objectForKey:@"aktiv"]boolValue]];
   }
   else	//aktiv auf 1 setzen
   {
      [aktivCheckbox setState:YES];
   }
   
   //	NSLog(@"TestDic: nach aktiv setzen");
   
   if ([tempTestdatenDic objectForKey:@"alle"])//alle setzen
   {
      [forAllCheckbox setState:[[tempTestdatenDic objectForKey:@"alle"]boolValue]];
   }
   else	//alle auf 1 setzen
   {
      [forAllCheckbox setState:YES];
   }
   
   
   
   
   
   if ([tempTestdatenDic objectForKey:@"anzahlaufgaben"])
   {
      
      int anzAufgaben=[[tempTestdatenDic objectForKey:@"anzahlaufgaben"]intValue];
      //NSLog(@"anzahl: %d string: %@",anzAufgaben,[tempTestdatenDic objectForKey:@"anzahlaufgaben"]);
      NSString* tempAnzahlString=[NSString stringWithFormat:@"%@",[tempTestdatenDic objectForKey:@"anzahlaufgaben"]];
      
      //NSLog(@"tempAnzahlString: %@",tempAnzahlString);
      [AnzahlPopTaste setEnabled:YES];
      //NSLog(@"AnzahlPopTaste: %@",[AnzahlPopTaste itemArray]);
      if ([[AnzahlPopTaste itemTitles]containsObject:tempAnzahlString])
      {
         [AnzahlPopTaste selectItemWithTitle:tempAnzahlString];
      }
      //		NSLog(@"TestDic: nach anzahlaufgaben setzen");
   }
   
   if ([tempTestdatenDic objectForKey:@"zeit"])
   {
      int index=[[tempTestdatenDic objectForKey:@"zeit"]intValue];
      //NSLog(@"index: %d ",index);
      NSString* tempZeitString=[NSString stringWithFormat:@"%@ s",[tempTestdatenDic objectForKey:@"zeit"]];
      
      
      //NSLog(@"zeit: %d string: %@ zeitstring: %@",index,[tempSeriedatenDic objectForKey:@"zeit"],tempZeitString);
      [ZeitPopTaste setEnabled:YES];
      if ([[ZeitPopTaste itemTitles]containsObject:tempZeitString])
      {
         [ZeitPopTaste selectItemWithTitle:tempZeitString];
      }
      //		NSLog(@"TestDic: nach zeit setzen");
      
   }
   NSDictionary* tempSeriedatenDic=[tempTestdatenDic objectForKey:@"seriedatendic"];;
   NSArray* tempTestArray=[tempTestdatenDic objectForKey:@"testarray"];
   if (tempSeriedatenDic)
   {
      [self setSettingsMitDic:tempSeriedatenDic];
   }
   
   NSLog(@"reportBearbeiten    tempSeriedatenDic: %@",[tempSeriedatenDic description]);
   if (tempTestdatenDic)//&&dirty)
   {
      [SaveTestTaste setTitle:@"Test sichern"];
      
      
      
      //		[NotificationDic setObject:tempTestNamenString forKey:@"testname"];
      //	NSLog(@"TestDic: nach notification setzen");
      //		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      //		[nc postNotificationName:@"TestBearbeiten" object:self userInfo:NotificationDic];
   }
   
   
   
   [SaveTestTaste setEnabled:NO];
   //	[SaveTestTaste setTitle:@"Test sichern"];
   [self openDrawer:NULL];
   [EingabeFeld setEnabled:YES];
   [forAllCheckbox setEnabled:YES];
   [aktivCheckbox setEnabled:YES];
   [EingabeFeld setEnabled:YES];
   [BearbeitenTaste setEnabled:NO];
   [DeleteTaste setEnabled:NO];
   [TestForAllTaste setEnabled:NO];
   [TestForNoneTaste setEnabled:NO];
   [SchliessenTaste setEnabled:NO];
   //	[TestTable setEnabled:NO];
   busy=YES;
   TestChanged=0;
   
   /*Weiter oben eingesetzt
    
    if (tempTestdatenDic)//&&dirty)
    {
    NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
    [NotificationDic setObject:tempTestNamenString forKey:@"testname"];
    //	NSLog(@"TestDic: nach notification setzen");
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"TestBearbeiten" object:self userInfo:NotificationDic];
    }
    
    */
   dirty=NO;
}


- (IBAction)reportCloseDrawer:(id)sender
{
   [SettingsDrawer close:NULL];
   [SettingsPfeil setState:NO];
   [EingabeFeld setStringValue:@""];
   [AnzahlPopTaste setEnabled:NO];
   [ZeitPopTaste setEnabled:NO];
   [SaveTestTaste setKeyEquivalent:@""];
   [SaveTestTaste setEnabled:NO];
   [forAllCheckbox setEnabled:NO];
   [aktivCheckbox setEnabled:NO];
   [aktivCheckbox setState:1];
   [EingabeFeld setEnabled:NO];
   [SaveTestTaste setKeyEquivalent:@""];
   [SchliessenTaste setEnabled:YES];
   [BearbeitenTaste setEnabled:YES];
   [SchliessenTaste setKeyEquivalent:@"/r"];
   [TestTable setEnabled:YES];
   [TestTable deselectAll:NULL];
   
}

- (IBAction)reportSaveTest:(id)sender
{
   
   //nicht verwendet: > reportSaveTestTaste
   
   NSLog(@"	reportSaveTest: TestChanged: %d",TestChanged);
   /*
    Neuen Test sichern
    */
   if ([[sender title] isEqualToString:@"Neuer Test"])
   {
      [sender setTitle:@"Test sichern"];
      [self openDrawer:NULL];
   }
   else
   {
      
      if ([[EingabeFeld stringValue]length])
      {
         [self closeDrawer:NULL];
         
         if (TestChanged)
         {
            
            [sender setTitle:@"Neuer Test"];
            
            NSArray* tempTestNamenArray=[TestDicArray valueForKey:@"testname"];//Alle vorhandenen Tests
            //NSLog(@"tempTestNamenArray: %@",[tempTestNamenArray description]);
            
            NSString* neuerTestName=[EingabeFeld stringValue];//Name für einen neuen Test
            //NSLog(@"neuerTestName: %@",neuerTestName);
            NSUInteger doppelIndex=[tempTestNamenArray indexOfObject:neuerTestName];
            NSInteger insertIndex=0;
            //NSLog(@"doppelIndex: %d",doppelIndex);
            //NSLog(@"tempTestNamenArray: %@   neuerTestName: %@  doppelIndex: %d",[tempTestNamenArray description],neuerTestName,doppelIndex);
            
            
            
            if (((doppelIndex<NSNotFound)))//neuer Name ist schon da
            {
               //NSLog(@"Doppelter Name");
               NSAlert* OrdnerWarnung=[[NSAlert alloc]init];
               [OrdnerWarnung addButtonWithTitle:NSLocalizedString(@"Go Back",@"Zurück")];
               [OrdnerWarnung addButtonWithTitle:NSLocalizedString(@"Replace Test",@"Test ersetzen")];
               [OrdnerWarnung setMessageText:NSLocalizedString(@"Name Already Exists",@"Name schon vorhanden")];
               [OrdnerWarnung setInformativeText:NSLocalizedString(@"The test must have another name to be saved.",@"Der Test muss einen andern Namen bekommen, um gesichert werden zu können.")];
               
               int modalAntwort=[OrdnerWarnung runModal];
               switch (modalAntwort)
               {
                  case NSAlertFirstButtonReturn://zurück
                  {
                     //[EingabeFeld setStringValue:@""];
                     [sender setTitle:@"Test sichern"];
                     [EingabeFeld setEnabled:YES];
                     [EingabeFeld selectText:NULL];
                     TestChanged=NO;
                     return;
                  }break;
                  case NSAlertSecondButtonReturn://ersetzen
                  {
                     insertIndex=doppelIndex;
                     //[TestDicArray removeObjectAtIndex:doppelIndex];
                     dirty=YES;
                     [TestTable reloadData];
                  }break;
                     
                     
               }//switch
            }
            
            if ([[EingabeFeld stringValue] length]&&dirty)
            {
               NSMutableDictionary* neuerTestNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               [neuerTestNamenDic setObject:SerieDatenDic forKey:@"seriedatendic"];
               
               //[neuerTestNamenDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
               [neuerTestNamenDic setObject:neuerTestName forKey:@"testname"];//leer wenn kein neuer Name
               [neuerTestNamenDic setObject:[NSNumber numberWithInt:[aktivCheckbox state]]forKey:@"aktiv"];
               NSNumber* AnzNumber=[NSNumber numberWithInt:[[AnzahlPopTaste titleOfSelectedItem]intValue]];
               [neuerTestNamenDic setObject:AnzNumber forKey:@"anzahlaufgaben"];
               
               NSNumber* ZeitNumber=[NSNumber numberWithInt:[[ZeitPopTaste titleOfSelectedItem]intValue]];
               //NSLog(@"reportSaveTest:	ZeitNumber: %@",ZeitNumber);
               [neuerTestNamenDic setObject:ZeitNumber forKey:@"zeit"];
               
               [neuerTestNamenDic setObject:[NSNumber numberWithInt:[forAllCheckbox state]]forKey:@"alle"];
               
               //NSLog(@"reportSaveTest	neuerTestNamenDic: %@",[neuerTestNamenDic description]);
               if (insertIndex)
               {
                  [TestDicArray replaceObjectAtIndex:insertIndex withObject:neuerTestNamenDic];
               }
               else
               {
                  [TestDicArray addObject:neuerTestNamenDic];
               }
               [TestTable reloadData];
               
               
               
               
               
               [neuerTestNamenDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
               NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
               [nc postNotificationName:@"NeuerTestname" object:self userInfo:neuerTestNamenDic];
               
               
               if ([forAllCheckbox state])
               {
                  NSArray* tempNamenArray=[NamenDicArray valueForKey:@"name"];
                  NSUInteger index=[tempNamenArray indexOfObject:aktuellerUser];
                  //NSLog(@"reportSaveTest forAll:	aktuellerUser: %@",aktuellerUser);
                  if (!(index==NSNotFound))
                  {
                     if ([[NamenDicArray objectAtIndex:index]objectForKey:@"usertestarray"])//usertestarray da
                     {
                        NSArray* tempUserTestArray=[[NamenDicArray objectAtIndex:index]objectForKey:@"usertestarray"];
                        //NSLog(@"reportSaveTest:	setTestliste:tempUserTestArray:  %@",[tempUserTestArray description]);
                        [TestZuNamenDS setTestliste:tempUserTestArray zuNamen:aktuellerUser];
                        
                     }
                     else
                     {
                        [TestZuNamenDS setTestliste:NULL zuNamen:aktuellerUser];
                     }
                     [TestZuNamenTable reloadData];
                  }
                  
               }
               
            }//TestChanged
            
            //	[DeleteTaste setEnabled:YES];
            //	[TestForAllTaste setEnabled:YES];
            //	[TestForNoneTaste setEnabled:YES];
            [SchliessenTaste setEnabled:YES];
            
            [EingabeFeld setStringValue:@""];
            [AnzahlPopTaste setEnabled:NO];
            [ZeitPopTaste setEnabled:NO];
            [SaveTestTaste setKeyEquivalent:@""];
            [SaveTestTaste setEnabled:NO];
            [forAllCheckbox setState:0];
            [forAllCheckbox setEnabled:NO];
            [aktivCheckbox setState:1];
            [aktivCheckbox setEnabled:NO];
            [EingabeFeld setEnabled:NO];
            [SaveTestTaste setKeyEquivalent:@""];
            [SchliessenTaste setEnabled:YES];
            [SchliessenTaste setKeyEquivalent:@"/r"];
            [TestTable setEnabled:YES];
            //[[self window]makeFirstResponder:SchliessenTaste];
            
            [self setTestWahlTasteMitTest:NULL];
            busy=NO;
            dirty=NO;
            //[[self window]makeFirstResponder:[self window]];
         }
         else
         {
            NSBeep();
         }
      }//if length
   }//if saveTest
}

- (void)reportSaveTestTaste:(id)sender
{
   NSLog(@"	reportSaveTestTaste Titel der Taste: %@ TestName: %@",[sender title],[EingabeFeld stringValue]);
   /*
    Neuen Test sichern
    */
   if ([[sender title] isEqualToString:@"Neuer Test"])
   {
      NSLog(@"reportSaveTestTaste vor setTitle");
      [sender setTitle:@"Test sichern"];
      NSLog(@"reportSaveTestTaste nach setTitle");
      [TestTable deselectAll:NULL];
      [[self window]makeFirstResponder: EingabeFeld];
      [self openDrawer:NULL];
      [EingabeFeld setEnabled:YES];
      [SchliessenTaste setEnabled:NO];
   }
   else
   {
      if ([[EingabeFeld stringValue]length])
      {
         if (TestChanged)
         {
            
            SerieDatenDic=(NSMutableDictionary*)[self SerieDatenDicAusSettings];
            
            //			if ([[SerieDatenDic objectForKey:@"settingcheck"]boolValue])
            if ([self checkSerieDatenDic:SerieDatenDic vonTest:[EingabeFeld stringValue]])
            {
               [sender setTitle:@"Neuer Test"];
               //				NSLog(@"Neuer Test: dirty: %d  SerieDatenDic: %@",dirty,[SerieDatenDic description]);
               [EingabeFeld setEnabled:NO];
               //[SettingsDrawer close:NULL];
               NSArray* tempTestNamenArray=[TestDicArray valueForKey:@"testname"];//Alle vorhandenen Tests
               NSLog(@"tempTestNamenArray: %@",[tempTestNamenArray description]);
               
               NSString* neuerTestName=[EingabeFeld stringValue];//Name für einen neuen Test
               NSLog(@"neuerTestName: %@",neuerTestName);
               NSUInteger doppelIndex=[tempTestNamenArray indexOfObject:neuerTestName];
               NSInteger insertIndex=-1;
               NSLog(@"doppelIndex: %d",doppelIndex);
               //NSLog(@"tempTestNamenArray: %@   neuerTestName: %@  doppelIndex: %d",[tempTestNamenArray description],neuerTestName,doppelIndex);
               
               if (((doppelIndex<NSNotFound)))//neuer Name ist schon da
               {
                  NSLog(@"Doppelter Name");
                  NSAlert* OrdnerWarnung=[[NSAlert alloc]init];
                  [OrdnerWarnung addButtonWithTitle:NSLocalizedString(@"Go Back",@"Zurück")];
                  [OrdnerWarnung addButtonWithTitle:NSLocalizedString(@"Replace Test",@"Test ersetzen")];
                  [OrdnerWarnung setMessageText:NSLocalizedString(@"Name Already Exists",@"Name schon vorhanden")];
                  [OrdnerWarnung setInformativeText:NSLocalizedString(@"The test must have another name to be saved.",@"Der Test muss einen andern Namen bekommen, um gesichert werden zu können.")];
                  
                  int modalAntwort=[OrdnerWarnung runModal];
                  switch (modalAntwort)
                  {
                     case NSAlertFirstButtonReturn://zurück
                     {
                        //[EingabeFeld setStringValue:@""];
                        [sender setTitle:@"Test sichern"];
                        [EingabeFeld setEnabled:YES];
                        [EingabeFeld selectText:NULL];
                        TestChanged=NO;
                        
                        return;
                     }break;
                     case NSAlertSecondButtonReturn://ersetzen
                     {
                        insertIndex=doppelIndex;
                        //[TestDicArray removeObjectAtIndex:doppelIndex];
                        dirty=YES;
                        [TestTable reloadData];
                     }break;
                        
                        
                  }//switch
               }
               
               if ([[EingabeFeld stringValue] length]&&dirty)
               {
                  NSMutableDictionary* neuerTestNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
                  [neuerTestNamenDic setObject:SerieDatenDic forKey:@"seriedatendic"];
                  
                  //[neuerTestNamenDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
                  [neuerTestNamenDic setObject:neuerTestName forKey:@"testname"];//leer wenn kein neuer Name
                  [neuerTestNamenDic setObject:[NSNumber numberWithInt:[aktivCheckbox state]]forKey:@"aktiv"];
                  NSNumber* AnzNumber=[NSNumber numberWithInt:[[AnzahlPopTaste titleOfSelectedItem]intValue]];
                  [neuerTestNamenDic setObject:AnzNumber forKey:@"anzahlaufgaben"];
                  
                  NSNumber* ZeitNumber=[NSNumber numberWithInt:[[ZeitPopTaste titleOfSelectedItem]intValue]];
                  //NSLog(@"reportSaveTest:	ZeitNumber: %@",ZeitNumber);
                  [neuerTestNamenDic setObject:ZeitNumber forKey:@"zeit"];
                  
                  [neuerTestNamenDic setObject:[NSNumber numberWithInt:[forAllCheckbox state]]forKey:@"alle"];
                  
                  NSLog(@"reportSaveTest	neuerTestNamenDic: %@",[neuerTestNamenDic description]);
                  if (insertIndex>=0)
                  {
                     [TestDicArray replaceObjectAtIndex:insertIndex withObject:[neuerTestNamenDic copy]];
                  }
                  else
                  {
                     [TestDicArray addObject:[neuerTestNamenDic copy]];
                  }
                  [TestTable reloadData];
                  
                  
                  
                  [neuerTestNamenDic setObject:TestDicArray forKey:@"testdicarray"];
                  
                  [neuerTestNamenDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
                  NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
                  [nc postNotificationName:@"NeuerTestname" object:self userInfo:[neuerTestNamenDic copy]];
                  
                  
                  if ([forAllCheckbox state])
                  {
                     NSArray* tempNamenArray=[NamenDicArray valueForKey:@"name"];
                     NSUInteger index=[tempNamenArray indexOfObject:aktuellerUser];
                     //NSLog(@"reportSaveTest forAll:	aktuellerUser: %@",aktuellerUser);
                     if (!(index==NSNotFound))
                     {
                        if ([[NamenDicArray objectAtIndex:index]objectForKey:@"usertestarray"])//usertestarray da
                        {
                           NSArray* tempUserTestArray=[[NamenDicArray objectAtIndex:index]objectForKey:@"usertestarray"];
                           //NSLog(@"reportSaveTest:	setTestliste:tempUserTestArray:  %@",[tempUserTestArray description]);
                           [TestZuNamenDS setTestliste:tempUserTestArray zuNamen:aktuellerUser];
                           
                        }
                        else
                        {
                           [TestZuNamenDS setTestliste:NULL zuNamen:aktuellerUser];
                        }
                        [TestZuNamenTable reloadData];
                     }
                     
                  }
                  
                  //	[DeleteTaste setEnabled:YES];
                  //	[TestForAllTaste setEnabled:YES];
                  //	[TestForNoneTaste setEnabled:YES];
                  [SchliessenTaste setEnabled:YES];
                  
                  [EingabeFeld setStringValue:@""];
                  [AnzahlPopTaste setEnabled:NO];
                  [ZeitPopTaste setEnabled:NO];
                  [SaveTestTaste setKeyEquivalent:@""];
                  [SaveTestTaste setTitle:@"Neuer Test"];
                  [SaveTestTaste setEnabled:YES];
                  [forAllCheckbox setState:0];
                  [forAllCheckbox setEnabled:NO];
                  [aktivCheckbox setState:1];
                  [aktivCheckbox setEnabled:NO];
                  [EingabeFeld setEnabled:NO];
                  [SaveTestTaste setKeyEquivalent:@""];
                  [SchliessenTaste setEnabled:YES];
                  [SchliessenTaste setKeyEquivalent:@"/r"];
                  [TestTable deselectAll:NULL];
                  [TestTable setEnabled:YES];
                  //[[self window]makeFirstResponder:SchliessenTaste];
                  
                  [self setTestWahlTasteMitTest:NULL];
                  busy=NO;
                  dirty=NO;
                  TestChanged=NO;
                  [self closeDrawer:NULL];
                  //[SettingsDrawer close:NULL];
                  //[[self window]makeFirstResponder:[self window]];
                  
               }
               else
               {
                  NSBeep();
               }
            }//if settingok
            else
            {
               
            }
            
         }//if TestChanged
         else
         {
            //nichts geändert
            [sender setTitle:@"Test sichern"];
            [EingabeFeld setEnabled:YES];
            [EingabeFeld selectText:NULL];
            TestChanged=NO;
            
         }
      }//if length
      else
      {
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung addButtonWithTitle:@"OK"];
         NSString* t0=NSLocalizedString(@"Settings for this test are incorrect",@"Einstellungen für diesen Test sind nicht korrekt");
         //NSString* t1=[NSString stringWithFormat:t0,derTestName];
         [Warnung setMessageText:t0];
         NSString* s2=NSLocalizedString(@"No Name for Test.",@"Der Test hat keinen Namen.");
         NSString* s3;//=NSLocalizedString(@"The settings are deleted.",@"Die Einstellungen werden gelöscht.");
         NSString* s1;//=NSLocalizedString(@"Error:",@"Fehler:");
         NSString* InformationString=[NSString stringWithFormat:@"%@\n%@\n%@",s1,s2,s3];
         [Warnung setInformativeText:s2];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         
         int antwort=[Warnung runModal];
         //		[SaveTestTaste setKeyEquivalent:@""];
         //		[SaveTestTaste setTitle:@"Neuer Test"];
         //		[SaveTestTaste setEnabled:NO];
         //		[EingabeFeld setEnabled:YES];
         
         //		[self closeDrawer:NULL];
      }
   }//neuer Test
}

- (IBAction)reportResaveTest:(id)sender
{
   //	NSLog(@"											reportResaveTest");
   /*
    Test aktualisieren
    */
   
   if ([[EingabeFeld stringValue]length])
   {
      NSArray* tempTestNamenArray=[TestDicArray valueForKey:@"testname"];//Alle vorhandenen Tests
      //NSLog(@"tempTestNamenArray: %@",[tempTestNamenArray description]);
      
      NSString* neuerTestName=[EingabeFeld stringValue];//Name für einen neuen Test
      //NSLog(@"neuerTestName: %@",neuerTestName);
      NSUInteger doppelIndex=[tempTestNamenArray indexOfObject:neuerTestName];
      //NSLog(@"doppelIndex: %d",doppelIndex);
      //NSLog(@"tempTestNamenArray: %@   neuerTestName: %@  doppelIndex: %d",[tempTestNamenArray description],neuerTestName,doppelIndex);
      
      if ((!(doppelIndex==NSNotFound)))//neuer Name ist schon da
      {
         
         NSLog(@"Doppelter Name");
         NSAlert* OrdnerWarnung=[[NSAlert alloc]init];
         [OrdnerWarnung addButtonWithTitle:NSLocalizedString(@"Go Back",@"Zurück")];
         [OrdnerWarnung addButtonWithTitle:NSLocalizedString(@"Replace Test",@"Test ersetzen")];
         [OrdnerWarnung setMessageText:NSLocalizedString(@"Name Already Exists",@"Name schon vorhanden")];
         [OrdnerWarnung setInformativeText:NSLocalizedString(@"The test must have another name to be saved.",@"Der Test muss einen andern Namen bekommen, um gesichert werden zu können.")];
         
         NSUInteger modalAntwort=[OrdnerWarnung runModal];
         switch (modalAntwort)
         {
            case NSAlertFirstButtonReturn://zurück
            {
               //[EingabeFeld setStringValue:@""];
               [EingabeFeld selectText:NULL];
               return;
            }break;
            case NSAlertSecondButtonReturn://ersetzen
            {
               [TestDicArray removeObjectAtIndex:doppelIndex];
               [TestTable reloadData];
            }break;
               
               
         }//switch
      }
      
      if ([[EingabeFeld stringValue] length]&&dirty)
      {
         NSMutableDictionary* neuerTestNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         
         //[neuerTestNamenDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
         [neuerTestNamenDic setObject:neuerTestName forKey:@"testname"];//leer wenn kein neuer Name
         
         
         [neuerTestNamenDic setObject:[NSNumber numberWithInt:[aktivCheckbox state]]forKey:@"aktiv"];
         NSNumber* AnzNumber=[NSNumber numberWithInt:[[AnzahlPopTaste titleOfSelectedItem]intValue]];
         [neuerTestNamenDic setObject:AnzNumber forKey:@"anzahlaufgaben"];
         
         NSNumber* ZeitNumber=[NSNumber numberWithInt:[[ZeitPopTaste titleOfSelectedItem]intValue]];
         //NSLog(@"reportSaveTest:	ZeitNumber: %@",ZeitNumber);
         [neuerTestNamenDic setObject:ZeitNumber forKey:@"zeit"];
         
         [neuerTestNamenDic setObject:[NSNumber numberWithInt:[forAllCheckbox state]]forKey:@"alle"];
         
         //NSLog(@"reportSaveTest	neuerTestNamenDic: %@",[neuerTestNamenDic description]);
         [TestDicArray addObject:neuerTestNamenDic];
         [TestTable reloadData];
         
         
         
         
         [neuerTestNamenDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
         [nc postNotificationName:@"NeuerTestname" object:self userInfo:neuerTestNamenDic];
         
         
         if ([forAllCheckbox state])
         {
            NSArray* tempNamenArray=[NamenDicArray valueForKey:@"name"];
            NSUInteger index=[tempNamenArray indexOfObject:aktuellerUser];
            //NSLog(@"reportSaveTest forAll:	aktuellerUser: %@",aktuellerUser);
            if (!(index==NSNotFound))
            {
               if ([[NamenDicArray objectAtIndex:index]objectForKey:@"usertestarray"])//usertestarray da
               {
                  NSArray* tempUserTestArray=[[NamenDicArray objectAtIndex:index]objectForKey:@"usertestarray"];
                  //NSLog(@"reportSaveTest:	setTestliste:tempUserTestArray:  %@",[tempUserTestArray description]);
                  [TestZuNamenDS setTestliste:tempUserTestArray zuNamen:aktuellerUser];
                  
               }
               else
               {
                  [TestZuNamenDS setTestliste:NULL zuNamen:aktuellerUser];
               }
               [TestZuNamenTable reloadData];
            }
            
         }
         
         
         [EingabeFeld setStringValue:@""];
         [AnzahlPopTaste setEnabled:NO];
         [ZeitPopTaste setEnabled:NO];
         [SaveTestTaste setKeyEquivalent:@""];
         [SaveTestTaste setEnabled:NO];
         [forAllCheckbox setEnabled:NO];
         [aktivCheckbox setEnabled:NO];
         [aktivCheckbox setState:1];
         [EingabeFeld setEnabled:NO];
         [SaveTestTaste setKeyEquivalent:@""];
         [SchliessenTaste setEnabled:YES];
         [SchliessenTaste setKeyEquivalent:@"/r"];
         //[[self window]makeFirstResponder:SchliessenTaste];
         
         [self setTestWahlTasteMitTest:NULL];
         busy=NO;
         dirty=NO;
         //[[self window]makeFirstResponder:[self window]];
      }
      else
      {
         NSBeep();
      }
   }//if length
}

- (void)setAnzahl:(int)derIndex
{
   //NSLog(@"TestPanel setAnzahl: %d",derIndex);
   [AnzahlPopTaste selectItemAtIndex:derIndex];
   dirty=YES;
   //[ZeitFeld setStringValue:[ZeitPopTaste titleOfSelectedItem]];
}



- (IBAction)reportAnzahl:(id)sender
{
   dirty=YES;
   [self SettingChangedAktion:NULL];
}

- (void)setZeit:(int)derIndex
{
   //NSLog(@"TestPanel setZeit: %d",derIndex);
   [ZeitPopTaste selectItemAtIndex:derIndex];
   dirty=YES;
   //[ZeitFeld setStringValue:[ZeitPopTaste titleOfSelectedItem]];
}


- (IBAction)reportZeit:(id)sender
{
   dirty=YES;
   [self SettingChangedAktion:NULL];
}

- (IBAction)reportNeuerTestForAll:(id)sender
{
   dirty=YES;
   [self SettingChangedAktion:NULL];
   
}

- (IBAction)reportNeuerTestAktiv:(id)sender
{
   dirty=YES;
   [self SettingChangedAktion:NULL];
   
}

- (IBAction)reportForAll:(id)sender
{
   //NSLog(@"reportForAll");
   if ([TestTable numberOfSelectedRows])
   {
      int index=[TestTable selectedRow];
      NSDictionary* tempTestDic=[TestDicArray objectAtIndex:index];
      if ([tempTestDic objectForKey:@"testname"])
      {
         
         NSString* tempTestName=[tempTestDic objectForKey:@"testname"];
         //NSLog(@"reportForAll: tempTestName:%@",tempTestName);
         
         if ([tempTestName length])
         {
            
            NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [NotificationDic setObject:tempTestName forKey:@"testforall"];
            NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"setTestForAll" object:self userInfo:NotificationDic];
            
            [TestZuNamenDS setDirty:YES];
            
            /*
             NSEnumerator* NamenEnum=[NamenDicArray objectEnumerator];
             id einNamenDic;
             while (einNamenDic =[NamenEnum nextObject])
             {
             if ([einNamenDic objectForKey:@"usertestarray"])//usertestarray da
             {
             NSArray* tempUserTestArray=[einNamenDic objectForKey:@"usertestarray"];
             if ([einNamenDic objectForKey:@"name"])
             {
             [TestZuNamenDS setTestliste:tempUserTestArray zuNamen:[einNamenDic objectForKey:@"name"]];
             }
             
             }
             else
             {
             if ([einNamenDic objectForKey:@"name"])
             {
             [TestZuNamenDS setTestliste:NULL zuNamen:[einNamenDic objectForKey:@"name"]];
             }
             }
             }//while
             */
            [TestZuNamenTable reloadData];
            [NamenZuTestTable reloadData];
            
         }
         
      }
   }
   
}

- (void)selectEingabeFeld
{
   [EingabeFeld setEnabled:YES];
   //[[self window]makeFirstResponder:SaveTestTaste];
   [EingabeFeld selectText:NULL];
   [SaveTestTaste setEnabled:YES];
   [SaveTestTaste setKeyEquivalent:@"\r"];
   //[[self window]makeFirstResponder:SaveTestTaste];
   [SchliessenTaste setEnabled:NO];
}

- (IBAction)reportForNone:(id)sender
{
   //NSLog(@"reportForNone anfang: TestDicArray: %@",[TestDicArray description]);
   if ([TestTable numberOfSelectedRows])
   {
      int index=[TestTable selectedRow];
      NSDictionary* tempTestDic=[TestDicArray objectAtIndex:index];
      if ([tempTestDic objectForKey:@"testname"])
      {
         
         NSString* tempTestName=[tempTestDic objectForKey:@"testname"];
         //NSLog(@"reportForAll: tempTestName:%@",tempTestName);
         
         if ([tempTestName length])
         {
            
            NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [NotificationDic setObject:tempTestName forKey:@"testforall"];
            NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"clearTestForAll" object:self userInfo:NotificationDic];
            
            [TestZuNamenDS setDirty:YES];
            
            NSEnumerator* NamenEnum=[NamenDicArray objectEnumerator];
            id einNamenDic;
            while (einNamenDic =[NamenEnum nextObject])
            {
               if ([einNamenDic objectForKey:@"usertestarray"])//usertestarray da
               {
                  NSArray* tempUserTestArray=[einNamenDic objectForKey:@"usertestarray"];
                  if ([einNamenDic objectForKey:@"name"])
                  {
                     [TestZuNamenDS setTestliste:tempUserTestArray zuNamen:[einNamenDic objectForKey:@"name"]];
                  }
                  
               }
               else
               {
                  if ([einNamenDic objectForKey:@"name"])
                  {
                     [TestZuNamenDS setTestliste:NULL zuNamen:[einNamenDic objectForKey:@"name"]];
                  }
               }
            }//while
            [TestZuNamenTable reloadData];
            [NamenZuTestTable reloadData];
            
         }
         
      }
   }
   NSLog(@"reportForNone ende: TestDicArray: %@",[TestDicArray description]);
   
}
- (IBAction)AktivCheckboxAktion:(id)sender
{
   //NSLog(@"AktivCheckboxAktion: Zeile: %d",[sender selectedRow]);
   [self SettingChangedAktion:NULL];
   NSMutableDictionary* einTestDic;
   einTestDic=(NSMutableDictionary*)[TestDicArray objectAtIndex:[sender selectedRow]];
   
   //NSLog(@"AktivCheckboxAktion		einTestDic: %@	",[einTestDic description]);
   if ([einTestDic objectForKey:@"aktiv"])
   {
      int tempAktivStatus=[[einTestDic objectForKey:@"aktiv"]intValue];
      
      //NSLog(@"AktivCheckboxAktion  selectedRow: %d	aktiv: %d",[sender selectedRow],tempAktivStatus);
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:[einTestDic objectForKey:@"aktiv"] forKey:@"aktiv"];
      [NotificationDic setObject:[einTestDic objectForKey:@"testname"] forKey:@"testname"];
      //	[NotificationDic setObject: [NSNumber numberWithInt:0] forKey:@"alle"];
      //NSLog(@"AktivCheckboxAktion		NotificationDic: %@	",[NotificationDic description]);
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"TestAktiv" object:self userInfo:NotificationDic];
      [einTestDic setObject: [NSNumber numberWithInt:0] forKey:@"alle"];
      [TestTable reloadData];
      [TestZuNamenTable reloadData];
      [NamenZuTestTable reloadData];
      
      
   }//if aktiv
   
}



- (void)setTestForAllInNamenDicArray:(NSString*)derTest
{
   //NSLog(@"setTestForAllInNamenDicArray: derTest:%@",derTest);
   if ([TestTable numberOfSelectedRows])
   {
      int index=[TestTable selectedRow];
      NSDictionary* tempTestDic=[TestDicArray objectAtIndex:index];
      
      if ([tempTestDic objectForKey:@"testname"])
      {
         
         NSString* tempTestName=[tempTestDic objectForKey:@"testname"];
         //NSLog(@"setTestForAll: tempTestName:%@	tempTestDic: %@",tempTestName,[tempTestDic description]);
         
         if ([derTest length])
         {
            [TestZuNamenDS setDirty:YES];
            
            NSEnumerator* NamenEnum=[NamenDicArray objectEnumerator];
            id einNamenDic;
            while (einNamenDic =[NamenEnum nextObject])
            {
               if ([einNamenDic objectForKey:@"usertestarray"])//usertestarray da
               {
                  NSArray* tempUserTestArray=[einNamenDic objectForKey:@"usertestarray"];
                  if ([einNamenDic objectForKey:@"name"])
                  {
                     [TestZuNamenDS setTestliste:tempUserTestArray zuNamen:[einNamenDic objectForKey:@"name"]];
                  }
                  
               }
               else
               {
                  if ([einNamenDic objectForKey:@"name"])
                  {
                     [TestZuNamenDS setTestliste:NULL zuNamen:[einNamenDic objectForKey:@"name"]];
                  }
               }
               
            }//while
            [TestZuNamenTable reloadData];
            [NamenZuTestTable reloadData];
            
         }//if name
      }//if length
   }
   //NSLog(@"setTestForAllinNamenDicArray:	ende");
}

- (void)setTestForAll:(NSString*)derTest
{
   
   //NSLog(@"setTestForAll: derTest: %@",derTest);
   if ([TestTable numberOfSelectedRows])
   {
      int index=[TestTable selectedRow];
      NSDictionary* tempTestDic=[TestDicArray objectAtIndex:index];
      
      if ([tempTestDic objectForKey:@"testname"])
      {
         
         NSString* tempTestName=[tempTestDic objectForKey:@"testname"];
         //NSLog(@"TestPanel setTestForAll vor set: tempTestName:%@	tempTestDic: %@",tempTestName,[tempTestDic description]);
         
         if ([derTest length])
         {
            
            NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [NotificationDic setObject:derTest forKey:@"testforall"];
            NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"setTestForAll" object:self userInfo:NotificationDic];
            
            [TestZuNamenDS setDirty:YES];
            
            [TestZuNamenTable reloadData];
            [NamenZuTestTable reloadData];
            
         }//if name
      }//if length
   }
   //NSLog(@"setTestForAll:	ende");
}

- (IBAction)reportTestToAll:(id)sender
{
   //NSLog(@"reportTestToAll: tag: %d",[sender selectedSegment]);
   switch ([sender selectedSegment])
   {
      case 0:
      {
         //NSLog(@"reportTestToAll einsetzen: tag: %d",[sender selectedSegment]);
         
         [self reportTestInAlleEinsetzen:NULL];
      }break;
      case 1:
      {
         //NSLog(@"reportTestToAll entfernen: tag: %d",[sender selectedSegment]);
         [self reportTestAusAllenEntfernen:NULL];
      }break;
         
   }//switch
   
}

- (IBAction)reportTestInAlleEinsetzen:(id)sender
{
   if ([TestWahlTaste indexOfSelectedItem])
   {
      //NSLog(@"reportTestInAlleEinsetzen: derTest: %@",[TestWahlTaste titleOfSelectedItem]);
      NSString* tempTestName =[TestWahlTaste titleOfSelectedItem];
      
      
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:tempTestName forKey:@"testforall"];
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"setTestForAll" object:self userInfo:NotificationDic];
      
      
      [TestZuNamenDS setDirty:YES];
      [self setNamenZuTestDSForTest:tempTestName];
      [TestZuNamenTable reloadData];
      [NamenZuTestTable reloadData];
      
      
   }
}

- (void)clearTestForAll:(NSString*)derTest
{
   //Test aus allen userarrays streichen
   NSLog(@"clearTestForAll: derTest: %@",derTest);
   if ([TestTable numberOfSelectedRows])
   {
      int index=[TestTable selectedRow];
      NSDictionary* tempTestDic=[TestDicArray objectAtIndex:index];
      
      if ([tempTestDic objectForKey:@"testname"])
      {
         
         NSString* tempTestName=[tempTestDic objectForKey:@"testname"];
         NSLog(@"clearTestForAll: tempTestName:%@	tempTestDic: %@",tempTestName,[tempTestDic description]);
         
         if ([tempTestName length])
         {
            
            NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [NotificationDic setObject:tempTestName forKey:@"testforall"];
            NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"clearTestForAll" object:self userInfo:NotificationDic];
            [TestZuNamenDS setDirty:YES];
         }
         //			[self setNamenZuTestDSForTest:tempTestName];
      }//if name
   }
   //NSLog(@"clearTestForAll:	ende");
}


- (IBAction)reportTestAusAllenEntfernen:(id)sender
{
   if ([TestWahlTaste indexOfSelectedItem])
   {
      NSLog(@"reportTestAusAllenEntfernen: derTest: %@",[TestWahlTaste titleOfSelectedItem]);
      NSString* tempTestName =[TestWahlTaste titleOfSelectedItem];
      
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:tempTestName forKey:@"testforall"];
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"clearTestForAll" object:self userInfo:NotificationDic];
      
      [TestZuNamenDS setDirty:YES];
      
      //		[self setNamenZuTestDSForTest:tempTestName];
      
      [TestZuNamenTable reloadData];
      [NamenZuTestTable reloadData];
      
      
   }
}

- (IBAction)ForAllCheckboxAktion:(id)sender
{
   /*
    Aktion der Checkbox 'forAll'
    */
   
   //NSLog(@"ForAllCheckboxAktion: Zeile: %d",[sender selectedRow]);
   NSMutableDictionary* einTestDic=(NSMutableDictionary*)[TestDicArray objectAtIndex:[sender selectedRow]];
   int forAllStatus=[[einTestDic objectForKey:@"alle"]intValue];
   NSString* tempTestName=[einTestDic objectForKey:@"testname"];
   
   NSLog(@"ForAllCheckboxAktion: %d	status: %d	Name: %@",[sender selectedRow],forAllStatus,tempTestName);
   
   if (forAllStatus)
   {
      //NSLog(@"ForAllCheckboxAktion: clear: %d",forAllStatus);
      [self clearTestForAll:tempTestName];
      
   }
   else
   {
      //NSLog(@"ForAllCheckboxAktion: set: %d\n\n",forAllStatus);
      
      [self setTestForAll:tempTestName];
      
   }
   
   [TestZuNamenTable reloadData];
   [NamenZuTestTable reloadData];
   
}



- (void)saveTest
{
   if ([[EingabeFeld stringValue] length])
   {
      //NSLog(@"											SaveTest");
      NSArray* tempTestNamenArray=[TestDicArray valueForKey:@"testname"];//Alle vorhandenen Tests
      //NSLog(@"tempTestNamenArray: %@",[tempTestNamenArray description]);
      
      NSString* neuerTestName=[EingabeFeld stringValue];//Name für einen neuen Test
      //NSLog(@"neuerTestName: %@",neuerTestName);
      NSUInteger doppelIndex=[tempTestNamenArray indexOfObject:neuerTestName];
      //NSLog(@"doppelIndex: %d",doppelIndex);
      //NSLog(@"tempTestNamenArray: %@   neuerTestName: %@  doppelIndex: %d",[tempTestNamenArray description],neuerTestName,doppelIndex);
      
      if ((!(doppelIndex==NSNotFound)))//neuer Name ist schon da
      {
         
         NSLog(@"Doppelter Name");
         NSAlert* OrdnerWarnung=[[NSAlert alloc]init];
         [OrdnerWarnung addButtonWithTitle:NSLocalizedString(@"Go Back",@"Zurück")];
         [OrdnerWarnung addButtonWithTitle:NSLocalizedString(@"Replace Test",@"Test ersetzen")];
         [OrdnerWarnung setMessageText:NSLocalizedString(@"Name Already Exists",@"Name schon vorhanden")];
         [OrdnerWarnung setInformativeText:NSLocalizedString(@"The test must have anpther name to be saved.",@"Der Test muss einen andern Namen bekommen, um gesichert werden zu können.")];
         
         int modalAntwort=[OrdnerWarnung runModal];
         switch (modalAntwort)
         {
            case NSAlertFirstButtonReturn://zurück
            {
               //[EingabeFeld setStringValue:@""];
               [EingabeFeld selectText:NULL];
               return;
            }break;
            case NSAlertSecondButtonReturn://ersetzen
            {
               [TestDicArray removeObjectAtIndex:doppelIndex];
               [TestTable reloadData];
            }break;
               
               
         }//switch
      }
      
      if ([[EingabeFeld stringValue] length]&&dirty)
      {
         NSMutableDictionary* neuerTestNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         
         //[neuerTestNamenDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
         [neuerTestNamenDic setObject:neuerTestName forKey:@"testname"];//leer wenn kein neuer Name
         [neuerTestNamenDic setObject:[NSNumber numberWithInt:[aktivCheckbox state]]forKey:@"aktiv"];
         NSNumber* AnzNumber=[NSNumber numberWithInt:[[AnzahlPopTaste titleOfSelectedItem]intValue]];
         [neuerTestNamenDic setObject:AnzNumber forKey:@"anzahlaufgaben"];
         
         NSNumber* ZeitNumber=[NSNumber numberWithInt:[[ZeitPopTaste titleOfSelectedItem]intValue]];
         //NSLog(@"reportSaveTest:	ZeitNumber: %@",ZeitNumber);
         [neuerTestNamenDic setObject:ZeitNumber forKey:@"zeit"];
         
         [neuerTestNamenDic setObject:[NSNumber numberWithInt:[forAllCheckbox state]]forKey:@"alle"];
         
         //NSLog(@"reportSaveTest	neuerTestNamenDic: %@",[neuerTestNamenDic description]);
         [TestDicArray addObject:neuerTestNamenDic];
         [TestTable reloadData];
         
         
         [neuerTestNamenDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
         [nc postNotificationName:@"NeuerTestname" object:self userInfo:neuerTestNamenDic];
         
         
         [EingabeFeld setStringValue:@""];
         [AnzahlPopTaste setEnabled:NO];
         [ZeitPopTaste setEnabled:NO];
         [SaveTestTaste setKeyEquivalent:@""];
         [SaveTestTaste setEnabled:NO];
         [forAllCheckbox setEnabled:NO];
         [aktivCheckbox setEnabled:NO];
         [aktivCheckbox setState:1];
         [SchliessenTaste setKeyEquivalent:@"/r"];
         [TestZuNamenTable reloadData];
         [NamenZuTestTable reloadData];
         
         dirty=NO;
      }
      else
      {
         NSBeep();
      }
   }//if length
}

- (void)saveUserTestArray
{
   if ([TestZuNamenDS isDirty]&&[NamenWahlTaste titleOfSelectedItem])//es wurde etwas geändert
   {
      NSArray* letzterUserTestArray=[TestZuNamenDS aktivTestForUserArray];
      
      NSArray* tempNamenArray=[NamenDicArray valueForKey:@"name"];
      NSUInteger index=[tempNamenArray indexOfObject:[NamenWahlTaste titleOfSelectedItem]];
      if ((index<NSNotFound))
      {
         [[NamenDicArray objectAtIndex:index]setObject:letzterUserTestArray forKey:@"usertestarray"];
         
         
         //		NSLog(@"saveUserTestArray		tempNamenArray: %@	aktuellerUser: %@	index: %d\n\n",[tempNamenArray description],aktuellerUser,index);
         //		NSLog(@"saveUserTestArray		aktuellerUser: %@	index: %d\n\n",aktuellerUser,index);
         //Einstellungen von letzterUserArray sichern
         NSMutableDictionary* UserTestArrayDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [UserTestArrayDic setObject:letzterUserTestArray forKey:@"usertestarray"];
         [UserTestArrayDic setObject:[NamenWahlTaste titleOfSelectedItem] forKey:@"user"];
         [UserTestArrayDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
         
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
         [nc postNotificationName:@"NeuerUserTestArray" object:self userInfo:UserTestArrayDic];
         [TestZuNamenDS setDirty:NO];
         [TestZuNamenTable reloadData];
         [NamenZuTestTable reloadData];
      }//
   }
}

- (void)saveUserTestArrayForUser:(NSString*)derUser
{
   NSArray* letzterUserTestArray=[TestZuNamenDS aktivTestForUserArray];//aktive Tests von User
   
   NSArray* tempNamenArray=[NamenDicArray valueForKey:@"name"];
   NSUInteger index=[tempNamenArray indexOfObject:derUser];
   if (index<NSNotFound)
   {
      [[NamenDicArray objectAtIndex:index]setObject:letzterUserTestArray forKey:@"usertestarray"];
      
      
      //		NSLog(@"saveUserTestArrayForUser		tempNamenArray: %@	User: %@	index: %d\n\n",[tempNamenArray description],derUser,index);
      //NSLog(@"saveUserTestArray		derUser: %@	index: %d\n\n",derUser,index);
      //Einstellungen von letzterUserArray sichern
      NSMutableDictionary* UserTestArrayDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [UserTestArrayDic setObject:letzterUserTestArray forKey:@"usertestarray"];
      [UserTestArrayDic setObject:derUser forKey:@"user"];
      [UserTestArrayDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"NeuerUserTestArray" object:self userInfo:UserTestArrayDic];
   }//Name da
   
   [TestZuNamenTable reloadData];
   [NamenZuTestTable reloadData];
   
}

- (void)setTestZuNamenDSForUser:(NSString*)derUser
{
   //	NSLog(@"setTestZuNamenDSForUser: derUser: %@ ",derUser);
   //vorhandene Namen auflisten
   
   NSString* tempUserName=@"";
   
   
   NSArray* tempNamenArray=[NamenDicArray valueForKey:@"name"];
   //index von derUser im tempNamenArray suchen
   long namenIndex=[tempNamenArray indexOfObject:derUser];
   
   if (namenIndex==NSNotFound)//ungueltiger Name
   {
      tempUserName=@"";//Einen String mit length an die Table senden: Checkbox desablen
   }
   else
   {
      tempUserName=derUser;
   }
   
   //	NSLog(@"setTestZuNamenDSForUser: %@	namenIndex: %d",derUser,namenIndex);
   
   
   
   NSArray* tempUserTestArray;
   NSDictionary* tempNamenDic;
   
   if (namenIndex==NSNotFound)//leerer Name
   {
      //NSLog(@"leerer Name");
      tempUserTestArray=[NSArray array];
      [NamenWahlTaste selectItemAtIndex:0];//'Namen waehlen' selektieren
      
   }
   else
   {
      tempNamenDic=[NamenDicArray objectAtIndex:namenIndex];//Dic zu 'derUser'
      tempUserTestArray=[[NamenDicArray objectAtIndex:namenIndex]objectForKey:@"usertestarray"];
      //		NSLog(@"tempUserTestArray: %@",[tempUserTestArray description]);
      [NamenWahlTaste selectItemWithTitle:derUser];//'derUser' selektieren, wenn nicht schon vorher gesetzt
   }
   
   //Array 'tempNamenDicArray'  mit Tests zum Namen 'derUser' zusammentragen
   NSMutableArray* tempNamenDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   //	NSLog(@"setTestZuNamenDSForUser		tempUserTestArray: %@",[tempUserTestArray description]);
   
   NSEnumerator* TestEnum=[TestDicArray objectEnumerator];//Array mit vorhandenen Tests aus der PList des Programms
   id einTestDic;
   while (einTestDic=[TestEnum nextObject])
   {
      NSLog(@"einTestDic: %@",[einTestDic description]);
      if ([einTestDic objectForKey:@"testname"])
      {
         //Test aufnehmen sofern aktiviert
         if ([einTestDic objectForKey:@"testname"]&&[[einTestDic objectForKey:@"aktiv"]boolValue])
         {
            //Dic mit dem TestNamen und OK, sofern der Test zugeteilt ist
            
            
            NSMutableDictionary* tempTestDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            if (derUser)
            {
               [tempTestDic setObject:derUser forKey:@"user"];
            }
            [tempTestDic setObject:[einTestDic objectForKey:@"testname"] forKey:@"testname"];
            [tempTestDic setObject:[einTestDic objectForKey:@"anzahlaufgaben"] forKey:@"anzahlaufgaben"];
            [tempTestDic setObject:[einTestDic objectForKey:@"zeit"] forKey:@"zeit"];
            
            //Wenn Test im Userarray ist, userok setzen
            if ([tempUserTestArray containsObject:[einTestDic objectForKey:@"testname"]])
            {
               //NSLog(@"Test ist zugeteilt: %@",[einTestDic objectForKey:@"testname"]);
               [tempTestDic setObject:[NSNumber numberWithBool:YES]forKey:@"userok"];
               //[tempTestDic setObject:[NSNumber numberWithBool:YES]forKey:@"testok"];
               
            }
            else
            {
               //NSLog(@"Test ist nicht zugeteilt: %@",[einTestDic objectForKey:@"testname"]);
               [tempTestDic setObject:[NSNumber numberWithBool:NO]forKey:@"userok"];
               //[tempTestDic setObject:[NSNumber numberWithBool:NO]forKey:@"testok"];
               
               
            }
            
            [tempNamenDicArray addObject:tempTestDic];
         }
         
      }//if testname
      
   }//while
   //	NSLog(@"User: %@		tempNamenDicArray: %@",derUser,[tempNamenDicArray description]);
   //NSLog(@"namenIndex: %d",namenIndex);
   
   //tempNamenDicArray an TestZuNamenDS schicken, wird dort in TableView eingesetzt
   if ([tempNamenDicArray count])
   {
      [TestZuNamenDS setTestliste:tempNamenDicArray zuNamen:tempUserName];
   }
   else
   {
      [TestZuNamenDS setTestliste:NULL zuNamen:tempUserName];
   }
   
   [TestZuNamenTable reloadData];
   [NamenZuTestTable reloadData];
}

- (IBAction)reportNamen:(id)sender
{
   if ([sender indexOfSelectedItem])
      
   {
      //	NSLog(@"reportNamen");
      [self setTestZuNamenDSForUser:[sender titleOfSelectedItem]];
   }
   else
   {
      [self setTestZuNamenDSForUser:NULL];
      [TestZuNamenTable deselectAll:NULL];
   }
   
   
}//reportNamen


- (int)anzTestForUser:(NSString*)derUser
{
   int anzTest=0;
   NSArray* tempNamenArray=[NamenDicArray valueForKey:@"name"];
   //index von derUser im tempNamenArray suchen
   NSUInteger namenIndex=[tempNamenArray indexOfObject:derUser];
   
   if (namenIndex==NSNotFound)//leerer Name
   {
      //NSLog(@"leerer Name");
      //tempUserTestArray=[NSArray array];
   }
   else
   {
      NSArray* tempUserTestArray=[[NamenDicArray objectAtIndex:namenIndex]objectForKey:@"usertestarray"];
      if (tempUserTestArray)
      {
         anzTest=[tempUserTestArray count];
      }
      //		NSLog(@"tempUserTestArray: %@",[tempUserTestArray description]);
      
   }
   
   
   
   return anzTest;
}

- (void)saveNamenVonTestArray
{
   if ([NamenZuTestDS isDirty]&&[TestWahlTaste titleOfSelectedItem])
   {
      
   }//if dirty
}

-(void)TestZuNamenCheckboxAktion:(id)sender
{
   
   
   //in TestZuNamen wurde die Checkbox  userOK angeklickt
   NSLog(@"TestZuNamenCheckboxAktion: Zeile: %ld",[sender selectedRow]);
   //Dic vor Aenderung
   if ([NamenWahlTaste indexOfSelectedItem])
   {
      //NSArray* tempArray =[TestZuNamenDS TestZuNamenDicArray];
      // long zeile = [sender selectedRow];
      // NSMutableDictionary* tempNamenDic= (NSMutableArray*)[tempArray objectAtIndex:zeile];
      NSMutableDictionary* tempNamenDic= [(NSMutableArray*)[(rTestZuNamenDS*)[TestZuNamenTable dataSource] TestZuNamenDicArray]objectAtIndex:[sender selectedRow]];
      
      BOOL testOKStatus=[[tempNamenDic objectForKey:@"userok"]boolValue];
      NSString* tempUserName=[NamenWahlTaste titleOfSelectedItem];
      NSString* tempTestName=[tempNamenDic objectForKey:@"testname"];
      int anzTest=[self anzTestForUser:tempUserName];
      //	NSLog(@"TestZuNamenCheckboxAktion	bisheriger tempNamenDic: %@ anzTest: %d",[tempNamenDic description],anzTest);
      NSNumber* userokNumber=[tempNamenDic objectForKey:@"userok"];
      //	NSLog(@"TestZuNamenCheckboxAktion: %d	status: %d	Name: %@	Testname: %@",[sender selectedRow],testOKStatus,tempUserName,tempTestName);
      if (anzTest==1&&[userokNumber intValue])
      {
         
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung addButtonWithTitle:@"OK"];
         NSString* MessageString=@"Nur noch ein Test";
         [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
         NSString* s0=NSLocalizedString(@"%@ is the only test activatet for user %@.",@"%@ ist der einzige Test für %@.");
         NSString* s1=[NSString stringWithFormat:s0,tempTestName,tempUserName];
         NSLog(@"s1: %@",s1);
         NSString* s2=@"";//NSLocalizedString(@"The Test is not deleted.",@"Der Test wird nicht gelöscht");
         NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
         [Warnung setInformativeText:InformationString];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         int antwort=[Warnung runModal];
         //	NSMutableDictionary* tempNewNamenDic=(NSMutableDictionary*)[[[TestZuNamenTable dataSource]TestZuNamenDicArray] objectAtIndex:[sender selectedRow]];
         //	NSLog(@"TestZuNamenCheckboxAktion	neuer tempNamenDic: %@",[tempNewNamenDic description]);
         
         //[TestZuNamenTable reloadData];
         //	return;
      }
      //Aenderung in Controller melden, auf Disk fixieren
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:[NSNumber numberWithBool:testOKStatus] forKey:@"usertestok"];
      [NotificationDic setObject:tempTestName forKey:@"testname"];
      [NotificationDic setObject:[NamenWahlTaste titleOfSelectedItem] forKey:@"username"];
      [NotificationDic setObject:[NSNumber numberWithInt:[self anzTestForUser:tempUserName]] forKey:@"anztest"];
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"UserTestArrayChanged" object:self userInfo:NotificationDic];
      [TestZuNamenDS setDirty:YES];
   }
   
}

-(void)NamenZuTestCheckboxAktion:(id)sender
{
   //in NamenZuTest wurde die Checkbox testok angeklickt
   
   //	NSLog(@"NamenZuTestCheckboxAktion: Zeile: %d\n\n",[sender selectedRow]);
   NSMutableDictionary* tempNamenDic= [(NSMutableArray*)[(rNamenZuTestDS*)[NamenZuTestTable dataSource] NamenZuTestDicArray]objectAtIndex:[sender selectedRow]];
   
   
   BOOL namenOKStatus=[[tempNamenDic objectForKey:@"testok"]boolValue];
   int CheckboxStatus=[[[sender tableColumnWithIdentifier:@"testok"]dataCellForRow:[sender selectedRow]]state];
   NSString* tempUserName=[tempNamenDic objectForKey:@"name"];
   //	NSLog(@"NamenZuTestCheckboxAktion Zeile: %d	status: %d	UserName: %@ CheckboxStatus: %d",[sender selectedRow],namenOKStatus,tempUserName,CheckboxStatus);
   
   NSUInteger namenIndex=[[NamenDicArray valueForKey:@"name"]indexOfObject:tempUserName];//Daten fuer tempUsername
   //	NSLog(@"NamenZuTestCheckbox %@ namenIndex: %d",[[NamenDicArray valueForKey:@"name"]description],namenIndex);
   if (namenIndex<NSNotFound)
   {
      //		NSLog(@"User:  %@",[[NamenDicArray objectAtIndex:namenIndex] description]);
      NSArray* tempUserTestArray=[[NamenDicArray objectAtIndex:namenIndex]objectForKey:@"usertestarray"];
      //		NSLog(@"tempUserTestArray %@",[tempUserTestArray description]);
      if (tempUserTestArray)
      {
         if ([tempUserTestArray count]==1&&namenOKStatus)//nur noch 1 test und vorher aktiviert
         {
            
            NSString* tempTestName=[tempUserTestArray objectAtIndex:0];
            //				NSLog(@"NamenZuTestCheckboxAktion  Nur noch ein Test fuer  User: %@",tempUserName);
            
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"OK"];
            NSString* MessageString=@"Nur noch ein Test";
            [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
            NSString* s0=NSLocalizedString(@"%@ is the only test activatet for user %@.",@"%@ ist der einzige Test für %@.");
            NSString* s1=[NSString stringWithFormat:s0,tempTestName,tempUserName];
            //				NSLog(@"s1: %@",s1);
            NSString* s2=@"";//NSLocalizedString(@"The Test is not deleted.",@"Der Test wird nicht gelöscht");
            NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
            [Warnung setInformativeText:InformationString];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            int antwort=[Warnung runModal];
            
         }
         
      }
      
   }
   
   //NSLog(@"NamenZuTestCheckboxAktion vor nc");
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithBool:namenOKStatus] forKey:@"usertestok"];
   [NotificationDic setObject:tempUserName forKey:@"username"];
   [NotificationDic setObject:[TestWahlTaste titleOfSelectedItem] forKey:@"testname"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"UserTestArrayChanged" object:self userInfo:NotificationDic];
   
   [TestZuNamenDS setDirty:YES];
   [NamenZuTestDS setDirty:YES];
   //	NSLog(@"NamenZuTestCheckboxAktion nach nc");
   
   
   /* 20.8.
    NSEnumerator* NamenEnum=[NamenDicArray objectEnumerator];
    id einNamenDic;
    while (einNamenDic =[NamenEnum nextObject])
    {
    if ([einNamenDic objectForKey:@"usertestarray"])//usertestarray da
    {
    NSArray* tempUserTestArray=[einNamenDic objectForKey:@"usertestarray"];
    if ([einNamenDic objectForKey:@"name"])
    {
				[TestZuNamenDS setTestliste:tempUserTestArray zuNamen:[einNamenDic objectForKey:@"name"]];
    }
    
    }
    else
    {
    if ([einNamenDic objectForKey:@"name"])
    {
				[TestZuNamenDS setTestliste:NULL zuNamen:[einNamenDic objectForKey:@"name"]];
    }
    }
    }//while
    */
   [NamenZuTestTable reloadData];
   
   
}

- (void)setNamenZuTestDSForTest:(NSString*)derTest
{
   //Namenliste fuer den Test an NamenZuTestDS schicken
   
   //	NSLog(@"setNamenZuTestDSForTest	Testname: %@",derTest);
   NSString* tempTestName=@"";
   long index=[TestWahlTaste indexOfSelectedItem];
   if (index)
   {
      tempTestName=derTest;//Einen String mit derTest an die Table senden: Checkbox enablen
   }
   //	NSLog(@"setNamenZuTestDSForTest	Testname: %@",derTest);
   
   NSArray* tempTestNamenArray =[TestDicArray valueForKey:@"testname"];
   //	NSLog(@"setNamenZuTestDSForTest:		tempTestNamenArray: %@",[tempTestNamenArray description]);
   //Ist der ausgewählte Test in TestDicArray?
   
   long testIndex=[tempTestNamenArray indexOfObject:derTest];
   
   if (testIndex<NSNotFound)
   {
      tempTestName=@" ";//Einen String mit length an die Table senden: Checkbox enablen
   }
   
   
   
   //NSLog(@"setNamenZuTestDSForTest:	testIndex: %d	tempTestNamenArray: %@",testIndex,[tempTestNamenArray description]);
   
   if (testIndex<NSNotFound)//Test ist vorhanden
   {
      [TestWahlTaste selectItemWithTitle:derTest];
      NSDictionary* tempTestDic=[TestDicArray objectAtIndex:testIndex];
      if ([tempTestDic objectForKey:@"anzahlaufgaben"])//AnzFeld fuer Test setzen
      {
         [AnzahlAufgabenFeld setStringValue:[[tempTestDic objectForKey:@"anzahlaufgaben"]stringValue]];
      }
      else
      {
         [AnzahlAufgabenFeld setStringValue:@""];
      }
      
      if ([tempTestDic objectForKey:@"zeit"])//ZeitFeld fuer Test setzen
      {
         [ZeitFeld setStringValue:[[tempTestDic objectForKey:@"zeit"]stringValue]];
      }
      else
      {
         [ZeitFeld setStringValue:@""];
      }
      
   }
   
   if (([derTest length]==0)||(index==0))//Testwahltaste auf 'test waehlen'
   {
      //NSLog(@"[derTest length]==0");
      [AnzahlAufgabenFeld setStringValue:@""];
      [ZeitFeld setStringValue:@""];
   }
   //Array 'tempTestNamenDicArray'  mit Namen zum Testnamen zusammentragen
   
   NSMutableArray* tempTestNamenDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   //	if (index)//nicht 'Namen waehlen'
   {
      //NSLog(@"vor Enum");
      NSEnumerator* NamenEnum=[NamenDicArray objectEnumerator];
      id einNamenDic;
      while (einNamenDic=[NamenEnum nextObject])
      {
         if ([einNamenDic objectForKey:@"name"])
         {
            //Name aufnehmen sofern aktiviert
            if ([einNamenDic objectForKey:@"name"]&&[[einNamenDic objectForKey:@"aktiv"]boolValue])
            {
               //Dic mit dem Namen und OK, sofern der Test zugeteilt ist
               NSMutableDictionary* tempNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               
               if (derTest)
               {
                  [tempNamenDic setObject:derTest forKey:@"testname"];
               }
               [tempNamenDic setObject:[einNamenDic objectForKey:@"name"] forKey:@"name"];
               NSArray* tempUserTestArray=[einNamenDic objectForKey:@"usertestarray"];
               //NSLog(@"Name: %@: tempUserTestArray: %@",[einNamenDic objectForKey:@"name"],[tempUserTestArray description]);
               // 20.7.					if (index && tempUserTestArray &&[tempUserTestArray containsObject:derTest])//Der Test ist im usertestarray
               
               
               
               if (tempUserTestArray &&[tempUserTestArray containsObject:derTest])//Der Test ist im usertestarray
               {
                  //NSLog(@"%@	setNamenZuTestDSForTest: Test %@ ist zugeteilt",[einNamenDic objectForKey:@"name"],derTest);
                  [tempNamenDic setObject:[NSNumber numberWithBool:YES] forKey:@"testok"];//Test ist zugeteilt
               }
               else
               {
                  [tempNamenDic setObject:[NSNumber numberWithBool:NO] forKey:@"testok"];//Test ist nicht zugeteilt
               }
               [tempTestNamenDicArray addObject:tempNamenDic];
            }//if aktiv
         }//if name
      }//while
      //NSLog(@"setNamenZuTestDSForTest:	nach if index: tempTestNamenDicArray: %@",[tempTestNamenDicArray description]);
   }//if index
   //	else
   {
      //		[ZeitFeld setStringValue:@""];
      //		[AnzahlAufgabenFeld setStringValue:@""];
   }
   //tempTestNamenDicArray an DS schicken
   //	NSLog(@"setNamenZuTestDSForTest:	vor  setNamenliste \ntempTestNamenDicArray:%@",[tempTestNamenDicArray description]);
   [NamenZuTestDS setNamenliste: tempTestNamenDicArray zuTest:tempTestName];
   //NSLog(@"setNamenZuTestDSForTest:	nach  setNamenliste");
   
   [NamenZuTestTable reloadData];
   //NSLog(@"setNamenZuTestDSForTest:	nach NamenZuTestTable");
   [TestZuNamenTable reloadData];
   //NSLog(@"setNamenZuTestDSForTest:	nach TestZuNamenTable");
}

- (IBAction)reportTestNamen:(id)sender
{
   //Namenliste fuer den Test an NamenZuTestDS schicken
   //NSLog(@"reportTestNamen	Testname: %@",[sender titleOfSelectedItem]);
   if ([sender indexOfSelectedItem])
   {
      [self setNamenZuTestDSForTest:[sender titleOfSelectedItem]];
      
      [TestInAlleEinsetzenTaste setEnabled:[sender indexOfSelectedItem]];
      [TestAusAllenEntfernenTaste setEnabled:[sender indexOfSelectedItem]];
   }
   else
   {
      [self setNamenZuTestDSForTest:NULL];
      [NamenZuTestTable deselectAll:NULL];
      //	[self setTestZuNamenDSForUser:NULL];
      //	[TestZuNamenTable deselectAll:NULL];
      
      
   }
}



- (IBAction)reportSettingAlsTestSichern:(id)sender
{
   NSLog(@"TestPanel reportSettingAlsTestSichern");
   [self closeDrawer:NULL];
   [EingabeFeld setEnabled:YES];
   [[self window]makeFirstResponder:EingabeFeld];
   NSLog(@"reportSettingAlsTestSichern: SerieDatenDic: %@",[SerieDatenDic description]);
   
   //
   
   //[TestPanel selectEingabeFeld];
   //[TestPanel setAnzahl:[AnzahlPopKnopf indexOfSelectedItem]];
   //[TestPanel setZeit:[ZeitPpKnopf indexOfSelectedItem]];
   
}


- (NSDictionary*)SerieDatenDicAusSettings
{
   int multOK=[ReihenSettings checkSettings];
   int anzReihenOK=0;
   int addsubOK=[AddSubSettings checkSettings];
   int anzAddSubOK=0;
   
   //NSLog(@"SerieDatenDicAusSettings	multOK: %d		addsubOK: %d",multOK,addsubOK);
   NSMutableDictionary* tempDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   [tempDic setObject:[NSNumber numberWithBool:(multOK+addsubOK)] forKey:@"settingcheck"];
   [tempDic setObject:[NSNumber numberWithInt:[[AnzahlPopTaste titleOfSelectedItem]intValue]] forKey:@"anzahlaufgaben"];
   //	NSLog(@"SerieDatenDicAusSettings	1");
   [tempDic setObject:[NSNumber numberWithInt:[[ZeitPopTaste titleOfSelectedItem]intValue]] forKey:@"zeit"];
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
   
   NSLog(@"SerieDatenDicAusSettings end: %@",[tempDic description]);
   [tempDic writeToFile:NSHomeDirectory() atomically:YES];
   
   
   return tempDic;
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

- (void)SettingChangedAktion:(NSNotification*)note
{
   NSLog(@"SettingChangedAktion: note: %@",[[note userInfo]description]);
   TestChanged=YES;
   if (note&&[note userInfo]&&[[note userInfo] objectForKey:@"settingchanged"])
   {
      
   }
   //[SaveTestTaste setTitle:@"Test sichern"];
   [SaveTestTaste setEnabled:YES];
   dirty=YES;
   
}

- (void)clearSettings
{
   //NSLog(@"clearSettings");
   [ReihenSettings clearSettings];
   [AddSubSettings clearSettings];
   
}



-(IBAction)closeDrawer:(id)sender
{
   {
      //NSLog(@"closeDrawer");
      [SettingsDrawer close:NULL];
      [SettingsPfeil setState:NO];
      [EingabeFeld setStringValue:@""];
      [EingabeFeld setEnabled:NO];
      [AnzahlPopTaste setEnabled:NO];
      [ZeitPopTaste setEnabled:NO];
      [SaveTestTaste setKeyEquivalent:@""];
      [SaveTestTaste setTitle:@"Neuer Test"];
      [SaveTestTaste setEnabled:YES];
      [forAllCheckbox setEnabled:NO];
      [aktivCheckbox setEnabled:NO];
      [SchliessenTaste setEnabled:YES];
      [SchliessenTaste setKeyEquivalent:@"/r"];
      [TestTable deselectAll:NULL];
      busy=NO;
      TestChanged=NO;
      dirty=NO;
      [self clearSettings];
   }
   
}

-(IBAction)openDrawer:(id)sender
{
   NSLog(@"openTestDrawer");
   //if (OK)
   {
      if (SerieDatenDic)
      {
         NSLog(@"openDrawer: 1");
         NSLog(@"openDrawer: SerieDatenDic: %@",[SerieDatenDic description]);
         //	[self setSettingsMitDic:SerieDatenDic];
      }
      NSLog(@"openDrawer: 2");
      //	[AblaufzeitTimer invalidate];
      [SettingsDrawer open:NULL];
      NSLog(@"openDrawer: 3");
      //[SettingsPfeil setState:YES];
      //	[AblaufzeitTimer invalidate];
      
      //	[closeDrawerTaste setHidden:(!(sender==NULL))];
      //	[DrawerSchliessenTaste setHidden:(!(sender==NULL))];
      //[SettingsDrawer toggle:sender];
      //				[self startTimeout];
      NSLog(@"openDrawer  SettingsDrawer is opening");
      [AnzahlPopTaste  setEnabled:YES];
      [ZeitPopTaste  setEnabled:YES];
      //	[closeDrawerTaste setKeyEquivalent:@"\r"];
      //	[[self window]makeFirstResponder:SettingAlsTestSichernTaste];
      //	NSLog(@"openDrawer  vor setSettings");
      
      //	[SerieDatenDic setObject:@"Training" forKey:@"testname"];
      
   }//if OK
   //	NSLog(@"openDrawer  end");
}

- (void)selectSettingsTab:(int)derTab
{
   [SettingsBox selectTabViewItemAtIndex:derTab];
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

- (void)setSettingsMitDic:(NSDictionary*)derSettingDic
{
   //Multiplikation
   [ReihenSettings setSettingsMit:derSettingDic];
   [AddSubSettings setSettingsMit:derSettingDic];
}

- (NSDictionary*)SerieDatenDic
{
   NSLog(@"Function SerieDatenDic: %@",[SerieDatenDic description]);
   return SerieDatenDic;
}






- (NSDictionary*)SettingStatus
{
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
   BOOL SeriedatenOK=YES;
   NSDictionary* tempStatusDic=[self StatusVonSerieDatenDic:derSerieDatenDic];
   //NSLog(@"checkSerieDatenDic complete: %d",[[tempStatusDic objectForKey:@"complete"]intValue]);
   //NSLog(@"checkSerieDatenDic complete: %@",[tempStatusDic description]);
   
   if 	(derTestName&&[derTestName length])
   {
      
   }
   else//Kein Testname
   {
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      NSString* t0=NSLocalizedString(@"Settings for this test are incorrect",@"Einstellungen für diesen Test sind nicht korrekt");
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


#pragma mark -
#pragma mark TestTable delegate:

/*
 - (void)EingabeChangeNotificationAktion:(NSNotification*)note
 {
	//NSLog(@"TestPanel NSTextDidChangeNotification");
	if ([note object]==EingabeFeld)
 {
 //NSLog(@"TestPanel: EingabeFeld");
 [EinsetzenTaste setEnabled:YES];
 [SaveTestTaste setEnabled:YES];
 }
	//[SchliessenTaste setTitle:NSLocalizedString(@"Save Test",@"Test sichern")];
 }
 */
- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
{
   //NSLog(@"controlTextDidBeginEditing: %@",[[aNotification  userInfo]objectForKey:@"NSFieldEditor"]);
   [TestTable deselectAll:NULL];
   //	[SchliessenTaste setTitle:NSLocalizedString(@"Save Test",@"Test sichern")];
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:@"namenschreiben" forKey:@"namenschreiben"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   //NSLog(@"controlTextDidBeginEditing:vor Post");
   //	[nc postNotificationName:@"TestBearbeiten" object:self userInfo:NotificationDic];
   //NSLog(@"controlTextDidBeginEditing: Nach Post");
   [AnzahlPopTaste setEnabled:YES];
   [ZeitPopTaste setEnabled:YES];
   [forAllCheckbox setEnabled:YES];
   [aktivCheckbox setEnabled:YES];
   [SaveTestTaste setEnabled:YES];
   //	[SaveTestTaste setKeyEquivalent:@"\r"];
   //	[[self window]makeFirstResponder:SaveTestTaste];
   [SchliessenTaste setKeyEquivalent:@""];
   TestChanged=YES;
   dirty=YES;
   //	[SaveTestTaste setKeyEquivalent:@"\r"];
   
   //[EinsetzenTaste setEnabled:YES];
   
   //	if ([[EingabeFeld stringValue]length])
   {
      //		[SchliessenTaste setTitle:NSLocalizedString(@"Save Test",@"Test sichern")];
      //		[SaveTestTaste setEnabled:YES];
      dirty=YES;
      //[UbernehmenTaste setEnabled:YES];
      //[UbernehmenTaste setKeyEquivalent:@"\r"];
      //[EntfernenTaste setEnabled:NO];
      //[BearbeitenTaste setEnabled:NO];
      //[NameInListeTaste setEnabled:YES];
      //Settings öffnen
      //		NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      //		[NotificationDic setObject:@"namenschreiben" forKey:@"namenschreiben"];
      //		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      //		[nc postNotificationName:@"TestBearbeiten" object:self userInfo:NotificationDic];
      
   }
   /*
    else
    {
    //[SchliessenTaste setTitle:NSLocalizedString(@"Close",@"Schliessen")];
    
    //[UbernehmenTaste setEnabled:NO];
    //[UbernehmenTaste setKeyEquivalent:@""];
    dirty=NO;
    }
    */
   
}
#pragma mark -
#pragma mark TestTable Data Source:

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
   return [TestDicArray count];
   
}


- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
            row:(int)rowIndex
{
   
   //NSLog(@"objectValueForTableColumn: %@ row: %d",[aTableColumn identifier],rowIndex);
   NSDictionary *einTestDic;
   if (rowIndex<[TestDicArray count])
   {
      einTestDic =[TestDicArray objectAtIndex: rowIndex];
      //if (einTestDic)
      {
         return [einTestDic objectForKey:[aTableColumn identifier]];
      }
   }
   else
   {
      return NULL;
   }
   //NSLog(@"einTestDic: aktiv: %d   Testname: %@",[[einTestDic objectForKey:@"aktiv"]intValue],[einTestDic objectForKey:@"testname"]);
   
   
   
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
              row:(int)rowIndex
{
   //NSLog(@"setObjectValueForTableColumn rowIndex: %d	[TestDicArray count]: %d",rowIndex,[TestDicArray count]);
   
   NSMutableDictionary* einTestDic;
   if (rowIndex<[TestDicArray count])
   {
      einTestDic=(NSMutableDictionary*)[TestDicArray objectAtIndex:rowIndex];
      
      //		//NSLog(@"einTestDic: %@	aTableColumn identifier:%@",[einTestDic description],[aTableColumn identifier]);
      [einTestDic setObject:anObject forKey:[aTableColumn identifier]];
      
      if ([[aTableColumn identifier]isEqualToString:@"aktiv"])
      {
         //			int tempAktivStatus=[[einTestDic objectForKey:@"aktiv"]intValue];
         //NSLog(@"setObjectValueForTableColumn  rowIndex: %d	aktiv: %d",rowIndex,tempAktivStatus);
         
         
         
      }//if ok
      
      if ([[aTableColumn identifier]isEqualToString:@"alle"])
      {
         //			int tempUserStatus=[[einTestDic objectForKey:@"alle"]intValue];
         //NSLog(@"setObjectValueForTableColumn  rowIndex: %d	alle: %d",rowIndex,tempUserStatus);
         
         /*			
          if ([einTestDic objectForKey:@"testname"])
          {
          
          NSString* tempTestName=[einTestDic objectForKey:@"testname"];
          //NSLog(@"setObjectValue:		tempTestName:%@",tempTestName);
          
          if ([tempTestName length])
          {
          
          
          if (tempUserStatus)
          {
          
          //						[self setTestForAll:tempTestName];
          //						NSLog(@"setObjectValue nach setTestForAll");
          
          }
          else
          {
          //						[self clearTestForAll:tempTestName];
          }
          
          }//if length
          
          }//if name
          */			
         
         
         
      }
      //NSLog(@"einTestDic nach set: %@",[einTestDic description]);
   }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row
{
   //NSLog(@"shouldSelectRow");
   
   //NSString* tempTestNamenString=[[TestDicArray objectAtIndex:row]objectForKey:@"testname"];
   //[DeleteTaste setEnabled:YES];
   if (!busy)
   {
      [SchliessenTaste setTitle:NSLocalizedString(@"Close",@"Schliessen")];
      [UpDownTaste setIntValue:row];
      NSLog(@"UpDown: Pos: %d",[UpDownTaste intValue]);
      [SaveTestTaste setEnabled:YES];
      
      if ([[[TestDicArray objectAtIndex:row]objectForKey:@"neuername"]boolValue])
      {
         //[NameAusListeTaste setEnabled:YES];
      }
      else
      {
         //   [NameAusListeTaste setEnabled:NO];
         
      }
   }
   
   return !busy;
}


- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
   
   //NSLog(@"ProjektListe willDisplayCell Zeile: %d, numberOfSelectedRows:%d", row ,[tableView numberOfSelectedRows]);
   //	NSLog(@"ProjektListe willDisplayCell Zeile: %d tableColumn identifier:%@ ",row,[tableColumn identifier]);
   
   if ([[tableColumn identifier]isEqualToString:@"alle"])
   {
      if ([[TestDicArray objectAtIndex:row]objectForKey:@"aktiv"])
      {
         BOOL aktivOK=[[[TestDicArray objectAtIndex:row]objectForKey:@"aktiv"]boolValue];
         [cell setEnabled:aktivOK];
         
      }
      else
      {
         [cell setEnabled:NO];
      }
   }//if alle
   
}//willDisplayCell



- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
   NSLog(@"TestListe tableViewSelectionDidChange");
   if ([TestTable numberOfSelectedRows]==0)
   {
      [DeleteTaste setEnabled:NO];
      [BearbeitenTaste setEnabled:NO];
      [TestForAllTaste setEnabled:NO];
      [TestForNoneTaste setEnabled:NO];
      //[OKKnopf setKeyEquivalent:@""];
      //[HomeKnopf setKeyEquivalent:@"\r"];
   }
   else
   {
      [DeleteTaste setEnabled:YES];
      [BearbeitenTaste setEnabled:YES];
      [TestForAllTaste setEnabled:YES];
      [TestForNoneTaste setEnabled:YES];
   }
   //NSLog(@"ProjektListe tableViewSelectionDidChange ende");
   
}


- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
   NSLog(@"TestTabFeld aktuelles TabViewItem: %@",[[TestTabFeld selectedTabViewItem] label]);
   NSLog(@"TestTabFeld willSelectTabViewItem: %@",[tabViewItem label]);
   
   //		Bisheriges Item abschliessen
   switch ([[[TestTabFeld selectedTabViewItem] identifier]intValue])
   {
      case 1://Testliste
      {
         [self saveTest];
         
         [TestTable deselectAll:NULL];
         [TestZuNamenTable deselectAll:NULL];
         [NamenZuTestTable deselectAll:NULL];
         [TestForAllTaste setEnabled:NO];
         [TestForNoneTaste setEnabled:NO];
         [NamenWahlTaste selectItemAtIndex:0];
         [TestWahlTaste selectItemAtIndex:0];
         [self setTestZuNamenDSForUser:NULL];
         [self setNamenZuTestDSForTest:NULL];
         [self setTestWahlTasteMitTest:NULL];
         [self setNamenWahlTasteMitNamen:NULL];
      }break;
         
      case 2://TestZuNamen
      {
         //ist ein Name aktiviert?
         
         if ([TestZuNamenTable selectedRow]>=0)
         {
            NSString* tempTestName=[[[TestZuNamenDS TestZuNamenDicArray]objectAtIndex:[TestZuNamenTable selectedRow]]objectForKey:@"testname"];
            [TestWahlTaste selectItemWithTitle:tempTestName];
            [self setNamenZuTestDSForTest:tempTestName];
            
         }
         else
         {
            [TestWahlTaste selectItemAtIndex:0];
            [self setNamenZuTestDSForTest:NULL];
         }
         [TestZuNamenTable deselectAll:NULL];
         [self setTestWahlTasteMitTest:NULL];
         [self setNamenWahlTasteMitNamen:NULL];
         
         [NamenWahlTaste selectItemAtIndex:0];
      }break;
         
      case 3://NamenZuTest
      {
         //ist ein Test aktiviert?
         
         if ([NamenZuTestTable selectedRow]>=0)
         {
            NSString* tempUserName=[[[NamenZuTestDS NamenZuTestDicArray]objectAtIndex:[NamenZuTestTable selectedRow]]objectForKey:@"name"];
            [NamenWahlTaste selectItemWithTitle:tempUserName];
            [self setTestZuNamenDSForUser:tempUserName];
            
         }
         else
         {
            [NamenWahlTaste selectItemAtIndex:0];
            [self setTestZuNamenDSForUser:NULL];
         }
         
         [self setTestWahlTasteMitTest:NULL];
         [self setNamenWahlTasteMitNamen:NULL];
         
         
         [TestWahlTaste selectItemAtIndex:0];
         [NamenZuTestTable deselectAll:NULL];
      }break;
         
   }//switch bisher
   
   //		Neues Item
   
   switch ([[tabViewItem identifier]intValue])
   {
      case 1://Testliste
      {
         
      }break;
         
      case 2://TestZuNamen
      {
         [TestZuNamenTable deselectAll:NULL];
         
         //NSLog(@"TestTabFeld willSelectTabViewItem 2:	NamenWahlTaste titleOfSelectedItem:%@",[NamenWahlTaste titleOfSelectedItem]);
         //NSLog(@"TestTabFeld willSelectTabViewItem: %@	aktuellerUser: %@",[tabViewItem identifier],aktuellerUser);
         
         if ([NamenWahlTaste indexOfSelectedItem])//ein User ausgewählt
         {
            //	[[[TestZuNamenTable tableColumnWithIdentifier:@"userok"]dataCell]setEnabled:YES];
            [TestZuNamenTable setEnabled:YES];
            
            [self setTestZuNamenDSForUser:[NamenWahlTaste titleOfSelectedItem]];//Table einrichten fuer User
            //			NSLog(@"willSelectTabView 2 User: %@:", [NamenWahlTaste titleOfSelectedItem]);
         }
         else
         {
            [self setTestZuNamenDSForUser:@""];
            //NSLog(@"willSelectTabView 2: kein User");
            //[TestZuNamenTable setEnabled:NO];
            
            //[[[TestZuNamenTable tableColumnWithIdentifier:@"userok"]dataCell]setEnabled:NO];
            //NSLog(@"willSelectTabView 2: leere Tabelle");
            
         }
         
      }break;
         
      case 3://NamenZuTests
      {
         //NSLog(@"willSelectTabView start");
         [NamenZuTestTable deselectAll:NULL];
         //NSLog(@"willSelectTabView nach deselectAll");
         int selektierteZeile=[TestZuNamenTable selectedRow];
         
         if (selektierteZeile>=0)//eine Zeile ist selektiert
         {
            //      NSMutableDictionary* tempNamenDic= [(NSMutableArray*)[(rTestZuNamenDS*)[TestZuNamenTable dataSource] TestZuNamenDicArray]objectAtIndex:[sender selectedRow]];
            
            NSMutableDictionary* tempTestDic= [(NSMutableArray*)[(rTestZuNamenDS*)[TestZuNamenTable dataSource] TestZuNamenDicArray]objectAtIndex:selektierteZeile];
            
            //NSDictionary* tempTestDic=[[[TestZuNamenTable dataSource]TestZuNamenDicArray]objectAtIndex:selektierteZeile];
            NSString* tempTestName=[tempTestDic objectForKey:@"testname"];
            //				NSLog(@"willSelectTabView:	tempTestDic: %@		tempTestName: %@",[tempTestDic description],tempTestName);
            if (tempTestName)//Test auswaehlen
            {
               //NSLog(@"TestZuNamenTable selektierter Test: %@",tempTestName);
               [self setNamenZuTestDSForTest:tempTestName];
               [TestWahlTaste selectItemWithTitle:tempTestName];
               [TestInAlleEinsetzenTaste setEnabled:YES];
               [TestAusAllenEntfernenTaste setEnabled:YES];
               
            }
            
         }
         else //leere Tabelle anzeigen
         {
            //NSLog(@"willSelectTabView 3: leere Tabelle");
            //	[TestWahlTaste selectItemAtIndex:0];
            [TestInAlleEinsetzenTaste setEnabled:NO];
            [TestAusAllenEntfernenTaste setEnabled:NO];
            //NSLog(@"willSelectTabView 3: nach TestWahlTaste");
            //			[self setNamenZuTestDSForTest:@""];
            //NSLog(@"willSelectTabView 3: leere Tabelle nach setNamenZuTestDSForTest");
            
            
         }
      }break;
   }//switch
}
@end
