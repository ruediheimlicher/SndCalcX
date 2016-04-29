#import <Cocoa/Cocoa.h>

@interface rSessionCell : NSCell
{
   int art;
   int b,h;
   BOOL sessionOK;
   NSRect GrafikRahmen;
   NSRect Anzeigebalken;
   int anzAufgaben, anzRichtig, anzFehler;
   int zeit,maxzeit;
   NSColor* Balkenfarbe;
   
}
- (void)setGrafikDaten:(NSDictionary*)derGrafikDic;


@end

@interface rSessionDS : NSObject <NSTableViewDataSource,NSTableViewDelegate>
{
   NSMutableArray*		SessionDicArray;
}
- (void)setSessionDicArrayMitDicArray:(NSArray*) derDicArray  mitDatum:(NSDate*)dasDatum;


@end