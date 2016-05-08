#import "rVolumes.h"

@implementation rVolumes
- (id) init
{
   //if ((self = [super init]))
   self = [super initWithWindowNibName:@"SCVolumes"];
	  {
        UserArray=[[NSMutableArray alloc] initWithCapacity: 0];
        NetworkArray=[[NSMutableArray alloc] initWithCapacity: 0];
     }
   
   SndCalcDatenPfad=[NSString string];
   return self;
}

- (void) awakeFromNib
{
   //NSLog(@"rVolumes: awakeFromNib");
   //[VolumesPopUp addItemWithTitle:@"Hallo"];
   UserDic=[[NSMutableDictionary alloc] initWithCapacity:0];
   neuerHostName=[[NSMutableString alloc] initWithCapacity:0];
   //NamenCell=[[NSTextFieldCell alloc]init];
   //[NamenCell setBackgroundColor:[NSColor redColor]];
   //[NamenCell setSelectable:NO];
   //[NamenCell setDrawsBackground:YES];
   //[[UserTable tableColumnWithIdentifier:@"namen"]setDataCell:NamenCell];
   [UserTable setDataSource:self];
   [UserTable setDelegate: self];
   
   SEL DoppelSelektor;
   DoppelSelektor=@selector(VolumeOK:);
   
   [UserTable setDoubleAction:DoppelSelektor];
   [UserTable reloadData];
   
   [NetworkTable setDataSource:self];
   [NetworkTable setDelegate: self];
   
   NSFont* RecPlayfont;
   RecPlayfont=[NSFont fontWithName:@"Helvetica" size: 36];
   NSColor * RecPlayFarbe=[NSColor grayColor];
   [DialogTitelSting setFont: RecPlayfont];
   [DialogTitelSting setTextColor: RecPlayFarbe];
   
   [StartString setFont: RecPlayfont];
   [StartString setTextColor: RecPlayFarbe];
   NSFont* Titelfont;
   Titelfont=[NSFont fontWithName:@"Helvetica" size: 18];
   NSColor * TitelFarbe=[NSColor grayColor];
   
   [TitelString setFont: Titelfont];
   [TitelString setTextColor: TitelFarbe];
   
   NSFont* ComputerimNetzfont;
   ComputerimNetzfont=[NSFont fontWithName:@"Helvetica" size: 14];
   NSColor * ComputerimNetzFarbe=[NSColor blueColor];
   [ComputerimNetzString setFont:ComputerimNetzfont];
   //[ComputerimNetzString setTextColor:ComputerimNetzFarbe];
   [OderString setFont:ComputerimNetzfont];
   //[OderString setTextColor:ComputerimNetzFarbe];
   NSFont* Homefont;
   Homefont=[NSFont fontWithName:@"Helvetica" size: 14];
   //[HomeKnopf setFont:Homefont];
   //NSImage* RecPlayImage = [NSImage imageNamed: @"MicroIcon"];
   //[RecPlayIcon setImage:RecPlayImage];
   [NetzwerkDrawer setMinContentSize:NSMakeSize(100, 100)];
   //[NetzwerkDrawer setMaxContentSize:NSMakeSize(400, 400)];
   [AbbrechenKnopf setToolTip:NSLocalizedString(@"Quit application.",@"Programm beenden.")];
   [AuswahlenKnopf setToolTip:NSLocalizedString(@"Choose the klicked user.",@"Den angeklickten Benutzer auswählen.")];
   [NetzwerkKnopf setToolTip:NSLocalizedString(@"Open a panel to connect to a network user.",@"√ñffnet ein Dialogfeld, um die Verbindung zu einen Benutzer im Netzwerk einzurichten.")];
   [UserTable setToolTip:NSLocalizedString(@"List of logged in users.",@"Liste der angemeldeten Benutzer.")];
   
}

- (long) anzVolumes
{
   return [UserArray count];
}

- (void) setHomeStatus:(BOOL) derStatus
{
   //	[HomeKnopf setEnabled:derStatus];
}

- (void) setUserArray:(NSArray*) dieUser
{
   //NSMutableArray* tempArray=[[NSMutableArray alloc] initWithCapacity:0];
   if ([dieUser count])
   {
      //NSLog(@"setUserArray start	dieUser: %@\n",[dieUser description]);
      
      NSEnumerator* enumerator=[dieUser objectEnumerator];
      id einObjekt;
      while (einObjekt=[enumerator nextObject])
      {
         //NSLog(@"setUserArray: einObjekt: %@",[einObjekt description]);
         NSMutableDictionary* tempUserDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         int SndCalcDatenOrt=0;
         NSNumber* SndCalcDatenOrtNumber=[einObjekt objectForKey:@"SndCalcDatenort"];
         if (SndCalcDatenOrtNumber)
         {
            SndCalcDatenOrt=[SndCalcDatenOrtNumber intValue];
            [tempUserDic setObject:SndCalcDatenOrtNumber forKey:@"SndCalcDatenort"];
         }
         
         BOOL userSndCalcDatenOK=NO;//Hat es einen Datenordner für User?
         NSNumber* UserSndCalcDatenOKNumber=[einObjekt objectForKey:@"userSndCalcDatenOK"];
         if (UserSndCalcDatenOKNumber)
         {
            userSndCalcDatenOK=[UserSndCalcDatenOKNumber boolValue];
         }
         
         BOOL volumeSndCalcDatenOK=NO;//Hat es einen Datenordner für Volume?
         NSNumber* VolumeSndCalcDatenOKNumber=[einObjekt objectForKey:@"volumeSndCalcDatenOK"];
         if (VolumeSndCalcDatenOKNumber)
         {
            volumeSndCalcDatenOK=[VolumeSndCalcDatenOKNumber boolValue];
         }
         /*
          BOOL homeSndCalcDatenAngelegt=NO;//Hat es Daten im Datenordner für home?
          NSNumber* HomeSndCalcDatenAngelegtNumber=[einObjekt objectForKey:@"volumeSndCalcDatenAngelegt"];
          if (HomeSndCalcDatenAngelegtNumber)
          {
          homeSndCalcDatenAngelegt=[HomeSndCalcDatenAngelegtNumber boolValue];
          }
          NSLog(@"setUserArray  volumeSndCalcDatenAngelegt: %d",homeSndCalcDatenAngelegt);
          */
         
         //Hat es einen Datenordner auf user oder volume?
         
         NSNumber* 	DatenOKNumber= [NSNumber numberWithBool:(userSndCalcDatenOK || volumeSndCalcDatenOK)];
         
         //			NSNumber* 	DatenOKNumber= [NSNumber numberWithBool:(userSndCalcDatenOK || homeSndCalcDatenAngelegt)];
         
         [tempUserDic setObject:DatenOKNumber forKey:@"datenOK"];
         
         NSString* NetzVolumePfad=[einObjekt objectForKey:@"netzvolumepfad"];
         if (NetzVolumePfad)
         {
            [tempUserDic setObject:NetzVolumePfad forKey:@"netzvolumepfad"];
         }
         
         NSString* VolumeSndCalcDatenPfad=[einObjekt objectForKey:@"volumeSndCalcDatenPfad"];
         if (VolumeSndCalcDatenPfad)
         {
            [tempUserDic setObject:VolumeSndCalcDatenPfad forKey:@"volumeSndCalcDatenPfad"];
         }
         
         NSString* UserNameString=[einObjekt objectForKey:@"username"];
         NSString* HostNameString=[einObjekt objectForKey:@"host"];
         //	NSLog(@"setUserArray SndCalcDatenOrt: %d HostNameString: %@  UserNameString: %@",SndCalcDatenOrt,HostNameString,UserNameString);
         if (UserNameString &&[UserNameString length])
         {
            switch (SndCalcDatenOrt)
            {
               case 0://keine Lesebox
               {
                  //Noch nichts vorhanden:
                  if (HostNameString &&[HostNameString length])//&& ![HostNameString isEqualToString:UserNameString])
                  {
                     [tempUserDic setObject:HostNameString forKey:@"host"];
                  }
                  [tempUserDic setObject:UserNameString forKey:@"username"];
                  
                  //volumeSndCalcDatenPfad fehlt
                  if ([tempUserDic objectForKey:@"volumeSndCalcDatenpfad"])
                  {
                     NSString* tempVolumeDocumentPfad=[tempUserDic objectForKey:@"volumeSndCalcDatenpfad"];
                     NSString* tempVolumeSndCalcDatenPfad=[tempVolumeDocumentPfad stringByAppendingPathComponent:NSLocalizedString(@"SndCalcDaten",@"SndCalcDaten")];
                     [tempUserDic setObject:tempVolumeSndCalcDatenPfad forKey:@"volumeSndCalcDatenPfad"];
                     [tempUserDic setObject:[NSNumber numberWithInt:2] forKey:@"leseboxort"];
                  }
               }break;
                  
               case 1://auf Volume
               {
                  [tempUserDic setObject:UserNameString forKey:@"host"];
               }break;
                  
                  
               case 2://in Documemts
               {
                  if (HostNameString &&[HostNameString length])//&& ![HostNameString isEqualToString:UserNameString])
                  {
                     [tempUserDic setObject:HostNameString forKey:@"host"];
                  }
                  [tempUserDic setObject:UserNameString forKey:@"username"];
                  
               }break;
            }//switch
            
            
            NSNumber* tempLeseboxOK=[einObjekt objectForKey:@"userleseboxOK"];
            NSNumber* tempVolumeLeseboxOK=[einObjekt objectForKey:@"volumeleseboxOK"];
            
            NSNumber* tempSndCalcDatenOrt=[einObjekt objectForKey:@"SndCalcDatenort"];
            
            [tempUserDic setObject:tempSndCalcDatenOrt forKey:@"SndCalcDatenOK"];
            
            //NSLog(@"tempUserDic: %@",[tempUserDic description]);
            [UserArray addObject:[tempUserDic copy]];
            //[neuerHostName setString:@""];
            //[UserDic setObject:UserNameString forKey:NamenString];
         }
         
      }//while
      
   }//count
   else
   {
      //[UserArray addObject:@"Lesebox im Netz suchen"];
      //[[[UserTable tableColumnWithIdentifier:@"volume"]dataCellForRow:0]setSelectable:NO];
      
      //[ComputerimNetzString setStringValue:@"Lesebox im Netz suchen"];
      
   }
   //	NSLog(@"setUserArray:	UserArray: %@",[UserArray description]);
   //NSLog(@"setUserArray:	UserArray: %@",[UserArray valueForKey:@"netzvolumepfad"]);
   
   NSString* NetzwerkString=NSLocalizedString(@"Find the Lecturebox in the network",@"Lesebox im Netz suchen");
   //[tempArray release];
   //[UserArray addObject:NetzwerkString];
   [UserDic setObject:@"Netzwerk" forKey:NetzwerkString];
   [UserTable setEnabled:YES];
   int erfolg=[[self window]makeFirstResponder:UserTable];
   [AuswahlenKnopf setEnabled:YES];
   [AuswahlenKnopf setKeyEquivalent:@"\r"];
   
   [UserTable reloadData];
   
   NSEnumerator* UserEnum=[UserArray reverseObjectEnumerator];
   id einUserDic;
   BOOL keineUserdaten=YES;//noch kein User mit Daten gefunden
   int UserdatenIndex=[UserArray count];//letzte zeile
   while((einUserDic=[UserEnum nextObject])&&keineUserdaten)
   {
      //NSLog(@"einUserDic: %@",[einUserDic description]);
      NSNumber* tempOKNumber=[einUserDic objectForKey:@"datenOK"];
      if (tempOKNumber&&[tempOKNumber boolValue])
      {
         keineUserdaten=NO;
      }
      UserdatenIndex--;
   }//while
   [UserTable selectRowIndexes:[NSIndexSet indexSetWithIndex:UserdatenIndex] byExtendingSelection:NO];
   
   //	[UserTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[UserArray count]-1] byExtendingSelection:NO];
   
   [VolumesPop setEnabled:NO];
   SEL DoppelSelektor;
   DoppelSelektor=@selector(VolumeOK:);
   [UserTable setDoubleAction:DoppelSelektor];
   //	[UserTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
   NSColor * SuchenFarbe=[NSColor blueColor];
   NSTextFieldCell* c=[[NSTextFieldCell alloc]init];
   c=	[[UserTable tableColumnWithIdentifier:@"namen"]dataCellForRow:[UserArray count]-1];
   [[[UserTable tableColumnWithIdentifier:@"namen"]dataCellForRow:(0)]setTextColor:SuchenFarbe];
}


- (IBAction)Abbrechen:(id)sender
{
   NSLog(@"Abbrechen: stopModalWithCode 0");
   NSNumber* n=[NSNumber numberWithBool:NO];
   NSMutableDictionary* LeseboxDic=[NSMutableDictionary dictionaryWithObject:n forKey:@"SndCalcDatenDa"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"VolumeWahl" object:self userInfo:LeseboxDic];
   
   [NSApp stopModalWithCode:0];
   
}

- (IBAction)HomeDirectory:(id)sender
{
   NSString* s=NSLocalizedString(@"SndCalcDaten",@"SndCalcDaten");
   SndCalcDatenPfad=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:s];
   //NSLog(@"SndCalcDatenPfad: %@",[SndCalcDatenPfad description]);
   [NSApp stopModalWithCode:3];
   //NSLog(@"Home");
   NSNumber* n=[NSNumber numberWithBool:YES];
   NSMutableDictionary* LeseboxDic=[NSMutableDictionary dictionaryWithObject:n forKey:@"LeseboxDa"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"VolumeWahl" object:self userInfo:LeseboxDic];
   
   //[UserTable setEnabled:NO];
   //[UserTable setEnabled:![HomeKnopf state]];
   [UserTable deselectAll:sender];
   //[OKKnopf setEnabled:[HomeKnopf state]];
}

/*
 - (NSString*)chooseNetworkSndCalcDatenPfad
 {
 
	BOOL erfolg=NO;
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	NSLog(@"chooseNetworkSndCalcDatenPfad");
	NSString* NetzPfad=@"//Network";
	NSOpenPanel * LeseboxDialog=[NSOpenPanel openPanel];
	[LeseboxDialog setCanChooseDirectories:YES];
	[LeseboxDialog setCanChooseFiles:NO];
	[LeseboxDialog setAllowsMultipleSelection:NO];
	NSString* s1=NSLocalizedString(@"\nOn which Machine IN THE 2nd. COLUMN should be the lecturebox?",@"LB auf welchem Comp?");
	NSString* s2=NSLocalizedString(@"The lecturebox can also be created after login.",@"Lesebox auch nach login");
	NSString* s3=NSLocalizedString(@"\nAfter login, the user must be choosen in the LEFTMOST COLUMN.\n",@"Ausw√§hlen in Kol- ganz links");
	
	[LeseboxDialog setMessage:[NSString stringWithFormat:@"%@\n%@\n%@",s1,s2,s3]];
	
	[LeseboxDialog setCanCreateDirectories:NO];
	NSString* tempSndCalcDatenPfad;
	int LeseboxHit=0;
	
	//LeseboxHit=[LeseboxDialog runModalForDirectory:NSHomeDirectory() file:@"Network" types:NULL];
	LeseboxHit=[LeseboxDialog runModalForDirectory:NetzPfad file:@"Network" types:NULL];
	
	
	if (LeseboxHit==NSOKButton)
	{
 tempSndCalcDatenPfad=[LeseboxDialog filename]; //gew√§hltes "home"
 NSLog(@"choose: SndCalcDatenPfad roh: %@",tempSndCalcDatenPfad);
 NSArray* tempPfadArray=[tempSndCalcDatenPfad pathComponents];
 //NSLog(@"tempPfadArray: %@",[tempPfadArray description]);
 if ([tempPfadArray count]>2)
 {
 NSArray* UserPfadArray=[tempPfadArray subarrayWithRange:NSMakeRange(0,3)];
 NSString* UserPfad=[NSString pathWithComponents:UserPfadArray];
 //NSLog(@"UserPfad: %@",UserPfad);
 
 BOOL LeseboxCheck=[self checkUserAnPfad:tempSndCalcDatenPfad];
 NSLog(@"tempSndCalcDatenPfad: %@  LeseboxCheck: %d",tempSndCalcDatenPfad,LeseboxCheck);
 
 }
 else
 {
 //Kein g√ºltiger Pfad
 NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
 [Warnung addButtonWithTitle:@"OK"];
 [Warnung setMessageText:NSLocalizedString(@"This is not a valable path for the application",@"Kein g√ºltiger Pfad")];
 [Warnung setAlertStyle:NSWarningAlertStyle];
 
 //[Warnung setIcon:RPImage];
 int antwort=[Warnung runModal];
 
 tempSndCalcDatenPfad=[NSString string];
 }
 
	}
	else//Abbrechen
	{
 //tempSndCalcDatenPfad=[NSString string];
 //NSNumber* n=[NSNumber numberWithBool:NO];
 //NSMutableDictionary* LeseboxDic=[NSMutableDictionary dictionaryWithObject:n forKey:@"LeseboxDa"];
 //NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"VolumeWahl" object:self userInfo:LeseboxDic];
 }
	
	return tempSndCalcDatenPfad;
 }
 
 */


- (IBAction)VolumeOK:(id)sender
{
   [NSApp stopModalWithCode:1];
   //int HomeStatus=[HomeKnopf state];
   NSString* NetzwerkString=@"Datenordner im Netz suchen";
   //NSLog(@"OKSheet:  stopModalWithCode HomeStatus: %d", HomeStatus);
   NSString* lb=NSLocalizedString(@"Lecturebox",@"Lesebox");
   //if ([HomeKnopf state])
	  {
        //	SndCalcDatenPfad=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:lb];
     }
   //else
	  {
        if ([UserTable numberOfSelectedRows])
        {
           int Zeile=[UserTable selectedRow];
           if ([UserArray objectAtIndex:Zeile]==NetzwerkString)//->Lesebox im Netz suchen
           {
              NSLog(@"VolumeOK A");
              SndCalcDatenPfad=[self chooseNetworkSndCalcDatenPfad];
           }
           else
           {
              NSLog(@"VolumeOK B");
              //Eines der Netz-Volumes mit Lesebox
              SndCalcDatenPfad=[UserDic objectForKey:[UserArray objectAtIndex:Zeile]];
           }
        }
     }
   NSNumber* n=[NSNumber numberWithBool:YES];
   NSMutableDictionary* LeseboxDic=[NSMutableDictionary dictionaryWithObject:n forKey:@"LeseboxDa"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"VolumeWahl" object:self userInfo:LeseboxDic];
   
   //NSMutableDictionary* UserDic=[NSMutableDictionary dictionaryWithObject:SndCalcDatenPfad forKey:@"LeseboxVolume"];
   //NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   //[nc postNotificationName:@"VolumeWahl" object:self userInfo:UserDic];
   return;
}

- (NSString*)SndCalcDatenPfad
{
   return SndCalcDatenPfad;
}

- (BOOL)istSystemVolume
{
   return istSystemVolume;
}

- (IBAction)reportOpenNetwork:(id)sender
{
   //NSLog(@"\nreportOpenNetwork\n\n");
   NSString* NetwerkSndCalcDatenPfad=[self chooseNetworkSndCalcDatenPfad];
   if (NetwerkSndCalcDatenPfad)
   {
      NSURL* NetzURL=[NSURL fileURLWithPath:NetwerkSndCalcDatenPfad];
      //CFStringRef=CFURLCopyHostName
      //NSLog(@"\nende reportOpenNetwork: URL: %@\n\n",NetzURL);
   }
   
}


- (IBAction)reportAuswahlen:(id)sender
{
   istSystemVolume=NO;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* localizedSndCalcDaten=NSLocalizedString(@"SndCalcDaten",@"SndCalcDaten");
   
   if ([UserTable numberOfSelectedRows])
   {
      int Zeile=[UserTable selectedRow];
      
      //NSLog(@"reportAuswahlen: Zeile: %d",Zeile);
      if (Zeile==0)//home
      {
         SndCalcDatenPfad=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:localizedSndCalcDaten];
         istSystemVolume=YES;
      }
      else
      {
         
         //NSLog(@"reportAuswahlen: Zeile: %d %@",Zeile,[[UserArray objectAtIndex:Zeile] description]);
         NSString* Username=[[UserArray objectAtIndex:Zeile]objectForKey:@"username"];
         NSString* Hostname=[[UserArray objectAtIndex:Zeile]objectForKey:@"host"];
         NSString* UserPfad;
         int SndCalcDatenort=[[[UserArray objectAtIndex:Zeile]objectForKey:@"SndCalcDatenort"]intValue];
         //NSLog(@"Volumes:	SndCalcDatenort: %d",SndCalcDatenort);
         switch (SndCalcDatenort)
         {
            case 0:
            case 1://Volume
            {
               if (Hostname && [Hostname length])
               {
                  // 22.02.10
                  UserPfad=[[UserArray objectAtIndex:Zeile]objectForKey:@"netzvolumepfad"];
                  //UserPfad=[NSString stringWithFormat:@"/Volumes/%@",Hostname];
               }
            }break;
            case 2: //Documents
            {
               if (Username && [Username length])
               {
                  UserPfad=[NSString stringWithFormat:@"/Volumes/%@",Username];
               }
            }break;
               
            default:
            {
               NSLog(@"Kein geeigneter Datenort da");
               return;
            }
         }//switch
         
         if ([Filemanager fileExistsAtPath:[UserPfad stringByAppendingPathComponent:@"Library"]]//ist Volume mit System
             &&![Filemanager fileExistsAtPath:[UserPfad stringByAppendingPathComponent:@"Users"]])//ist nicht die HD
         {
            istSystemVolume=YES;
            //NSString* localizedSndCalcDaten=NSLocalizedString(@"SndCalcDaten",@"SndCalcDaten");
            NSString* DocumentsPfad=[NSString stringWithFormat:@"%@/Documents",UserPfad];
            SndCalcDatenPfad=[DocumentsPfad stringByAppendingPathComponent:localizedSndCalcDaten];
            
         }
         else//Externe HD
         {
            //NSLog(@"Externe HD");
            SndCalcDatenPfad=[UserPfad stringByAppendingPathComponent:localizedSndCalcDaten];;
         }
      }
   }
   
   //Eventuell Ordner SndCalcDaten einrichten
   BOOL istDirectory=NO;
   BOOL SndCalcDatenOK=YES;
   if (!(([Filemanager fileExistsAtPath:SndCalcDatenPfad isDirectory:&istDirectory] &&istDirectory)))
   {
      //SndCalcDatenOK=[Filemanager createDirectoryAtPath:SndCalcDatenPfad attributes:NULL];
      
      SndCalcDatenOK = [Filemanager createDirectoryAtPath:SndCalcDatenPfad withIntermediateDirectories:NO attributes:NULL error:NULL];
      
   }
   
			
   //NSLog(@"Volumes: SndCalcDatenPfad: %@",[SndCalcDatenPfad description]);
   
   //Der SndCalcDatenPfad wird in chooseSndCAlcDaten gelesen und in Leseboxvorbereiten gesetzt
   
   
   NSNumber* n=[NSNumber numberWithBool:YES];
   NSMutableDictionary* SndCalcDatenDic=[NSMutableDictionary dictionaryWithObject:n forKey:@"SndCalcDatenDa"];
   [SndCalcDatenDic setObject:[NSNumber numberWithBool:istSystemVolume] forKey:@"istsysvol"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"VolumeWahl" object:self userInfo:SndCalcDatenDic];
   //NSLog(@"SndCalcDatenDic: %@",[SndCalcDatenDic description]);
   //NSMutableDictionary* UserDic=[NSMutableDictionary dictionaryWithObject:SndCalcDatenPfad forKey:@"SndCalcDatenDicVolume"];
   //NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   //[nc postNotificationName:@"VolumeWahl" object:self userInfo:UserDic];[
   
   [NSApp stopModalWithCode:3];
   
   return;
   
}
- (IBAction)reportAnmelden:(id)sender
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([NetworkTable numberOfSelectedRows])
   {
      
      
      NSMutableString* ComputerName=[[[NetworkArray objectAtIndex:[NetworkTable selectedRow]]objectForKey:@"networkname"]mutableCopy];
      NSLog(@"ComputerName: %@",ComputerName);
      [neuerHostName setString:ComputerName];
      //NSLog(@"neuerHostName: %@",neuerHostName);
      [ComputerName replaceOccurrencesOfString:@"." withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, [ComputerName length])];
      [ComputerName replaceOccurrencesOfString:@" " withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, [ComputerName length])];
      NSArray* MV=[[NSWorkspace sharedWorkspace]mountedLocalVolumePaths];
      int AnzUser=[MV count];
      NSLog(@"MV: %@  Anzahl: %d",[MV description], AnzUser);
      BOOL istOK=NO;
      NSString* afpString=@"afp://";
      NSString* ComputerNameString=[[afpString stringByAppendingString:ComputerName]stringByAppendingString:@".local"];
      
      NSURL* ComputerURL=[NSURL URLWithString:ComputerNameString];
      NSURLRequest* ComputerRequest = [NSURLRequest requestWithURL:ComputerURL];
      NSData* ComputerData = [NSMutableData data];
      NSURLConnection *ComputerConnection;
      ComputerConnection=[NSURLConnection connectionWithRequest:ComputerRequest
                                                       delegate:self];
      istOK=[[NSWorkspace sharedWorkspace]openURL:[NSURL URLWithString:ComputerNameString]];
      if (istOK)
      {
         [neuerHostName setString:ComputerName];
         
         NSString* neuerUserDocumentsPfad=[NSString stringWithFormat:@"/Volumes/%@/Documents",ComputerName];
         NSLog(@"ComputerNameString: %@",[neuerUserDocumentsPfad description]);
         [PrufenKnopf setEnabled:YES];
         [AnmeldenKnopf setEnabled:NO];
         NSNumber* LoginOK=[NSNumber numberWithBool:YES];
         [[NetworkArray objectAtIndex:[NetworkTable selectedRow]]setObject:LoginOK forKey:@"networkloginOK"];
         [NetworkTable reloadData];
      }
      else
         NSLog(@"openURL: nichts");
      [AnmeldenKnopf setEnabled:NO];
      //NSLog(@"reportAnmelden: neuerHostName: %@",neuerHostName);
   }
   
   
}

/*
 - (IBAction)checkUser:(id)sender
 {
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	
	NSMutableArray* neueMountedVols=(NSMutableArray *)[[NSWorkspace sharedWorkspace]mountedLocalVolumePaths];//Liste der gemounteten Vols
	int anz=[neueMountedVols count];
	[neueMountedVols removeObject:@"/"];
	[neueMountedVols removeObject:@"/Network"];
	NSLog(@"neueMountedVols: %@ anz: %d  neuer Hostname: %@",[neueMountedVols description],anz,neuerHostName);
	NSLog(@"UserArray: %@",[UserArray description]);
	if ([neueMountedVols count])
	{
 NSEnumerator* MVEnum=[neueMountedVols objectEnumerator];
 id einUser;
 while (einUser=[MVEnum nextObject])//mounted Volumes
 {
 NSString* tempMountedUserName=[einUser lastPathComponent];//Name des Users in neueMountedVols
 BOOL NameIstNeu=YES;
 NSEnumerator* UserArrayEnum=[UserArray objectEnumerator];//Array der schon vorhandenen User
 id einDic;
 while (einDic=[UserArrayEnum nextObject])
 {
 NSString* UserNameString=[einDic objectForKey:@"username"];
 NSString* HostNameString=[einDic objectForKey:@"host"];
 //NSLog(@"UserNameString: %@  HostNameString: %@",UserNameString,HostNameString);
 if (UserNameString)
 {
 if ([UserNameString isEqualToString:tempMountedUserName])
 //&&[HostNameString isEqualTo: neuerHostName])//neuer User ist schon in UserArray
 {
 NameIstNeu=NO;
 }
 }//if UserNameString
 
 }//while UserArrayEnum
 
 if (NameIstNeu)
 {
 NSMutableDictionary* tempUserDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
 [tempUserDic setObject:tempMountedUserName forKey:@"username"];
 if ([neuerHostName length])
 {
 [tempUserDic setObject:[neuerHostName copy] forKey:@"host"];
 }
 else
 {
 [tempUserDic setObject:@"-" forKey:@"host"];
 }
 BOOL LeseboxOK=NO;
 NSString* lb=NSLocalizedString(@"SndCalcDaten",@"SndCalcDaten");
 NSString* tempPfad=[[einUser stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:lb];
 //NSLog(@"tempPfad: %@",tempPfad);
 if ([Filemanager fileExistsAtPath:tempPfad])
 {
 LeseboxOK=YES;
 }
 [tempUserDic setObject:[NSNumber numberWithBool:LeseboxOK] forKey:@"userleseboxOK"];
 NSLog(@"checkUsert: add tempUserDic: %@",[tempUserDic description]);
 [UserArray addObject:tempUserDic];
 [UserTable reloadData];
 [neuerHostName setString:@""];
 }//if NameIstNeu
 
 }//while MVEnum
 
 
	}//count
	[PrufenKnopf setEnabled:NO];
	[AnmeldenKnopf setEnabled:YES];
	[AuswahlenKnopf setEnabled:YES];
 
	[[self window]makeFirstResponder:UserTable];
	NSLog(@"checkUser: %@",[UserArray description]);
	
 }
 */

- (BOOL)checkUserAnPfad:(NSString*)derUserPfad
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   SndCalcDatenPfad=[NSString string];
   NSString* tempUserPfad=[derUserPfad copy];
   NSString* tempMountedUserName=[tempUserPfad lastPathComponent];//Name des Netzwerk-Users in derUserPfad
   BOOL NameIstNeu=YES;
   NSEnumerator* UserArrayEnum=[UserArray objectEnumerator];//Array der schon vorhandenen User
   id einDic;
   while (einDic=[UserArrayEnum nextObject])
   {
      NSString* UserNameString=[einDic objectForKey:@"username"];
      NSString* HostNameString=[einDic objectForKey:@"host"];
      //NSLog(@"UserNameString: %@  HostNameString: %@",UserNameString,HostNameString);
      if (UserNameString)
      {
         if ([UserNameString isEqualToString:tempMountedUserName])
            //&&[HostNameString isEqualTo: neuerHostName])//neuer User ist schon in UserArray
         {
            NameIstNeu=NO;//User ist schon in der Liste
         }
      }//if UserNameString
      
   }//while UserArrayEnum
   BOOL LeseboxOK=NO;
   if (NameIstNeu)
   {
      NSMutableDictionary* tempUserDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [tempUserDic setObject:tempMountedUserName forKey:@"username"];
      if ([neuerHostName length])
      {
         [tempUserDic setObject:[neuerHostName copy] forKey:@"host"];
      }
      else
      {
         [tempUserDic setObject:@"-" forKey:@"host"];
      }
      
      [tempUserDic setObject:tempMountedUserName forKey:@"host"];
      
      NSString* lb=NSLocalizedString(@"SndCalcDaten",@"SndCalcDaten");
      [tempUserDic setObject:[NSNumber numberWithInt:0] forKey:@"leseboxort"];
      NSString* tempUserSndCalcDatenPfad=[tempUserPfad stringByAppendingPathComponent:lb];
      NSLog(@"tempUserSndCalcDatenPfad: %@",tempUserSndCalcDatenPfad);
      
      if ([Filemanager fileExistsAtPath:tempUserSndCalcDatenPfad])//Lesebox ist auf dem Volume
      {
         NSLog(@"Lesebox ist auf dem Volume");
         LeseboxOK=YES;
         [tempUserDic setObject:[NSNumber numberWithBool:NO] forKey:@"leseboxindocuments"];
         [tempUserDic setObject:[NSNumber numberWithInt:1] forKey:@"leseboxort"];
         SndCalcDatenPfad=tempUserSndCalcDatenPfad;
      }
      
      NSString* tempDocumentSndCalcDatenPfad=[[tempUserPfad stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:lb];
      NSLog(@"tempDocumentSndCalcDatenPfad: %@",tempDocumentSndCalcDatenPfad);
      if ([Filemanager fileExistsAtPath:tempDocumentSndCalcDatenPfad])
      {
         NSLog(@"Lesebox ist auf in Documents");
         
         LeseboxOK=YES;
         [tempUserDic setObject:[NSNumber numberWithBool:YES] forKey:@"leseboxindocuments"];
         [tempUserDic setObject:[NSNumber numberWithInt:2] forKey:@"leseboxort"];
         SndCalcDatenPfad=tempDocumentSndCalcDatenPfad;
         
      }
      [tempUserDic setObject:[NSNumber numberWithBool:LeseboxOK] forKey:@"userleseboxOK"];
      NSLog(@"checkUserAnPfad:	tempUserDic: %@",[tempUserDic description]);
      [UserArray addObject:tempUserDic];
      
      [UserTable reloadData];
      [UserTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[UserArray count]-1] byExtendingSelection:NO];
      [neuerHostName setString:@""];
   }//if NameIstNeu
   
   
   return LeseboxOK;
}

#pragma mark -
#pragma mark URL Delegate:

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
   NSLog(@"didReceiveData");
   // add the new data to the old data
   // [ComputerData appendData:data];
   // great opportunity to provide progress to the user
}

#pragma mark -
#pragma mark UserTable Data Source:

- (long)numberOfRowsInTableView:(NSTableView *)aTableView
{
   switch ([aTableView tag])
   {
      case 0:
      {
         return [UserArray count];
      }break;
         
      case 1:
      {
         return [NetworkArray count];
      }
         
   }//switch
   return 0;
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(long)rowIndex
{
   id einObjekt;
   //NSLog(@"tableView tag: %d",[aTableView tag]);
   switch ([aTableView tag])
   {
      case 0:
      {
         // NSDictionary *einUserDic;
         //NSLog(@"UserArray: %@",[UserArray description]);
         if (rowIndex<[UserArray count])
         {
            NS_DURING
            einObjekt = [[UserArray objectAtIndex: rowIndex]objectForKey:[aTableColumn identifier]];
            
            NS_HANDLER
            if ([[localException name] isEqual: @"NSRangeException"])
            {
               return nil;
            }
            else [localException raise];
            NS_ENDHANDLER
         }
         
      }break;
         
      case 1:
      {
         // NSDictionary *einVolumeDic;
         //NSLog(@"objectValue NetworkArray: %@",[NetworkArray description]);
         if (rowIndex<[NetworkArray count])
         {
            NS_DURING
            einObjekt = [[NetworkArray objectAtIndex: rowIndex]objectForKey:[aTableColumn identifier]];
            
            NS_HANDLER
            if ([[localException name] isEqual: @"NSRangeException"])
            {
               return nil;
            }
            else [localException raise];
            NS_ENDHANDLER
         }
         
      }
         
   }//switch
   
   
   return einObjekt;
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
              row:(long)rowIndex
{
   switch ([aTableView tag])
   {
      case 0:
      {
         
         
      }break;
         
      case 1:
      {
         
      }
         
   }//switch
   
   /*
    NSString* einVolume;
    if (rowIndex<[UserArray count])
    {
    einVolume=[UserArray objectAtIndex:rowIndex];
    [UserArray insertObject:anObject atIndex:rowIndex];
    }
    */
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(long)row
{
   BOOL selectOK=YES;
   switch ([tableView tag])
   {
      case 0:
      {
         
      }break;
         
      case 1:
      {
         if (row<=[NetworkArray count])
         {
            [AnmeldenKnopf setEnabled:YES];
            [AuswahlenKnopf setEnabled:NO];
         }
         else
         {
            [AnmeldenKnopf setEnabled:NO];
            [PrufenKnopf setEnabled:NO];
         }
      }
         
   }//switch
   
   {
      //NSLog(@"shouldSelectRow im Bereich: row %d",row);
      
   }
   return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(long)row
{
   switch ([tableView tag])
   {
      case 0:
      {
         if ([[tableColumn identifier] isEqualToString:@"host"])
         {
            if (([UserArray count]>1)&&(row==0))
            {
               NSColor * SuchenFarbe=[NSColor orangeColor];
               [cell setTextColor:SuchenFarbe];
            }
            else
            {
               NSColor * TextFarbe=[NSColor blackColor];
               [cell setTextColor:TextFarbe];
            }
         }
      }break;
         
      case 1:
      {
         
      }
         
   }//switch
   
   NSFont* Tablefont;
   Tablefont=[NSFont fontWithName:@"Helvetica" size: 14];
   [cell setFont:Tablefont];
   if ((row==[UserArray count]-1)&&[[tableColumn identifier] isEqualToString:@"username"])
   {
      NSColor * SuchenFarbe=[NSColor orangeColor];
      //[cell setTextColor:SuchenFarbe];
   }
   else
   {
      NSColor * TextFarbe=[NSColor blackColor];
      //[cell setTextColor:TextFarbe];
      
   }
}
@end
