//
//  actionEditViewController.m
//  iPersonalTrainer
//
//  Created by Coshx on 7/8/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "actionEditViewController.h"

@interface actionEditViewController ()

@end

@implementation actionEditViewController

@synthesize delegate;
@synthesize actionNamed = _actionNamed;
@synthesize nameEdit = _nameEdit;
@synthesize countEdit = _countEdit;
@synthesize selectImage = _selectImage;
@synthesize actionImage = _actionImage;

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

-(void)viewWillAppear:(BOOL)animated {
    NSString *fullTitle = [@"Edit Action - " stringByAppendingString:_actionNamed];
    [self setTitle:fullTitle];
    [_nameEdit setText:_actionNamed];
    NSString *count = [NSString stringWithFormat:@"%@",[[self getActionFromController] count]];
    [_countEdit setText:count];
    UIImage *actionSetImage = [[self getActionFromController] image];
    [_actionImage setImage:actionSetImage];
}

-(void)viewWillDisappear:(BOOL)animated {
    //save the settings, even if they weren't changed
    NSString *name = [_nameEdit text];
    NSString *count = [_countEdit text];
    [[self delegate] updateAction:[self getActionFromController] withName:name];
    [[self delegate] updateAction:[self getActionFromController] withCount:count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(Action*)getActionFromController {
    return [[self delegate] getActionForName:_actionNamed];
}

-(IBAction)nameIsDoneEditing:(id)sender {
    NSString *newName = [_nameEdit text];
    [self setTitle:[@"Edit Action - " stringByAppendingString:newName]];
    [[self getActionFromController] setName:newName];
}

-(IBAction)countIsDoneEditing:(id)sender {
    NSString *newCount = [_countEdit text];
    [[self getActionFromController] setCount:newCount];
}

@end
