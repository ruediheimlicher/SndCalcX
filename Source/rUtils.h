//
//  rUtils.h
//  SndCalcII
//
//  Created by Sysadmin on 12.01.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rPasswortRequest.h"
#import "rPasswortDialog.h"

@interface rUtils : NSObject 
{
rPasswortRequest*			PasswortRequestPanel;
rPasswortDialog*			PasswortDialogPanel;
}
- (NSString*)HomeSndCalcDatenPfad;
- (NSArray*)UsersMitSndCalcDatenArray;
- (NSDictionary*)DatenDicForUser:(NSString*)derName anPfad:(NSString*)derPfad;
- (BOOL)setDatenDic:(NSDictionary*)derDic forUser:(NSString*)derName anPfad:(NSString*)derPfad;
- (BOOL)saveTestArray:(NSArray*)derTestArray anPfad:(NSString*)derPfad;
- (NSArray*)TestArrayAusPListAnPfad:(NSString*)derPfad;
- (NSArray*)NamenDicArrayAnPfad:(NSString*)derPfad;
- (BOOL)checkChangeNamenListe:(NSArray*)derNamenDicArray anPfad:(NSString*)derPfad;
- (void)DeleteNamen:(NSString*)derName anPfad:(NSString*)derPfad;
- (BOOL)deleteTestMitDatum:(NSString*)dasDatum forUser:(NSString*)derUser anPfad:(NSString*)derPfad;

- (BOOL)deleteTestName:(NSString*)derTestName anPfad:(NSString*)derPfad;
- (void)deleteInvalidTestsAnPfad:(NSString*)derPfad;
- (BOOL)saveTestName:(NSString*)derTestName anPfad:(NSString*)derPfad;
- (BOOL)setAlle:(BOOL)derStatus forTest:(NSString*)derTestName anPfad:(NSString*)derPfad;
- (BOOL) setPListBusy:(BOOL)derStatus anPfad:(NSString*)derPfad;

- (NSDictionary*)changePasswort:(NSDictionary*)derNamenDic;
- (BOOL)confirmPasswort:(NSDictionary*)derNamenDic;
- (BOOL)saveAdminPW:(NSDictionary*)derPWDic anPfad:(NSString*)derPfad;
- (void)saveUserTestArray:(NSArray*)derTestArray forUser:(NSString*)derUser anPfad:(NSString*)derPfad;
- (void)setTestInUserTestArray:(NSString*)derTest forUser:(NSString*)derUser anPfad:(NSString*)derPfad;
- (void)setTestForAll:(NSString*)derTest nurAktiveUser:(BOOL)nurAktive anPfad:(NSString*)derPfad;
- (void)clearTestForAll:(NSString*)derTest nurAktiveUser:(BOOL)nurAktive anPfad:(NSString*)derPfad;
- (void)deleteTestInUserTestArray:(NSString*)derTest forUser:(NSString*)derUser anPfad:(NSString*)derPfad;
- (void)deleteErgebnisseVonTest:(NSString*)derTest anPfad:(NSString*)derPfad;
- (NSArray*)UserTestArrayVonUser:(NSString*)derUser anPfad:(NSString*)derPfad;
- (void)setAktivInPList:(NSNumber*)derStatus forTest:(NSString*)derTest anPfad:(NSString*)derPfad;
- (NSArray*)NetzwerkVolumesArray;
- (BOOL)DataValidAnPfad:(NSString*)derDataPfad;
- (BOOL)deletePListAnPfad:(NSString*)derSndCalcDatenPfad;
- (void)saveNote:(NSString*)dieNote forUser:(NSString*)derUser anPfad:(NSString*)derPfad;
- (BOOL)saveElement:(id)derElementName mitKey:(NSString*)derKey anPfad:(NSString*)derPfad;


- (NSInteger)tagDesJahresVonDate:(NSDate*)datum;
- (NSString*) lokalDatumVonDate:(NSDate*)datum;
- (NSInteger)jahrVonDate:(NSDate*)datum;
- (NSInteger)monatVonDate:(NSDate*)datum;
- (NSInteger)tagVonDate:(NSDate*)datum;
- (BOOL)saveSessionDatum:(NSDate*)dasDatum anPfad:(NSString*)derPfad;
- (NSDate*)SessionDatumAnPfad:(NSString*)derPfad;
- (BOOL)saveSessionBehalten:(BOOL)behaltenOK anPfad:(NSString*)derPfad;
- (BOOL)SessionBehaltenAnPfad:(NSString*)derPfad;
- (BOOL)saveSessionBehaltenTag:(int)derTag anPfad:(NSString*)derPfad;
- (int)SessionBehaltenTagAnPfad:(NSString*)derPfad;
- (void)ErgebnisseBehaltenBisAnzahl:(int)dieAnzahl anPfad:(NSString*)derPfad;
@end
