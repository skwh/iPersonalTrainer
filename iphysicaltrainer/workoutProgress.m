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

@end

@implementation workoutProgress

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
    
}

-(void)loadScroller {
    NSInteger numPages = [[_workoutKept actionsArray] count];
    _numberOfPages = numPages;
    NSLog(@"number of pages: %i",_numberOfPages);
    [_scrollViewWorkouts setContentSize:CGSizeMake(numPages * self.view.frame.size.width, self.view.frame.size.height)];
    [_scrollViewWorkouts setPagingEnabled:TRUE];
    for (int i=0;i<numPages;i++) {
        Action *selectedAction = [[_workoutKept actionsArray] objectAtIndex:i];
        NSString *selectedActionCount = [NSString stringWithFormat:@"%@",[selectedAction count]];
        
        NSInteger slideWithPosition = i*self.view.frame.size.width;
        
        //check the settings to see if the image is always on
        UIImage *selectedActionImage = [selectedAction image];
        if (selectedActionImage != [UIImage imageNamed:@"first.png"]) {
            [self renderImage:selectedActionImage withPositionCount:i];
        } else if ([[_passedSettings objectForKey:@"imageAlwaysOn"] isEqualToString:@"1"]) {
            [self renderImage:selectedActionImage withPositionCount:i];
        }
        UILabel *actionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((i*self.view.frame.size.width)+(self.view.frame.size.width/2), 20, 200, 40)];
        UILabel *actionNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake((i*self.view.frame.size.width)+(self.view.frame.size.width/2), 50, 200, 40)];
        UIView *tapView = [[UIView alloc] init];
        [tapView setTag:i];
        
        [tapView setBackgroundColor:[UIColor redColor]];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        
        [tapView addGestureRecognizer:tapRecognizer];
        
        [actionNumberLabel setBackgroundColor:[UIColor clearColor]];
        [actionNumberLabel setText:selectedActionCount];
        
        [actionNameLabel setBackgroundColor:[UIColor clearColor]];
        [actionNameLabel setText:[selectedAction name]];
        
        CGSize actionLabelSize = [actionNameLabel.text sizeWithFont:actionNameLabel.font];
        CGSize actionNumberLabelSize = [actionNumberLabel.text sizeWithFont:actionNumberLabel.font];
        
        [tapView setFrame:CGRectMake(slideWithPosition+((self.view.frame.size.width/2)-100), 150, 200, 200)];
        [actionNameLabel setFrame:CGRectMake(slideWithPosition+(self.view.frame.size.width/2-(actionLabelSize.width/2)), 20, actionLabelSize.width, actionLabelSize.height)];
        [actionNumberLabel setFrame:CGRectMake(slideWithPosition+(self.view.frame.size.width/2-(actionNumberLabelSize.width/2)), 50, actionNumberLabelSize.width, actionNumberLabelSize.height)];
        
        [_actionCountLabels setObject:actionNumberLabel forKey:[NSString stringWithFormat:@"%i",i]];
//        [_pagesAndTags setObject:[NSValue valueWithCGRect:CGRectMake(slideWithPosition+self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)] forKey:[NSString stringWithFormat:@"%i",[tapView tag]]];
        
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
                //go back to the workout screen
                [[self navigationController] popViewControllerAnimated:TRUE];
            }
        }
    }
}

@end
