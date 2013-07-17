//
//  editWorkoutViewController.h
//  iPersonalTrainer
//
//  Created by Coshx on 7/15/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "workoutViewController.h"
#import "setTimerViewController.h"
#import "workoutProgress.h"

@interface editWorkoutViewController : UIViewController <setTimerViewControllerDelegate>

@property NSString *workoutTitle;
@property (assign, nonatomic) id <updateWorkoutDetails> delegate;
@property NSTimeInterval timeInterval;

-(IBAction)timerSwitchPressed:(id)sender;

@end
