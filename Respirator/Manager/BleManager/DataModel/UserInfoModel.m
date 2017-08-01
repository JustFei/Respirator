//
//  UserInfoModel.m
//  ManridyApp
//
//  Created by JustFei on 16/10/13.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeInteger:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.height forKey:@"height"];
    [aCoder encodeObject:self.weight forKey:@"weight"];
    [aCoder encodeInteger:self.stepLength forKey:@"stepLength"];
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.gender = [aDecoder decodeIntegerForKey:@"gender"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.height = [aDecoder decodeObjectForKey:@"height"];
        self.weight = [aDecoder decodeObjectForKey:@"weight"];
        self.stepLength = [aDecoder decodeIntegerForKey:@"stepLength"];
    }
    return self;
}

@end
