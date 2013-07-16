//
//  Workout.h
//  navigationControllerTest
//
//  Created by Coshx on 7/5/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Action.h"

@interface Workout : NSObject

@property NSString *name;
@property NSMutableArray *actionsArray;
@property NSMutableArray *countsArray;
@property NSMutableDictionary *actionsDict;
@property NSTimer *timer;

-(void)associateActionsAndCounts;
-(void)addAction:(Action*)action;

+(Workout *)initWithName:(NSString *)name;
+(Workout *)initWithName:(NSString *)name andActions:(NSMutableArray*)actions;
+(Workout *)initWithName:(NSString *)name andActions:(NSMutableArray*)actions andCounts:(NSMutableArray*)counts;

@end
