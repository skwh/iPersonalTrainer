//
//  setTimerViewController.h
//  iPersonalTrainer
//
//  Created by Coshx on 7/15/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class setTimerViewController;

@protocol setTimerViewControllerDelegate

-(void)setTimerViewControllerDidFinish:(setTimerViewController*)viewController;
-(void)recievePickerData:(NSTimeInterval)interval;

@end

@interface setTimerViewController : UIViewController <UINavigationBarDelegate>

@property (assign, nonatomic) id <setTimerViewControllerDelegate> delegate;

-(IBAction)done:(id)sender;

@end