//
//  AnalysisProcotolTool.h
//  ManridyBleDemo
//
//  Created by 莫福见 on 16/9/14.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class manridyModel;

@interface AnalysisProcotolTool : NSObject


@property (nonatomic ,assign) float staticLon;

@property (nonatomic ,assign) float staticLat;

+ (instancetype)shareInstance;

//解析设置时间数据（00|80）
- (manridyModel *)analysisSetTimeData:(NSData *)data WithHeadStr:(NSString *)head;

//解析获取运动信息的数据（03|83）
- (manridyModel *)analysisGetSportData:(NSData *)data WithHeadStr:(NSString *)head;

//解析用户信息的数据（06|86）
- (manridyModel *)analysisUserInfoData:(NSData *)data WithHeadStr:(NSString *)head;

//解析运动目标的数据（07|87）
- (manridyModel *)analysisSportTargetData:(NSData *)data WithHeadStr:(NSString *)head;

//解析查找设备的数据 (10|90)
- (BOOL)analysisSearchRequest:(NSData *)data withHeadStr:(NSString *)head;

//解析固件维护指令的数据（0F|8F）
- (manridyModel *)analysisFirmwareData:(NSData *)data WithHeadStr:(NSString *)head;

//解析分段计步的数据（1A|8A）
- (manridyModel *)analysisSegmentedStep:(NSData *)data WithHeadStr:(NSString *)head;

@end
