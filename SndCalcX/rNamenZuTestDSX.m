#import "rNamenZuTestDSX.h"


@implementation rNamenZuTestDS : NSObject
- (id)init
{
   self=[super init];
   NamenZuTestDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   aktuellerTest=@"";
   return self;
}

- (void)setNamenZuTestArrayMitDicArray:(NSArray*) derDicArray
{
   //NSLog(@"\n\n\n*******\nsetTestZuNamenArrayMitDicArray:	DicArray: %@\n\n",[[derDicArray valueForKey:@"name"] description]);
   /*
    Aus NamenDicArray der PList den NamenZuTestDicArray aufbauen
    - Name des Users (nur aktive)
    - UserTestArray: zugeteilte Tests
    */
   //	NSLog(@"setNamenZuTestArrayMitDicArray:	derDicArray object 0: %@",[[derDicArray objectAtIndex:0] description]);
   [NamenZuTestDicArray removeAllObjects];
   NSEnumerator* DicEnum=[derDicArray objectEnumerator];
   
   id einDic;
   
   while (einDic=[DicEnum nextObject])
   {
      if ([[einDic objectForKey:@"aktiv"]boolValue])//Nur aktive User aufnehmen
      {
         //NSLog(@"setNamenZuTestArrayMitDicArray:	einDic: %@",[einDic description]);
         NSMutableDictionary* tempDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
         
         NSString* Username=[einDic objectForKey:@"name"];
         if (Username)
         {
            [tempDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"aktiv"];
            [tempDictionary setObject:Username forKey:@"name"];
            
            
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
            
            if ([einDic objectForKey:@"usertestarray"])
            {
               [tempDictionary setObject:[einDic objectForKey:@"usertestarray"] forKey:@"usertestarray"];
            }
            
            [NamenZuTestDicArray addObject:tempDictionary];
         }//if name
      }//if aktiv
   }//while
   //NSLog(@"setNamenZuTestArrayMitDicArray: %@\n\n",[NamenZuTestDicArray description]);
   
}

- (NSArray*)NamenZuTestDicArray
{
   return NamenZuTestDicArray;
}

- (void)addTestZuTestListe:(NSString*)derTest zuNamen:(NSString*)derUser
{
   NSArray* tempNamenArray=[NamenZuTestDicArray valueForKey:@"name"];
   long index=[tempNamenArray indexOfObject:derUser];
   if (index<NSNotFound)//User ist da
   {
      NSMutableDictionary* tempNamenDic=(NSMutableDictionary*)[NamenZuTestDicArray objectAtIndex:index];
      
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

- (void)setNamenliste:(NSArray*)derNamenArray zuTest:(NSString*)derTest
{
   //NSLog(@"			setNamenliste: %@	zuTest: %@",[derNamenArray description], derTest);
   //	NSArray* tempTestNamenArray=[NamenZuTestDicArray valueForKey:@"testname"];
   //	NSLog(@"setNamenListe	tempTestNamenArray: %@",[tempTestNamenArray description]);
   
   NamenZuTestDicArray =(NSMutableArray*)derNamenArray;
   aktuellerTest=derTest;
   //NSLog(@"setNamenliste: aktuellerTest: %@  NamenZuTestDicArray: %@",aktuellerTest,[NamenZuTestDicArray description]);
   return;
   
   
   NSEnumerator* TestEnum=[NamenZuTestDicArray objectEnumerator];
   id einTestDic;
   int anzTest=0;
   while(einTestDic=[TestEnum nextObject])
   {
      
      //NSLog(@"einTestDic	: %@",[einTestDic description]);
      NSString* tempTestName=[einTestDic objectForKey:@"testname"];
      if (tempTestName)
      {
         
         if ([derNamenArray containsObject:tempTestName])//Test ist in usertestarray
         {
            [einTestDic setObject:[NSNumber numberWithBool:YES]forKey:@"userok"];
            anzTest++;
            //				NSLog(@"Test ist in usertestarray: %@",[einTestDic description]);
         }
         else
         {
            [einTestDic setObject:[NSNumber numberWithBool:NO]forKey:@"userok"];
            
         }
         
      }//if tempTestName
   }//while
   
   if ([NamenZuTestDicArray count]&&(anzTest==0))
   {
      [[NamenZuTestDicArray objectAtIndex:0]setObject:[NSNumber numberWithBool:YES]forKey:@"userok"];
      
   }
   dirty=NO;
   
}//setTestlisteZuNamen


- (NSArray*)TestListeZuNamen:(NSString*)derUser
{
   NSMutableArray* tempTestArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   
   return tempTestArray;
}

- (void)setUserOKForAllForTest:(NSString*)derTest
{
   NSEnumerator* TestEnum=[NamenZuTestDicArray objectEnumerator];
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

- (NSArray*)aktuellerUserTestArray
{//Array mit Tests, die für den aktuellen User aktiviert sind
   NSMutableArray* tempTestArray=[[NSMutableArray alloc]initWithCapacity:0];
   int anzTest=0;
   
   NSEnumerator* TestEnum=[NamenZuTestDicArray objectEnumerator];
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
   return [NamenZuTestDicArray count];
}


- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(long)rowIndex
{
   //NSLog(@"objectValueForTableColumn");
   NSDictionary *einNamenDic;
   if (rowIndex<[NamenZuTestDicArray count])
   {
      einNamenDic = [NamenZuTestDicArray objectAtIndex: rowIndex];
      return [einNamenDic objectForKey:[aTableColumn identifier]];
   }
   //NSLog(@"einSessionDic: aktiv: %d   Testname: %@",[[einSessionDic objectForKey:@"aktiv"]intValue],[einSessionDic objectForKey:@"name"]);
   return NULL;
   
   
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(long)rowIndex
{
   //NSLog(@"NamenZuTestDS setObjectValueForTableColumn: %@  zeile: %d",[aTableColumn identifier],rowIndex);
   if (rowIndex<[NamenZuTestDicArray count])
   {
      NSMutableDictionary* einNamenDic;
      einNamenDic=[NamenZuTestDicArray objectAtIndex:rowIndex];
      //		NSLog(@"NamenZuTestDS setObjectValueForTableColum einNamenDic: %@",[einNamenDic description]);
      if ([einNamenDic objectForKey:@"usertestarray"])
      {
         //		if ([[einNamenDic objectForKey:@"usertestarray"]count]==1)
         //		{
         //		NSLog(@"NamenZuTestDS setObjectValueForTableColumn nur noch ein Test");
         //		}
         
      }
      [einNamenDic setObject:anObject forKey:[aTableColumn identifier]];
      dirty=YES;
      //NSLog(@"NamenZuTestDS setObjectValueForTableColumn END");
   }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(long)row
{
   //NSLog(@"shouldSelectRow");  
   return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(long)row
{
   
   
   //NSLog(@"willDisplayCell: zeile: %d",row);
   NSDictionary* einDic=[NamenZuTestDicArray objectAtIndex:row];
   
   if ([[tableColumn identifier]isEqualToString:@"testok"])
   {
      //NSLog(@"willDisplayCell aktuellerTest: %@",aktuellerTest);
      
      if ([aktuellerTest length])
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