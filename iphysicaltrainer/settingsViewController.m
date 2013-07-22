//
//  settingsViewController.m
//  iPersonalTrainer
//
//  Created by Coshx on 7/16/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "settingsViewController.h"

@interface settingsViewController ()

@end

@implementation settingsViewController

@synthesize imageOnSwitch = _imageOnSwitch;
@synthesize currentSettings = _currentSettings;

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

-(void)viewWillDisappear:(BOOL)animated {
    
}

-(void)viewWillAppear:(BOOL)animated {
    NSString *imageOnSwitchValue = [_currentSettings objectForKey:@"imageAlwaysOn"];
    [_imageOnSwitch setOn:[imageOnSwitchValue boolValue] animated:YES];
}

-(IBAction)imageOnSwitchChanged:(id)sender {
    NSString *imageOnSwitchValue = [NSString stringWithFormat:@"%d",[_imageOnSwitch state]];
    NSDictionary *newSettings = [NSDictionary dictionaryWithObject:imageOnSwitchValue forKey:@"imageAlwaysOn"];
    [[self delegate] receiveNewSettings:newSettings];
}

-(IBAction)done:(id)sender {
    [[self delegate] settingsViewControllerIsDone:self];
}

@end
