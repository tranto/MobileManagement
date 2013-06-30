//
//  MenuViewController.m
//  Mobile Management
//
//  Created by TranTo on 6/28/13.
//  Copyright (c) 2013 TranTo. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
static MenuViewController *gInstance = nil;

- (IBAction)goToScanView:(id)sender {
    ScanViewController *_scanViewController = [[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:nil];
    [self.navigationController pushViewController:_scanViewController animated:YES];
    SAFE_RELEASE(_scanViewController);
}

- (IBAction)goToBookingView:(id)sender {
    BookingViewController *_bookViewController = [[BookingViewController alloc] initWithNibName:@"BookingViewController" bundle:nil];
    [self.navigationController pushViewController:_bookViewController animated:YES];
    SAFE_RELEASE(_bookViewController);
}

+ (MenuViewController *)shareInstance{
    if (gInstance == nil) {
        gInstance = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    }
    return gInstance;
}


@end
