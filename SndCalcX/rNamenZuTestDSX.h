#import <Cocoa/Cocoa.h>


@interface rNamenZuTestDS : NSObject <NSTableViewDataSource,NSTableViewDelegate>

{
   NSMutableArray*				NamenZuTestDicArray;
   NSString*					aktuellerTest;
   BOOL						dirty;
}
- (void)setNamenZuTestArrayMitDicArray:(NSArray*) derDicArray;
- (void)setNamenliste:(NSArray*)derNamenArray zuTest:(NSString*)derTest;
- (void)addTestZuTestListe:(NSString*)derTest zuNamen:(NSString*)derUser;
- (NSArray*)TestListeZuNamen:(NSString*)derUser;
- (NSArray*)NamenZuTestDicArray;
- (NSArray*)aktuellerUserTestArray;
- (BOOL)isDirty;
- (void)setDirty:(BOOL)derStatus;
@end