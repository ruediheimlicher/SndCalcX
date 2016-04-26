//
//  rSpeaker.h
//  SndCalcII
//
//  Created by Sysadmin on 24.10.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>
#import <AVFoundation/AVFoundation.h>

#import "rStimmenPanel.h"

@interface rSpeaker : NSObject {
NSDictionary*			ZahlenPlistDic;
NSDictionary*			QuittungPlistDic;
//Movie						QTMovieArray[40];
NSArray*					ZahlenDicArray;
NSArray*					QuittungDicArray;
   

AVQueuePlayer*       AufgabenPlayerX;
   NSMutableArray*   QueueArray;

QTMovieView *			AufgabenPlayer;
QTMovie*					AufgabenQTKitMovie;
//Movie						AufgabenMovie;
QTMovie*					QuittungenQTKitMovie;
//Movie						QuittungenMovie;
//Track				AufgabenTrack;

//QTCallBackUPP			gQuittungPlayingCompleteCallBack;
//QTCallBackUPP			gAufgabePlayingCompleteCallBack;
//QTCallBack				gQtCallBack;
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
- (void)setQuittungSelektionDic:(NSDictionary*)derQuittungSelektionDic;


- (QTMovieView*)AufgabenPlayer;
- (NSArray*)StimmenNamenArrayAusResources;
- (NSDictionary*)QuittungNamenArrayDicAusResources;
- (BOOL)readZahlen;

- (BOOL)readQuittungen;
- (IBAction)showStimmenPanel:(id)sender;
- (NSDictionary*)chooseStimme;

- (NSURL*)URLvonZahl:(int)dieZahl;
- (NSArray*)URLArrayvonZahl:(int)dieZahl;

- (NSURL*)URLvonOperation:(int)dieOperation;
- (NSURL*)URLvonQuittung:(int)dieQuittung;
- (long)setZahlTrackVon:(int)dieZahl mitOffset:(long)derOffset;
- (long)setOpTrackVon:(int)dieOperation mitOffset:(long)derOffset;
-(QTTime)setOpQTKitTrackVon:(int)dieOperation mitOffset:(QTTime)derOffset;
-(QTTime)setZahlQTKitTrackVon:(int)dieZahl mitOffset:(QTTime)derOffset;

- (long)setQuittungTrackVon:(int)dieQuittung mitOffset:(long)derOffset;
- (QTTime)setQTKitQuittungVon:(int)dieQuittung mitOffset:(QTTime)derOffset;

- (BOOL)AufgabeAb:(NSDictionary*)derAufgabenDic;
- (BOOL)QuittungAb:(NSDictionary*)derQuittungDic;

- (IBAction)play;
- (void)setVolume:(float)dasVolume;
- (int)deleteMovieFiles;
//- (void)setupMoviePlayingCompleteCallback:(Movie)theMovie callbackUPP:(QTCallBackUPP) callbackUPP;
- (QTMovie*)AufgabenQTKitMovie;
- (QTMovie*)QuittungenQTKitMovie;

@end
