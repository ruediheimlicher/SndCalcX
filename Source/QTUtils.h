//////////
//
//	File:		QTUtils.h
//
//	Contains:	Interface file for QuickTime movie toolbox utility functions.
//
//	Written by:	Apple Developer Technical Support
//
//	Copyright:	© 2001 by Apple Computer, Inc., all rights reserved.
//
//	Change History (most recent first):
//	   
//	   <1>	 	6/18/01	srk		first file
//
//////////



Boolean QTUtils_IsAutoPlayMovie (Movie theMovie);
NSString *GetMovieTimeScaleAsString(Movie theMovie);
NSString *GetMovieDurationAsString(Movie theMovie);
