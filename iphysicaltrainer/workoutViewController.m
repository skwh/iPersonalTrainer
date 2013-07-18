//
//  workoutViewController.m
//  iPersonalTrainer
//
//  Created by Coshx on 7/5/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "workoutViewController.h"

@interface workoutViewController ()

@end

@implementation workoutViewController

@synthesize delegate;
@synthesize actionListTable = _actionListTable;
@synthesize start = _start;
@synthesize stats = _stats;
@synthesize workoutName = _workoutName;
@synthesize edit = _edit;

#pragma mark - Default methods

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
    [self setTitle:_workoutName];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addActionButtonPressed)];
    [[self navigationItem] setRightBarButtonItem:addButton animated:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [_actionListTable reloadData];
}

#pragma mark - NavigationController methods

-(IBAction)continueToNextView:(id)sender {
    //check which button called the method
    if (sender == _stats) {
        //create a new stats controller and push it
        NSString *nibName = (_usingLargeScreen)?@"LargeWorkoutStatsViewController" : @"workoutStatsViewController";
        workoutStatsViewController *statsController = [[workoutStatsViewController alloc] initWithNibName:nibName bundle:nil];
        [statsController setWorkoutNamed:_workoutName];
        [[self navigationController] pushViewController:statsController animated:TRUE];
    } else if (sender == _start) {
        //create a new start controller and push it
        NSString *nibName = (_usingLargeScreen)?@"LargeWorkoutProgressViewController" : @"workoutProgress";
        workoutProgress *progressController = [[workoutProgress alloc] initWithNibName:nibName bundle:nil];
        [progressController setWorkoutNamed:_workoutName];
        [[self navigationController] pushViewController:progressController animated:TRUE];
    } else if (sender == _edit) {
        NSString *nibName = (_usingLargeScreen)?@"LargeEditWorkoutViewController" : @"editWorkoutViewController";
        editWorkoutViewController *editController = [[editWorkoutViewController alloc] initWithNibName:nibName bundle:nil];
        [editController setDelegate:self];
        [editController setWorkoutTitle:_workoutName];
        if ([[self getWorkoutFromController] timer]) {
            NSTimeInterval savedInterval = [[[self getWorkoutFromController] timer] timeInterval];
            [editController setTimeInterval:savedInterval];
        }
        [[self navigationController] pushViewController:editController animated:TRUE];
    }
}

#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self delegate] getActionNumberForWorkout:[self getWorkoutFromController]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get current action from the workout from the workoutcontroller
    Action *currentAction = [[[self getWorkoutFromController] actionsArray] objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"ActionCell";
    UITableViewCell *cell = [_actionListTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //check if the action retrieved is valid
    if (currentAction != nil) {
        cell.textLabel.text = [currentAction name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",currentAction.count];
    } else {
        cell.textLabel.text = @"Error";
        cell.detailTextLabel.text = @"Oh lawd so many errors";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //tell the tableview to begin updating
    [tableView beginUpdates];
    //get the cell text at index
    NSString *cellText = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    //find the action being deleted based on the row selected
    Action *actionDeleted = [[self delegate] getAction:cellText forWorkout:[self getWorkoutFromController]];
    //remove the actions with the workout data methods
    [self removeActionFromWorkout:actionDeleted];
    //tell the table to delete the row
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //end the updates
    [tableView endUpdates];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //get the action selected
    Action *selectedAction = [[[self getWorkoutFromController] actionsArray] objectAtIndex:indexPath.row];
    NSString *nibName = (_usingLargeScreen)? @"LargeActionEditViewController" : @"actionEditViewController";
    //create action edit controller
    actionEditViewController *actionEdit = [[actionEditViewController alloc] initWithNibName:nibName bundle:nil];
    //set the selected action name
    [actionEdit setKeptAction:selectedAction];
    //pass the index path for later
    [actionEdit setCellIndexPath:indexPath];
    //set the action's delegate
    [actionEdit setDelegate:self];
    //push the controller onto the stack
    [[self navigationController] pushViewController:actionEdit animated:YES];
}

#pragma mark - Workout data methods

-(Workout *)getWorkoutFromController {
    //use getWorkout rather than getWorkoutFromReloadedWorkouts because it takes less time
    return [[self delegate] getWorkout:_workoutName];
}

-(void)addActionToWorkout:(Action *)newAction {
    //use updateWorkout:addAction because it is complete
    [[self delegate] updateWorkout:[self getWorkoutFromController] addAction:newAction];
}

-(void)removeActionFromWorkout:(Action *)deletedAction {
    //use updateWorkout:removeAction because it is complete
    [[self delegate] updateWorkout:[self getWorkoutFromController] removeAction:deletedAction];
}

#pragma mark - edit mode methods

-(void)addActionButtonPressed {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Action"
                                                  message:@"Please enter the name of the new action."
                                                  delegate:self
                                                  cancelButtonTitle:@"Continue"
                                                  otherButtonTitles:nil
                              ];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder = @"Action Name";
    [alertView show];
}

#pragma mark - UIAlertViewDelegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"New Action"]) {
        NSString *enteredTitle = [[alertView textFieldAtIndex:0] text];
        NSString *newTitle = [enteredTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //check if the action already exists
        if ([[[self getWorkoutFromController] actionsDict] objectForKey:newTitle]) {
            //if so, alert the user
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"An action with that name already exists." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
        } else {
            //else, create action and add it to the tableView
            UIImage *defaultImage = [UIImage imageNamed:@"first.png"];
            Action *newAction = [Action actionWithName:newTitle andCount:@"0" andImage:defaultImage];
            [[self delegate] updateWorkout:[self getWorkoutFromController] addAction:newAction];
            [_actionListTable reloadData];
        }
    } else if ([alertView.title isEqualToString:@"Oops"]) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [self addActionButtonPressed];
    }
}

#pragma mark - ui control methods

-(void)refreshLabelData {
    [self setTitle:_workoutName];
    [_actionListTable reloadData];
}

#pragma mark - passAction methods

-(Action*)getActionForName:(NSString *)actionNamed {
    NSMutableDictionary *actionsDictionary = [[self getWorkoutFromController] actionsDict];
    Action *selectedAction = [actionsDictionary objectForKey:actionNamed];
    return selectedAction;
}

-(void)updateAction:(Action *)action {
    [[self delegate] updateWorkout:[self getWorkoutFromController] updateAction:action];
    [_actionListTable reloadData];
}

-(void)updateActionWithString:(NSString *)actionNamed {
    [[self delegate] updateWorkout:[self getWorkoutFromController] updateAction:[self getActionForName:actionNamed]];
    [_actionListTable reloadData];
}

-(void)updateAction:(Action *)action withCount:(NSString *)newCount {
    [action setCount:newCount];
    [[self delegate] updateWorkout:[self getWorkoutFromController] updateAction:action];
    [_actionListTable reloadData];
}

-(void)updateAction:(Action *)action withName:(NSString *)newName {
    [action setName:newName];
    [[self delegate] updateWorkout:[self getWorkoutFromController] updateAction:action];
    [_actionListTable reloadData];
}

-(void)deleteAction:(Action *)action atIndexPath:(NSIndexPath *)indexPath {
    [self tableView:_actionListTable commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
}

#pragma mark - update workout details methods

-(void)updateWorkoutWithName:(NSString *)name {
    [self setTitle:name];
    [[self delegate] updateWorkout:[self getWorkoutFromController] withName:name];
    _workoutName = name;
}
-(void)updateWorkoutWithDictionary:(NSDictionary *)settings {
    NSString *name = [settings objectForKey:@"name"];
    NSTimer *timer = [settings objectForKey:@"timer"];
    if (name) {
        [self updateWorkoutWithName:name];
    }
    if (timer) {
        [self updateWorkoutWithTimer:timer];
    }
}
-(void)updateWorkoutWithTimer:(NSTimer *)timer {
    [[self getWorkoutFromController] setTimer:timer];
}

@end
