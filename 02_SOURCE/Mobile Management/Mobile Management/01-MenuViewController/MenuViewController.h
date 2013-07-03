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
#import "ZXingWidgetController.h"

@interface MenuViewController : UIViewController<ZXingDelegate>{
    
    IBOutlet UITextField *txtStorename;
    IBOutlet UIButton *_btnCheckout;
    IBOutlet UIButton *_btnBooking;
  
    IBOutlet UIButton *_btnDone;
}
- (IBAction)CompleteStorename:(id)sender;

- (IBAction)goToScanView:(id)sender;
- (IBAction)goToBookingView:(id)sender;
+ (MenuViewController *)shareInstance;
@end
