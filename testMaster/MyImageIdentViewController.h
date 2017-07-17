//
//  MyImageIdentViewController.h
//  testMaster
//
//  Created by administrator on 4/20/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyImageIdentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITextView *labelResults;
- (NSString *) base64EncodeImage: (UIImage*)image;
- (void) createRequest: (NSString*)imageData;
- (void)runRequestOnBackgroundThread: (NSMutableURLRequest*) request;
- (void)analyzeResults: (NSData*)dataToParse;
@end
