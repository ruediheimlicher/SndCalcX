//
//  rRahmen.m
//  SndCalcII
//
//  Created by Sysadmin on 05.11.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "rRahmen.h"


@implementation rRahmen
- (id)initWithFrame:(NSRect)frame
{
self=[super initWithFrame:frame];
//NSLog(@"rRahmen initWithFrame");
//NSLog(@"rRahmen: \nx: %d y: %d\nb: %d h: %d",frame.origin.x,frame.origin.y,frame.size.width, frame.size.height);
mark=-1;


return self;
}
- (void)setMark:(int)dieMarke
{
mark=dieMarke;
}

- (void)drawRect:(NSRect) rect
{
	//NSLog(@"rRahmen drawRect: mark:%d",mark);
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
		switch (mark)
	{
	case 0://clear
	{
	//NSLog(@"clear");
	[super drawRect:rect];
	[[NSColor blackColor]set];
	mark=-1;
	//
	}break;
	case 1://richtig
	{
	[super drawRect:rect];
	[RahmenPath setLineWidth:4];

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
	[KreuzPath setLineWidth:3];
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

@end
