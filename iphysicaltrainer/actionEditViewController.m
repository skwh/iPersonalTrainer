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

@end

@implementation actionEditViewController

@synthesize keptAction = _keptAction;
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
    _actionNamed = [_keptAction name];
    
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
    //save the settings, even if they weren't changed
    NSString *name = [_nameEdit text];
    [self setTitle:[@"Edit-" stringByAppendingString:name]];
    NSString *count = [_countEdit text];
    [_keptAction setName:name];
    [[self delegate] updateAction:_keptAction withName:name];
    [[self delegate] updateAction:_keptAction withCount:count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
