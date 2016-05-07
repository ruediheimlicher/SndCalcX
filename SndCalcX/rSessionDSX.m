#import "rSessionDSX.h"

@implementation rSessionCell : NSCell

- (id)init
{
   self=[super init];
   
   return self;
}

- (void)setRahmen:(NSRect)derRahmen
{
   GrafikRahmen=derRahmen;
   b=GrafikRahmen.size.width;
   h=GrafikRahmen.size.height;
   
}

- (NSRect)GrafikRahmen
{
   return GrafikRahmen;
}


- (void)setGrafikDaten:(NSDictionary*)derGrafikDic
{
   //NSLog(@"setGrafikDaten: %@",[derGrafikDic description]);
   art=[[derGrafikDic objectForKey:@"art"]intValue];
   anzAufgaben=[[derGrafikDic objectForKey:@"anzaufgaben"]intValue];
   anzRichtig=[[derGrafikDic objectForKey:@"anzrichtig"]intValue];
   anzFehler=[[derGrafikDic objectForKey:@"anzfehler"]intValue];
   zeit=[[derGrafikDic objectForKey:@"zeit"]intValue];
   maxzeit=[[derGrafikDic objectForKey:@"maxzeit"]intValue];
   sessionOK=[[derGrafikDic objectForKey:@"session"]boolValue];
   
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
   //NSLog(@"controlView: %@",[controlView description]);
   //NSLog(@"drawInteriorWithFrame GrafikRahmen: %f  %f",GrafikRahmen.size.height,GrafikRahmen.size.width);
   float Anzeigebreite=0.0;
   float Raster=0;
   GrafikRahmen=cellFrame;
   GrafikRahmen.origin.x+=4.5;
   GrafikRahmen.origin.y+=2.5;
   GrafikRahmen.size.height-=5.0;
   GrafikRahmen.size.width=GrafikRahmen.size.height;
   NSRect Feld=GrafikRahmen;
   NSBezierPath* bp=[NSBezierPath bezierPathWithOvalInRect:Feld];
   //NSLog(@"drawInterior:	anzAufgaben: %d",anzAufgaben);
   if (sessionOK)//alle Aufgaben gelöst
   {
      [[NSColor greenColor]set];
   }
   else
   {
      [[NSColor whiteColor]set];
      //[NSBezierPath fillRect:Feld];
   }
   [bp fill];
   //[NSBezierPath fillRect:Feld];
}

@end

@implementation rSessionDS : NSObject

- (id)init
{
   self=[super init];
   SessionDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   return self;
}

- (void)setSessionDicArrayMitDicArray:(NSArray*) derDicArray mitDatum:(NSDate*)dasDatum
{
   NSLog(@"setSessionDicArrayMitDicArray:	Datum: %@\nDicArray: %@",[dasDatum description],[derDicArray description]);
   
   NSEnumerator* DicEnum=[derDicArray objectEnumerator];
   
   id einDic;
   
   while (einDic=[DicEnum nextObject])
   {
      if ([[einDic objectForKey:@"aktiv"]boolValue])
      {
         NSMutableDictionary* tempDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempDictionary setObject:[einDic objectForKey:@"name"]forKey:@"name"];
         
         if ([einDic objectForKey:@"lastdate"])
         {
            NSDate* tempDatum=[einDic objectForKey:@"lastdate"];
            //NSLog(@"setSessionDicArrayMitDicArray	Descending	einDic: %@\n				Sessiondatum: %@",tempDatum,dasDatum);
            
            if ([tempDatum compare:dasDatum]== NSOrderedDescending)//lastDate ist nach SessionDatum
            {
               //NSImage* SessionYESImg=[NSImage imageNamed:@"SessionYESImg.tif"];
               //NSImage* SessionYESImg=[NSImage imageNamed:@"MarkOnImg.tif"];
               [tempDictionary setObject:[NSNumber numberWithBool:YES]forKey:@"session"];
            }
            else
            {
               //NSLog(@"setSessionDicArrayMitDicArray	Ascending	einDic: %@	Sessiondatum: %@",[einDic description],dasDatum);
               [tempDictionary setObject:[NSNumber numberWithBool:NO]forKey:@"session"];
               
            }
         }
         else
         {
            [tempDictionary setObject:[NSNumber numberWithBool:NO]forKey:@"session"];
            
         }
         [SessionDicArray addObject:tempDictionary];
      }//if aktiv
   }//while
   
}

#pragma mark -
#pragma mark SessionTable Data Source:

- (long)numberOfRowsInTableView:(NSTableView *)aTableView
{
   return [SessionDicArray count];
}


- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(long)rowIndex
{
   //NSLog(@"objectValueForTableColumn");
   NSDictionary *einSessionDic;
   //	if (rowIndex<[SessionDicArray count])
   {
      einSessionDic = [SessionDicArray objectAtIndex: rowIndex];
      
   }
   //NSLog(@"einSessionDic: aktiv: %d   Testname: %@",[[einSessionDic objectForKey:@"aktiv"]intValue],[einSessionDic objectForKey:@"name"]);
   
   return [einSessionDic objectForKey:[aTableColumn identifier]];
   
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(long)rowIndex
{
   NSLog(@"setObjectValueForTableColumn");
   
   NSMutableDictionary* einSessionDic;
   if (rowIndex<[SessionDicArray count])
   {
      einSessionDic=[SessionDicArray objectAtIndex:rowIndex];
      [einSessionDic setObject:anObject forKey:[aTableColumn identifier]];
   }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(long)row
{
   //NSLog(@"shouldSelectRow");
   return NO;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(long)row
{
   NSDictionary* einSessionDic=[SessionDicArray objectAtIndex:row];
   //NSLog(@"einSessionDic: %@",[einSessionDic description]);
   
   if ([[tableColumn identifier]isEqualToString:@"session"])
   {
      //NSLog(@" StatistikTable willDisplayCell Zeile: %d, ", row );
      //NSLog(@"willDisplayCell GrafikRahmen: %f  %f",[cell GrafikRahmen].size.height,[cell GrafikRahmen].size.width);
      
      if (einSessionDic)
      {
         //NSLog(@"willDisplayCell session: %d",[[einSessionDic objectForKey:@"session"]intValue]);
         NSImage* SessionYESImg=[NSImage imageNamed:@"MarkOnImg.tif"];
         //[cell setImage:SessionYESImg];
         
         //	[cell setStringValue:[[einSessionDic objectForKey:@"session"]stringValue]];
         [cell setGrafikDaten:einSessionDic];
         //[[NSColor cyanColor]set];
      }
   }
   
   
   
   
}//willDisplayCell

@end