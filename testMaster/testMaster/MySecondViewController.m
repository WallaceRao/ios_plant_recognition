//
//  MySecondViewController.m
//  testMaster
//
//  Created by administrator on 4/17/17.
//  Copyright © 2017 administrator. All rights reserved.
//



#import "MySecondViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface MySecondViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
     UIImagePickerController *_imagePickerController;
}

@end

@implementation MySecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    [self.recognise addTarget:self action:@selector(onRecognise) forControlEvents:UIControlEventTouchUpInside];
    [self.repick addTarget:self action:@selector(onRepick) forControlEvents:UIControlEventTouchUpInside];
    
    // [self selectImageFromAlbum];
    
}


- (void)onRecognise
{
    
}

- (void)onRepick
{
    [self selectImageFromAlbum];
}

- (IBAction)unwindToSecondViewController:(UIStoryboardSegue *)unwindSegue
{
}





- (void)viewDidAppear:(BOOL)animated
{   static bool firstLaunched = false;
    [super viewDidAppear:animated];
    if(!firstLaunched)
    {
        [self selectImageFromAlbum];
        firstLaunched = YES;
        
    }
    
    
}

- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
 
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //UIImage
        self.imageView.image = info[UIImagePickerControllerEditedImage];
        [self.labelResults setHidden:YES];
        [self.spinner setHidden:NO];
        
        [self.spinner startAnimating];
        
        // Base64 encode the image and create the request
        NSString *binaryImageData = [self base64EncodeImage:self.imageView.image];
        [self createRequest:binaryImageData];

        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
