// -*- mode:objc; c-basic-offset:2; indent-tabs-mode:nil -*-
/**
 * Copyright 2009-2012 ZXing authors All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ZXingWidgetController.h"
#import "Decoder.h"
#import "NSString+HTML.h"
#import "ResultParser.h"
#import "ParsedResult.h"
#import "ResultAction.h"
#import "TwoDDecoderResult.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>
#import "ProductObject.h"



#define CAMERA_SCALAR 1.12412 // scalar = (480 / (2048 / 480))
#define FIRST_TAKE_DELAY 1.0
#define ONE_D_BAND_HEIGHT 10.0

@interface ZXingWidgetController ()

@property BOOL showCancel;
@property BOOL showLicense;
@property BOOL oneDMode;
@property BOOL isStatusBarHidden;

- (void)initCapture;
- (void)stopCapture;

@end

@implementation ZXingWidgetController

#if HAS_AVFF
@synthesize captureSession;
@synthesize prevLayer;
#endif
@synthesize result, delegate, soundToPlay;
@synthesize overlayView;
@synthesize oneDMode, showCancel, showLicense, isStatusBarHidden;
@synthesize readers;


- (id)initWithDelegate:(id<ZXingDelegate>)scanDelegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode {
  /*!
   @note : TriHPM->License : NO 
   */
  return [self initWithDelegate:scanDelegate showCancel:shouldShowCancel OneDMode:shouldUseoOneDMode showLicense:NO];
}

- (id)initWithDelegate:(id<ZXingDelegate>)scanDelegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode showLicense:(BOOL)shouldShowLicense {
  self = [super init];
  if (self) {
    [self setDelegate:scanDelegate];
    self.oneDMode = shouldUseoOneDMode;
    self.showCancel = shouldShowCancel;
    self.showLicense = shouldShowLicense;
    self.wantsFullScreenLayout = YES;
    beepSound = -1;
    decoding = NO;

    /*!
    @note : TriHPM custome
    */
      
      _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MoApp-layout-BG2.png"]];
    
  OverlayView *theOverLayView = nil;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
     theOverLayView = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCAN, HEIGHT_SCAN)
                           cancelEnabled:NO//showCancel
                                oneDMode:oneDMode
                             showLicense:shouldShowLicense];
  }
  else{
      theOverLayView = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCAN_IPHONE, HEIGHT_SCAN_IPHONE)
                                            cancelEnabled:NO//showCancel
                                                 oneDMode:oneDMode
                                              showLicense:shouldShowLicense];
  }
      
//  [theOverLayView setBackgroundColor:[UIColor redColor]];
     
    [theOverLayView setDelegate:self];
    self.overlayView = theOverLayView;

    [theOverLayView release];
      

      
      
  }
  
  return self;
}



- (void)dealloc {
  if (beepSound != (SystemSoundID)-1) {
    AudioServicesDisposeSystemSoundID(beepSound);
  }
  
  [self stopCapture];
    SAFE_RELEASE(_background);
  [result release];
  [soundToPlay release];
  [overlayView release];
  [readers release];
    [_btBack release];
    [_tbvData release];
    [_lstData release];
  [super dealloc];
}

- (void)cancelled {
  [self stopCapture];
  if (!self.isStatusBarHidden) {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
  }

  wasCancelled = YES;
  if (delegate != nil) {
    [delegate zxingControllerDidCancel:self];
  }
}

- (void)submit{
   
}
- (NSString *)getPlatform {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char *machine = malloc(size);
  sysctlbyname("hw.machine", machine, &size, NULL, 0);
  NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
  free(machine);
  return platform;
}

- (BOOL)fixedFocus {
  NSString *platform = [self getPlatform];
  if ([platform isEqualToString:@"iPhone1,1"] ||
      [platform isEqualToString:@"iPhone1,2"]) return YES;
  return NO;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    /*!
     @note : TriHPM Nhung cai init nay dang de o viewDidAppear neu de viewdidload thi khi push vao
     se rat cham.
     Nhung neu bo viewDidAppear khi load lai view se addSubView 1 lan nua.(***)
     */
     [self.view addSubview:_background];
    [self initCapture];
    [self.view addSubview:overlayView];
    
    [overlayView setPoints:nil];
    wasCancelled = NO;
    /*!
     @note : TriHPM custome
     */
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _btBack = [[UIButton alloc] initWithFrame:CGRectMake(350, 50, 114, 33)];
        
        _btSubmit = [[UIButton alloc] initWithFrame:CGRectMake(550, 50, 114, 33)];
    }
    else{
        _btBack = [[UIButton alloc] initWithFrame:CGRectMake(180, 50, 50, 30)];
        _btSubmit = [[UIButton alloc] initWithFrame:CGRectMake(250, 50, 50, 30)];
    }

    [_btBack setBackgroundImage:[UIImage imageNamed:@"MoApp-layout-Recovered_11.png"] forState:UIControlStateNormal];
     [_btBack addTarget:self action:@selector(goToBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btBack];
    
//    [_btSubmit setBackgroundColor:[UIColor redColor]];
//    [_btSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    [_btSubmit setBackgroundImage:[UIImage imageNamed:@"MoApp-layout-Recovered_13.png"] forState:UIControlStateNormal];
    [_btSubmit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btSubmit];
    
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UILabel *_lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(520, 230, 100, 50)];
        _lblTitle.text = @"Summary";
        _lblTitle.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_lblTitle];
        SAFE_RELEASE(_lblTitle);
        _lbSumPrice = [[UILabel alloc] initWithFrame:CGRectMake(630, 230, 100, 50)];
    }
    else{
        UILabel *_lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(150, 100, 50, 50)];
        _lblTitle.text = @"Summary";
        _lblTitle.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_lblTitle];
        SAFE_RELEASE(_lblTitle);
        _lbSumPrice = [[UILabel alloc] initWithFrame:CGRectMake(180, 100, 100, 50)];
    }
    [_lbSumPrice setBackgroundColor:[UIColor clearColor]];
    [_lbSumPrice setText:@"$ 00"];
    [_lbSumPrice setTextAlignment:NSTextAlignmentCenter];

    [self.view addSubview:_lbSumPrice];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _tbvData = [[UITableView alloc] initWithFrame:CGRectMake(20, HEIGHT_SCAN + 45, 714, HEIGHT_MSCREEN- 60 -HEIGHT_SCAN)];
    }
    else{
        _tbvData = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT_SCAN_IPHONE, WIDTH_MSCREEN, HEIGHT_MSCREEN-HEIGHT_SCAN_IPHONE)];
    }
//    [_tbvData setBackgroundColor:[UIColor lightGrayColor]];
    [_tbvData setDataSource:self];
    [_tbvData setDelegate:self];
    _tbvData.backgroundColor = [UIColor clearColor];
    _tbvData.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tbvData];
    

    
//    SAFE_RELEASE(headerView);

    _lstData = [[NSMutableArray alloc] init];
    
//    //please remove me
//    ProductObject * product = [[ProductObject alloc] init];
//    [product setQRCode:@"abc"];
//    [product setName:@"trh"];
//    [product setPrice:@"fdsfs"];
//    product.quantum++;
//    [_lstData addObject:product];

    
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.wantsFullScreenLayout = YES;
  if ([self soundToPlay] != nil) {
    OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)[self soundToPlay], &beepSound);
    if (error != kAudioServicesNoError) {
      NSLog(@"Problem loading nearSound.caf");
    }
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.isStatusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
  if (!isStatusBarHidden)
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

  decoding = YES;
   
}
- (void)goToBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submit:(id)sender{

    NSString *listId = @"";
    NSString *listNumber = @"";

    NSUInteger count = 0;
    for (ProductObject *oneProduct in _lstData) {
        count++;
        if (count != [_lstData count]) {
            listId = [NSString stringWithFormat:@"%@|",oneProduct.name];
            listNumber = [NSString stringWithFormat:@"%d|",oneProduct.quantum];
        }else{
            listId = [NSString stringWithFormat:@"%@",oneProduct.name];
            listNumber = [NSString stringWithFormat:@"%d",oneProduct.quantum];
        }
    
    }
    
//    if (delegate != nil) {
        [delegate zxingSubmitWithListId:listId withListQuan:listNumber];
//    }
    NSLog(@"DATA %@",((ProductObject *)[_lstData objectAtIndex:0]).price);
}
- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  if (!isStatusBarHidden)
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
  [self.overlayView removeFromSuperview];
  [self stopCapture];
}

- (CGImageRef)CGImageRotated90:(CGImageRef)imgRef
{
  CGFloat angleInRadians = -90 * (M_PI / 180);
  CGFloat width = CGImageGetWidth(imgRef);
  CGFloat height = CGImageGetHeight(imgRef);
  
  CGRect imgRect = CGRectMake(0, 0, width, height);
  CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
  CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                 rotatedRect.size.width,
                                                 rotatedRect.size.height,
                                                 8,
                                                 0,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
  CGContextSetAllowsAntialiasing(bmContext, FALSE);
  CGContextSetInterpolationQuality(bmContext, kCGInterpolationNone);
  CGColorSpaceRelease(colorSpace);
  //      CGContextTranslateCTM(bmContext,
  //                                                +(rotatedRect.size.width/2),
  //                                                +(rotatedRect.size.height/2));
  CGContextScaleCTM(bmContext, rotatedRect.size.width/rotatedRect.size.height, 1.0);
  CGContextTranslateCTM(bmContext, 0.0, rotatedRect.size.height);
  CGContextRotateCTM(bmContext, angleInRadians);
  //      CGContextTranslateCTM(bmContext,
  //                                                -(rotatedRect.size.width/2),
  //                                                -(rotatedRect.size.height/2));
  CGContextDrawImage(bmContext, CGRectMake(0, 0,
                                           rotatedRect.size.width,
                                           rotatedRect.size.height),
                     imgRef);
  
  CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
  CFRelease(bmContext);
  [(id)rotatedImage autorelease];
  
  return rotatedImage;
}

- (CGImageRef)CGImageRotated180:(CGImageRef)imgRef
{
  CGFloat angleInRadians = M_PI;
  CGFloat width = CGImageGetWidth(imgRef);
  CGFloat height = CGImageGetHeight(imgRef);
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 8,
                                                 0,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
  CGContextSetAllowsAntialiasing(bmContext, FALSE);
  CGContextSetInterpolationQuality(bmContext, kCGInterpolationNone);
  CGColorSpaceRelease(colorSpace);
  CGContextTranslateCTM(bmContext,
                        +(width/2),
                        +(height/2));
  CGContextRotateCTM(bmContext, angleInRadians);
  CGContextTranslateCTM(bmContext,
                        -(width/2),
                        -(height/2));
  CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), imgRef);
  
  CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
  CFRelease(bmContext);
  [(id)rotatedImage autorelease];
  
  return rotatedImage;
}

// DecoderDelegate methods

- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset{
#if ZXING_DEBUG
  NSLog(@"DecoderViewController MessageWhileDecodingWithDimensions: Decoding image (%.0fx%.0f) ...", image.size.width, image.size.height);
#endif
}

- (void)decoder:(Decoder *)decoder
  decodingImage:(UIImage *)image
    usingSubset:(UIImage *)subset {
}

- (void)presentResultForString:(NSString *)resultString {
  self.result = [ResultParser parsedResultForString:resultString];
  if (beepSound != (SystemSoundID)-1) {
    AudioServicesPlaySystemSound(beepSound);
  }
#if ZXING_DEBUG
  NSLog(@"result string = %@", resultString);
#endif
}

- (void)presentResultPoints:(NSArray *)resultPoints
                   forImage:(UIImage *)image
                usingSubset:(UIImage *)subset {
  // simply add the points to the image view
  NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:resultPoints];
  [overlayView setPoints:mutableArray];
  [mutableArray release];
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)twoDResult {
  [self presentResultForString:[twoDResult text]];
  [self presentResultPoints:[twoDResult points] forImage:image usingSubset:subset];
  // now, in a selector, call the delegate to give this overlay time to show the points
  [self performSelector:@selector(notifyDelegate:) withObject:[[twoDResult text] copy] afterDelay:0.0];
  decoder.delegate = nil;
}
#pragma mark - Result
- (void)notifyDelegate:(id)text {
  if (!isStatusBarHidden) [[UIApplication sharedApplication] setStatusBarHidden:NO];
  [delegate zxingController:self didScanResult:text];
    NSArray *resultPr = [text componentsSeparatedByString:@"\n"];
    NSLog(@"%@",resultPr);
    if ([resultPr count]==4) {
        ProductObject *product = [self isItemExists:text];
        if (!product) {
            product = [[ProductObject alloc] init];
            [product setQRCode:text];
            [product setName:[resultPr objectAtIndex:0]];
            [product setPrice:[resultPr objectAtIndex:3]];
            product.quantum++;
            [_lstData addObject:product];
        }
        else{
            product.quantum++;
            NSLog(@"Quan : %d", product.quantum);
        }
        [_tbvData reloadData];
    }
    [self performSelector:@selector(delayScan) withObject:nil afterDelay:DELAY_SCAN];
  [text release];
}
- (void)delayScan
{
    decoding = !decoding;
    
}
- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason {
  decoder.delegate = nil;
  [overlayView setPoints:nil];
}

- (void)decoder:(Decoder *)decoder foundPossibleResultPoint:(CGPoint)point {
  [overlayView setPoint:point];
}

/*
  - (void)stopPreview:(NSNotification*)notification {
  // NSLog(@"stop preview");
  }

  - (void)notification:(NSNotification*)notification {
  // NSLog(@"notification %@", notification.name);
  }
*/

#pragma mark - 
#pragma mark AVFoundation

#include <sys/types.h>
#include <sys/sysctl.h>

// Gross, I know. But you can't use the device idiom because it's not iPad when running
// in zoomed iphone mode but the camera still acts like an ipad.
#if 0 && HAS_AVFF
static bool isIPad() {
  static int is_ipad = -1;
  if (is_ipad < 0) {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0); // Get size of data to be returned.
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
    free(name);
    is_ipad = [machine hasPrefix:@"iPad"];
  }
  return !!is_ipad;
}
#endif
    
- (void)initCapture {
#if HAS_AVFF
  AVCaptureDevice* inputDevice =
      [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  AVCaptureDeviceInput *captureInput =
      [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
  AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init]; 
  captureOutput.alwaysDiscardsLateVideoFrames = YES; 
  [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
  NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey; 
  NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; 
  NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key]; 
  [captureOutput setVideoSettings:videoSettings]; 
  self.captureSession = [[[AVCaptureSession alloc] init] autorelease];

  NSString* preset = 0;

#if 0
  // to be deleted when verified ...
  if (isIPad()) {
    if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
        [UIScreen mainScreen].scale > 1 &&
        [inputDevice
          supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
      preset = AVCaptureSessionPresetiFrame960x540;
    }
    if (false && !preset &&
        [inputDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetHigh]) {
      preset = AVCaptureSessionPresetHigh;
    }
  }
#endif

  if (!preset) {
    preset = AVCaptureSessionPresetMedium;
  }
  self.captureSession.sessionPreset = preset;

  [self.captureSession addInput:captureInput];
  [self.captureSession addOutput:captureOutput];

  [captureOutput release];

  if (!self.prevLayer) {
    self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
  }
  // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);

    /*!
     @note : TriHPM set frame
     */
//  self.prevLayer.frame = self.view.bounds;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.prevLayer setFrame:CGRectMake(0, 0, WIDTH_SCAN, HEIGHT_SCAN)];
    }
    else{
        [self.prevLayer setFrame:CGRectMake(0, 0, WIDTH_SCAN_IPHONE, HEIGHT_SCAN_IPHONE)];
    }
  self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  [self.view.layer addSublayer: self.prevLayer];

  [self.captureSession startRunning];
#endif
}

#if HAS_AVFF
- (void)captureOutput:(AVCaptureOutput *)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
       fromConnection:(AVCaptureConnection *)connection 
{
    /*!
     @note : TriHPM decoding:// chi chup dc 1 lan duy nhat
     */
  if (!decoding) {
    return;
  }
  CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
  /*Lock the image buffer*/
  CVPixelBufferLockBaseAddress(imageBuffer,0); 
  /*Get information about the image*/
  size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
  size_t width = CVPixelBufferGetWidth(imageBuffer); 
  size_t height = CVPixelBufferGetHeight(imageBuffer); 
    
  // NSLog(@"wxh: %lu x %lu", width, height);

  uint8_t* baseAddress = CVPixelBufferGetBaseAddress(imageBuffer); 
  void* free_me = 0;
  if (true) { // iOS bug?
    uint8_t* tmp = baseAddress;
    int bytes = bytesPerRow*height;
    free_me = baseAddress = (uint8_t*)malloc(bytes);
    baseAddress[0] = 0xdb;
    memcpy(baseAddress,tmp,bytes);
  }

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
  CGContextRef newContext =
      CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace,
                            kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);

  CGImageRef capture = CGBitmapContextCreateImage(newContext); 
  CVPixelBufferUnlockBaseAddress(imageBuffer,0);
  free(free_me);

  CGContextRelease(newContext); 
  CGColorSpaceRelease(colorSpace);

  if (false) {
    CGRect cropRect = [overlayView cropRect];
    if (oneDMode) {
      // let's just give the decoder a vertical band right above the red line
      cropRect.origin.x = cropRect.origin.x + (cropRect.size.width / 2) - (ONE_D_BAND_HEIGHT + 1);
      cropRect.size.width = ONE_D_BAND_HEIGHT;
      // do a rotate
      CGImageRef croppedImg = CGImageCreateWithImageInRect(capture, cropRect);
      CGImageRelease(capture);
      capture = [self CGImageRotated90:croppedImg];
      capture = [self CGImageRotated180:capture];
      //              UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:capture], nil, nil, nil);
      CGImageRelease(croppedImg);
      CGImageRetain(capture);
      cropRect.origin.x = 0.0;
      cropRect.origin.y = 0.0;
      cropRect.size.width = CGImageGetWidth(capture);
      cropRect.size.height = CGImageGetHeight(capture);
    }

    // N.B.
    // - Won't work if the overlay becomes uncentered ...
    // - iOS always takes videos in landscape
    // - images are always 4x3; device is not
    // - iOS uses virtual pixels for non-image stuff

    {
      float height = CGImageGetHeight(capture);
      float width = CGImageGetWidth(capture);

      NSLog(@"%f %f", width, height);

      CGRect screen = UIScreen.mainScreen.bounds;
      float tmp = screen.size.width;
      screen.size.width = screen.size.height;;
      screen.size.height = tmp;

      cropRect.origin.x = (width-cropRect.size.width)/2;
      cropRect.origin.y = (height-cropRect.size.height)/2;
    }

    NSLog(@"sb %@", NSStringFromCGRect(UIScreen.mainScreen.bounds));
    NSLog(@"cr %@", NSStringFromCGRect(cropRect));

    CGImageRef newImage = CGImageCreateWithImageInRect(capture, cropRect);
    CGImageRelease(capture);
    capture = newImage;
  }

  UIImage* scrn = [[[UIImage alloc] initWithCGImage:capture] autorelease];

  CGImageRelease(capture);

  Decoder* d = [[Decoder alloc] init];
  d.readers = readers;
  d.delegate = self;

  decoding = [d decodeImage:scrn] == YES ? NO : YES;

  [d release];

  if (decoding) {

    d = [[Decoder alloc] init];
    d.readers = readers;
    d.delegate = self;

    scrn = [[[UIImage alloc] initWithCGImage:scrn.CGImage
                                       scale:1.0
                                 orientation:UIImageOrientationLeft] autorelease];

    // NSLog(@"^ %@ %f", NSStringFromCGSize([scrn size]), scrn.scale);
    decoding = [d decodeImage:scrn] == YES ? NO : YES;

    [d release];
  }

}

#endif

- (void)stopCapture {
  decoding = NO;
#if HAS_AVFF
  [captureSession stopRunning];
  AVCaptureInput* input = [captureSession.inputs objectAtIndex:0];
  [captureSession removeInput:input];
  AVCaptureVideoDataOutput* output = (AVCaptureVideoDataOutput*)[captureSession.outputs objectAtIndex:0];
  [captureSession removeOutput:output];
  [self.prevLayer removeFromSuperlayer];

  self.prevLayer = nil;
  self.captureSession = nil;
#endif
}

#pragma mark - Torch

- (void)setTorch:(BOOL)status {
#if HAS_AVFF
  Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
  if (captureDeviceClass != nil) {
    
    AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [device lockForConfiguration:nil];
    if ( [device hasTorch] ) {
      if ( status ) {
        [device setTorchMode:AVCaptureTorchModeOn];
      } else {
        [device setTorchMode:AVCaptureTorchModeOff];
      }
    }
    [device unlockForConfiguration];
    
  }
#endif
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *headerView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MoApp-740x30.png"]] autorelease];
    headerView.frame = CGRectMake(0, 0, 714, 30);
    UILabel *_lblN0 = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 30, 30)];
    _lblN0.text = @"No";
    _lblN0.backgroundColor = [UIColor clearColor];
    _lblN0.textColor = [UIColor whiteColor];
    [headerView addSubview:_lblN0];
    SAFE_RELEASE(_lblN0);
    
    UILabel *_lblCode = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 60, 30)];
    _lblCode.text = @"Code";
    _lblCode.backgroundColor = [UIColor clearColor];
    _lblCode.textColor = [UIColor whiteColor];
    [headerView addSubview:_lblCode];
    SAFE_RELEASE(_lblCode);
    
    UILabel *_lblDeviceName = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, 200, 30)];
    _lblDeviceName.text = @"Device Name";
    _lblDeviceName.backgroundColor = [UIColor clearColor];
    _lblDeviceName.textColor = [UIColor whiteColor];
    [headerView addSubview:_lblDeviceName];
    SAFE_RELEASE(_lblDeviceName);
    
    UILabel *_lblQuantity = [[UILabel alloc] initWithFrame:CGRectMake(580, 0, 60, 30)];
    _lblQuantity.text = @"Qua";
    _lblQuantity.backgroundColor = [UIColor clearColor];
    _lblQuantity.textColor = [UIColor whiteColor];
    [headerView addSubview:_lblQuantity];
    SAFE_RELEASE(_lblQuantity);
    
    UILabel *_lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(650, 0, 50, 30)];
    _lblPrice.text = @"Total";
    _lblPrice.backgroundColor = [UIColor clearColor];
    _lblPrice.textColor = [UIColor whiteColor];
    [headerView addSubview:_lblPrice];
    SAFE_RELEASE(_lblPrice);
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_lstData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ProductObject *item = [_lstData objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        int xRatio = -10;
        
        if (indexPath.row %2 == 0) {
            UIImageView *_backgroundTemp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MoApp-714x68 (2).png"]];
            _backgroundTemp.frame = CGRectMake(0, 0, 714, 68);
            [cell.contentView addSubview:_backgroundTemp];
            SAFE_RELEASE(_backgroundTemp);
        }else{
            UIImageView *_backgroundTemp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MoApp-714x68.png"]];
            _backgroundTemp.frame = CGRectMake(0, 0, 714, 68);
            [cell.contentView addSubview:_backgroundTemp];
            SAFE_RELEASE(_backgroundTemp);
        }
        UILabel *lbNo = nil;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            lbNo = [[UILabel alloc] initWithFrame:CGRectMake(xRatio, 0, 50, 50)];
        }
        else{
            lbNo = [[UILabel alloc] initWithFrame:CGRectMake(xRatio, 0, 50, 50)];
        }
        [lbNo setTag:1];
        [lbNo setBackgroundColor:[UIColor clearColor]];
        [lbNo setTextAlignment:NSTextAlignmentCenter];
        [lbNo setText:[NSString stringWithFormat:@"%0.2d",indexPath.row + 1]];
        [cell.contentView addSubview:lbNo];
        
        xRatio += CGRectGetWidth(lbNo.frame);
        UILabel *lbQRCode = nil;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            lbQRCode = [[UILabel alloc] initWithFrame:CGRectMake(xRatio, 0, 200, 50)];
        }
        else {
            lbQRCode = [[UILabel alloc] initWithFrame:CGRectMake(xRatio, 0, 60, 50)];
        }
        [lbQRCode setTag:2];
        [lbQRCode setBackgroundColor:[UIColor clearColor]];
        [lbQRCode setText:[NSString stringWithFormat:@"%@",item.qRCode]];
        [cell.contentView addSubview:lbQRCode];
        
        xRatio += CGRectGetWidth(lbQRCode.frame);
        UILabel *lbName = nil;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            lbName = [[UILabel alloc] initWithFrame:CGRectMake(xRatio, 0, 320, 50)];
        }
        else {
            lbName = [[UILabel alloc] initWithFrame:CGRectMake(xRatio, 0, 70, 50)];
        }
        [lbName setTag:3];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setText:[NSString stringWithFormat:@"%@",item.name]];
        [cell.contentView addSubview:lbName];
        
        xRatio += CGRectGetWidth(lbName.frame);
        UILabel *lbQua = nil;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            lbQua = [[UILabel alloc] initWithFrame:CGRectMake(xRatio, 0, 80, 50)];
        }
        else {
            lbQua = [[UILabel alloc] initWithFrame:CGRectMake(xRatio, 0, 50, 50)];
        }
        [lbQua setTag:4];
        [lbQua setBackgroundColor:[UIColor clearColor]];
        [lbQua setTextAlignment:NSTextAlignmentCenter];
        [lbQua setText:[NSString stringWithFormat:@"%d",item.quantum]];
        [cell.contentView addSubview:lbQua];
        
        xRatio += CGRectGetWidth(lbQua.frame);
        UILabel *lbPrice = nil;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(xRatio, 0, WIDTH_MSCREEN-xRatio, 50)];
        }
        else {
            lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(xRatio, 0, WIDTH_MSCREEN-xRatio, 50)];
        }
        [lbPrice setTag:5];
        [lbPrice setBackgroundColor:[UIColor clearColor]];
        [lbPrice setText:[NSString stringWithFormat:@"%@",item.price]];
        [cell.contentView addSubview:lbPrice];
        
        SAFE_RELEASE(lbNo);
        SAFE_RELEASE(lbQRCode);
        SAFE_RELEASE(lbName);
        SAFE_RELEASE(lbQua);
        SAFE_RELEASE(lbPrice);
        
    }
    else{
        UILabel *lbuNo = (UILabel*)[cell.contentView viewWithTag:1];
        [lbuNo setText:[NSString stringWithFormat:@"%0.2d",indexPath.row + 1]];
        
        UILabel *lbuQRCode = (UILabel*)[cell.contentView viewWithTag:2];
        [lbuQRCode setText:[NSString stringWithFormat:@"%@",item.qRCode]];
        
        UILabel *lbuName = (UILabel*)[cell.contentView viewWithTag:3];
        [lbuName setText:[NSString stringWithFormat:@"%@",item.name]];
        
        UILabel *lbuQua = (UILabel*)[cell.contentView viewWithTag:4];
        [lbuQua setText:[NSString stringWithFormat:@"%d",item.quantum]];
        
        UILabel *lbuPrice = (UILabel*)[cell.contentView viewWithTag:5];
        [lbuPrice setText:[NSString stringWithFormat:@"%@",item.price]];
    }
   
    [self sumPriceOfProduct];
    return cell;
}
- (BOOL)torchIsOn {
#if HAS_AVFF
  Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
  if (captureDeviceClass != nil) {
    
    AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ( [device hasTorch] ) {
      return [device torchMode] == AVCaptureTorchModeOn;
    }
    [device unlockForConfiguration];
  }
#endif
  return NO;
}
-(ProductObject *)isItemExists:(NSString *)item
{
    for (ProductObject *tmp in _lstData) {
        if ([tmp.qRCode isEqualToString:item]) {
            return tmp;
        }
    }
    return nil;
}
-(void)sumPriceOfProduct
{
    float sum = [[[_lbSumPrice.text componentsSeparatedByString:@"$"] lastObject] floatValue];
    for (ProductObject *tmp in _lstData) {
        NSArray *price = [tmp.price componentsSeparatedByString:@"$"];
        if ([price count] > 1) {
            float p = [[price lastObject] floatValue];
            sum += p;
        }
    }
    if (sum == 0) {
        [_lbSumPrice setText:[NSString stringWithFormat:@"$ 00"]];
    }
    else{
        [_lbSumPrice setText:[NSString stringWithFormat:@"$ %.2f", sum]];
    }
    
}
@end
