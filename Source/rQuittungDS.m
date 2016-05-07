#import "rQuittungDS.h"


@implementation rQuittungDS : NSObject 

- (id)init
{
	self=[super init];
	QuittungDicArray=[[NSMutableArray alloc]initWithCapacity:0];
	QuittungSelektionDic=[[NSMutableDictionary alloc]initWithCapacity:0];

	//NSLog(@"QuittungDS init");
	return self;
}

- (void)awakeFromNib
{
//	NSLog(@"QuittungDS awake");
}

- (void)setQuittungDicArray:(NSArray*) derDicArray
{
	//NSLog(@"\n*******\nQuittungDicArray:	derDicArray: %@\n",[[derDicArray valueForKey:@"quittungname"] description]);
	[QuittungDicArray removeAllObjects];
	NSMutableDictionary* homeDic=[[NSMutableDictionary alloc]initWithCapacity:0];

	[homeDic setObject:@"home" forKey:@"quittungname"];
	if ([derDicArray count])
	{
		[homeDic setObject:[[derDicArray objectAtIndex:0] objectForKey:@"quittungklasse"] forKey:@"quittungklasse"];
	}
	[QuittungDicArray addObject:homeDic];

	
	NSEnumerator* DicEnum=[derDicArray objectEnumerator];
	id einDic;
	while (einDic=[DicEnum nextObject])
	{
		
			//NSLog(@"setQuittungDicArray:	einDic: %@",[einDic description]);
			NSMutableDictionary* tempDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
			
			NSString* QuittungName=[einDic objectForKey:@"quittungname"];
			if (QuittungName)
			{
				[tempDictionary setObject:QuittungName forKey:@"quittungname"];
			}//if name
			
			NSString* QuittungKlasse=[einDic objectForKey:@"quittungklasse"];
			if (QuittungKlasse)
			{
				[tempDictionary setObject:QuittungKlasse forKey:@"quittungklasse"];
			}//if klasse
			
			[QuittungDicArray addObject:tempDictionary];
			
			
	
	}//while
			//NSLog(@"setQuittungDicArray: %@\n\n",[QuittungDicArray description]);
	
}

- (void)setQuittungSelektionDic:(NSDictionary*)derQuittungSelektionDic
{
	QuittungSelektionDic=(NSMutableDictionary*)derQuittungSelektionDic;
}

- (void)addQuittungDic:(NSDictionary*) derQuittungDic
{
	
	NSLog(@"\n		addQuittungDic:	derQuittungDic: %@",derQuittungDic);
	if ([QuittungDicArray count]==0)//Array leer
	{
		NSDictionary* homeDic=[NSDictionary dictionaryWithObject:@"home" forKey:@"quittungname"];
		[QuittungDicArray addObject:homeDic];
	}
	[QuittungDicArray addObject:derQuittungDic];
	
	
}


- (NSArray*)QuittungDicArray
{
	return QuittungDicArray;
}

- (NSDictionary*)QuittungSelektionDic
{
	return 	QuittungSelektionDic;
}



#pragma mark -
#pragma mark SessionTable Data Source:

- (long)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [QuittungDicArray count];
}


- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(long)rowIndex
{
	//NSLog(@"objectValueForTableColumn");
    NSDictionary *einQuittungDic;
	{
		einQuittungDic = [QuittungDicArray objectAtIndex: rowIndex];
		
	}
	
	return [einQuittungDic objectForKey:[aTableColumn identifier]];
	
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(long)rowIndex
{
	//NSLog(@"QuittungDS setObjectValueForTableColumn: %@",[aTableColumn identifier]);
	
		NSMutableDictionary* einQuittungDic;
		einQuittungDic=[QuittungDicArray objectAtIndex:rowIndex];
		[einQuittungDic setObject:anObject forKey:[aTableColumn identifier]];
		
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(long)row
{
	//NSLog(@"shouldSelectRow: bisherige selectedRow: %d	neue row: %d",[tableView selectedRow],row );  
	NSString* QuittungName=[[QuittungDicArray objectAtIndex:row] objectForKey:@"quittungname"];

	//if (row)//nicht 'home'
	{
				
		NSString* QuittungKlasse=[[QuittungDicArray objectAtIndex:row] objectForKey:@"quittungklasse"];
		NSLog(@"shouldSelectRow:QuittungName: %@  QuittungKlasse: %@",QuittungName,QuittungKlasse);
		[QuittungSelektionDic setObject:QuittungName forKey:[QuittungKlasse lowercaseString]];
		NSLog(@"QuittungSelektionDic: %@",[QuittungSelektionDic description]);
		
	}
	
	return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(long)row
{
	NSDictionary* einDic=[QuittungDicArray objectAtIndex:row];
		
	if ([[tableColumn identifier]isEqualToString:@"quittungname"])
	{
	}
	
	
	
	
}//willDisplayCell

@end