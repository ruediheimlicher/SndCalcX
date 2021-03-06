#import "rDiplomFensterX.h"

float kDiplomTimeout=10.0;

@implementation rDiplomFenster
- (id)init
{
   self = [super initWithWindowNibName:@"SCDiplomFenster"];
   DiplomDic=[[NSDictionary alloc]init];
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(StatistikTimeoutAktion:)
              name:@"StatistikTimeout"
            object:nil];
   
   return self;
}

- (void)awakeFromNib
{
   //NSImage*	ZielImg=[NSImage imageNamed:@"Zielfahne"];
   NSImage*	ZielImg=[NSImage imageNamed:@"Ziel"];
   [ZielImage setImage:ZielImg];
   
}

- (void)setDiplomMit:(NSDictionary*)derDiplomDic
{
   
   DiplomDic=derDiplomDic;
   //NSLog(@"setDiplomMit: %@",[derDiplomDic description]);
   NSString* s1=NSLocalizedString(@"That's it",@"Das wär's");
   [TitelString setStringValue:s1];
   
   NSNumber* ModusNumber=[derDiplomDic objectForKey:@"modus"];
   if ([ModusNumber intValue])
   {
      [SichernCheckbox setEnabled:YES];
      [SichernCheckbox setState:1];
   }
   else
   {
      [SichernCheckbox setEnabled:NO];
      [SichernCheckbox setState:0];
   }
   NSNumber* AnzahlNumber=[derDiplomDic objectForKey:@"anzahlaufgaben"];
   int anz=[AnzahlNumber intValue];
   NSNumber* RichtigNumber=[derDiplomDic objectForKey:@"anzrichtig"];
   int richtig=[RichtigNumber intValue];
   NSString* s2a=NSLocalizedString(@"Of the given ",@"von den gegebenen");
   NSString* s2b=NSLocalizedString(@"Samples you have ",@" Aufgaben hast du ");
   NSString* s2c=NSLocalizedString(@"solved. ",@" gelöst");
   [AnzahlString setStringValue:[NSString stringWithFormat:@"%@ %d %@ %d %@",s2a,anz,s2b,richtig,s2c]];
   NSString* s3a =NSLocalizedString(@"This took ",@"Dafür hast du");
   NSString* s3b =NSLocalizedString(@" secconds",@" Sekunden gebraucht.");
   NSNumber* ZeitNumber=[derDiplomDic objectForKey:@"abgelaufenezeit"];
   [ZeitString setStringValue: [NSString stringWithFormat:@"%@ %d %@",s3a,[ZeitNumber intValue],s3b]];
   
  // NSString* s4=NSLocalizedString(@"Doing this, you made %d errors",@"Dabei hast du %d Fehler gemacht.");
   NSString* s4a=NSLocalizedString(@"Doing this, you made ",@"Dabei hast du ");
   NSString* s4b=NSLocalizedString(@" errors",@" Fehler gemacht.");
   
   NSNumber* FehlerNumber=[derDiplomDic objectForKey:@"anzfehler"];
   [FehlerString setStringValue:[NSString stringWithFormat:@"%@ %d %@",s4a,[FehlerNumber intValue],s4b]];
   
   [WeiterfahrenString setStringValue:NSLocalizedString(@"How to go on?",@"Wie willst du weiterfahren?")];
   
   [self setDiplomTimerMitIntervall:kDiplomTimeout];
   
}

- (void)DiplomTimerFunktion:(NSTimer*)derTimer
{
   //NSLog(@"DiplomTimerFunktion fire");
   [NSApp stopModalWithCode:0];
   [[self window] orderOut:NULL];
   [NSApp abortModal];
   
   //
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"umgebung"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   //	[nc postNotificationName:@"TestReset" object:self userInfo:NotificationDic];
   
   //	[[NSApp mainWindow]makeKeyAndOrderFront:NULL];
   
}

- (void)setTastenStatus:(BOOL)derStatus
{
   [SichernCheckbox setHidden:(derStatus==0)];
   [AnschauenTaste setHidden:(derStatus==0)];
}

- (void)StatistikTimeoutAktion:(NSNotification*) note
{
   NSLog(@"DiplomFenster:												StatistikTimeoutAktion");
   //[AnschauenTaste pef:0];
   [[NSApp modalWindow]makeKeyAndOrderFront:NULL];
   [[self window]makeKeyAndOrderFront:NULL];
   [[self window]makeFirstResponder:[self window]];
   //[[self window]makeKeyWindow];
   
   [self setDiplomTimerMitIntervall:5.0];
   
   
   
}


- (void)setDiplomTimerMitIntervall:(float)dasIntervall
{
   
   /*
    if ([DiplomTimer isValid])
    {
    NSLog(@"DiplomTimer invalidate");
    [DiplomTimer invalidate];
    }
    */
   //NSLog(@"DiplomTimer is set");
   DiplomTimer=[NSTimer scheduledTimerWithTimeInterval:(float)dasIntervall
                                                target:self
                                              selector:@selector(DiplomTimerFunktion:)
                                              userInfo:nil
                                               repeats:NO];
   [[NSRunLoop currentRunLoop] addTimer: DiplomTimer forMode:NSModalPanelRunLoopMode];
   
}

- (void)reportFinish:(id)sender
{
   if ([DiplomTimer isValid])
   {
      [DiplomTimer invalidate];
   }
   [NSApp stopModalWithCode:0];
   [[self window] orderOut:NULL];
   
   
}

- (void)reportWeiterfahren:(id)sender
{
   if ([DiplomTimer isValid])
   {
      [DiplomTimer invalidate];
   }
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"umgebung"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"Weiterfahren" object:self userInfo:NotificationDic];
   
   [NSApp stopModalWithCode:1];
   [[self window] orderOut:NULL];
   
}

- (BOOL)TestSichernOK
{
   return [SichernCheckbox state];
}

- (void)reportErgebnisseAnschauen:(id)sender
{
   float ErgebnisseTimeout=10.0;
   if ([DiplomTimer isValid])
   {
      NSLog(@"DiplomTimer invalidate");
      [DiplomTimer invalidate];
   }
   
   [NSApp stopModalWithCode:2];
   [[self window] orderOut:NULL];
   
   //Notification Nicht abgeschickt, Regelung in Antwort auf runModal
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject: [NSNumber numberWithInt:0]forKey:@"modus"];//
   [NotificationDic setObject: DiplomDic forKey:@"diplomdic"];//
   [NotificationDic setObject: [NSNumber numberWithFloat:ErgebnisseTimeout] forKey:@"timeout"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   //	[nc postNotificationName:@"showStatistik" object:self userInfo:NotificationDic];
   
}
@end
