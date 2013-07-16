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
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed)];
    [[self navigationItem] setRightBarButtonItem:button];
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
        workoutStatsViewController *statsController = [[workoutStatsViewController alloc] initWithNibName:@"workoutStatsViewController" bundle:nil];
        [statsController setWorkoutNamed:_workoutName];
        [[self navigationController] pushViewController:statsController animated:TRUE];
    } else if (sender == _start) {
        //create a new start controller and push it
        workoutProgress *progressController = [[workoutProgress alloc] initWithNibName:@"workoutProgress" bundle:nil];
        [progressController setWorkoutNamed:_workoutName];
        [[self navigationController] pushViewController:progressController animated:TRUE];
    } else if (sender == _edit) {
        editWorkoutViewController *editController = [[editWorkoutViewController alloc] initWithNibName:@"editWorkoutViewController" bundle:nil];
        [editController setDelegate:self];
        [editController setWorkoutTitle:_workoutName];
        [[self navigationController] pushViewController:editController animated:TRUE];
    }
}

-(void)addActionButtonPressed {
    //create action and add it to the tableView
    UIImage *defaultImage = [UIImage imageNamed:@"first.png"];
    Action *newAction = [Action actionWithName:@"New Action" andCount:@"0" andImage:defaultImage];
    [[self delegate] updateWorkout:[self getWorkoutFromController] addAction:newAction];
    [_actionListTable reloadData];
}

#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self delegate] getActionNumberForWorkout:[self getWorkoutFromController]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"ActionCellID";
    UITableViewCell *cell = [_actionListTable dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //get current action from the workout from the workoutcontroller
    Action *currentAction = [[[self getWorkoutFromController] actionsArray] objectAtIndex:indexPath.row];
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
    //create action edit controller
    actionEditViewController *actionEdit = [[actionEditViewController alloc] initWithNibName:@"actionEditViewController" bundle:nil];
    //set the selected action name
    [actionEdit setKeptAction:selectedAction];
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

-(void)editButtonPressed {
    //set the title to show action editing
    [self setTitle:@"Edit Actions"];
    //set the table to editing mode
    [_actionListTable setEditing:YES];
    //create and push the add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addActionButtonPressed)];
    [[self navigationItem] setLeftBarButtonItem:addButton animated:TRUE];
    //create and push the done button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonDonePressed)];
    [[self navigationItem] setRightBarButtonItem:doneButton animated:TRUE];
    //disable start & stats buttons
    [self disableStartStatsButtons];
}

-(void)editButtonDonePressed {
    //reset the title
    [self setTitle:_workoutName];
    //set the table to normal mode
    [_actionListTable setEditing:FALSE];
    //remove the add button
    [[self navigationItem] setLeftBarButtonItem:nil animated:YES];
    //revert to the edit button and push it
    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed)];
    [[self navigationItem] setRightBarButtonItem:editButton];
    //enable start stats buttons
    [self enableStartStatsButtons];
}

-(void)disableStartStatsButtons {
    [_start setAlpha:0.5f];
    [_stats setAlpha:0.5f];
    [_start setEnabled:FALSE];
    [_stats setEnabled:FALSE];
}

-(void)enableStartStatsButtons {
    [_start setAlpha:1.0f];
    [_stats setAlpha:1.0f];
    [_start setEnabled:TRUE];
    [_stats setEnabled:TRUE];
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
}

-(void)updateActionWithString:(NSString *)actionNamed {
    [[self delegate] updateWorkout:[self getWorkoutFromController] updateAction:[self getActionForName:actionNamed]];
}

-(void)updateAction:(Action *)action withCount:(NSString *)newCount {
    [action setCount:newCount];
    [[self delegate] updateWorkout:[self getWorkoutFromController] updateAction:action];
}

-(void)updateAction:(Action *)action withName:(NSString *)newName {
    [action setName:newName];
    [[self delegate] updateWorkout:[self getWorkoutFromController] updateAction:action];
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
