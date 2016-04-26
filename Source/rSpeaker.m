//
//  rSpeaker.mQuittungSelektionDic
//  SndCalcII
//
//  Created by Sysadmin on 24.10.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "rSpeaker.h"
//#import <QTKit/QTKit.h>
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
//gAufgabePlayingCompleteCallBack =  NewQTCallBackUPP(&AufgabenCallBackProc);
   NSArray* qarray;

}

/*
- (void)setupMoviePlayingCompleteCallback:(Movie)theMovie callbackUPP:(QTCallBackUPP) callbackUPP
{
   fprintf(stderr, "setupMoviePlayingCompleteCallback\n");
    TimeBase tb = GetMovieTimeBase (theMovie);
    OSErr err = noErr;
    
    gQtCallBack = NewCallBack (tb, callBackAtExtremes);
    if (gQtCallBack != NULL)
    {
        err = CallMeWhen (gQtCallBack, 
                        callbackUPP, 
                        NULL,
                        triggerAtStop,
                        NULL,
                        NULL);
    }
}

- (QTMovie*)AufgabenQTKitMovie
{
return AufgabenQTKitMovie;
}

- (QTMovie*)QuittungenQTKitMovie
{
return QuittungenQTKitMovie;
}
*/
/*
- (NSMovieView*)AufgabenPlayer
{
return AufgabenPlayer;
}
*/


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
				
				int StimmenNamenIndex=[[tempStimmenNamenArray valueForKey:@"stimmenname"]indexOfObject:tempStimmenName];
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
   NSLog(@"QuittungNamenArrayDicAusResources ResourcenPfad: %@" , ResourcenPfad);
   NSString *str=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Zahlen_AIFF"];
   NSLog(@"QuittungNamenArrayDicAusResources str: %@" , str);

	//Zahlen.plist lesen: Liste der benötigten Ziffern
	NSDictionary* tempQuittungPListDic;
	int anzQuittungen=0;
	NSString* QuittungPlistPfad=[ResourcenPfad stringByAppendingPathComponent:@"Quittung.plist"];
	if ([Filemanager fileExistsAtPath:QuittungPlistPfad])
	{
		tempQuittungPListDic=[NSDictionary dictionaryWithContentsOfFile:QuittungPlistPfad];
		NSLog(@"tempQuittungPListDic: %@",[tempQuittungPListDic description]);
		
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
			
			NSLog(@"QuittungNamenArrayAusResources	QuittungNamenArrayDic: %@",[QuittungNamenArrayDic description]);
			
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
         
         //NSMovie *tempMovie = [[NSMovie alloc] initWithURL:tempmovieUrl byReference:YES];
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

   NSArray* tempQuittungArray=[Filemanager contentsOfDirectoryAtPath:[ResourcenPfad stringByAppendingPathComponent:@"Quittung_AIFF"] error:NULL];

	//NSLog(@"tempQuittungArray roh: %@\n",[tempQuittungArray description]);
	
   
   
   NSString* QuittungPlistPfad=[ResourcenPfad stringByAppendingPathComponent:@"Quittung.plist"];
	
	//liste der notwendigen Quittungen
	if ([Filemanager fileExistsAtPath:QuittungPlistPfad])
	{
		//Dic der erforderlichen Quittungen mit ID
		QuittungPlistDic=[NSDictionary dictionaryWithContentsOfFile:QuittungPlistPfad];//Dic mit Namen und ResNummern
	}
	NSLog(@"readQuittungen QuittungPlistDic: %@",[QuittungPlistDic description]);
	
   
   
   NSMutableArray* tempZahlenArray=[[NSMutableArray alloc]initWithCapacity:0];
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
	NSLog(@"readQuittungen:		AIFFArray: %@ \n",[AIFFArray description]);
	//NSLog(@"AIFFArray Anzahl: %d ",[AIFFArray count]);
	//NSLog(@"");
	//NSLog(@"readQuittungen start mit Selektion:		QuittungSelektionDic: %@ \n",[QuittungSelektionDic description]);
	
   NSMutableArray* tempQuittungDicArray=[[NSMutableArray alloc]initWithCapacity:0];

	//Klassen abfragen
	NSEnumerator* QuittungListeEnum=[[QuittungPlistDic allKeys] objectEnumerator];//erforderliche Klassennamen
	
	id eineQuittungKlasse;
	while (eineQuittungKlasse=[QuittungListeEnum nextObject])
   {
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
      //NSLog(@"\neineQuittungKlasse: %@   tempSelectedKlasseName: %@  IDausPlist: %@",eineQuittungKlasse,tempSelectedKlasseName,IDausPlist);
      

      //AIFFArray durchsuchen
      NSEnumerator* AIFFEnum=[AIFFArray objectEnumerator];
      id einName;
      while (einName=[AIFFEnum nextObject])
      {
         NSString* tempName=[einName stringByDeletingPathExtension];
         NSArray* tempQuittungNamenTeileArray=[tempName componentsSeparatedByString:@"_"];
         NSString* tempQuittungKlasse=[tempQuittungNamenTeileArray lastObject];//Klasse der Quittung
         //NSLog(@"tempName: %@  PListName: %@",tempName,PListName);
         
         if ([[tempQuittungKlasse stringByDeletingPathExtension] isEqualToString:eineQuittungKlasse])//Die Klasse stimmt
         {
            switch ([tempQuittungNamenTeileArray count])
            {
               case 1://nur ein Teil
               {
                  if ([tempSelectedKlasseName isEqualToString:@"home"])//home ausgewählt fuer die Quittungsklasse
                  {
                     //NSLog(@"home:		eineZahl: nur 1 Element Klasse: %@",tempQuittungKlasse);
                     tempMovieName=tempName;//Name der Klasse ohne pathExtension
                  }
               }break;
                  
               case 2://2 Teile
               {
                  //NSLog(@"aif. eineQuittung: %@  tempQuittungNamenTeileArray: %@", eineQuittung,[tempQuittungNamenTeileArray description]);
                  //NSLog(@"eineQuittungKlasse: %@",eineQuittungKlasse);
                  NSString* tempQuittungName=[tempQuittungNamenTeileArray objectAtIndex:0];//Username der Klasse
                  NSString* tempQuittungKlasse=[[tempQuittungNamenTeileArray objectAtIndex:1]stringByDeletingPathExtension];
                  //NSString* tempKlasseName=[QuittungSelektionDic objectForKey: eineQuittungKlasse];//ausgewählter Name fuer Klasse
                  //NSLog(@"Klasse: %@	tempKlasseName: %@	eineQuittung: %@",eineQuittungKlasse,tempKlasseName,eineQuittung);
                  //NSLog(@"tempQuittungName: %@  tempQuittungKlasse: %@",tempQuittungName,tempQuittungKlasse);
                  if ([tempSelectedKlasseName isEqualToString:tempQuittungName])//Username stimmt
                  {
                     tempMovieName=tempName;//Name der Klasse ohne pathExtension
                  }
               }break;
                  //default:
                  //tempMovieName=[eineQuittungKlasse stringByAppendingPathExtension:@"aif"];//sicher ist sicher
            }//switch
         }//Klasse stimmt
      }//while einName
      
      //NSLog(@"nach AIFFArray durchsuchen  tempMovieName: %@",tempMovieName);
      if ([tempMovieName length])//es passte
      {
         NSString* tempAIFFPfad=[[ResourcenPfad stringByAppendingPathComponent:@"Quittung_AIFF"] stringByAppendingPathComponent:einName ];

         NSURL *	tempQuittungUrl = [NSURL fileURLWithPath:tempAIFFPfad];
         if ([Filemanager fileExistsAtPath:tempAIFFPfad])
         {
            NSMutableDictionary* tempMovieDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [tempMovieDic setObject:tempAIFFPfad forKey:@"quittungpfad"];
            [tempMovieDic setObject:tempQuittungUrl forKey:@"quittungurl"];
            [tempMovieDic setObject:tempMovieName forKey:@"name"];
            [tempMovieDic setObject:IDausPlist forKey:@"ID"];
            [tempQuittungDicArray addObject:tempMovieDic];
         }
      }//if length
      
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

-(QTTime)setQTKitQuittungVon:(int)dieQuittung mitOffset:(QTTime)derOffset
{
	//NSLog(@"	setQTKitQuittungVon %d",dieQuittung);
  
	NSArray* IDArray=[QuittungDicArray valueForKey:@"ID"];
	//NSLog(@"IDArray: %@",[IDArray description]);
	int GermanOffset=20000;
	int IDOffset=GermanOffset;
	
	
	QTTime Start = derOffset;
	int QuittungID=IDOffset+(dieQuittung);
   
   
	//NSLog(@"Beginn Quittung: %d QuittungID: %d",dieQuittung,QuittungID);
	int QuittungIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:QuittungID] stringValue]];
	//NSLog(@"QuittungIndex: %d",QuittungIndex);
	if (QuittungIndex<0)
   {
      return QTZeroTime;
   }
   
   QuittungenQTKitMovie= [[QuittungDicArray objectAtIndex:QuittungIndex]objectForKey:@"movie"];
   if (QuittungenQTKitMovie)
   {
      //NSLog(@"setQTKitQuittungVon QuittungenQTKitMovie OK");
      [AufgabenPlayer setMovie:QuittungenQTKitMovie];
      
      QTTime QTKitTrackDauer = [QuittungenQTKitMovie duration];
      
      Start.timeValue+=QTKitTrackDauer.timeValue;
      return Start;
   }
   return Start;
}





-(QTTime)setOpQTKitTrackVon:(int)dieOperation mitOffset:(QTTime)derOffset
{
	//NSLog(@"setQTKitOpTrackVon: TrackVon: %d",dieOperation);
	NSArray* IDArray=[ZahlenDicArray valueForKey:@"ID"];
	//NSLog(@"IDArray: %@",[IDArray description]);
	int GermanOffset=20000;
	int IDOffset=GermanOffset;
	
   QTTime Start = derOffset;

	QTMovie* OperationMovie;
	
   //Movie OperationQTMovie=nil;
	
	int OperationID=IDOffset+(dieOperation);
	
	
	//NSLog(@"Beginn Operation: %d OperationID: %d",dieOperation,OperationID);
	int OperationIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:OperationID] stringValue]];
	
	//NSLog(@"OperationIndex: %d",OperationIndex);
	if (OperationIndex<0)
	{
		return QTZeroTime;
	}
	//OperationMovie=[[ZahlenArray objectAtIndex:OperationIndex]objectForKey:@"movie"];
	//OperationQTMovie=(Movie)[OperationMovie quickTimeMovie]; //Movie fuer QT
	//NSLog(@"Start: %lld",Start.timeValue);
   QTMovie* OperationQTKitMovie=[[ZahlenDicArray objectAtIndex:OperationIndex]objectForKey:@"movie"];
   QTTime QTKitOperationTrackDauer = [OperationQTKitMovie duration];
   //NSLog(@"QTKitOperationTrackDauer: %lld",QTKitOperationTrackDauer.timeValue);
 //  [AufgabenQTKitMovie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute];

   [AufgabenQTKitMovie insertSegmentOfMovie:OperationQTKitMovie timeRange:QTMakeTimeRange(QTZeroTime,QTKitOperationTrackDauer) atTime:[AufgabenQTKitMovie duration]];

	//Track fuer Operation 
	
	// Trackdauer addieren
   Start.timeValue+=QTKitOperationTrackDauer.timeValue;

		//NSLog(@"setOpTrackVon Ende");
	return Start;
}//setOpTrackVon

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

- (NSURL*)URLvonQuittung:(int)dieQuittung
{
   
   return nil;
}



-(QTTime)setZahlQTKitTrackVon:(int)dieZahl mitOffset:(QTTime)derOffset
{

	//NSLog(@"setQTKitZahlTrackVon: %d derOffset: %lld",dieZahl, derOffset.timeValue);
	NSArray* IDArray=[ZahlenDicArray valueForKey:@"ID"];
//	NSLog(@"IDArray: %@",[IDArray description]);
	int GermanOffset=20000;
	int IDOffset=GermanOffset;
	//int TrackOK=YES;
	int FehlendeZahl=0;
   QTTime Start = derOffset;

	int ZehnIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:IDOffset+10] stringValue]];
	if (ZehnIndex<0)//Zahl nicht im Array
	{
		FehlendeZahl=10;
      NSLog(@"FehlendeZahl"); 
//		goto bail;
	}
	int HundertIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:IDOffset+100] stringValue]];
	if (HundertIndex<0)
	{
		return QTZeroTime;
	}
	
   // Movie fuer "Hundert" nach der Hunderterzahl
   QTMovie* HundertQTKitMovie=[[ZahlenDicArray objectAtIndex:HundertIndex]objectForKey:@"movie"];
   QTTime HundertQTKitTrackDauer = [HundertQTKitMovie duration];

   // Movie fuer "Tausend" nach der Tausenderzahl
	int TausendIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:IDOffset+1000] stringValue]];
	if (TausendIndex<0)
	{
		return QTZeroTime;
	}
   
   QTMovie* TausendQTKitMovie=[[ZahlenDicArray objectAtIndex:TausendIndex]objectForKey:@"movie"];
   QTTime TausendQTKitTrackDauer = [TausendQTKitMovie duration];

	//NSLog(@"Begin Zahlen lesen");
	
	//													TAUSENDER
	
   // Tausender feststellen
	int Tausender=dieZahl/1000;
	
   // Movie dazu
   QTMovie* TausenderQTKitMovie;
   if (Tausender>0)			//Es hat Tausender
	{
		//NSLog(@"Beginn Tausender: %d",Tausender);
      // lage des Tausenders im Zahlarray feststellen
		int TausenderIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:IDOffset+Tausender] stringValue]];
		if (TausenderIndex<0)
		{
			return QTZeroTime;
		}
      TausenderQTKitMovie=[[ZahlenDicArray objectAtIndex:TausenderIndex]objectForKey:@"movie"];
      QTTime TausenderQTKitTrackDauer = [TausenderQTKitMovie duration];
      
      // Track einsetzen
      [AufgabenQTKitMovie insertSegmentOfMovie:TausenderQTKitMovie 
                                     timeRange:QTMakeTimeRange(QTZeroTime,TausenderQTKitTrackDauer) 
                                        atTime:[AufgabenQTKitMovie duration]];
      Start.timeValue+=TausenderQTKitTrackDauer.timeValue;
      
      // "Tausend" einfuegen
      [AufgabenQTKitMovie insertSegmentOfMovie:TausendQTKitMovie 
                                     timeRange:QTMakeTimeRange(QTZeroTime,TausendQTKitTrackDauer) 
                                        atTime:[AufgabenQTKitMovie duration]];
      Start.timeValue+=TausenderQTKitTrackDauer.timeValue;

  	
   }//if Tausender>0
	//NSLog(@"Ende Tausender");
	
	
	
	//														HUNDERTER
	
	int Hunderter=(dieZahl%1000)/100;
   // Movie dazu
   QTMovie* HunderterQTKitMovie;

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
         
         int HunderterIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:HunderterID] stringValue]];
         if (HunderterIndex<0)
         {
            return QTZeroTime;
         }
         // QTMovie fuer Hunderter einrichten
         HunderterQTKitMovie = [[ZahlenDicArray objectAtIndex:HunderterIndex]objectForKey:@"movie"];
         
         // Trackdauer dazu
         QTTime HunderterQTKitTrackDauer = [HunderterQTKitMovie duration];
         
         // Track fuer Hunderter einsetzen
         
         
         // Hunderterzahl einsetzen
         [AufgabenQTKitMovie insertSegmentOfMovie:HunderterQTKitMovie 
                                        timeRange:QTMakeTimeRange(QTZeroTime,HunderterQTKitTrackDauer) 
                                           atTime:[AufgabenQTKitMovie duration]];
         Start.timeValue+=HunderterQTKitTrackDauer.timeValue;
         
      }
      // "Hundert" einsetzen. Wenn Hunderter = 1: kein "ein" davor   
      [AufgabenQTKitMovie insertSegmentOfMovie:HundertQTKitMovie 
                                     timeRange:QTMakeTimeRange(QTZeroTime,HundertQTKitTrackDauer) 
                                        atTime:[AufgabenQTKitMovie duration]];
      Start.timeValue+=HundertQTKitTrackDauer.timeValue;
      
      
      
   }//if Hunderter>0
	//NSLog(@"Ende Hunderter");
	
	
	//														Zehner
	
	int Zehner=((dieZahl%1000)%100)/10;
   QTMovie* ZehnerQTKitMovie;
	QTMovie* ZehnerMovie;
   
  
	
//   Movie ZehnerQTMovie=nil;
	int ZehnerID=0;
      
	//														Einer
	int Einer=dieZahl%10;								
   QTMovie* EinerQTKitMovie;
	
   int EinerID=0;
	
   QTMovie* UndQTKitMovie;
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
            int EinerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:EinerID] stringValue]];
            //NSLog(@"EinerIndex");
            
            if (EinerIndex<0)
            {
               return QTZeroTime;
            }
            
            // QTMovie fuer Einer
            EinerQTKitMovie=[[ZahlenDicArray objectAtIndex:EinerIndex]objectForKey:@"movie"];
            QTTime EinerQTKitTrackDauer = [EinerQTKitMovie duration];
            
             
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
            
            int UndIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:UndID] stringValue]];
            //NSLog(@"UndIndex");
            if (UndIndex<0)
            {
               return QTZeroTime;
            }
            
            // QTMovie fuer "und"
            UndQTKitMovie=[[ZahlenDicArray objectAtIndex:UndIndex]objectForKey:@"movie"];
            QTTime UndQTKitTrackDauer = [UndQTKitMovie duration];
            
            
            // Einer einsetzen
            [AufgabenQTKitMovie insertSegmentOfMovie:EinerQTKitMovie 
                                           timeRange:QTMakeTimeRange(QTZeroTime,EinerQTKitTrackDauer) 
                                              atTime:[AufgabenQTKitMovie duration]];
            Start.timeValue+=EinerQTKitTrackDauer.timeValue;
            
            
             
            // "und" einsetzen: Es folgen noch Zehner
            [AufgabenQTKitMovie insertSegmentOfMovie:UndQTKitMovie 
                                           timeRange:QTMakeTimeRange(QTZeroTime,UndQTKitTrackDauer) 
                                              atTime:[AufgabenQTKitMovie duration]];
            Start.timeValue+=UndQTKitTrackDauer.timeValue;
            
            
				
            //NSLog(@"setZahlTrack ende einer");		
         }//  if einer>0 (zehner >0)
         
         ZehnerID=IDOffset+10*Zehner;		// "-ig anhängen: Zehner=2 muss fuer die ID 20 geben
         int ZehnerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:ZehnerID] stringValue]];
         //NSLog(@"ZehnerIndex");
         if (ZehnerIndex<0)
         {
            return QTZeroTime;
         }
         ZehnerQTKitMovie=[[ZahlenDicArray objectAtIndex:ZehnerIndex]objectForKey:@"movie"];
         QTTime ZehnerQTKitTrackDauer = [ZehnerQTKitMovie duration];
        
         // Zehner einsetzen
         [AufgabenQTKitMovie insertSegmentOfMovie:ZehnerQTKitMovie 
                                        timeRange:QTMakeTimeRange(QTZeroTime,ZehnerQTKitTrackDauer) 
                                           atTime:[AufgabenQTKitMovie duration]];
         Start.timeValue+=ZehnerQTKitTrackDauer.timeValue;
         
		}           // if Zehner>1
      else        //	10 - 19
		{
         if ((Einer>=0)&&(Einer<=2))//10,11,12
         {
            EinerID=IDOffset+10+Einer;
            int EinerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:EinerID] stringValue]];
            //NSLog(@"EinerIndex");
            
            if (EinerIndex<0)
            {
               return QTZeroTime;
            }
            EinerQTKitMovie=[[ZahlenDicArray objectAtIndex:EinerIndex]objectForKey:@"movie"];
            QTTime EinerQTKitTrackDauer = [EinerQTKitMovie duration];

            // Einer einsetzen
            [AufgabenQTKitMovie insertSegmentOfMovie:EinerQTKitMovie 
                                           timeRange:QTMakeTimeRange(QTZeroTime,EinerQTKitTrackDauer) 
                                              atTime:[AufgabenQTKitMovie duration]];
            Start.timeValue+=EinerQTKitTrackDauer.timeValue;

         }
         else //13 - 19
         {
            
            EinerID=IDOffset+Einer;
            
            if ((Einer==6) || (Einer==7) || (Einer==8))//17, 18. 19
            {
               EinerID+=1000;
            }
            
            int EinerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:EinerID] stringValue]];
            //NSLog(@"EinerIndex");
            
            if (EinerIndex<0)
            {
               return QTZeroTime;
            }
            
            EinerQTKitMovie=[[ZahlenDicArray objectAtIndex:EinerIndex]objectForKey:@"movie"];
            QTTime EinerQTKitTrackDauer = [EinerQTKitMovie duration];
            // Einer einsetzen
            [AufgabenQTKitMovie insertSegmentOfMovie:EinerQTKitMovie 
                                           timeRange:QTMakeTimeRange(QTZeroTime,EinerQTKitTrackDauer) 
                                              atTime:[AufgabenQTKitMovie duration]];
            Start.timeValue+=EinerQTKitTrackDauer.timeValue;
            
            
            //		Zehner von 13 - 19
            ZehnerID=IDOffset+10;		
            int ZehnerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:ZehnerID] stringValue]];
            //NSLog(@"ZehnerIndex");
            if (ZehnerIndex<0)
            {
               return QTZeroTime;
            }
            ZehnerQTKitMovie=[[ZahlenDicArray objectAtIndex:ZehnerIndex]objectForKey:@"movie"];
            QTTime ZehnerQTKitTrackDauer = [ZehnerQTKitMovie duration];
            // Zehner einsetzen
            [AufgabenQTKitMovie insertSegmentOfMovie:ZehnerQTKitMovie 
                                           timeRange:QTMakeTimeRange(QTZeroTime,ZehnerQTKitTrackDauer) 
                                              atTime:[AufgabenQTKitMovie duration]];
            Start.timeValue+=ZehnerQTKitTrackDauer.timeValue;
           
         }
         
		}
      //NSLog(@"setZahlTrack ende Zehner vor nur einer");
	}//if Zehner>0
	
	else	//nur Einer
	{
	
      EinerID=IDOffset+Einer;
		int EinerIndex=[IDArray indexOfObject:[[NSNumber numberWithInt:EinerID] stringValue]];
		//NSLog(@"Nur Einer: EinerIndex: %d",EinerIndex);
		
		if (EinerIndex<0)
		{
			return QTZeroTime;
		}
      // QTMovie holen
		QTMovie* EinerQTKitMovie=[[ZahlenDicArray objectAtIndex:EinerIndex]objectForKey:@"movie"];
      //NSLog(@"Start: %lld",Start.timeValue);
      
      // Trackdauer bestimmen
      QTTime QTKitEinerTrackDauer = [EinerQTKitMovie duration];
      //NSLog(@"QTKitEinerTrackDauer: %lld duration: %lld",QTKitEinerTrackDauer.timeValue,[AufgabenQTKitMovie duration].timeValue);
      //Track einfuegen
//      [AufgabenQTKitMovie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute];

      [AufgabenQTKitMovie insertSegmentOfMovie:EinerQTKitMovie 
                                     timeRange:QTMakeTimeRange(QTZeroTime,QTKitEinerTrackDauer) 
                                        atTime:[AufgabenQTKitMovie duration]];
                                                                                          // Trackdauer addieren
      Start.timeValue+=QTKitEinerTrackDauer.timeValue;
	
	}
//	NSLog(@"Zahl: %d Tausender: %d Hunderter: %d Zehner: %d Einer: %d",dieZahl,Tausender,Hunderter, Zehner, Einer);
//   [AufgabenQTKitMovie play];
   
	return Start;
	
	//bail:
		NSAlert* SoundWarnung=[[NSAlert alloc]init];
		NSString* t=NSLocalizedString(@"Missing Sound",@"Fehlender Ton");
		NSString* i0=NSLocalizedString(@"The sound for the number: %d could not be loaded.",@"Die Tondatei für diE Zahl: %d konnte nicht gefunden werden.");
		NSString* i1=[NSString stringWithFormat:@"%@ %@",i0,FehlendeZahl];
		NSString* b1=NSLocalizedString(@"Terminate",@"Beenden");
		[SoundWarnung addButtonWithTitle:b1];
		[SoundWarnung setMessageText:t];
		[SoundWarnung setInformativeText:i1];
		
		int modalAntwort=[SoundWarnung runModal];
		
   NSLog(@"setZahlTracK End");
	return QTZeroTime;
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
		NSLog(@"AufgabeAb: Nummer: %d var0: %d var1: %d op0: %d var2: %d",Aufgabennummer,var0,var1,op0,var2);
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
      NSArray* var2Array = [self URLArrayvonZahl:var2];

      NSURL* op0URL = [self URLvonOperation:op0];
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
    //NSLog(@"AufgabenPlayerX actionAtItemEnd: %ld",AufgabenPlayerX.actionAtItemEnd);
   if (AufgabenPlayerX.currentItem == AufgabenPlayerX.items.lastObject)
   {
      NSLog(@"letztes item da");
     
   }
   else
   {
     // NSLog(@"item da");
   }
}


- (void)AufgabeFertigAktion:(NSNotification*)note
{
	NSLog(@"Speaker AufgabeFertigAktion");
	
	//movieDidEndSelector = nil;
	//movieDidEndTargetObject = nil;

	{
		
	}
}

- (void)QTKitAufgabeFertigAktion:(NSNotification*)note
{
	//NSLog(@"Speaker QTKitAufgabeFertigAktion");
   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:@"QTMovieDidEndNotification" object:nil];
   
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"fertig"];
	[NotificationDic setObject:@"QTKit" forKey:@"quelle"];
	[nc postNotificationName:@"AufgabelesenFertig" object:nil userInfo:NotificationDic];

}

- (void)QTKitQuittungFertig
{
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"fertig"];
	[NotificationDic setObject:@"QTKit" forKey:@"quelle"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"QTKitQuittungFertig" object:nil userInfo:NotificationDic];
   NSLog(@"Speaker QTKitQuittungFertig nc ab");
   
   
}


- (void)QTKitQuittungFertigAktion:(NSNotification*)note
{
	//NSLog(@"Speaker QTKitQuittungFertigAktion");
   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:@"QTMovieDidEndNotification" object:nil];

 }


- (BOOL)QuittungAb:(NSDictionary*)derQuittungDic
{
	BOOL QuittungOK=YES;
		
	if ([derQuittungDic objectForKey:@"quittung"])
	{
		int quittung=0;
		NSNumber* QuittungNumber=[derQuittungDic objectForKey:@"quittung"];
		if (QuittungNumber)
		{
			quittung=[QuittungNumber intValue];
		}
		//NSLog(@"QuittungAb: quittung: %d",quittung);
      
      QTTime QuittungTime = [self setQTKitQuittungVon:quittung mitOffset:QTZeroTime];
     // NSLog(@"QuittungAb: QuittungTime nach set: %lld",QuittungTime.timeValue);
     [QuittungenQTKitMovie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute];
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];    
      [nc addObserver:self 
             selector:@selector(QTKitQuittungFertigAktion:) 
                 name:QTMovieDidEndNotification 
               object:QuittungenQTKitMovie];

      [QuittungenQTKitMovie gotoBeginning];
		[QuittungenQTKitMovie play];
   
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
    if ([[AufgabenPlayer movie] rate])
    {
        /* yes, so stop it */
        [AufgabenPlayer pause:NULL];
    }

        [AufgabenPlayer gotoBeginning:NULL];
        [AufgabenPlayer play:NULL];
       

}

- (void)setVolume:(float)dasVolume
{
  
	//NSLog(@"setVolume: Volume: %f",dasVolume);
	PlayerVolume=dasVolume;

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
