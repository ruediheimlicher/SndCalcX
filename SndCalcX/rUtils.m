//
//  rUtils.m
//  SndCalcII
//
//  Created by Sysadmin on 12.01.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "rUtils.h"


@implementation rUtils

- (void)Alert:(NSString*)derFehler
{
   NSAlert * DebugAlert=[NSAlert alertWithMessageText:@"Debugger!"
                                        defaultButton:NULL
                                      alternateButton:NULL
                                          otherButton:NULL
                            informativeTextWithFormat:@"Mitteilung: \n%@",derFehler];
   [DebugAlert runModal];
   
}

- (id)init
{
   return [super init];
}

- (NSString*)HomeSndCalcDatenPfad
{
   /*
    Gibt den Pfad der SndCalcDaten auf home zur√ºck
    */
   
   BOOL HomeSndCalcDatenDa=NO;
   BOOL istOrdner;
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   NSString* HomeSndCalcPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/SndCalcDaten"];
   HomeSndCalcDatenDa= ([Filemanager fileExistsAtPath:HomeSndCalcPfad isDirectory:&istOrdner]&&istOrdner);
   //NSLog(@"mountedVolume:    HomeSndCalcVolume: %@",[HomeSndCalcPfad description]);
   if (HomeSndCalcDatenDa)
      return HomeSndCalcPfad;
   else
      return [NSString string];
   
}


- (NSArray*)UsersMitSndCalcDatenArray
{
   /*
    Prüft home und die eingeloggten Benutzer, ob ein ordner SndCalcDaten vorhanden ist.
    Gibt einen Array mit Dics zurück,
    die in den Userarray des Startfensters eingesetzt werden
    Die Dics enthalten den Pfad und eine Anzeige für den Ordner SndCalcDaten
    */
   BOOL UserMitSndCalcDatenDa=NO;
   BOOL istOrdner;
   NSString* HomeVolumeString=@"Auf diesem Computer hier";
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   
   NSString* SndCalcDatenOrdnerName=NSLocalizedString(@"SndCalcDaten",@"SndCalcDaten");
   //NSString* cb=NSLocalizedString(@"Comments",@"Anmerkungen");
   
   NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
   NSMutableArray * UserMitSndCalcDatenArray=[NSMutableArray arrayWithCapacity:0];//Ordner für die Dics
   NSMutableDictionary* HomeDic=[[NSMutableDictionary alloc]initWithCapacity:0];//Dic fuer Volume
   
   //Dic für Home einrichten
   [HomeDic setObject:HomeVolumeString forKey:@"netzvolumepfad"];
   [HomeDic setObject:[NSHomeDirectory() lastPathComponent] forKey:@"username"];
   
   NSString*HomeSndCalcDatenPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents/",SndCalcDatenOrdnerName];
   
   //	[self Alert:HomeSndCalcDatenPfad];
   
   [HomeDic setObject:HomeSndCalcDatenPfad forKey:@"userSndCalcDatenpfad"];
   [HomeDic setObject:[NSNumber numberWithBool:YES] forKey:@"loginOK"];
   
   //	NSLog(@"cb: %@  SndCalcDaten: %@ HomeSndCalcDatenPfad: %@",cb,lb,HomeSndCalcDatenPfad);
   
   int HomeSndCalcDatenOK=0;
   
   if ([Filemanager fileExistsAtPath:HomeSndCalcDatenPfad isDirectory:&istOrdner]&&istOrdner)//SndCalcDatenordner vorhanden auf home
   {
      
      //	[self Alert:@"SndCalcDatenordner vorhanden auf home"];
      
      //NSLog(@"HomeSndCalcDatenPfad: %@",HomeSndCalcDatenPfad);
      NSMutableArray* tempArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:HomeSndCalcDatenPfad error:NULL];
      [tempArray removeObject:@".DS_Store"];
      HomeSndCalcDatenOK=([tempArray count]>0);//Daten in SndCalcDaten sind vorhanden
      NSString* tempAlertString=[NSString stringWithFormat:@"%@ Anzahl: %d",[tempArray description],[tempArray count]];
      //		[self Alert:tempAlertString];
      if ([tempArray containsObject:@"UserDaten"])
      {
         NSString* tempUserPfad=[HomeSndCalcDatenPfad stringByAppendingPathComponent:@"UserDaten"];
         
         //		[self Alert:[[Filemanager directoryContentsAtPath:tempUserPfad]description]];
      }
      
   }
   else	//Datenordner einrichten
   {
      //		[self Alert:@"SndCalcDatenordner nicht vorhanden auf home"];
      
      //BOOL OrdnerOK=[Filemanager createDirectoryAtPath:HomeSndCalcDatenPfad attributes:NULL];
      
      BOOL OrdnerOK = [Filemanager createDirectoryAtPath:HomeSndCalcDatenPfad withIntermediateDirectories:NO attributes:NULL error:NULL];
      
      HomeSndCalcDatenOK=NO;//Datenordner ist noch leer
   }
   
   
   //	NSLog(@"HomeSndCalcDatenOK: %d",HomeSndCalcDatenOK);
   //	[HomeDic setObject:[NSNumber numberWithBool:HomeSndCalcDatenAngelegt] forKey:@"homeSndCalcDatenAngelegt"];
   [HomeDic setObject:[NSNumber numberWithBool:HomeSndCalcDatenOK] forKey:@"userSndCalcDatenOK"];//Datenordner ist auf Home da?
   
   [HomeDic setObject:[NSNumber numberWithInt:0] forKey:@"volumeSndCalcDatenOK"];
   [HomeDic setObject:[NSString string] forKey:@"volumeSndCalcDatenpfad"];
   
   [HomeDic setObject:[NSNumber numberWithInt:HomeSndCalcDatenOK] forKey:@"SndCalcDatenort"];
   
   [HomeDic setObject:@"Home" forKey:@"host"];
   [UserMitSndCalcDatenArray addObject:HomeDic];//Dic fuer das Volume anfuegen;
   
   
   //Eingeloggte Volumes mit SndCalcDaten suchen
   NSMutableArray * volumesArray=[NSMutableArray arrayWithArray:[workspace mountedLocalVolumePaths]];
   
   [volumesArray removeObject:@"/"];
   [volumesArray removeObject:@"/Network"];
   [volumesArray removeObject:@"/Volumes/Untitled"];
   [volumesArray removeObject:@"/net"];
   [volumesArray removeObject:@"/Volumes/NetBootClients0"];
   //NSLog(@"mountedLocalVolumePaths:\nvolumesArray sauber: %@   Anzahl Volumes: %d",[volumesArray description],[volumesArray count]);
   int volumesIndex;
   if ([volumesArray count]) //Es sind Volumes eingeloggt
   {
      for (volumesIndex=0;volumesIndex<(int)[volumesArray count];volumesIndex++)
      {
         
         //	NSMutableDictionary* tempUserDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];//Dic fuer Volume
         NSString* NetzVolumePfad=[NSString stringWithString:[volumesArray objectAtIndex:volumesIndex] ];
         //**
         //NSArray* PfadArray = NSSearchPathForDirectoriesInDomains(NSAdminApplicationDirectory,  NSAllDomainsMask, YES);
         //NSLog(@"PfadArray: %@",[PfadArray description]);
         //**
         //NSLog(@"NetzVolumePfad raw: %@",NetzVolumePfad);
         
         //   SCHULER
         
         if ([[NetzVolumePfad lastPathComponent] isEqualToString:@"Schueler"]||[[NetzVolumePfad lastPathComponent] isEqualToString:@"schueler"])
         {
            //NSLog(@"NetzVolumePfad: %@",NetzVolumePfad);
            NSMutableArray* KlassenordnerArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:NetzVolumePfad error:NULL];
            [KlassenordnerArray removeObject:@".DS_Store"];
            [KlassenordnerArray removeObject:@"Lerndaten"];
            [KlassenordnerArray removeObject:@"Lesebox"];
            [KlassenordnerArray removeObject:@"SndCalcDaten"];
            [KlassenordnerArray removeObject:@".CFUserTextEncoding"];
            [KlassenordnerArray removeObject:@"Library"];
            [KlassenordnerArray removeObject:@"Desktop"];
            [KlassenordnerArray removeObject:@"Sites"];
            [KlassenordnerArray removeObject:@"Music"];
            [KlassenordnerArray removeObject:@"Pictures"];
            [KlassenordnerArray removeObject:@"Movies"];
            [KlassenordnerArray removeObject:@"Public"];
            //NSLog(@"KlassenordnerArray: %@",[KlassenordnerArray description]);
            
            int KlassenordnerIndex=0;
            for (KlassenordnerIndex=0;KlassenordnerIndex<[KlassenordnerArray count];KlassenordnerIndex++)
            {
               
               
               NSMutableDictionary* tempUserDic=[[NSMutableDictionary alloc]initWithCapacity:0];//Dic fuer Volume
               NSString* tempVolumeName=[KlassenordnerArray objectAtIndex:KlassenordnerIndex];
               NSLog(@"tempVolumeName: %@",tempVolumeName);
               
               
               NSString* tempNetzVolumePfad=[NetzVolumePfad stringByAppendingPathComponent:[KlassenordnerArray objectAtIndex:KlassenordnerIndex]];
               
               
               //NSLog(@"index: %d tempNetzVolumePfad: %@",KlassenordnerIndex,tempNetzVolumePfad);
               [tempUserDic setObject:[KlassenordnerArray objectAtIndex:KlassenordnerIndex] forKey:@"username"];		//Name des Users oder Volumes
               [tempUserDic setObject:[KlassenordnerArray objectAtIndex:KlassenordnerIndex] forKey:@"host"];
               [tempUserDic setObject:tempNetzVolumePfad forKey:@"netzvolumepfad"];//Pfad des Volumes
               [tempUserDic setObject:[NSNumber numberWithBool:YES] forKey:@"loginOK"];
               
               
               
               
               //Pfad fuer SndCalcDaten in 'Documents'
               NSString*tempNetzUserSndCalcDatenPfad=[tempNetzVolumePfad stringByAppendingFormat:@"%@",SndCalcDatenOrdnerName];
               //NSLog(@"tempNetzUserSndCalcDatenPfad: %@",tempNetzUserSndCalcDatenPfad);
               BOOL UserSndCalcDatenOK=NO;	//Wird YES wenn SndCalcDaten in Documents des users ist
               
               //Pfad fuer SndCalcDaten auf Volume
               NSString*tempNetzVolumeSndCalcDatenPfad=[tempNetzVolumePfad stringByAppendingPathComponent:SndCalcDatenOrdnerName];
               //NSLog(@"tempNetzVolumeSndCalcDatenPfad: %@",tempNetzVolumeSndCalcDatenPfad);
               BOOL VolumeSndCalcDatenOK=NO;	//Wird YES, wenn SndCalcDaten auf Volume ist
               
               int SndCalcDatenOrt=0;		//wird 1 wenn SndCalcDaten auf Volume ist, 2 wenn in 'Documents'
               
               //leere Strings einsetzen
               [tempUserDic setObject:[NSString string] forKey:@"userSndCalcDatenpfad"];
               [tempUserDic setObject:[NSString string] forKey:@"volumeSndCalcDatenpfad"];//leerer String
               
               //Pruefen, ob auf 'NetzVolumePfad' ein 'Documents'-Ordner mit einer SndCalcDaten vorhanden ist
               
               if ([Filemanager fileExistsAtPath:tempNetzUserSndCalcDatenPfad isDirectory:&istOrdner]&&istOrdner)
               {
                  NSMutableArray* tempArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempNetzUserSndCalcDatenPfad error:NULL];
                  [tempArray removeObject:@".DS_Store"];
                  if ([tempArray count])
                  {
                     //SndCalcDaten in 'Documents'
                     NSLog(@"SndCalcDaten in 'Documents':	tempNetzUserSndCalcDatenPfad: %@",tempNetzUserSndCalcDatenPfad);
                     //NSLog(@"SndCalcDaten in 'Documents':	tempNetzUserSndCalcDaten: %@",[[Filemanager directoryContentsAtPath:tempNetzUserSndCalcDatenPfad]description]);
                     UserSndCalcDatenOK=YES;//SndCalcDaten ist da
                     SndCalcDatenOrt=2;		//in 'Documents'
                     UserMitSndCalcDatenDa=YES;
                     [tempUserDic setObject:tempNetzUserSndCalcDatenPfad forKey:@"volumeSndCalcDatenpfad"];
                  }
                  
               }
               
               //Pruefen, ob auf 'tempNetzVolumeSndCalcDatenPfad' eine ordner SndCalcDaten vorhanden ist
               else if ([Filemanager fileExistsAtPath:tempNetzVolumeSndCalcDatenPfad isDirectory:&istOrdner]&&istOrdner)
               {
                  NSMutableArray* tempArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempNetzVolumeSndCalcDatenPfad error:NULL];
                  [tempArray removeObject:@".DS_Store"];
                  
                  if ([tempArray count])
                  {
                     //SndCalcDaten auf Volume
                     //NSLog(@"SndCalcDaten auf Volume:		tempNetzVolumeSndCalcDatenPfad: %@",tempNetzVolumeSndCalcDatenPfad);
                     //NSLog(@"SndCalcDaten auf Volume:	tempNetzVolumeSndCalcDatenPfad: %@",[[Filemanager directoryContentsAtPath:tempNetzVolumeSndCalcDatenPfad]description]);
                     VolumeSndCalcDatenOK=YES;//SndCalcDaten ist da
                     UserMitSndCalcDatenDa=YES;
                     SndCalcDatenOrt=1;	//auf Volume
                     [tempUserDic setObject:tempNetzVolumeSndCalcDatenPfad forKey:@"volumeSndCalcDatenpfad"];
                  }
                  
               }
               
               [tempUserDic setObject:[NSNumber numberWithBool:UserSndCalcDatenOK] forKey:@"userSndCalcDatenOK"];
               [tempUserDic setObject:[NSNumber numberWithBool:VolumeSndCalcDatenOK] forKey:@"volumeSndCalcDatenOK"];
               [tempUserDic setObject:[NSNumber numberWithInt:SndCalcDatenOrt] forKey:@"SndCalcDatenort"];
               
               [UserMitSndCalcDatenArray addObject:tempUserDic];//Dic fuerr das Volume anfuegen;
               
            } // for KlassenordnerIndex
         }// if Schuler in Pfad
         else
         {
            //NSLog(@"\nnicht Schueler : %@",[NetzVolumePfad lastPathComponent]);
            //NSLog(@"NetzVolumePfad: %@",NetzVolumePfad);
            NSMutableDictionary* tempUserDic=[[NSMutableDictionary alloc]initWithCapacity:0];//Dic fuer Volume
            
            [tempUserDic setObject:[NetzVolumePfad lastPathComponent] forKey:@"username"];		//Name des Users oder Volumes
            [tempUserDic setObject:[NetzVolumePfad lastPathComponent] forKey:@"host"];
            [tempUserDic setObject:NetzVolumePfad forKey:@"netzvolumepfad"];//Pfad des Volumes
            [tempUserDic setObject:[NSNumber numberWithBool:YES] forKey:@"loginOK"];
            
            
            
            //Pfad fuer SndCalcDaten in 'Documents'
            NSString*tempNetzUserSndCalcDatenPfad=[NetzVolumePfad stringByAppendingFormat:@"%@%@",@"/Documents/",SndCalcDatenOrdnerName];
            //NSLog(@"tempNetzUserSndCalcDatenPfad: %@",tempNetzUserSndCalcDatenPfad);
            BOOL UserSndCalcDatenOK=NO;	//Wird YES wenn SndCalcDaten in Documents des users ist
            
            //Pfad fuer SndCalcDaten auf Volume
            NSString*tempNetzVolumeSndCalcDatenPfad=[NetzVolumePfad stringByAppendingPathComponent:SndCalcDatenOrdnerName];
            //NSLog(@"tempNetzVolumeSndCalcDatenPfad: %@",tempNetzVolumeSndCalcDatenPfad);
            BOOL VolumeSndCalcDatenOK=NO;	//Wird YES, wenn SndCalcDaten auf Volume ist
            
            int SndCalcDatenOrt=0;		//wird 1 wenn SndCalcDaten auf Volume ist, 2 wenn in 'Documents'
            
            //leere Strings einsetzen
            [tempUserDic setObject:[NSString string] forKey:@"userSndCalcDatenpfad"];
            [tempUserDic setObject:[NSString string] forKey:@"volumeSndCalcDatenpfad"];//leerer String
            
            //Pruefen, ob auf 'NetzVolumePfad' ein 'Documents'-Ordner mit einer SndCalcDaten vorhanden ist
            if ([Filemanager fileExistsAtPath:tempNetzUserSndCalcDatenPfad isDirectory:&istOrdner]&&istOrdner)
            {
               NSMutableArray* tempArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempNetzUserSndCalcDatenPfad error:NULL];
               [tempArray removeObject:@".DS_Store"];
               if ([tempArray count])
               {
                  //SndCalcDaten in 'Documents'
                  //NSLog(@"SndCalcDaten in 'Documents':	tempNetzUserSndCalcDatenPfad: %@",tempNetzUserSndCalcDatenPfad);
                  //NSLog(@"SndCalcDaten in 'Documents':	tempNetzUserSndCalcDaten: %@",[[Filemanager directoryContentsAtPath:tempNetzUserSndCalcDatenPfad]description]);
                  UserSndCalcDatenOK=YES;//SndCalcDaten ist da
                  SndCalcDatenOrt=2;		//in 'Documents'
                  UserMitSndCalcDatenDa=YES;
                  [tempUserDic setObject:tempNetzUserSndCalcDatenPfad forKey:@"volumeSndCalcDatenpfad"];
               }
               
            }
            
            //Pruefen, ob auf 'tempNetzVolumeSndCalcDatenPfad' eine ordner SndCalcDaten vorhanden ist
            else if ([Filemanager fileExistsAtPath:tempNetzVolumeSndCalcDatenPfad isDirectory:&istOrdner]&&istOrdner)
            {
               NSMutableArray* tempArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempNetzVolumeSndCalcDatenPfad error:NULL];
               [tempArray removeObject:@".DS_Store"];
               if ([tempArray count])
               {
                  //SndCalcDaten auf Volume
                  //NSLog(@"SndCalcDaten auf Volume:		tempNetzVolumeSndCalcDatenPfad: %@",tempNetzVolumeSndCalcDatenPfad);
                  //NSLog(@"SndCalcDaten auf Volume:	tempNetzVolumeSndCalcDatenPfad: %@",[[Filemanager directoryContentsAtPath:tempNetzVolumeSndCalcDatenPfad]description]);
                  VolumeSndCalcDatenOK=YES;//SndCalcDaten ist da
                  UserMitSndCalcDatenDa=YES;
                  SndCalcDatenOrt=1;	//auf Volume
                  [tempUserDic setObject:tempNetzVolumeSndCalcDatenPfad forKey:@"volumeSndCalcDatenpfad"];
               }
               
            }
            [tempUserDic setObject:[NSNumber numberWithBool:UserSndCalcDatenOK] forKey:@"userSndCalcDatenOK"];
            [tempUserDic setObject:[NSNumber numberWithBool:VolumeSndCalcDatenOK] forKey:@"volumeSndCalcDatenOK"];
            [tempUserDic setObject:[NSNumber numberWithInt:SndCalcDatenOrt] forKey:@"SndCalcDatenort"];
            
            [UserMitSndCalcDatenArray addObject:tempUserDic];//Dic fuerr das Volume anfuegen;
            
            
            
            
            /*
             NSMutableArray* KlassenordnerArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:NetzVolumePfad error:NULL];
             //NSLog(@"KlassenordnerArray: %@",[KlassenordnerArray description]);
             
             int KlassenordnerIndex=0;
             for (KlassenordnerIndex=0;KlassenordnerIndex<[KlassenordnerArray count];KlassenordnerIndex++)
             {
             
             
             NSMutableDictionary* tempUserDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];//Dic fuer Volume
             NSString* tempVolumeName=[KlassenordnerArray objectAtIndex:KlassenordnerIndex];
             NSLog(@"tempVolumeName: %@",tempVolumeName);
             
             
             NSString* tempNetzVolumePfad=[NetzVolumePfad stringByAppendingPathComponent:[KlassenordnerArray objectAtIndex:KlassenordnerIndex]];
             
             
             NSLog(@"index: %d tempNetzVolumePfad: %@",KlassenordnerIndex,tempNetzVolumePfad);
             
             
             [tempUserDic setObject:[KlassenordnerArray objectAtIndex:KlassenordnerIndex] forKey:@"username"];		//Name des Users oder Volumes
             [tempUserDic setObject:[KlassenordnerArray objectAtIndex:KlassenordnerIndex] forKey:@"host"];
             [tempUserDic setObject:tempNetzVolumePfad forKey:@"netzvolumepfad"];//Pfad des Volumes
             [tempUserDic setObject:[NSNumber numberWithBool:YES] forKey:@"loginOK"];
             
             
             
             //Pruefen, ob auf 'NetzVolumePfad' ein 'Documents'-Ordner mit einer SndCalcDaten vorhanden ist
             
             //Pfad fuer SndCalcDaten in 'Documents'
             NSString*tempNetzUserSndCalcDatenPfad=[tempNetzVolumePfad stringByAppendingFormat:@"/Documents/%@",SndCalcDatenOrdnerName];
             //NSLog(@"tempNetzUserSndCalcDatenPfad: %@",tempNetzUserSndCalcDatenPfad);
             BOOL UserSndCalcDatenOK=NO;	//Wird YES wenn SndCalcDaten in Documents des users ist
             
             //Pfad fuer SndCalcDaten auf Volume
             //NSString*tempNetzVolumeSndCalcDatenPfad=[tempNetzVolumePfad stringByAppendingPathComponent:SndCalcDatenOrdnerName];
             //NSLog(@"tempNetzVolumeSndCalcDatenPfad: %@",tempNetzVolumeSndCalcDatenPfad);
             BOOL VolumeSndCalcDatenOK=NO;	//Wird YES, wenn SndCalcDaten auf Volume ist
             
             int SndCalcDatenOrt=0;		//wird 1 wenn SndCalcDaten auf Volume ist, 2 wenn in 'Documents'
             
             //leere Strings einsetzen
             [tempUserDic setObject:[NSString string] forKey:@"userSndCalcDatenpfad"];
             [tempUserDic setObject:[NSString string] forKey:@"volumeSndCalcDatenpfad"];//leerer String
             
             if ([Filemanager fileExistsAtPath:tempNetzUserSndCalcDatenPfad isDirectory:&istOrdner]&&istOrdner)
             {
             NSMutableArray* tempArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempNetzUserSndCalcDatenPfad error:NULL];
             [tempArray removeObject:@".DS_Store"];
             if ([tempArray count])
             {
             if ([tempArray  containsObject:@"Data"])
             {
             //SndCalcDaten in 'Documents'
             //NSLog(@"SndCalcDaten in 'Documents':	tempNetzUserSndCalcDatenPfad: %@",tempNetzUserSndCalcDatenPfad);
             //NSLog(@"SndCalcDaten in 'Documents':	tempNetzUserSndCalcDaten: %@",[[Filemanager directoryContentsAtPath:tempNetzUserSndCalcDatenPfad]description]);
             UserSndCalcDatenOK=YES;//SndCalcDaten ist da
             SndCalcDatenOrt=2;		//in 'Documents'
             UserMitSndCalcDatenDa=YES;
             
             [tempUserDic setObject:tempNetzUserSndCalcDatenPfad forKey:@"volumeSndCalcDatenpfad"];
             }
             }
             
             }
             
             //Pruefen, ob auf 'tempNetzVolumePfad' eine ordner SndCalcDaten vorhanden ist
             else if ([Filemanager fileExistsAtPath:tempNetzVolumePfad isDirectory:&istOrdner]&&istOrdner)
             {
             NSMutableArray* tempArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempNetzVolumePfad error:NULL];
             [tempArray removeObject:@".DS_Store"];
             //NSLog(@"SndCalcDaten auf VolumePfad:	tempNetzVolumePfad: %@",[tempArray description]);
             if ([tempArray count])
             {
             if ([tempArray  containsObject:@"SndCalc.plist"])
             {
             //SndCalcDaten auf Volume
             //NSLog(@"SndCalcDaten auf Volume:		tempNetzVolumeSndCalcDatenPfad: %@",tempNetzVolumeSndCalcDatenPfad);
             //NSLog(@"SndCalcDaten auf Volume:	tempNetzVolumeSndCalcDatenPfad: %@",[[Filemanager directoryContentsAtPath:tempNetzVolumePfad]description]);
             VolumeSndCalcDatenOK=YES;//SndCalcDaten ist da
             UserMitSndCalcDatenDa=YES;
             SndCalcDatenOrt=1;	//auf Volume
             [tempUserDic setObject:tempNetzVolumePfad forKey:@"volumeSndCalcDatenpfad"];
             }
             }
             
             }
             
             //           if (VolumeSndCalcDatenOK)
             {
             [tempUserDic setObject:[NSNumber numberWithBool:UserSndCalcDatenOK] forKey:@"userSndCalcDatenOK"];
             [tempUserDic setObject:[NSNumber numberWithBool:VolumeSndCalcDatenOK] forKey:@"volumeSndCalcDatenOK"];
             [tempUserDic setObject:[NSNumber numberWithInt:SndCalcDatenOrt] forKey:@"SndCalcDatenort"];
             
             [UserMitSndCalcDatenArray addObject:tempUserDic];//Dic fuerr das Volume anfuegen;
             }
             } // for KlassenordnerIndex
             */
            //
         }
      }//for volumesIndex
      
      //NSLog(@"UserMitSndCalcDatenArray: %@",[UserMitSndCalcDatenArray description]);
      
      if ([UserMitSndCalcDatenArray count])//Volumes mit SndCalcDaten vorhanden
      {
         
      }
      
   }//volumesArray count
   else
   {
      
      //kein mountedVolume: OpenPanel
      
   }
   
   //NSLog(@"***   Utils: UserMitSndCalcDatenArray: %@",[UserMitSndCalcDatenArray description]);
   return UserMitSndCalcDatenArray;
}


- (NSDictionary*)DatenDicForUser:(NSString*)derName anPfad:(NSString*)derPfad
{
   /*
    Der returnDic enthält die Daten unter dem Key "userplist"!!
    */
   //NSLog(@"NamenDicFor: %@ anPfad: %@",derName,derPfad);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSMutableDictionary* returnDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
   BOOL SndCalcOrdnerOK=NO;
   BOOL UserDatenOrdnerOK=NO;
   BOOL UserNamenOrderOK=NO;
   BOOL UserPlistOK=NO;
   BOOL istOrdner=NO;
   NSDictionary* UserPlist;
   if (([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner])&&istOrdner)
   {
      NSString* DatenOrdnerPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];//Ordner mit den Userdaten
      if (([Filemanager fileExistsAtPath:DatenOrdnerPfad isDirectory:&istOrdner])&&istOrdner)//Datenordner ist da
      {
         UserDatenOrdnerOK=YES;
         //NSArray* tempNamenArray=[Filemanager directoryContentsAtPath:DatenOrdnerPfad];
         NSString* UserDatenOrdnerPfad=[DatenOrdnerPfad stringByAppendingPathComponent:derName];//Ordner mit den Daten des Users
         if (([Filemanager fileExistsAtPath:UserDatenOrdnerPfad isDirectory:&istOrdner])&&istOrdner)//Datenordner ist da
         {
            UserNamenOrderOK=YES;
            NSString* UserDatenPfad=[UserDatenOrdnerPfad stringByAppendingPathComponent:@"Data"];//Ordner mit den Daten des Users
            if (([Filemanager fileExistsAtPath:UserDatenPfad ]))//plist ist da
            {
               UserPlist=[NSDictionary dictionaryWithContentsOfFile:UserDatenPfad];
               if (UserPlist)
               {
                  [returnDictionary setObject:UserPlist forKey:@"userplist"];
                  UserPlistOK=YES;
               }
               
            }
            else
            {
               //Keine plist
            }
            
         }
         else
         {
            //Kein Ordner fuer derName
         }
      }
      else
      {
         //Kein UserDatenOrdner
         
      }
      
      
      
   }
   else
   {
      //Kein SndCalcOrdner
      
   }
   [returnDictionary setObject:[NSNumber numberWithBool:UserDatenOrdnerOK] forKey:@"userdatenordnerok"];
   [returnDictionary setObject:[NSNumber numberWithBool:UserNamenOrderOK] forKey:@"usernamenordnerok"];
   //[returnDictionary setObject:[NSNumber numberWithBool:SndCalcOrdnerOK] forKey:@"sndcalcordnerok"];
   [returnDictionary setObject:[NSNumber numberWithBool:UserPlistOK] forKey:@"userplistok"];
   
   
   return returnDictionary;
}

- (BOOL)setDatenDic:(NSDictionary*)derDic forUser:(NSString*)derName anPfad:(NSString*)derPfad
{
   BOOL DatenDicOK=YES;
   //NSLog(@"setDatenDic: %@ \nforUser: %@ anPfad: %@",[derDic description], derName, derPfad);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   NSString* DatenOrdnerPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];//Ordner mit den Userdaten
   if (!([Filemanager fileExistsAtPath:DatenOrdnerPfad isDirectory:&istOrdner]&&istOrdner))//Kein UserDatenOrdner
   {
      //BOOL OK=[Filemanager createDirectoryAtPath:DatenOrdnerPfad attributes:nil];
      
      BOOL OK = [Filemanager createDirectoryAtPath:DatenOrdnerPfad withIntermediateDirectories:NO attributes:NULL error:NULL];
      
      if (!OK){return NO;}
   }
   
   NSString* UserDatenOrdnerPfad=[DatenOrdnerPfad stringByAppendingPathComponent:derName];//Ordner mit den Daten des Users
   if (!([Filemanager fileExistsAtPath:UserDatenOrdnerPfad isDirectory:&istOrdner]&&istOrdner))//Kein UserDatenOrdner
   {
      //BOOL OK=[Filemanager createDirectoryAtPath:UserDatenOrdnerPfad attributes:nil];
      
      BOOL OK = [Filemanager createDirectoryAtPath:UserDatenOrdnerPfad withIntermediateDirectories:NO attributes:NULL error:NULL];
      
      if (!OK){return NO;}
   }
			
   NSString* UserDatenPfad=[UserDatenOrdnerPfad stringByAppendingPathComponent:@"Data"];//Adresse mit den Daten des Users
			//NSLog(@"UserDatenPfad: %@",UserDatenPfad);
   DatenDicOK=[derDic writeToFile:UserDatenPfad atomically:YES];
   
   return DatenDicOK;
}



- (NSArray*)NamenDicArrayAnPfad:(NSString*)derPfad
{
   //NSLog(@"NamenDicArrayAnPfad:  %@",derPfad);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSMutableArray* returnNamenDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   BOOL SndCalcOrdnerOK=NO;
   BOOL UserDatenOrdnerOK=NO;
   BOOL UserNamenOrderOK=NO;
   BOOL UserPlistOK=NO;
   BOOL istOrdner=NO;
   
   if (([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner])&&istOrdner)
   {
      NSString* DatenOrdnerPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];//Ordner mit den Userdaten
      if (([Filemanager fileExistsAtPath:DatenOrdnerPfad isDirectory:&istOrdner])&&istOrdner)//Datenordner ist da
      {
         UserDatenOrdnerOK=YES;
         NSMutableArray* tempNamenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:DatenOrdnerPfad error:NULL];
         [tempNamenArray removeObject:@".DS_Store"];
         //NSLog(@"NamenDicArrayAnPfad:tempNamenArray %@",[tempNamenArray description]);
         
         NSEnumerator* NamenEnum=[tempNamenArray objectEnumerator];
         id einName;
         while (einName=[NamenEnum nextObject])
         {
            //NSMutableDictionary* tempNamenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
            //NSArray* tempNamenArray=[Filemanager directoryContentsAtPath:DatenOrdnerPfad];
            NSString* UserDatenOrdnerPfad=[DatenOrdnerPfad stringByAppendingPathComponent:einName];//Ordner mit den Daten des Users
            //NSLog(@"NamenDicArrayAnPfad:UserDatenOrdnerPfad: %@",UserDatenOrdnerPfad);
            if (([Filemanager fileExistsAtPath:UserDatenOrdnerPfad isDirectory:&istOrdner])&&istOrdner)//Datenordner ist da
            {
               //NSLog(@"NamenDicArrayAnPfad: ordner da");
               UserNamenOrderOK=YES;
               NSString* UserDatenPfad=[UserDatenOrdnerPfad stringByAppendingPathComponent:@"Data"];//Ordner mit den Daten des Users
               if (([Filemanager fileExistsAtPath:UserDatenPfad ]))//plist ist da
               {
                  //NSLog(@"NamenDicArrayAnPfad: Data ist da");
                  NSDictionary* tempNamenDic=[NSDictionary dictionaryWithContentsOfFile:UserDatenPfad];
                  //NSLog(@"NamenDicArrayAnPfad:tempNamenDic %@",[tempNamenDic description]);
                  if (tempNamenDic)
                  {
                     [returnNamenDicArray addObject:tempNamenDic];
                  }
                  
               }
               else
               {
                  //Keine plist
               }
               
            }
            else
            {
               //Kein Ordner fuer derName
            }
         }//while
      }
      else
      {
         //Kein UserDatenOrdner
         
      }
      
      
      
   }
   else
   {
      //Kein SndCalcOrdner
      
   }
   //NSLog(@"NamenDicArrayAnPfad:returnNamenDicArray %@",[[returnNamenDicArray valueForKey:@"usertestarray"]description]);
   //NSLog(@"NamenDicArrayAnPfad:returnNamenDicArray: %@",[[returnNamenDicArray valueForKey:@"name"]description]);
   
   return returnNamenDicArray;
   
}


- (BOOL)checkChangeNamenListe:(NSArray*)derNamenDicArray anPfad:(NSString*)derPfad
{
   //NSLog(@"checkChangeNamenListe:  %@\n%@",[derNamenDicArray description],derPfad);
   BOOL UserDatenOrdnerOK=NO;
   BOOL istOrdner=NO;
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   if (!([Filemanager fileExistsAtPath:derPfad]))//neue Einrichtung
   {
      //BOOL OK=[Filemanager createDirectoryAtPath:derPfad attributes:nil];
      BOOL OK = [Filemanager createDirectoryAtPath:derPfad withIntermediateDirectories:NO attributes:NULL error:NULL];
      
      
      NSLog(@"SndCalcDaten einrichten OK: %hhd",OK);
      if (OK==NO)
      {
         return OK;
      }
   }
   
   NSString* DatenOrdnerPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];
   if (!([Filemanager fileExistsAtPath:DatenOrdnerPfad]))//neuer Datenordner
   {
      //BOOL OK=[Filemanager createDirectoryAtPath:DatenOrdnerPfad attributes:nil];
      //NSLog(@"DatenOrdner einrichten OK: %d",OK);
      
      BOOL OK = [Filemanager createDirectoryAtPath:DatenOrdnerPfad withIntermediateDirectories:NO attributes:NULL error:NULL];
      
      if (OK==NO)
      {
         return OK;
      }
      
   }
   else
   {
   }
   
   if (([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner])&&istOrdner)
   {
      NSString* DatenOrdnerPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];//Ordner mit den Userdaten
      if (([Filemanager fileExistsAtPath:DatenOrdnerPfad isDirectory:&istOrdner])&&istOrdner)//Datenordner ist da
      {
         UserDatenOrdnerOK=YES;
         NSArray* tempNamenArray=[derNamenDicArray valueForKey:@"name"];
         
         //NSLog(@"NamenDicArrayAnPfad:tempNamenArray %@",[tempNamenArray description]);
         //Array der Namen im NamenDicArray: Eventuell hat es neue Namen
         
         NSEnumerator* NamenEnum=[tempNamenArray objectEnumerator];
         id einName;
         int index=0;
         while (einName=[NamenEnum nextObject])
         {
            if (!([einName isEqualToString:@"Gast"]))
            {
               //NSArray* tempNamenArray=[Filemanager directoryContentsAtPath:DatenOrdnerPfad];
               NSString* UserDatenOrdnerPfad=[DatenOrdnerPfad stringByAppendingPathComponent:einName];//Ordner mit den Daten des Users
               if (([Filemanager fileExistsAtPath:UserDatenOrdnerPfad isDirectory:&istOrdner])&&istOrdner)//Datenordner ist da
               {
                  UserDatenOrdnerOK=YES;
                  //'aktiv' pruefen
                  BOOL istAktiv=YES;
                  NSNumber* istAktivNumber=[[derNamenDicArray objectAtIndex:index]objectForKey:@"aktiv"];
                  if (istAktivNumber)
                  {
                     istAktiv=[istAktivNumber boolValue];
                  }
                  //'aktiv' in Data setzen
                  NSString* UserDatenPfad=[UserDatenOrdnerPfad stringByAppendingPathComponent:@"Data"];
                  if ([Filemanager fileExistsAtPath:UserDatenPfad])
                  {
                     NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithContentsOfFile:UserDatenPfad];
                     if (tempDataDic)
                     {
                        [tempDataDic setObject:[NSNumber numberWithBool:istAktiv] forKey:@"aktiv"];
                        BOOL OK=[tempDataDic writeToFile:UserDatenPfad atomically:YES];
                     }
                     
                  }
                  
               }
               else
               {
                  //Kein Datenordner fuer derName: erstellen
                  //UserDatenOrdnerOK=[Filemanager createDirectoryAtPath:UserDatenOrdnerPfad attributes:NULL];
                  UserDatenOrdnerOK = [Filemanager createDirectoryAtPath:UserDatenOrdnerPfad withIntermediateDirectories:NO attributes:NULL error:NULL];
                  
                  NSMutableDictionary* tempDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
                  [tempDictionary setObject:einName forKey:@"name"];
                  
                  if ([[derNamenDicArray objectAtIndex:index]objectForKey:@"testarray"])
                  {
                     [tempDictionary setObject:[[derNamenDicArray objectAtIndex:index]objectForKey:@"testarray"] forKey:@"usertestarray"];
                  }
                  
                  [tempDictionary setObject:[NSNumber numberWithFloat:80.00] forKey:@"lastvolume"];
                  [tempDictionary setObject:[NSNumber numberWithInt:1] forKey:@"aktiv"];
                  NSString* UserDatenPfad=[UserDatenOrdnerPfad stringByAppendingPathComponent:@"Data"];
                  BOOL OK=[tempDictionary writeToFile:UserDatenPfad atomically:YES];
                  
               }
               index++;
            }//not Gast
            
         }//while
      }
      else
      {
         //Kein UserDatenOrdner
         
      }
      
      
      
   }
   else
   {
      //Kein SndCalcOrdner
      
   }
   return UserDatenOrdnerOK;
}

- (void)DeleteNamen:(NSString*)derName anPfad:(NSString*)derPfad
{
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   NSString* DatenOrdnerPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];//Ordner mit den Userdaten
   NSString* UserDatenOrdnerPfad=[DatenOrdnerPfad stringByAppendingPathComponent:derName];//Ordner mit den Daten des Users
   BOOL OK=[Filemanager removeItemAtPath:UserDatenOrdnerPfad error:nil];
   NSLog(@"Utils DeleteNamen: UserDatenOrdnerPfad: %@ OK: %d",UserDatenOrdnerPfad,OK);
   
}


- (BOOL)saveTestArray:(NSArray*)derTestArray anPfad:(NSString*)derPfad
{
   BOOL saveOK=NO;
   BOOL istOrdner=NO;
   //NSLog(@"Utils saveTestArray: %@	anPfad: %@",[derTestArray description],derPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      if (tempPListDic)
      {
         [tempPListDic setObject:derTestArray forKey:@"testarray"];
         saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
      }//if tempPlistDic
      else
      {
         NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempPListDic setObject:derTestArray forKey:@"testarray"];
         saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
      }
      
      
   }//if exists
   else
   {
      
   }
   return saveOK;
}


- (BOOL)saveTestName:(NSString*)derTestName anPfad:(NSString*)derPfad
{
   BOOL saveOK=NO;
   BOOL istOrdner=NO;
   NSLog(@"Utils saveTestName: %@	anPfad: %@",derTestName,derPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      if (tempPListDic)
      {
         if ([tempPListDic objectForKey:@"testarray"])
         {
            NSMutableArray* tempTestDicArray=[[NSMutableArray alloc]initWithArray:[tempPListDic objectForKey:@"testarray"]];
            NSArray*	tempTestNamenArray=[tempTestDicArray valueForKey:@"testname"];
            NSUInteger index=[tempTestNamenArray indexOfObject:derTestName];
            if (index==NSNotFound)//Testname noch nicht da
            {
               [tempTestDicArray addObject:derTestName];
               [tempPListDic setObject:tempTestDicArray forKey:@"testarray"];
               saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
               
            }
         }
         
      }//if tempPlistDic
      
      
   }//if exists
   else
   {
      
   }
   return saveOK;
}

- (BOOL)setAlle:(BOOL)derStatus forTest:(NSString*)derTestName anPfad:(NSString*)derPfad
{
   BOOL setOK=NO;
   BOOL istOrdner=NO;
   //NSLog(@"saveTestArray: %@	anPfad: %@",[derTestArray description],derPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      if (tempPListDic)
      {
         if ([tempPListDic objectForKey:@"testarray"])
         {
            NSMutableArray* tempTestDicArray=[tempPListDic objectForKey:@"testarray"];
            NSArray*	tempTestNamenArray=[tempTestDicArray valueForKey:@"testname"];
            NSUInteger index=[tempTestNamenArray indexOfObject:derTestName];
            if (index<NSNotFound)//Testname ist da
            {
               NSNumber* StatusNumber=[NSNumber numberWithBool:derStatus];
               [[tempTestDicArray objectAtIndex:index]setObject:StatusNumber forKey:@"alle"];
               
               //			[tempPListDic setObject:tempTestDicArray forKey:@"testarray"];
               setOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
               
            }
         }
         
      }//if tempPlistDic
      
      
   }//if exists
   else
   {
      
   }
   return setOK;
}




- (BOOL)deleteTestName:(NSString*)derTestName anPfad:(NSString*)derPfad
{
   BOOL deleteOK=NO;
   BOOL istOrdner=NO;
   //NSLog(@"deleteTestName: %@	anPfad: %@",derTestName,derPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      if (tempPListDic)
      {
         if ([tempPListDic objectForKey:@"testarray"])
         {
            NSMutableArray* tempTestDicArray=[[NSMutableArray alloc]initWithArray:[tempPListDic objectForKey:@"testarray"]];
            //				NSLog(@"Utils deleteTestName: tempTestDicArray: %@",[tempTestDicArray description]);
            NSArray*	tempTestNamenArray=[tempTestDicArray valueForKey:@"testname"];
            //				NSLog(@"Utils deleteTestName: tempTestNamenArray: %@",[tempTestNamenArray description]);
            NSUInteger index=[tempTestNamenArray indexOfObject:derTestName];
            if (!(index==NSNotFound))
            {
               //	NSLog(@"delete Test: %@",derTestName);
               [tempTestDicArray removeObjectAtIndex:index];
               [tempPListDic setObject:tempTestDicArray forKey:@"testarray"];
               deleteOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
               
            }
         }
         
      }//if tempPlistDic
      
      
   }//if exists
   else
   {
      
   }
   [self clearTestForAll:derTestName nurAktiveUser:NO anPfad:derPfad];
   return deleteOK;
}

- (void)deleteInvalidTestsAnPfad:(NSString*)derPfad
{
   NSLog(@"deleteInvalidTestsAnPfad");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   BOOL UserDatenOrdnerOK;
   BOOL UserWarnungOK=YES;
   if (([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner])&&istOrdner)
   {
      NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];//Pfad der PList
      NSMutableArray* tempTestNamenArray;//Array der vorhandenen Testnamen in der PList
      if ([Filemanager fileExistsAtPath:tempPListPfad])//Datenordner ist da
      {
         
         NSDictionary* tempPListDic=[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
         if (tempPListDic && [tempPListDic objectForKey:@"testarray"])
         {
            tempTestNamenArray=[[tempPListDic objectForKey:@"testarray"]valueForKey:@"testname"];
            NSLog(@"deleteInvalidTestsAnPfad:tempTestNamenArray %@",[tempTestNamenArray description]);
         }
         
         
      }
      
      NSString* DatenOrdnerPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];//Ordner mit den Userdaten
      if (([Filemanager fileExistsAtPath:DatenOrdnerPfad isDirectory:&istOrdner])&&istOrdner)//Datenordner ist da
      {
         NSMutableArray* tempInvalidErgebnisDicArray=[[NSMutableArray alloc]initWithCapacity:0];
         
         
         UserDatenOrdnerOK=YES;
         NSMutableArray* tempNamenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:DatenOrdnerPfad error:NULL];
         [tempNamenArray removeObject:@".DS_Store"];
         //NSLog(@"deleteInvalidTestsAnPfad:tempNamenArray %@",[tempNamenArray description]);
         
         NSEnumerator* NamenEnum=[tempNamenArray objectEnumerator];
         id einName;
         while (einName=[NamenEnum nextObject])
         {
            NSMutableDictionary* tempErgebnisDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [tempErgebnisDic setObject:einName forKey:@"name"];
            NSString*tempUserPListPfad=[[DatenOrdnerPfad stringByAppendingPathComponent:einName]stringByAppendingPathComponent:@"Data"];
            NSLog(@"tempUserPListPfad: %@",[[tempUserPListPfad stringByDeletingLastPathComponent]lastPathComponent]);
            
            NSMutableDictionary* tempUserPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempUserPListPfad];
            //NSLog(@"tempUserPListDic %@",[tempUserPListDic description]);
            if (tempUserPListDic && [tempUserPListDic objectForKey:@"ergebnisdicarray"])
            {
               NSArray* tempErgebnisTestnamenArray=[[tempUserPListDic objectForKey:@"ergebnisdicarray"]valueForKey:@"testname"];
               //NSLog(@"tempErgebnisTestnamenArray von: %@ einName:  %@",einName,[tempErgebnisTestnamenArray description]);
               NSMutableArray* tempInvalidErgebnisTestNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
               NSMutableArray* tempValidErgebnisDicArray=[[NSMutableArray alloc]initWithCapacity:0];
               NSEnumerator* ErgebnisEnum=[tempErgebnisTestnamenArray objectEnumerator];
               id einErgebnisTestName;
               int index=0;
               
               while (einErgebnisTestName=[ErgebnisEnum nextObject])
               {
                  if ([tempTestNamenArray containsObject:einErgebnisTestName])
                  {
                     [tempValidErgebnisDicArray addObject:[[tempUserPListDic objectForKey:@"ergebnisdicarray"]objectAtIndex:index]];
                  }
                  else
                  {
                     [tempInvalidErgebnisTestNamenArray addObject:einErgebnisTestName];
                     
                  }
                  index++;
               }//while
               if ([tempInvalidErgebnisTestNamenArray count])//Es hat ungueltige Ergebnisse
               {
                  NSLog(@"tempInvalidErgebnisTestNamenArray: %@",[tempInvalidErgebnisTestNamenArray description]);
                  if (UserWarnungOK)
                  {
                     UserWarnungOK=NO;
                     NSAlert *Warnung = [[NSAlert alloc] init];
                     [Warnung addButtonWithTitle:@"OK"];
                     //	[Warnung addButtonWithTitle:@""];
                     //	[Warnung addButtonWithTitle:@""];
                     [Warnung addButtonWithTitle:@"Abbrechen"];
                     NSString* MessageString=NSLocalizedString(@"Delete invalid results",@"Ungültige Ergebnisse löschen");
                     [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
                     
                     NSString* s1=NSLocalizedString(@" Results will be definetly deleted.",@" Ergebnisse werden endgültig gelöscht.");
                     NSString* s2=@"";
                     NSString* InformationString=[NSString stringWithFormat:@"%d%@\n%@",[tempInvalidErgebnisTestNamenArray count],s1,s2];
                     [Warnung setInformativeText:InformationString];
                     [Warnung setAlertStyle:NSWarningAlertStyle];
                     
                     //[Warnung setIcon:RPImage];
                     int antwort=[Warnung runModal];
                     
                     switch (antwort)
                     {
                        case NSAlertFirstButtonReturn://	1000
                        {
                           NSLog(@"NSAlertFirstButtonReturn");
                           NSLog(@"tempValidErgebnisDicArray: %@",[tempValidErgebnisDicArray valueForKey:@"testname"]);
                           [tempErgebnisDic setObject:tempInvalidErgebnisTestNamenArray forKey:@"invalid"];
                           [tempUserPListDic setObject:tempValidErgebnisDicArray forKey:@"ergebnisdicarray"];
                           [tempUserPListDic writeToFile:tempUserPListPfad atomically:YES];
                           
                        }break;
                           
                        case NSAlertSecondButtonReturn://1001
                        {
                           NSLog(@"NSAlertSecondButtonReturn");
                           
                        }break;
                           
                     }//switch
                  }//if UserWarnungOK
                  NSLog(@"tempValidErgebnisDicArray: %@",[tempValidErgebnisDicArray valueForKey:@"testname"]);
                  //						[tempErgebnisDic setObject:tempInvalidErgebnisTestNamenArray forKey:@"invalid"];
                  //						[tempUserPListDic setObject:tempValidErgebnisDicArray forKey:@"ergebnisdicarray"];
                  //						[tempUserPListDic writeToFile:tempUserPListPfad atomically:YES];
                  
               }
            }
            
            
            
            [tempInvalidErgebnisDicArray addObject:tempErgebnisDic];
         }//while einName
         
         NSLog(@"tempInvalidErgebnisDicArray: %@",[tempInvalidErgebnisDicArray description]);
         
         
         
      }//Datenordner da
      
   }
}

- (void)ErgebnisseBehaltenBisAnzahl:(int)dieAnzahl anPfad:(NSString*)derPfad
{
   NSLog(@"ErgebnisseBehaltenBisAnzahl: %d",dieAnzahl);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   BOOL UserDatenOrdnerOK;
   if (([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner])&&istOrdner)
   {
      NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];//Pfad der PList
      NSMutableArray* tempTestNamenArray;//Array der vorhandenen Testnamen in der PList
      if ([Filemanager fileExistsAtPath:tempPListPfad])//Datenordner ist da
      {
         
         NSDictionary* tempPListDic=[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
         if (tempPListDic && [tempPListDic objectForKey:@"testarray"])
         {
            tempTestNamenArray=[[tempPListDic objectForKey:@"testarray"]valueForKey:@"testname"];
            NSLog(@"ErgebnisseBehaltenBisAnzahl:tempTestNamenArray %@",[tempTestNamenArray description]);
         }
         
         
      }
      
      
      
      
      
      
      
      NSString* DatenOrdnerPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];//Ordner mit den Userdaten
      if (([Filemanager fileExistsAtPath:DatenOrdnerPfad isDirectory:&istOrdner])&&istOrdner)//Datenordner ist da
      {
         
         UserDatenOrdnerOK=YES;
         NSMutableArray* tempNamenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:DatenOrdnerPfad error:NULL];
         [tempNamenArray removeObject:@".DS_Store"];
         //NSLog(@"ErgebnisseBehaltenBisAnzahl:tempNamenArray %@",[tempNamenArray description]);
         
         NSEnumerator* NamenEnum=[tempNamenArray objectEnumerator];
         id einName;
         while (einName=[NamenEnum nextObject])
         {
            NSMutableDictionary* tempErgebnisDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [tempErgebnisDic setObject:einName forKey:@"name"];
            NSString*tempUserPListPfad=[[DatenOrdnerPfad stringByAppendingPathComponent:einName]stringByAppendingPathComponent:@"Data"];
            //NSLog(@"tempUserPListPfad: %@",[[tempUserPListPfad stringByDeletingLastPathComponent]lastPathComponent]);
            
            NSMutableDictionary* tempUserPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempUserPListPfad];
            //NSLog(@"tempUserPListDic %@",[tempUserPListDic description]);
            if (tempUserPListDic && [tempUserPListDic objectForKey:@"ergebnisdicarray"])
            {
               NSMutableArray* tempErgebnisDicArray=(NSMutableArray*)[tempUserPListDic objectForKey:@"ergebnisdicarray"];
               //NSLog(@"tempErgebnisTestnamenArray von: %@ einName:  %@",einName,[tempErgebnisTestnamenArray description]);
               if ([tempErgebnisDicArray count]>dieAnzahl)
               {
                  NSRange deleteRange=NSMakeRange(dieAnzahl,[tempErgebnisDicArray count]-dieAnzahl);
                  [tempErgebnisDicArray removeObjectsInRange:deleteRange];
               }
               
               
               NSLog(@"tempErgebnisDicArray nach reduktion: %@",[[tempErgebnisDicArray valueForKey:@"testname"]description]);
               //					[tempUserPListDic setObject:tempValidErgebnisDicArray forKey:@"ergebnisdicarray"];
               [tempUserPListDic writeToFile:tempUserPListPfad atomically:YES];
            }
            
            
            
         }//while einName
         
         
         
         
      }//Datenordner da
      
   }
}

- (void)deleteErgebnisseVonTest:(NSString*)derTest anPfad:(NSString*)derPfad
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSMutableArray* returnNamenDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   BOOL SndCalcOrdnerOK=NO;
   BOOL UserDatenOrdnerOK=NO;
   BOOL UserNamenOrderOK=NO;
   BOOL UserPlistOK=NO;
   BOOL istOrdner=NO;
   
   if (([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner])&&istOrdner)
   {
      NSString* DatenOrdnerPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];//Ordner mit den Userdaten
      if (([Filemanager fileExistsAtPath:DatenOrdnerPfad isDirectory:&istOrdner])&&istOrdner)//Datenordner ist da
      {
         UserDatenOrdnerOK=YES;
         NSMutableArray* tempNamenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:DatenOrdnerPfad error:NULL];
         [tempNamenArray removeObject:@".DS_Store"];
         //NSLog(@"NamenDicArrayAnPfad:tempNamenArray %@",[tempNamenArray description]);
         
         NSEnumerator* NamenEnum=[tempNamenArray objectEnumerator];
         id einName;
         while (einName=[NamenEnum nextObject])
         {
            //NSMutableDictionary* tempNamenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
            //NSArray* tempNamenArray=[Filemanager directoryContentsAtPath:DatenOrdnerPfad];
            NSString* UserDatenOrdnerPfad=[DatenOrdnerPfad stringByAppendingPathComponent:einName];//Ordner mit den Daten des Users
            if (([Filemanager fileExistsAtPath:UserDatenOrdnerPfad isDirectory:&istOrdner])&&istOrdner)//Datenordner ist da
            {
               UserNamenOrderOK=YES;
               NSString* UserDatenPfad=[UserDatenOrdnerPfad stringByAppendingPathComponent:@"Data"];//Ordner mit den Daten des Users
               if (([Filemanager fileExistsAtPath:UserDatenPfad ]))//plist ist da
               {
                  NSDictionary* tempNamenDic=[NSDictionary dictionaryWithContentsOfFile:UserDatenPfad];
                  if (tempNamenDic)
                  {
                     NSMutableArray* tempErgebnisDicArray=(NSMutableArray*)[tempNamenDic objectForKey:@"ergebnisdicarray"];
                     //NSLog(@"		User: %@",[tempNamenDic objectForKey:@"name"]);
                     //NSLog(@"Ergebnisarray: %@",[[tempNamenDic objectForKey:@"ergebnisdicarray"]valueForKey:@"testname"]);
                     
                     if (tempErgebnisDicArray)//Array existiert
                     {
                        NSUInteger durchlauf=[tempErgebnisDicArray count];
                        NSInteger ergebnisindex=-1;
                        while ((ergebnisindex<NSNotFound)&&durchlauf)
                        {
                           ergebnisindex=[[tempErgebnisDicArray valueForKey:@"testname"]indexOfObject:derTest];
                           if ((ergebnisindex<NSNotFound)&&(ergebnisindex<NSNotFound))//Test noch vorhanden
                           {
                              //NSLog(@"Ergebnis fuer Test: %@ ist da an index: %d",derTest,ergebnisindex);
                              [tempErgebnisDicArray removeObjectAtIndex:ergebnisindex];
                           }
                           durchlauf--;
                        }//while ergebnisindex
                        
                        
                        
                        
                     }//if tempErgebnisDicArray
                     
                     
                     BOOL writeOK=[tempNamenDic writeToFile:UserDatenPfad atomically:YES];
                  }
                  
               }
               else
               {
                  //Keine plist
               }
               
            }
            else
            {
               //Kein Ordner fuer derName
            }
         }//while einName
      }
      else
      {
         //Kein UserDatenOrdner
         
      }
      
      
      
   }
   else
   {
      //Kein SndCalcOrdner
      
   }
   
   
}

- (NSArray*)TestArrayAusPListAnPfad:(NSString*)derPfad
{
   BOOL istOrdner=NO;
   //NSLog(@"                 TestArrayAusPListAnPfad: %@",derPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSArray* tempTestDicArray=[NSArray array];
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSDictionary* tempPListDic=[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      if (tempPListDic)
      {
         //NSLog(@"Utils	    TestArrayAusPListAnPfad:       tempPListDic: %@",[tempPListDic description]);
         tempTestDicArray=[tempPListDic objectForKey:@"testarray"];
      }//if tempPlistDic
      else
      {
         NSLog(@"keine PList");
      }
      
      
   }//if exists
   else
   {
      
   }
   //NSLog(@"Utils	    TestArrayAusPListAnPfad: %@	anPfad: %@",[tempTestDicArray description],derPfad);
   return tempTestDicArray;
}


- (BOOL)saveAdminPW:(NSDictionary*)derPWDic anPfad:(NSString*)derPfad
{
   BOOL saveOK=NO;
   BOOL istOrdner=NO;
   //NSLog(@"saveAdminPW: %@	anPfad: %@",[derPWDic description],derPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      if (tempPListDic)
      {
         [tempPListDic setObject:derPWDic forKey:@"pwdic"];
         saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
      }//if tempPlistDic
      else
      {
         NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempPListDic setObject:derPWDic forKey:@"pwdic"];
         saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
      }
      
      
   }//if exists
   else
   {
      
   }
   return saveOK;
}

- (NSDate*)SessionDatumAnPfad:(NSString*)derPfad
{
   NSDate* tempSessionDatum=[NSDate date];
   NSCalendarDate* heute=[NSCalendarDate date];
   //	[heute setCalendarFormat:@"%d.%m.%Y    Zeit: %H:%M"];
   [heute setCalendarFormat:@"%d.%m.%Y"];
   int lastSessionTag=[heute dayOfYear];
   int heuteTag=[heute dayOfYear];
   int heuteMonat=[heute monthOfYear];
   //NSLog(@"SessionDatumAnPfad: heute: %@",[heute description]);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)//SndCaldDaten sind da
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      
      if (tempPListDic&&[tempPListDic objectForKey:@"sessiondatum"])
      {
         
         tempSessionDatum=[tempPListDic objectForKey:@"sessiondatum"];
         
      }
   }
   return tempSessionDatum;
}

- (BOOL)saveSessionDatum:(NSDate*)dasDatum anPfad:(NSString*)derPfad
{
   BOOL saveOK=NO;
   BOOL istOrdner=NO;
   NSLog(@"saveSessionDatum: %@	derPfad: %@",[dasDatum description],derPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      if (tempPListDic)
      {
         [tempPListDic setObject:dasDatum forKey:@"sessiondatum"];
         saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
      }//if tempPlistDic
      else
      {
         NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempPListDic setObject:dasDatum forKey:@"sessiondatum"];
         
         saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
      }
      
      
   }//if exists
   else
   {
      
   }
   return saveOK;
}



- (BOOL)saveSessionBehalten:(BOOL)behaltenOK anPfad:(NSString*)derPfad
{
   BOOL saveOK=NO;
   BOOL istOrdner=NO;
   NSLog(@"saveSessionBehalten: %d	anPfad: %@",behaltenOK,derPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      if (tempPListDic)
      {
         [tempPListDic setObject:[NSNumber numberWithBool:behaltenOK] forKey:@"sessionbehalten"];
         saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
      }//if tempPlistDic
      else
      {
         NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempPListDic setObject:[NSNumber numberWithBool:NO] forKey:@"sessionbehalten"];
         
         saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
      }
      
      
   }//if exists
   else
   {
      
   }
   NSLog(@"saveSessionBehalten:ende");
   return saveOK;
}


- (BOOL)SessionBehaltenAnPfad:(NSString*)derPfad
{
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   BOOL behaltenOK=NO;
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)//SndCaldDaten sind da
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      
      if (tempPListDic&&[tempPListDic objectForKey:@"sessionbehalten"])
      {
         
         behaltenOK=[[tempPListDic objectForKey:@"sessionbehalten"]boolValue];
         
      }
   }
   return behaltenOK;
   
}



- (BOOL)saveSessionBehaltenTag:(int)derTag anPfad:(NSString*)derPfad
{
   BOOL saveOK=NO;
   BOOL istOrdner=NO;
   NSLog(@"saveSessionBehaltenTag: %d	anPfad: %@",derTag,derPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      if (tempPListDic)
      {
         [tempPListDic setObject:[NSNumber numberWithInt:derTag] forKey:@"sessionbehaltentag"];
         saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
      }//if tempPlistDic
      
      
   }//if exists
   else
   {
      
   }
   return saveOK;
}

- (int)SessionBehaltenTagAnPfad:(NSString*)derPfad
{
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   NSCalendarDate* heute=[NSCalendarDate date];
   int SessionBehaltenTag=[heute dayOfYear]-1;//wenn keine andere Angabe
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)//SndCaldDaten sind da
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      
      if (tempPListDic&&[tempPListDic objectForKey:@"sessionbehaltentag"])
      {
         
         SessionBehaltenTag=[[tempPListDic objectForKey:@"sessionbehaltentag"]intValue];
         
      }
   }
   return SessionBehaltenTag;
}


- (BOOL) setPListBusy:(BOOL)derStatus anPfad:(NSString*)derPfad
{
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   BOOL saveOK=NO;
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)//SndCaldDaten sind da
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      
      if (tempPListDic)
      {
         [tempPListDic setObject:[NSNumber numberWithBool:derStatus] forKey:@"busy"];
         saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
      }//if temPListDic
   }
   return saveOK;
}

- (void)saveNote:(NSString*)dieNote forUser:(NSString*)derUser anPfad:(NSString*)derPfad
{
   //NSLog(@"saveNote");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   BOOL saveOK=NO;
   NSString* tempUserDatenPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];
   NSString* tempNamenPfad=[tempUserDatenPfad stringByAppendingPathComponent:derUser];
   if ([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempDatenPfad=[tempNamenPfad stringByAppendingPathComponent:@"Data"];
      NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithContentsOfFile:tempDatenPfad];
      if (tempDic)
      {
         [tempDic setObject:dieNote forKey:@"note"];
         saveOK=[tempDic writeToFile:tempDatenPfad atomically:YES];
      }
   }
   
}

- (void)saveUserTestArray:(NSArray*)derTestArray forUser:(NSString*)derUser anPfad:(NSString*)derPfad
{
   //NSLog(@"saveUserTestArray");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   BOOL saveOK=NO;
   NSString* tempUserDatenPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];
   NSString* tempNamenPfad=[tempUserDatenPfad stringByAppendingPathComponent:derUser];
   if ([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempDatenPfad=[tempNamenPfad stringByAppendingPathComponent:@"Data"];
      NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithContentsOfFile:tempDatenPfad];
      if (tempDic)
      {
         [tempDic setObject:derTestArray forKey:@"usertestarray"];
         saveOK=[tempDic writeToFile:tempDatenPfad atomically:YES];
      }
   }
   
}

- (NSArray*)UserTestArrayVonUser:(NSString*)derUser anPfad:(NSString*)derPfad
{
   //NSLog(@"UserTestArrayVonUser");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   BOOL saveOK=NO;
   //	NSArray* returnTestArray;
   NSString* tempUserDatenPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];
   NSString* tempNamenPfad=[tempUserDatenPfad stringByAppendingPathComponent:derUser];
   if ([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempDatenPfad=[tempNamenPfad stringByAppendingPathComponent:@"Data"];
      NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithContentsOfFile:tempDatenPfad];
      if ([tempDic objectForKey:@"usertestarray"])
      {
         return [tempDic objectForKey:@"usertestarray"];
      }
      else
      {
         return [NSArray array];
      }
   }
   return[NSArray array];
}




- (void)setTestInUserTestArray:(NSString*)derTest forUser:(NSString*)derUser anPfad:(NSString*)derPfad
{
   //	NSLog(@"Utils setTestInUserTestArray: Test: %@  User: %@",derTest,derUser);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   BOOL saveOK=NO;
   NSString* tempUserDatenPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];
   NSString* tempNamenPfad=[tempUserDatenPfad stringByAppendingPathComponent:derUser];
   if ([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempDatenPfad=[tempNamenPfad stringByAppendingPathComponent:@"Data"];
      NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithContentsOfFile:tempDatenPfad];
      if (tempDic)
      {
         if ([tempDic objectForKey:@"usertestarray"])
         {
            if (![[tempDic objectForKey:@"usertestarray"]containsObject:derTest])//Test noch nicht da
            {
               [[tempDic objectForKey:@"usertestarray"]addObject:derTest];
            }
         }
         else//noch kein UserArray
         {
            NSMutableArray* tempArray=[NSMutableArray arrayWithObject:derTest];
            
            [tempDic setObject:tempArray forKey:@"usertestarray"];
         }
         saveOK=[tempDic writeToFile:tempDatenPfad atomically:YES];
         //		NSLog(@"Utils setTestInUserTestArray	ende: tempDic: %@  saveOK: %d",[tempDic description],saveOK);
         
      }
   }
}

- (void)setTestForAll:(NSString*)derTest nurAktiveUser:(BOOL)nurAktive anPfad:(NSString*)derPfad
{
   NSLog(@"Utils               setTestForAll: Test: %@ ",derTest);
   NSMutableArray* tempNamenDicArray=(NSMutableArray*)[self NamenDicArrayAnPfad:derPfad];
   NSEnumerator* NamenEnum=[tempNamenDicArray objectEnumerator];
   id einDic;
   while (einDic=[NamenEnum nextObject])
   {
      if ([einDic objectForKey:@"name"])
      {
         NSString* tempName=[einDic objectForKey:@"name"];
         if ((!nurAktive)||((nurAktive && ([einDic objectForKey:@"aktiv"]&&[[einDic objectForKey:@"aktiv"]boolValue]))))
         {
            //NSLog(@"Utils setTestForAll: User: %@ ",tempName);
            [self setTestInUserTestArray:derTest forUser:tempName anPfad:derPfad];
         }
         
      }
      
   }//while
   //NSLog(@"Utils setTestForAll:	ende");
}


- (void)clearTestForAll:(NSString*)derTest nurAktiveUser:(BOOL)nurAktive anPfad:(NSString*)derPfad
{
   NSLog(@"Utils                   clearTestForAll: Test: %@",derTest);
   
   NSMutableArray* tempNamenDicArray=(NSMutableArray*)[self NamenDicArrayAnPfad:derPfad];
   
   NSEnumerator* NamenEnum=[tempNamenDicArray objectEnumerator];
   id einDic;
   
   while (einDic=[NamenEnum nextObject])
   {
      if ([einDic objectForKey:@"name"])
      {
         NSString* tempName=[einDic objectForKey:@"name"];
         //	NSLog(@"***   Utils clearTestForAll: User: %@ ",tempName);
         
         [self deleteTestInUserTestArray:derTest forUser:tempName anPfad:derPfad];
         
         
      }
      
   }//while
}




- (void)deleteTestInUserTestArray:(NSString*)derTest forUser:(NSString*)derUser anPfad:(NSString*)derPfad
{
   NSLog(@"Utils deleteTestInUserTestArray: Test: %@  User: %@",derTest,derUser);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   BOOL removeOK=NO;
   NSString* tempUserDatenPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];
   NSString* tempNamenPfad=[tempUserDatenPfad stringByAppendingPathComponent:derUser];
   if ([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempDatenPfad=[tempNamenPfad stringByAppendingPathComponent:@"Data"];
      NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithContentsOfFile:tempDatenPfad];
      //		NSLog(@"tempDic: vor: %@",[tempDic description]);
      if (tempDic)
      {
         //			if ([tempDic objectForKey:@"usertestarray"]&&([[tempDic objectForKey:@"usertestarray"] count]>1))
         {
            [[tempDic objectForKey:@"usertestarray"]removeObject:derTest];
            //			NSLog(@"tempDic: nach remove: %@",[tempDic description]);
            removeOK=[tempDic writeToFile:tempDatenPfad atomically:YES];
            //NSLog(@"tempDic: nach remove: %@  removeOK: %d",[tempDic description],removeOK);
         }
         //			else
         {
            //			NSLog(@"deleteTestInUserTestArray: nur noch 1 Objekt");
            
         }
      }
   }
   
}


- (void)setAktivInPList:(NSNumber*)derStatus forTest:(NSString*)derTest anPfad:(NSString*)derPfad
{
   //NSLog(@"Utils setAktivInPList: Test: %@  ",derTest);
   BOOL aktivOK=NO;
   BOOL istOrdner=NO;
   //	NSLog(@"setAktivInPList Status: %@  Test: %@  anPfad: %@",derStatus,derTest,derPfad);
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:derPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempPListPfad=[derPfad stringByAppendingPathComponent:PListName];
      NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
      if (tempPListDic)
      {
         if ([tempPListDic objectForKey:@"testarray"])
         {
            NSArray* tempTestArray=[tempPListDic objectForKey:@"testarray"];
            //				NSLog(@"Utils setAktivInPList: tempTestArray vor set : %@",[[tempPListDic objectForKey:@"testarray"]description]);
            
            NSUInteger index=[[tempTestArray valueForKey:@"testname"]indexOfObject:derTest];
            if (index<NSNotFound)//Test existiert
            {
               NSMutableDictionary* tempTestDic=(NSMutableDictionary*)[[tempPListDic objectForKey:@"testarray"]objectAtIndex:index];
               if (tempTestDic)
               {
                  //						NSLog(@"Utils setAktivInPList: tempTestDic vor set : %@",[tempTestDic description]);
                  
                  [tempTestDic setObject:derStatus forKey:@"aktiv"];
                  //						NSLog(@"Utils setAktivInPList: tempTestDic nach set : %@",[tempTestDic description]);
                  if ([derStatus boolValue]==NO)//aktiv auf NO setzen
                  {
                     //Test in userarrays löschen
                     [self clearTestForAll:derTest nurAktiveUser:NO anPfad:derPfad];
                  }
                  
               }
            }
            
            //				NSLog(@"Utils setAktivInPList: tempTestArray nach set : %@",[[tempPListDic objectForKey:@"testarray"]description]);
            aktivOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
            //				NSLog(@"Utils setAktivInPList aktivOK: %d",aktivOK);
         }
      }//if tempPlistDic
      else
      {
         NSLog(@"setAktivInPList: keine PList");
      }
   }//if exists
   
}




- (BOOL)confirmPasswort:(NSDictionary*)derNamenDic
{
   BOOL confirmOK=NO;
   //NSLog(@"confirmPasswort start");
   NSString* tempName=[derNamenDic objectForKey:@"name"];
   NSData* PWData=[derNamenDic objectForKey:@"pw"];
   if (!PasswortRequestPanel)
   {
      PasswortRequestPanel=[[rPasswortRequest alloc]init];
   }
   
   NSModalSession PasswortSession=[NSApp beginModalSessionForWindow:[PasswortRequestPanel window]];
   [PasswortRequestPanel setName:tempName mitPasswort: PWData];
   
   int modalAntwort = [NSApp runModalForWindow:[PasswortRequestPanel window]];
   //NSLog(@"Utils confirmPasswort: modalAntwort: %d",modalAntwort);
   
   [NSApp endModalSession:PasswortSession];
   confirmOK=(modalAntwort==1);
   return confirmOK;
}


- (NSDictionary*)changePasswort:(NSDictionary*)derNamenDic
{
   BOOL confirmOK=NO;
   //NSLog(@"changePasswort start");
   NSString* tempName=[derNamenDic objectForKey:@"name"];
   NSData* PWData=[derNamenDic objectForKey:@"pw"];
   
   if (!PasswortDialogPanel)
   {
      PasswortDialogPanel=[[rPasswortDialog alloc]init];
   }
   
   NSModalSession PasswortSession=[NSApp beginModalSessionForWindow:[PasswortDialogPanel window]];
   [PasswortDialogPanel setName:tempName mitPasswort: PWData];
   
   int modalAntwort = [NSApp runModalForWindow:[PasswortDialogPanel window]];
   
   //NSLog(@"changePasswort Antwort: %d",modalAntwort);
   
   
   [NSApp endModalSession:PasswortSession];
   if (modalAntwort==0)//Cancel
   {
      return [derNamenDic copy];
   }
   
   NSDictionary* returnDic=[PasswortDialogPanel neuerPasswortDic];
   //
   //NSLog(@"changePasswort:\nderNamenDic: %@\n returnDic: %@\n\n",[derNamenDic description],[returnDic description]);
   return [returnDic copy];
}



- (NSArray*)NetzwerkVolumesArray
{
   /*
    Gibt die Volumes im Ordner 'Network' zur√ºck
    */
   
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   NSString* NetzPfad=@"//Network";
   
   NSMutableArray* NetzobjekteArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NetzobjekteArray=[[Filemanager contentsOfDirectoryAtPath:NetzPfad error:NULL]mutableCopy];
   //NSLog(@"NetzobjekteArray roh: %@",[NetzobjekteArray description]);
   if ([NetzobjekteArray containsObject:@"Library"])
   {
      [NetzobjekteArray removeObject:@"Library"];
   }
   if ([NetzobjekteArray containsObject:@"Servers"])
   {
      [NetzobjekteArray removeObject:@"Servers"];
   }
   if ([NetzobjekteArray containsObject:@".localized"])
   {
      [NetzobjekteArray removeObject:@".localized"];
   }
   [NetzobjekteArray removeObject:@"Users"];
   [NetzobjekteArray removeObject:@"Applications"];
   //NSLog(@"NetzobjekteArray sauber: %@",[NetzobjekteArray description]);
   
   NSMutableArray* NetzobjekteDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   if ([NetzobjekteArray count])
   {
      NSEnumerator* NetzObjektEnum=[NetzobjekteArray objectEnumerator];
      id einNetzObjekt;
      NSString* NetzVolumePfad=@"/Volumes";
      while (einNetzObjekt=[NetzObjektEnum nextObject])
      {
         
         NSMutableDictionary* tempNetworkDic=[[NSMutableDictionary alloc]initWithCapacity:0];//Dic f√ºr Volume
         [tempNetworkDic setObject:einNetzObjekt forKey:@"networkname"];
         NSString* LoginCheckPfad=[NetzVolumePfad stringByAppendingPathComponent:einNetzObjekt];
         NSMutableArray* LoginCheckArray=[[NSMutableArray alloc]initWithCapacity:0];
         LoginCheckArray=[[Filemanager contentsOfDirectoryAtPath:NetzVolumePfad error:NULL]mutableCopy];
         NSLog(@"LoginCheckPfad: %@\nLoginCheckArray roh: %@",LoginCheckPfad,[LoginCheckArray description]);
         if (LoginCheckArray)
         {
            [LoginCheckArray removeObject:@".DS_Store"];
         }
         
         [tempNetworkDic setObject:[NSNumber numberWithBool:NO] forKey:@"networkloginOK"];//Objekt nicht login
         
         [NetzobjekteDicArray addObject:tempNetworkDic];
      }//while einNetzObjekt
      
      
      //NSLog(@"NetzobjekteArray: \n%@\n",[NetzobjekteArray description]);
   }//if ([NetzobjekteArray count])
   /*		
    CFStringRef MaschinenName=CSCopyMachineName();
    
    NSLog(@"MaschinenName: %@    Host names: %@ ",MaschinenName,[[NSHost currentHost] names]);
    NSLog(@"Host names: %@", [[NSHost currentHost] names]);
    */
   
   NSLog(@"NetzobjekteDicArray: \n%@\n",[NetzobjekteDicArray description]);
   return NetzobjekteDicArray;
}



- (BOOL)DataValidAnPfad:(NSString*)derSndCalcDatenPfad
{
   BOOL SndCalcDatenValid=NO;
   BOOL ArchivValid=NO;
   BOOL erfolg;
   NSString* BeendenString=NSLocalizedString(@"Beenden",@"Beenden");
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:derSndCalcDatenPfad ])
   {
      SndCalcDatenValid=YES;
      //NSLog(@"SndCalcDaten da: derSndCalcDatenPfad: %@",derSndCalcDatenPfad);
   }//exists at SndCalcDatenPfad
   else
   {
      
      //NSLog(@"Keine SndCalcDaten da: %@",derSndCalcDatenPfad);
      //PList l√∂schen
      BOOL DeleteOK=[self deletePListAnPfad:derSndCalcDatenPfad];
      //NSLog(@"Keine SndCalcDaten da: %@  DeleteOK: %d",derSndCalcDatenPfad,DeleteOK);
      
      NSString* LString1=NSLocalizedString(@"The folder 'Lecturebox' can be created on the choosen computer",@"SndCalcDaten kann anlegt werden");
      NSString* LString2=NSLocalizedString(@"\nA list of names in format .doc, .rtf, or .txt is needed",@"rtf-Klassenliste muss vorhanden sein");
      NSLog(@"LString1: %@ LString2: %@",LString1,LString2);
      NSString* SndCalcDatenString=[LString1 stringByAppendingString:LString2];
      
      int Antwort=NSRunAlertPanel(NSLocalizedString(@"Create New Lecturebox:",@"Neue SndCalcDaten einrichten:"),SndCalcDatenString,NSLocalizedString(@"Create",@"Anlegen"),NSLocalizedString(@"Quit",@"Beenden"),nil);
      //NSLog(@"Neue  SndCalcDaten: Antwort: %d",Antwort);
      switch (Antwort)
      {
         case 1:
         {			
            //SndCalcDatenValid=[Filemanager createDirectoryAtPath:derSndCalcDatenPfad attributes:nil];
            
            SndCalcDatenValid = [Filemanager createDirectoryAtPath:derSndCalcDatenPfad withIntermediateDirectories:NO attributes:NULL error:NULL];
            
            
            //NSLog(@"SndCalcDatenVorhandenAnPfad: SndCalcDatenVorhanden: %d",SndCalcDatenValid);
            
            if (!SndCalcDatenValid)
            {
               NSString* c1= NSLocalizedString(@"The folder 'Lecturebox' cannot be created on the choosen computer",@"Keine SndCalcDaten auf Computer");
               NSString* c2= NSLocalizedString(@"Perhaps the user permissions do not allow this",@"Benutzungsrechte fraglich");
               NSString* WarnString=[NSString stringWithFormat:@"%@\r%@",c1,c2];
               NSString* TitelStringLB=NSLocalizedString(@"Create Lecturebox:",@"SndCalcDaten einrichten:");
               
               
               
               int Antwort=NSRunAlertPanel(TitelStringLB,WarnString,BeendenString, nil,nil);
               //Beenden
               NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               [BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
               NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
               [beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
               
            }
         }break;
            
         case 0:
         {
            NSString* WarnString=NSLocalizedString(@"The lecturebox must be created manually on the choosen computer",@"LB manuelleinrichten");
            WarnString=[WarnString stringByAppendingString:NSLocalizedString(@"Quit Applikation",@"Programm beenden")];
            NSString* TitelStringNeueLB=NSLocalizedString(@"Create New Lecturebox:",@"Neue SndCalcDaten einrichten:");
            
            int Antwort=NSRunAlertPanel(TitelStringNeueLB, WarnString,BeendenString, nil,nil);
            
            //Beenden
            NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
            NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
            [beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
         }break;
      }
      
   }//exists not at SndCalcDatenPfad
   return SndCalcDatenValid;
}

- (BOOL)deleteTestMitDatum:(NSString*)dasDatum forUser:(NSString*)derUser anPfad:(NSString*)derPfad
{
   BOOL deleteOK=YES;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   NSLog(@"Utils deleteTestMitDatum: derUser: %@	dasDatum: %@",derUser,dasDatum);
   NSString* tempUserDatenPfad=[derPfad stringByAppendingPathComponent:@"UserDaten"];
   NSString* tempNamenPfad=[tempUserDatenPfad stringByAppendingPathComponent:derUser];
   if ([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istOrdner]&&istOrdner)
   {
      NSString* tempDatenPfad=[tempNamenPfad stringByAppendingPathComponent:@"Data"];
      NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithContentsOfFile:tempDatenPfad];
      if (tempDic)
      {
         //NSLog(@"tempDic: %@",[tempDic description]);
         
         if ([tempDic objectForKey:@"ergebnisdicarray"]&&[[tempDic objectForKey:@"ergebnisdicarray"]count])
         {
            NSMutableArray* tempDicArray=[[NSMutableArray alloc]initWithArray:[tempDic objectForKey:@"ergebnisdicarray"]];
            NSArray* tempDatumArray=[tempDicArray valueForKey:@"datum"];
            //NSLog(@"tempDatumArray: %@",[tempDatumArray description]);
            NSUInteger datumIndex=[tempDatumArray indexOfObject:dasDatum];
            if (!(datumIndex==NSNotFound))
            {
               //NSLog(@"User: %@	datumIndex: %d",derUser,datumIndex);
               [tempDicArray removeObjectAtIndex:datumIndex];
            }
            [tempDic setObject:tempDicArray forKey:@"ergebnisdicarray"];
            deleteOK=[tempDic writeToFile:tempDatenPfad atomically:YES];
         }
      }
   }
   
   return deleteOK;
}



- (BOOL)deletePListAnPfad:(NSString*)derSndCalcDatenPfad 
{
   BOOL DeleteOK=NO;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* tempUserPfad=[derSndCalcDatenPfad copy];
   NSString* PListPfad;
   NSString* PListName=NSLocalizedString(@"SndCalc.plist",@"SndCalc.plist");
   NSLog(@"deletePListAnPfad: tempUserPfad start: %@",tempUserPfad);
   BOOL istSysVol=YES;
   if (istSysVol)
   {
      while(![[tempUserPfad lastPathComponent] isEqualToString:@"Documents"])//Pfad von User finden
      {
         tempUserPfad=[tempUserPfad stringByDeletingLastPathComponent];
         //NSLog(@"tempUserPfad: %@",tempUserPfad);
      }
      tempUserPfad=[tempUserPfad stringByDeletingLastPathComponent];//"Documents" entfernen
      //NSLog(@"tempUserPfad: %@",tempUserPfad);
      tempUserPfad=[tempUserPfad stringByAppendingPathComponent:@"Library"];
      tempUserPfad=[tempUserPfad stringByAppendingPathComponent:@"Preferences"];
      
      PListPfad=[tempUserPfad stringByAppendingPathComponent:PListName];//Pfad der PList in der Library auf dem Vol der LB
   }
   else
   {
      PListPfad=[tempUserPfad stringByAppendingPathComponent:PListName];//Pfad der PList auf dem Vol der LB
      
   }
   
   if([Filemanager fileExistsAtPath:PListPfad])
   {
      DeleteOK=[Filemanager removeItemAtPath:PListPfad error:nil];
   }
   return DeleteOK;
}

- (BOOL)ArchivValidAnPfad:(NSString*)derSndCalcDatenPfad
{
   BOOL ArchivValid=0;	
   NSString* TitelStringArchiv=NSLocalizedString(@"Creating The Archive:",@"Archiv einrichten:");
   NSString* BeendenString=NSLocalizedString(@"Quit",@"Beenden");
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* tempArchivPfad=[derSndCalcDatenPfad stringByAppendingPathComponent:@"Archiv"];
   if ([Filemanager fileExistsAtPath:tempArchivPfad])
   {
      ArchivValid=YES;
   }
   else
   {
      //ArchivValid=[Filemanager createDirectoryAtPath:tempArchivPfad attributes:nil];
      
      ArchivValid   = [Filemanager createDirectoryAtPath:tempArchivPfad withIntermediateDirectories:NO attributes:NULL error:NULL];
      
      
      if (!ArchivValid)
      {
         NSString* WarnString=NSLocalizedString(@"The folder 'Archive' cannot be created on the choosen computer",@"Auf dem Computer kein Archiv eingerichtet");
         int Antwort=NSRunAlertPanel(TitelStringArchiv, WarnString,BeendenString, nil,nil);
         //Beenden
         NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
         NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
         [beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
      }
      
   }
   return ArchivValid;
}


@end
