//
//  Task.m
//  TooDoo
//
//  Created by Gajaharan Satkunanandan on 23/10/2016.
//  Copyright © 2016 Gajaharan Satkunanandan. All rights reserved.
//


#import "Task.h"

@implementation Task

-(id) initWithData: (NSDictionary *) data {
    self = [super init];
    
    if(self) {
        self.taskTitle = data[TASK_TITLE];
        self.taskDescription = data[TASK_DESCRIPTION];
        self.date = data[TASK_DATE];
        self.isCompleted = [data[TASK_COMPLETION] boolValue];
    }
    
    return self;
}

-(id) init {
    self = [self initWithData:nil];
    return self;
}
@end
