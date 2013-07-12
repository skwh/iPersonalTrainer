//
//  FirstViewController.m
//  iphysicaltrainer
//
//  Created by Coshx on 7/5/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "FirstViewController.h"
#import "workoutViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

#pragma mark - Synthesizers

@synthesize tableView = _tableView;
@synthesize workouts = _workouts;
@synthesize workoutData = _workoutData;
@synthesize workoutDict = _workoutDict;
@synthesize workoutNumber = _workoutNumber;
@synthesize firstTimeLoad = _firstTimeLoad;

#pragma mark - Base methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Workouts", @"Workouts");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"Workouts"];
    _workoutDict = [[NSMutableDictionary alloc] init];
    _workouts = [[NSMutableArray alloc] init];
    _firstTimeLoad = YES;
    [self loadWorkouts];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editWorkoutButtonPressed)];
    [[self navigationItem] setRightBarButtonItem:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - workout data methods

-(void)loadWorkouts {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"workoutList" ofType:@"plist"];
    _workoutData = [NSArray arrayWithContentsOfFile:path];
    _workoutNumber = [_workoutData count];
    [_tableView reloadData];
}
-(void)writeToWorkouts:(NSMutableDictionary *)dictionary {
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"workoutList-edit" ofType:@"plist"];
    NSLog(@"Write to workouts called!");
}

-(BOOL)insertWorkoutIntoDictionaryAndCheck:(Workout *)workout {
    //[workout associateActionsAndCounts];
    [_workoutDict setObject:workout forKey:[workout name]];
    Workout *inserted = [_workoutDict objectForKey:[workout name]];
    if (inserted == NULL) {
        return FALSE;
    }
    return TRUE;
}

-(void)addWorkoutToMasterWorkouts:(Workout *)workout {
    //add workout to dict
    [_workoutDict setObject:workout forKey:[workout name]];
    //add workout to array
    [_workouts addObject:workout];
    _workoutNumber++;
}

#pragma mark - UINavigationController methods

-(IBAction)continueToNextView:(id)sender withWorkoutName:(NSString*)workoutName {
    if (_firstTimeLoad) _firstTimeLoad = NO;
    workoutViewController *workoutView = [[workoutViewController alloc] initWithNibName:@"workoutViewController" bundle:nil];
    [workoutView setWorkoutName:workoutName];
    [workoutView setDelegate:self];
    [[self navigationController] pushViewController:workoutView animated:YES];
}

-(void)editWorkoutButtonPressed {
    //set the tableview to edit mode
    [_tableView setEditing:YES];
    //create the add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWorkoutButtonPressed)];
    [[self navigationItem] setLeftBarButtonItem:addButton];
    //change the edit button to done
    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editWorkoutButtonDone)];
    [[self navigationItem] setRightBarButtonItem:editButton];
    //set the title
    [self setTitle:@"Edit Workouts"];
}

-(void)editWorkoutButtonDone {
    //set the tableview to no edit mode
    [_tableView setEditing:NO];
    //remove the add button
    [[self navigationItem] setLeftBarButtonItem:nil];
    //reset the edit button
    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editWorkoutButtonDone)];
    [[self navigationItem] setRightBarButtonItem:editButton];
    //reset the title
    [self setTitle:@"Workouts"];
    
}

-(void)addWorkoutButtonPressed {
    //check if first time load is true
    if (_firstTimeLoad) _firstTimeLoad = NO;
    //create actions and counts arrays for a new workout
    NSMutableArray *newActions = [[NSMutableArray alloc] init];
    NSMutableArray *newCounts = [[NSMutableArray alloc] init];
    //create a new blank workout
    Workout *newWorkout = [Workout initWithName:@"New Workout" andActions:newCounts andCounts:newActions];
    //add the workout to the array
    [self addWorkoutToMasterWorkouts:newWorkout];
    //refresh the table
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _workoutNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    Workout *newWorkout;
    if (_firstTimeLoad) {
        newWorkout = [self firstTimeWorkoutSetup:indexPath.row];
        //assign the object in the workout dict
        BOOL inserted = [self insertWorkoutIntoDictionaryAndCheck:newWorkout];
        //and check if it worked
        if (inserted) {
            [_workouts addObject:newWorkout];
            cell.textLabel.text = [newWorkout name];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Actions: %i",[[newWorkout actionsArray] count]];
        } else {
            cell.textLabel.text = @"Error";
            cell.textLabel.text = @"Damn bootleg fireworks";
        }
    } else {
        newWorkout = [_workouts objectAtIndex:indexPath.row];
        if (newWorkout != nil) {
            cell.textLabel.text = [newWorkout name];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Actions: %i",[[newWorkout actionsArray] count]];
        } else {
            cell.textLabel.text = @"Error";
            cell.textLabel.text = @"Damn bootleg fireworks";
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedWorkout = [_tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self continueToNextView:nil withWorkoutName:selectedWorkout];
}

#pragma mark - Workout setup methods

-(Workout*)firstTimeWorkoutSetup:(NSUInteger)row {
    NSDictionary *workoutInfo = [_workoutData objectAtIndex:row];
    return [self setupWorkoutWithInfoDictionary:workoutInfo];
}

-(Workout*)setupWorkoutWithInfoDictionary:(NSDictionary *)workoutInfo {
    //find the length of the actions
    NSInteger workoutActionsLength = [(NSArray*)[workoutInfo objectForKey:@"actions"] count];
    //create the actions array
    NSMutableArray *workoutActions = [[NSMutableArray alloc] init];
    //create an NSMutableArray for counts
    NSMutableArray *countsArray = [[NSMutableArray alloc] init];
    //for each item in the array
    for (int i=0;i<workoutActionsLength;i++) {
        //get the action array
        NSArray *actionInfo = [workoutInfo objectForKey:@"actions"];
        //get the count array
        NSArray *countInfo = [workoutInfo objectForKey:@"counts"];
        //get the name from the action array
        NSString *actionName = [actionInfo objectAtIndex:i];
        //get the count from the count array
        NSString *actionCount = [countInfo objectAtIndex:i];
        //create a new action
        Action *newAction = [Action actionWithName:actionName andCount:actionCount andImage:[UIImage imageNamed:@"first.png"]];
        //add the action to the workout's action array
        [workoutActions addObject:newAction];
        [countsArray addObject:actionCount];
    }
    
    //create the workout with the action array and info from the dict
    Workout *workout = [Workout initWithName:[workoutInfo objectForKey:@"name"] andActions:workoutActions andCounts:countsArray];
    //setup the workout's dictionary
    [workout setActionsDict:[[NSMutableDictionary alloc] init]];
    //assign the actions to the dictionary
    for (int i=0;i<workoutActions.count;i++) {
        Action *currentAction = [workoutActions objectAtIndex:i];
        [[workout actionsDict] setObject:currentAction forKey:[currentAction name]];
    }
    return workout;
}

#pragma mark - passWorkout protocol methods

-(Workout *)getWorkout:(NSString *)name {
    Workout *selectedWorkout = [_workoutDict objectForKey:name];
    return selectedWorkout;
}

-(NSInteger)getActionNumberForWorkout:(Workout*)workout {
    return [[workout actionsArray] count];
}

-(Action*)getAction:(NSString *)actionNamed forWorkout:(Workout *)workout {
    Action *action = [[workout actionsDict] objectForKey:actionNamed];
    return action;
}

-(void)updateWorkout:(Workout *)workout removeAction:(Action *)action {
    //remove action from array
    [[workout actionsArray] removeObject:action];
    //remove action from dict
    [[workout actionsDict] removeObjectForKey:[action name]];
    //remove action from counts
    [[workout countsArray] removeObject:[action count]];
    //reload the workouts table
    [_tableView reloadData];
}

-(void)updateWorkout:(Workout *)workout addAction:(Action *)action {
    //add action to array
    [[workout actionsArray] addObject:action];
    //add action to dict
    [[workout actionsDict] setObject:action forKey:[action name]];
    //add action to counts
    [[workout countsArray] addObject:[action count]];
    //reload the workouts table
    [_tableView reloadData];
}

-(void)updateWorkout:(Workout *)workout updateAction:(Action *)action {
    //this is probably dumb
    [self updateWorkout:workout removeAction:action];
    [self updateWorkout:workout addAction:action];
    [_tableView reloadData];
}

@end
