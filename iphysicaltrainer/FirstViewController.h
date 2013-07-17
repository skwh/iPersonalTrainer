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
#import "settingsViewController.h"

@protocol passWorkout <NSObject>

@optional

-(void)passNewWorkout:(Workout *)passedWorkout;
-(void)passWorkoutArray:(NSMutableArray *)passedWorkoutArray;
-(void)passWorkoutDictionary:(NSMutableDictionary *)passedWorkoutDictionary;
-(NSMutableArray *)returnMasterWorkoutArray;
-(NSMutableDictionary *)returnMasterWorkoutDictionary;
-(NSMutableDictionary *)reloadAllWorkouts;
-(Workout*)workoutFromReloadedWorkouts:(NSString *)workoutNamed;

@required

-(Workout *)getWorkout:(NSString *)name;
-(void)updateWorkout:(Workout *)workout removeAction:(Action *)action;
-(void)updateWorkout:(Workout *)workout addAction:(Action *)action;
-(void)updateWorkout:(Workout *)workout updateAction:(Action *)action;
-(void)updateWorkout:(Workout *)workout withName:(NSString *)name;
-(NSInteger)getActionNumberForWorkout:(Workout *)workout;
-(Action *)getAction:(NSString *)actionNamed forWorkout:(Workout*)workout;

@end


@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, passWorkout, passSettings, UIAlertViewDelegate> {
    UIBarButtonItem *editButton;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong) NSMutableArray *workoutData;
@property (strong) NSMutableArray *workouts;
@property (strong) NSMutableDictionary *workoutDict;
@property (strong) NSDictionary *settings;
@property BOOL firstTimeLoad;

#pragma mark - Workout setup methods

-(Workout *)setupWorkoutWithInfoDictionary:(NSDictionary *)workoutInfo;

#pragma mark - UINavigationController methods

-(IBAction)continueToNextView:(id)sender withWorkoutName:(NSString *)name;

#pragma mark - IO methods

-(void)loadWorkouts;
-(void)writeToWorkouts:(NSMutableDictionary *)dictionary;

#pragma mark - UI control methods

-(void)editWorkoutButtonPressed;
-(void)editWorkoutButtonDone;
-(void)addWorkoutButtonPressed;
-(void)settingsButtonPressed;

@end
