#import "rStimmenPanel.h"

@implementation rStimmenPanel
- (id) init
{
   
   self = [super initWithWindowNibName:@"SCStimmenPanel"];
   {
      StimmenTableArray=[[NSMutableArray alloc] initWithCapacity: 0];
      QuittungTableArray=[[NSMutableArray alloc] initWithCapacity: 0];
      NeueStimmeDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      NeueQuittungDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      QuittungSelektionDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      QuittungNamenArrayDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
      
   }
   
   return self;
}

- (void)awakeFromNib
{
   //NSLog(@"StimmenPanel awake: home: %@",NSHomeDirectory());
   //[DokumenteSucher setPath:NSHomeDirectory()];
   [StimmenTableArray removeAllObjects];
   [StimmenTableArray addObject:[NSDictionary dictionaryWithObject:@"home" forKey:@"stimmenname"]];
   [StimmenTable setDelegate:self];
   [StimmenTable setDataSource:self];
   QuittungDS=[[rQuittungDS alloc]init];
   [QuittungTable setDelegate:QuittungDS];
   [QuittungTable setDataSource:QuittungDS];
   
   //	[QuittungDS setQuittungDicArray:NULL];
   
   [QuittungTable reloadData];
   NSDictionary* firstItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
   NSAttributedString* firstItem=[[NSAttributedString alloc]initWithString:NSLocalizedString(@"Choose Name",@"Namen wählen") attributes:firstItemAttr];
   //	[QuittungNamenPopTaste insertItemWithTitle:@"Quittung wählen"atIndex:0];
   [[QuittungNamenPopTaste itemAtIndex:0]setAttributedTitle:firstItem];
   [QuittungOKTaste setEnabled:NO];
   [QuittungPlusMinusTaste setEnabled:NO];
}




- (void)setStimmenTableArrayMitStimmenNamenArray:(NSArray*)derDicArray mitStimme:(NSString*)dieStimme
{
   //NSLog(@"setStimmenTableArrayMitDicArray:	derDicArray: %@",[derDicArray description]);
   [StimmenTableArray removeAllObjects];
   NSDictionary* homeDic=[NSDictionary dictionaryWithObject:@"home" forKey:@"stimmenname"];
   [StimmenTableArray addObject:homeDic];
   if ([derDicArray count])
   {
      NSEnumerator* StimmenEnum=[derDicArray objectEnumerator];
      id einStimmenDic;
      while(einStimmenDic=[StimmenEnum nextObject])
      {
         
         if ([[StimmenTableArray valueForKey:@"stimmenname"]containsObject:[einStimmenDic objectForKey:@"stimmenname"]])//Name schon da
         {
            
         }
         else
         {
            NSMutableDictionary* tempStimmenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [tempStimmenDic setObject:[einStimmenDic objectForKey:@"stimmenname"] forKey:@"stimmenname"];
            
            [StimmenTableArray addObject:tempStimmenDic];
         }
      }//while
      [StimmenTable reloadData];
      
   }
   
   NSUInteger index=[[StimmenTableArray valueForKey:@"stimmenname"]indexOfObject:dieStimme];
   //NSLog(@"stimmenname aktivieren: 	index: %d	Stimmenname: %@",index,[StimmenTableArray valueForKey:@"stimmenname"]);
   if (index<NSNotFound)//Stimme ist in Liste
   {
      [StimmenTable selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
   }
   else
   {
      [StimmenTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
      
   }
   
}

- (void)setQuittungSelektionDic:(NSDictionary*)derQuittungSelektionDic
{
   //NSLog(@"Stimmenpanel derQuittungSelektionDic: :%@",[derQuittungSelektionDic description]);
   //	[QuittungSelektionDic release];
   QuittungSelektionDic=(NSMutableDictionary*)derQuittungSelektionDic;
   
   [QuittungDS setQuittungSelektionDic:derQuittungSelektionDic];
   
   //NSLog(@"setQuittungSelektionDic:	QuittungSelektionDic: %@",[QuittungSelektionDic description]);
   
}


- (void)setQuittungNamenArrayDic:(NSDictionary*)derQuittungNamenArrayDic
{
   QuittungNamenArrayDic=(NSMutableDictionary*)derQuittungNamenArrayDic;
   //NSLog(@"setQuittungNamenArrayDic:	QuittungNamenArrayDic: %@",[QuittungNamenArrayDic description]);
}

- (void)addStimmeZuDicArrayMitDic:(NSDictionary*)derStimmenDic
{
   NSLog(@"addStimmeZuDicArrayMitDic:	derStimmenDic: %@",[derStimmenDic description]);
   if ([derStimmenDic objectForKey:@"stimmename"])
   {
      [StimmenNameFeld setStringValue:[derStimmenDic objectForKey:@"stimmename"]];
   }//if Stimmenarray
   NSLog(@"addStimmeZuDicArrayMitDic:	StimmenTableArray: %@",[StimmenTableArray description]);
   
}


- (IBAction)reportCancel:(id)sender
{
   
   [NSApp stopModalWithCode:0];
   [[self window]orderOut:NULL];
}

- (IBAction)reportClose:(id)sender
{
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   long selektierteZeile=[StimmenTable selectedRow];
   
   //Ausgewählte Stimme an Controller schicken, um neue Zifern-Soundfiles zu laden
   
   NSString* selectedStimme=[[StimmenTableArray objectAtIndex:selektierteZeile]objectForKey:@"stimmenname"];
   //NSLog(@"reportClose: selectedStimme: %@",selectedStimme);
   NSMutableDictionary* ZiffernNotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [ZiffernNotificationDic setObject:selectedStimme forKey:@"stimmenname"];
   [nc postNotificationName:@"Stimme" object:self userInfo:ZiffernNotificationDic];
   
   //Ausgewählte Quittungen an Controller schicken, um neue Quittungen-Soundfiles zu laden
   NSDictionary* selectedQuittungDic=[QuittungDS QuittungSelektionDic];
   //NSLog(@"reportClose:   selectedQuittungDic: %@",[selectedQuittungDic description]);
   NSMutableDictionary* QuittungNotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [QuittungNotificationDic setObject:selectedQuittungDic forKey:@"quittungdic"];
   [nc postNotificationName:@"Quittung" object:self userInfo:QuittungNotificationDic];
   
   [NSApp stopModalWithCode:1];
   [[self window]orderOut:NULL];
   
}

- (NSString*) StimmenName
{
   long selektierteZeile=[StimmenTable selectedRow];
   
   NSString* selectedStimme=[[StimmenTableArray objectAtIndex:selektierteZeile]objectForKey:@"stimmenname"];
   NSLog(@"StimmenName: selektierteZeile: %d	selectedStimme: %@",selektierteZeile, selectedStimme);
   return selectedStimme;
}

- (IBAction)reportQuittungEntfernen:(id)sender
{
   NSString* deleteStimme=[self StimmenName];
   NSAlert *Warnung = [[NSAlert alloc] init];
   [Warnung addButtonWithTitle:@"Stimme entfernen"];
   [Warnung addButtonWithTitle:@"Abbrechen"];
   [Warnung addButtonWithTitle:@""];
   [Warnung addButtonWithTitle:@"Abbrechen"];
   NSString* MessageString=@"Stimme entfernen?";
   [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
   
   NSString* s1=@"Soll die Stimme: ";
   NSString* s2=@"wirklich entfernt werden?";
   NSString* InformationString=[NSString stringWithFormat:@"%@ %@\n%@",s1,deleteStimme,s2];
   [Warnung setInformativeText:InformationString];
   [Warnung setAlertStyle:NSAlertStyleWarning];
   
   //[Warnung setIcon:RPImage];
   long antwort=[Warnung runModal];
   
   switch (antwort)
   {
      case NSAlertFirstButtonReturn://	1000
      {
         NSLog(@"NSAlertFirstButtonReturn: Entfernen");
         BOOL deleteOK=[self deleteStimme:[self StimmenName]];
      }break;
         
      case NSAlertSecondButtonReturn://1001
      {
         NSLog(@"NSAlertSecondButtonReturn: Cancel");
         
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

- (IBAction)reportStimmeEntfernen:(id)sender
{
   NSString* deleteStimme=[self StimmenName];
   NSAlert *Warnung = [[NSAlert alloc] init];
   [Warnung addButtonWithTitle:@"Stimme entfernen"];
   [Warnung addButtonWithTitle:@"Abbrechen"];
   [Warnung addButtonWithTitle:@""];
   [Warnung addButtonWithTitle:@"Abbrechen"];
   NSString* MessageString=@"Stimme entfernen?";
   [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
   
   NSString* s1=@"Soll die Stimme: ";
   NSString* s2=@"wirklich entfernt werden?";
   NSString* InformationString=[NSString stringWithFormat:@"%@ %@\n%@",s1,deleteStimme,s2];
   [Warnung setInformativeText:InformationString];
   [Warnung setAlertStyle:NSAlertStyleWarning];
   
   //[Warnung setIcon:RPImage];
   long antwort=[Warnung runModal];
   
   switch (antwort)
	  {
        case NSAlertFirstButtonReturn://	1000
        {
           NSLog(@"NSAlertFirstButtonReturn: Entfernen");
           BOOL deleteOK=[self deleteStimme:[self StimmenName]];
        }break;
           
        case NSAlertSecondButtonReturn://1001
        {
           NSLog(@"NSAlertSecondButtonReturn: Cancel");
           
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

- (IBAction)reportQuittungPlusMinus:(id)sender
{
   NSLog(@"reportQuittungPlusMinus: tag: %ld",(long)[sender selectedSegment]);
   switch ([sender selectedSegment])
   {
      case 0: //Quittung importieren
      {
         
         [self reportQuittungImportieren:NULL];
      }break;
      case 1://Quittung entfernen
      {
         [self reportQuittungEntfernen:NULL];
      }break;
   }//switch
   
}

- (IBAction)reportQuittungImportieren:(id)sender
{
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   NSMutableArray* tempQuittungArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   [QuittungPlusMinusTaste setEnabled:NO];
   NSOpenPanel * QuittungOpenPanel=[NSOpenPanel openPanel];
   
   [QuittungOpenPanel setCanChooseDirectories:NO];
   [QuittungOpenPanel setCanChooseFiles:YES];
   [QuittungOpenPanel setAllowsMultipleSelection:NO];
   NSString* s1=NSLocalizedString(@"Where is the sound file of the tone?",@"Sndfile fuer Quittung");
   NSString* s2=NSLocalizedString(@"\nThe file must be in AIFF format,",@"File als AIFF");
   NSString* s3=NSLocalizedString(@" and it must have the suffix .aif.",@"Suffix .aif");
   //[QuittungOpenPanel setMessage:s1];
   [QuittungOpenPanel setTitle:@"Neue Soundfiles laden"];
   NSTextField* QuittungOpenFeld=[[NSTextField alloc]initWithFrame:NSMakeRect(0,0,500,80)];
   [QuittungOpenFeld setStringValue:[NSString stringWithFormat:@"%@\n%@%@",s1,s2,s3]];
   [QuittungOpenPanel setAccessoryView:QuittungOpenFeld];
   
   /*
    [QuittungOpenPanel beginSheetForDirectory:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
    file:NULL types:NULL
    modalForWindow:[self window]
    modalDelegate:self
    didEndSelector:@selector(QuittungOpenPanelDidEnd:returnCode:contextInfo:)
    contextInfo:NULL];
    */
   
   [QuittungOpenPanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result)
    {
       if (result == NSModalResponseOK)
       {
          
       }
    } ];
   /*
    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
    file:NULL types:NULL
    modalForWindow:[self window]
    modalDelegate:self
    didEndSelector:@selector(QuittungOpenPanelDidEnd:returnCode:contextInfo:)
    contextInfo:NULL];
    */
   //Antwort bearbeiten in 'QuittungOpenPanelDidEnd'
}

- (IBAction)reportQuittungOK:(id)sender
{
   if ([[QuittungTableArray valueForKey:@"quittungname"]containsObject:[QuittungNameFeld stringValue]])//Name schon da
   {
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      //[Warnung addButtonWithTitle:@""];
      //[Warnung addButtonWithTitle:@""];
      //[Warnung addButtonWithTitle:@"Abbrechen"];
      NSString* MessageString=@"Name schon vorhanden";
      [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
      
      NSString* s1=@"Der Name: ";
      NSString* s2=@"ist schon vorhanden.";
      NSString* InformationString=[NSString stringWithFormat:@"%@ %@\n%@",s1,[QuittungNameFeld stringValue],s2];
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSAlertStyleWarning];
      
      //[Warnung setIcon:RPImage];
      long antwort=[Warnung runModal];
      
      switch (antwort)
      {
         case NSAlertFirstButtonReturn://	1000
         {
            NSLog(@"NSAlertFirstButtonReturn");
            [[self window]makeFirstResponder:StimmenTable];
            [QuittungPlusMinusTaste setEnabled:YES];
            
            return;
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
   else
   {
      //Quittung im Table anzeigen
      NSMutableDictionary* tempQuittungDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [tempQuittungDic setObject:[QuittungNameFeld stringValue] forKey:@"quittungname"];
      [tempQuittungDic setObject:QuittungNamenPopTaste forKey:@"klassename"];
      
      [QuittungDS addQuittungDic:tempQuittungDic];
      [QuittungTable reloadData];
      
      //Quittung zu Resourcen hinzufügen
      NSDictionary* copyFehlerDic=[self copyQuittungToResources];
      NSLog(@"reportQuittungOK: copyFehlerDic: %@",[copyFehlerDic description]);
      
      /*
       //Neue Quittung zu PList hinzufügen
       NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
       //		[NotificationDic setObject:QuittungTableArray forKey:@"klangtablearray"];
       [NotificationDic setObject:[QuittungNameFeld stringValue] forKey:@"neuequittungname"];
       [NotificationDic setObject:[QuittungNamenPopTaste titleOfSelectedItem] forKey:@"klassename"];
       NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
       //		nicht geschickt	[nc postNotificationName:@"neueQuittung" object:self userInfo:NotificationDic];
       */
      [QuittungNameFeld setStringValue:@""];
      //Taste 'Stimme uebernehmen' desablen
      [QuittungOKTaste setEnabled:NO];
      
      [[self window]makeFirstResponder:QuittungTable];
      [QuittungPlusMinusTaste setEnabled:YES];
   }
}

- (IBAction)reportQuittungKlasse:(id)sender
{
   //NSLog(@"reportQuittungKlasse:  %@",[sender titleOfSelectedItem]);
   NSArray* tempKlasseTeile=[[[sender titleOfSelectedItem] lowercaseString] componentsSeparatedByString:@" "];
   NSString* modKlasse=[tempKlasseTeile objectAtIndex:0];
   if ([tempKlasseTeile count]==2)//Zwei Worte
   {
      modKlasse=[modKlasse stringByAppendingString:[tempKlasseTeile objectAtIndex:1]];
   }
   //NSLog(@"modKlasse: %@",modKlasse);
   
   //vorhandene QuittungsNamen zur Klasse
   NSArray* tempQuittungenNamenArray=[QuittungNamenArrayDic objectForKey:modKlasse];
   NSMutableArray* tempQuittungDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   if (tempQuittungenNamenArray&&[tempQuittungenNamenArray count])//es hat Namen fuer dier Klasse
   {
      //NSLog(@"reportQuittungKlasse: tempQuittungenNamenArray: %@",[tempQuittungenNamenArray description]);
      NSEnumerator* QuittungEnum=[tempQuittungenNamenArray objectEnumerator];
      id einQuittungName;
      while (einQuittungName=[QuittungEnum nextObject])
      {
         NSMutableDictionary* tempQuittungNameDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempQuittungNameDic setObject:modKlasse forKey:@"quittungklasse"];
         [tempQuittungNameDic setObject:einQuittungName forKey:@"quittungname"];
         
         [tempQuittungDicArray addObject:tempQuittungNameDic];
      }//while
      
   }
   
   [QuittungDS setQuittungDicArray:tempQuittungDicArray];
   [QuittungTable reloadData];
   
   NSString* tempselectedQuittung=[[QuittungDS QuittungSelektionDic] objectForKey:modKlasse];
   
   NSUInteger index=[[[QuittungDS QuittungDicArray] valueForKey:@"quittungname"]indexOfObject:tempselectedQuittung];
   //NSLog(@"Quittungen: %@	index: %d",[[[QuittungDS QuittungDicArray] valueForKey:@"quittungname"]description],index);
   if (index<NSNotFound)
   {
      [QuittungTable selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
   }
   else
   {
      [QuittungTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
   }
   [QuittungPlusMinusTaste setEnabled:YES];
}

- (void)StimmeOpenPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
   
   NSLog(@"ZahlenOpenPanel openPanelDidEnd: returnCode: %d",returnCode);
   
   switch (returnCode)
   {
      case NSModalResponseOK:
      {
         NSLog(@"Open: OK");
         NSFileManager* Filemanager=[NSFileManager defaultManager];
         NSMutableArray* tempZahlenArray=[[NSMutableArray alloc]initWithCapacity:0];
         NSArray* tempZiffernArray;
         NSString* tempStimmenPfad;
         
         tempStimmenPfad=[[panel URL]path]; //Pfad des Ordners mit den Stimmen
         tempZahlenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempStimmenPfad error:NULL];
         NSLog(@"openPanelDidEnd: Pfad: %@: tempZahlenArray: %@",tempStimmenPfad,[tempZahlenArray description]);
         [tempZahlenArray removeObject:@".DS_Store"];
         
         //Stimmenarray auf Vollständigkeit prüfen
         BOOL StimmenArrayOK=[self checkStimmenArray:tempZahlenArray mitStimmenName:[tempStimmenPfad lastPathComponent]];
         NSLog(@"openPanelDidEnd:	StimmenArrayOK: %d",StimmenArrayOK);
         if (StimmenArrayOK)
         {
            [NeueStimmeDic setObject:tempZahlenArray forKey:@"stimmenarray"];
            [NeueStimmeDic setObject:[tempStimmenPfad lastPathComponent] forKey:@"stimmenname"];
            [NeueStimmeDic setObject:tempStimmenPfad forKey:@"stimmenordnerpfad"];
            
            //Vorschlab fuer Stimmenname einsetzen: Name des importiertenOrdners
            [StimmenNameFeld setStringValue:[tempStimmenPfad lastPathComponent]];
            [StimmenNameFeld selectText:NULL];
            //Taste 'Stimme uebernehmen' enablen
            [StimmeOKTaste setEnabled:YES];
            
            [[self window]makeFirstResponder:StimmenNameFeld];
            
            
         }
         else
         {
            
         }
         
      }break;
         
      case NSModalResponseCancel:
      {
         NSLog(@"ZahlenOpenPanel: Cancel");
         [[self window]makeFirstResponder:StimmenTable];
         [StimmePlusMinusTaste setEnabled:YES];
         
         
      }break;
   }//switch
   
}

- (void)QuittungOpenPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
   
   NSLog(@"QuittungOpenPanel QuittungOpenPanelDidEnd: returnCode: %d",returnCode);
   
   switch (returnCode)
   {
      case NSModalResponseOK:
      {
         NSLog(@"Quittung Open: OK");
         NSFileManager* Filemanager=[NSFileManager defaultManager];
         NSMutableArray* tempZahlenArray=[[NSMutableArray alloc]initWithCapacity:0];
         
         NSString* tempQuittungPfad;
         
         tempQuittungPfad=[[panel URL]path]; //Pfad des Ordners mit den Stimmen
         //NSLog(@"QuittungOpenPanel: Pfad: %@: tempZahlenArray: %@",tempQuittungPfad,[tempZahlenArray description]);
         
         //NSLog(@"QuittungOpenPanel:	tempQuittungPfad: %@",tempQuittungPfad);
         if ([[tempQuittungPfad pathExtension]isEqualToString:@"aif"])
         {
            NSString* tempQuittungName=[[tempQuittungPfad lastPathComponent]stringByDeletingPathExtension];
            [NeueQuittungDic setObject:tempQuittungName forKey:@"quittungname"];
            [NeueQuittungDic setObject:tempQuittungPfad forKey:@"klangpfad"];
            [NeueQuittungDic setObject:[[QuittungNamenPopTaste titleOfSelectedItem]lowercaseString] forKey:@"klangklasse"];
            
            NSLog(@"NeueQuittungDic:  %@",[NeueQuittungDic description]);
            //Vorschlag fuer Stimmenname einsetzen: Name des importiertenOrdners
            
            [QuittungNameFeld setStringValue: tempQuittungName];
            [QuittungNameFeld selectText:NULL];
            //Taste 'Quittung uebernehmen' enablen
            [QuittungOKTaste setEnabled:YES];
            
            [[self window]makeFirstResponder:QuittungNameFeld];
            
            
         }
         else
         {
            
         }
         
      }break;
         
      case NSModalResponseCancel:
      {
         NSLog(@"QuittungOpenPanel: Cancel");
         
         [[self window]makeFirstResponder:StimmenTable];
         [StimmePlusMinusTaste setEnabled:YES];
         [QuittungPlusMinusTaste setEnabled:YES];
         
      }break;
   }//switch
   
}









- (BOOL)checkStimmenArray:(NSArray*)derStimmenArray mitStimmenName:(NSString*)derStimmenName
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL StimmenArrayOK=YES;
   NSMutableDictionary* tempDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   //Zahlen.plist lesen: Liste der benötigten Ziffern
   NSDictionary* tempZahlenPListDic;
   
   NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources"];
   NSString* ZahlenPlistPfad=[ResourcenPfad stringByAppendingPathComponent:@"Zahlen.plist"];
   if ([Filemanager fileExistsAtPath:ZahlenPlistPfad])
   {
      tempZahlenPListDic=[[NSDictionary dictionaryWithContentsOfFile:ZahlenPlistPfad]mutableCopy];
      //NSLog(@"tempZiffernDic: %@",[tempZiffernDic description]);
   }
   
   NSArray* PListZiffernNamenArray=[tempZahlenPListDic allKeys];//Alle notwendigen Ziffernnamen
   NSMutableArray* fehlendeZiffernArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* bereinigterZiffernArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   //	NSLog(@"PListZiffernNamenArray: %@",[PListZiffernNamenArray description]);
   
   //Vollständigkeit prüfen
   NSEnumerator* PListEnum=[PListZiffernNamenArray objectEnumerator];
   id eineZiffer;
   while (eineZiffer =[PListEnum nextObject])
   {
      if ([derStimmenArray containsObject:[eineZiffer stringByAppendingPathExtension:@"aif"]])//File mit Name ist da
      {
         [bereinigterZiffernArray  addObject:eineZiffer];
      }
      else
      {
         [fehlendeZiffernArray addObject:eineZiffer];
      }
   }//while
   
   
   NSLog(@"bereinigterZiffernArray: %@",[bereinigterZiffernArray description]);
   NSLog(@"fehlendeZiffernArray: %@",[fehlendeZiffernArray description]);
   if ([bereinigterZiffernArray count]==0)
   {
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"Zurück"];
      [Warnung setMessageText:[NSString stringWithFormat:@"Im ausgewählten Ordner hat es keine passenden Dateien"]];
      
      //	NSString* s1=@"Er kann in den Papierkorb oder in den Ordner 'Magazin' in der Lesebox verschoben werden.";
      //	NSString* s2=@"Er kann auch sofort entfernt werden. Diese Aktion ist aber nicht rückgängig zu machen.";
      //	NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
      //	[Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSAlertStyleWarning];
      long antwort=[Warnung runModal];
      return NO;
   }
   if ([fehlendeZiffernArray count])
   {
      long fehlendeZiffern=[fehlendeZiffernArray count];
      NSString* Fehler=[fehlendeZiffernArray componentsJoinedByString:@", "];
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"Zurück"];
      [Warnung addButtonWithTitle:@"Liste drucken"];
      
      [Warnung setMessageText:[NSString stringWithFormat:@"Im ausgewählten Ordner fehlen die Dateien für die Ziffern: \n%@",Fehler]];
      
      //	NSString* s1=@"Er kann in den Papierkorb oder in den Ordner 'Magazin' in der Lesebox verschoben werden.";
      //	NSString* s2=@"Er kann auch sofort entfernt werden. Diese Aktion ist aber nicht rückgängig zu machen.";
      //	NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
      //	[Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      long antwort=[Warnung runModal];
      if (antwort==NSAlertSecondButtonReturn)
      {
         
         NSTextView* FehlendeZiffernView=[[NSTextView alloc]initWithFrame:NSMakeRect(10,10,600,600)];
         NSString* T=[NSString stringWithFormat:@"%@ %@\n",@"Import von Ziffern mit Stimme: ",derStimmenName];
         NSString* t=@"Fehlende Ziffern:\n";
         NSString* s=[fehlendeZiffernArray componentsJoinedByString:@"\n"];
         [FehlendeZiffernView setString:[NSString stringWithFormat:@"%@\n%@\n%@",T,t,s]];
         [FehlendeZiffernView print:NULL];
         
      }
      return NO;
   }
   
   return YES;
}

- (NSDictionary*)copyZiffernToResources
{
   //Ziffern in der Form <stimmenname>_<ziffer>.aif in die Resource kopieren
   NSLog(@"copyZiffernToResources:	NeueStimmeDic: %@",[NeueStimmeDic description]);
   NSMutableDictionary* copyFehlerDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   //Pfad der neuen Soundfiles:
   NSString* NeueStimmeOrdnerPfad=[NeueStimmeDic objectForKey:@"stimmenordnerpfad"];
   NSString* StimmenName=[NeueStimmeDic objectForKey:@"stimmenname"];
   NSArray* tempZiffernArray=[NeueStimmeDic objectForKey:@"stimmenarray"];
   //Pfad der Resourcen im Projekt:
   NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources"];
   //Soundfiles in Resourcenordner kopieren
   NSLog(@"NeueStimmeOrdnerPfad: %@	ResourcenPfad: %@",NeueStimmeOrdnerPfad,ResourcenPfad);
   
   //Erster Teil des ZiffernNamens:
   NSString* StimmenNameTeil=[[StimmenNameFeld stringValue] stringByAppendingString:@"_"];
   NSMutableArray* copyFehlerArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSEnumerator* ZiffernEnum=[tempZiffernArray objectEnumerator];
   id eineZiffer;
   while (eineZiffer=[ZiffernEnum nextObject])
   {
      NSString* SourcePfad=[NeueStimmeOrdnerPfad stringByAppendingPathComponent:eineZiffer];
      NSString* tempZiffernName=[StimmenNameTeil stringByAppendingString:eineZiffer];
      NSString* DestPfad=[ResourcenPfad stringByAppendingPathComponent:tempZiffernName];
      
      //		Test
      //		NSString* TestOrdnerPfad=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SndCalcTest"];
      //		NSString* DestPfad=[TestOrdnerPfad stringByAppendingPathComponent:tempZiffernName];
      //		ende Test
      
      //	NSLog(@"SourcePfad: %@  \nDestPfad: %@",SourcePfad,DestPfad);
      //NSLog(@"\nDestPfad: %@",DestPfad);
      BOOL copyOK=[Filemanager copyItemAtPath:SourcePfad toPath:DestPfad error:NULL];
      if (copyOK==0)//Fehler beim Kopieren
      {
         [copyFehlerArray addObject:tempZiffernName];
      }
      //NSLog(@"tempZiffernName: %@  copyOK: %d",tempZiffernName,copyOK);
   }//while
   
   [copyFehlerDic setObject:copyFehlerArray forKey:@"copyfehlerarray"];
   [copyFehlerDic setObject:StimmenName  forKey:@"stimmenname"];
   NSLog(@"copyZiffernToResource: copyFehlerDic: %@",[copyFehlerDic description]);
   return copyFehlerDic;
}

- (NSDictionary*)copyQuittungToResources
{
   //Quittung in der Form <klangnname>_<klang>.aif in die Resource kopieren
   NSLog(@"copyQuittungToResources:	NeueQuittungDic: %@",[NeueQuittungDic description]);
   NSMutableDictionary* copyFehlerDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   //Pfad der neuen Soundfiles:
   NSString* NeueQuittungPfad=[NeueQuittungDic objectForKey:@"klangpfad"];
   NSString* QuittungName=[NeueQuittungDic objectForKey:@"quittungname"];
   NSString* QuittungKlasse=[[NeueQuittungDic objectForKey:@"klangklasse"]stringByAppendingPathExtension:@"aif"];
   //Pfad der Resourcen im Projekt:
   NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources"];
   //Soundfiles in Resourcenordner kopieren
   //NSLog(@"NeueQuittungPfad: %@	ResourcenPfad: %@",NeueQuittungPfad,ResourcenPfad);
   
   //Erster Teil des QuittungNamens:
   NSString* QuittungNameTeil=[QuittungName stringByAppendingString:@"_"];
   
   NSString* SourcePfad=NeueQuittungPfad;
   NSString* tempQuittungName=[QuittungNameTeil stringByAppendingString:QuittungKlasse];
   NSString* DestPfad=[ResourcenPfad stringByAppendingPathComponent:tempQuittungName];
   
   //		Test
   //		NSString* TestOrdnerPfad=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SndCalcTest"];
   //		NSString* DestPfad=[TestOrdnerPfad stringByAppendingPathComponent:tempZiffernName];
   //		ende Test
   
   NSLog(@"SourcePfad: %@  \nDestPfad: %@",SourcePfad,DestPfad);
   //NSLog(@"\nDestPfad: %@",DestPfad);
   
   BOOL copyOK=1;//		[Filemanager copyPath:SourcePfad toPath:DestPfad handler:NULL];
   
   //NSLog(@"tempZiffernName: %@  copyOK: %d",tempZiffernName,copyOK);
   
   [copyFehlerDic setObject:[NSNumber numberWithBool:copyOK] forKey:@"copyfehler"];
   [copyFehlerDic setObject:QuittungName  forKey:@"quittungname"];
   [copyFehlerDic setObject:QuittungKlasse  forKey:@"klangklasse"];
   NSLog(@"copyQuittungToResource: copyFehlerDic: %@",[copyFehlerDic description]);
   return copyFehlerDic;
}

- (BOOL)deleteStimme:(NSString*)derStimmenName
{
   NSMutableDictionary* deleteFehlerDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL removeOK=YES;
   //Pfad der Resourcen im Projekt:
   NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources"];
   NSArray* tempZiffernArray=[Filemanager contentsOfDirectoryAtPath:ResourcenPfad error:NULL];
   
   
   //Fuer Test:
   //	NSString* TestOrdnerPfad=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SndCalcTest"];
   //	NSArray* tempZiffernArray=[Filemanager directoryContentsAtPath:TestOrdnerPfad];
   
   //Array fuer Fehler
   NSMutableArray* removeFehlerArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   
   NSEnumerator* ZiffernEnum=[tempZiffernArray objectEnumerator];
   id eineZiffer;
   while (eineZiffer=[ZiffernEnum nextObject])
   {
      if( [[eineZiffer pathExtension]isEqualToString:@"aif"])
      {
         //ZiffernName aufteilen
         NSArray*tempZiffernTeileArray=[eineZiffer componentsSeparatedByString:@"_"];
         //	NSLog(@"eineZiffer: %@	tempZiffernTeileArray: %@",eineZiffer,[tempZiffernTeileArray description]);
         if ([tempZiffernTeileArray count]==2)//nicht defaultStimme 'home'
         {
            NSString* tempZiffernName=[tempZiffernTeileArray objectAtIndex:1];//zweiter Teil des Namens
            NSString* tempStimmenName=[tempZiffernTeileArray objectAtIndex:0];//erster Teil des Namens
            //NSLog(@"tempZiffernName: %@  ",tempZiffernName);
            
            NSString* deletePfadZusatz=[NSString stringWithFormat:@"%@_%@",tempStimmenName,tempZiffernName];
            
            NSString* DestPfad=[ResourcenPfad stringByAppendingPathComponent:deletePfadZusatz];
            
            //Fuer Test
            //		NSString* DestPfad=[TestOrdnerPfad stringByAppendingPathComponent:deletePfadZusatz];
            //	NSLog(@"SourcePfad: %@  \nDestPfad: %@",SourcePfad,DestPfad);
            
            
            //NSLog(@"\nDestPfad: %@	\ntempZiffernName: %@	\nderStimmenName: %@",DestPfad,tempZiffernName,derStimmenName);
            if ([tempStimmenName isEqualToString:derStimmenName])//File gehört zur Stimme
            {
               removeOK=[Filemanager removeItemAtPath:DestPfad error:NULL];
               if (removeOK==0)//Fehler beim Kopieren
               {
                  [removeFehlerArray addObject:eineZiffer];
                  
               }
            }
         }//if count==2
         
      }//if aif
   }//while
   
   //	NSLog(@"deleteStimme: removeFehlerArray: %@",[removeFehlerArray description]);
   if ([removeFehlerArray count]==0)//Entfernen erfolgreich
   {
      NSUInteger deleteIndex=[[StimmenTableArray valueForKey:@"stimmenname"]indexOfObject:[self StimmenName]];
      if (deleteIndex<NSNotFound)
      {
         [StimmenTableArray removeObjectAtIndex:deleteIndex];
         [StimmenTable reloadData];
      }
   }
   return removeOK;
}

- (IBAction)reportStimmeImportieren:(id)sender
{
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   NSMutableArray* tempZahlenArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   [StimmePlusMinusTaste setEnabled:NO];
   NSOpenPanel * ZahlenOpenPanel=[NSOpenPanel openPanel];
   
   [ZahlenOpenPanel setCanChooseDirectories:YES];
   [ZahlenOpenPanel setCanChooseFiles:NO];
   [ZahlenOpenPanel setAllowsMultipleSelection:NO];
   NSString* s1=NSLocalizedString(@"Where is the folder with the sound files of the digits?",@"Sndfiles fuer Ziffern");
   NSString* s2=NSLocalizedString(@"\nThe files must be in AIFF format,",@"Files als AIFF");
   NSString* s3=NSLocalizedString(@" and they must have the suffix .aif.",@"Suffix .aif");
   //[ZahlenOpenPanel setMessage:s1];
   [ZahlenOpenPanel setTitle:@"Neue Soundfiles laden"];
   NSTextField* ZahlenOpenFeld=[[NSTextField alloc]initWithFrame:NSMakeRect(0,0,500,80)];
   [ZahlenOpenFeld setStringValue:[NSString stringWithFormat:@"%@\n%@%@",s1,s2,s3]];
   [ZahlenOpenPanel setAccessoryView:ZahlenOpenFeld];
   
   /*
    [ZahlenOpenPanel beginSheetForDirectory:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
    file:NULL types:NULL
    modalForWindow:[self window]
    modalDelegate:self
    didEndSelector:@selector(StimmeOpenPanelDidEnd:returnCode:contextInfo:)
    contextInfo:NULL];
    */
   [ZahlenOpenPanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result)
    {
       if (result == NSModalResponseOK)
       {
          
       }
    } ];
   
   //Antwort bearbeiten in 'openPanelDidEnd'
}

- (IBAction)reportStimmeOK:(id)sender
{
   if ([[StimmenTableArray valueForKey:@"stimmenname"]containsObject:[StimmenNameFeld stringValue]])//Name schon da
   {
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      //[Warnung addButtonWithTitle:@""];
      //[Warnung addButtonWithTitle:@""];
      //[Warnung addButtonWithTitle:@"Abbrechen"];
      NSString* MessageString=@"Name schon vorhanden";
      [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
      
      NSString* s1=@"Der Name: ";
      NSString* s2=@"ist schon vorhanden.";
      NSString* InformationString=[NSString stringWithFormat:@"%@ %@\n%@",s1,[StimmenNameFeld stringValue],s2];
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSAlertStyleWarning];
      
      //[Warnung setIcon:RPImage];
      long antwort=[Warnung runModal];
      
      switch (antwort)
      {
         case NSAlertFirstButtonReturn://	1000
         {
            NSLog(@"NSAlertFirstButtonReturn");
            [[self window]makeFirstResponder:StimmenTable];
            [StimmePlusMinusTaste setEnabled:YES];
            
            return;
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
   else
   {
      //Stimme im Table anzeigen
      NSMutableDictionary* tempStimmenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [tempStimmenDic setObject:[StimmenNameFeld stringValue] forKey:@"stimmenname"];
      
      [StimmenTableArray addObject:tempStimmenDic];
      [StimmenTable reloadData];
      
      //Stimme zu Resourcen hinzufügen
      NSDictionary* copyFehlerDic=[self copyZiffernToResources];
      NSLog(@"reportStimmeOK: copyFehlerDic: %@",[copyFehlerDic description]);
      
      /*
       //Neue Stimme zu PList hinzufügen
       NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
       [NotificationDic setObject:StimmenTableArray forKey:@"stimmentablearray"];
       [NotificationDic setObject:[StimmenNameFeld stringValue] forKey:@"neuestimme"];
       NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
       //		[nc postNotificationName:@"neueStimme" object:self userInfo:NotificationDic];
       */
      
      [StimmenNameFeld setStringValue:@""];
      //Taste 'Stimme uebernehmen' desablen
      [StimmeOKTaste setEnabled:NO];
      
      [[self window]makeFirstResponder:StimmenTable];
      [StimmePlusMinusTaste setEnabled:YES];
   }
}

- (IBAction)reportStimmePlusMinus:(id)sender
{
   NSLog(@"reportStimmePlusMinus: tag: %ld",(long)[sender selectedSegment]);
   switch ([sender selectedSegment])
   {
      case 0: //Stimme importieren
      {
         
         [self reportStimmeImportieren:NULL];
      }break;
      case 1://Stimme entfernen
      {
         [self reportStimmeEntfernen:NULL];
      }break;
   }//switch
}


#pragma mark -
#pragma mark SessionTable Data Source:

- (long)numberOfRowsInTableView:(NSTableView *)aTableView
{
   return [StimmenTableArray count];
}


- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
            row:(long)rowIndex
{
   //NSLog(@"objectValueForTableColumn");
   NSDictionary *einStimmenDic;
   //	if (rowIndex<[SessionDicArray count])
   {
      einStimmenDic = [StimmenTableArray objectAtIndex: rowIndex];
      
   }
   //NSLog(@"einSessionDic: aktiv: %d   Testname: %@",[[einSessionDic objectForKey:@"aktiv"]intValue],[einSessionDic objectForKey:@"name"]);
   
   return [einStimmenDic objectForKey:[aTableColumn identifier]];
   
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
              row:(long)rowIndex
{
   //NSLog(@"StimmenTable setObjectValueForTableColumn: %@",[aTableColumn identifier]);
   
   NSMutableDictionary* einStimmenDic;
   einStimmenDic=[StimmenTableArray objectAtIndex:rowIndex];
   [einStimmenDic setObject:anObject forKey:[aTableColumn identifier]];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(long)row
{
   //NSLog(@"shouldSelectRow: %d",row);  
   
   return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(long)row
{
   NSDictionary* einDic=[StimmenTableArray objectAtIndex:row];
   
   if ([[tableColumn identifier]isEqualToString:@"stimmenname"])
   {
      //NSLog(@"willDisplayCell row: %d",row);
      
   }
   
   
   
   
}//willDisplayCell

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView
{
   //	NSLog(@"selectionShouldChangeInTableView selektiert: : %d Zeilen",[aTableView numberOfSelectedRows]);
   //	if ([aTableView numberOfSelectedRows])
   {
      //		[SchliessenTaste setTitle:@"Schliessen"];
   }
   //	else
   {
      [SchliessenTaste setTitle:@"Stimme auswählen"];
   }
   
   
   
   return YES;
}
@end
