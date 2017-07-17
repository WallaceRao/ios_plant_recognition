//
//  DetailViewController.m
//  testMaster
//
//  Created by administrator on 4/11/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController



- (void)configureView {
    // Update the user interface for the detail item.
    if (self.url) {
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:request];

    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(NSDate *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}



- (void)setUrl:(NSString *)newUrl {
    if (_url!= newUrl) {
        _url = newUrl;
        
        // Update the view.
        [self configureView];
    }
}





@end
