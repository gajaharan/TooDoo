//
//  DetailTaskViewController.h
//  TooDoo
//
//  Created by Gajaharan Satkunanandan on 22/10/2016.
//  Copyright © 2016 Gajaharan Satkunanandan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "EditTaskViewController.h"

@protocol DetailTaskViewControllerDelegate <NSObject>

-(void)updateTask;

@end
@interface DetailTaskViewController : UIViewController<EditTaskViewControllerDelegate>

@property  (strong, nonatomic) Task *task;
@property (weak, nonatomic) id <DetailTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender;

@end
