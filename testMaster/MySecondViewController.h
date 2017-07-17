//
//  MySecondViewController.h
//  testMaster
//
//  Created by administrator on 4/17/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyImageIdentViewController.h"

@interface MySecondViewController : MyImageIdentViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *repick;
@property (weak, nonatomic) IBOutlet UIButton *recognise;



@end
