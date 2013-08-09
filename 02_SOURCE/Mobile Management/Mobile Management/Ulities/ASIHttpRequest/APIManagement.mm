//
//  APIManagement.m
//  Mobile Management
//
//  Created by TranTo on 7/3/13.
//  Copyright (c) 2013 TranTo. All rights reserved.
//

#import "APIManagement.h"
#import "TBXML.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#define Dummy_Data 0 
@implementation APIManagement

+ (NSString *)updateProductInfo:(NSString *)productIds withNumber:(NSString *)numberItemList withStoreName:(NSString *)storeName{
    if (Dummy_Data) {
        
        return @"";
    }
    __block BOOL result = NO;
    NSString *strTemp = [NSString stringWithFormat:@"%@product_ids=%@&num=%@&shop_name=%@",Header_Update_Product_List_Info,productIds,numberItemList,storeName];
    NSURL *resURL = [[NSURL alloc] initWithString:[strTemp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    DLog(@"URL %@",strTemp);
    __block ASIHTTPRequest *requestDataRes = [ASIHTTPRequest requestWithURL:resURL];
    [requestDataRes setCompletionBlock:^{
        NSString *data = [[NSString alloc] initWithData:[requestDataRes responseData] encoding:NSUTF8StringEncoding];
        result = [APIManagement parseXML:data];
        DLog(@"RESULT %@",data);
    }];
   
    [requestDataRes setFailedBlock:^{
        NSError *error = [requestDataRes error];
        DLog(@"ERRROR %@",error);
        
    }];
    [requestDataRes startAsynchronous];
    return @"";
}

+ (BOOL)parseXML:(NSString *)xmlString{
    NSError *reqError = nil;
    TBXML *xmlDoc = [TBXML newTBXMLWithXMLString:xmlString error:&reqError];
    if (!reqError) {
        TBXMLElement *root = [xmlDoc rootXMLElement];
//        TBXMLElement *element = [TBXML childElementNamed:XML_ELEMENT_NAME parentElement:root];
        DLog(@"CODE %@",[TBXML textForElement:root]);
        if (root) {
            int errorCode = [[TBXML textForElement:root] intValue];
            DLog(@"ERROR CODE %d",errorCode);
            switch (errorCode) {
                case ERROR_CODE:
                    return NO;	
                case SUCCESS_CODE:
                    return YES;
            }
        }
        return NO;
    }
    return NO;
}

@end
