//////////
//
//	File:		QTUtils.c
//
//	Contains:	QuickTime movie toolbox utility functions.
//
//	Written by:	Apple Developer Technical Support
//
//	Copyright:	© 2001 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//	   
//	   <1>	 	6/12/01	srk		first file
//
//////////


#include <Carbon/Carbon.h>
#include <QuickTime/QuickTime.h>
//#include <AppKit/AppKit.h>

#include "QTUtils.h"



static StringPtr MakeMovieTimeDisplayString(long	movieTotalSeconds);
static StringPtr MakeMovieTimeScaleDisplayString(long	movieTimeScale);

//////////
//
// QTUtils_IsAutoPlayMovie
//
// Get the autoplay state of a movie file.
//
// A movie file can have information about its autoplay state in a user data item of type 'play'.
// If the movie doesn't contain an item of this type, then we'll assume that it doesn't autoplay.
// If it does contain an item of this type, then the item data (a Boolean) is 0 for normal play
// and 1 for autoplay.
//
//////////

Boolean QTUtils_IsAutoPlayMovie (Movie theMovie)
{
	UserData		myUserData = NULL;
	Boolean			myAutoPlay = false;
	OSErr			myErr = paramErr;

	// make sure we've got a movie
	if (theMovie == NULL)
		return(myAutoPlay);
		
	// get the movie's user data list
	myUserData = GetMovieUserData(theMovie);
	if (myUserData != NULL) {
		myErr = GetUserDataItem(myUserData, &myAutoPlay, sizeof(myAutoPlay), FOUR_CHAR_CODE('play'), 0);
		if (myErr != noErr)
			myAutoPlay = false;
	}

	return(myAutoPlay);
}

//////////
//
// MakeMovieTimeDisplayString
//
// Construct a string of the form "00:00:00" corresponding to the movie time.
//
//////////

static StringPtr MakeMovieTimeDisplayString(long	movieTotalSeconds)
{
	Str255			tempString;
	StringPtr		finalString;

    long			movieHours;
	long			movieMinutes;
	long			movieSeconds;

    finalString = NewPtr(sizeof(Str255));
    finalString[0] = 0;
    
	/* This is the readout that says something like: “2 minutes 5 seconds” */
	
	movieHours = movieTotalSeconds / 60 * 60;
    movieMinutes = movieTotalSeconds / 60;
	movieSeconds = movieTotalSeconds % 60;
	
    tempString[0] = 0;
	
	if (movieHours != 0)
	{			
        if (movieHours < 10)
        {
            PLstrcat(finalString, "\p0");
        }
		NumToString(movieHours, tempString);
        PLstrcat(finalString, (ConstStr255Param)&tempString);
	}
    else
    {
        PLstrcat(finalString,"\p00");
    }
    
    PLstrcat(finalString,"\p:");
    tempString[0] = 0;
	
	if (movieMinutes != 0)
	{			
        if (movieMinutes < 10)
        {
            PLstrcat(finalString, "\p0");
        }
		NumToString(movieMinutes, tempString);
        PLstrcat(finalString, (ConstStr255Param)&tempString);
	}
    else
    {
        PLstrcat(finalString,"\p00");
    }
    
    PLstrcat(finalString,"\p:");
    tempString[0] = 0;

	if (movieSeconds != 0)
	{
        if (movieSeconds < 10)
        {
            PLstrcat(finalString, "\p0");
        }
		NumToString(movieSeconds, tempString);
        PLstrcat(finalString, (ConstStr255Param)&tempString);
	}
    else
    {
        PLstrcat(finalString,"\p00");
    }

	/* Now, if the movie is shorter than one second long (“zero seconds”), but
		_not_ zero duration, handle that case specially.
		*/

	if ((movieMinutes == 0) && (movieSeconds == 0) && (movieHours == 0) && (movieTotalSeconds != 0))
	{
		finalString[0] = 0;
        PLstrcat(finalString,"\pless than one second");
	}

    p2cstrcpy(finalString, (ConstStr255Param)finalString);
    return finalString;
}

//////////
//
// MakeMovieTimeScaleDisplayString
//
// Construct a display string for the movie time scale.
//
//////////

static StringPtr MakeMovieTimeScaleDisplayString(long	movieTimeScale)
{
	StringPtr		finalString;

    finalString = NewPtr(sizeof(Str255));
    finalString[0] = 0;
    
    NumToString(movieTimeScale, finalString);

    p2cstrcpy(finalString, (ConstStr255Param)finalString);
    return finalString;
}

//////////
//
// GetMovieDurationAsString
//
// Construct a string of the form "00:00:00" corresponding to the movie duration.
//
//////////

NSString *GetMovieDurationAsString(Movie theMovie)
{
    StringPtr	movieDurationString = MakeMovieTimeDisplayString(GetMovieDuration(theMovie) / GetMovieTimeScale(theMovie));
    NSString	*movieDurationNSString = [NSString stringWithCString:movieDurationString];
    DisposePtr((Ptr)movieDurationString);
    
    return movieDurationNSString;
}

//////////
//
// GetMovieTimeScaleAsString
//
// Construct a string of the form "00:00:00" corresponding to the movie current time.
//
//////////

NSString *GetMovieTimeScaleAsString(Movie theMovie)
{
    StringPtr	timeScaleString = MakeMovieTimeScaleDisplayString(GetMovieTimeScale(theMovie));
    NSString	*timeScaleNSString = [NSString stringWithCString:timeScaleString];
    DisposePtr((Ptr)timeScaleString);
    
    return timeScaleNSString;
}

