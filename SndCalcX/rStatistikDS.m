//
//  rStatistikDS.m
//  SndCalcII
//
//  Created by Sysadmin on 18.03.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "rStatistikDS.h"

@implementation rGrafikCell:NSCell
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
   //Daten von Ergebnisse fuer Test
   //	NSLog(@"StatistikDS GrafikCell setGrafikDaten : %@",[derGrafikDic description]);
   art=[[derGrafikDic objectForKey:@"art"]intValue];
   anzAufgaben=[[derGrafikDic objectForKey:@"anzaufgaben"]intValue];
   anzRichtig=[[derGrafikDic objectForKey:@"anzrichtig"]intValue];
   anzFehler=[[derGrafikDic objectForKey:@"anzfehler"]intValue];
   zeit=[[derGrafikDic objectForKey:@"zeit"]intValue];
   maxzeit=[[derGrafikDic objectForKey:@"maxzeit"]intValue];
   if ([derGrafikDic objectForKey:@"grafiktext"])
   {
      GrafikTextString=[derGrafikDic objectForKey:@"grafiktext"];
   }
   else
   {
      GrafikTextString=@"";
   }
   
   if ([derGrafikDic objectForKey:@"grafikdatentext"])
   {
      GrafikTextString=[derGrafikDic objectForKey:@"grafikdatentext"];
   }
   else
   {
      GrafikTextString=@"";
   }
   
   if ([derGrafikDic objectForKey:@"farbig"])
   {
      farbig=[[derGrafikDic objectForKey:@"farbig"]boolValue];
   }
   else
   {
      farbig=YES;
   }
   
   //	NSLog(@"StatistikDS GrafikCell setGrafikDaten: GrafikTextString: %@",GrafikTextString);
   
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
   
   //NSLog(@"controlView: %@",[controlView description]);
   //NSLog(@"drawInteriorWithFrame GrafikRahmen: %f  %f",GrafikRahmen.size.height,GrafikRahmen.size.width);
   float Anzeigebreite=0.0;
   float Raster=0;
   GrafikRahmen=cellFrame;
   switch (art)
   {
      case 0:
      {
         
      }break;
      case 1:
      case 2:
      {
         GrafikRahmen.origin.x+=4.5;
         GrafikRahmen.origin.y+=2.5;
         GrafikRahmen.size.height-=4.0;
         GrafikRahmen.size.width-=10.0;
         
         //NSLog(@"drawInterior:	anzAufgaben: %d",anzAufgaben);
         if (anzAufgaben==0)
         {
            return;
         }
         NSDictionary* Attr;
         if (anzAufgaben==anzRichtig)//alle Aufgaben gelöst
         {
            
            NSString* s=@"Grafik";
            if (farbig)
            {
               Attr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:10], NSFontAttributeName,nil];
            }
            else
            {
               Attr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor grayColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:10], NSFontAttributeName,nil];
               
            }
            //[s drawInRect:cellFrame withAttributes:Attr];
            //return;
            
            Raster=(GrafikRahmen.size.width)/ maxzeit;
            //NSLog(@"Breite: %f maxzeit: %d Raster: %d",cellFrame.size.width,maxzeit,Raster);
            Anzeigebreite=Raster*zeit;
            Anzeigebalken=GrafikRahmen;
            Anzeigebalken.size.width=Anzeigebreite;
            
            
            [[NSColor greenColor]set];
            [NSBezierPath fillRect:Anzeigebalken];
            
            [[NSColor lightGrayColor]set];
            [NSBezierPath strokeRect:GrafikRahmen];
            
         }
         else
         {
            Raster=(GrafikRahmen.size.width+1.0)/ anzAufgaben;
            //Balkenbreite=Raster*anzRichtig;
            NSRect Feld=GrafikRahmen;
            //NSLog(@"Breite: %f anzAufgaben: %d Raster: %d Feld.origin.x: %f",cellFrame.size.width,anzAufgaben,Raster,Feld.origin.x);
            
            //Feld.origin.x+=0.5;
            Feld.size.width=Raster-2.0;//Feld fuer eine Aufgabe
            int i;
            float originx=Feld.origin.x;
            for (i=0;i<anzAufgaben;i++)
            {
               Feld.origin.x=originx+i*Raster;
               //NSLog(@"i: %d origin.x: %f Feld.origin.y: %f",i,Feld.origin.x,Feld.origin.y);
               if (i<anzRichtig)
               {
                  [[NSColor cyanColor]set];
                  [NSBezierPath fillRect:Feld];
               }
               //else
               {
                  NSBezierPath* bp=[NSBezierPath bezierPathWithRect:Feld];
                  [[NSColor blackColor] set];
                  [bp setLineWidth:0.5];
                  [bp stroke];
               }
               //Feld.origin.x+=(Raster);
            }//for i
            
         }
      }break;//case 1,2
         
      case 4://TestTitel
      {
         
         //	NSLog(@"GrafikCell    drawRect: Grafiktext: %@",GrafikTextString);
         NSFont* TestTitelFont=[NSFont fontWithName:@"Helvetica-Bold" size: 8];
         
         NSDictionary* Attr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor blackColor], NSForegroundColorAttributeName,[NSFont fontWithName:@"Helvetica-Bold" size: 12], NSFontAttributeName,nil];
         [GrafikTextString drawInRect:GrafikRahmen withAttributes:Attr];
         
      }
   }//switch
}

@end



@implementation rStatistikDS
- (id)init
{
   ErgebnisDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   farbig=YES;
   return self;
}

- (void)setAdminStatistikDicArray:(NSArray*)derAdminStatistikDicArray
{
   /*
    Admin-Modus: Daten im Array der Datenquelle einsetzen
    
    Die Daten kommen von der Funktion 'setAdminTestNamenPop' von Statistik. Dort werden sie
    von der Funktion ErgebnisDicArrayForTest nach den Einstellungen im Statistikfenster ausgesucht.
    */
   //NSLog(@"StatistikDS");
   //NSLog(@"StatistikDS	setAdminStatistikDicArray: Count: %d",[derAdminStatistikDicArray count]);
   //NSLog(@"StatistikDS	setAdminStatistikDicArray: Array: %@",[derAdminStatistikDicArray description]);
   AdminStatistikDicArray=derAdminStatistikDicArray;
   [ErgebnisDicArray removeAllObjects];
   NSEnumerator* DicEnum=[AdminStatistikDicArray objectEnumerator];
   id einDic;
   NSString* tempName=[NSString string];
   while (einDic=[DicEnum nextObject])
   {
      NSMutableDictionary* tempDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
      [tempDic setObject:[einDic objectForKey:@"name"] forKey:@"name"];//Namen einsetzen
      //NSLog(@"setAdminStatistikDicArray			vor	Name einsetzen");
      
      if ([[einDic objectForKey:@"name"]length]&&[[einDic objectForKey:@"name"]isEqualToString:tempName])//Name kam schon einmal vor
      {
         [tempDic setObject:@" " forKey:@"nametext"];
      }
      else
      {
         [tempDic setObject:[einDic objectForKey:@"name"] forKey:@"nametext"];//Namen einsetzen
         tempName=[einDic objectForKey:@"name"];
      }
      //NSLog(@"setAdminStatistikDicArray				Name eingesetzt");
      //Die Daten  müssen mit dem richtigen key eingesetzt werden
      //NSLog(@"Testname: %@",[einDic objectForKey:@"testname"]);
      if ([einDic objectForKey:@"datumtext"])
      {
         [tempDic setObject:[einDic objectForKey:@"datumtext"] forKey:@"datumtext"];
      }
      if ([einDic objectForKey:@"art"])
      {
         [tempDic setObject:[einDic objectForKey:@"art"] forKey:@"art"];
      }
      [tempDic setObject:[einDic objectForKey:@"testname"] forKey:@"testname"];
      [tempDic setObject:[einDic objectForKey:@"zeit"] forKey:@"zeit"];
      [tempDic setObject:[einDic objectForKey:@"maxzeit"] forKey:@"maxzeit"];
      [tempDic setObject:[einDic objectForKey:@"anzfehler"] forKey:@"fehler"];
      [tempDic setObject:[einDic objectForKey:@"anzfehler"] forKey:@"anzfehler"];
      [tempDic setObject:[einDic objectForKey:@"anzrichtig"] forKey:@"anzrichtig"];
      [tempDic setObject:[einDic objectForKey:@"anzaufgaben"] forKey:@"anzaufgaben"];
      [tempDic setObject:[einDic objectForKey:@"anzfehler"] forKey:@"anzfehler"];
      if ([einDic objectForKey:@"grafikdatentext"])
      {
         [tempDic setObject:[einDic objectForKey:@"grafikdatentext"] forKey:@"grafikdatentext"];
      }
      if ([einDic objectForKey:@"art"])
      {
         [tempDic setObject:[einDic objectForKey:@"art"] forKey:@"art"];
      }
      
      if ([einDic objectForKey:@"allezeigen"])
      {
         [tempDic setObject:[einDic objectForKey:@"allezeigen"] forKey:@"allezeigen"];
      }
      if ([einDic objectForKey:@"mittel"])
      {
         NSString* MittelString=[NSString stringWithFormat:@"%2.1f",[[einDic objectForKey:@"mittel"]floatValue]];
         [tempDic setObject:MittelString forKey:@"mittel"];
      }
      //[tempDic setObject:[einDic objectForKey:@"datum"] forKey:@"datum"];
      if ([einDic objectForKey:@"datum"]==@"Datum")
      {
         [tempDic setObject:@"Datum" forKey:@"datum"];
      }
      else
      {
         NSCalendarDate* tempDate=[[NSCalendarDate alloc]initWithString:[[einDic objectForKey:@"datum"]description]];
         //NSLog(@"reportTestnamen	tempDate: %@",[tempDate description]);
         if (tempDate)
         {
            //int test=[[NSCalendarDate calendarDate] dayOfMonth];
            //NSLog(@"Heute ganz: %@ test heute: %d",[NSCalendarDate calendarDate],test);
            int tag=[tempDate dayOfMonth];
            int monat=[tempDate monthOfYear];
            int jahr=[tempDate yearOfCommonEra];
            NSString* JahrString=[[NSNumber numberWithInt:jahr]stringValue];
            JahrString=[JahrString substringFromIndex:2];
            NSString* Tag=[NSString stringWithFormat:@"%d.%d.%@",tag,monat,JahrString];
            
            //NSString* Tag=[NSString stringWithFormat:@"%d.%d.%d",tag,monat,jahr];
            [tempDic setObject:[einDic objectForKey:@"datum"] forKey:@"datum"];
            [tempDic setObject:Tag forKey:@"datumtext"];
            //NSLog(@"reportTestnamen: %@  Tag: %@",tempDate,Tag);
         }
      }
      
      if ([einDic objectForKey:@"note"])
      {
         if ([[einDic objectForKey:@"name"]isEqualToString:@"Andrina Schmuki"])
         {
            //		NSLog(@"setAdminStatistikDicArray Name: %@	Note: %@",[einDic objectForKey:@"name"],[einDic objectForKey:@"note"]);
         }
         NSString* NoteString=[einDic objectForKey:@"note"];
         if ([[einDic objectForKey:@"note"] length])
         {
            //NSBeep();
            [tempDic setObject:[einDic objectForKey:@"note"] forKey:@"note"];
         }
         else
         {
            [tempDic setObject:@"" forKey:@"note"];
            
            //NSLog(@"keine Note:		Name: %@",[einDic objectForKey:@"name"]);
         }
      }
      //NSLog(@"StatistikDS	setAdminStatistikDicArray: tempDic: %@",[tempDic description]);
      
      [ErgebnisDicArray addObject:tempDic];
      //NSLog(@"StatistikDS end");
   }//while einDic
   
}

- (void)setFarbig:(BOOL)farbigDrucken
{
   
   farbig=farbigDrucken;
   NSLog(@"StatistikDS setFarbig: %d",farbig);
}

- (void)markNoteChanged:(NSString*)dieNote forRow:(int)dieZeile
{
   NSLog(@"markNoteChangedForRow: %d ",dieZeile);
   //NSBeep();
   [[ErgebnisDicArray objectAtIndex:dieZeile]setObject:[NSNumber numberWithInt:1] forKey:@"notechanged"];
   [[ErgebnisDicArray objectAtIndex:dieZeile]setObject:dieNote forKey:@"note"];
   //NSLog(@"markNoteChangedForRow: %d  Dic: %@ ",dieZeile,[[ErgebnisDicArray objectAtIndex:dieZeile]description]);
}


- (NSDictionary*)DicForRow:(int)dieZeile
{
   return [ErgebnisDicArray objectAtIndex:dieZeile];
   
}

- (NSArray*)NoteChangedDicArray
{
   //NSLog(@"			NoteChangedDicArray DS ErgebnisDicArray: %@",[ErgebnisDicArray description]);
   
   NSMutableArray* returnDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSEnumerator* NoteEnum=[ErgebnisDicArray objectEnumerator];
   id einDic;
   while (einDic=[NoteEnum nextObject])
   {
      //NSLog(@"			NoteChangedDicArray DS einDic: %@",[einDic description]);
      if ([einDic objectForKey:@"notechanged"])//Note wurde bearbeitet
      {
         //NSLog(@"			einDic mit notechanged: %@",[einDic description]);
         [returnDicArray addObject:einDic];
      }
   }//while
   //NSLog(@"NoteChangedDicArray			returnDicArray: %@",[returnDicArray description]);
   return returnDicArray;
}


- (NSArray*)ClearNoteDicArray
{
   //NSLog(@"			ClearNoteDicArray DS ErgebnisDicArray: %@",[ErgebnisDicArray description]);
   
   NSMutableArray* returnDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSEnumerator* NoteEnum=[ErgebnisDicArray objectEnumerator];
   id einDic;
   while (einDic=[NoteEnum nextObject])
   {
      //NSLog(@"			ClearNoteDicArray DS einDic: %@",[einDic description]);
      [einDic setObject:@"" forKey:@"note"];//Note loeschen
      [einDic setObject:[NSNumber numberWithInt:1] forKey:@"notechanged"];//Dic markieren
      [returnDicArray addObject:einDic];
   }//while
   //NSLog(@"ClearNoteDicArray			returnDicArray: %@",[returnDicArray description]);
   return returnDicArray;
}

#pragma mark -
#pragma mark TestTable delegate:


#pragma mark -
#pragma mark TestTable Data Source:

- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
{
   //NSLog(@"controlTextDidBeginEditing Zeile: %d",[[aNotification object]selectedRow]);
   int zeile=[[aNotification object]selectedRow];
   NSString* Name=[[ErgebnisDicArray objectAtIndex:zeile]objectForKey:@"name"];
   
   //NSLog(@"controlTextDidBeginEditing Zeile: %d	Name: %@",[[aNotification object]selectedRow],Name);
   
   
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
   //NSLog(@"controlTextDidEndEditing Note: %@",[[[aNotification userInfo]objectForKey:@"NSFieldEditor"]string]);
   int zeile=[[aNotification object]selectedRow];
   //NSString* Name=[[[[aNotification object]tableColumnWithIdentifier:@"nametext"]dataCellForRow:zeile]stringValue];
   NSString* Note=[[[aNotification userInfo]objectForKey:@"NSFieldEditor"]string];
   //NSLog(@"controlTextDidEndEditing Zeile: %d	Note: %@	Name: %@",[[aNotification object]selectedRow],Note,Name);
   //NSLog(@"controlTextDidEndEditing Zeile: %d	Note: %@",[[aNotification object]selectedRow],Note);
   if (Note)
   {
      [self markNoteChanged:Note forRow:zeile];
   }
}


- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
   return [ErgebnisDicArray count];
}


- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(int)rowIndex
{
   //NSLog(@"objectValueForTableColumn");
   NSDictionary *einTestDic;
   if (rowIndex<[ErgebnisDicArray count])
   {
      einTestDic = [ErgebnisDicArray objectAtIndex: rowIndex];
      
   }
   //NSLog(@"einTestDic  Testname: %@",[einTestDic objectForKey:@"name"]);
   
   return [einTestDic objectForKey:[aTableColumn identifier]];
   
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(int)rowIndex
{
   NSLog(@"setObjectValueForTableColumn");
   
   NSMutableDictionary* einTestDic;
   if (rowIndex<[ErgebnisDicArray count])
   {
      einTestDic=[ErgebnisDicArray objectAtIndex:rowIndex];
      [einTestDic setObject:anObject forKey:[aTableColumn identifier]];
   }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row
{
   //NSLog(@"shouldSelectRow");
   
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithInt:row] forKey:@"zeile"];
   
   NSDictionary* deleteZeilenDic=[ErgebnisDicArray objectAtIndex:row];
   if (deleteZeilenDic &&[deleteZeilenDic objectForKey:@"art"])
   {
      [NotificationDic setObject:[deleteZeilenDic objectForKey:@"art"] forKey:@"art"];
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"DeleteKnopf" object:self userInfo:NotificationDic];
      
      if ([[deleteZeilenDic objectForKey:@"art"]intValue]==0)
      {
         return NO;
      }
      
   }
   
   
   return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
   NSMutableDictionary* tempZeilenDic=(NSMutableDictionary*)[ErgebnisDicArray objectAtIndex:row];
   //	[tempZeilenDic setObject:[NSNumber numberWithBool:farbig]forKey:@"farbig"];
   //	[tempZeilenDic setObject:[NSNumber numberWithBool:NO]forKey:@"farbig"];
   
   //	NSLog(@"StatistikDS willDisplayCell tempZeilenDic: %@",[tempZeilenDic description]);
   
   if ([[tableColumn identifier]isEqualToString:@"zeit"])
   {
      if (([[tempZeilenDic objectForKey:@"zeit"]intValue]>0)&&([[tempZeilenDic objectForKey:@"maxzeit"]intValue] ==[[tempZeilenDic objectForKey:@"zeit"]intValue]))
      {
         //
         [cell setTextColor:[NSColor redColor]];
      }
      else
      {
         [cell setTextColor:[NSColor blackColor]];
      }
   }
   
   if ([[tableColumn identifier]isEqualToString:@"grafik"])
   {
      //NSLog(@" StatistikTable willDisplayCell Zeile: %d, ", row );
      //NSLog(@"willDisplayCell GrafikRahmen: %f  %f",[cell GrafikRahmen].size.height,[cell GrafikRahmen].size.width);
      
      if (tempZeilenDic)
      {
         NSString* TestString=@"Grafiktext";
         int kolIndex=[tableView columnWithIdentifier:@"grafik"];
         NSRect cellFeld=[tableView frameOfCellAtColumn:kolIndex row:row];
         //			[TestString drawInRect:cellFeld withAttributes:NULL];
         //NSLog(@"Zeit: %@",[tempZeilenDic objectForKey:@"zeit"]);
         //			NSLog(@"StatistikDS willDisplay:        tempZeilenDic: %@                     **",[tempZeilenDic description]);           
         [cell setGrafikDaten:tempZeilenDic];
         //[[NSColor cyanColor]set];
      }
   }
   
   if ([[tableColumn identifier]isEqualToString:@"malpoints"])
   {
      if (tempZeilenDic)
      {
         
         [cell setGrafikDaten:tempZeilenDic];		
      }
   }
   
   if ([[tableColumn identifier]isEqualToString:@"note"])
   {
      if (tempZeilenDic)
      {
         //NSLog(@"Name: %@",[tempZeilenDic objectForKey:@"name"]);
         if (([[tempZeilenDic objectForKey:@"nametext"]length]>5))
         {
            //NSArray* NotenArray=[NSArray arrayWithObjects:@"6",@"5-6",@"5",@"4-5",@"4",@"3-4",@"3",@"2-3",nil];
            [[NSColor redColor]set];
            //[cell setBordered:YES];
            [cell setEditable:YES];
            [cell setDrawsBackground:YES];
            //[cell setCellType:NSComboBoxCell];		
         }
         else
         {
            [[NSColor blackColor]set];
            
            [cell setBordered:NO];
            [cell setEditable:NO];
            [cell setDrawsBackground:NO];
            
         }
      }
   }
   if ([[tableColumn identifier]isEqualToString:@"nametext"]||[[tableColumn identifier]isEqualToString:@"datumtext"])
   {
      if ([[tempZeilenDic objectForKey:@"art"]intValue]==4)//TestTitelZeile
      {
         //
         [cell setFont:[NSFont fontWithName:@"Helvetica-Bold" size: 12]];
         //[cell setTextColor:[NSColor redColor]];
      }
      else
      {
         [cell setFont:[NSFont fontWithName:@"Helvetica" size: 12]];
         [cell setAlignment:NSLeftTextAlignment];	
         //[cell setTextColor:[NSColor blackColor]];
      }
   }
   if ([[tableColumn identifier]isEqualToString:@"testname"])
   {
      //		NSLog(@" StatistikTable willDisplayCell Testname: Zeile: %d, ", row );
      [cell setAlignment:NSCenterTextAlignment];
   }
   
}//willDisplayCell



@end
