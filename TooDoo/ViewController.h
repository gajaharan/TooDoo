//
//  ViewController.h
//  TooDoo
//
//  Created by Gajaharan Satkunanandan on 22/10/2016.
//  Copyright © 2016 Gajaharan Satkunanandan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTaskViewController.h"

@interface ViewController : UIViewController <AddTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) NSMutableArray *taskObjects;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)reorderBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)addTaskBarButtonItemPressed:(UIBarButtonItem *)sender;


@end

