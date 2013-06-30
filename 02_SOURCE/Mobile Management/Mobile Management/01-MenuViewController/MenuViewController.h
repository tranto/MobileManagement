//
//  MenuViewController.h
//  Mobile Management
//
//  Created by TranTo on 6/28/13.
//  Copyright (c) 2013 TranTo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanViewController.h"
#import "BookingViewController.h"
@interface MenuViewController : UIViewController
- (IBAction)goToScanView:(id)sender;
- (IBAction)goToBookingView:(id)sender;
+ (MenuViewController *)shareInstance;
@end
