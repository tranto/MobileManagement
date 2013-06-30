//
//  CIColor_Inspiration_Definition.h
//  FunctionHelper
//
//  Created by HaPhanMinhTri on 1/14/13.
//  Copyright (c) 2013 HaPhanMinhTri. All rights reserved.
//



#pragma mark - TYPEDEF ENUM
typedef enum {
    ERROR   =0,
    PAST    =1,
    PRESENT =2,
    FUTURE  =3
}ResultCompareTime;


#pragma mark - DEFINE OTHER

#define DDMMYYYY @"dd/mm/yyyy"
#define MMDDYYYY @"mm/dd/yyyy"
#define YYYYDDMM @"yyyy/dd/mm"
#define YYYYMMDD @"yyyy/mm/dd"

#define MSCREEN [UIScreen mainScreen]
#define WIDTH_MSCREEN [[UIScreen mainScreen] bounds].size.width
#define HEIGHT_MSCREEN [[UIScreen mainScreen] bounds].size.height

#define IS_IPHONE_IPOD_5 (([[UIScreen mainScreen] bounds].size.height==568)?YES:NO)

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#if __has_feature(objc_arc)

    #define SAFE_PROP_RETAIN strong

    #define SAFE_RELEASE(p) 
    #define SAFE_RETAIN(p) 
    #define SAFE_AUTORELEASE(p) (p)

    #define SAFE_ARC_BLOCK_COPY(p) (p)
    #define SAFE_ARC_BLOCK_RELEASE(p)

#else

    #define SAFE_PROP_RETAIN retain

    #define SAFE_RELEASE(p)				{ if (p) { [(p) release]; (p) = nil;  } }
    #define SAFE_RETAIN(p) [p retain]
    #define SAFE_AUTORELEASE(p) ([(p) autorelease])

    #define SAFE_ARC_BLOCK_COPY(p) (Block_copy(p))
    #define SAFE_ARC_BLOCK_RELEASE(p) (Block_release(p))

#endif

#if !defined(__clang__) || __clang_major__ < 3
    #ifndef __bridge
        #define __bridge
    #endif

    #ifndef __bridge_retain
        #define __bridge_retain
    #endif

    #ifndef __bridge_retained
        #define __bridge_retained
    #endif

    #ifndef __autoreleasing
        #define __autoreleasing
    #endif

    #ifndef __strong
        #define __strong
    #endif

    #ifndef __unsafe_unretained
        #define __unsafe_unretained
    #endif

    #ifndef __weak
        #define __weak
    #endif
#endif

#pragma mark - DEFINE LOG
//*********************************************** DLog ********************************************************
//-------------------------------------------------------------------------------------------------------------
//DLog() will output like NSLog but containing function and line number and only when the DEBUG variable is set
//-------------------------------------------------------------------------------------------------------------
#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define DLog(...)
#endif

//*********************************************** DLogSeparators **********************************************
//-------------------------------------------------------------------------------------------------------------
//ULog() only show "______________________________"
//-------------------------------------------------------------------------------------------------------------
#ifdef DEBUG
#define DLogSeparators() NSLog( @"────────────────────────────────────────────────────────────────────────────" );
#else
#define DLogSeparators()
#endif

//*********************************************** ULog ********************************************************
//-------------------------------------------------------------------------------------------------------------
//ULog() will show the UIAlertView only when the DEBUG variable is set
//-------------------------------------------------------------------------------------------------------------
#ifdef DEBUG
    #define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
    #define ULog(...)
#endif



