//
//  actionEditViewController.m
//  iPersonalTrainer
//
//  Created by Coshx on 7/8/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "actionEditViewController.h"

@interface actionEditViewController ()

@property UIImagePickerController *imagePickerController;
@property BOOL deleting;

@end

@implementation actionEditViewController

@synthesize keptAction = _keptAction;
@synthesize delegate;
@synthesize actionNamed = _actionNamed;
@synthesize nameEdit = _nameEdit;
@synthesize countEdit = _countEdit;
@synthesize selectImage = _selectImage;
@synthesize actionImage = _actionImage;
@synthesize deleteActionButton = _deleteActionButton;
@synthesize cellIndexPath = _cellIndexPath;
@synthesize deleting = _deleting;

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
    _actionNamed = [_keptAction name];
    _deleting = FALSE;
    [_deleteActionButton.layer setCornerRadius:10.0f];
    [_deleteActionButton.layer setBorderColor:[UIColor blackColor].CGColor];
    [_deleteActionButton.layer setBorderWidth:2.0f];
}

-(void)viewWillAppear:(BOOL)animated {
    NSString *fullTitle = [@"Edit-" stringByAppendingString:_actionNamed];
    [self setTitle:fullTitle];
    [_nameEdit setText:_actionNamed];
    NSString *count = [NSString stringWithFormat:@"%@",[_keptAction count]];
    [_countEdit setText:count];
    UIImage *actionSetImage = [_keptAction image];
    [_actionImage setImage:actionSetImage];
}

-(void)viewWillDisappear:(BOOL)animated {
    //if the action is not being deleted
    if (!_deleting) {
        //and the settings were changed
        NSString *name = [_nameEdit text];
        NSString *count = [_countEdit text];
        if (![name isEqualToString:[_keptAction name]] || ![count isEqualToString:[NSString stringWithFormat:@"%@",[_keptAction count]]]) {
            [self setTitle:[@"Edit-" stringByAppendingString:name]];
            [_keptAction setName:name];
            [_keptAction setCount:count];
            [[self delegate] updateAction:_keptAction withName:name];
            [[self delegate] updateAction:_keptAction withCount:count];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[self delegate] deleteAction:_keptAction atIndexPath:_cellIndexPath];
        _deleting = TRUE;
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [[self navigationController] popViewControllerAnimated:YES];
    } else if (buttonIndex == 1) {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
    }
}


#pragma mark - editing methods

-(IBAction)deletedButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Action" message:@"Are you sure you want to delete this action?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"No"];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

-(IBAction)nameIsDoneEditing:(id)sender {
    NSString *newName = [_nameEdit text];
    [self setTitle:[@"Edit-" stringByAppendingString:newName]];
    _actionNamed = newName;
    [_keptAction setName:newName];
}

-(IBAction)countIsDoneEditing:(id)sender {
    NSString *newCount = [_countEdit text];
    [_keptAction setCount:newCount];
}

#pragma mark - Image Picker methods

-(void)finishAndUpdateImagePicker {
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.imagePickerController = nil;
}

-(void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)showImagePickerForPhotoPicker:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [_keptAction setImage:image];
    [_actionImage setImage:image];
    [self finishAndUpdateImagePicker];
}

@end
