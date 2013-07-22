//
//  settingsViewController.h
//  iPersonalTrainer
//
//  Created by Coshx on 7/16/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class settingsViewController;

@protocol passSettings
-(void)settingsViewControllerIsDone:(settingsViewController*)viewController;
-(void)receiveNewSettings:(NSDictionary *)newSettings;
@end

@interface settingsViewController : UIViewController

@property id delegate;
@property IBOutlet UISwitch *imageOnSwitch;
@property NSDictionary *currentSettings;

@end
