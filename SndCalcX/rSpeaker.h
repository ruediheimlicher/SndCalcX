//
//  rSpeaker.h
//  SndCalcII
//
//  Created by Sysadmin on 24.10.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

#import "rStimmenPanel.h"
#import "defines.h"

@interface rSpeaker : NSObject {
   NSDictionary*			ZahlenPlistDic;
   NSDictionary*			QuittungPlistDic;
   NSArray*					ZahlenDicArray;
   NSArray*					QuittungDicArray;
   
   
   AVQueuePlayer*       AufgabenPlayerX;
   NSMutableArray*   QueueArray;
   
   BOOL						gIsMoviePlaying;
   float						PlayerVolume;
   
   NSString*				Stimme;
   NSMutableDictionary*	QuittungSelektionDic;
   rStimmenPanel*			StimmenPanel;
   
}
@property(nonatomic) AVPlayerActionAtItemEnd actionAtItemEnd;
- (id)init;
- (void)setStimme:(NSString*)dieStimme;
- (NSString*)Stimme;


- (NSArray*)StimmenNamenArrayAusResources;
- (NSDictionary*)QuittungNamenArrayDicAusResources;
- (void)setQuittungSelektionDic:(NSDictionary*)derQuittungSelektionDic;

- (BOOL)readZahlen;

- (BOOL)readQuittungen;
- (IBAction)showStimmenPanel:(id)sender;
//- (NSDictionary*)chooseStimme;

- (NSURL*)URLvonZahl:(int)dieZahl;
- (NSArray*)URLArrayvonZahl:(int)dieZahl;

- (NSURL*)URLvonOperation:(int)dieOperation;
- (NSURL*)URLvonQuittung:(int)dieQuittung;


- (BOOL)AufgabeAb:(NSDictionary*)derAufgabenDic;
- (BOOL)QuittungAb:(NSDictionary*)derQuittungDic;

- (IBAction)play;
- (void)setVolume:(float)dasVolume;
- (int)deleteMovieFiles;
//- (void)setupMoviePlayingCompleteCallback:(Movie)theMovie callbackUPP:(QTCallBackUPP) callbackUPP;

@end
