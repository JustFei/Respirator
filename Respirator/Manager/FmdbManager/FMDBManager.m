//
//  FMDBManager.m
//  ManridyApp
//
//  Created by JustFei on 16/10/9.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "FMDBManager.h"
#import "SportModel.h"
#import "UserInfoModel.h"

@implementation FMDBManager

static FMDatabase *_fmdb;

#pragma mark - init
/**
 *  创建数据库文件
 *
 *  @param path 数据库名字，以用户名+MotionData命名
 *
 */
- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    
    if (self) {
        NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.sqlite",path]];
        _fmdb = [FMDatabase databaseWithPath:filepath];
        
        NSLog(@"数据库路径 == %@", filepath);
        
        if ([_fmdb open]) {
            NSLog(@"数据库打开成功");
        }
        
//        //UserInfoData
//        [_fmdb executeUpdate:[NSString stringWithFormat:@"create table if not exists UserInfoData(id integer primary key, username text, gender text, age integer, height integer, weight integer, steplength integer, steptarget integer, sleeptarget integer);"]];

        //MotionData
        [_fmdb executeUpdate:[NSString stringWithFormat:@"create table if not exists MotionData(id integer primary key, date text, step text, kCal text, mileage text, currentDataCount integer, sumDataCount integer);"]];
    }
    
    return self;
}

#pragma mark - StepData
/**
 *  插入数据模型
 *
 *  @param model 运动数据模型
 *
 *  @return 是否成功
 */
- (BOOL)insertStepModel:(SportModel *)model
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO MotionData(date, step, kCal, mileage, currentDataCount, sumDataCount) VALUES ('%@', '%@', '%@', '%@', '%@', '%@');", model.date, model.stepNumber, model.kCalNumber, model.mileageNumber, [NSNumber numberWithInteger: model.currentDataCount],[NSNumber numberWithInteger:model.sumDataCount]];
    
    BOOL result = [_fmdb executeUpdate:insertSql];
    if (result) {
        NSLog(@"插入Motion数据成功");
    }else {
        NSLog(@"插入Motion数据失败");
    }
    return result;
}

/**
 *  查找数据
 *
 *  @param date 查找的关键字
 *
 *  @return 返回所有查找的结果
 */
- (NSArray *)queryStepWithDate:(NSString *)date {
    
    NSString *queryString;
    
    FMResultSet *set;
    
    if (date == nil) {
        queryString = [NSString stringWithFormat:@"SELECT * FROM MotionData;"];
        
        set = [_fmdb executeQuery:queryString];
    }else {
        //这里一定不能将？用需要查询的日期代替掉
        queryString = [NSString stringWithFormat:@"SELECT * FROM MotionData where date = ?;"];
        
        set = [_fmdb executeQuery:queryString ,date];
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    
    while ([set next]) {
        
        NSString *step = [set stringForColumn:@"step"];
        NSString *kCal = [set stringForColumn:@"kCal"];
        NSString *mileage = [set stringForColumn:@"mileage"];
        NSInteger currentDataCount = [set stringForColumn:@"currentDataCount"].integerValue;
        NSInteger sumDataCount = [set stringForColumn:@"sumDataCount"].integerValue;
        
        SportModel *model = [[SportModel alloc] init];
        
        model.date = date;
        model.stepNumber = step;
        model.kCalNumber = kCal;
        model.mileageNumber = mileage;
        model.currentDataCount = currentDataCount;
        model.sumDataCount = sumDataCount;
        
        NSLog(@"%@的数据：步数=%@，卡路里=%@，里程=%@",date ,step ,kCal ,mileage);
        
        [arrM addObject:model];
    }
    
    NSLog(@"Motion查询成功");
    return arrM;
}

/**
 *  修改数据内容
 *
 *  @param date  需要修改的日期
 *  @param model 需要修改的模型内容
 *
 *  @return 是否修改成功
 */
- (BOOL)modifyStepWithDate:(NSString *)date model:(SportModel *)model
{
    if (date == nil) {
        NSLog(@"传入的日期为空，不能修改");
        
        return NO;
    }
    
    NSString *modifySql = [NSString stringWithFormat:@"update MotionData set step = ?, kCal = ?, mileage = ? where date = ?" ];
    
    BOOL modifyResult = [_fmdb executeUpdate:modifySql, model.stepNumber, model.kCalNumber, model.mileageNumber, date];
    
    if (modifyResult) {
        NSLog(@"Motion数据修改成功");
    }else {
        NSLog(@"Motion数据修改失败");
    }
   
    return modifyResult;
}

@end
