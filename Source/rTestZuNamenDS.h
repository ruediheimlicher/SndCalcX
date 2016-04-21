#import <Cocoa/Cocoa.h>


@interface rTestZuNamenDS : NSObject 
{
NSMutableArray*				TestZuNamenDicArray;

NSString*					aktuellerUser;
BOOL						dirty;

}
- (void)setTestZuNamenArrayMitDicArray:(NSArray*) derDicArray;
- (void)setTestliste:(NSArray*)derTestArray zuNamen:(NSString*)derUser;
- (void)addTestZuTestListe:(NSString*)derTest zuNamen:(NSString*)derUser;
- (NSArray*)TestListeZuNamen:(NSString*)derUser;
- (NSArray*)aktivTestForUserArray;
- (NSArray*)TestZuNamenDicArray;
- (void)setUserOK:(int)derStatus forTest:(NSString*)derTest;
- (BOOL)isDirty;
- (void)setDirty:(BOOL)derStatus;
- (int)anzTestForUser;
@end