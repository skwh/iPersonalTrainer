//
//  SecondViewController.h
//  iphysicaltrainer
//
//  Created by Coshx on 7/5/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SecondViewController : UIViewController

@property BOOL usingLargeScreen;

-(void)timerFired;
-(IBAction)startStopButtonPressed:(id)sender;
-(void)updateRunTimeLabel;

@end
