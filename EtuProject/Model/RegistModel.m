//
//  RegistModel.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/1.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "RegistModel.h"

@implementation RegistModel

-(id)init
{
    self = [super init];
    if (self) {
        self.sex = @"";
        self.height = @"";
        self.weight = @"";
        self.birthday = @"";
        self.targetStep = @"";
    }
    return self;
}

@end
