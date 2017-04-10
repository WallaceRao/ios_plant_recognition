//
//  DetailViewController.h
//  testMaster
//
//  Created by administrator on 4/11/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

