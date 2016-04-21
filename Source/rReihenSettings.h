//
//  rReihenSettings.h
//  SndCalcII
//
//  Created by Sysadmin on 16.10.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rReihenSettings : NSView 
{
NSMatrix* TastenArray;
int					Reihen[50];
NSMutableArray*		ReihenKnopfArray;
NSMutableArray*		ReihenTastenArray;
NSButton*			ClearTaste;//Reihentasten rücksetzen
NSButton*			EinschaltTaste;
NSButton*			Kleines1Mal1Taste;
NSButton*			Grosses1Mal1Taste;
NSButton*			ZehnerReihenTaste;
NSButton*			HunderterReihenTaste;
BOOL				SettingChanged;
}
- (id)initWithFrame:(NSRect)frame;
- (NSDictionary*)getSettings;
- (void)setSettingsMit:(NSDictionary*)dieSettings;
- (NSView*)TastenArray;
- (NSArray*)ReihenKnopfArray;
- (NSArray*)ReihenTastenArray;
- (NSButton*)ClearTaste;
- (NSButton*)EinschaltTaste;
- (void)KnopfAktion:(id)sender;
- (int)AnzahlReihen;
- (int)checkSettings;
- (void)clearSettings;
@end
