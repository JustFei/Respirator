//
//  SyncTool.m
//  New_iwear
//
//  Created by JustFei on 2017/6/1.
//  Copyright © 2017年 manridy. All rights reserved.
//

#import "SyncTool.h"
#import "FMDBManager.h"

@interface SyncTool ()
{
    /** 同步的数据量 */
    NSInteger _asynCount;
    //判断设置是否在同步中
    BOOL _syncSettingIng;
}

@property (nonatomic, assign) NSInteger sumCount;
@property (nonatomic, assign) NSInteger progressCount;
@property (nonatomic, strong) FMDBManager *myFmdbManager;

@end

@implementation SyncTool

#pragma mark - Singleton
static SyncTool *_syncTool = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSegmentStep:) name:GET_SEGEMENT_STEP object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNotificationObserver:) name:SET_FIRMWARE object:nil];
    }
    return self;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _syncTool = [[self alloc] init];
    });
    
    return _syncTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _syncTool = [super allocWithZone:zone];
    });
    
    return _syncTool;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - 数据同步
- (void)syncAllData
{
    //如果在同步中，直接返回
    if (self.syncDataIng) {
        NSLog(@"正在同步中。。。");
        return;
    }
    [self syncData];
}

- (void)syncData
{
    self.syncDataIng = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.syncDataIng = NO;
    });
    
    //同步时间
    [[BleManager shareInstance] writeTimeToPeripheral:[NSDate date]];
    [NSThread sleepForTimeInterval:0.01];
    //当前计步数据
    [[BleManager shareInstance] writeMotionRequestToPeripheralWithMotionType:MotionTypeStepAndkCal];
    [NSThread sleepForTimeInterval:0.01];
    //计步历史
    [[BleManager shareInstance] writeMotionRequestToPeripheralWithMotionType:MotionTypeDataInPeripheral];
    [NSThread sleepForTimeInterval:0.01];
    //分段计步历史
    [[BleManager shareInstance] writeSegementStepWithHistoryMode:SegmentedStepDataHistoryData];
}

#pragma mark - 设置同步
- (void)syncSetting
{
    /** 同步时间 */
    [[BleManager shareInstance] writeTimeToPeripheral:[NSDate date]];
    [NSThread sleepForTimeInterval:0.01];
    /** 同步硬件版本号 */
    [[BleManager shareInstance] writeRequestVersion];
    [NSThread sleepForTimeInterval:0.01];
    /** 同步获取电量 */
    [[BleManager shareInstance] writeGetElectricity];
    [NSThread sleepForTimeInterval:0.01];
    /** 同步用户信息设置 */
    [self writeUserInfoSetting];
}

- (void)writeUserInfoSetting
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_SETTING]) {
        NSData *infoData = [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_SETTING];
        UserInfoModel *infoModel = [NSKeyedUnarchiver unarchiveObjectWithData:infoData];
        [[BleManager shareInstance] writeUserInfoToPeripheralWeight:[NSString stringWithFormat:@"%ld",(long)infoModel.weight] andHeight:[NSString stringWithFormat:@"%@", infoModel.height]];
    }else {
        [[BleManager shareInstance] writeUserInfoToPeripheralWeight:@"60" andHeight:@"170"];
    }
}

#pragma mark - Noti
//分段计步数据
- (void)getSegmentStep:(NSNotification *)noti
{
    manridyModel *model = [noti object];
    if (model.segmentStepModel.segmentedStepState == SegmentedStepDataUpdateData) {
        //当有数据上报时，获取新数据
        if (!_syncDataIng) {
            [self syncAllData];
        }
    }else if (model.segmentStepModel.segmentedStepState == SegmentedStepDataHistoryCount) {
        self.sumCount = self.sumCount + model.segmentStepModel.AHCount;
    }else if (model.segmentStepModel.segmentedStepState == SegmentedStepDataHistoryData) {
        if (model.segmentStepModel.AHCount == 0) {
            return;
        }
        
        //插入数据库
        [self.myFmdbManager insertSegmentStepModel:model.segmentStepModel];
    }
}

//SET_FIRMWARE

- (void)setNotificationObserver:(NSNotification *)noti
{
    if ([noti.name isEqualToString:SET_FIRMWARE]) {
        // 版本号,电量,亮度
        manridyModel *model = [noti object];
        if (model.isReciveDataRight == ResponsEcorrectnessDataRgith) {
            if (model.receiveDataType == ReturnModelTypeFirwmave) {
                switch (model.firmwareModel.mode) {
                    case FirmwareModeGetVersion:
                        //版本号
                        [[NSUserDefaults standardUserDefaults] setObject:model.firmwareModel.version forKey:HARDWARE_VERSION];
                        break;
                    case FirmwareModeGetElectricity:
                        //电量
                        [[NSUserDefaults standardUserDefaults] setObject:model.firmwareModel.PerElectricity forKey:ELECTRICITY_INFO_SETTING];
                        break;
                        
                    default:
                        break;
                }
            }
        }
        
    }
}

#pragma mark - lazy
- (FMDBManager *)myFmdbManager
{
    if (!_myFmdbManager) {
        _myFmdbManager = [[FMDBManager alloc] initWithPath:DB_NAME];
    }
    
    return _myFmdbManager;
}

@end
