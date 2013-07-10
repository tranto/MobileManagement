//
//  ProductObject.m
//  ZXingWidget
//
//  Created by HaPhanMinhTri on 7/11/13.
//
//

#import "ProductObject.h"

@implementation ProductObject
- (id)init
{
    self = [super init];
    if (self) {
        _name = @"";
        _quantum = 0;
        _qRCode = @"";
        _price = @"25$";
    }
    return self;
}
- (void)dealloc
{
    SAFE_RELEASE(_name);
    SAFE_RELEASE(_qRCode);
    SAFE_RELEASE(_price);
    [super dealloc];
}
@end
