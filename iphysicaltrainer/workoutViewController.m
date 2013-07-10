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
    NSLog(@"workoutViewControllerLoaded, with workout:%@",_workoutName);
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed)];
    [[self navigationItem] setRightBarButtonItem:button];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                      style: UIBarButtonItemStyleBordered
//                                     target:nil
//                                     action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self setTitle:_workoutName];
    [_actionListTable reloadData];
}

-(Workout *)getWorkoutFromController {
    return [[self delegate] getWorkout:_workoutName];
}

#pragma mark - NavigationController methods

-(IBAction)continueToNextView:(id)sender {
    if (sender == _stats) {
        workoutStatsViewController *statsController = [[workoutStatsViewController alloc] initWithNibName:@"workoutStatsViewController" bundle:nil];
        [[self navigationController] pushViewController:statsController animated:TRUE];
    } else if (sender == _start) {
        workoutProgress *progressController = [[workoutProgress alloc] initWithNibName:@"workoutProgress" bundle:nil];
        [[self navigationController] pushViewController:progressController animated:TRUE];
    }
}

-(void)addAction {
    addActionViewController *addController = [[addActionViewController alloc] initWithNibName:@"addActionViewController" bundle:nil];
    [[self navigationController] pushViewController:addController animated:TRUE];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self getWorkoutFromController] actionsArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"ActionCellID";
    UITableViewCell *cell = [_actionListTable dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    Action *currentAction = [[[self getWorkoutFromController] actionsArray] objectAtIndex:indexPath.row];
    NSLog(@"%@",[currentAction description]);
    cell.textLabel.text = [currentAction description];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",currentAction.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    Action *actionDeleted = [[[self getWorkoutFromController] actionsDict] objectForKey:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    [self removeActionsFromWorkout:actionDeleted];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - Recieve data methods

-(void)refreshLabelData {
    [self setTitle:_workoutName];
    [_actionListTable reloadData];
}

-(void)addActionsToWorkout:(NSArray *)newActions {
    [[[self getWorkoutFromController] actionsArray] addObjectsFromArray:newActions];
}

-(void)removeActionsFromWorkout:(Action *)deletedActions {
    [[self delegate] updateWorkout:[self getWorkoutFromController] ofAction:deletedActions];
}

#pragma mark - edit mode methods

-(void)editButtonPressed {
    [_actionListTable setEditing:TRUE];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    [[self navigationItem] setLeftBarButtonItem:addButton animated:TRUE];
    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonDone)];
    [[self navigationItem] setRightBarButtonItem:editButton animated:TRUE];
    [self disableButtons];
}

-(void)editButtonDone {
    [_actionListTable setEditing:FALSE];
    [[self navigationItem] setLeftBarButtonItem:nil animated:NO];
    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed)];
    [[self navigationItem] setRightBarButtonItem:editButton];
    [self enableButtons];
}

-(void)disableButtons {
    [_start setAlpha:0.5f];
    [_stats setAlpha:0.5f];
    [_start setEnabled:FALSE];
    [_stats setEnabled:FALSE];
}

-(void)enableButtons {
    [_start setAlpha:1.0f];
    [_stats setAlpha:1.0f];
    [_start setEnabled:TRUE];
    [_stats setEnabled:TRUE];
}


@end
