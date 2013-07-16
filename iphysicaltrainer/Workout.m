//  Workout.m
//  navigationControllerTest
//
//  Created by Coshx on 7/5/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "Workout.h"
#import "Action.h"

@implementation Workout

@synthesize name = _name;
@synthesize actionsArray = _actionsArray;
@synthesize countsArray = _countsArray;
@synthesize actionsDict = _actionsDict;
@synthesize timer = _timer;

-(NSString *)description {
    return [self name];
}

#pragma mark - Setup methods

-(void)associateActionsAndCounts {
    _actionsDict = [[NSMutableDictionary alloc] init];
    for (int i=0;i<_actionsArray.count;i++) {
        NSString *actionName = [_actionsArray objectAtIndex:i];
        NSString *num = [_countsArray objectAtIndex:i];
        Action *newAction  = [Action actionWithName:actionName andCount:num];
        [_actionsDict setObject:newAction forKey:newAction.name];
    }
}

-(void)addAction:(Action*)action {
    [_actionsArray addObject:action];
    [_actionsDict setObject:action forKey:[action name]];
    [_countsArray addObject:[action count]];
}

#pragma mark - Factory methods

+(Workout *)initWithName:(NSString *)name {
    Workout *newWorkout = [Workout alloc];
    [newWorkout setName:name];
    return newWorkout;
}

+(Workout *)initWithName:(NSString *)name andActions:(NSMutableArray*)actions {
    Workout *newWorkout = [Workout alloc];
    [newWorkout setName:name];
    [newWorkout setActionsArray:actions];
    return newWorkout;
}

+(Workout *)initWithName:(NSString *)name andActions:(NSMutableArray*)actions andCounts:(NSMutableArray *)countsArray {
    Workout *newWorkout = [Workout alloc];
    [newWorkout setName:name];
    [newWorkout setActionsArray:actions];
    [newWorkout setCountsArray:countsArray];
    return newWorkout;
}

@end
