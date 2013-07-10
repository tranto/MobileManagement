//
//  ProductObject.h
//  ZXingWidget
//
//  Created by HaPhanMinhTri on 7/11/13.
//
//

#import <Foundation/Foundation.h>

@interface ProductObject : NSObject
@property (nonatomic,retain)NSString *qRCode;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *price;
@property (assign) int quantum;
@end
