//
//  AddTaskViewController.m
//  TooDoo
//
//  Created by Gajaharan Satkunanandan on 22/10/2016.
//  Copyright © 2016 Gajaharan Satkunanandan. All rights reserved.
//

#import "AddTaskViewController.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(Task *)returnNewTaskObject {
    Task *task = [[Task alloc]init];
    task.title = self.textField.text;
    task.decription = self.textView.text;
    task.date = self.datePicker.date;
    task.isCompleted = NO;
    
    return task;
}

- (IBAction)addTaskButtonPressed:(UIButton *)sender {
    [self.delegate didAddTask:[self returnNewTaskObject]];
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.delegate didCancel];
}
@end
