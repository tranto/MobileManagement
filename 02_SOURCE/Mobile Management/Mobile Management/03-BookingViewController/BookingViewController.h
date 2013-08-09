//
//  BookingViewController.h
//  Mobile Management
//
//  Created by TranTo on 6/28/13.
//  Copyright (c) 2013 TranTo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingViewController : UIViewController{
    
    IBOutlet UIButton *btnAn;
    IBOutletCollection(UIButton) NSArray *btnBG;
    IBOutlet UIButton *btnOnOff;
    IBOutlet UIButton *btnCharger;
    
    IBOutlet UIButton *btnCircuit;
    
    IBOutlet UIButton *btnSoftware;
    
    IBOutlet UIButton *btnTo;
    
    IBOutlet UIButton *btnKeypad;
    
    IBOutlet UIButton *btnMul;
    
    IBOutlet UIButton *btnCirCleaning;
    
    IBOutlet UIButton *btnVolume;
    
    IBOutlet UIButton *btnHousing;
    
    IBOutlet UIButton *btnCamera;
    
    IBOutlet UIButton *btnBuzz;
    
    IBOutlet UIButton *btnribbon;
    
    IBOutlet UIButton *btnLCD;
    
    IBOutlet UIButton *btnConnectoe;
    
    IBOutlet UIButton *btnResister;
    
    IBOutlet UIButton *btnLight;
    
    IBOutlet UIButton *btnCap;
    
    IBOutlet UIButton *btnMic;
    
    IBOutlet UIButton *btnSpeaker;
    
    
    IBOutlet UIButton *btnVibration;
    

    IBOutlet UIButton *btnBGA;
    
}
- (IBAction)goToMenu:(id)sender;
- (IBAction)toggle:(id)sender;

- (IBAction)showDatePicker:(id)sender;

@end
