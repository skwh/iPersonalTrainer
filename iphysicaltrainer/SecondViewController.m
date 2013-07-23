//
//  SecondViewController.m
//  iphysicaltrainer
//
//  Created by Coshx on 7/5/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (weak) IBOutlet UILabel *runTimeLabel;
@property (weak) IBOutlet UIButton *startStopButton;
@property (weak) IBOutlet MKMapView *map;
@property NSTimer *privateTimer;
@property NSInteger timeSinceTimerStarted;

@property BOOL TIMER_ON;

@end

@implementation SecondViewController

@synthesize TIMER_ON = _TIMER_ON;
@synthesize runTimeLabel = _runTimeLabel;
@synthesize privateTimer = _privateTimer;
@synthesize timeSinceTimerStarted = _timeSinceTimerStarted;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Running", @"Running");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _TIMER_ON = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startStopButtonPressed {
    if (!_TIMER_ON) {
        _privateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        _TIMER_ON = YES;
    } else if (_TIMER_ON) {
        [_privateTimer invalidate];
        _TIMER_ON = NO;
    }
}

-(void)timerFired {
    _timeSinceTimerStarted++;
    [self updateRunTimeLabel];
}

-(void)updateRunTimeLabel {
    NSInteger num_seconds = _timeSinceTimerStarted;
    NSInteger days = num_seconds / (60 * 60 * 24);
    num_seconds -= days * (60 * 60 * 24);
    NSInteger hours = num_seconds / (60 * 60);
    num_seconds -= hours * (60 * 60);
    NSInteger minutes = num_seconds / 60;
    num_seconds -= minutes * 60;
    
    NSString *labelText = [@"Run Time: " stringByAppendingFormat:@"%02d:%02d:%02d",hours,minutes,num_seconds];
    [_runTimeLabel setText:labelText];
}

@end
