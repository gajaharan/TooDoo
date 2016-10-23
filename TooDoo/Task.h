//
//  Task.h
//  TooDoo
//
//  Created by Gajaharan Satkunanandan on 23/10/2016.
//  Copyright © 2016 Gajaharan Satkunanandan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *decription;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL isCompleted;

-(id) initWithData: (NSDictionary *) data;

@end
