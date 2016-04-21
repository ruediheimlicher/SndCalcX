//
//  rAddSubSettings.h
//  SndCalcII
//
//  Created by Sysadmin on 18.10.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rAddSubSettings : NSView {
NSButton*		EinschaltTaste;
NSButton*		mitAddTaste;
NSButton*		mitSubTaste;
NSMutableArray*		AddSubTastenArray;
NSImage*			OnImg;
NSImage*			OffImg;


}
- (id)initWithFrame:(NSRect)frame;
//- (void)initAddSubSettings;
- (NSButton*)EinschaltTaste;
- (NSArray*)AddSubTastenArray;
- (void)setSettingsMit:(NSDictionary*)dieSettings;
- (NSDictionary*)getSettings;
- (int)checkSettings;
- (void)clearSettings;
@end
