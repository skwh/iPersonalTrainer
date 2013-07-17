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

@property (weak) IBOutlet UILabel *runTimeLabel;
@property (weak) IBOutlet UIButton *startStopButton;
@property (weak) IBOutlet MKMapView *map;

@end
