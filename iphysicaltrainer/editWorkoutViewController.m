//
//  editWorkoutViewController.m
//  iPersonalTrainer
//
//  Created by Coshx on 7/15/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "editWorkoutViewController.h"

@interface editWorkoutViewController ()

@property IBOutlet UITextField *workoutNameInput;
@property IBOutlet UISwitch *workoutTimerSwitch;
@property IBOutlet UILabel *pickerIndicator;
@property NSTimeInterval timeInterval;

@end

@implementation editWorkoutViewController

@synthesize workoutNameInput = _workoutNameInput;
@synthesize workoutTimerSwitch = _workoutTimerSwitch;
@synthesize workoutTitle = _workoutTitle;
@synthesize timeInterval = _timeInterval;
@synthesize pickerIndicator = _pickerIndicator;

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
    NSString *title = [@"Edit Workout - " stringByAppendingString:_workoutTitle];
    [self setTitle:title];
}

-(void)viewWillAppear:(BOOL)animated {
    [_workoutNameInput setText:_workoutTitle];
}

-(void)viewWillDisappear:(BOOL)animated {
    NSString *newName = [_workoutNameInput text];
    [[self delegate] updateWorkoutWithName:newName];
    if (_timeInterval) {
        NSInvocation *blankInvocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature alloc]];
        NSTimer *newTimer = [NSTimer timerWithTimeInterval:_timeInterval invocation:blankInvocation repeats:FALSE];
        [[self delegate] updateWorkoutWithTimer:newTimer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTimerViewControllerDidFinish:(setTimerViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)recievePickerData:(NSTimeInterval)interval {
    _timeInterval = interval;
    _pickerIndicator.text = [@"Timer on: " stringByAppendingFormat:@"%@",[self createDateStringFromInteger:interval]];
}

-(IBAction)timerSwitchPressed:(id)sender {
    if (sender == _workoutTimerSwitch) {
        if (_workoutTimerSwitch.on == TRUE) {
            setTimerViewController *timerController = [[setTimerViewController alloc] initWithNibName:@"setTimerViewController" bundle:nil];
            timerController.delegate = self;
            timerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:timerController animated:YES completion:nil];
        } else if (_workoutTimerSwitch.on == FALSE) {
            [_pickerIndicator setText:@"Timer is disabled."];
        }
    }
}

-(IBAction)workoutNameDoneEditing:(id)sender {
    NSString *name = [_workoutNameInput text];
    _workoutTitle = name;
    NSString *title = [@"Edit Workout - " stringByAppendingString:_workoutTitle];
    [self setTitle:title];
    [[self delegate] updateWorkoutWithName:_workoutTitle];
}

-(NSString *)createDateStringFromInteger:(NSInteger)integer {
    NSInteger num_seconds = integer;
    NSInteger days = num_seconds / (60 * 60 * 24);
    num_seconds -= days * (60 * 60 * 24);
    NSInteger hours = num_seconds / (60 * 60);
    num_seconds -= hours * (60 * 60);
    NSInteger minutes = num_seconds / 60;
    return [NSString stringWithFormat:@"%i hours, %i minutes, %i seconds",hours,minutes,num_seconds];
}

@end
