//
//  workoutProgress.h
//  iPersonalTrainer
//
//  Created by Coshx on 7/8/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "Action.h"

@interface workoutProgress : UIViewController <UIAlertViewDelegate>

@property Workout *workoutKept;
@property NSString *workoutNamed;
@property IBOutlet UIScrollView *scrollViewWorkouts;
@property NSDictionary *passedSettings;

-(void)timerDone:(NSTimer *)timer;
-(void)loadScroller;

@end
