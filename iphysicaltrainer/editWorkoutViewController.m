//
//  editWorkoutViewController.m
//  iPersonalTrainer
//
//  Created by Coshx on 7/15/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "editWorkoutViewController.h"

@interface editWorkoutViewController ()

@property (weak) IBOutlet UITextField *workoutNameInput;
@property (weak) IBOutlet UISwitch *workoutTimerSwitch;
@property (weak) IBOutlet UILabel *pickerIndicator;
@property (weak) IBOutlet UIButton *editPickerSelection;

@end

@implementation editWorkoutViewController

@synthesize workoutNameInput = _workoutNameInput;
@synthesize workoutTimerSwitch = _workoutTimerSwitch;
@synthesize workoutTitle = _workoutTitle;
@synthesize timeInterval = _timeInterval;
@synthesize pickerIndicator = _pickerIndicator;
@synthesize editPickerSelection = _editPickerSelection;

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
    [_workoutNameInput setText:_workoutTitle];
    if (_timeInterval) {
        [_workoutTimerSwitch setOn:TRUE];
        [_pickerIndicator setText:[@"Timer on: " stringByAppendingFormat:@"%@",[self createDateStringFromInteger:_timeInterval]]];
        [_editPickerSelection setHidden:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    NSString *newName = [_workoutNameInput text];
    if (![_workoutTitle isEqualToString:newName]) {
        [[self delegate] updateWorkoutWithName:newName];
    }
    if (_timeInterval) {
        workoutProgress *progressController = [[workoutProgress alloc] init];
        NSTimer *newTimer = [NSTimer timerWithTimeInterval:_timeInterval
                                                    target:progressController
                                                    selector:@selector(timerDone:)
                                                    userInfo:nil
                                                    repeats:YES
                             ];
        
        [[self delegate] updateWorkoutWithTimer:newTimer];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    if (_timeInterval) {
        [_editPickerSelection setHidden:NO];
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
            if (_timeInterval) {
                [timerController setSavedTime:_timeInterval];
            }
            timerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:timerController animated:YES completion:nil];
        } else if (_workoutTimerSwitch.on == FALSE) {
            [_pickerIndicator setText:@"Timer is disabled."];
            [_editPickerSelection setHidden:YES];
        }
    } else if (sender == _editPickerSelection && _workoutTimerSwitch.on) {
        setTimerViewController *timerController = [[setTimerViewController alloc] initWithNibName:@"setTimerViewController" bundle:nil];
        timerController.delegate = self;
        if (_timeInterval) {
            [timerController setSavedTime:_timeInterval];
        }
        timerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:timerController animated:YES completion:nil];
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
    return [NSString stringWithFormat:@"%i hours, %i minutes",hours,minutes];
}

@end
