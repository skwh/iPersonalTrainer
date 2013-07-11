//
//  Action.m
//  iPersonalTrainer
//
//  Created by Coshx on 7/8/13.
//  Copyright (c) 2013 skwh. All rights reserved.
//

#import "Action.h"

@implementation Action

@synthesize image;
@synthesize name;
@synthesize count;

#pragma mark - factory methods

+(Action *)actionWithName:(NSString*)name {
    Action *newAct = [Action alloc];
    [newAct setName:name];
    return newAct;
}
+(Action *)actionWithName:(NSString*)name andCount:(NSString *)count {
    Action *newAct = [Action alloc];
    [newAct setName:name];
    [newAct setCount:count];
    return  newAct;
}
+(Action *)actionWithName:(NSString*)name andImage:(UIImage *)image {
    Action *newAct = [Action alloc];
    [newAct setName:name];
    [newAct setImage:image];
    return  newAct;
}
+(Action *)actionWithName:(NSString *)name andCount:(NSString *)count andImage:(UIImage *)image {
    Action *newAct = [Action alloc];
    [newAct setName:name];
    [newAct setCount:count];
    [newAct setImage:image];
    return newAct;
}
-(NSString *)description {
    return [self name];
}
@end
