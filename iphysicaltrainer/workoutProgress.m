//
//  workoutProgress.m
//  iPersonalTrainer
//
//  Created by Coshx on 7/8/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "workoutProgress.h"

@interface workoutProgress ()

@property NSMutableDictionary *actionCountLabels;
@property int numberOfPages;

@property NSTimer *timer;
@property NSTimeInterval timeInterval;
@property NSDate *timerDate;

@end

@implementation workoutProgress

@synthesize timeInterval = _timeInterval;
@synthesize timer = _timer;
@synthesize timerDate = _timerDate;

@synthesize numberOfPages = _numberOfPages;
@synthesize actionCountLabels = _actionCountLabels;
@synthesize scrollViewWorkouts = _scrollViewWorkouts;
@synthesize workoutNamed = _workoutNamed;
@synthesize workoutKept = _workoutKept;
@synthesize passedSettings = _passedSettings;

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
    _actionCountLabels = [[NSMutableDictionary alloc] init];
    [self loadScroller];
    [self startTimer];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_timer invalidate];
}

-(void)loadScroller {
    NSInteger numPages = [[_workoutKept actionsArray] count];
    //get the number of pages
    _numberOfPages = numPages;
    //create an array for the allowed actions (actions that are not blank)
    NSMutableArray *allowedActionsArray = [[NSMutableArray alloc] init];
    //iterate over all the actions
    for (int i=0;i<numPages;i++) {
        //get the selected action
        Action *selectedAction = [[_workoutKept actionsArray] objectAtIndex:i];
        //get the count of the selected action
        NSString *selectedActionCount = [NSString stringWithFormat:@"%@",[selectedAction count]];
        //if the selected action is blank
        if ([selectedActionCount isEqualToString:@"0"] || [selectedActionCount isEqualToString:@""]) {
            //skip it
            continue;
        } else {
            //else, put it in the allowed actions
            [allowedActionsArray addObject:selectedAction];
        }
    }
    //set the size of the scroll view to allow for all the actions
    [_scrollViewWorkouts setContentSize:CGSizeMake([allowedActionsArray count] * self.view.frame.size.width, self.view.frame.size.height)];
    //set paging enabled
    [_scrollViewWorkouts setPagingEnabled:TRUE];
    //iterate over the allowed actions
    for (int i=0;i<[allowedActionsArray count];i++) {
        //get the selected action
        Action *selectedAction = [allowedActionsArray objectAtIndex:i];
        //get the count
        NSString *selectedActionCount = [NSString stringWithFormat:@"%@",[selectedAction count]];
        //get the x position where the slide is
        NSInteger slideWithPosition = i*self.view.frame.size.width;
        //check the settings to see if the image is always on
        UIImage *selectedActionImage = [selectedAction image];
        //if the image is not the default image
        if (selectedActionImage != [UIImage imageNamed:@"first.png"]) {
            //allow it
            [self renderImage:selectedActionImage withPositionCount:i];
            //or, if the imageAlwaysOn flag is true
        } else if ([[_passedSettings objectForKey:@"imageAlwaysOn"] isEqualToString:@"1"]) {
            //allow it
            [self renderImage:selectedActionImage withPositionCount:i];
        }
        //create the action's name's label
        UILabel *actionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((i*self.view.frame.size.width)+(self.view.frame.size.width/2), 20, 200, 40)];
        //create the action's count's label
        UILabel *actionNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake((i*self.view.frame.size.width)+(self.view.frame.size.width/2), 50, 200, 40)];
        //create the tap view
        UIView *tapView = [[UIView alloc] init];
        //set the tap view's tag to the current slide's position
        [tapView setTag:i];
        //set the background color of the tap view
        [tapView setBackgroundColor:[UIColor redColor]];
        //create the tap gesture recognizer
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        //add the recognizer to the tap view
        [tapView addGestureRecognizer:tapRecognizer];
        //set the background color of the action's name's label
        [actionNumberLabel setBackgroundColor:[UIColor clearColor]];
        //set the text of the action's name's label
        [actionNumberLabel setText:selectedActionCount];
        //set the background color of the action's count's label
        [actionNameLabel setBackgroundColor:[UIColor clearColor]];
        //set the text of the action's count's label
        [actionNameLabel setText:[selectedAction name]];
        //get the size of the action's names' label
        CGSize actionLabelSize = [actionNameLabel.text sizeWithFont:actionNameLabel.font];
        //get the sie of the action's count's label
        CGSize actionNumberLabelSize = [actionNumberLabel.text sizeWithFont:actionNumberLabel.font];
        //set the tap view's frame 
        [tapView setFrame:CGRectMake(slideWithPosition+((self.view.frame.size.width/2)-100), 120, 200, 200)];
        //set the action's name's label's frame
        [actionNameLabel setFrame:CGRectMake(slideWithPosition+(self.view.frame.size.width/2-(actionLabelSize.width/2)), 20, actionLabelSize.width, actionLabelSize.height)];
        //set the action's counts' label's frame
        [actionNumberLabel setFrame:CGRectMake(slideWithPosition+(self.view.frame.size.width/2-(actionNumberLabelSize.width/2)), 50, actionNumberLabelSize.width, actionNumberLabelSize.height)];
        //add the number label to the private array
        [_actionCountLabels setObject:actionNumberLabel forKey:[NSString stringWithFormat:@"%i",i]];
        //add all the created elements to the scroll view
        [_scrollViewWorkouts addSubview:tapView];
        [_scrollViewWorkouts addSubview:actionNameLabel];
        [_scrollViewWorkouts addSubview:actionNumberLabel];
    }
    
}

-(void)renderImage:(UIImage *)image withPositionCount:(int)i {
    NSInteger slideWithPosition = i*self.view.frame.size.width;
    UIImageView *actionImageView = [[UIImageView alloc] initWithImage:image];
    CGSize actionImageViewSize = actionImageView.frame.size;
    if (actionImageViewSize.width > 100) {
        actionImageViewSize.width = 100;
    }
    if (actionImageViewSize.height > 100) {
        actionImageViewSize.height = 100;
    }
    [actionImageView setFrame:CGRectMake(slideWithPosition+(self.view.frame.size.width/2-(actionImageViewSize.width/2)), 80, actionImageViewSize.width, actionImageViewSize.height)];
    [_scrollViewWorkouts addSubview:actionImageView];
}

-(void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollingFire) userInfo:nil repeats:YES];
    _timerDate = [[NSDate alloc] init];
}

-(void)pollingFire {
    _timeInterval++;
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

-(void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    //get the view that was tapped
    UIView *tappedView = tapGesture.view;
    //get the view's tag
    int tappedViewTag = [tappedView tag];
    //get the label associated with the view
    UILabel *actionTappedLabel = [_actionCountLabels objectForKey:[NSString stringWithFormat:@"%i",[tappedView tag]]];
    //if the count is a number
    if ([actionTappedLabel.text intValue]) {
        //get the number from the label
        int count = [[actionTappedLabel text] intValue];
        //if the number is greater than zero
        if (count > 0) {
            //decrement the count
            count = count-1;
            //set the new count to the label
            [actionTappedLabel setText:[NSString stringWithFormat:@"%i",count]];
            //if the count is one
            if (count == 1) {
                //set the background color to blue
                [tappedView setBackgroundColor:[UIColor blueColor]];
            }
        }
        //if the count is zero
        if (count == 0) {
            //set the background color to green
            [tappedView setBackgroundColor:[UIColor greenColor]];
            //if the action is not the last page
            if (tappedViewTag < _numberOfPages-1) {
                //scroll to the next action
                [_scrollViewWorkouts scrollRectToVisible:CGRectMake((1+[tappedView tag])*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
                //if the action is on the last page
            } else if (tappedViewTag == _numberOfPages-1) {
                //show an alert with the time
                [_timer invalidate];
                
                NSInteger num_seconds = _timeInterval;
                NSInteger days = num_seconds / (60 * 60 * 24);
                num_seconds -= days * (60 * 60 * 24);
                NSInteger hours = num_seconds / (60 * 60);
                num_seconds -= hours * (60 * 60);
                NSInteger minutes = num_seconds / 60;
                num_seconds -= minutes * 60;
                
                NSString *timeAsString = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,num_seconds];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Workout Complete" message:[@"You finished in " stringByAppendingString:timeAsString] delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
                alert.alertViewStyle = UIAlertViewStyleDefault;
                [alert show];
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && [[alertView title] isEqualToString:@"Workout Complete"]) {
        [[self navigationController] popViewControllerAnimated:TRUE];
    }
}

@end
