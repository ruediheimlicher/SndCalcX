#import "rEinstellungenPanel.h"

@implementation rEinstellungenPanel
- (id) init
{
    //if ((self = [super init]))
	self = [super initWithWindowNibName:@"SCEinstellungenPanel"];
	
		return self;
}

- (void) awakeFromNib
{


}

- (void) setAdminTimeout:(int)dieZeit
{
//NSLog(@"setAdminTimeout Zeit: %d ",dieZeit);
[AdminTimeoutTaste selectItemWithTitle:[[NSNumber numberWithInt:dieZeit]stringValue]];
}

- (void) setUserTimeout:(int)dieZeit
{
NSLog(@"setUserTimeout Zeit: %d ",dieZeit);

[UserTimeoutTaste selectItemWithTitle:[[NSNumber numberWithInt:dieZeit]stringValue]];
}

- (void) setFarbig:(BOOL)farbigDrucken
{
NSLog(@"setFarbig farbigDrucken: %d ",farbigDrucken);

[FarbigTaste setState:farbigDrucken];
}


- (IBAction)reportAdminTimeout:(id)sender
{

}

- (void)setzeZeitFeld:(NSArray*)zeitArray
{
   //NSLog(@"setzeZeitFeld zeitArray: %@",zeitArray);
   
   ZeitFeld.string = [zeitArray componentsJoinedByString:@"\n"];
}


- (void)setzeAnzahlFeld:(NSArray*)anzArray
{
   //NSLog(@"setzeAnzahlFeld anzArray: %@",anzArray);
   NSString* anzstring =[anzArray componentsJoinedByString:@"\n"];;
   //NSLog(@"setzeAnzahlFeld anzstring: %@",anzstring);
  [AnzahlFeld setString:[anzArray componentsJoinedByString:@"\n"]];
}



- (IBAction)reportCancel:(id)sender
{
NSLog(@"reportCancel ");

		[NSApp stopModalWithCode:0];
		[[self window]orderOut:NULL];

}

- (IBAction)reportClose:(id)sender
{
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithLong:[[AdminTimeoutTaste selectedItem]tag]] forKey:@"admintimeout"];
	[NotificationDic setObject:[NSNumber numberWithLong:[[UserTimeoutTaste selectedItem]tag]] forKey:@"usertimeout"];
	[NotificationDic setObject:[NSNumber numberWithInt:[FarbigTaste state]] forKey:@"farbig"];
   [NotificationDic setObject:[[AnzahlFeld string]componentsSeparatedByString:@"\n" ] forKey:@"anzahlarray"];
   [NotificationDic setObject:[[ZeitFeld string]componentsSeparatedByString:@"\n" ] forKey:@"zeitarray"];

	//NSLog(@"reportClose: NotificationDic: %@",[NotificationDic description]);
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"Einstellungen" object:self userInfo:NotificationDic];


	[NSApp stopModalWithCode:1];
	[[self window]orderOut:NULL];

}


- (IBAction)reportUserTimout:(id)sender
{

}

- (long)cleanOK
{
return ([CleanTaste state]);
}

- (long)AnzahlBehalten
{
return ([[ErgebnisseBehaltenTaste selectedItem]tag]);
}


@end
