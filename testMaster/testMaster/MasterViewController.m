//
//  MasterViewController.m
//  testMaster
//
//  Created by administrator on 4/11/17.
//  Copyright © 2017 administrator. All rights reserved.
//



#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@property NSMutableDictionary *images;
@property NSMutableDictionary *urls;



@end

@implementation MasterViewController

- (void) initPlants
{
    self.images = [[NSMutableDictionary alloc] init];
    self.urls = [[NSMutableDictionary alloc] init];
    
    
    self.urls[@"Beech forest"] = @"http://www.doc.govt.nz/nature/native-plants/beech-forest/";
    self.urls[@"Cabbage tree"] = @"http://www.doc.govt.nz/nature/native-plants/cabbage-tree-ti-kouka/";
    self.urls[@"Chatham Island Christmas tree"] = @"http://www.doc.govt.nz/nature/native-plants/chatham-island-christmas-tree/";
    
    self.urls[@"Chatham Island forget-me-not"] = @"http://www.doc.govt.nz/nature/native-plants/chatham-island-forget-me-not/";
    self.urls[@"Chatham Islands plants"] = @"http://www.doc.govt.nz/nature/native-plants/chatham-islands-plants/";
    self.urls[@"Coastal cress"] = @"http://www.doc.govt.nz/nature/native-plants/coastal-cress/";
    
    self.urls[@"Dactylanthus"] = @"http://www.doc.govt.nz/nature/native-plants/dactylanthus/";
    self.urls[@"New Zealand ferns"] = @"http://www.doc.govt.nz/nature/native-plants/ferns/";
    self.urls[@"Freshwater algae"] = @"http://www.doc.govt.nz/nature/native-plants/freshwater-algae/";
    
    self.urls[@"Golden sand sedge"] = @"http://www.doc.govt.nz/nature/native-plants/golden-sand-sedge-pikao-pingao/";
    self.urls[@"Harakeke"] = @"http://www.doc.govt.nz/nature/native-plants/harakeke-flax/";
    self.urls[@"Kakabeak"] = @"http://www.doc.govt.nz/nature/native-plants/kakabeak/";
    
    self.urls[@"Kauri"] = @"http://www.doc.govt.nz/nature/native-plants/kauri/";
    self.urls[@"Kettle hole plants"] = @"http://www.doc.govt.nz/nature/native-plants/kettle-hole-plants/";
    self.urls[@"Kōwhai"] = @"http://www.doc.govt.nz/nature/native-plants/kowhai/";
    
    
    //UIImage *image = [UIImage imageNamed:@"plants/Beech forest.jpg"];
    self.images[@"Beech forest"] = [UIImage imageNamed:@"plants/Beech forest.jpg"];
    self.images[@"Cabbage tree"] = [UIImage imageNamed:@"plants/Cabbage tree.jpg"];
    self.images[@"Chatham Island Christmas tree"] = [UIImage imageNamed:@"plants/Chatham Island Christmas tree.jpg"];
    
    self.images[@"Chatham Island forget-me-not"] = [UIImage imageNamed:@"plants/Chatham Island forget-me-not.jpg"];
    self.images[@"Chatham Islands plants"] = [UIImage imageNamed:@"plants/Chatham Islands plants.jpg"];
    self.images[@"Coastal cress"] = [UIImage imageNamed:@"plants/Coastal cress.jpg"];
    
    self.images[@"Dactylanthus"] = [UIImage imageNamed:@"plants/Dactylanthus.jpg"];
    self.images[@"New Zealand ferns"] = [UIImage imageNamed:@"plants/New Zealand ferns.jpeg"];
    self.images[@"Freshwater algae"] = [UIImage imageNamed:@"plants/Freshwater algae.jpg"];
    
    self.images[@"Golden sand sedge"] = [UIImage imageNamed:@"plants/Golden sand sedge.jpeg"];
    self.images[@"Harakeke"] = [UIImage imageNamed:@"plants/Harakeke.jpg"];
    self.images[@"Kakabeak"] = [UIImage imageNamed:@"plants/Kakabeak.JPG"];
    
    self.images[@"Kauri"] = [UIImage imageNamed:@"plants/kauri.jpg"];
    self.images[@"Kettle hole plants"] = [UIImage imageNamed:@"plants/Kettle hole plants.jpg"];
    self.images[@"Kōwhai"] = [UIImage imageNamed:@"plants/kowhai.jpg"];

   
    return;
}








- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
   // self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self initPlants];
    for (int i = 0; i < [[self.images allKeys] count]; i++) {
        [self insertNewObject:nil];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)insertNewObject:(id)sender {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSArray *plantNames = [self.images allKeys];
        NSString *name = [plantNames objectAtIndex:indexPath.row];
        NSString *url = [self.urls objectForKey:name];
        
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        [controller setUrl:url];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.images allKeys] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];


    NSArray *plantNames = [self.images allKeys];
    NSString *name = [plantNames objectAtIndex:indexPath.row];
    UIImage *plantImage = [self.images objectForKey:name];

    if(!name || !plantImage)
    {
        return nil;
    }
    
    [cell.imageView setImage:plantImage];
    
    CGSize itemSize = CGSizeMake(80, 60);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    cell.textLabel.text = name;
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
