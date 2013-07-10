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

@synthesize tableView = _tableView;
@synthesize workouts = _workouts;
@synthesize workoutDict = _workoutDict;

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
    [self loadWorkouts];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWorkout)];
    [[self navigationItem] setRightBarButtonItem:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - workout loading methods

-(void)loadWorkouts {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"workoutList" ofType:@"plist"];
    _workouts = [NSArray arrayWithContentsOfFile:path];
    [_tableView reloadData];
}
-(void)writeToWorkouts:(NSMutableDictionary *)dictionary {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"workoutList-edit" ofType:@"plist"];
    NSLog(@"Write to workouts called!");
}

-(BOOL)insertWorkout:(Workout *)workout {
    [workout associateActionsAndCounts];
    [_workoutDict setObject:workout forKey:[workout name]];
    Workout *inserted = [_workoutDict objectForKey:[workout name]];
    if (inserted == NULL) {
        return FALSE;
    }
    return TRUE;
}

#pragma mark - UINavigationController methods

-(IBAction)continueToNextView:(id)sender withWorkoutName:(NSString*)workoutName {
    workoutViewController *workoutView = [[workoutViewController alloc] initWithNibName:@"workoutViewController" bundle:nil];
    [workoutView setWorkoutName:workoutName];
    [workoutView setDelegate:self];
    [[self navigationController] pushViewController:workoutView animated:YES];
}

-(void)addWorkout {
    addWorkoutViewController *addWorkoutView = [[addWorkoutViewController alloc] initWithNibName:@"addWorkoutViewController" bundle:nil];
    [[self navigationController] pushViewController:addWorkoutView animated:TRUE];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _workouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    
    NSDictionary *workoutInfo = [_workouts objectAtIndex:indexPath.row];
    Workout *workout = [Workout initWithName:[workoutInfo objectForKey:@"name"] andActions:[workoutInfo objectForKey:@"actions"] andCounts:[workoutInfo objectForKey:@"counts"]];
    [_workoutDict setObject:workout forKey:[workout name]];
    BOOL inserted = [self insertWorkout:workout];
    if (inserted) {
        cell.textLabel.text = [workout name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Actions: %i",[[workout actionsArray] count]];
    } else {
        cell.textLabel.text = @"Error";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedWorkout = [_tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self continueToNextView:nil withWorkoutName:selectedWorkout];
}

#pragma mark - passWorkout methods

-(void)passWorkout:(Workout *)passedWorkout {
    [_workouts addObject:passedWorkout];
    [_workoutDict setObject:passedWorkout forKey:[passedWorkout name]];
    NSLog(@"workouts array after update:%@",[_workouts description]);
}

-(void)passWorkoutArray:(NSMutableArray *)passedWorkoutArray {
    _workouts = passedWorkoutArray;
    [[self tableView] reloadData];
}

-(void)passWorkoutDictionary:(NSMutableDictionary *)passedWorkoutDictionary {
    _workoutDict = passedWorkoutDictionary;
    [[self tableView] reloadData];
}

-(NSMutableDictionary *)returnWorkoutDictionary {
    return _workoutDict;
}

-(NSMutableArray *)returnWorkoutArray {
    return _workouts;
}

-(Workout *)getWorkout:(NSString *)name {
    return [_workoutDict objectForKey:name];
}

-(void)updateWorkout:(Workout *)workout ofAction:(Action *)action {
    //remove action from array
    [[workout actionsArray] removeObject:action];
    //remove action from dict
    [[workout actionsDict] removeObjectForKey:[action name]];
    //remove action from counts
    [[workout countsArray] removeObject:[action count]];
}

@end
