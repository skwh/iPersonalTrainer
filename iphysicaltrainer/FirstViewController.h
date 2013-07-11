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

-(void)passNewWorkout:(Workout *)passedWorkout;
-(void)passWorkoutArray:(NSMutableArray *)passedWorkoutArray;
-(void)passWorkoutDictionary:(NSMutableDictionary *)passedWorkoutDictionary;
-(NSMutableDictionary *)reloadAllWorkouts;
-(Workout*)workoutFromReloadedWorkouts:(NSString *)workoutNamed;

//@required

-(NSMutableArray *)returnMasterWorkoutArray;
-(NSMutableDictionary *)returnMasterWorkoutDictionary;
-(Workout *)getWorkout:(NSString *)name;
-(void)updateWorkout:(Workout *)workout removeAction:(Action *)action;
-(void)updateWorkout:(Workout *)workout addAction:(Action *)action;
-(NSInteger)getActionNumberForWorkout:(Workout *)workout;
-(Action *)getAction:(NSString *)actionNamed forWorkout:(Workout*)workout;

@end


@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, passWorkout> {
    UIBarButtonItem *editButton;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *workoutData;
@property NSMutableArray *workouts;
@property NSMutableDictionary *workoutDict;
@property NSInteger workoutNumber;
@property BOOL firstTimeLoad;

#pragma mark - Workout setup methods

-(Workout *)setupWorkoutWithInfoDictionary:(NSDictionary *)workoutInfo;

#pragma mark - UINavigationController methods

-(IBAction)continueToNextView:(id)sender withWorkoutName:(NSString *)name;

#pragma mark - Private pass workout protocol methods

-(NSMutableArray *)extractWorkoutFromDataArray:(NSArray *)array;

#pragma mark - IO methods

-(void)loadWorkouts;
-(void)writeToWorkouts:(NSMutableDictionary *)dictionary;

#pragma mark - UI control methods

-(void)addWorkoutButtonPressed;

@end
