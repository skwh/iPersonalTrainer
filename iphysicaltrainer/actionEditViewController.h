//
//  actionEditViewController.h
//  iPersonalTrainer
//
//  Created by Coshx on 7/8/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "workoutViewController.h"

@interface actionEditViewController : UIViewController {
    id <passAction> delegate;
}

@property NSString *actionNamed;

@property IBOutlet UITextField *nameEdit;
@property IBOutlet UITextField *countEdit;
@property IBOutlet UIButton *selectImage;
@property IBOutlet UIImageView *actionImage;
@property id delegate;

-(IBAction)nameIsDoneEditing:(id)sender;
-(IBAction)countIsDoneEditing:(id)sender;

-(Action*)getActionFromController;

@end
