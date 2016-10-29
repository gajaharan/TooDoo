//
//  ViewController.m
//  TooDoo
//
//  Created by Gajaharan Satkunanandan on 22/10/2016.
//  Copyright © 2016 Gajaharan Satkunanandan. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

-(NSMutableArray *)taskObjects {
    if(!_taskObjects) {
        _taskObjects = [[NSMutableArray alloc]init];
    }
    
    return _taskObjects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    NSArray *taskAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY];
    
    for(NSDictionary *dictionary in taskAsPropertyLists) {
        Task *taskObject = [self taskObjectForDictionary:dictionary];
        [self.taskObjects addObject:taskObject];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[AddTaskViewController class]]) {
        AddTaskViewController *addTaskViewController = segue.destinationViewController;
        addTaskViewController.delegate = self;
    }
    else if ([segue.destinationViewController isKindOfClass:[DetailTaskViewController class]]) {
        DetailTaskViewController *detailTaskViewController = segue.destinationViewController;
        NSIndexPath *path = sender;
        Task *taskObject = self.taskObjects[path.row];
        detailTaskViewController.task = taskObject;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reorderBarButtonPressed:(UIBarButtonItem *)sender {
    if(self.tableView.editing == YES) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}

- (IBAction)addTaskBarButtonItemPressed:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"toAddTaskViewControllerSegue" sender:nil];
}

#pragma mark - AddTaskViewControllerDelegate

-(void)didAddTask:(Task *)task {
    [self.taskObjects addObject:task];
    
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY] mutableCopy];
    
    if(!taskObjectsAsPropertyLists) taskObjectsAsPropertyLists = [[NSMutableArray alloc]init];
    
    [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

-(void)didCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DetailTaskViewControllerDelegate
-(void) updateTask {
    [self saveTasks];
    [self.tableView reloadData];
}


#pragma mark - Helper Methods

-(NSDictionary *)taskObjectAsAPropertyList:(Task *)taskObject {
    NSDictionary *dictionary = @{TASK_TITLE: taskObject.taskTitle, TASK_DESCRIPTION: taskObject.description, TASK_DATE: taskObject.date, TASK_COMPLETION: @(taskObject.isCompleted) };
    return dictionary;
}

-(Task *)taskObjectForDictionary:(NSDictionary *) dictionary {
    Task *taskObject = [[Task alloc] initWithData:dictionary];
    
    return taskObject;
}

-(BOOL)isDateGreaterThanDate:(NSDate *) date and:(NSDate *) toDate {
    NSTimeInterval dateInterval = [date timeIntervalSince1970];
    NSTimeInterval toDateInterval = [toDate timeIntervalSince1970];
    
    if(dateInterval > toDateInterval)
        return YES;
    else
        return NO;
}

-(void)saveTasks {
    NSMutableArray *taskObjectsAsPropertyLists = [[NSMutableArray alloc]init];
    for(int x=0; x < [self.taskObjects count]; x++) {
        [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:self.taskObjects[x]]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)updateCompletionOfTask:(Task *) task forIndexPath:(NSIndexPath *) indexPath {
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:TASK_OBJECTS_KEY] mutableCopy];
    
    if(!taskObjectsAsPropertyLists) taskObjectsAsPropertyLists = [[NSMutableArray alloc]init];
    
    [taskObjectsAsPropertyLists removeObjectAtIndex:indexPath.row];
    if(task.isCompleted == YES) task.isCompleted = NO;
    else task.isCompleted = YES;
    
    [taskObjectsAsPropertyLists insertObject:[self taskObjectAsAPropertyList:task] atIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
    
}

#pragma UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.taskObjects count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    //Configure Cell
    Task *task = self.taskObjects [indexPath.row];
    cell.textLabel.text = task.taskTitle;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    cell.detailTextLabel.text = stringFromDate;
    
    
    BOOL isOverDue = [self isDateGreaterThanDate:[NSDate date] and:task.date];
    if(task.isCompleted == YES) cell.backgroundColor = [UIColor greenColor];
    else if(isOverDue == YES) cell.backgroundColor = [UIColor redColor];
    else cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task * task = self.taskObjects[indexPath.row];
    [self updateCompletionOfTask:task forIndexPath:indexPath];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *newTaskObjectsData = [[NSMutableArray alloc] init];
        
        for(Task *task in self.taskObjects) {
            [newTaskObjectsData addObject:[self taskObjectAsAPropertyList:task]];
            
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:newTaskObjectsData forKey:TASK_OBJECTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toDetailTaskViewControllerSegue" sender:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Task *taskObject = self.taskObjects[sourceIndexPath.row];
    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
    [self.taskObjects insertObject:taskObject atIndex:destinationIndexPath.row];
    
    [self saveTasks];
}



@end
