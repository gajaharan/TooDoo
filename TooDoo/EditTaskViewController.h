//
//  EditTaskViewController.h
//  TooDoo
//
//  Created by Gajaharan Satkunanandan on 22/10/2016.
//  Copyright © 2016 Gajaharan Satkunanandan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"


@protocol EditTaskViewControllerDelegate <NSObject>

-(void) didUpdateTask;

@end
@interface EditTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) Task *task;
@property (weak, nonatomic) id <EditTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)saveBarButtonPressed:(UIBarButtonItem *)sender;
@end
