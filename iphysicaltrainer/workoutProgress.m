//
//  workoutProgress.m
//  iPersonalTrainer
//
//  Created by Coshx on 7/8/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "workoutProgress.h"

@interface workoutProgress ()

@end

@implementation workoutProgress

@synthesize scrollViewWorkouts = _scrollViewWorkouts;
@synthesize workoutNamed = _workoutNamed;
@synthesize workoutKept = _workoutKept;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *fullTitle = [@"Start Workout - " stringByAppendingString:_workoutNamed];
    [self setTitle:fullTitle];
    [self loadScroller];
    
}

-(void)loadScroller {
    NSInteger numPages = [[_workoutKept actionsArray] count];
    [_scrollViewWorkouts setContentSize:CGSizeMake(numPages * self.view.frame.size.width, self.view.frame.size.height)];
    [_scrollViewWorkouts setPagingEnabled:TRUE];
    for (int i=0;i<numPages;i++) {
        Action *selectedAction = [[_workoutKept actionsArray] objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i*self.view.frame.size.width)+(self.view.frame.size.width/2), 20, 200, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[selectedAction name]];
        CGSize labelSize = [label.text sizeWithFont:label.font];
        NSInteger slideWithPosition = i*self.view.frame.size.width;
        [label setFrame:CGRectMake(slideWithPosition+(self.view.frame.size.width/2-(labelSize.width/2)), 20, labelSize.width, labelSize.height)];
        [_scrollViewWorkouts addSubview:label];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)timerDone:(NSTimer *)timer {
    NSLog(@"TIMES UP BRO");
    [timer invalidate];
}

@end
