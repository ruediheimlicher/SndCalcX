//
//  NSString+regex.h
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 07.05.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString  (regex)

- (BOOL)doesMatchRegStringExp:(NSString *)string;
-(NSString*) firstURLinString;
-(NSString*) firstStringWithPattern:(NSString*)pattern;
-(BOOL) matchesPattern:(NSString*)pattern;

@end
