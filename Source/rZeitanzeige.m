#import "rZeitanzeige.h"

@implementation rZeitanzeige

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) 
	{
		NSRect BalkenRect=[self frame];
		//BalkenRect.size.height-=2;
		Rahmenbreite=BalkenRect.size.width-1;
		Rahmenhoehe=BalkenRect.size.height-2;
		Feldbreite=0;
		Feldhoehe=Rahmenhoehe;
		Level=0;
		Max=120;
	}
	return self;
}



- (void)drawRect:(NSRect)rect
{
	
	[self drawLevelmeter];
	
}
- (void)setZeit:(int) dieZeit
{
	if (dieZeit>Max)
		dieZeit=Max;
	else
		Level=dieZeit;
	//NSLog(@"Level ein: %d Level aus: %d",derLevel,Level);
	[self display];
}

- (void)setZehntelZeit:(int) dieZeit
{
	if (dieZeit/10.0>Max)
		dieZeit=Max;
	else
		Level=dieZeit/10.0;
	//NSLog(@"Level ein: %d Level aus: %d",derLevel,Level);
	[self display];
}

- (void)drawLevelmeter
{
	[self lockFocus];
	
	Feldbreite= Rahmenbreite/Max*Level;
	NSRect f;
	NSPoint Nullpunkt=NSMakePoint(1,2);
	f=NSMakeRect(Nullpunkt.x+1,Nullpunkt.y,Feldbreite,Feldhoehe-2);
	[[NSColor blackColor]set];
	//[NSBezierPath strokeRect:f];
	//[[NSColor greenColor] set];
	NSColor* BalkenFarbe=[NSColor colorWithDeviceRed:90.0/255 green:255.0/255 blue:130.0/255 alpha:1.0];
	//BalkenFarbe=[NSColor cyanColor];
	[BalkenFarbe set];
	[NSBezierPath fillRect:f];
	f=NSMakeRect(Feldbreite+1,Nullpunkt.y,Rahmenbreite-1,Feldhoehe-2);
	[[NSColor blackColor]set];
	//[NSBezierPath strokeRect:f];
	[[NSColor whiteColor] set];
	[NSBezierPath fillRect:f];
	NSRect BalkenRect=[self bounds];
	BalkenRect.size.height-=1;
	BalkenRect.size.width-=1;
	[[NSColor grayColor]set];	

	[NSBezierPath strokeRect:BalkenRect];
	
	[self unlockFocus];
	
}
- (void)setMax:(int)dasMax
{
	Max=dasMax;
	[self display];
}

@end
