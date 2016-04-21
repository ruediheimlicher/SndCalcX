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
NSLog(@"setAdminTimeout Zeit: %d ",dieZeit);
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



- (IBAction)reportCancel:(id)sender
{
NSLog(@"reportCancel ");

		[NSApp stopModalWithCode:0];
		[[self window]orderOut:NULL];

}

- (IBAction)reportClose:(id)sender
{
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:[[AdminTimeoutTaste selectedItem]tag]] forKey:@"admintimeout"];
	[NotificationDic setObject:[NSNumber numberWithInt:[[UserTimeoutTaste selectedItem]tag]] forKey:@"usertimeout"];
	[NotificationDic setObject:[NSNumber numberWithInt:[FarbigTaste state]] forKey:@"farbig"];

	NSLog(@"reportClose: NotificationDic: %@",[NotificationDic description]);
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"Einstellungen" object:self userInfo:NotificationDic];


	[NSApp stopModalWithCode:1];
	[[self window]orderOut:NULL];

}


- (IBAction)reportUserTimout:(id)sender
{

}

- (int)cleanOK
{
return ([CleanTaste state]);
}

- (int)AnzahlBehalten
{
return ([[ErgebnisseBehaltenTaste selectedItem]tag]);
}


@end
