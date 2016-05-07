#import "rAufgabenzeiger.h"

@implementation rAufgabenzeiger

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) 
	{
		AnzFelder=24;
		AnzAufgaben=24;
		Grenze =AnzAufgaben;
		NSRect BalkenRect=[self frame];
		
		int Breite=BalkenRect.size.width;
		Feldbreite=Breite/AnzFelder;
		
		max=0;
		Abstand=3;
		Feldhoehe=Feldbreite-Abstand-1;
		Rahmen.origin=NSMakePoint(0,0);;
		Rahmen.size.height=Feldbreite+Abstand-1;
		Rahmen.size.width=AnzFelder*(Feldbreite)+Abstand;
		//NSLog(@"init AufgabenZeiger: Rahmen: \nx: %d y: %d\nb: %d h: %d",Rahmen.origin.x,Rahmen.origin.y,Rahmen.size.width, Rahmen.size.height);
		
		lastLevel=0;
		fixTime=1.0;
		maxSet=NO;
		holdMax=-1;
		//NSLog(@"Hoehe: %d  Feldhoehe: %d" ,Hoehe, Feldhoehe);

		//NSLog(@"Breite: %d  Feldbreite: %f" ,Breite, Feldbreite);
		
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
	[self drawAufgabenzeiger];
}

- (void)setAnzahl:(int)dieAnzahl
{
	if (dieAnzahl>Grenze)
		Level=Grenze;
	else
		Level=dieAnzahl;
		[self display];
}
- (void)setAnzAufgaben:(int) dieNummer
{

	if (dieNummer>24)
		Grenze=24;
	else
	Grenze=dieNummer;
	
	[self display];
}

- (void)drawAufgabenzeiger
{
	[self lockFocus];
	int i;
	NSRect f;
	NSPoint Nullpunkt=NSMakePoint(3,3);
	for (i=0;i<Grenze;i++)
	{
		f=NSMakeRect(Nullpunkt.x+(i*(Feldbreite)),Nullpunkt.y,Feldbreite-Abstand,Feldhoehe);
		[[NSColor blackColor]set];
		[NSBezierPath strokeRect:f];
		{
			if (i<Level)
			{
				if (i<Grenze)
				{
					[[NSColor greenColor] set];
				}
				else
				{
					[[NSColor redColor] set];
				}
				
			}
			else
			{
				[[NSColor whiteColor]set];

			}
		}
		
		[NSBezierPath fillRect:f];
	}//for i
	[[NSColor grayColor]set];
	[NSBezierPath strokeRect:Rahmen];
	
	[self unlockFocus];

}

@end
