//
//  setTimerViewController.m
//  iPersonalTrainer
//
//  Created by Coshx on 7/15/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "setTimerViewController.h"

@interface setTimerViewController ()

@property IBOutlet UIDatePicker *picker;
@property IBOutlet UIButton *doneButton;

@end

@implementation setTimerViewController

@synthesize picker = _picker;
@synthesize savedTime = _savedTime;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    if (_savedTime) {
        [_picker setCountDownDuration:_savedTime];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [[self delegate] recievePickerData:[_picker countDownDuration]];
}

-(IBAction)done:(id)sender {
    [[self delegate] setTimerViewControllerDidFinish:self];
}

@end
