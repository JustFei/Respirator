//
//  FMDBManager.h
//  ManridyApp
//
//  Created by JustFei on 16/10/9.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class SportModel;
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
- (BOOL)insertStepModel:(SportModel *)model;

//查询数据,如果 传空 默认会查询表中所有数据
- (NSArray *)queryStepWithDate:(NSString *)date;

//删除数据,如果 传空 默认会删除表中所有数据
//- (BOOL)deleteData:(NSString *)deleteSql;

//修改数据
- (BOOL)modifyStepWithDate:(NSString *)date model:(SportModel *)model;


#pragma mark - CloseData
- (void)CloseDataBase;

@end
