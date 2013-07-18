//
//  workoutViewController.h
//  iPersonalTrainer
//
//  Created by Coshx on 7/5/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "workoutProgress.h"
#import "workoutStatsViewController.h"
#import "Workout.h"
#import "Action.h"
#import "FirstViewController.h"

@protocol passAction <NSObject>

@required
-(Action*)getActionForName:(NSString *)actionNamed;
-(void)updateAction:(Action*)action;
-(void)updateActionWithString:(NSString*)actionNamed;
-(void)updateAction:(Action*)action withName:(NSString *)newName;
-(void)updateAction:(Action *)action withCount:(NSString *)newCount;
-(void)deleteAction:(Action *)action atIndexPath:(NSIndexPath*)indexPath;

@end

@protocol updateWorkoutDetails
-(void)updateWorkoutWithName:(NSString *)name;
-(void)updateWorkoutWithDictionary:(NSDictionary *)settings;
-(void)updateWorkoutWithTimer:(NSTimer *)timer;
@end

#import "actionEditViewController.h"
#import "editWorkoutViewController.h"

@interface workoutViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,passAction,updateWorkoutDetails,UIAlertViewDelegate> {
    UIBarButtonItem *editButton;
    //UIBarButtonItem *addButton;
    id <passWorkout> delegate;
}

@property (strong) NSString *workoutName;
@property (weak) IBOutlet UITableView *actionListTable;
@property (weak) IBOutlet UIButton *start;
@property (weak) IBOutlet UIButton *stats;
@property (weak) IBOutlet UIButton *edit;
@property (retain) id delegate;

-(IBAction)continueToNextView:(id)sender;

#pragma mark - Workout data control methods

-(Workout*)getWorkoutFromController;

-(void)addActionToWorkout:(Action *)newAction;
-(void)removeActionFromWorkout:(Action *)deletedAction;

#pragma mark - UI control methods

-(void)refreshLabelData;
-(void)addActionButtonPressed;

@end
