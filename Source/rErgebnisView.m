//
//  rErgebnisfeld.m
//  SndCalcII
//
//  Created by Sysadmin on 03.11.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "rErgebnisView.h"



@implementation rErgebnisView
- (id)initWithFrame:(NSRect)frame
{
self=[super initWithFrame:frame];
//NSLog(@"rErgebnisView initWithFrame");
//NSLog(@"Rahmen: \nx: %d y: %d\nb: %d h: %d",frame.origin.x,frame.origin.y,frame.size.width, frame.size.height);
mark=-1;
ready =NO;
//anzFalschesZeichen=0;
DezimalZahlen=[NSCharacterSet decimalDigitCharacterSet];

return self;
}

- (void)awakeFromNib
{
//NSLog(@"rErgebnisView awakeFromNib");
//NSLog(@"rErgebnisView initWithFrame");
NSRect Rahmen=[self frame];
//NSLog(@"Rahmen: \nx: %d y: %d\nb: %d h: %d",Rahmen.origin.x,Rahmen.origin.y,Rahmen.size.width, Rahmen.size.height);

//[self setDelegate:self];

}

- (void)setErgebnisView
{
//NSLog(@"setErgebnisView");
NSRect Rahmen=[self bounds];
//NSLog(@"setErgebnisView: Rahmen: \nx: %d y: %d\nb: %d h: %d",Rahmen.origin.x,Rahmen.origin.y,Rahmen.size.width, Rahmen.size.height);
//[self setFieldEditor:YES];
//[self setBackgroundColor:[NSColor greenColor]];
[self setTextColor:[NSColor blackColor]];
[self setAlignment:NSCenterTextAlignment];
//[self addToolTip:@"Ergebnis"];
NSFont* ErgebnisFont=[NSFont fontWithName:@"Helvetica" size: 28];
[self setEditable:NO];
[self setSelectable:NO];
[self setString:@""];
[self setFont:ErgebnisFont];
//[self setTag:1];
//NSLog(@"setErgebnisView Ende");
}


- (void)FalschesZeichenFunktion:(NSTimer*)derTimer
{
	//NSLog(@"FalschesZeichenFunktion : info: %@",[derTimer userInfo]);
	[falschesZeichenTimer invalidate];
//	[NSApp stopModalWithCode:0];
	[NSApp abortModal];
	
}

- (void)keyDown:(NSEvent *)theEvent
{
	NSString* c=[theEvent characters];
		NSLog(@"keyDown: c: %@  code: %d modifier: %d anz: %d",c,[theEvent keyCode],[theEvent modifierFlags],[[self string]length]);
	if(([theEvent keyCode]==24)||([theEvent keyCode]==30))//Tasten ^ oder ¬ ohne space
	{
		return;
		NSLog(@"c ist ungŸltig l: ");
		
	}
	
	if ([[self string]length]>3)// mehr als 4 Zeichen
	{
		NSLog(@"keyDown:length>3");
		if (ready)
		{
			ready=NO;
			NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[NotificationDic setObject:[NSNumber numberWithInt:36] forKey:@"key"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"ErgebnisFertig" object:self userInfo:NotificationDic];
			
		}
		
		[self setEditable:NO];
		[self setSelectable:NO];
		return;
	}

	
//	if (([theEvent keyCode]==36)||([theEvent keyCode]==76) || [[self string]length]>3)//enter oder mehr als 4 Zeichen


	
	if (([theEvent keyCode]==36)||([theEvent keyCode]==76) )//enter 
	{
		if ([[self string]length])
		{
			[self setEditable:NO];
			[self setSelectable:NO];
			
			NSLog(@"\nkeyDown:EnterKey");
			if (ready)
			{
				ready=NO;
				NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				[NotificationDic setObject:[NSNumber numberWithInt:36] forKey:@"key"];
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				[nc postNotificationName:@"ErgebnisFertig" object:self userInfo:NotificationDic];
				
			}
			
		}

	}
	
	else
	{
		if (([theEvent keyCode]==51)||([c length]&&[DezimalZahlen characterIsMember:[c characterAtIndex:0]]))//Delete
		{
			NSLog(@"keyDown: Ziffer: %@",[theEvent characters]);
			[super keyDown:theEvent];
			
		}
		else
		{
			NSLog(@"keyDown:  falsches Zeichen: %@",[theEvent characters]);
			NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[NotificationDic setObject:[theEvent characters] forKey:@"falscheszeichen"];
			[nc postNotificationName:@"FalschesZeichen" object:self userInfo:NotificationDic];
			NSSound* FalschesZeichenSnd=[NSSound soundNamed:@"FalschesZeichen"];
			if (FalschesZeichenSnd)
			{
				[FalschesZeichenSnd play];
				
			}
			NSString* falschesZeichen;
			
			if ([c length])
			{
				falschesZeichen=[theEvent characters];
			}
			else
			{
				falschesZeichen=@"Falsche Taste!";
			}
			
			
			anzFalschesZeichen++;
			NSString* InfText=@"Es sind nur die Ziffern von 0 bis 9 erlaubt";
			int delay=2.0;
			switch (anzFalschesZeichen)
			{
				case 1:
				case 2:
				{
					InfText=[InfText stringByAppendingString:[NSString stringWithFormat:@"\nBisher hast du dich %d mal vertippt",anzFalschesZeichen]];
				}break;
				case 3:
				{
					NSString* s1=@"\nDu hast dich zu oft vertippt.";
					NSString* s2=@"\n\nVon jetzt an werden dir jedesmal 10 s abgezogen!";
					InfText=[InfText stringByAppendingString:[NSString stringWithFormat:@"%@ %@",s1,s2]];
					NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
					[nc postNotificationName:@"Vertipper" object:self userInfo:NULL];
					delay=5.0;
				}break;
				default:
				{
					NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
					[nc postNotificationName:@"Vertipper" object:self userInfo:NULL];
					delay=0.1;
				}
			}//switch
			
			
			falschesZeichenTimer=[NSTimer scheduledTimerWithTimeInterval:delay 
																   target:self 
																 selector:@selector(FalschesZeichenFunktion:) 
																 userInfo:nil 
																  repeats:NO];
			
			if (anzFalschesZeichen<=3)
			{
				NSAlert * FalschesZeichenAlert=[NSAlert alertWithMessageText:@"Falsches Zeichen!" 
															   defaultButton:NULL 
															 alternateButton:NULL 
																 otherButton:NULL 
												   informativeTextWithFormat:@"Zeichen: %@\n%@",falschesZeichen,InfText];
				
				
				[[NSRunLoop currentRunLoop] addTimer: falschesZeichenTimer forMode:NSModalPanelRunLoopMode];
				
				[FalschesZeichenAlert runModal];
			}
			//NSLog(@"Falsches Zeichen");
		}
		
	}
	
	
	
}

- (void)setMark:(int)dieMarke
{
mark=dieMarke;
}

- (void)setReady:(BOOL)derStatus;
{
ready=derStatus;
}

- (void)resetFalschesZeichen
{
	anzFalschesZeichen=0;
}

- (void)drawRect:(NSRect) rect
{

	//NSLog(@"drawRect: mark:%d",mark);
	[super drawRect:rect];
	//return;
	//[[NSColor whiteColor]set];
	NSRect RahmenRect=rect;
	NSPoint a=RahmenRect.origin;
	RahmenRect.origin.x+=1;
	RahmenRect.origin.y+=1;
	RahmenRect.size.width-=2;
	RahmenRect.size.height-=2;
	NSBezierPath* RahmenPath;
	RahmenPath=[NSBezierPath bezierPathWithRect:RahmenRect];
	[[NSColor grayColor]set];
	[RahmenPath stroke];
	return;
	switch (mark)
	{
	case 0://clear
	{
	[self setString:@""];
	NSLog(@"clear");
	[super drawRect:rect];

	
	[[NSColor grayColor]set];
	
	[RahmenPath stroke];
	[[NSColor blackColor]set];
	mark=-1;
	//
	}break;
	case 1://richtig
	{
	[super drawRect:rect];

	[[NSColor greenColor]set];
	[RahmenPath stroke];


	}break;
	case 2://falsch
	{
	[super drawRect:rect];

	NSPoint obenlinks=RahmenRect.origin;
	obenlinks.y+=RahmenRect.size.height-1;
	obenlinks.x+=1;
	NSPoint untenrechts=a;
	untenrechts.x+=RahmenRect.size.width-1;
	untenrechts.y+=1;
	NSPoint untenlinks=a;
	NSPoint obenrechts=a;
	obenrechts.x+=RahmenRect.size.width;
	obenrechts.y+=RahmenRect.size.height;
	NSBezierPath* KreuzPath=[NSBezierPath bezierPath];
	[[NSColor redColor]set];
	[KreuzPath moveToPoint:obenlinks];
	[KreuzPath lineToPoint:untenrechts];
	//
	[KreuzPath moveToPoint:untenlinks];
	[KreuzPath lineToPoint:obenrechts];
	
	[KreuzPath stroke];

	}break;
	default:
	{
	[super drawRect:rect];
	}
	}//switch
	

}

- (void)ErgebnisFeldAktion:(id)sender
{
NSLog(@"rErgebnisView  ErgebnisFeldAktion");
//[OKTaste performClick:NULL];


[self setSelectable:NO];
[self setEditable:NO];
[self display];

}

- (void)textDidChange:(NSNotification *)aNotification

{
//- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
//NSLog(@"ErgebnisView: textDidChange");

}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
NSLog(@"ErgebnisView: controlTextDidEndEditingd");
[self setSelectable:NO];
[self setEditable:NO];
[self display];


}

@end
