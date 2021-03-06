//
//  rSpeaker.mQuittungSelektionDic
//  SndCalcII
//
//  Created by Sysadmin on 24.10.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "rSpeaker.h"
#define kSoundMediaTimeScale =44100

const short  kPlus=2001;
const short  kMinus=2002;
const short  kMal=2003;
const short  kDurch=2004;
const short  kUnd=2200;
const short  kUn=2201;
const short  kMaxChannels=4;
const short  kMaxElemente=12;

//pascal void AufgabenCallBackProc (QTCallBack cb, long refcon);
//pascal void QuittungCallBackProc (QTCallBack cb, long refcon);

@implementation rSpeaker
- (id)init
{
   //NSLog(@"rSpeaker init");
   self=[super init];
   
   //AufgabenPlayer=[[NSMovieView alloc]initWithFrame:NSMakeRect(0,0,0,0)];
   // setup a callback for our movie so QuickTime will call us when the
   //   movie finishes playing
   
   //NSLog(@"kFullVolume: %f kNoVolume: %f",kFullVolume,kNoVolume);
   //PlayerVolume=kFullVolume;//0x0010;
   PlayerVolume=120.0;
   Stimme=@"home";
   
   QueueArray = [[NSMutableArray alloc]initWithCapacity:0];
   
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(NeueStimmeAktion:)
              name:@"neueStimme"
            object:nil];
   
   
   [nc addObserver:self
          selector:@selector(StimmeAktion:)
              name:@"Stimme"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(QuittungAktion:)
              name:@"Quittung"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(playerItemDidReachEnd:)
              name:AVPlayerItemDidPlayToEndTimeNotification
            object:[QueueArray lastObject]];
   
   QuittungSelektionDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   return self;
}


- (void)awakeFromNib
{
   NSLog(@"Speaker awake");
   //**AufgabenPlayer=[[NSMovieView alloc]initWithFrame:NSMakeRect(0,0,0,0)];
   /* setup a callback for our movie so QuickTime will call us when the
    movie finishes playing */
   //gQuittungPlayingCompleteCallBack =  NewQTCallBackUPP(&QuittungCallBackProc);
   ////gAufgabePlayingCompleteCallBack =  NewQTCallBackUPP(&AufgabenCallBackProc);
   //NSArray* qarray;
   
}


- (void)NeueStimmeAktion:(NSNotification*)note
{
   NSLog(@"NeueStimmeAktion:note userInfo: %@",[[note userInfo]description]);
   NSArray* tempZiffernArray=[[note userInfo]objectForKey:@"stimmentablearray"];
   NSString* neueStimme=[[note userInfo]objectForKey:@"neuestimme"];
   
}

- (void)StimmeAktion:(NSNotification*)note
{
   //Ziffern fuer ausgewählte Stimme bei close von StimmenPanel laden
   //NSLog(@"Speaker StimmeAktion:note userInfo: %@",[[note userInfo]description]);
   NSString* neueStimme=[[note userInfo]objectForKey:@"stimmenname"];
   
   if (neueStimme&&(![neueStimme isEqualToString:Stimme]))
   {
      [self setStimme: neueStimme];
      [self readZahlen];
   }
}

- (void)QuittungAktion:(NSNotification*)note
{
   //Soundfiles fuer ausgewählte Quittungen bei close von StimmenPanel laden
   //NSLog(@"\n\nSpeaker QuittungAktion:note userInfo: %@",[[note userInfo]description]);
   
   NSDictionary* neueQuittungDic=[[note userInfo]objectForKey:@"quittungdic"];
   QuittungSelektionDic=(NSMutableDictionary*)neueQuittungDic;
   
   [self readQuittungen];
   
}


- (void)setStimme:(NSString*)dieStimme
{
   //dieStimme: selektierte Stimme aus PList
   //NSLog(@"setStimme vor set: bisherige Stimme: %@	dieStimme: %@",Stimme, dieStimme);
   
   //in Resources vorhandenen Namen von Stimmen
   NSArray* ResourceStimmenArray=[self StimmenNamenArrayAusResources];
   //NSLog(@"Speaker setStimme ResourceStimmenArray: %@\n",[ResourceStimmenArray description]);
   if ([[ResourceStimmenArray valueForKey:@"stimmenname"]containsObject:dieStimme])//Stimmen ist in Resourcen
   {
      Stimme=dieStimme;
   }
   else
   {
      Stimme=@"home";
   }
   
   //NSLog(@"setStimme nach set: Stimme: %@",Stimme);
}

- (NSString*)Stimme
{
   return Stimme;
}

- (void)setQuittungSelektionDic:(NSDictionary*)derQuittungSelektionDic
{
   //derQuittungSelektionDic: selektierte Quittungsklassennamen aus PList
   //NSLog(@"Speaker setQuittungSelektionDic: derQuittungSelektionDic: %@\n",[derQuittungSelektionDic description]);
   QuittungSelektionDic=(NSMutableDictionary*)derQuittungSelektionDic;
   
   //in den Resources vorhandene Namen fuer die Klassen
   NSDictionary* ResourceQuittungArrayDic=[self QuittungNamenArrayDicAusResources];
   //NSLog(@"Speaker setQuittungSelektionDic ResourceQuittungArrayDic: %@\n",[ResourceQuittungArrayDic description]);
   
   //QuittungDic synchronisieren
   NSEnumerator* PListEnum=[[derQuittungSelektionDic allKeys] objectEnumerator];//Klassennamen
   id eineKlasse;
   while(eineKlasse=[PListEnum nextObject])
   {
      NSString* tempSelektierteKlasse=[QuittungSelektionDic objectForKey:eineKlasse];
      if ([tempSelektierteKlasse isEqualToString:@"home"])
      {
         [QuittungSelektionDic setObject:@"home" forKey:eineKlasse];//auf 'home' setzen
      }
      else//UserKlassenname
      {
         NSArray* tempKlassenNamenArray=[ResourceQuittungArrayDic objectForKey:eineKlasse];
         if (tempKlassenNamenArray&&[tempKlassenNamenArray containsObject:tempSelektierteKlasse])//selekt. Klasse ist in Res
         {
            //Alles OK
         }
         else//Selektierte Klasse nicht in Resources
         {
            [QuittungSelektionDic setObject:@"home" forKey:eineKlasse];//auf 'home' setzen
         }
      }
      
   }//while
   
   //NSLog(@"Speaker setQuittungSelektionDic  nach set: QuittungSelektionDic: %@\n",[QuittungSelektionDic description]);
   
}

- (IBAction)showStimmenPanel:(id)sender
{
   
   //NSLog(@"showStimmenPanel: ");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   if (!StimmenPanel)
   {
      //NSLog(@"init TestPanel");
      StimmenPanel=[[rStimmenPanel alloc]init];
      
   }
			
   NSModalSession StimmenSession=[NSApp beginModalSessionForWindow:[StimmenPanel window]];
   int modalAntwort=0;
   //NSLog(@"showStimmenPanel: Stimme: %@",Stimme);
   NSArray* tempStimmenNamenArray=[self StimmenNamenArrayAusResources];
   //NSLog(@"showStimmenPanel  StimmenNamenArrayAusResources: %@",[tempStimmenNamenArray description]);
   
   [StimmenPanel setStimmenTableArrayMitStimmenNamenArray:tempStimmenNamenArray mitStimme:Stimme];
   
   [StimmenPanel setQuittungSelektionDic:QuittungSelektionDic];
   [StimmenPanel setQuittungNamenArrayDic:[self QuittungNamenArrayDicAusResources]];
   
   
   //NSLog(@"showStimmenPanel: QuittungSelektionDic: %@",[QuittungSelektionDic description]);
   
   //	[self setQuittungSelektionDic:QuittungSelektionDic];
   
   
   modalAntwort=[NSApp runModalSession:StimmenSession];
   
   
   [NSApp endModalSession:StimmenSession];
   //	NSLog(@"showStimmenPanel: modalAntwort: %d selectedStimme: %@",modalAntwort,[StimmenPanel StimmenName]);
   
   
   
}


- (NSArray*)StimmenNamenArrayAusResources
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL StimmenArrayOK=YES;
   NSMutableDictionary* tempStimmenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   //Zahlen.plist lesen: Liste der benötigten Ziffern
   NSDictionary* tempZahlenPListDic;
   int anzZiffern=0;
   NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources"];
   NSString* ZahlenPlistPfad=[ResourcenPfad stringByAppendingPathComponent:@"Zahlen.plist"];
   NSArray* PListZiffernNamenArray;
   if ([Filemanager fileExistsAtPath:ZahlenPlistPfad])
   {
      tempZahlenPListDic=[[NSDictionary dictionaryWithContentsOfFile:ZahlenPlistPfad]mutableCopy];
      //NSLog(@"tempZiffernDic: %@",[tempZiffernDic description]);
      
      PListZiffernNamenArray=[tempZahlenPListDic allKeys];//Alle notwendigen Ziffernnamen
      anzZiffern=[PListZiffernNamenArray count];
   }
   
   //Vorhandene Ziffern in Resources
   NSArray* tempZiffernArray=[Filemanager contentsOfDirectoryAtPath:ResourcenPfad error:NULL];
   
   //		Test
   //	NSString* TestOrdnerPfad=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SndCalcTest"];
   //	NSArray* tempZiffernArray=[Filemanager directoryContentsAtPath:TestOrdnerPfad];
   
   
   NSMutableArray* tempStimmenNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSEnumerator* StimmenNamenEnum=[tempZiffernArray objectEnumerator];
   id eineZiffer;
   while (eineZiffer=[StimmenNamenEnum nextObject])
   {
      if( [[eineZiffer pathExtension]isEqualToString:@"aif"])
      {
         //ZiffernName aufteilen
         NSArray*tempZiffernTeileArray=[eineZiffer componentsSeparatedByString:@"_"];
         //NSLog(@"eineZiffer: %@	tempZiffernTeileArray: %@",eineZiffer,[tempZiffernTeileArray description]);
         
         
         if ([tempZiffernTeileArray count]==2)//nicht defaultStimme 'home'
         {
            
            
            NSString* tempZiffernName=[tempZiffernTeileArray objectAtIndex:1];//zweiter Teil des Namens
            //Ist tempZiffernName in Liste der notwendigen Ziffern?
            if ([PListZiffernNamenArray containsObject:[tempZiffernName stringByDeletingPathExtension]])
            {
               
               NSString* tempStimmenName=[tempZiffernTeileArray objectAtIndex:0];//erster Teil des Namens
               //NSLog(@"tempStimmenName: %@  ",tempStimmenName);
               
               long StimmenNamenIndex=[[tempStimmenNamenArray valueForKey:@"stimmenname"]indexOfObject:tempStimmenName];
               if(StimmenNamenIndex==NSNotFound)//StimmenName noch nicht vorhanden
               {
                  NSMutableDictionary* tempStimmenNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
                  [tempStimmenNamenDic setObject:tempStimmenName forKey:@"stimmenname"];
                  [tempStimmenNamenDic setObject:[NSNumber numberWithInt:1] forKey:@"anz"];
                  //NSLog(@"name neu:	tempStimmenNamenDic:  %@",[tempStimmenNamenDic description]);
                  [tempStimmenNamenArray addObject:tempStimmenNamenDic];
               }//if
               else	//StimmenName schon vorhanden
               {
                  
                  NSMutableDictionary* tempStimmenNamenDic=(NSMutableDictionary*)[tempStimmenNamenArray objectAtIndex:StimmenNamenIndex];
                  //NSLog(@"Name schon da:				tempStimmenNamenDic:  %@",[tempStimmenNamenDic description]);
                  int anz=[[tempStimmenNamenDic objectForKey:@"anz"]intValue]+1;
                  [tempStimmenNamenDic setObject:[NSNumber numberWithInt:anz] forKey:@"anz"];
                  //NSLog(@"neue anz:				tempStimmenNamenDic:  %@",[tempStimmenNamenDic description]);
               }
               
            }//tempZiffernName in Liste
            
         }//if count==2
         
      }//if aif
   }//while StimmenNamenEnum
   
   //NSLog(@"StimmenNamenArrayAusResources	tempStimmenNamenArray: %@",[tempStimmenNamenArray description]);
   
   return tempStimmenNamenArray;
}


- (NSDictionary*)QuittungNamenArrayDicAusResources
{
   //Neu
   //vorhandene userdef. Namen von QuittungsKlassen
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //BOOL StimmenArrayOK=YES;
   NSString* ResourcenPfad=[[NSBundle mainBundle]resourcePath];
   //NSLog(@"QuittungNamenArrayDicAusResources ResourcenPfad: %@" , ResourcenPfad);
   NSString *str=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Zahlen_AIFF"];
   //NSLog(@"QuittungNamenArrayDicAusResources str: %@" , str);
   
   //Zahlen.plist lesen: Liste der benötigten Ziffern
   NSDictionary* tempQuittungPListDic;
   int anzQuittungen=0;
   NSString* QuittungPlistPfad=[ResourcenPfad stringByAppendingPathComponent:@"Quittung.plist"];
   if ([Filemanager fileExistsAtPath:QuittungPlistPfad])
   {
      tempQuittungPListDic=[NSDictionary dictionaryWithContentsOfFile:QuittungPlistPfad];
      //NSLog(@"tempQuittungPListDic: %@",[tempQuittungPListDic description]);
      
   }
   else
   {
      NSLog(@"Keine QuittungPListDic");
      
   }
   NSArray* KeyArray=[tempQuittungPListDic allKeys];
   
   //NSLog(@"tempQuittungPListDic: %@   KeyArray: %@",[tempQuittungPListDic description],[KeyArray description]);
   
   NSArray* PListQuittungNamenArray=[tempQuittungPListDic allKeys];//Alle notwendigen QuittungKlassennnamen
   anzQuittungen=[PListQuittungNamenArray count];
   
   NSArray* tempQuittungenArray=[Filemanager contentsOfDirectoryAtPath:ResourcenPfad error:NULL];//Liste der vorhandenen Quittungen
			
			NSMutableDictionary* QuittungNamenArrayDic=[[NSMutableDictionary alloc]initWithCapacity:0];	//Dic mit Namen der zusätzlichen Q.
			
			NSEnumerator* QuittungenNamenEnum=[tempQuittungenArray objectEnumerator];
			id eineQuittung;
			while (eineQuittung=[QuittungenNamenEnum nextObject])
         {
            if( [[eineQuittung pathExtension]isEqualToString:@"aif"])
            {
               NSArray* tempQuittungNamenTeileArray=[eineQuittung componentsSeparatedByString:@"_"];
               //			NSLog(@"aif. eineQuittung: %@  tempQuittungNamenTeileArray: %@", eineQuittung,[tempQuittungNamenTeileArray description]);
               NSEnumerator* QuittungListeEnum=[PListQuittungNamenArray objectEnumerator];
               id eineQuittungKlasse;
               while (eineQuittungKlasse=[QuittungListeEnum nextObject])
               {
                  //NSLog(@"eineQuittungKlasse: %@",eineQuittungKlasse);
                  if ([[QuittungSelektionDic objectForKey: eineQuittungKlasse]isEqualToString:@"home"])//home ausgewählt fuer die Quittungsklasse
                  {
                     if ([tempQuittungNamenTeileArray count]==1)//nur ein Teil
                     {
                        if ([[eineQuittung stringByDeletingPathExtension]isEqualToString:eineQuittungKlasse])
                        {
                           //NSLog(@"home:		eineZahl: nur 1 Element",eineQuittung);
                           
                           
                        }
                     }
                     
                  }
                  //else
                  {
                     
                     if ([tempQuittungNamenTeileArray count]==2)
                     {
                        //NSLog(@"aif. eineQuittung: %@  tempQuittungNamenTeileArray: %@", eineQuittung,[tempQuittungNamenTeileArray description]);
                        //NSLog(@"eineQuittungKlasse: %@",eineQuittungKlasse);
                        NSString* tempQuittungName=[tempQuittungNamenTeileArray objectAtIndex:0];
                        NSString* tempQuittungKlasse=[[tempQuittungNamenTeileArray objectAtIndex:1]stringByDeletingPathExtension];
                        //NSString* tempKlasseName=[QuittungSelektionDic objectForKey: eineQuittungKlasse];//ausgewählter Name fuer Klasse
                        //NSLog(@"Klasse: %@	tempKlasseName: %@	eineQuittung: %@",eineQuittungKlasse,tempKlasseName,eineQuittung);
                        //NSLog(@"tempQuittungNamen: %@  tempQuittungKlasse: %@",tempQuittungNamen,tempQuittungKlasse);
                        
                        if ([tempQuittungKlasse isEqualToString:eineQuittungKlasse])
                        {
                           
                           NSMutableArray* tempQuittungNamenArray;
                           //[tempQuittungNamenArray addObject:eineQuittung];
                           tempQuittungNamenArray=(NSMutableArray*)[QuittungNamenArrayDic objectForKey:eineQuittungKlasse];
                           
                           if (tempQuittungNamenArray)//
                           {
                              //NSLog(@"tempQuittungNamenArray add eineQuittung: %@: Array: %@",eineQuittung,[tempQuittungNamenArray description]);
                              
                              [tempQuittungNamenArray addObject:tempQuittungName];
                           }
                           else
                           {
                              //NSLog(@"tempQuittungNamenArray neu: eineQuittung: %@",eineQuittung);
                              tempQuittungNamenArray=[[NSMutableArray alloc]initWithArray:[NSArray arrayWithObject:tempQuittungName]];
                              [QuittungNamenArrayDic setObject: tempQuittungNamenArray forKey:eineQuittungKlasse];
                           }
                           
                        }
                     }//count==2
                  }
                  
               }//while
            }//if aif
         }//while QuittungenNamenEnum
			
			//NSLog(@"QuittungNamenArrayAusResources	QuittungNamenArrayDic: %@",[QuittungNamenArrayDic description]);
			
			return QuittungNamenArrayDic;
}




- (BOOL)readZahlen
{
   BOOL readOK=YES;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* ResourcenPfad=[[NSBundle mainBundle]resourcePath];
   NSArray* tempZahlenArray=[Filemanager contentsOfDirectoryAtPath:[ResourcenPfad stringByAppendingPathComponent:@"Zahlen_AIFF"] error:NULL];
   //NSLog(@"\n         tempZahlenArray roh: \n%@",[tempZahlenArray description]);
   
   
   NSMutableArray* AIFFArray=[[NSMutableArray alloc]initWithCapacity:0];	//Array mit Namen der aif-Zahlen
   
   NSEnumerator* ZahlenEnum=[tempZahlenArray objectEnumerator];
   id eineZahl;
   while (eineZahl=[ZahlenEnum nextObject])
   {
      if ([eineZahl hasSuffix:@"aif"])
      {
         NSArray* tempZahlNamenArray=[eineZahl componentsSeparatedByString:@"_"];
         //NSLog(@"aif. Stimme:  %@ tempZahlNamenArray: %@",Stimme, [tempZahlNamenArray description]);
         //NSLog(@"aif.  tempZahlNamenArray: %@", [tempZahlNamenArray description]);
         
         if ([Stimme isEqualToString:@"home"])
         {
            //	NSLog(@"home: eineZahl: %@",eineZahl);
            if ([tempZahlNamenArray count]==1)//nur ein teil
            {
               //NSLog(@"home:		eineZahl: nur 1 Element",eineZahl);
               [AIFFArray addObject:[tempZahlNamenArray lastObject]];
            }
         }
         else
         {
            //NSLog(@"eineZahl: %@",eineZahl);
            if (([tempZahlNamenArray count]==2)&&[[tempZahlNamenArray objectAtIndex:0]isEqualToString:Stimme])
            {
               //NSLog(@"Stimme: %@		eineZahl: %@",Stimme,eineZahl);
               //'Stimme' ist erster Teil des Ziffernnamens
               //[AIFFArray addObject:[tempZahlNamenArray lastObject]];
               [AIFFArray addObject:eineZahl];
            }
            
         }
      }//if .aif
   }//while
   
   //	NSLog(@"readZahlen: Stimme: \n%@\nAIFFArray: %@\n",Stimme,[AIFFArray description]);
   //	NSLog(@"readZahlen: Stimme: %@\nAIFFArray count: %d\n",Stimme,[AIFFArray count]);
   
   NSString* ZahlenPlistPfad=[ResourcenPfad stringByAppendingPathComponent:@"Zahlen.plist"];
   
   if ([Filemanager fileExistsAtPath:ZahlenPlistPfad])
   {
      //Dic mit Namen und ResNummern
      ZahlenPlistDic=[[NSDictionary dictionaryWithContentsOfFile:ZahlenPlistPfad]mutableCopy];
      //NSLog(@"ZahlenPlistDic: %@",[ZahlenPlistDic description]);
   }
   
   
   
   
   NSMutableArray* tempZahlenDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   int index=0;
   NSEnumerator* AIFFEnum=[AIFFArray objectEnumerator];
   id einName;
   
   while (einName=[AIFFEnum nextObject])
   {
      NSString* tempName=[einName stringByDeletingPathExtension];
      NSArray* tempNamenArray=[tempName componentsSeparatedByString:@"_"];
      NSString* PListName=[tempNamenArray lastObject];//Name der Ziffer
      //NSLog(@"tempName: %@  PListName: %@",tempName,PListName);
      
      NSString* IDausPlist=[ZahlenPlistDic objectForKey:PListName];//in PList vorhanden
      //NSLog(@"IDausPlist: %@  ",IDausPlist); // nummer des sounds, 5-stellig
      
      
      if (IDausPlist)
      {
         NSString* tempAIFFPfad=[[ResourcenPfad stringByAppendingPathComponent:@"Zahlen_AIFF"] stringByAppendingPathComponent:einName ];
         
         NSURL *	tempZahlUrl = [NSURL fileURLWithPath:tempAIFFPfad];
         //NSLog(@"tempName: %@  tempAIFFPfad: %@",tempName,tempAIFFPfad);
         
         if ([Filemanager fileExistsAtPath:tempAIFFPfad])
         {
            NSMutableDictionary* tempMovieDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [tempMovieDic setObject:tempAIFFPfad forKey:@"zahlpfad"];
            [tempMovieDic setObject:tempZahlUrl forKey:@"zahlurl"];
            [tempMovieDic setObject:tempName forKey:@"name"];
            [tempMovieDic setObject:IDausPlist forKey:@"ID"];
            [tempZahlenDicArray addObject:tempMovieDic];
         }
         else
         {
            NSLog(@"tempName err bei %@",einName);
         }
      }
      else
      {
         readOK=NO;
      }
      index++;
   }//while
   
   //NSLog(@"tempZahlenArray: %@",[tempZahlenArray description]);
   
   NSSortDescriptor* desc=[[NSSortDescriptor alloc] initWithKey:@"ID" ascending: YES];
   //	NSArray* sortArray=[tempZahlenArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:desc,nil]];
   
   ZahlenDicArray=[NSArray arrayWithArray:[tempZahlenDicArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:desc,nil]]];
   //NSLog(@"readZahlen	  ZahlenDicArray: %@	",[ZahlenDicArray description]);
   
   
   return readOK;
   
}

- (BOOL)readQuittungen
{
   // NSLog(@"readQuittungen start");
   OSErr err;
   //  NSLog(@"readQuittungen QuittungenMovie err: %d",err);
   BOOL readOK=YES;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* ResourcenPfad=[[NSBundle mainBundle]resourcePath];
   // NSLog(@"readQuittungen ResourcenPfad: %@",ResourcenPfad);
   //Array mit Inhalt von resources
   
   //NSLog(@"readQuittungen Array Pfad: %@",[ResourcenPfad stringByAppendingPathComponent:@"Quittung_AIFF"]);
   
   // vorhandene Quittungen suchen
   NSArray* tempQuittungArray=[Filemanager contentsOfDirectoryAtPath:[ResourcenPfad stringByAppendingPathComponent:@"Quittung_AIFF"] error:NULL];
   
   //NSLog(@"tempQuittungArray roh: %@\n",[tempQuittungArray description]);
   /*
    "falsch.aif",
    "falscheszeichen.aif",
    "Fertig2.aiff",
    "Quietschende Bremsen",
    "richtig.aif",
    "richtig2.aif",
    "seriefertig.aif",
    "seriefertig2.aif",
    */
   
   
   NSString* QuittungPlistPfad=[ResourcenPfad stringByAppendingPathComponent:@"Quittung.plist"];
   
   //liste der notwendigen Quittungen in der PList suchen
   if ([Filemanager fileExistsAtPath:QuittungPlistPfad])
   {
      //Dic der erforderlichen Quittungen mit ID
      QuittungPlistDic=[NSDictionary dictionaryWithContentsOfFile:QuittungPlistPfad];//Dic mit Namen und ResNummern
   }
  // NSLog(@"readQuittungen QuittungPlistDic: %@",[QuittungPlistDic description]);
   /*
    falsch = 25002;
    falscheszeichen = 25005;
    richtig = 25001;
    seriefertig = 25003;
    */
   
   
   int index=0;
   NSMutableArray* AIFFArray=[[NSMutableArray alloc]initWithCapacity:0];	//Array mit Namen der aif-Quittungen
   
   
   NSEnumerator* QuittungEnum=[tempQuittungArray objectEnumerator];
   id eineQuittung;
   while (eineQuittung=[QuittungEnum nextObject])
   {
      if ([eineQuittung hasSuffix:@"aif"])
      {
         //Namen aufteilen. home-Namen haben nur einen Teil
         NSArray* tempQuittungNamenTeileArray=[eineQuittung componentsSeparatedByString:@"_"];
         //NSLog(@"aif. eineQuittung: %@  tempQuittungNamenTeileArray: %@", eineQuittung,[tempQuittungNamenTeileArray description]);
         
         NSEnumerator* QuittungListeEnum=[[QuittungPlistDic allKeys]objectEnumerator];
         id eineQuittungKlasse;
         while (eineQuittungKlasse=[QuittungListeEnum nextObject])//notwendige Klassennamen
         {
            //				NSLog(@"eineQuittungKlasse: %@",eineQuittungKlasse);
            
            if ([[QuittungSelektionDic objectForKey: eineQuittungKlasse]isEqualToString:@"home"])//home ausgewählt fuer die Quittungsklasse
            {
               if ([tempQuittungNamenTeileArray count]==1)//nur ein Teil
               {
                  if ([[eineQuittung stringByDeletingPathExtension]isEqualToString:eineQuittungKlasse])
                  {
                     //							NSLog(@"home:		eineZahl: nur 1 Element",eineQuittung);
                     
                     [AIFFArray addObject:eineQuittung];
                  }
               }
               
            }
            //else
            {
               
               if ([tempQuittungNamenTeileArray count]==2)//User-Klassen haben 2 Teile getrennt durch '_'
               {
                  //NSLog(@"aif. eineQuittung: %@  tempQuittungNamenTeileArray: %@", eineQuittung,[tempQuittungNamenTeileArray description]);
                  //NSLog(@"eineQuittungKlasse: %@",eineQuittungKlasse);
                  NSString* tempQuittungNamen=[tempQuittungNamenTeileArray objectAtIndex:0];//User-definierter Name
                  NSString* tempQuittungKlasse=[[tempQuittungNamenTeileArray objectAtIndex:1]stringByDeletingPathExtension];
                  //NSString* tempKlasseName=[QuittungSelektionDic objectForKey: eineQuittungKlasse];//ausgewählter Name fuer Klasse
                  //NSLog(@"Klasse: %@	tempKlasseName: %@	eineQuittung: %@",eineQuittungKlasse,tempKlasseName,eineQuittung);
                  //NSLog(@"tempQuittungNamen: %@  tempQuittungKlasse: %@",tempQuittungNamen,tempQuittungKlasse);
                  
                  if ([tempQuittungKlasse isEqualToString:eineQuittungKlasse])//Objekt gehört zur Klasse
                  {
                     [AIFFArray addObject:eineQuittung];
                  }
               }//count==2
            }
            
         }//while
      }
   }//while
   //NSLog(@"readQuittungen:		AIFFArray: %@ \n",[AIFFArray description]);
   /*
    "falsch.aif",
    "falscheszeichen.aif",
    "richtig.aif",
    "seriefertig.aif"
    */
   //NSLog(@"AIFFArray Anzahl: %d ",[AIFFArray count]);
   //NSLog(@"");
   //NSLog(@"readQuittungen start mit Selektion:		QuittungSelektionDic: %@ \n",[QuittungSelektionDic description]);
   
   NSMutableArray* tempQuittungDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   //Klassen abfragen
   NSEnumerator* QuittungListeEnum=[[QuittungPlistDic allKeys] objectEnumerator];//erforderliche Klassennamen
   
   id eineQuittungKlasse;
   //	while (eineQuittungKlasse=[QuittungListeEnum nextObject])
   {
      /*
       NSString* tempMovieName=@"";
       //selektierter Name fuer Klasse:
       NSString* tempSelectedKlasseName=[QuittungSelektionDic objectForKey:eineQuittungKlasse];
       if (!tempSelectedKlasseName)
       {
       tempSelectedKlasseName=@"home";
       }
       //		NSLog(@"\neineQuittungKlasse: %@   tempSelectedKlasseName: %@",eineQuittungKlasse,tempSelectedKlasseName);
       NSString* tempMoviePfad;
       NSString* IDausPlist=[QuittungPlistDic objectForKey:eineQuittungKlasse];//in PList vorhanden
       NSLog(@"\neineQuittungKlasse: %@   tempSelectedKlasseName: %@  IDausPlist: %@",eineQuittungKlasse,tempSelectedKlasseName,IDausPlist);
       */
      
      //AIFFArray durchsuchen
      NSEnumerator* AIFFEnum=[AIFFArray objectEnumerator];
      id einName;
      while (einName=[AIFFEnum nextObject])
      {
         NSString* tempName=[einName stringByDeletingPathExtension];
         NSArray* tempQuittungNamenArray=[tempName componentsSeparatedByString:@"_"];
         NSString* PListName=[tempQuittungNamenArray lastObject];//Klasse der Quittung
         
         //NSLog(@"tempName: %@  PListName: %@",tempName,PListName);
         NSString* IDausPlist=[QuittungPlistDic objectForKey:PListName];//in PList vorhanden
         
         /*
          //if ([[tempQuittungKlasse stringByDeletingPathExtension] isEqualToString:eineQuittungKlasse])//Die Klasse stimmt
          {
          switch ([tempQuittungNamenTeileArray count])
          {
          case 1://nur ein Teil
          {
          }break;
          
          case 2://2 Teile
          {
          }break;
          //default:
          //tempMovieName=[eineQuittungKlasse stringByAppendingPathExtension:@"aif"];//sicher ist sicher
          }//switch
          }//Klasse stimmt
          */
         if (IDausPlist)
         {
            NSString* tempAIFFPfad=[[ResourcenPfad stringByAppendingPathComponent:@"Quittung_AIFF"] stringByAppendingPathComponent:einName];
            
            NSURL *	tempQuittungUrl = [NSURL fileURLWithPath:tempAIFFPfad];
            if ([Filemanager fileExistsAtPath:tempAIFFPfad])
            {
               NSMutableDictionary* tempMovieDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               [tempMovieDic setObject:tempAIFFPfad forKey:@"quittungpfad"];
               [tempMovieDic setObject:tempQuittungUrl forKey:@"quittungurl"];
               [tempMovieDic setObject:IDausPlist forKey:@"ID"];
               [tempMovieDic setObject:[einName stringByDeletingPathExtension] forKey:@"name"];
               
               [tempQuittungDicArray addObject:tempMovieDic];
            }
         }
         
         
      }//while einName
      
      
      
      
   }//while eineQuittungKlasse
   
   
   //NSLog(@"readQuittungen tempQuittungDicArray: %@",[tempQuittungDicArray description]);
   
   NSSortDescriptor* desc=[[NSSortDescriptor alloc] initWithKey:@"ID" ascending: YES];
   //NSArray* sortArray=[tempZahlenArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:desc,nil]];
   QuittungDicArray=[[tempQuittungDicArray copy] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:desc,nil]];
   //NSLog(@"");
   //NSLog(@"readQuittungen readOK: %d QuittungZahlenArray: %@",readOK,[QuittungZahlenArray description]);
   //NSArray* ValueArray = [QuittungZahlenArray valueForKey:@"ID"];
   //NSLog(@"readQuittungen ValueArray: %@",[ValueArray description]);
   return readOK;
   
}

- (NSURL*)URLvonZahl:(int)zahl
{
   return nil;
}



- (NSArray*)URLArrayvonZahl:(int)dieZahl
{
   /* Element von ZahlenDicArry
    {
    ID = 20002;
    name = zwei;
    zahlpfad = "/Users/ruediheimlicher/Library/Developer/Xcode/DerivedData/SndCalcX-ayfiljreolpoegebabuxkrhzucjq/Build/Products/Debug/SndCalcX.app/Contents/Resources/Zahlen_AIFF/zwei.aif";
    zahlurl = "file:///Users/ruediheimlicher/Library/Developer/Xcode/DerivedData/SndCalcX-ayfiljreolpoegebabuxkrhzucjq/Build/Products/Debug/SndCalcX.app/Contents/Resources/Zahlen_AIFF/zwei.aif";
    },
    
    */
   NSFileManager* fm = [NSFileManager defaultManager];
   NSMutableArray* fehlerarray = [[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* tempURLArray = [[NSMutableArray alloc]initWithCapacity:0];
   //NSLog(@"setQTKitZahlTrackVon: %d derOffset: %lld",dieZahl, derOffset.timeValue);
   NSArray* IDArray=[ZahlenDicArray valueForKey:@"ID"];
   //NSLog(@"IDArray: %@",[IDArray description]);
   int GermanOffset=20000;
   int IDOffset=GermanOffset;
   int FehlendeZahl=0;
   NSUInteger ZehnIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:IDOffset+10] stringValue]];
   if (ZehnIndex == NSNotFound)//Zahl nicht im Array
   {
      FehlendeZahl=10;
      [fehlerarray addObject:[NSNumber numberWithInt:10]];
      NSLog(@"zehnfehler");
      //		goto bail;
   }
   //NSLog(@"ZehnIndex: %ld\t%ld",ZehnIndex,(long)ZehnIndex);
   NSString* zehnPfad = [[ZahlenDicArray objectAtIndex:ZehnIndex]objectForKey:@"zahlpfad"];
   // NSLog(@"zehnPfad: %@",zehnPfad);
   
   if ([fm fileExistsAtPath:zehnPfad])
   {
      //[tempURLArray addObject:[NSURL fileURLWithPath:zehnPfad]];
   }
   
   NSUInteger HundertIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:IDOffset+100] stringValue]];
   if (HundertIndex == NSNotFound)
   {
      NSLog(@"hundertfehler");
      [fehlerarray addObject:[NSNumber numberWithInt:100]];
      //return QTZeroTime;
   }
   // NSLog(@"HundertIndex: %ld",HundertIndex);
   NSString* hundertPfad = [[ZahlenDicArray objectAtIndex:HundertIndex]objectForKey:@"zahlpfad"];
   
   NSUInteger TausendIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:IDOffset+1000] stringValue]];
   if (TausendIndex == NSNotFound)
   {
      NSLog(@"tausendfehler");
      [fehlerarray addObject:[NSNumber numberWithInt:1000]];
      //return QTZeroTime;
   }
   //NSLog(@"TausendIndex: %ld",TausendIndex);
   NSString* tausendPfad = [[ZahlenDicArray objectAtIndex:TausendIndex]objectForKey:@"zahlpfad"];
   
   // Tausender feststellen
   int Tausender=dieZahl/1000; //      TAUSENDER
   
   // Pfad dazu
   if (Tausender >0)			//Es hat Tausender
   {
      //NSLog(@"Beginn Tausender: %d",Tausender);
      // lage des Tausenders im Zahlarray feststellen
      NSUInteger TausenderIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:IDOffset+Tausender] stringValue]];
      if (TausenderIndex == NSNotFound )
      {
         NSLog(@"tausenderfehler");
         [fehlerarray addObject:[NSNumber numberWithInt:Tausender]];
         //return QTZeroTime;
      }
      // NSLog(@"TausenderIndex: %ld",TausenderIndex);
      NSString* tausenderPfad = [[ZahlenDicArray objectAtIndex:TausenderIndex]objectForKey:@"zahlpfad"];
      
      // Tracks einsetzen
      if ([fm fileExistsAtPath:tausenderPfad])
      {
         [tempURLArray addObject:[NSURL fileURLWithPath:tausenderPfad]];
      }
      [tempURLArray addObject:[NSURL fileURLWithPath:tausendPfad]];
      
   }// if Tausender
   
   //														HUNDERTER
   
   int Hunderter=(dieZahl%1000)/100;
   // Pfad dazu
   
   if (Hunderter>0)			//Es hat Hunderter
   {
      //NSLog(@"Beginn Hunderter: %d",Hunderter);
      int HunderterID=IDOffset+Hunderter;
      if ((Hunderter>1)||((Hunderter==1)&&(Tausender>0)))//Mehr als ein Hunderter oder mit Tausendern
      {
         if (Hunderter==1) // 'ein' anstatt 'eins'
         {
            HunderterID+=1000;
         }
         
         NSUInteger HunderterIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:HunderterID] stringValue]];
         if (HunderterIndex == NSNotFound)
         {
            NSLog(@"hunderterfehler");
            [fehlerarray addObject:[NSNumber numberWithInt:Hunderter]];
            //return QTZeroTime;
         }
         //    NSLog(@"HunderterIndex: %ld",HunderterIndex);
         NSString* hunderterPfad = [[ZahlenDicArray objectAtIndex:HunderterIndex]objectForKey:@"zahlpfad"];
         
         
         // Track fuer Hunderter einsetzen
         if ([fm fileExistsAtPath:hunderterPfad])
         {
            [tempURLArray addObject:[NSURL fileURLWithPath:hunderterPfad]];
         }
         [tempURLArray addObject:[NSURL fileURLWithPath:hundertPfad]];
         
      }
      
      
      
   }//if Hunderter>0
   //NSLog(@"Ende Hunderter");
   
   
   //														ZEHNER
   
   int Zehner=((dieZahl%1000)%100)/10;
   int ZehnerID=0;
   
   //														EINER
   int Einer=dieZahl%10; // modulo
   int EinerID=0;
   int UndID=0;
   
   if (Zehner>0)			// Es hat Zehner
   {
      if (Zehner>1)		// Ab 20
      {
         if (Einer>0)
         {
            EinerID=IDOffset+Einer;
            if (Einer==1)
            {
               EinerID+=1000;	//		"ein"
            }
            NSUInteger EinerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:EinerID] stringValue]];
            //NSLog(@"EinerIndex");
            
            if (EinerIndex == NSNotFound)
            {
               NSLog(@"Zehner>1 einerfehler: %d index: %ld",Einer,EinerIndex);
               [fehlerarray addObject:[NSNumber numberWithInt:Einer]];
               
            }
            NSString* einerPfad = [[ZahlenDicArray objectAtIndex:EinerIndex]objectForKey:@"zahlpfad"];
            
            
            
            if ((Zehner==2)||(Zehner==3)||(Zehner==6))	// Zahlen mit "un"
            {
               if (Einer>0)
               {
                  UndID=IDOffset+kUn;
               }
            }
            else                                         // Zahlen mit "und"
            {
               if (Einer>0)
               {
                  UndID=IDOffset+kUnd;
               }
               
            }
            
            NSUInteger UndIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:UndID] stringValue]];
            //NSLog(@"UndIndex");
            if (UndIndex == NSNotFound)
            {
               NSLog(@"undfehler");
               [fehlerarray addObject:@"und"];
            }
            NSString* undPfad = [[ZahlenDicArray objectAtIndex:UndIndex]objectForKey:@"zahlpfad"];
            
            // Einer einsetzen
            // Track fuer Einer einsetzen
            if ([fm fileExistsAtPath:einerPfad])
            {
               [tempURLArray addObject:[NSURL fileURLWithPath:einerPfad]];
            }
            
            // "und" einsetzen: Es folgen noch Zehner
            // Track fuer "und" einsetzen
            if ([fm fileExistsAtPath:undPfad])
            {
               [tempURLArray addObject:[NSURL fileURLWithPath:undPfad]];
            }
            
            
            
            //NSLog(@"setZahlTrack ende einer");
         }//  if einer>0 (zehner >0)
         
         ZehnerID=IDOffset+10*Zehner;		// "-ig anhängen: Zehner=2 muss fuer die ID 20 geben
         NSUInteger ZehnerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:ZehnerID] stringValue]];
         //NSLog(@"ZehnerIndex");
         if (ZehnerIndex == NSNotFound)
         {
            NSLog(@"zehnerfehler");
            [fehlerarray addObject:[NSNumber numberWithInt:Zehner]];
         }
         NSString* zehnerPfad = [[ZahlenDicArray objectAtIndex:ZehnerIndex]objectForKey:@"zahlpfad"];
         
         
         // Zehner einsetzen
         // Track fuer Zehner einsetzen
         if ([fm fileExistsAtPath:zehnerPfad])
         {
            [tempURLArray addObject:[NSURL fileURLWithPath:zehnerPfad]];
         }
         
      }           // if Zehner>1
      else        //	10 - 19
      {
         if ((Einer>=0)&&(Einer<=2))//10,11,12
         {
            EinerID=IDOffset+10+Einer;
            NSUInteger EinerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:EinerID] stringValue]];
            //NSLog(@"EinerIndex");
            
            if (EinerIndex == NSNotFound)
            {
               NSLog(@"(Einer>=0)&&(Einer<=2)einerfehler: %d index: %ld",Einer,EinerIndex);
               [fehlerarray addObject:[NSNumber numberWithInt:Einer]];
            }
            NSString* einerPfad = [[ZahlenDicArray objectAtIndex:EinerIndex]objectForKey:@"zahlpfad"];
            
            // Einer einsetzen
            // Track fuer Einer einsetzen
            if ([fm fileExistsAtPath:einerPfad])
            {
               [tempURLArray addObject:[NSURL fileURLWithPath:einerPfad]];
            }
            
         }
         else //13 - 19
         {
            
            EinerID=IDOffset+Einer;
            
            if ((Einer==6) || (Einer==7) || (Einer==8))//17, 18. 19
            {
               EinerID+=1000;
            }
            
            NSUInteger EinerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:EinerID] stringValue]];
            //NSLog(@"EinerIndex");
            
            if (EinerIndex == NSNotFound)
            {
               NSLog(@"13 - 19 einerfehler: %d index: %ld",Einer,EinerIndex);
               [fehlerarray addObject:[NSNumber numberWithInt:Einer]];
            }
            NSString* einerPfad = [[ZahlenDicArray objectAtIndex:EinerIndex]objectForKey:@"zahlpfad"];
            
            // Einer einsetzen
            // Track fuer Einer einsetzen
            if ([fm fileExistsAtPath:einerPfad])
            {
               [tempURLArray addObject:[NSURL fileURLWithPath:einerPfad]];
            }
            
            
            //		Zehner von 13 - 19
            ZehnerID=IDOffset+10;
            NSUInteger ZehnerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:ZehnerID] stringValue]];
            //NSLog(@"ZehnerIndex");
            if (ZehnerIndex == NSNotFound)
            {
               NSLog(@"zehnerfehler");
               [fehlerarray addObject:[NSNumber numberWithInt:Zehner]];
            }
            NSString* zehnerPfad = [[ZahlenDicArray objectAtIndex:ZehnerIndex]objectForKey:@"zahlpfad"];
            
            // Zehner einsetzen
            // Track fuer Zehner einsetzen
            if ([fm fileExistsAtPath:zehnerPfad])
            {
               [tempURLArray addObject:[NSURL fileURLWithPath:zehnerPfad]];
            }
            
         }
         
      }
      //NSLog(@"setZahlTrack ende Zehner vor nur einer");
   }//if Zehner>0
   
   else if (Einer)	//nur Einer
   {
      
      EinerID=IDOffset+Einer;
      NSUInteger EinerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:EinerID] stringValue]];
      //NSLog(@"Nur Einer: EinerIndex: %d",EinerIndex);
      
      if (EinerIndex == NSNotFound)
      {
         NSLog(@"nur Einer einerfehler: %d index: %ld",Einer,EinerIndex);
         [fehlerarray addObject:[NSNumber numberWithInt:Einer]];
      }
      NSString* einerPfad = [[ZahlenDicArray objectAtIndex:EinerIndex]objectForKey:@"zahlpfad"];
      
      // Track fuer Einer einsetzen
      if ([fm fileExistsAtPath:einerPfad])
      {
         [tempURLArray addObject:[NSURL fileURLWithPath:einerPfad]];
      }
      
      
   }
   //	NSLog(@"Zahl: %d Tausender: %d Hunderter: %d Zehner: %d Einer: %d",dieZahl,Tausender,Hunderter, Zehner, Einer);
   //   [AufgabenQTKitMovie play];
   
   
   
   if (fehlerarray.count)
   {
      NSLog(@"fehlerarray: %@",fehlerarray);
      [fehlerarray addObject:@"fehler"];
      return fehlerarray;
   }
   //NSLog(@"tempURLArray: %@",tempURLArray);
   if (tempURLArray.count)
   {
      return tempURLArray;
   }
   return nil;
}

- (NSURL*)URLvonOperation:(int)dieOperation
{
   
   
   NSFileManager* fm = [NSFileManager defaultManager];
   NSMutableArray* fehlerarray = [[NSMutableArray alloc]initWithCapacity:0];
   //NSMutableArray* tempURLArray = [[NSMutableArray alloc]initWithCapacity:0];
   //NSLog(@"setQTKitZahlTrackVon: %d derOffset: %lld",dieZahl, derOffset.timeValue);
   NSArray* IDArray=[ZahlenDicArray valueForKey:@"ID"];
   NSArray* NameArray=[ZahlenDicArray valueForKey:@"name"];
   //NSLog(@"IDArray: %@",[IDArray description]);
   //NSLog(@"NameArray: %@",[NameArray description]);
   int GermanOffset=20000;
   int IDOffset=GermanOffset;
   int FehlendeOperation=0;
   NSString* Operator;
   switch(dieOperation-2000)
   {
      case 1://Plus
      {
         Operator=@"plus";
      }break;
         
      case 2://Minus
      {
         Operator=@"minus";
      }break;
         
         
      case 3://Mal
      {
         Operator=@"mal";
      }break;
   }//switch
   
   long OpIndex=[NameArray indexOfObject:Operator];
   
   
   
   if (OpIndex == NSNotFound)//Zahl nicht im Array
   {
      FehlendeOperation=10;
      [fehlerarray addObject:[NSNumber numberWithInt:dieOperation]];
      NSLog(@"FehlendeOperation: %@",Operator);
      //		goto bail;
   }
   //NSLog(@"OpIndex: %ld\t%ld",OpIndex,(long)ZehnIndex);
   NSString* opPfad = [[ZahlenDicArray objectAtIndex:OpIndex]objectForKey:@"zahlpfad"];
   //NSLog(@"opPfad: %@",opPfad);
   
   if ([fm fileExistsAtPath:opPfad])
   {
      NSURL* opURL = [NSURL fileURLWithPath:opPfad];
      return opURL;
   }
   
   return nil;
}

//- (NSURL*)URLvonQuittung:(NSString*)dieQuittung
- (NSURL*)URLvonQuittung:(int)dieQuittung
{
   NSFileManager* fm = [NSFileManager defaultManager];
   NSMutableArray* fehlerarray = [[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* tempURLArray = [[NSMutableArray alloc]initWithCapacity:0];
   //NSLog(@"URLvonQuittung: %d derOffset: %lld",dieZahl, derOffset.timeValue);
   NSArray* IDArray=[QuittungDicArray valueForKey:@"ID"]; // ID der Quittungen, 25001-25005
   NSArray* NameArray=[QuittungDicArray valueForKey:@"name"];
   //NSLog(@"QuittungDicArray: %@",[[QuittungDicArray objectAtIndex:0] description]);
   //NSLog(@"Quittung IDArray: %@,Quittung: %d",[IDArray description], dieQuittung);
   //NSLog(@"NameArray: %@",[NameArray description]);
   int GermanOffset=20000;
   int IDOffset=GermanOffset;
   int FehlendeZahl=0;
   
   //long QuittungIndex=[NameArray indexOfObject:dieQuittung];
   long QuittungIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:dieQuittung] stringValue]];
   
   
   
   if (QuittungIndex == NSNotFound)//Zahl nicht im Array
   {
      [fehlerarray addObject:[NSNumber numberWithInt:dieQuittung]];
      NSLog(@"FehlendeQuittung: %d",dieQuittung);
      //		goto bail;
   }
   //NSLog(@"OpIndex: %ld\t%ld",OpIndex,(long)ZehnIndex);
   NSString* quittungPfad = [[QuittungDicArray objectAtIndex:QuittungIndex]objectForKey:@"quittungpfad"];
   //NSLog(@"opPfad: %@",opPfad);
   
   if ([fm fileExistsAtPath:quittungPfad])
   {
      NSURL* quittungURL = [NSURL fileURLWithPath:quittungPfad];
      return quittungURL;
   }
   return nil;
}




- (BOOL)AufgabeAb:(NSDictionary*)derAufgabenDic
{
   BOOL AufgabeOK=YES;
   
   if (derAufgabenDic)
   {
      
      
      int Aufgabennummer=0;
      NSNumber* AufgabenNumber=[derAufgabenDic objectForKey:@"aufgabennummer"];
      if (AufgabenNumber)
      {
         Aufgabennummer=[AufgabenNumber intValue];
      }
      
      int var0=0,var1=0,var2=0,op0=1;;
      NSNumber* Var0Number=[derAufgabenDic objectForKey:@"var0"];
      if (Var0Number)
      {
         var0=[Var0Number intValue];
      }
      NSNumber* Var1Number=[derAufgabenDic objectForKey:@"var1"];
      if (Var1Number)
      {
         var1=[Var1Number intValue];
      }
      NSNumber* Op0Number=[derAufgabenDic objectForKey:@"op0"];
      if (Op0Number)
      {
         op0=[Op0Number intValue];
      }
      NSNumber* Var2Number=[derAufgabenDic objectForKey:@"var2"];
      if (Var2Number)
      {
         var2=[Var2Number intValue];
      }
      //NSLog(@"AufgabeAb: Nummer: %d var0: %d var1: %d op0: %d var2: %d",Aufgabennummer,var0,var1,op0,var2);
      //NSLog(@"AufgabeAb: Nummer: var0:%d",var0);
      /* Element von ZahlenDicArry
       {
       ID = 20002;
       name = zwei;
       zahlpfad = "/Users/ruediheimlicher/Library/Developer/Xcode/DerivedData/SndCalcX-ayfiljreolpoegebabuxkrhzucjq/Build/Products/Debug/SndCalcX.app/Contents/Resources/Zahlen_AIFF/zwei.aif";
       zahlurl = "file:///Users/ruediheimlicher/Library/Developer/Xcode/DerivedData/SndCalcX-ayfiljreolpoegebabuxkrhzucjq/Build/Products/Debug/SndCalcX.app/Contents/Resources/Zahlen_AIFF/zwei.aif";
       },
       
       */
      NSArray* var0Array = [self URLArrayvonZahl:var0];
      NSArray* var1Array = [self URLArrayvonZahl:var1];
  //    NSArray* var2Array = [self URLArrayvonZahl:var2];
      
      NSURL* op0URL = [self URLvonOperation:op0];
      // NSURL* richtigURL = [self URLvonQuittung:@"richtig"];
 //     NSURL* richtigURL = [self URLvonQuittung:AUFGABERICHTIG];
      
      
      //    NSLog(@"var0Array: %@",var0Array);
      [QueueArray removeAllObjects];
      for (int i=0;i<var0Array.count;i++)
      {
         [QueueArray addObject:[[AVPlayerItem alloc] initWithURL:var0Array[i]]];
         
      }
      
      [QueueArray addObject:[[AVPlayerItem alloc] initWithURL:op0URL]];
      
      for (int i=0;i<var1Array.count;i++)
      {
         [QueueArray addObject:[[AVPlayerItem alloc] initWithURL:var1Array[i]]];
         
      }
      //   [QueueArray addObject:[[AVPlayerItem alloc] initWithURL:richtigURL]];
      
      //[QueueArray addObjectsFromArray:var0Array];
      
      if ([[AufgabenPlayerX items]count])
      {
         [AufgabenPlayerX removeAllItems];
      }
      AufgabenPlayerX = [AVQueuePlayer queuePlayerWithItems:QueueArray];
      /*
       }
       else
       {
       AufgabenPlayerX = [[AVQueuePlayer alloc]initWithItems:QueueArray];
       }
       */
      AufgabenPlayerX.volume = PlayerVolume;
      //NSLog(@"volume vor play: %2.2f",AufgabenPlayerX.volume   );
      [AufgabenPlayerX play];
      
      
      
   }//if tempAufgabenDic
   
   else
   {
      return NO;
   }
   return AufgabeOK;
}
- (void)playerItemDidReachEnd:(NSNotification *)notification {
   // Do stuff here
   //NSLog(@"AufgabenPlayerX actionAtItemEnd: %@",notification);
   if (AufgabenPlayerX.currentItem == AufgabenPlayerX.items.lastObject)
   {
      NSString* last =[AufgabenPlayerX.items.lastObject description];
      //NSLog(@"letztes item da: %@",last);
      if ([last containsString:@"Quittung_AIFF"]) // Quittungen abfangen, sollen kein postnotification auslösen
      {
         //NSLog(@"letztes item Quittung da: %@",last);
         return;
      }
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      // [nc removeObserver:self name:@"QTMovieDidEndNotification" object:nil];
      
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"fertig"];
      [nc postNotificationName:@"AufgabelesenFertig" object:nil userInfo:NotificationDic];
      
   }
   else
   {
      // NSLog(@"item da");
   }
}


- (void)AufgabeFertigAktion:(NSNotification*)note
{
   NSLog(@"Speaker AufgabeFertigAktion");
}

- (void)QTKitAufgabeFertigAktion:(NSNotification*)note
{
   NSLog(@"Speaker QTKitAufgabeFertigAktion");
}

- (void)QTKitQuittungFertig
{
   NSLog(@"Speaker QTKitQuittungFertig");
   
   
}


- (void)QTKitQuittungFertigAktion:(NSNotification*)note
{
   NSLog(@"Speaker QTKitQuittungFertigAktion");
   
}


- (BOOL)QuittungAb:(NSDictionary*)dieQuittung
{
   //NSLog(@"QuittungAb: quittung: %@",dieQuittung);
   BOOL QuittungOK=YES;
   int tempQuittung = [[dieQuittung  objectForKey:@"quittung"]intValue];
   NSURL* quittungURL = [self URLvonQuittung:tempQuittung];
   
   if (quittungURL)
   {
      [QueueArray removeAllObjects];
      [QueueArray addObject:[[AVPlayerItem alloc] initWithURL:quittungURL]];
      if ([[AufgabenPlayerX items]count])
      {
         [AufgabenPlayerX removeAllItems];
      }
      AufgabenPlayerX = [AVQueuePlayer queuePlayerWithItems:QueueArray];
      AufgabenPlayerX.volume = PlayerVolume;
      [AufgabenPlayerX play];
   }//if tempQuittungnDic
   
   else
   {
      return NO;
   }
   return QuittungOK;
}

- (IBAction)play
{
   NSLog(@"Speaker play");
}

- (void)setVolume:(float)dasVolume
{
   
  //NSLog(@"Player setVolume: Volume: %f",dasVolume);
   PlayerVolume=dasVolume;
   AufgabenPlayerX.volume = dasVolume;
   
}


- (int)deleteMovieFiles
{
   
   NSString*	DokumentOrdnerPfad;
   NSString* AufgabenName=@"SndCalcFile";
   NSString* QuittungName=@"QuittungFile";
   //NSLog(@"deleteAufgabenMovie: %@",AufgabenName);
   NSArray *PfadArray;
   
   PfadArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   if ([PfadArray count] > 0)  
   { // only copying one file
      DokumentOrdnerPfad= [PfadArray objectAtIndex:0];
   }
   
   
   
   NSString* SndCalcDatenOrdnerPfad=[DokumentOrdnerPfad stringByAppendingPathComponent:@"SndCalcTemp"];
   //Pfad des Datenordners
   
   NSString* AufgabenPfad = [SndCalcDatenOrdnerPfad stringByAppendingPathComponent:AufgabenName];
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   //NSLog(@"AufgabenPfad: %@",AufgabenPfad);
   int removeOK=0;
   if ([Filemanager fileExistsAtPath:AufgabenPfad])   //file schon da
	  {
        removeOK=[Filemanager removeItemAtPath:AufgabenPfad error:NULL];
     }
   
	  //NSLog(@"DeleteAufgabenMovie: removeOK: %d",removeOK);
   
   NSString* QuittungPfad = [SndCalcDatenOrdnerPfad stringByAppendingPathComponent:QuittungName];
   //NSLog(@"QuittungPfad: %@",QuittungPfad);
   removeOK=0;
   if ([Filemanager fileExistsAtPath:QuittungPfad])   //file schon da
	  {
        removeOK=[Filemanager removeItemAtPath:QuittungPfad error:NULL];
     }
   
	  //NSLog(@"DeleteQuittungMovie: removeOK: %d",removeOK);
	  
	  
	  
	  NSString* tempOrdnerPfad=[AufgabenPfad stringByDeletingLastPathComponent];
   if ([Filemanager fileExistsAtPath:tempOrdnerPfad])   //file schon da
	  {
        //DisposeMovie(AufgabenMovie);
        removeOK=[Filemanager removeItemAtPath:tempOrdnerPfad error:NULL];
     }
	  
	  return removeOK;
   
}

@end
