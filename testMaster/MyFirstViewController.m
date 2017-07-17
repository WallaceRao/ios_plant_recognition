//
//  MyFirstViewController.m
//  testMaster
//
//  Created by administrator on 4/17/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MyFirstViewController.h"
#include <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>


#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0
#define preViewOriginX 20
#define preViewOriginY 100
#define preViewSizeWidth (kScreenWidth-40)
#define preViewSizeHeight (kScreenHeight-250)

@interface MyFirstViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property(nonatomic)AVCaptureDevice *device;
@property(nonatomic)AVCaptureDeviceInput *input;
@property(nonatomic)AVCaptureMetadataOutput *output;
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;
@property(nonatomic)AVCaptureSession *session;


@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic)UIButton *PhotoButton;

@property (nonatomic)UIButton *confirmButton;
@property (nonatomic)UIButton *cancelButton;

@property (nonatomic)UIImageView *photoView;
@property (nonatomic)UIView *focusView;
@property (nonatomic)UIImage *image;


@property (nonatomic)BOOL canCa;


@end




@implementation MyFirstViewController

- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || AVAuthorizationStatusRestricted == authStatus) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                NSLog(@"已授权");
            } else {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            }
        }];
    } else{
        return YES;
    }
    return YES;
}



- (void)customUI{
    _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _PhotoButton.frame = CGRectMake(kScreenWidth*1/2.0-30, kScreenHeight-130, 60, 60);
    UIImage *photoImage = [UIImage imageNamed:@"takephoto.png"];
    [_PhotoButton setImage:photoImage forState: UIControlStateNormal];
   // [_PhotoButton setImage:[UIImage imageNamed:@"takephoto.png"] forState:UIControlStateNormal];
    [_PhotoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_PhotoButton];
    
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = CGRectMake(kScreenWidth-110, kScreenHeight-130, 80, 60);
    //[_confirmButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
   // [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(onConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    [_confirmButton setHidden:YES];
    [_confirmButton setAttributedTitle:[self UnderLineTextString:@"Confirm"]
                          forState:UIControlStateNormal];
    
    
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_cancelButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    _cancelButton.frame = CGRectMake(30, kScreenHeight-130, 80, 60);
   // [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    [_cancelButton setHidden:YES];
    [_cancelButton setAttributedTitle:[self UnderLineTextString:@"Cancel"]
                              forState:UIControlStateNormal];
    
    
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_focusView];
    _focusView.hidden = YES;

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(NSMutableAttributedString *)UnderLineTextString:(NSString *)str
{
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [titleString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:NSMakeRange(0, [titleString length])];// set your text lenght..
    [titleString addAttribute:NSForegroundColorAttributeName value:self.view.tintColor range:NSMakeRange(0, [titleString length])];
    
    return titleString;
}







- (void)customCamera{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //使用设备初始化输入
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(preViewOriginX, preViewOriginY, preViewSizeWidth, preViewSizeHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    //[self.view setHidden:YES];
    [self.imageView setHidden:YES];
    [self.recognise setHidden:YES];
    [self.retake setHidden:YES];
    
    //开始启动
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _canCa = [self canUserCamear];
    if (_canCa) {
        [self customCamera];
        [self customUI];
        
    }else{
        return;
    }
    [self.recognise addTarget:self action:@selector(onRecognise) forControlEvents:UIControlEventTouchUpInside];
    [self.retake addTarget:self action:@selector(onRetake) forControlEvents:UIControlEventTouchUpInside];
    
    
    /*相册权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        //无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
     */


}
- (void)viewDidAppear:(BOOL)animated
{
    
 
}




- (void)onRecognise
{
    
}

- (void)onRetake
{
    if(self.photoView)
    {
        [self.photoView removeFromSuperview];
        self.photoView = nil;
    }
    [self.imageView setHidden:YES];
    [self.recognise setHidden:YES];
    [self.retake setHidden:YES];
    [_PhotoButton setHidden:NO];
    [_confirmButton setHidden:YES];
    [_cancelButton setHidden:YES];
    [self.view.layer addSublayer:self.previewLayer];
    [self.session startRunning];
    [self.labelResults setHidden:YES];
    
}





- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}


- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    if (!(preViewOriginX <= point.x && point.x <= preViewOriginX + preViewSizeWidth) ||
        !(preViewOriginY <= point.y && point.y <= preViewOriginY + preViewSizeHeight)) {
        return;
    }
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
    
}


- (void) shutterCamera
{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        [self.session stopRunning];
      //  [self saveImageToPhotoAlbum:self.image];
        if(!self.photoView)
            self.photoView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        [self.view insertSubview:_imageView belowSubview:_PhotoButton];
        self.photoView.layer.masksToBounds = YES;
        self.photoView.image = _image;
        NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
        [_confirmButton setHidden:NO];
        [_cancelButton setHidden:NO];
        
       
    }];
}



- (void) onCancel
{
    if(self.photoView)
    {
        [self.photoView removeFromSuperview];
        self.photoView = nil;
    }
    [_confirmButton setHidden:YES];
    [_cancelButton setHidden:YES];
    [self.view.layer addSublayer:self.previewLayer];
    [self.session startRunning];
}



- (void) onConfirmBtn
{
    [_PhotoButton setHidden:YES];
    [_confirmButton setHidden:YES];
    [_cancelButton setHidden:YES];
    [self.imageView setHidden:NO];
    [self.recognise setHidden:NO];
    [self.retake setHidden:NO];
    [[self imageView] setImage:_image];
    [self.session stopRunning];
    [self.previewLayer removeFromSuperlayer];
    [self.labelResults setHidden: YES];
    [self.spinner setHidden:NO];
    [self.spinner startAnimating];
    
    // Base64 encode the image and create the request
    NSString *binaryImageData = [self base64EncodeImage:self.image];
    [self createRequest:binaryImageData];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)unwindToFirstViewController:(UIStoryboardSegue *)unwindSegue
{
}




@end
