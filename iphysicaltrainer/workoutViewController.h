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
#import "addActionViewController.h"
#import "actionEditViewController.h"
#import "FirstViewController.h"

@interface workoutViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    UIBarButtonItem *editButton;
    //UIBarButtonItem *addButton;
    id <passWorkout> delegate;
}

@property NSString *workoutName;
@property IBOutlet UITableView *actionListTable;
@property IBOutlet UIButton *start;
@property IBOutlet UIButton *stats;
@property (retain) id delegate;

-(IBAction)continueToNextView:(id)sender;

#pragma mark - Workout data control methods

-(Workout*)getWorkoutFromController;

-(void)addActionToWorkout:(Action *)newAction;
-(void)removeActionFromWorkout:(Action *)deletedAction;

#pragma mark - UI control methods

-(void)refreshLabelData;
-(void)addActionButtonPressed;
-(void)editButtonPressed;
-(void)editButtonDonePressed;

-(void)disableStartStatsButtons;
-(void)enableStartStatsButtons;

@end
