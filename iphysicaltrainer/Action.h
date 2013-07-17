//
//  Action.h
//  iPersonalTrainer
//
//  Created by Coshx on 7/8/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Action : NSObject

+(Action *)actionWithName:(NSString *)name;
+(Action *)actionWithName:(NSString *)name andCount:(NSString *)count;
+(Action *)actionWithName:(NSString *)name andImage:(UIImage *)image;
+(Action *)actionWithName:(NSString *)name andCount:(NSString *)count andImage:(UIImage *)image;

@property (strong) UIImage *image;
@property (strong) NSString *name;
@property (strong) NSString *count;
@property (strong) NSTimer *timer;

@end
