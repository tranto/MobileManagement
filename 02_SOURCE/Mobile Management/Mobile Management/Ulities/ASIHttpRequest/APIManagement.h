//
//  APIManagement.h
//  Mobile Management
//
//  Created by TranTo on 7/3/13.
//  Copyright (c) 2013 TranTo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralDefinition.h"
@interface APIManagement : NSObject

+ (NSString *)updateProductInfo:(NSString *)productIds withNumber:(NSString *)numberItemList withStoreName:(NSString *)storeName;
+ (BOOL)parseXML:(NSString *)xmlString;
@end
