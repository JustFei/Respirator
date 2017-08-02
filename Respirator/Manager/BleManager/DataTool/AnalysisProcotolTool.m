//
//  AnalysisProcotolTool.m
//  ManridyBleDemo
//
//  Created by 莫福见 on 16/9/14.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AnalysisProcotolTool.h"
#import "manridyModel.h"
#import "NSStringTool.h"
#import "AppDelegate.h"

@interface AnalysisProcotolTool ()

@end

@implementation AnalysisProcotolTool

#pragma mark - Singleton
static AnalysisProcotolTool *analysisProcotolTool = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        analysisProcotolTool = [[self alloc] init];
    });
    
    return analysisProcotolTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        analysisProcotolTool = [super allocWithZone:zone];
    });
    
    return analysisProcotolTool;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - 解析协议数据
#pragma mark 解析设置时间数据（00|80）
- (manridyModel *)analysisSetTimeData:(NSData *)data WithHeadStr:(NSString *)head
{
    manridyModel *model = [[manridyModel alloc] init];
    model.receiveDataType = ReturnModelTypeSetTimeModel;
    
    if ([head isEqualToString:@"00"]) {
        NSData *timeData = [data subdataWithRange:NSMakeRange(1, 7)];
        NSString *timeStr = [NSStringTool convertToNSStringWithNSData:timeData];
        model.setTimeModel.time = timeStr;
        model.isReciveDataRight = ResponsEcorrectnessDataRgith;
        
        //        NSLog(@"设定了时间为：%@\n%@",timeStr,model.setTimeModel.time);
    }else if ([head isEqualToString:@"80"]) {
        model.isReciveDataRight = ResponsEcorrectnessDataFail;
    }
    
    return model;
}

#pragma mark 解析获取运动信息的数据（03|83）
- (manridyModel *)analysisGetSportData:(NSData *)data WithHeadStr:(NSString *)head
{
    manridyModel *model = [[manridyModel alloc] init];
    model.receiveDataType = ReturnModelTypeSportModel;
    
    const unsigned char *hexBytes = [data bytes];
    NSString *ENStr = [NSString stringWithFormat:@"%02x", hexBytes[1]];
    NSString *historyDataCount = [NSString stringWithFormat:@"%02x", hexBytes[2]];
    NSString *currentDataCount = [NSString stringWithFormat:@"%02x", hexBytes[3]];
    
    if ([head isEqualToString:@"03"]) {
        
        model.isReciveDataRight = ResponsEcorrectnessDataRgith;
        
        if ([ENStr isEqualToString:@"01"]) {
            //这里不做单纯获取step的数据的操作
            model.sportModel.motionType = MotionTypeStep;
        }else if ([ENStr isEqualToString:@"07"]) {
            NSData *stepData = [data subdataWithRange:NSMakeRange(2, 3)];
            int stepValue = [NSStringTool parseIntFromData:stepData];
            //        NSLog(@"今日步数 = %d",stepValue);
            NSString *stepStr = [NSString stringWithFormat:@"%d",stepValue];
            
            NSData *mileageData = [data subdataWithRange:NSMakeRange(5, 3)];
            int mileageValue = [NSStringTool parseIntFromData:mileageData];
            //        NSLog(@"今日里程数 = %d",mileageValue);
            NSString *mileageStr = [NSString stringWithFormat:@"%d",mileageValue];
            
            NSData *kcalData = [data subdataWithRange:NSMakeRange(8, 3)];
            int kcalValue = [NSStringTool parseIntFromData:kcalData];
            //        NSLog(@"卡路里 = %d",kcalValue);
            NSString *kCalStr = [NSString stringWithFormat:@"%d",kcalValue];
            
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy/MM/dd"];
            NSDate *currentDate = [NSDate date];
            NSString *currentDateString = [dateformatter stringFromDate:currentDate];
            
            model.sportModel.date = currentDateString;
            model.sportModel.stepNumber = stepStr;
            model.sportModel.mileageNumber = mileageStr;
            model.sportModel.kCalNumber = kCalStr;
            model.sportModel.motionType = MotionTypeStepAndkCal;
        }else if ([ENStr isEqualToString:@"80"]) {
            model.sportModel.sumDataCount = historyDataCount.integerValue;
            model.sportModel.motionType = MotionTypeCountOfData;
        }else if ([ENStr isEqualToString:@"C0"] || [ENStr isEqualToString:@"c0"]) {
            model.sportModel.sumDataCount = historyDataCount.integerValue;
            model.sportModel.currentDataCount = currentDataCount.integerValue;
            
            NSData *time = [data subdataWithRange:NSMakeRange(4, 3)];
            NSString *timeStr = [NSString stringWithFormat:@"%@",time];
            
            NSString *yearStr = [timeStr substringWithRange:NSMakeRange(1, 2)];
            NSString *monthStr = [timeStr substringWithRange:NSMakeRange(3, 2)];
            NSString *dayStr = [timeStr substringWithRange:NSMakeRange(5, 2)];
            
            NSData *stepData = [data subdataWithRange:NSMakeRange(9, 3)];
            int stepValue = [NSStringTool parseIntFromData:stepData];
            NSString *stepStr = [NSString stringWithFormat:@"%d",stepValue];
            NSString *dateStr = [NSString stringWithFormat:@"20%@/%@/%@",yearStr ,monthStr ,dayStr];
            
            NSLog(@"yy == %@ , mm == %@ , dd == %@ , date == %@",yearStr ,monthStr ,dayStr ,dateStr );
            NSLog(@"step = %@",stepStr);
    
            model.sportModel.stepNumber = stepStr;
            model.sportModel.date = dateStr;
            model.sportModel.motionType = MotionTypeDataInPeripheral;
        }
    }else if ([head isEqualToString:@"83"]) {
        model.isReciveDataRight = ResponsEcorrectnessDataFail;
    }
    
    return model;
}

#pragma mark 解析运动目标的数据（07|87）
- (manridyModel *)analysisSportTargetData:(NSData *)data WithHeadStr:(NSString *)head
{
    manridyModel *model = [[manridyModel alloc] init];
    model.receiveDataType = ReturnModelTypeSportTargetModel;
    
    if ([head isEqualToString:@"07"]) {
        NSData *target = [data subdataWithRange:NSMakeRange(2, 3)];
        int targetValue = [NSStringTool parseIntFromData:target];
        NSString *targetStr = [NSString stringWithFormat:@"%d",targetValue];
        
        model.isReciveDataRight = ResponsEcorrectnessDataRgith;
        
        model.sportTargetModel.sportTargetNumber = targetStr;
        
    }else if ([head isEqualToString:@"87"]) {
        model.isReciveDataRight = ResponsEcorrectnessDataFail;
    }
    
    return model;
}

#pragma mark 解析用户信息的数据（06|86）
- (manridyModel *)analysisUserInfoData:(NSData *)data WithHeadStr:(NSString *)head
{
    manridyModel *model = [[manridyModel alloc] init];
    model.receiveDataType = ReturnModelTypeUserInfoModel;
    
    if ([head isEqualToString:@"06"]) {
        NSData *weight = [data subdataWithRange:NSMakeRange(1, 1)];
        int weightValue = [NSStringTool parseIntFromData:weight];
        NSString *weightStr = [NSString stringWithFormat:@"%d",weightValue];
        
        NSData *height = [data subdataWithRange:NSMakeRange(2, 1)];
        int heightValue = [NSStringTool parseIntFromData:height];
        NSString *heightStr = [NSString stringWithFormat:@"%d",heightValue];
        
        model.userInfoModel.weight = weightStr;
        model.userInfoModel.height = heightStr;
        model.isReciveDataRight = ResponsEcorrectnessDataRgith;
        
    }else if ([head isEqualToString:@"86"]) {
        model.isReciveDataRight = ResponsEcorrectnessDataFail;
    }
    
    return model;
}


#pragma mark 解析固件维护指令的数据（0F|8F）
- (manridyModel *)analysisFirmwareData:(NSData *)data WithHeadStr:(NSString *)head
{
    const unsigned char *hexBytes = [data bytes];
    NSString *typeStr = [NSString stringWithFormat:@"%02x", hexBytes[1]];
    manridyModel *model = [[manridyModel alloc] init];
    if ([head isEqualToString:@"0f"]) {
        model.isReciveDataRight = ResponsEcorrectnessDataRgith;
        model.receiveDataType = ReturnModelTypeFirwmave;
        
        if ([typeStr isEqualToString:@"04"]) {//亮度
            model.firmwareModel.mode = FirmwareModeSetLCD;
        }else if ([typeStr isEqualToString:@"05"]) {//版本号
            int maint = hexBytes[7];
            int miint = hexBytes[8];
            int reint = hexBytes[9];
            
            NSString *versionStr = [[[NSString stringWithFormat:@"%d", maint] stringByAppendingString:[NSString stringWithFormat:@".%d",miint]] stringByAppendingString:[NSString stringWithFormat:@".%d",reint]];
            
            model.firmwareModel.mode = FirmwareModeGetVersion;
            model.firmwareModel.version = versionStr;
        }else if ([typeStr isEqualToString:@"06"]) {//电量
            NSString *batteryStr = [NSString stringWithFormat:@"%x", hexBytes[8]];
            model.firmwareModel.mode = FirmwareModeGetElectricity;
            model.firmwareModel.PerElectricity = [NSString stringWithFormat:@"%d", [NSStringTool parseIntFromData:[data subdataWithRange:NSMakeRange(8, 1)]]];
            NSLog(@"电量：%@",batteryStr);
        }
    }else if ([head isEqualToString:@"8f"]) {
        model.isReciveDataRight = ResponsEcorrectnessDataFail;
    }
    
    return model;
}

#pragma mark 解析分段计步的数据（1A|8A）
//解析分段计步的数据（1A|8A）
- (manridyModel *)analysisSegmentedStep:(NSData *)data WithHeadStr:(NSString *)head
{
    manridyModel *model = [[manridyModel alloc] init];
    model.receiveDataType = ReturnModelTypeSegmentStepModel;
    
    if ([head isEqualToString:@"1a"]) {
        const unsigned char *hexBytes = [data bytes];
        NSString *TyStr = [NSString stringWithFormat:@"%02x", hexBytes[1]];
        if ([TyStr isEqualToString:@"01"]) {
            model.segmentStepModel.segmentedStepState = SegmentedStepDataUpdateData;
        }else if ([TyStr isEqualToString:@"02"]) {
            model.segmentStepModel.segmentedStepState = SegmentedStepDataHistoryCount;
        }else if ([TyStr isEqualToString:@"04"]) {
            model.segmentStepModel.segmentedStepState = SegmentedStepDataHistoryData;
        }
        //将nsdata 转为 byte 数组
        NSUInteger len = [data length];
        Byte *byteData = (Byte*)malloc(len);
        memcpy(byteData, [data bytes], len);
        
        int ah = (((byteData[2] << 4) & 0x0ff0) | ((byteData[3] >> 4) & 0x0f)) & 0x0fff;
        int ch = (byteData[4] | ((byteData[3] & 0x0f) << 8)) & 0x0fff;
        int timeInterval = byteData[18];
        NSData *stepData = [data subdataWithRange:NSMakeRange(5, 3)];
        int stepValue = [NSStringTool parseIntFromData:stepData];
        
        NSData *mileageData = [data subdataWithRange:NSMakeRange(8, 3)];
        int mileageValue = [NSStringTool parseIntFromData:mileageData];
        
        NSData *kcalData = [data subdataWithRange:NSMakeRange(11, 3)];
        int kcalValue = [NSStringTool parseIntFromData:kcalData];
        
        NSData *startTimeData = [data subdataWithRange:NSMakeRange(14, 4)];
        int startTimeValue = [NSStringTool parseIntFromData:startTimeData];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        //utc 时间转为标准时间，不会存在时区差异
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSString *startTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startTimeValue]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startTimeValue]];
        
        model.segmentStepModel.AHCount = ah;
        model.segmentStepModel.CHCount = ch;
        model.segmentStepModel.stepNumber = [NSString stringWithFormat:@"%d",stepValue];
        model.segmentStepModel.kCalNumber = [NSString stringWithFormat:@"%d",mileageValue];
        model.segmentStepModel.mileageNumber = [NSString stringWithFormat:@"%d",kcalValue];
        model.segmentStepModel.startTime = startTimeStr;
        model.segmentStepModel.date = dateStr;
        model.segmentStepModel.timeInterval = timeInterval;
        
        NSLog(@"segmentStepModel == %@", model.segmentStepModel);
    }else {
        model.isReciveDataRight = ResponsEcorrectnessDataFail;
    }
    
    return  model;
}

@end
