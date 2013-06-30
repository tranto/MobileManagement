//
//  FunctionHelper.h
//  FunctionHelper
//
//  Created by Ha Phan Minh Tri on 1/15/13.
//  Copyright (c) 2013 HaPhanMinhTri. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - ALERT VIEW
@interface UIAlertView (BlockExtensions) <UIAlertViewDelegate>

#if NS_BLOCKS_AVAILABLE
- (id)initWithTitle:(NSString *)title message:(NSString *)message completionBlock:(void (^)( UIAlertView *alertView, NSUInteger buttonIndex))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_AVAILABLE(10_6, 4_0);

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_AVAILABLE(10_6, 4_0);

- (void)setDismissBlock:(void (^)(UIAlertView *alertView, NSUInteger buttonIndex))blockDismiss NS_AVAILABLE(10_6, 4_0) ;
#endif

@end

#pragma mark - ACTIONSHEET
@interface UIActionSheet (BlockExtensions) <UIActionSheetDelegate>
#if NS_BLOCKS_AVAILABLE
- (id)initWithTitle:(NSString *)title completionBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))block cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_AVAILABLE(10_6, 4_0);

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_AVAILABLE(10_6, 4_0);

- (void)setDismissBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))blockDismiss NS_AVAILABLE(10_6, 4_0);

#endif
@end

@interface Inspiration_FunctionHelper : NSObject


#pragma mark - PATH
//************************ Get Path *******************
//-----------------------------------------------------
+ (NSString *) getPathFromDocument;
+ (NSString *) getPathFromDocumentWithSubPath:(NSString *)subPath;
+ (NSString *) getPathFromTemporatyDirectoryWithSubPath:(NSString *)subPath;
//-----------------------------------------------------




//************************ Check Path *****************
//-----------------------------------------------------
+ (BOOL) checkExistsPath:(NSString *)path;
//-----------------------------------------------------


//************************ Process with Path **********
//-----------------------------------------------------
+ (BOOL) createFolderFromPath:(NSString *)path;
+ (BOOL) deleteFolderOrFileFromPath:(NSString *)path;
//-----------------------------------------------------




#pragma mark - CHECK CHECKSUM A FILE
//************************ CheckMD5 *******************
//-----------------------------------------------------
+ (NSString *) checkSumWithMD5StringFromData:(NSData *)data;
//-----------------------------------------------------




#pragma mark - DATE
//************************ Get Date *******************
//-----------------------------------------------------
+ (NSInteger) getYearFromDate:(NSDate *)myDate;
+ (NSInteger) getMonthFromDate:(NSDate *)myDate;
+ (NSInteger) getDayFromDate:(NSDate *)myDate;
+ (NSInteger) getHourFromDate:(NSDate *)myDate;
+ (NSInteger) getMinuteFromDate:(NSDate *)myDate;
+ (NSInteger) getSecondFromDate:(NSDate *)myDate;
+ (void) getYear:(NSInteger *)year month:(NSInteger *)month day:(NSInteger *)day hour:(NSInteger *)hour minute:(NSInteger *)minute second:(NSInteger *)second fromDate:(NSDate *)myDate;
//-----------------------------------------------------



//************************ Compare Date ***************
//-----------------------------------------------------
+ (ResultCompareTime) compareMyDate:(NSDate *)myDate otherDate:(NSDate *)dateOther;
//-----------------------------------------------------



#pragma mark - CONVERT
//************************ Convert ********************
//-----------------------------------------------------
+ (NSDate *) convertStringToDate:(NSString *)myString formatter:(NSString *)myFormatter;
+ (NSString *) convertDateToString:(NSDate *)myDate formatter:(NSString *)myFormatter;
//NSString *convertNSNumberToNSString(NSNumber *number,NSNumberFormatterStyle stype);
//-----------------------------------------------------

//Hai ham nay giong nhau
+ (void)swapBetweenA:(void **) a andB:(void **)b;
+ (void)swapBetween_A:(id *)a B:(id *)b;

#pragma mark - UIVIEW
//************************ Random *********************
//-----------------------------------------------------
+ (UIColor *) randomColor;
//-----------------------------------------------------

//************************ Set Exclusive **************
//-----------------------------------------------------
+ (void) setExclusiveTouchForList:(NSArray *)lst;
//Example : setExclusiveTouchForList(@[_btOne, _btTwo, _btThree, _btFour]);
//-----------------------------------------------------

//************************ ResizeImage **************
//-----------------------------------------------------
+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)newSize;
//-----------------------------------------------------



#pragma mark - NSSTRING
//************************ Check Validate *************
//-----------------------------------------------------
+ (BOOL) isEmailValid:(NSString *)emailAddress;
+ (BOOL) isEmpty:(NSString *)inputString;//string is all whitespace OR string is empty or nil
+ (BOOL) isNumber:(NSString *)string;// check string input is number
+ (BOOL) isSpaceInString:(NSString *)inputString;

+ (NSString *)removeSpaceInString:(NSString *)inputString;
+ (NSString *)removeItem:(NSString *)aItem inString:(NSString *)inputString ;
//-----------------------------------------------------
#pragma mark - Functions for Nail project


@end
