//
//  rRahmen.h
//  SndCalcII
//
//  Created by Sysadmin on 05.11.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rRahmen : NSView 
{
int mark;
}
- (id)initWithFrame:(NSRect)frame;
//- (void)setRahmen;
- (void)setMark:(int)dieMarke;

@end
