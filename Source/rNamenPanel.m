#import "rNamenPanel.h"

@implementation rNamenPanel

- (id)init
{
self = [super initWithWindowNibName:@"SCNamenPanel"];
neuerName=[NSString string];
NamenArray=[[NSMutableArray alloc]initWithCapacity:0];
NamenDicArray=[[NSMutableArray alloc]initWithCapacity:0];

return self;
}

- (void)awakeFromNib
{
	[IconFeld setImage:[NSImage imageNamed:@"duerergrau"]];
//	[NamenTable setDataSource:self];
	
}
- (IBAction)reportCancel:(id)sender
{
	[VornamenFeld setStringValue:@""];
	[NamenFeld setStringValue:@""];
	[NamenView setString:@""];
	[NamenTable deselectAll:NULL];

	[NSApp stopModalWithCode:0];
	[[self window] orderOut:NULL];

}

- (IBAction)reportEntfernen:(id)sender
{
if ([NamenTable numberOfSelectedRows])
{
NSInteger index=[NamenTable selectedRow];
NSString* deleteName=[[NamenDicArray objectAtIndex:index] valueForKey:@"name"];
NSAlert *Warnung = [[NSAlert alloc] init];
[Warnung addButtonWithTitle:NSLocalizedString(@"Delete",@"Lšschen")];
[Warnung addButtonWithTitle:NSLocalizedString(@"Cancel",@"Abbrechen")];			
[Warnung setMessageText:NSLocalizedString(@"Are You Shure?",@"Namen wirklich entfernen?")];
NSString* I1=NSLocalizedString(@"Do you really want do delete the name %@?",@"Namen %@wiklich entfernen?");
[Warnung setInformativeText:[NSString stringWithFormat:I1,deleteName]];
[Warnung setAlertStyle:NSWarningAlertStyle];

//[Warnung setIcon:RPImage];
NSInteger modalAntwort=[Warnung runModal];
switch (modalAntwort)
{
	case NSAlertFirstButtonReturn://Loeschen
	{ 
		NSLog(@"Papierkorb");
		NSString*deleteName=[[NamenDicArray objectAtIndex:index]objectForKey:@"name"];
		
		NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		[NotificationDic setObject:deleteName forKey:@"deletename"];
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"DeleteName" object:self userInfo:NotificationDic];
		[NamenDicArray removeObjectAtIndex:index];
		[NamenTable reloadData];

	}break;
		
	case NSAlertSecondButtonReturn://Abbrechen
	{
		return;		
	}break;
	case NSAlertThirdButtonReturn://
	{
		
	}break;		
}
	[NamenTable deselectAll:NULL];

}//if number
}

- (NSString*)neuerName
{
return neuerName;
}

- (NSArray*)getNamenArray
{
return [NamenArray copy];
}

- (NSArray*)getNamenDicArray
{
return [NamenDicArray copy];
}

- (void)setNamenDicArray:(NSArray*)derDicArray
{
//NSLog(@"NamenPanel setNamenDicArray: derDicArray: %@",[derDicArray description]);
[NamenDicArray removeAllObjects];
[NamenDicArray addObjectsFromArray:derDicArray];
[NamenTable reloadData];
}

- (IBAction)reportClose:(id)sender
{
	
	[NamenArray removeAllObjects];
	NSMutableString* tempNamenViewString =(NSMutableString*)[NamenView string];//Neuer Name
	if ([tempNamenViewString length])
	{
		//NSLog(@"tempNamenViewString: %@",[tempNamenViewString description]);
		NSInteger anzCR=[tempNamenViewString replaceOccurrencesOfString:@"\n"
													   withString:@"\r" 
														  options:NSCaseInsensitiveSearch
															range:NSMakeRange(0, [tempNamenViewString length])];
		//NSLog(@"anzCR: %d",anzCR);
		
		int nochDoppelteCR=YES;
		while (nochDoppelteCR)//Doppelte CR entfernen
		{
			NSInteger anzCR=[tempNamenViewString replaceOccurrencesOfString:@"\r\r"
														   withString:@"\r" 
															  options:NSCaseInsensitiveSearch
																range:NSMakeRange(0, [tempNamenViewString length])];
			//NSLog(@"anzCR: %d",anzCR);
			if (anzCR==0)
			{
				nochDoppelteCR=0;
			}
		}//while
		
		//Den string mit den neuen Namen in Zeilen aufteilen: Namen
		NSArray* tempNamenViewArray=[tempNamenViewString componentsSeparatedByString:@"\r"];// NamensZeilen
		
		//NSLog(@"tempNamenViewArray: %@  %d",[tempNamenViewArray description],[tempNamenViewArray count]);
		
		int i;
		for (i=0;i<[tempNamenViewArray count];i++)
		{
			NSMutableString* tempZeilenstring=[[tempNamenViewArray objectAtIndex:i]mutableCopy];//Namen auf Zeile i
			if ([tempZeilenstring length])
			{
				//NSLog(@"tempZeilenstring  Anfang: %@",tempZeilenstring);
				
				//NSMutableString* tempZeilenstring=(NSMutableString*)eineZeile;
				//NSLog(@"tempZeilenstring: %@  tempZeilenstring Anfang: %@",tempZeilenstring,tempZeilenstring);
				int nochTabs=YES;
				while (nochTabs)//Tabs ersetzen durch Leerschlag
				{
					NSInteger anzTabs=[tempZeilenstring replaceOccurrencesOfString:@"\t"
																  withString:@" " 
																	 options:NSCaseInsensitiveSearch
																	   range:NSMakeRange(0, [tempZeilenstring length])];
					//NSLog(@"anzTabs: %d",anzTabs);
					if (anzTabs==0)
					{
						nochTabs=0;
					}
				}//while
				int nochDoppelterLeerschlag=YES;
				while (nochDoppelterLeerschlag)//doppelte LeehrschlŠge entfernen
				{
					NSInteger anzLeerschlag=[tempZeilenstring replaceOccurrencesOfString:@"  "
																		withString:@" " 
																		   options:NSCaseInsensitiveSearch
																			 range:NSMakeRange(0, [tempZeilenstring length])];
					//NSLog(@"anzLeerschlag: %d",anzLeerschlag);
					if (anzLeerschlag==0)
					{
						nochDoppelterLeerschlag=0;
					}
				}//while
				//NSLog(@"tempZeilenstring sauber: %@",tempZeilenstring);
				NSArray* tempArray=[tempZeilenstring componentsSeparatedByString:@" "];
				NSMutableArray* tempNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
				int k;
				for (k=0;k<[tempArray count];k++)
				{
					if ([[tempArray objectAtIndex:k]length])
					{
						[tempNamenArray addObject:[tempArray objectAtIndex:k]];
					}
				}
				//NSLog(@"tempNamenArray : %@",[tempNamenArray description]);
				[tempNamenArray removeObjectIdenticalTo:@" "];
				NSLog(@"tempNamenArray sauber: %@",[tempNamenArray description]);
				NSString* VornamenString;
				NSString* NamenString;
				if ([tempNamenArray count]>1)
				{
					VornamenString=[self stringSauberVon:[tempNamenArray objectAtIndex:0]];
					NamenString=[self stringSauberVon:[tempNamenArray objectAtIndex:[tempNamenArray count]-1]];
					NSString* VornameNamenString=[NSString stringWithFormat:@"%@ %@",VornamenString,NamenString];
					//NSLog(@"VornameNamenString: %@",VornameNamenString);
					[NamenArray addObject: VornameNamenString];
					
				}//if count
				else
				{
					VornamenString=[self stringSauberVon:[tempNamenArray objectAtIndex:0]];
					[NamenArray addObject: VornamenString];
				}
			}//if length
		}//while enumerator
		
		//NSLog(@"NamenArray sauber: %@",[NamenArray description]);//Neue Namen aus NamenView, sofern vornhanden
	}
	else
	{
		// keine Namen
	}	
	[NamenTable deselectAll:NULL];
	
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	
	[NotificationDic setObject:[NamenArray copy] forKey:@"namenarray"];//
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"EinzelNamen" object:self userInfo:NotificationDic];
	
	//NSLog(@"reportClaose:	NamenPanel nach neuen Namen: NamenDicArray: %@",[NamenDicArray description]);
	
	[NamenView setString:@""];
	[NSApp stopModalWithCode:1];
	[[self window] orderOut:NULL];
	
	
}

- (NSString*)stringSauberVon:(NSString*)derString
{
	NSMutableString* tempString=[[NSMutableString alloc]initWithCapacity:0];
	tempString=[derString mutableCopy];
	BOOL LeerschlagAmAnfang=YES;
	BOOL LeerschlagAmEnde=YES;
	NSInteger index=[tempString length];
	while (LeerschlagAmAnfang || (LeerschlagAmEnde &&[tempString length]&&index))
	{
		if ([tempString characterAtIndex:0]==' ')
		{
			[tempString deleteCharactersInRange:NSMakeRange(0,1)];
		}
		else
		{
			LeerschlagAmAnfang=NO;
		}
		if ([tempString characterAtIndex:[tempString length]-1]==' ')
		{
			[tempString deleteCharactersInRange:NSMakeRange([tempString length]-1,1)];
		}
		else
		{
			LeerschlagAmEnde=NO;
		}
		index --;
	}//while
	//NSLog(@"stringSauber: resultString: *%@*",tempString);
	return tempString;
}

#pragma mark TestTable Data Source:

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return (int)[NamenDicArray count];
}


- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(int)rowIndex
{
//NSLog(@"objectValueForTableColumn");
    NSDictionary *einNamenDic;
	if (rowIndex<[NamenDicArray count])
	{
			einNamenDic = [NamenDicArray objectAtIndex: rowIndex];
			
	}
	//NSLog(@"einNamenDic: aktiv: %d   Testname: %@",[[einNamenDic objectForKey:@"aktiv"]intValue],[einNamenDic objectForKey:@"name"]);

	return [einNamenDic objectForKey:[aTableColumn identifier]];
	
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex
{
NSLog(@"setObjectValueForTableColumn");

    NSMutableDictionary* einNamenDic;
    if (rowIndex<[NamenDicArray count])
	{
		einNamenDic=[NamenDicArray objectAtIndex:rowIndex];
		[einNamenDic setObject:anObject forKey:[aTableColumn identifier]];
	}
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row
{
  //NSLog(@"shouldSelectRow");

  NSString* tempNamenString=[[NamenDicArray objectAtIndex:row]objectForKey:@"name"];
	//[DeleteTaste setEnabled:YES];
 
  
    if ([[[NamenDicArray objectAtIndex:row]objectForKey:@"neuername"]boolValue])
  {
  //[NameAusListeTaste setEnabled:YES];
  }
  else
  {
 //   [NameAusListeTaste setEnabled:NO];

  }
  
  return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
	//NSLog(@"ProjektListe willDisplayCell Zeile: %d, numberOfSelectedRows:%d", row ,[tableView numberOfSelectedRows]);
	NSString* tempTestNamenString=[[NamenDicArray objectAtIndex:row]objectForKey:@"name"];
	if([[[NamenDicArray objectAtIndex:row]objectForKey:@"neuername"]boolValue])//neuer Name
	{
	//[cell setTextColor:[NSColor redColor]];
	}
	else//alter Name
	{
	//[cell setTextColor:[NSColor blackColor]];
	}
}//willDisplayCell
  
  


@end
