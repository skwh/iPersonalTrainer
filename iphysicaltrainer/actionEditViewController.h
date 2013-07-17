//
//  actionEditViewController.h
//  iPersonalTrainer
//
//  Created by Coshx on 7/8/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "workoutViewController.h"

@interface actionEditViewController : UIViewController <UIImagePickerControllerDelegate> {
    id <passAction> delegate;
}

@property NSString *actionNamed;

@property Action *keptAction;
@property (weak) IBOutlet UITextField *nameEdit;
@property (weak) IBOutlet UITextField *countEdit;
@property (weak) IBOutlet UIButton *selectImage;
@property (weak) IBOutlet UIImageView *actionImage;
@property (retain, nonatomic) id delegate;

-(IBAction)nameIsDoneEditing:(id)sender;
-(IBAction)countIsDoneEditing:(id)sender;

@end
