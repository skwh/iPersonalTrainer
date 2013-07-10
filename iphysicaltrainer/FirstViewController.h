//
//  FirstViewController.h
//  iphysicaltrainer
//
//  Created by Coshx on 7/5/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"
#import "Workout.h"
#import "addWorkoutViewController.h"

@protocol passWorkout <NSObject>

@optional

-(void)passWorkout:(Workout*)passedWorkout;
-(void)passWorkoutArray:(NSMutableArray*)passedWorkoutArray;
-(void)passWorkoutDictionary:(NSMutableDictionary*)passedWorkoutDictionary;

@required

-(NSMutableArray*)returnWorkoutArray;
-(NSMutableDictionary*)returnWorkoutDictionary;
-(Workout *)getWorkout:(NSString *)name;
-(void)updateWorkout:(Workout *)workout ofAction:(Action *)action;

@end


@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, passWorkout> {
    UIBarButtonItem *editButton;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *workouts;
@property NSMutableDictionary *workoutDict;

-(IBAction)continueToNextView:(id)sender withWorkoutName:(NSString *)name;

-(void)loadWorkouts;
-(void)writeToWorkouts:(NSMutableDictionary*)dictionary;

-(BOOL)insertWorkout:(Workout *)workout withWorkoutData:(Workout *)workout;
-(void)addWorkout;

@end
