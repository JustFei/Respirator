//
//  FMDBManager.h
//  ManridyApp
//
//  Created by JustFei on 16/10/9.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class StepModel;
@class HeartRateModel;
@class UserInfoModel;
@class SleepModel;
@class ClockModel;
@class BloodModel;
@class BloodO2Model;
@class SedentaryModel;

typedef enum : NSUInteger {
    SQLTypeStep = 0,
    SQLTypeHeartRate,
    SQLTypeTemperature,
    SQLTypeSleep,
    SQLTypeBloodPressure,
    SQLTypeUserInfoModel,
} SQLType;

typedef enum : NSUInteger {
    QueryTypeAll = 0,
    QueryTypeWithDay,
    QueryTypeWithMonth,
    QueryTypeWithLastCount      //取出最后几条数据
} QueryType;

@interface FMDBManager : NSObject

- (instancetype)initWithPath:(NSString *)path;

#pragma mark - StepData 
//插入模型数据
- (BOOL)insertStepModel:(StepModel *)model;

//查询数据,如果 传空 默认会查询表中所有数据
- (NSArray *)queryStepWithDate:(NSString *)date;

//删除数据,如果 传空 默认会删除表中所有数据
//- (BOOL)deleteData:(NSString *)deleteSql;

//修改数据
- (BOOL)modifyStepWithDate:(NSString *)date model:(StepModel *)model;

#pragma mark - SegmentStepData
//插入分段计步数据
- (BOOL)insertSegmentStepModel:(SegmentedStepModel *)model;

//查询分段计步数据
- (NSArray *)querySegmentedStepWithDate:(NSString *)date;


#pragma mark - CloseData
- (void)CloseDataBase;

@end
