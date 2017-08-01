//
//  manridyModel.h
//  ManridyBleDemo
//
//  Created by 莫福见 on 16/9/12.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetTimeModel.h"
#import "UserInfoModel.h"
#import "SportModel.h"
#import "FirmwareModel.h"

typedef enum : NSUInteger {
    ResponsEcorrectnessDataFail = 0,
    ResponsEcorrectnessDataRgith
} ResponsEcorrectnessData;

typedef enum : NSUInteger {
    ReturnModelTypeSetTimeModel = 0,
    ReturnModelTypeSportModel,
    ReturnModelTypeFirwmave,
    ReturnModelTypeUserInfoModel
} ReturnModelType;


@interface manridyModel : NSObject

//判断返回数据是否成功
@property (nonatomic, assign) ResponsEcorrectnessData isReciveDataRight;

//返回信息的类型
@property (nonatomic, assign) ReturnModelType receiveDataType;

//返回设置时间数据
@property (nonatomic, strong) SetTimeModel *setTimeModel;

//用户信息
@property (nonatomic, strong) UserInfoModel *userInfoModel;

//返回运动信息数据
@property (nonatomic, strong) SportModel *sportModel;

//设备信息
@property (nonatomic, strong) FirmwareModel *firmwareModel;

@end



