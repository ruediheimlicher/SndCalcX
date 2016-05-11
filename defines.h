//
//  defines.h
//  SndCalcX
//
//  Created by Ruedi Heimlicher on 28.04.2016.
//  Copyright © 2016 Ruedi Heimlicher. All rights reserved.
//

#ifndef defines_h
#define defines_h

#define     AUFGABEFALSCH     25002
#define     FALSCHESZEICHEN   25005
#define     AUFGABERICHTIG    25001
#define     SERIEFERTIG       25003

#define     TRAININGMANUELL   1
#define     TRAININGAUTO      2

#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) /* */
#endif
#define ALog(...) NSLog(__VA_ARGS__)
#endif /* defines_h */

