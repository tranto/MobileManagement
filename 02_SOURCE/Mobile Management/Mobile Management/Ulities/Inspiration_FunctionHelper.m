//
//  FunctionHelper.m
//  FunctionHelper
//
//  Created by Ha Phan Minh Tri on 1/15/13.
//  Copyright (c) 2013 HaPhanMinhTri. All rights reserved.
//

#import "Inspiration_FunctionHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>


#pragma mark -
#pragma mark Extenstion For UIAlertView
#pragma mark -

@implementation UIAlertView (BlockExtensions)
- (id)initWithTitle:(NSString *)title message:(NSString *)message
                            cancelButtonTitle:(NSString *)cancelButtonTitle
                            otherButtonTitles:(NSString *)otherButtonTitles, ...  {
    
    if (self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil]) {
		if (cancelButtonTitle) {
			[self addButtonWithTitle:cancelButtonTitle];
			self.cancelButtonIndex = [self numberOfButtons] - 1;
		}
        
		
		if (otherButtonTitles) {
            va_list argumentList;
			va_start(argumentList, otherButtonTitles);
            do{
                [self addButtonWithTitle:otherButtonTitles];
            }
			while ((otherButtonTitles = va_arg(argumentList, id)));
			va_end(argumentList);
		}
	}
	return self;
    
}
- (id)initWithTitle:(NSString *)title message:(NSString *)message
                              completionBlock:(void (^)(UIAlertView *alertView, NSUInteger buttonIndex))block
                            cancelButtonTitle:(NSString *)cancelButtonTitle
                            otherButtonTitles:(NSString *)otherButtonTitles, ...  {

	objc_setAssociatedObject(self, "blockAlerViewCallback", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
	if (self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil]) {
        
		if (cancelButtonTitle) {
			[self addButtonWithTitle:cancelButtonTitle];
			self.cancelButtonIndex = [self numberOfButtons] - 1;
		}
        
		
		if (otherButtonTitles) {
            va_list argumentList;
			va_start(argumentList, otherButtonTitles);
            do{
                [self addButtonWithTitle:otherButtonTitles];
            }
			while ((otherButtonTitles = va_arg(argumentList, id)));
			va_end(argumentList);
		}
	}
	return self;
}
-(void)setDismissBlock:(void(^)( UIAlertView *alertView, NSUInteger buttonIndex))blockDismiss{
    objc_setAssociatedObject(self, "blockAlerViewSetDismissBlock", blockDismiss, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^block)(UIAlertView *alertView, NSUInteger buttonIndex) = objc_getAssociatedObject(self,"blockAlerViewCallback");
    void (^blockDismiss)(UIAlertView *alertView, NSUInteger buttonIndex) = objc_getAssociatedObject(self, "blockAlerViewSetDismissBlock");
    if (blockDismiss) {
        blockDismiss(self,buttonIndex);
        objc_removeAssociatedObjects(self);
    }
    else if (block){
        block(self,buttonIndex);

        objc_removeAssociatedObjects(self);
    }
    //removeAssociatedObjects nen de o trong if
}

@end


#pragma mark -
#pragma mark Extenstion For UIActionSheet
#pragma mark -
@implementation UIActionSheet (BlockExtensions)

- (id)initWithTitle:(NSString *)title completionBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))block
                                    cancelButtonTitle:(NSString *)cancelButtonTitle
                               destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                    otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
	objc_setAssociatedObject(self, "blockActionSheetCallback", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
	if (self = [self initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]) {
        
		if (destructiveButtonTitle) {
			[self addButtonWithTitle:destructiveButtonTitle];
			self.destructiveButtonIndex = [self numberOfButtons] - 1;
		}
		if (otherButtonTitles) {
			va_list argumentList;
			va_start(argumentList, otherButtonTitles);
            do {
                [self addButtonWithTitle:otherButtonTitles];
            } while ((otherButtonTitles = va_arg(argumentList, id)));
            va_end(argumentList);
		}
        
		if (cancelButtonTitle) {
			[self addButtonWithTitle:cancelButtonTitle];
			self.cancelButtonIndex = [self numberOfButtons] - 1;
		}
	}
	return self;
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    if (self = [self initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]) {
        
		if (destructiveButtonTitle) {
			[self addButtonWithTitle:destructiveButtonTitle];
			self.destructiveButtonIndex = [self numberOfButtons] - 1;
		}
        
		if (otherButtonTitles) {
			va_list argumentList;
			va_start(argumentList, otherButtonTitles);
            do {
                [self addButtonWithTitle:otherButtonTitles];
            } while ((otherButtonTitles = va_arg(argumentList, id)));
            va_end(argumentList);
		}
        
		if (cancelButtonTitle) {
			[self addButtonWithTitle:cancelButtonTitle];
			self.cancelButtonIndex = [self numberOfButtons] - 1;
		}
	}
	return self;

}

- (void)setDismissBlock:(void (^)(UIActionSheet *actionSheet, NSUInteger buttonIndex))blockDismiss{
    objc_setAssociatedObject(self, "blockActionSheetSetDismissBlock", blockDismiss, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	void (^block)(UIActionSheet *actionSheet, NSUInteger buttonIndex) = objc_getAssociatedObject(self, "blockActionSheetCallback");
    void (^blockDismiss)(UIActionSheet *actionSheet, NSUInteger buttonIndex) = objc_getAssociatedObject(self, "blockActionSheetSetDismissBlock");
    if (block) {
        block(self,buttonIndex);
        objc_removeAssociatedObjects(self);
    }
	else if (blockDismiss){
        blockDismiss(self,buttonIndex);
        objc_removeAssociatedObjects(self);
    }
}
@end

#pragma mark -
#pragma mark Inspiration FunctionHelper
#pragma mark -

@implementation Inspiration_FunctionHelper
#pragma mark - ======== PATH ========
#pragma mark Document
+ (NSString *) getPathFromDocument{
    NSArray *segments = @[NSHomeDirectory(),@"Documents"];
    return [NSString pathWithComponents:segments];
}

+ (NSString *) getPathFromDocumentWithSubPath:(NSString *)subPath{
    NSArray *segments = @[NSHomeDirectory(),[NSString stringWithFormat:@"Documents/%@",subPath]];
    return [NSString pathWithComponents:segments];
}
#pragma mark Temp
+ (NSString *) getPathFromTemporatyDirectoryWithSubPath:(NSString *)subPath{
    NSArray *segments = @[NSTemporaryDirectory(),subPath];
    return [NSString pathWithComponents:segments];
}
#pragma mark Check Path
+ (BOOL) checkExistsPath:(NSString *)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path ];
}
#pragma mark Process with Path
+ (BOOL) createFolderFromPath:(NSString *)path{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:path ] ) {
        NSError *error = nil;
        if ([filemanager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            return YES;// create success
        }
        else{
            if (error) {
                DLog(@"ERROR : %@", error);
            }
            return NO;
        }
    }
    else{
        return YES;// Folder exists
    }
    return NO;
}
+ (BOOL) deleteFolderOrFileFromPath:(NSString *)path{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:path ] ) {
        NSError *error = nil;
        if ([filemanager removeItemAtPath:path error:&error]) {
            return YES;// remove success
        }
        else{
            if (error) {
                DLog(@"ERROR : %@", error);
            }
            return NO;
        }
    }
    else{
        return YES;// Folder not exists
    }
    return NO;
    
}
#pragma mark -  ======== CHECK CHECKSUM A FILE ========
+ (NSString *) checkSumWithMD5StringFromData:(NSData *)data{
    void *cData = malloc([data length]);
    unsigned char resultCString[16];
    [data getBytes:cData length:[data length]];
    
    CC_MD5(cData, [data length], resultCString);
    free(cData);
    
    NSString *result = [NSString stringWithFormat:
                        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        resultCString[0], resultCString[1], resultCString[2], resultCString[3],
                        resultCString[4], resultCString[5], resultCString[6], resultCString[7],
                        resultCString[8], resultCString[9], resultCString[10], resultCString[11],
                        resultCString[12], resultCString[13], resultCString[14], resultCString[15]
                        ];
    return result;
}
#pragma mark - ======== DATE ========

#pragma mark Get Date
+ (NSInteger) getYearFromDate:(NSDate *)myDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSYearCalendarUnit;
    
    NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate:myDate];
    NSInteger year = [dateComponents year];
    SAFE_RELEASE(gregorian);
    return year;
}
+ (NSInteger) getMonthFromDate:(NSDate *)myDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSMonthCalendarUnit;
    
    NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate:myDate];
    NSInteger month = [dateComponents month];
    SAFE_RELEASE(gregorian);
    return month;
}
+ (NSInteger) getDayFromDate:(NSDate *)myDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
    
    NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate:myDate];
    NSInteger month = [dateComponents day];
    SAFE_RELEASE(gregorian);
    return month;
}
+ (NSInteger) getHourFromDate:(NSDate *)myDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSHourCalendarUnit;
    
    NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate:myDate];
    NSInteger month = [dateComponents hour];
    SAFE_RELEASE(gregorian);
    return month;
}
+ (NSInteger) getMinuteFromDate:(NSDate *)myDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSMinuteCalendarUnit;
    
    NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate:myDate];
    NSInteger month = [dateComponents minute];
    SAFE_RELEASE(gregorian);
    return month;
}
+ (NSInteger) getSecondFromDate:(NSDate *)myDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSSecondCalendarUnit;
    
    NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate:myDate];
    NSInteger month = [dateComponents second];
    SAFE_RELEASE(gregorian);
    return month;
}
+ (void) getYear:(NSInteger *)year month:(NSInteger *)month day:(NSInteger *)day hour:(NSInteger *)hour minute:(NSInteger *)minute second:(NSInteger *)second fromDate:(NSDate *)myDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];

    if (year) {
        *year  = [[gregorian components:NSYearCalendarUnit fromDate:myDate] year];
    }
    if (month) {
        *month = [[gregorian components:NSMonthCalendarUnit fromDate:myDate] month];
    }
    if (day) {
        *day   = [[gregorian components:NSDayCalendarUnit fromDate:myDate] day];
    }
    if (hour) {
        *hour  = [[gregorian components:NSHourCalendarUnit fromDate:myDate] hour];
    }
    if (minute) {
        *minute= [[gregorian components:NSMinuteCalendarUnit fromDate:myDate] minute];
    }
    if (second) {
        *second= [[gregorian components:NSSecondCalendarUnit fromDate:myDate] second];
    }
    SAFE_RELEASE(gregorian);

}
#pragma mark Compare Date
+ (ResultCompareTime) compareMyDate:(NSDate *)myDate otherDate:(NSDate *)dateOther{
    
    NSComparisonResult result = [dateOther compare:myDate];
    
    DLog(@"My Date   : %@", myDate);
    DLog(@"Date Other:%@", dateOther);
    
    switch (result)
    {
        case NSOrderedAscending:    return FUTURE;  break;
        case NSOrderedDescending:   return PAST;    break;
        case NSOrderedSame:         return PRESENT; break;
        default:                    return ERROR;   break;
    }
}
#pragma mark - UIVIEW

+ (UIColor *) randomColor{
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (void) setExclusiveTouchForList:(NSArray *)lst{
    for (UIView *view in lst) {
        view.exclusiveTouch = YES;
    }
}
+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - ======== CONVERT ========
+ (NSDate *) convertStringToDate:(NSString *)myString formatter:(NSString *)myFormatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:myFormatter];
    NSDate *date = [formatter dateFromString:myString];
    SAFE_RELEASE(formatter);
    return date;
}
+ (NSString *) convertDateToString:(NSDate *)myDate formatter:(NSString *)myFormatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:myFormatter];
    NSString *returnStr = [formatter stringFromDate:myDate];
    SAFE_RELEASE(formatter);
    return returnStr;
}
//NSString *convertNSNumberToNSString(NSNumber *number, NSNumberFormatterStyle stype){
//    NSDictionary *attributesDict = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:NULL];
//
//    // Print total file system size and available space
//    NSLog(@"System size: %lld", [[attributesDict objectForKey:NSFileSystemSize] longLongValue]);
//    NSLog(@"System free space: %lld", [[attributesDict objectForKey:NSFileSystemFreeSize] longLongValue]);
//
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    formatter.numberStyle = stype;
////    [formatter setPositiveFormat:@"#,###.00"];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"];
//    [formatter setLocale:locale];
//    NSString *string = [formatter stringFromNumber:number];
//    [formatter release];
//    return string;
//}

+ (void)swapBetweenA:(void **) a andB:(void **) b{
    void **temp = *a;
    *a = *b;
    *b = temp;
}
+ (void)swapBetween_A:(id *)a B:(id *)b{
    id temp = *a;
    *a = *b;
    *b = temp;
}



#pragma mark - ======== NSSTRING ========
#pragma mark Check Validate
+ (BOOL) isEmailValid:(NSString *)emailAddress{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAddress];
}

+ (BOOL) isEmpty:(NSString *)inputString{
    if ([inputString length] == 0 || [[inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
+ (BOOL) isNumber:(NSString *)string{
    BOOL valid;
    double holder;
    NSScanner *scan = [NSScanner scannerWithString: string];
    valid = [scan scanDouble:&holder] && [scan isAtEnd];
    return valid;
}
+ (BOOL) isSpaceInString:(NSString *)inputString{
    if([inputString rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound){
        return YES;
    }
    return FALSE;
}

#pragma mark Check Input is Number

+ (NSString *)removeSpaceInString:(NSString *)inputString{
    return [inputString stringByReplacingOccurrencesOfString:@" " withString:@""];
}
+ (NSString *)removeItem:(NSString *)aItem inString:(NSString *)inputString {
    return [inputString stringByReplacingOccurrencesOfString:aItem withString:@""];
}

@end


