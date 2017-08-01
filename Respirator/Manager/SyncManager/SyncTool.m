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
/** 控制同步发送消息的信号量 */
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_queue_t sendMessageQueue;
@property (nonatomic, strong) FMDBManager *myFmdbManager;
@property (nonatomic, strong) MDSnackbar *stateBar;

@end

@implementation SyncTool

#pragma mark - Singleton
static SyncTool *_syncTool = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSegmentStep:) name:GET_SEGEMENT_STEP object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSegmentRun:) name:GET_SEGEMENT_RUN object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSleep:) name:GET_SLEEP_DATA object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHR:) name:GET_HR_DATA object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBP:) name:GET_BP_DATA object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBO:) name:GET_BO_DATA object:nil];
        //注册所有通知
        NSArray *observerArr = @[SET_TIME,
                                 SET_FIRMWARE,
                                 SET_WINDOW,
                                 GET_SEDENTARY_DATA,
                                 LOST_PERIPHERAL_SWITCH,
                                 SET_CLOCK,
                                 SET_UNITS_DATA,
                                 SET_TIME_FORMATTER,
                                 SET_MOTION_TARGET,
                                 SET_USER_INFO];
        for (NSString *keyWord in observerArr) {
            [[NSNotificationCenter defaultCenter]
             addObserver:self selector:@selector(setNotificationObserver:) name:keyWord object:nil];
        }
        // 信号量初始化为1
        self.semaphore = dispatch_semaphore_create(1);
        self.sendMessageQueue = dispatch_get_global_queue(0, 0);
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
}

- (void)syncData
{
    self.syncDataIng = YES;
    NSLog(@"syncDataIng == %d", self.syncDataIng);
    //初始化计数器
    self.sumCount = 0;
    
    //同步时间
    [[BleManager shareInstance] writeTimeToPeripheral:[NSDate date]];
    //当前计步数据
    [[BleManager shareInstance] writeMotionRequestToPeripheralWithMotionType:MotionTypeStepAndkCal];
    [self writeHistoryData];
}

- (void)writeHistoryData
{
    for (int i = 0; i <= 100; i ++) {
        [self updateProgress:i];
        [NSThread sleepForTimeInterval:0.01];
    }
}

#pragma mark - 设置同步
- (void)syncSetting
{
    _asynCount = 0;
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
    [NSThread sleepForTimeInterval:0.01];
}

- (void)writeUserInfoSetting
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_SETTING]) {
        NSData *infoData = [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_SETTING];
        UserInfoModel *infoModel = [NSKeyedUnarchiver unarchiveObjectWithData:infoData];
        [[BleManager shareInstance] writeUserInfoToPeripheralWeight:[NSString stringWithFormat:@"%ld",(long)infoModel.weight] andHeight:[NSString stringWithFormat:@"%ld", infoModel.height]];
    }else {
        [[BleManager shareInstance] writeUserInfoToPeripheralWeight:@"60" andHeight:@"170"];
    }
}

/**
 SET_TIME,
 SET_FIRMWARE,
 SET_WINDOW,
 GET_SEDENTARY_DATA,
 LOST_PERIPHERAL_SWITCH,
 SET_CLOCK,
 SET_UNITS_DATA,
 SET_TIME_FORMATTER,
 SET_MOTION_TARGET,
 SET_USER_INFO;
 */

- (void)setNotificationObserver:(NSNotification *)noti
{
    NSLog(@"asynCount == %ld noti.name == %@",_asynCount ,noti.name);
    
    if ([noti.name isEqualToString:SET_TIME] ||
        [noti.name isEqualToString:SET_WINDOW] ||
        [noti.name isEqualToString:GET_SEDENTARY_DATA] ||
        [noti.name isEqualToString:LOST_PERIPHERAL_SWITCH] ||
        [noti.name isEqualToString:SET_UNITS_DATA] ||
        [noti.name isEqualToString:SET_TIME_FORMATTER] ||
        [noti.name isEqualToString:SET_MOTION_TARGET] ||
        [noti.name isEqualToString:SET_USER_INFO]) {
        BOOL isFirst = noti.userInfo[@"success"];
        if (isFirst == 1)
        {
            _asynCount ++;
        }
        else [self asynFail];
    }else if ([noti.name isEqualToString:SET_FIRMWARE]) {
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
            _asynCount ++;
        }else [self asynFail];
    }else if ([noti.name isEqualToString:SET_CLOCK]) {
        manridyModel *model = [noti object];
        if (model.isReciveDataRight == ResponsEcorrectnessDataRgith) _asynCount ++;
        else [self asynFail];
    }
    if (_asynCount == 2) {
        if (self.syncSettingSuccessBlock) {
            self.syncSettingSuccessBlock(YES);
        }
    }
}

- (void)asynFail
{
    if (self.syncSettingSuccessBlock) {
        self.syncSettingSuccessBlock(NO);
    }
}

#pragma mark - Action
/** 取消通知栏 */
- (void)cancelStateBarAction:(MDButton *)sender
{
    if (self.stateBar.isShowing) {
        [self.stateBar dismiss];
    }
}

- (void)updateProgress:(float)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.stateBar setText:[NSString stringWithFormat:@"%@ %.0f%%", NSLocalizedString(@"syncingData", nil), progress]];
        if (progress >= 100) {
            self.syncDataIng = NO;
            NSLog(@"syncDataIngEnd == %d", self.syncDataIng);
            self.stateBar.text = NSLocalizedString(@"syncSuccess", nil);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_ALL_UI object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.stateBar dismiss];
            });
        }
    });
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
