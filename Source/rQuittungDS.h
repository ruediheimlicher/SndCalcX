#import <Cocoa/Cocoa.h>


@interface rQuittungDS : NSObject <NSTableViewDataSource,NSTableViewDelegate>
{
NSMutableArray*				QuittungDicArray;
NSMutableDictionary*		QuittungSelektionDic;


}
- (void)setQuittungDicArray:(NSArray*) derDicArray;
- (void)addQuittungDic:(NSDictionary*) derQuittungDic;
- (void)setQuittungSelektionDic:(NSDictionary*)derQuittungSelektionDic;
- (NSArray*)QuittungDicArray;
- (NSDictionary*)QuittungSelektionDic;
@end