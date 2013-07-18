//
//  workoutProgress.h
//  iPersonalTrainer
//
//  Created by Coshx on 7/8/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface workoutProgress : UIViewController <UIAlertViewDelegate>

@property NSString *workoutNamed;

-(void)timerDone:(NSTimer *)timer;

@end
