//
//  ReihenSettings.m
//  SndCalcII
//
//  Created by Sysadmin on 16.10.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "rReihenSettings.h"
enum 
{kKleines1Mal1Taste,

kZehnerReihenTaste,
kGrosses1Mal1Taste,
kHunderterReihenTaste};

@implementation rReihenSettings
- (void)DebugStep:(NSString*)dieWarnung
{
					NSAlert *Warnung = [[NSAlert alloc] init];
					[Warnung addButtonWithTitle:@"OK"];
					[Warnung setMessageText:dieWarnung];
					int antwort=[Warnung runModal];
}

- (id)initWithFrame:(NSRect)frame
{
NSLog(@"rReihenSettings initWithFrame");
self=[super initWithFrame:frame];
//[self DebugStep:@"initReihenSettings nach super"];
NSNotificationCenter * nc;
nc=[NSNotificationCenter defaultCenter];
[nc addObserver:self
	   selector:@selector(ReihenSettingsAktion:)
		   name:@"reihensettings"
		 object:nil];

//[self DebugStep:@"initReihenSettings nach nc"];
NSButtonCell* ReihenTaste=[[NSButtonCell alloc]init];
[ReihenTaste setButtonType:NSPushOnPushOffButton];

//[self DebugStep:@"initReihenSettings nach setButtonType"];
//[ReihenTaste setButtonType:NSToggleButton];


//[ReihenTaste  setBackgroundColor:[NSColor greenColor]];
//[ReihenTaste setShowsStateBy:NSPushInCellMask|NSChangeBackgroundCellMask];

NSRect SettingsRect=frame;

//[[NSColor redColor]set];
//[NSBezierPath fillRect:SettingsRect];




//NSLog(@"tabView frame: origin: %f %f size: %f %f ",SettingsRect.origin.x,SettingsRect.origin.y,SettingsRect.size.height,SettingsRect.size.width);
//[self DebugStep:@"initReihenSettings nach fillrect"];

int AbstandVonOben=115;
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

//[self DebugStep:@"initReihenSettings nach init Einschalt"];
//[EinschaltTaste setButtonType:NSPushOnPushOffButton];
[EinschaltTaste setButtonType:NSSwitchButton];
[[EinschaltTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];
[EinschaltTaste setBordered:YES];
[[EinschaltTaste cell]setTitle:@"Reihen einschalten"];
[[EinschaltTaste cell]setShowsStateBy:NSChangeGrayCellMask|NSContentsCellMask];
[EinschaltTaste setState:0];
[EinschaltTaste setAlignment:NSCenterTextAlignment];
[EinschaltTaste setAlternateTitle:@"Aufgaben mit Reihen"];
[EinschaltTaste setTarget:self];
[EinschaltTaste setAction:@selector(EinschaltAktion:)]; 

//[self DebugStep:@"initReihenSettings nach Einschalt setAction"];

ReihenKnopfArray=[[NSMutableArray alloc]initWithCapacity:0];

//[self DebugStep:@"initReihenSettings nach ReihenknopfArray init"];


ReihenTastenArray=[[NSMutableArray alloc]initWithCapacity:0];
NSPoint EckeRechtsOben=SettingsRect.origin;
NSFont*TastenFont;
TastenFont=[NSFont fontWithName:@"Helvetica" size: 12];

//EckeRechtsOben.y+=(SettingsRect.size.height-AbstandVonOben);
EckeRechtsOben.y+=1*(KnopfmassV+AbstandV)+AbstandV;
//EckeRechtsOben.y+=1*(KnopfmassH+AbstandV)+AbstandV;
int Tastenmass;
	int z,k;
	
//[self DebugStep:@"initReihenSettings vor for z anzkolonnen"];


	for(z=0;z<anzZeilen;z++)
	{
		for (k=0;k<anzKolonnen;k++)
		{
			NSPoint KnopfEcke=NSMakePoint(EckeRechtsOben.x+k*(KnopfmassH+AbstandH),EckeRechtsOben.y-z*(KnopfmassV+AbstandV));
			NSRect KnopfFrame;
			KnopfFrame.origin=KnopfEcke;
			KnopfFrame.size=NSMakeSize(KnopfmassH,KnopfmassV);

			if ((k<10)&&(z*10+k<25))
			{
				NSButton* tempKnopf=[[NSButton alloc]initWithFrame:KnopfFrame];
				
				[tempKnopf setButtonType:NSPushOnPushOffButton];

	//			[tempKnopf setButtonType:NSPushOnPushOffButton];
				[[tempKnopf cell] setFont: TastenFont];

				[tempKnopf setState:0];
				[[tempKnopf cell] setShowsStateBy:NSChangeGrayCell|NSPushInCellMask];
				[[tempKnopf cell]setBezelStyle:NSShadowlessSquareBezelStyle];
				[tempKnopf setAlignment:NSCenterTextAlignment];
//				[[tempKnopf cell]setBackgroundColor:[NSColor lightGrayColor]];
				//[[tempKnopf cell]setBezelStyle:NSRegularSquareBezelStyle];
				//[[tempKnopf cell]setGradientType:NSGradientConvexWeak];
				//[[tempKnopf cell]setBezelStyle:NSRoundedBezelStyle];
				[tempKnopf setTag:z*10+k+1];
				[tempKnopf setTitle:[[NSNumber numberWithInt:z*10+k+1]stringValue]];
				[tempKnopf setTarget:self];
				[tempKnopf setAction:@selector(KnopfAktion:)];
				
				[ReihenKnopfArray addObject:tempKnopf];
				
			}
			
			if ((10*z+k)==25)//Löschtaste
			{
				KnopfFrame.size.width+=4*(KnopfmassH+AbstandH);
				ClearTaste=[[NSButton alloc]initWithFrame:KnopfFrame];
				[ClearTaste setButtonType:NSMomentaryPushButton];
				[ClearTaste setState:0];
				[ClearTaste setAlignment:NSCenterTextAlignment];
				[[ClearTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];

//				[[ClearTaste cell]setBackgroundColor:[NSColor grayColor]];
				[ClearTaste setTitle:@"Alle ausschalten"];
				[ClearTaste setTarget:self];
				[ClearTaste setAction:@selector(ClearAktion:)];
			}
		}//for k
	}//for z
	
	

	EckeRechtsOben.x+=(anzKolonnen+1)*KnopfmassH+2*AbstandH;//Ecke nach rechts verschieben
	anzKolonnen=2;
	anzZeilen=2;
	Tastenmass=95;
	AbstandH=8;
	
	
//[self DebugStep:@"initReihenSettings vor for z anzZeilen "];


	for(z=0;z<anzZeilen;z++)
	{
		for (k=0;k<anzKolonnen;k++)
		{
			NSString* zs=[@"Zeile: " stringByAppendingString:[[NSNumber numberWithInt:z]stringValue]];
			NSString* ks=[@"Kolonne: " stringByAppendingString:[[NSNumber numberWithInt:k]stringValue]];
			NSString* kontrollstring=[zs stringByAppendingString:ks];
			
//			[self DebugStep:kontrollstring];
			
			
			NSPoint KnopfEcke=NSMakePoint(EckeRechtsOben.x+k*(Tastenmass+AbstandH),EckeRechtsOben.y-z*(KnopfmassV+AbstandV));
			NSRect KnopfFrame;
			KnopfFrame.origin=KnopfEcke;
			KnopfFrame.size=NSMakeSize(Tastenmass,KnopfmassH);
			if (k==0)
			{
				NSRect TastenFrame;
				TastenFrame.origin=KnopfEcke;
				TastenFrame.size=NSMakeSize(Tastenmass,KnopfmassV);
				NSButton* tempTaste=[[NSButton alloc]initWithFrame:TastenFrame];
				[tempTaste setButtonType:NSPushOnPushOffButton];
				[[tempTaste cell] setShowsStateBy:NSChangeGrayCell|NSPushInCellMask];
				[tempTaste setState:0];
				[tempTaste setAlignment:NSCenterTextAlignment];
				//				[[tempTaste cell]setBackgroundColor:[NSColor lightGrayColor]];
				[[tempTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];
				//				[[tempTaste cell]showsStateBy] != NSNoCellMask;
				switch (z)
				{
					case 0:
					{
						[tempTaste setTitle:@"Kleines 1*1"];
						[tempTaste setTarget:self];
						[tempTaste setAction:@selector(Kleines1Mal1Aktion:)];
						Kleines1Mal1Taste=tempTaste;
						[ReihenTastenArray addObject:tempTaste];
					}break;
						
					case 1:
					{
						[tempTaste setTitle:@"Grosses 1*1"];
						[tempTaste setTarget:self];
						[tempTaste setAction:@selector(Grosses1Mal1Aktion:)];
						Grosses1Mal1Taste=tempTaste;
						[ReihenTastenArray addObject:tempTaste];
					}break;
				}//switch
			}
			if (k==1)
			{	
//				[self DebugStep:@"k=1"];
				NSRect TastenFrame;
				//[self DebugStep:@"k=11"];
				TastenFrame.origin=KnopfEcke;
				//[self DebugStep:@"k=12"];
				TastenFrame.size=NSMakeSize(Tastenmass+10,KnopfmassV);
				//[self DebugStep:@"k=13"];
				NSButton* tempTaste=[[NSButton alloc]initWithFrame:TastenFrame];
			//	[self DebugStep:@"k=14"];
				[tempTaste setButtonType:NSPushOnPushOffButton];
			//	[self DebugStep:@"k=15"];
				[[tempTaste cell] setShowsStateBy:NSChangeGrayCell|NSPushInCellMask];
			//	[self DebugStep:@"k=16"];
				[tempTaste setState:0];
			//	[self DebugStep:@"k=17"];
				[tempTaste setAlignment:NSCenterTextAlignment];
			//	[self DebugStep:@"k=18"];
				[[tempTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];
	//			[self DebugStep:@"k=19"];
	//			[[tempTaste cell]setBackgroundColor:[NSColor grayColor]];
	//			[self DebugStep:@"vor switch z"];
				switch (z)
				{
					case 0:
					{	
					//	[self DebugStep:@"k=1 z=0"];
						[tempTaste setTitle:@"Zehnerreihen"];
						[tempTaste setHidden:YES];
						ZehnerReihenTaste=tempTaste;
						[ReihenTastenArray addObject:tempTaste];
					//	[self DebugStep:@"z=0 end"];
					}break;
						
					case 1:
					{
					//	[self DebugStep:@"k=1 z=1"];
						[tempTaste setTitle:@"Hunderterreihen"];
						[tempTaste setHidden:YES];
						HunderterReihenTaste=tempTaste;
						[ReihenTastenArray addObject:tempTaste];
					//	[self DebugStep:@"z=1 end"];
					}break;
				}//switch
			}
			
		}
	}
	

//NSLog(@"ReihenTastenArray: %@",[ReihenTastenArray description]);

//[self DebugStep:@"initReihenSettings end "];


return self;



}


- (void)clearSettings
{
//NSLog(@"ClearAktion");
[[ReihenTastenArray objectAtIndex:kKleines1Mal1Taste]setState:0];
[[ReihenTastenArray objectAtIndex:kGrosses1Mal1Taste]setState:0];
[EinschaltTaste setState:0];
SettingChanged=0;
NSEnumerator* E=[ReihenKnopfArray objectEnumerator];
id einKnopf;
while (einKnopf=[E nextObject])
{
[einKnopf setState:0];
}//while

}


- (IBAction)ClearAktion:(id)sender
{
//NSLog(@"ClearAktion");
[[ReihenTastenArray objectAtIndex:kKleines1Mal1Taste]setState:0];
[[ReihenTastenArray objectAtIndex:kGrosses1Mal1Taste]setState:0];
SettingChanged=0;
NSEnumerator* E=[ReihenKnopfArray objectEnumerator];
id einKnopf;
while (einKnopf=[E nextObject])
{
[einKnopf setState:0];
}//while

}

- (IBAction)Kleines1Mal1Aktion:(id)sender
{
	//NSLog(@"Kleines1Mal1Aktion: state: %d",[sender state]);
	NSEnumerator* E=[ReihenKnopfArray objectEnumerator];
	id einKnopf;
	if ([sender state]==1)
	{
	[[ReihenTastenArray objectAtIndex:kGrosses1Mal1Taste]setState:0];
	}
	while (einKnopf=[E nextObject])
	{
		if (([sender state]==1)&&([einKnopf tag]>1 &&[einKnopf tag]<10))
		{
			[einKnopf setState:1];
			[EinschaltTaste setState:1];
		}
		else
		{
			[einKnopf setState:0];
		}
		
	}//while
	if (SettingChanged==NO)//erste Aenderung, melden an TestPanel
{
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"changedtaste"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"SettingChanged" object:self userInfo:NotificationDic];

	SettingChanged=YES;
}

	
}

- (IBAction)Grosses1Mal1Aktion:(id)sender
{
	NSLog(@"Grosses1Mal1Aktion: state: %d",[sender state]);
	NSEnumerator* E=[ReihenKnopfArray objectEnumerator];
	id einKnopf;
	while (einKnopf=[E nextObject])
	{
		if (([sender state]==1)&&([einKnopf tag]>11 &&[einKnopf tag]<20))
		{
			[einKnopf setState:1];
			[[ReihenTastenArray objectAtIndex:kKleines1Mal1Taste]setState:0];
			[EinschaltTaste setState:1];
		}
		else
		{
			[einKnopf setState:0];
		}
		
	}//while
	if (SettingChanged==NO)//erste Aenderung, melden an TestPanel
{
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"changedtaste"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"SettingChanged" object:self userInfo:NotificationDic];

	SettingChanged=YES;
}

}




- (void)ReihenSettingsAktion:(NSNotification*)note
{
	NSLog(@"ReihenSettingsAktion");
	
	if ([[note userInfo]objectForKey:@"einschalttaste"])
	{
		int einschalten=[[[note userInfo]objectForKey:@"einschalttaste"]intValue];
		[EinschaltTaste setState:einschalten];
	}
	
	if ([[note userInfo]objectForKey:@"cleartaste"])
	{
		int einschalten=[[[note userInfo]objectForKey:@"einschalttaste"]intValue];
		[ClearTaste setState:einschalten];
	}
	
	if ([[note userInfo]objectForKey:@"einschalttaste"])
	{
		int einschalten=[[[note userInfo]objectForKey:@"einschalttaste"]intValue];
		[EinschaltTaste setState:einschalten];
	}
	
	

}

- (void)setSettingsMit:(NSDictionary*)dieSettings
{
	SettingChanged=NO;
	//NSLog(@"setSettingsMit: %@",[dieSettings description]);
	NSNumber* MultNumber=[dieSettings objectForKey:@"multiplikation"];
	if (MultNumber)
	{
		[EinschaltTaste setState:[MultNumber intValue]];
	}//if 
	
	NSNumber* Kleines1Mal1Number=[dieSettings objectForKey:@"kleines1mal1"];
	if (Kleines1Mal1Number)
	{
		[Kleines1Mal1Taste setState:[Kleines1Mal1Number intValue]];
	}//if 
	
	NSNumber* Grosses1Mal1Number=[dieSettings objectForKey:@"grosses1mal1"];
	if (Grosses1Mal1Number)
	{
		[Grosses1Mal1Taste setState:[Grosses1Mal1Number intValue]];
	}//if 
	
	NSNumber* ZehnerReihenNumber=[dieSettings objectForKey:@"zehnerreihen"];
	if (ZehnerReihenNumber)
	{
		[ZehnerReihenTaste setState:[ZehnerReihenNumber intValue]];
	}//if 
	
	NSNumber* HunderterReihenNumber=[dieSettings objectForKey:@"hunderterreihen"];
	if (HunderterReihenNumber)
	{
		[HunderterReihenTaste setState:[HunderterReihenNumber intValue]];
	}//if 
	
	NSArray* ReihenDicArray=[dieSettings objectForKey:@"reihenarray"];
	if (ReihenDicArray&&[ReihenDicArray count])//Es gibt Reihen
	{
		NSEnumerator* KnopfEnum=[ReihenKnopfArray objectEnumerator];
		id einKnopf;
		while (einKnopf=[KnopfEnum nextObject])
		{
			if ([ReihenDicArray containsObject:[NSNumber numberWithInt:[einKnopf tag]]])
			{
				[einKnopf setState:YES];
			}
			else
			{
				[einKnopf setState:NO];
			}
		}
	}//while
	
}


- (NSDictionary*)getSettings
{
	
	NSMutableDictionary* SettingsDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[SettingsDic setObject:[NSNumber numberWithInt:[EinschaltTaste state]] forKey:@"reihenein"];
	
	[SettingsDic setObject:[NSNumber numberWithInt:[EinschaltTaste state]] forKey:@"multiplikation"];
	[SettingsDic setObject:[NSNumber numberWithInt:[[ReihenTastenArray objectAtIndex:kZehnerReihenTaste] state]] 
											forKey:@"zehnerreihen"];
	[SettingsDic setObject:[NSNumber numberWithInt:[[ReihenTastenArray objectAtIndex:kHunderterReihenTaste] state]]
					forKey:@"hunderterreihen"];
	[SettingsDic setObject:[NSNumber numberWithInt:[[ReihenTastenArray objectAtIndex:kKleines1Mal1Taste] state]]
					forKey:@"kleines1mal1"];
	[SettingsDic setObject:[NSNumber numberWithInt:[[ReihenTastenArray objectAtIndex:kGrosses1Mal1Taste] state]]
					forKey:@"grosses1mal1"];
	
	
	NSMutableArray* ReihenArray=[[NSMutableArray alloc]initWithCapacity:0];
	
	NSEnumerator* ReihenEnum=[ReihenKnopfArray objectEnumerator];
	id einKnopf;
	while (einKnopf=[ReihenEnum nextObject])
	{
	if ([einKnopf state]==1)//Reihe gesetzt
	{
		[ReihenArray addObject:[NSNumber numberWithInt:[einKnopf tag]]];
	}
	}//while
	
	[SettingsDic setObject:ReihenArray forKey:@"reihenarray"];
	[SettingsDic setObject:[NSNumber numberWithInt:[ReihenArray count]]
				forKey:@"anzahlreihen"];

	//NSLog(@"SettingsDic: %@",[SettingsDic description]);
	return SettingsDic;
}

- (int)AnzahlReihen
{
int anz=0;
	NSEnumerator* ReihenEnum=[ReihenKnopfArray objectEnumerator];
	id einKnopf;
	while (einKnopf=[ReihenEnum nextObject])
	{
	if ([einKnopf state]==1)//Reihe gesetzt
	{
		anz++;
	}
	}//while

return anz;
}

- (NSView*)TastenArray
{
return TastenArray;
}
- (NSArray*)ReihenKnopfArray
{
return ReihenKnopfArray;
}

- (NSArray*)ReihenTastenArray
{
return ReihenTastenArray;
}
- (NSButton*)EinschaltTaste
{
return EinschaltTaste;
}

- (NSButton*)ClearTaste
{
return ClearTaste;
}

- (void)EinschaltAktion:(id)sender
{
//NSLog(@"MD EinschaltAktion");
//[EinschaltTaste setBordered:[sender state]];

}

- (IBAction)KnopfAktion:(id)sender
{
NSLog(@"MD KnopfAktion: tag:%d" ,[sender tag]);
//[EinschaltTaste setBordered:[sender state]];
	[EinschaltTaste setState:[self AnzahlReihen]];
if (SettingChanged==NO)//erste Aenderung, melden an TestPanel
{
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"changedtaste"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"SettingChanged" object:self userInfo:NotificationDic];

	SettingChanged=YES;
}
}


- (int)checkSettings
{
	int checkSum=0;
	if ([EinschaltTaste state])
	{
		checkSum++;
		NSEnumerator* KnopfEnum=[ReihenKnopfArray objectEnumerator];
		id einKnopf;
		while (einKnopf=[KnopfEnum nextObject])
		{
		checkSum+=[einKnopf state];
		 }//while 
		
	}
	//NSLog(@"Reihen checkSettings: checkSum: %d",checkSum);
	return checkSum;
}

@end
