//
//  rAddSubSettings.m
//  SndCalcII
//
//  Created by Sysadmin on 18.10.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "rAddSubSettings.h"

enum
{
   kMitAdditionTaste,
   kMitSubtraktionTaste,
   kBereichPopMenu=3,
   kZehnerUPopMenu=5,
   kZweiteZahlPopMenu=7,
   kHunderterUPopMenu=9
};
@implementation rAddSubSettings



- (id)initWithFrame:(NSRect)frame
{
   //NSLog(@"rAddSubSettings initWithFrame");
   self=[super initWithFrame:frame];
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(AddSubSettingsAktion:)
              name:@"addsubsettings"
            object:nil];
   
   
   NSRect SettingsRect=frame;
   //[[NSColor redColor]set];
   //[NSBezierPath fillRect:SettingsRect];
   //NSLog(@"tabView frame: origin: %f %f size: %f %f ",SettingsRect.origin.x,SettingsRect.origin.y,SettingsRect.size.height,SettingsRect.size.width);
   
   int AbstandVonOben=105;
   int anzZeilen=3;
   int anzKolonnen=10;
   int KnopfmassH=26;
   int KnopfmassV=22;
   int AbstandH=2;
   int AbstandV=2;
   
   NSPoint EinschaltTastenEcke=SettingsRect.origin;
   EinschaltTastenEcke.y+=2*(KnopfmassV+AbstandV)+AbstandV;
   //EinschaltTastenEcke.x+=AbstandH;
   NSRect EinschaltTastenRect;
   EinschaltTastenRect.origin=EinschaltTastenEcke;
   EinschaltTastenRect.size.height=KnopfmassV;
   EinschaltTastenRect.size.width=anzKolonnen*(KnopfmassH+AbstandH)-AbstandH;
   EinschaltTaste=[[NSButton alloc]initWithFrame:EinschaltTastenRect];
   [EinschaltTaste setButtonType:NSSwitchButton];
   [[EinschaltTaste cell]setTitle:@"Addition und Subtraktion einschalten"];
   [EinschaltTaste setButtonType:NSSwitchButton];
   [[EinschaltTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];
   
   [EinschaltTaste setBordered:YES];
   [[EinschaltTaste cell]setTitle:@"Reihen einschalten"];
   [[EinschaltTaste cell]setShowsStateBy:NSChangeGrayCellMask|NSContentsCellMask];
   
   [EinschaltTaste setButtonType:NSSwitchButton];
   [[EinschaltTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];
   [EinschaltTaste setBordered:YES];
   [[EinschaltTaste cell]setTitle:@"Addition/Subtraktion einschalten"];
   [[EinschaltTaste cell]setShowsStateBy:NSChangeGrayCellMask|NSContentsCellMask];
   [EinschaltTaste setState:0];
   [EinschaltTaste setAlignment:NSCenterTextAlignment];
   [EinschaltTaste setAlternateTitle:@"Aufgaben mit Addition/Subtraktion"];
   [EinschaltTaste setTarget:self];
   [EinschaltTaste setAction:@selector(EinschaltAktion:)];
   
   
   NSFont* TastenFont=[NSFont fontWithName:@"Helvetica" size: 12];
   
   
   OnImg=[NSImage imageNamed:@"OnImage"];
   [EinschaltTaste setImage:OnImg];
   OffImg=[NSImage imageNamed:@"OffImage"];
   [EinschaltTaste setAlternateImage:OffImg];
   AddSubTastenArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSPoint EckeRechtsOben=SettingsRect.origin;
   
   //EckeRechtsOben.y+=(SettingsRect.size.height-AbstandVonOben);
   EckeRechtsOben.y+=1*(KnopfmassV+AbstandV)+AbstandV;
   
   int Tastenmass,PopMenuMass,TabMass,Textmass;
   int z,k;
   //for z
   
   //EckeRechtsOben.x+=(anzKolonnen+1)*KnopfmassH+2*AbstandH;//Ecke nach rechts verschieben
   anzKolonnen=4;
   anzZeilen=3;
   Tastenmass=138;
   PopMenuMass=140;
   Textmass=130;
   AbstandH=8;
   
   for(z=0;z<anzZeilen;z++)
   {
      TabMass=0;
      for (k=0;k<anzKolonnen;k++)
      {
         NSPoint KnopfEcke=NSMakePoint(EckeRechtsOben.x+TabMass+k*(AbstandH),EckeRechtsOben.y-z*(KnopfmassV+AbstandV));
         NSRect KnopfFrame;
         NSRect FeldFrame;
         KnopfFrame.origin=KnopfEcke;
         KnopfFrame.size=NSMakeSize(Tastenmass,KnopfmassV);
         if((k==0)||(k==2))
         {
            //TabMass+=Tastenmass;
            
            //	TabMass+=Textmass;
         }
         else
         {
            //	TabMass+=PopMenuMass;
         }
         
         
         switch (k)
         {
            case 0:
            {
               TabMass+=Textmass;
               FeldFrame.origin=KnopfEcke;
               FeldFrame.size=NSMakeSize(Tastenmass,KnopfmassV);
               switch (z)
               {
                  case 0:
                  {
                     NSButton* tempTaste=[[NSButton alloc]initWithFrame:FeldFrame];
                     [tempTaste setButtonType:NSPushOnPushOffButton];
                     [tempTaste setState:0];
                     [tempTaste setAlignment:NSCenterTextAlignment];
                     [[tempTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];
                     
                     //				[[tempTaste cell]setBackgroundColor:[NSColor lightGrayColor]];
                     [tempTaste setTitle:@"mit Addition"];
                     [tempTaste setTarget:self];
                     [tempTaste setAction:@selector(mitAdditionAktion:)];
                     [AddSubTastenArray addObject:tempTaste];
                     
                     
                  }break;
                     
                  case 1:
                  {
                     
                     FeldFrame.size.height-=KnopfmassV/5;
                     NSTextField* BereichFeld=[[NSTextField alloc]initWithFrame:FeldFrame];
                     [BereichFeld setStringValue:@"Bereich:"];
                     [BereichFeld setAlignment:NSRightTextAlignment];
                     [BereichFeld setBordered:NO];
                     [BereichFeld setDrawsBackground:NO];
                     [AddSubTastenArray addObject:(NSControl*)BereichFeld];
                  }break;
                     
                  case 2:
                  {
                     FeldFrame.size.height-=KnopfmassV/5;
                     NSTextField* BereichFeld=[[NSTextField alloc]initWithFrame:FeldFrame];
                     [BereichFeld setStringValue:@"Zweite Zahl:"];
                     [BereichFeld setAlignment:NSRightTextAlignment];
                     [BereichFeld setBordered:NO];
                     [BereichFeld setDrawsBackground:NO];
                     [AddSubTastenArray addObject:(NSControl*)BereichFeld];
                  }break;
                     
               }//switch
            }break;
               
            case 1:
            {
               TabMass+=PopMenuMass;
               FeldFrame.origin=KnopfEcke;
               FeldFrame.size=NSMakeSize(Tastenmass,KnopfmassV);
               NSString* item1=@"Eins bis Zehn";
               NSString* item2=@"Eins bis Zwanzig";
               NSString* item3=@"Zehn bis Zwanzig";
               NSString* item4=@"Zweistellig";
               NSString* item5=@"Dreistellig";
               NSArray* ItemArray=[NSArray arrayWithObjects:item1,item2,item3,item4,item5,nil];
               //NSArray* ItemArray=[NSArray arrayWithObjects:item1,item2,item3,item4,nil];
               
               switch (z)
               {
                  case 0:
                  {
                     FeldFrame.origin.x=EinschaltTastenRect.origin.x+EinschaltTastenRect.size.width-Tastenmass;
                     NSButton* tempTaste=[[NSButton alloc]initWithFrame:FeldFrame];
                     [tempTaste setButtonType:NSPushOnPushOffButton];
                     [[tempTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];
                     
                     [tempTaste setState:0];
                     [tempTaste setAlignment:NSCenterTextAlignment];
                     //				[[tempTaste cell]setBackgroundColor:[NSColor lightGrayColor]];
                     [tempTaste setTitle:@"mit Subtraktion"];
                     [tempTaste setTarget:self];
                     [tempTaste setAction:@selector(mitSubtraktionAktion:)];
                     [AddSubTastenArray addObject:tempTaste];
                  }break;
                     
                  case 1:
                  {
                     FeldFrame.size=NSMakeSize(PopMenuMass,KnopfmassV);
                     NSPopUpButton* ZehnBisZwanzigPopMenu=[[NSPopUpButton alloc]initWithFrame:FeldFrame pullsDown:NO];
                     [ZehnBisZwanzigPopMenu setFont:TastenFont];
                     [ZehnBisZwanzigPopMenu addItemsWithTitles:ItemArray];
                     int i=0;
                     for (i=0;i<[ItemArray count];i++)
                     {
                        [[ZehnBisZwanzigPopMenu itemAtIndex:i]setTag:i];
                     }
                     
                     [AddSubTastenArray addObject:ZehnBisZwanzigPopMenu];
                  }break;
                     
                  case 2:
                  {
                     FeldFrame.size=NSMakeSize(PopMenuMass,KnopfmassV);
                     NSPopUpButton* kZweiteZahlPopMenu=[[NSPopUpButton alloc]initWithFrame:FeldFrame pullsDown:NO];
                     [kZweiteZahlPopMenu setFont:TastenFont];
                     [kZweiteZahlPopMenu addItemsWithTitles:ItemArray];
                     [AddSubTastenArray addObject:kZweiteZahlPopMenu];
                  }break;
                     
                     
               }//switch z
            }break;
               
            case 2:
            {
               TabMass+=(Textmass/2);
               FeldFrame.origin=KnopfEcke;
               FeldFrame.size=NSMakeSize(Tastenmass,KnopfmassV);
               switch (z)
               {
                  case 0:
                  {
                  }break;
                     
                  case 1:
                  {
                     FeldFrame.size.height-=KnopfmassV/5;
                     FeldFrame.size.width=Textmass/2;
                     NSTextField* BereichFeld=[[NSTextField alloc]initWithFrame:FeldFrame];
                     [BereichFeld setStringValue:NSLocalizedString(@"ZehnerU",@"Zehnerübergang:")];
                     [BereichFeld setAlignment:NSRightTextAlignment];
                     [BereichFeld setBordered:NO];
                     [BereichFeld setDrawsBackground:NO];
                     [AddSubTastenArray addObject:(NSControl*)BereichFeld];
                  }break;
                     
                  case 2:
                  {
                     FeldFrame.size.height-=KnopfmassV/5;
                     FeldFrame.size.width=Textmass/2;
                     NSTextField* BereichFeld=[[NSTextField alloc]initWithFrame:FeldFrame];
                     [BereichFeld setStringValue:NSLocalizedString(@"HunderterU",@"Hunderterübergang:")];
                     [BereichFeld setAlignment:NSRightTextAlignment];
                     [BereichFeld setBordered:NO];
                     [BereichFeld setDrawsBackground:NO];
                     [AddSubTastenArray addObject:(NSControl*)BereichFeld];
                  }break;
                     
               }//switch
            }break;
               
               
            case 3:
            {
               TabMass+=PopMenuMass;
               FeldFrame.origin=KnopfEcke;
               FeldFrame.size=NSMakeSize(Tastenmass/2,KnopfmassV);
               switch (z)
               {
                  case 0:
                  {
                  }break;
                     
                  case 1:
                  {
                     FeldFrame.size=NSMakeSize(2*Tastenmass/3,KnopfmassV);
                     NSPopUpButton* kZehnerUPopMenu=[[NSPopUpButton alloc]initWithFrame:FeldFrame pullsDown:NO];
                     [kZehnerUPopMenu setFont:TastenFont];
                     
                     NSString* item1=@"nie";
                     NSString* item2=@"immer";
                     NSString* item3=@"offen";
                     
                     NSArray* ItemArray=[NSArray arrayWithObjects:item1,item2,item3,nil];
                     [kZehnerUPopMenu addItemsWithTitles:ItemArray];
                     //[[kZehnerUPopMenu itemWithTitle:@"offen"]setEnabled:NO];
                     [AddSubTastenArray addObject:kZehnerUPopMenu];
                  }break;
                     
                  case 2:
                  {
                     FeldFrame.size=NSMakeSize(2*Tastenmass/3,KnopfmassV);
                     NSPopUpButton* kHunderterUPopMenu=[[NSPopUpButton alloc]initWithFrame:FeldFrame pullsDown:NO];
                     [kHunderterUPopMenu setFont:TastenFont];
                     NSString* item1=@"nie";
                     NSString* item2=@"immer";
                     NSString* item3=@"offen";
                     
                     NSArray* ItemArray=[NSArray arrayWithObjects:item1,item2,item3,nil];
                     [kHunderterUPopMenu addItemsWithTitles:ItemArray];
                     [AddSubTastenArray addObject:kHunderterUPopMenu];
                  }break;
                     
                     
               }//switch z
               
            }
         }//switch k
      }
   }
   
   //NSLog(@"AddSubTastenArray: %@",[AddSubTastenArray description]);
   [EinschaltTaste setState:0];
   [[AddSubTastenArray objectAtIndex:kMitAdditionTaste] setState:0];
   [[AddSubTastenArray objectAtIndex:kMitSubtraktionTaste] setState:0];
   [[AddSubTastenArray objectAtIndex:kBereichPopMenu] selectItemAtIndex:3];
   [[AddSubTastenArray objectAtIndex:kZweiteZahlPopMenu] selectItemAtIndex:0];
   [[AddSubTastenArray objectAtIndex:kZehnerUPopMenu] selectItemAtIndex:1];
   [[AddSubTastenArray objectAtIndex:kHunderterUPopMenu] selectItemAtIndex:0];
   
   return self;
   
   
   
}

- (NSArray*)AddSubTastenArray
{
   return AddSubTastenArray;
}
- (NSButton*)EinschaltTaste
{
   return EinschaltTaste;
}

- (void)setSettingsMit:(NSDictionary*)dieSettings
{
   NSNumber* AddSubNumber=[dieSettings objectForKey:@"addsubein"];
   if (AddSubNumber)
   {
      [EinschaltTaste setState:[AddSubNumber intValue]];
   }//if
   
   NSNumber* AddNumber=[dieSettings objectForKey:@"addition"];
   if (AddNumber)
   {
      [[AddSubTastenArray objectAtIndex:kMitAdditionTaste] setState:[AddNumber intValue]];
   }//if
   
   NSNumber* SubNumber=[dieSettings objectForKey:@"subtraktion"];
   if (SubNumber)
   {
      [[AddSubTastenArray objectAtIndex:kMitSubtraktionTaste] setState:[SubNumber intValue]];
   }//if
   
   NSNumber* BereichNumber=[dieSettings objectForKey:@"bereich"];
   if (SubNumber)
   {
      [[AddSubTastenArray objectAtIndex:kBereichPopMenu] selectItemAtIndex:[BereichNumber intValue]];
   }//if 
   
   NSNumber* ZweiteZahlNumber=[dieSettings objectForKey:@"zweitezahl"];
   if (ZweiteZahlNumber)
   {
      [[AddSubTastenArray objectAtIndex:kZweiteZahlPopMenu] selectItemAtIndex:[ZweiteZahlNumber intValue]];
   }//if 
   
   NSNumber* ZehnerUNumber=[dieSettings objectForKey:@"zehneru"];
   if (ZehnerUNumber)
   {
      [[AddSubTastenArray objectAtIndex:kZehnerUPopMenu] selectItemAtIndex:[ZehnerUNumber intValue]];
   }//if 
   
   NSNumber* HunderterUNumber=[dieSettings objectForKey:@"hunderteru"];
   if (HunderterUNumber)
   {
      [[AddSubTastenArray objectAtIndex:kHunderterUPopMenu] selectItemAtIndex:[HunderterUNumber intValue]];
   }//if 
   
   
   
}

- (NSDictionary*)getSettings
{
   NSMutableDictionary* SettingsDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   [SettingsDic setObject:[NSNumber numberWithInt:[EinschaltTaste state]] forKey:@"addsubein"];
   
   [SettingsDic setObject:[NSNumber numberWithInt:[[AddSubTastenArray objectAtIndex:kMitAdditionTaste] state]] 
                   forKey:@"addition"];
   
   [SettingsDic setObject:[NSNumber numberWithInt:[[AddSubTastenArray objectAtIndex:kMitSubtraktionTaste] state]]
                   forKey:@"subtraktion"];
   int index;
   
   index=[(NSPopUpButton*)[AddSubTastenArray objectAtIndex:kBereichPopMenu] indexOfSelectedItem];
   //NSLog(@"kBereichPopMenu index: %d",index);				
   [SettingsDic setObject:[NSNumber numberWithInt:index] forKey:@"bereich"];
   
   index=[(NSPopUpButton*)[AddSubTastenArray objectAtIndex:kZweiteZahlPopMenu] indexOfSelectedItem];
   //NSLog(@"						zweitezahl:		kBereichPopMenu index: %d",index);				
   [SettingsDic setObject:[NSNumber numberWithInt:index] forKey:@"zweitezahl"];
   
   index=[(NSPopUpButton*)[AddSubTastenArray objectAtIndex:kZehnerUPopMenu] indexOfSelectedItem];
   //NSLog(@"kZehnerUPopMenu index: %d",index);				
   [SettingsDic setObject:[NSNumber numberWithInt:index] forKey:@"zehneru"];
   
   index=[(NSPopUpButton*)[AddSubTastenArray objectAtIndex:kHunderterUPopMenu] indexOfSelectedItem];
   //NSLog(@"kHunderterUPopMenu index: %d",index);				
   [SettingsDic setObject:[NSNumber numberWithInt:index] forKey:@"hunderteru"];
   
   return SettingsDic;
}

- (void)clearSettings
{
   //NSLog(@"clearSettings");
   [EinschaltTaste setState:0];
   [[AddSubTastenArray objectAtIndex:kMitAdditionTaste] setState:0];
   [[AddSubTastenArray objectAtIndex:kMitSubtraktionTaste] setState:0];
   [[AddSubTastenArray objectAtIndex:kBereichPopMenu] selectItemAtIndex:3];
   [[AddSubTastenArray objectAtIndex:kZweiteZahlPopMenu] selectItemAtIndex:0];
   [[AddSubTastenArray objectAtIndex:kZehnerUPopMenu] selectItemAtIndex:1];
   [[AddSubTastenArray objectAtIndex:kHunderterUPopMenu] selectItemAtIndex:0];
   
   
}

- (void)AddSubSettingsAktion:(id)sender
{
   
}


- (void)mitAdditionAktion:(id)sender
{
   //NSLog(@"mitAdditionAktion");
   switch ([sender state])
   {
      case 0:
      {
         [EinschaltTaste setState:1];
      }break;
         
      case 1:
      {
         
      }break;
      default:
         break;
   }//switch
   
   
   //[EinschaltTaste setState:[sender state]];
}


- (void)mitSubtraktionAktion:(id)sender
{
   //NSLog(@"mitSubtraktionAktion");
   
}

- (void)EinschaltAktion:(id)sender
{
   //NSLog(@"AS EinschaltAktion");
   //[EinschaltTaste setBordered:[sender state]];
   
}

- (int)checkSettings
{
   int checkSum=0;
   if ([EinschaltTaste state])
   {
      checkSum++;
      if ([[AddSubTastenArray objectAtIndex:kMitAdditionTaste] state])
      {
         checkSum++;
      }
      if ([[AddSubTastenArray objectAtIndex:kMitSubtraktionTaste] state])
      {
         checkSum++;
      }
      
   }
   //NSLog(@"AddSub checkSettings: checkSum: %d",checkSum);
   return checkSum;
   
}

@end
