#import "rTestZuNamenDS.h"


@implementation rTestZuNamenDS : NSObject

- (id)init
{
	self=[super init];
	TestZuNamenDicArray=[[NSMutableArray alloc]initWithCapacity:0];
//	tempTestZuNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	aktuellerUser=[NSString string];
	return self;
}

- (void)setTestZuNamenArrayMitDicArray:(NSArray*) derDicArray
{
	//NSLog(@"\n  setTestZuNamenArrayMitDicArray:	DicArray: %@\n",[derDicArray description]);
	//NSLog(@"\n  setTestZuNamenArrayMitDicArray:	TestZuNamenDicArray: %@\n",[TestZuNamenDicArray description]);
	[TestZuNamenDicArray removeAllObjects];
	//TestZuNamenDicArray=[NSMutableArray array];
//	NSLog(@"setTestZuNamenMitDicArray start  +++++");
	
	NSEnumerator* DicEnum=[derDicArray objectEnumerator];
	
	id einDic;
	
	while (einDic=[DicEnum nextObject])
	{
		if ([[einDic objectForKey:@"aktiv"]boolValue])
		{
			//NSLog(@"setTestZuNamenArrayMitDicArray:	einDic: %@",[einDic description]);
			NSMutableDictionary* tempDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
			
			NSString* Testname=[einDic objectForKey:@"testname"];
			if (Testname)
			{
//			NSLog(@"setTestZuNamenArrayMitDicArray:	Testname: %@",Testname);
				[tempDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"aktiv"];
				[tempDictionary setObject:Testname forKey:@"testname"];
				
				
				if ([einDic objectForKey:@"zeit"])
				{
					[tempDictionary setObject:[einDic objectForKey:@"zeit"] forKey:@"zeit"];
				}
				
				if ([einDic objectForKey:@"anzahlaufgaben"])
				{
					[tempDictionary setObject:[einDic objectForKey:@"anzahlaufgaben"] forKey:@"anzahlaufgaben"];
				}
				
				if ([einDic objectForKey:@"alle"])
				{
					//			[tempDictionary setObject:[einDic objectForKey:@"alle"] forKey:@"userok"];
					[tempDictionary setObject:[einDic objectForKey:@"alle"] forKey:@"alle"];
				}
				
				if ([einDic objectForKey:@"userok"])
				{
					[tempDictionary setObject:[einDic objectForKey:@"userok"] forKey:@"userok"];
				}
				else
				{
					[tempDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"userok"];
				}
				
				[TestZuNamenDicArray addObject:tempDictionary];
			}//if name
		}//if aktiv
	}//while
//	NSLog(@"setTestZuNamenArrayMitDicArray ENDE:	TestZuNamenDicArray: %@\n\n",[TestZuNamenDicArray description]);

}

- (NSArray*)TestZuNamenDicArray
{
	return TestZuNamenDicArray;
}

- (void)addTestZuTestListe:(NSString*)derTest zuNamen:(NSString*)derUser
{
NSArray* tempNamenArray=[TestZuNamenDicArray valueForKey:@"testname"];
NSUInteger index=[tempNamenArray indexOfObject:derUser];
if (index<NSNotFound)//User ist da
{
	NSMutableDictionary* tempNamenDic=(NSMutableDictionary*)[TestZuNamenDicArray objectAtIndex:index];
	
	NSString* tempTestName=[tempNamenDic objectForKey:@"testname"];
	if (tempTestName)
	{
		NSMutableArray* tempTestArray=(NSMutableArray*)[tempNamenDic objectForKey:@"usertestarray"];

		if (tempTestArray)//Test ist in usertestarray
		{
//			NSLog(@"Test ist in usertestarray: %@",[einTestDic description]);
			[tempTestArray addObject:derTest];
			
		}
		else
		{
			tempTestArray=[NSMutableArray arrayWithObject:derTest];
			[tempNamenDic setObject:tempTestArray forKey:@"usertestarray"];
		}
		[tempNamenDic setObject:[NSNumber numberWithBool:YES]forKey:@"userok"];
	dirty=NO;
	}
}

}

- (void)setTestliste:(NSArray*)derTestArray zuNamen:(NSString*)derUser
{
//	NSLog(@"			setTestliste: %@	zuNamen: %@",[derTestArray description], derUser);
	//NSLog(@"			setTestliste: %@	zuNamen: %@",[derTestArray description], derUser);
	//	NSArray* tempTestNamenArray=[TestZuNamenDicArray valueForKey:@"testname"];
	//	NSLog(@"\n\nsetTestListe	tempTestNamenArray: %@",[tempTestNamenArray description]);

//	[TestZuNamenDicArray release];
	TestZuNamenDicArray =(NSMutableArray*)derTestArray;
	aktuellerUser=derUser;
//	NSLog(@"TestZuNamenDicArray	: %@",[TestZuNamenDicArray description]);
	return;

	
	NSEnumerator* TestEnum=[TestZuNamenDicArray objectEnumerator];
	id einTestDic;
	int anzTest=0;
	while(einTestDic=[TestEnum nextObject])
	{	
		//NSLog(@"einTestDic	: %@",[einTestDic description]);
		NSString* tempTestName=[einTestDic objectForKey:@"testname"];
		if (tempTestName)
		{
			
			if ([derTestArray containsObject:tempTestName])//Test ist in usertestarray
			{
				[einTestDic setObject:[NSNumber numberWithBool:YES]forKey:@"userok"];
				anzTest++;
				NSLog(@"Test ist in usertestarray: %@",[einTestDic description]);
			}
			else
			{
				[einTestDic setObject:[NSNumber numberWithBool:NO]forKey:@"userok"];
				
			}
			
		}//if tempTestName
	}//while
	
	if ([TestZuNamenDicArray count]&&(anzTest==0))
	{
		[[TestZuNamenDicArray objectAtIndex:0]setObject:[NSNumber numberWithBool:YES]forKey:@"userok"];

	}
	dirty=NO;
	NSLog(@"anzTest: %d",[self anzTestForUser]);
}//setTestlisteZuNamen

- (void)setUserOK:(int)derStatus forTest:(NSString*)derTest 
{
	//userokfŸr letzten test in userArray reseten nach checkboxaktion
	NSUInteger index=[[TestZuNamenDicArray valueForKey:@"testname"]indexOfObject:derTest];
	if (index<NSNotFound)
	{
	[[TestZuNamenDicArray objectAtIndex:index]setObject:[NSNumber numberWithInt:derStatus]forKey:@"userok"];
	}

}


- (int)anzTestForUser
{
	NSEnumerator* TestEnum=[TestZuNamenDicArray objectEnumerator];
	id einTestDic;
	int anzTest=0;
	while(einTestDic=[TestEnum nextObject])
	{	
		//NSLog(@"einTestDic	: %@",[einTestDic description]);
		if ([einTestDic objectForKey:@"userok"]&&[[einTestDic objectForKey:@"userok"]intValue])
		{
			
				anzTest++;
				//NSLog(@"Test ist in usertestarray: %@",[einTestDic description]);
		
			
		}//if tempTestName
	}//while
return anzTest;
}

- (NSArray*)TestListeZuNamen:(NSString*)derUser
{
	NSMutableArray* tempTestArray=[[NSMutableArray alloc]initWithCapacity:0];


return tempTestArray;
}

- (void)setUserOKForAllForTest:(NSString*)derTest
{
	NSEnumerator* TestEnum=[TestZuNamenDicArray objectEnumerator];
	id einDic;
	while (einDic=[TestEnum nextObject])
	{
		
		if ([einDic objectForKey:@"userok"])
		{
			if ([[einDic objectForKey:@"userok"]boolValue])
			{
//				[tempTestArray addObject:[einDic objectForKey:@"testname"]];
			}
		}
	}//while einDic

}

- (NSArray*)aktivTestForUserArray
{
	//Array mit Tests, die fŸr den aktuellen User aktiviert sind
	NSMutableArray* tempTestArray=[[NSMutableArray alloc]initWithCapacity:0];
	int anzTest=0;
	
	NSEnumerator* TestEnum=[TestZuNamenDicArray objectEnumerator];
	id einDic;
	while (einDic=[TestEnum nextObject])
	{
		
		if ([einDic objectForKey:@"userok"])
		{
			if ([[einDic objectForKey:@"userok"]boolValue])
			{
				[tempTestArray addObject:[einDic objectForKey:@"testname"]];
			}
		}
	}//while einDic

	return tempTestArray;
}

- (BOOL)isDirty
{
return dirty;
}

- (void)setDirty:(BOOL)derStatus
{
dirty=derStatus;
}
#pragma mark -
#pragma mark SessionTable Data Source:

- (long)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [TestZuNamenDicArray count];
}


- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(long)rowIndex
{
	//NSLog(@"objectValueForTableColumn");
    NSDictionary *einNamenDic;
	if (rowIndex<[TestZuNamenDicArray count])
	{
		einNamenDic = [TestZuNamenDicArray objectAtIndex: rowIndex];
		//NSLog(@"objectValueForTableColumn  einNamenDic: %@ anzTest; %d",[einNamenDic description],[self anzTestForUser]);
	
	//NSLog(@"einNamenDic: aktiv: %d   Testname: %@",[[einSessionDic objectForKey:@"aktiv"]intValue],[einSessionDic objectForKey:@"name"]);
	
	return [einNamenDic objectForKey:[aTableColumn identifier]];
	}
   return nil;
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(long)rowIndex
{
	//NSLog(@"setObjectValue ForTableColumn: %@",[aTableColumn identifier]);
	if ([self anzTestForUser]==1)
	{
	/*
		NSDictionary* tempNamenDic;
		tempNamenDic=[TestZuNamenDicArray objectAtIndex:rowIndex];
		NSLog(@"Nur noch ein Test: setObjectValue einNamenDic: %@",[tempNamenDic  description]);
		NSString* tempUserName=[tempNamenDic objectForKey:@"user"];
		NSString* tempTestName=[tempNamenDic objectForKey:@"testname"];

		NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
		[Warnung addButtonWithTitle:@"OK"];
		[Warnung addButtonWithTitle:@""];
		[Warnung addButtonWithTitle:@""];
		//[Warnung addButtonWithTitle:@"Abbrechen"];
		NSString* MessageString=@"Nur noch ein Test";
		[Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
		NSString* s0=NSLocalizedString(@"%@ is the only test activatet for user %@.",@"%@ ist der einzige Test fŸr %@.");
		NSString* s1=[NSString stringWithFormat:s0,tempTestName,tempUserName];
		NSLog(@"s1: %@",s1);
		NSString* s2=NSLocalizedString(@"The Test is not deleted.",@"Der Test wird nicht gelšscht");
		NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
//		int antwort=[Warnung runModal];
*/
	}
//	else
	{
	
		NSMutableDictionary* einNamenDic;
		einNamenDic=[TestZuNamenDicArray objectAtIndex:rowIndex];
		[einNamenDic setObject:anObject forKey:[aTableColumn identifier]];

	
	
	
		
	}
	dirty=YES;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(long)row
{
//	NSLog(@"shouldSelectRow");  
	return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(long)row
{
	NSDictionary* einDic=[TestZuNamenDicArray objectAtIndex:row];
	//NSLog(@"willDisplayCell einDic: %@",[einDic description]);
	//NSLog(@"TestZuNamenDS willDisplayCell aktuellerUser: %@ laenge: %d",aktuellerUser,[aktuellerUser length]);
	if ([[tableColumn identifier]isEqualToString:@"userok"])
	{
		if ([aktuellerUser length])
		{
			[cell setEnabled:YES];
			
		}
		else
		{
			
			[cell setEnabled:NO];
		}
		
	}
	
	
	
	
}//willDisplayCell

@end