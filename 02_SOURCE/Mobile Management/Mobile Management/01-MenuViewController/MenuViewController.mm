//
//  MenuViewController.m
//  Mobile Management
//
//  Created by TranTo on 6/28/13.
//  Copyright (c) 2013 TranTo. All rights reserved.
//

#import "MenuViewController.h"
#import <MultiFormatReader.h>
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

- (void)viewWillAppear:(BOOL)animated{
    NSString *vUserDefault = [[NSUserDefaults standardUserDefaults] objectForKey:User_Default_First_Time_Installation_Key];
    _btnBooking.enabled = NO;
    _btnCheckout.enabled = NO;
    if (vUserDefault) {
        
        _btnDone.titleLabel.text = @"Reset";
       
        _btnBooking.enabled = YES;
        _btnCheckout.enabled = YES;
    }else{
        _btnDone.titleLabel.text = @"Done";
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
static MenuViewController *gInstance = nil;

- (IBAction)CompleteStorename:(id)sender {

    if ([Inspiration_FunctionHelper isEmpty:txtStorename.text]) {
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Name" message:@"Please rewirte your store name" completionBlock:^(UIAlertView *alertView, NSUInteger buttonIndex) {
            
        } cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [messageAlert show];
        SAFE_RELEASE(messageAlert);
    }else{
        NSString *vUserDefault = [[NSUserDefaults standardUserDefaults] objectForKey:User_Default_First_Time_Installation_Key];
        if (vUserDefault) {
            txtStorename.text = @"";
            txtStorename.enabled = YES;
            _btnDone.titleLabel.text = @"Done";
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:User_Default_First_Time_Installation_Key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _btnBooking.enabled = NO;
            _btnCheckout.enabled = NO;
        }else{
            @autoreleasepool {
                if ([_btnDone.titleLabel.text isEqualToString:@"Done"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:txtStorename.text forKey:User_Default_First_Time_Installation_Key];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                     txtStorename.enabled = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                         _btnDone.titleLabel.text = @"Reset";
                    });
                    
                }
                _btnBooking.enabled = YES;
                _btnCheckout.enabled = YES;
               
            }
       
        
        }
    }
}

- (IBAction)goToScanView:(id)sender {
    
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    MultiFormatReader* qrcodeReader = [[MultiFormatReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    [qrcodeReader release];
    widController.readers = readers;
    [readers release];
    NSBundle *mainBundle = [NSBundle mainBundle];
    widController.soundToPlay =
    [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
    
    [self.navigationController pushViewController:widController animated:YES];
    
    SAFE_RELEASE(widController);
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

#pragma mark - ZXingDelegate
- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
    DLog(@"Result : %@", result);
}
- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{

}

- (void)dealloc {
    [txtStorename release];
    [_btnCheckout release];
    [_btnBooking release];
    [_btnDone release];
    [super dealloc];
}
- (void)viewDidUnload {
    [txtStorename release];
    txtStorename = nil;
    [_btnCheckout release];
    _btnCheckout = nil;
    [_btnBooking release];
    _btnBooking = nil;
    [_btnDone release];
    _btnDone = nil;
    [super viewDidUnload];
}
@end
