#import "rPWTimeout.h"

@implementation rPWTimeout
- (id)init
{
self = [super initWithWindowNibName:@"SCPWTimeoutPanel"];

return self;
}


- (void)setTitelString:(NSString*)derTextString
{
[DialogTitelString setStringValue:derTextString];
}


- (void)setTextString1:(NSString*)derTextString
{
//NSLog(@"setTextString1: %@",derTextString);
[DialogTextString1 setStringValue:derTextString];
//NSLog(@"setTextString1: %@",[DialogTextString1 stringValue]);
}
- (void)setTextString2:(NSString*)derTextString
{
[DialogTextString2 setStringValue:derTextString];
}




- (IBAction)reportContinue:(id)sender
{
NSLog(@"PWTimeoutreportContinue");

	[NSApp stopModalWithCode:1];
	[[self window] orderOut:NULL];

}

- (IBAction)reportStop:(id)sender
{
NSLog(@"PWTimeoutreportStop");

	[NSApp stopModalWithCode:0];
	[[self window] orderOut:NULL];


}

@end
