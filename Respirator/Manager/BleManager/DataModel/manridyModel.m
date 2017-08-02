//
//  manridyModel.m
//  ManridyBleDemo
//
//  Created by 莫福见 on 16/9/12.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "manridyModel.h"

@implementation manridyModel

- (SetTimeModel *)setTimeModel
{
    if (!_setTimeModel) {
        _setTimeModel = [[SetTimeModel alloc] init];
    }
    
    return _setTimeModel;
}

- (UserInfoModel *)userInfoModel
{
    if (!_userInfoModel) {
        _userInfoModel = [[UserInfoModel alloc] init];
    }
    
    return _userInfoModel;
}

- (StepModel *)sportModel
{
    if (!_sportModel) {
        _sportModel = [[StepModel alloc] init];
    }
    
    return  _sportModel;
}

- (FirmwareModel *)firmwareModel
{
    if (!_firmwareModel) {
        _firmwareModel = [[FirmwareModel alloc] init];
    }
    
    return _firmwareModel;
}

- (SegmentedStepModel *)segmentStepModel
{
    if (!_segmentStepModel) {
        _segmentStepModel = [[SegmentedStepModel alloc] init];
    }
    
    return _segmentStepModel;
}

- (SportTargetModel *)sportTargetModel
{
    if (!_sportTargetModel) {
        _sportTargetModel = [[SportTargetModel alloc] init];
    }
    
    return _sportTargetModel;
}

@end
