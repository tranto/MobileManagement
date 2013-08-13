//
//  BookingViewController.m
//  Mobile Management
//
//  Created by TranTo on 6/28/13.
//  Copyright (c) 2013 TranTo. All rights reserved.
//

#import "BookingViewController.h"

@interface BookingViewController ()

@end

@implementation BookingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         
        [btnBuzz setImage:[UIImage imageNamed:@"Buzz-38x24-on.png"] forState:UIControlStateSelected];
    
        [btnCamera setImage:[UIImage imageNamed:@"Camera-63x24-on.png"] forState:UIControlStateSelected];
    
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

- (IBAction)goToMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - toggleButton
- (IBAction)toggle:(id)sender {
    if (sender == btnAn) {
        btnAn.selected = !btnAn.selected;
        btnBGA.selected = !btnAn.selected;
        btnBuzz.selected = !btnAn.selected;
        btnCamera.selected = !btnAn.selected;
        btnCap.selected = !btnAn.selected;
        btnCharger.selected = !btnAn.selected;
        btnCirCleaning.selected = !btnAn.selected;
        btnCircuit.selected = !btnAn.selected;
        btnConnectoe.selected = !btnAn.selected;
        btnHousing.selected = !btnAn.selected;
        btnKeypad.selected = !btnAn.selected;
        btnLCD.selected =!btnAn.selected;
        btnLight.selected = !btnAn.selected;
        btnMic.selected = !btnAn.selected;
        btnMul.selected = !btnAn.selected;
        btnOnOff.selected = !btnAn.selected;
        btnResister.selected = !btnAn.selected;
        btnribbon.selected = !btnAn.selected;
        btnSoftware.selected = !btnAn.selected;
        btnSpeaker.selected = !btnAn.selected;
        btnTo.selected = !btnAn.selected;
        btnVibration.selected = !btnAn.selected;
        btnVolume.selected = !btnAn.selected;
    
    }else if(sender == btnBGA){
        btnBGA.selected = !btnBGA.selected;
        btnBGA.highlighted = YES;
        if (btnBGA.selected) {
             [btnBGA setBackgroundImage:[UIImage imageNamed:@"BGAIC-52x24-on.png"] forState:UIControlStateSelected];
        }
        else{
            [btnBGA setBackgroundImage:[UIImage imageNamed:@"BGAIC-52x24.png"] forState:UIControlStateNormal];
        }
        btnAn.selected = !btnBGA.selected;
        
        btnBuzz.selected = !btnBGA.selected;
        btnCamera.selected = !btnBGA.selected;
        btnCap.selected = !btnBGA.selected;
        btnCharger.selected = !btnBGA.selected;
        btnCirCleaning.selected = !btnBGA.selected;
        btnCircuit.selected = !btnBGA.selected;
        btnConnectoe.selected = !btnBGA.selected;
        btnHousing.selected = !btnBGA.selected;
        btnKeypad.selected = !btnBGA.selected;
        btnLCD.selected =!btnBGA.selected;
        btnLight.selected = !btnBGA.selected;
        btnMic.selected = !btnBGA.selected;
        btnMul.selected = !btnBGA.selected;
        btnOnOff.selected = !btnBGA.selected;
        btnResister.selected = !btnBGA.selected;
        btnribbon.selected = !btnBGA.selected;
        btnSoftware.selected = !btnBGA.selected;
        btnSpeaker.selected = !btnBGA.selected;
        btnTo.selected = !btnBGA.selected;
        btnVibration.selected = !btnBGA.selected;
        btnVolume.selected = !btnBGA.selected;
    }else if((UIButton *)sender == btnBGA){
        dispatch_async(dispatch_get_main_queue(), ^{
           
//            [btnBGA setImage:[UIImage imageNamed:@"BGAIC-52x24-on.png"] forState:UIControlStateSelected];
        });
       
    }
}
#pragma mark - show DatePicker
- (IBAction)showDatePicker:(id)sender {
    UIDatePicker *datePicker = [[[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 400, 300, 400)] autorelease];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [self.view addSubview:datePicker];
}
- (void)dealloc {
    [btnAn release];
    [btnBG release];
    [btnOnOff release];
    [btnCharger release];
    [btnCircuit release];
    [btnSoftware release];
    [btnTo release];
    [btnKeypad release];
    [btnMul release];
    [btnCirCleaning release];
    [btnVolume release];
    [btnHousing release];
    [btnCamera release];
    [btnLCD release];
    [btnribbon release];
    [btnBuzz release];
    [btnConnectoe release];
    [btnResister release];
    [btnLight release];
    [btnCap release];
    [btnMic release];
    [btnSpeaker release];
    [btnVibration release];
    [btnBG release];
    [btnBGA release];
    
    [super dealloc];
}
- (void)viewDidUnload {
    [btnAn release];
    btnAn = nil;
    [btnBG release];
    btnBG = nil;
    [btnOnOff release];
    btnOnOff = nil;
    [btnCharger release];
    btnCharger = nil;
    [btnCircuit release];
    btnCircuit = nil;
    [btnSoftware release];
    btnSoftware = nil;
    [btnTo release];
    btnTo = nil;
    [btnKeypad release];
    btnKeypad = nil;
    [btnMul release];
    btnMul = nil;
    [btnCirCleaning release];
    btnCirCleaning = nil;
    [btnVolume release];
    btnVolume = nil;
    [btnHousing release];
    btnHousing = nil;
    [btnCamera release];
    btnCamera = nil;
    [btnLCD release];
    btnLCD = nil;
    [btnribbon release];
    btnribbon = nil;
    [btnBuzz release];
    btnBuzz = nil;
    [btnConnectoe release];
    btnConnectoe = nil;
    [btnResister release];
    btnResister = nil;
    [btnLight release];
    btnLight = nil;
    [btnCap release];
    btnCap = nil;
    [btnMic release];
    btnMic = nil;
    [btnSpeaker release];
    btnSpeaker = nil;
    [btnVibration release];
    btnVibration = nil;
    [btnBG release];
    btnBG = nil;
    [btnBGA release];
    btnBGA = nil;
    
    [super viewDidUnload];
}






@end
