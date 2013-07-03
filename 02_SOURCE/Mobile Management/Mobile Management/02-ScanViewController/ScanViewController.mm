//
//  ScanViewController.m
//  Mobile Management
//
//  Created by TranTo on 6/28/13.
//  Copyright (c) 2013 TranTo. All rights reserved.
//

#import "ScanViewController.h"
#import <MultiFormatReader.h>
@interface ScanViewController ()

@end

@implementation ScanViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)goToScan:(id)sender {
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    MultiFormatReader* qrcodeReader = [[MultiFormatReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    [qrcodeReader release];
    widController.readers = readers;
    [readers release];
    NSBundle *mainBundle = [NSBundle mainBundle];
    widController.soundToPlay =
    [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];

    [self presentViewController:widController animated:YES completion:nil];
    
    [widController release];
    
}

#pragma mark - ZXingDelegate
- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
    DLog(@"Result : %@", result);
}
- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
