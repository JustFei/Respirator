//
//  BleManager.m
//  New_iwear
//
//  Created by Faith on 2017/5/10.
//  Copyright © 2017年 manridy. All rights reserved.
//

#import "BleManager.h"
#import "BleDevice.h"
#import "manridyModel.h"
#import "NSStringTool.h"
#import "AnalysisProcotolTool.h"
#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

#define kServiceUUID              @"F000EFE0-0451-4000-0000-00000000B000"
#define kWriteCharacteristicUUID  @"F000EFE1-0451-4000-0000-00000000B000"
#define kNotifyCharacteristicUUID @"F000EFE3-0451-4000-0000-00000000B000"

@interface BleManager () <UNUserNotificationCenterDelegate>

@property (nonatomic, strong) CBCharacteristic *notifyCharacteristic;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) NSMutableArray *deviceArr;
@property (nonatomic, strong) UNMutableNotificationContent *notiContent;
@property (nonatomic, strong) dispatch_queue_t sendMessageQueue;
@property (nonatomic, strong) NSTimer *resendTimer;
@property (nonatomic, assign) BOOL haveResendMessage;

@end

@implementation BleManager


#pragma mark - Singleton
static BleManager *bleManager = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _myCentralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:nil];
//        _fmTool = [[AllBleFmdb alloc] init];
        self.notiContent = [[UNMutableNotificationContent alloc] init];
        // 信号量初始化为1
        self.sendMessageQueue = dispatch_get_global_queue(0, 0);
    }
    return self;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bleManager = [[self alloc] init];
    });
    
    return bleManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bleManager = [super allocWithZone:zone];
    });
    
    return bleManager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - action of connecting layer -连接层操作
/** 判断有没有当前设备有没有连接的 */
- (BOOL)retrievePeripherals
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"peripheralUUID"]) {
        NSString *uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"peripheralUUID"];
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidStr];
        NSArray *arr = [_myCentralManager retrievePeripheralsWithIdentifiers: @[uuid]];
        NSLog(@"当前已连接的设备%@,有%ld个",arr.firstObject ,(unsigned long)arr.count);
        if (arr.count != 0) {
            CBPeripheral *per = (CBPeripheral *)arr.firstObject;
            per.delegate = self;
            BleDevice *device = [[BleDevice alloc] initWith:per andAdvertisementData:nil andRSSI:nil];
            
            [self connectDevice:device];
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

/** 扫描设备 */
- (void)scanDevice
{
    [self.deviceArr removeAllObjects];
    self.connectState = kBLEstateDisConnected;
    [_myCentralManager scanForPeripheralsWithServices:nil options:nil];
}

/** 停止扫描 */
- (void)stopScan
{
    [_myCentralManager stopScan];
}

/** 连接设备 */
- (void)connectDevice:(BleDevice *)device
{
    if (!device) {
        return;
    }
    self.isReconnect = YES;
    self.currentDev = device;
    [_myCentralManager connectPeripheral:device.peripheral options:nil];
}

/** 断开设备连接 */
- (void)unConnectDevice
{
    if (self.currentDev.peripheral) {
        [self.myCentralManager cancelPeripheralConnection:self.currentDev.peripheral];
    }
}

/** 检索已连接的外接设备 */
- (NSArray *)retrieveConnectedPeripherals
{
    return [_myCentralManager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceUUID]]];
}

#pragma mark - data of write -写入数据操作
#pragma mark - 统一做消息队列处理，发送
- (void)addMessageToQueue:(NSData *)message
{
    //1.写入数据
    dispatch_async(self.sendMessageQueue, ^{
        if (self.currentDev.peripheral && self.writeCharacteristic) {
            [NSThread sleepForTimeInterval:0.05];
            NSLog(@"---%@---", message);
            [self.currentDev.peripheral writeValue:message forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
        }
    });
}

//set time
- (void)writeTimeToPeripheral:(NSDate *)currentDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    
    NSString *currentStr = [NSString stringWithFormat:@"%02ld%02ld%02ld%02ld%02ld%02ld%02ld",[comps year] % 100 ,[comps month] ,[comps day] ,[comps hour] ,[comps minute] ,[comps second] ,[comps weekday] - 1];
    //    NSLog(@"-----------weekday is %ld",(long)[comps weekday]);//在这里需要注意的是：星期日是数字1，星期一时数字2，以此类推。。。
    
    //传入时间和头，返回协议字符串
    NSString *protocolStr = [NSStringTool protocolAddInfo:currentStr head:@"00"];
    
    //写入操作
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
    NSLog(@"同步时间");
}

//get motionInfo
- (void)writeMotionRequestToPeripheralWithMotionType:(MotionType)type
{
    NSString *protocolStr = [NSStringTool protocolAddInfo:[NSString stringWithFormat:@"%ld",(unsigned long)type] head:@"03"];
    
    //写入操作
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
    NSLog(@"请求计步数据");
}

//set motionInfo zero
- (void)writeMotionZeroToPeripheral
{
    NSString *protocolStr = [NSStringTool protocolAddInfo:nil head:@"04"];
    
    //写入操作
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
    NSLog(@"清空计步数据");
}

//set userInfo
- (void)writeUserInfoToPeripheralWeight:(NSString *)weight andHeight:(NSString *)height
{
    NSString *protocolStr = [weight stringByAppendingString:[NSString stringWithFormat:@",%@",height]];
    
    protocolStr = [NSStringTool protocolAddInfo:protocolStr head:@"06"];
    
    //写入操作
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
    NSLog(@"同步用户信息");
}

//set motion target
- (void)writeMotionTargetToPeripheral:(NSString *)target
{
    NSString *protocolStr = [NSStringTool protocolAddInfo:target head:@"07"];
    
    //写入操作
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
    NSLog(@"同步计步目标");
}

/** 分段计步获取 */
- (void)writeSegementStepWithHistoryMode:(SegmentedStepData)mode
{
    NSString *protocolStr;
    switch (mode) {
            /** 具体的历史数据 */
        case SegmentedStepDataHistoryCount:
            protocolStr = @"FC1A02";
            break;
            /** 历史数据条数 */
        case SegmentedStepDataHistoryData:
            protocolStr = @"FC1A04";
            break;
            
        default:
            break;
    }
    
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
}

//search my peripheral
- (void)writeSearchPeripheralWithONorOFF:(BOOL)state
{
    NSString *protocolStr;
    protocolStr = state ? @"FC100003" : @"FC100000";

    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
}

//设备断开后震动提醒
- (void)writePeripheralShakeWhenUnconnectWithOforOff:(BOOL)state
{
    NSString *protocolStr;
    protocolStr = state ? @"FC100201" : @"FC100200";
    
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
    NSLog(@"同步防丢");
}

//翻腕亮屏设置
- (void)writeWristFunWithOff:(BOOL)state
{
    NSString *protocolStr;
    protocolStr = state ? @"FC1501" : @"FC1500";
    
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
    NSLog(@"翻腕亮屏设置");
}

//stop peripheral
- (void)writeStopPeripheralRemind
{
    NSString *protocolStr = @"1001";
    
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
}

/** get version from peripheral */
- (void)writeRequestVersion
{
    NSString *protocolStr = [NSStringTool protocolAddInfo:@"" head:@"0f"];
    
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
    NSLog(@"同步版本号");
}

/** 设置设备亮度 */
- (void)writeDimmingToPeripheral:(float)value
{
    NSString *dim = [NSStringTool ToHex:value];
    if (dim.length < 2) {
        dim = [NSString stringWithFormat:@"0%@", dim];
    }
    NSString *protocolStr = [NSString stringWithFormat:@"fc0f04%@", dim];
    
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
    NSLog(@"同步亮度");
}

/** 获取电量 */
- (void)writeGetElectricity
{
    NSString *protocolStr = @"fc0f06";
    
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
    NSLog(@"同步电量");
}

//写入名称
- (void)writePeripheralNameWithNameString:(NSString *)name
{
    NSString *lengthInterval = [NSStringTool ToHex:name.length / 2];
    if (lengthInterval.length < 2) {
        while (1) {
            lengthInterval = [@"0" stringByAppendingString:lengthInterval];
            if (lengthInterval.length >= 2) {
                break;
            }
        }
    }
    NSString *protocolStr = [[@"FC0F07" stringByAppendingString:lengthInterval]stringByAppendingString:name];
    
    while (1) {
        if (protocolStr.length < 40) {
            protocolStr = [protocolStr stringByAppendingString:@"00"];
        }else {
            break;
        }
    }
    
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
}

/*推送公制和英制单位
 ImperialSystem  YES = 英制
 NO  = 公制
 */
- (void)writeUnitToPeripheral:(BOOL)ImperialSystem
{
    NSString *protocolStr;
    protocolStr = ImperialSystem ? @"FC170001" : @"FC170000";
    
    [self addMessageToQueue:[NSStringTool hexToBytes:protocolStr]];
    NSLog(@"同步单位");
}



#pragma mark - CBCentralManagerDelegate
//检查设备蓝牙开关的状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationBleStateChange object:@(central.state)];
}

//查找到正在广播的指定外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    BleDevice *device = [[BleDevice alloc] initWith:peripheral andAdvertisementData:advertisementData andRSSI:RSSI];
    //当你发现你感兴趣的连接外围设备，停止扫描其他设备，以节省电能。
    if (device.deviceName != nil ) {
        if (![self.deviceArr containsObject:peripheral]) {
            [self.deviceArr addObject:peripheral];
            
            //返回扫描到的设备实例
            if ([self.discoverDelegate respondsToSelector:@selector(manridyBLEDidDiscoverDeviceWithMAC:)]) {
                
                [self.discoverDelegate manridyBLEDidDiscoverDeviceWithMAC:device];
            }
        }
    }
}

//连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    peripheral.delegate = self;
    //传入nil会返回所有服务;一般会传入你想要服务的UUID所组成的数组,就会返回指定的服务
    [peripheral discoverServices:nil];
}

//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //    NSLog(@"连接失败");
    
    if ([self.connectDelegate respondsToSelector:@selector(manridyBLEDidFailConnectDevice:)]) {
        [self.connectDelegate manridyBLEDidFailConnectDevice:self.currentDev];
    }
    
}

//断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.connectState = kBLEstateDisConnected;
    [SyncTool shareInstance].syncDataIng = NO;
    if ([self.connectDelegate respondsToSelector:@selector(manridyBLEDidDisconnectDevice:)]) {
        [self.connectDelegate manridyBLEDidDisconnectDevice:self.currentDev];
    }
    if (self.isReconnect) {
        NSLog(@"需要断线重连");
        [self.myCentralManager connectPeripheral:self.currentDev.peripheral options:nil];
    }else {
        self.currentDev = nil;
    }
    
}

#pragma mark - CBPeripheralDelegate
//发现到服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for (CBService *service in peripheral.services) {
        
        //返回特定的写入，订阅的特征即可
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:kWriteCharacteristicUUID],[CBUUID UUIDWithString:kNotifyCharacteristicUUID]] forService:service];
    }
}

//获得某服务的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    //    NSLog(@"Discovered characteristic %@", service.characteristics);
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        //保存写入特征
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kWriteCharacteristicUUID]]) {
            
            self.writeCharacteristic = characteristic;
        }
        
        //保存订阅特征
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kNotifyCharacteristicUUID]]) {
            self.notifyCharacteristic = characteristic;
            self.connectState = kBLEstateDidConnected;
            if ([self.connectDelegate respondsToSelector:@selector(manridyBLEDidConnectDevice:)]) {
                if (self.currentDev.peripheral == peripheral) {
                    [[NSUserDefaults standardUserDefaults] setObject:peripheral.identifier.UUIDString forKey:@"peripheralUUID"];
                    [self.connectDelegate manridyBLEDidConnectDevice:self.currentDev];
                }
            }
            
            //订阅该特征
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

//获得某特征值变化的通知
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{

}

//订阅特征值发送变化的通知，所有获取到的值都将在这里进行处理
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"updateValue == %@",characteristic.value);
    
    [self analysisDataWithCharacteristic:characteristic.value];
    
}

//写入某特征值后的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        //        NSLog(@"Error writing characteristic value: %@",[error localizedDescription]);
    }else {
        //        NSLog(@"Success writing chararcteristic value: %@",characteristic);
    }
}

#pragma mark - 数据解析
- (void)analysisDataWithCharacteristic:(NSData *)value
{
    if ([value bytes] != nil) {
        const unsigned char *hexBytes = [value bytes];
        //命令头字段
        NSString *headStr = [[NSString stringWithFormat:@"%02x", hexBytes[0]] localizedLowercaseString];
        
        if ([headStr isEqualToString:@"00"] || [headStr isEqualToString:@"80"]) {
            //解析设置时间数据
//            manridyModel *model = [[AnalysisProcotolTool shareInstance] analysisSetTimeData:value WithHeadStr:headStr];
            [[NSNotificationCenter defaultCenter] postNotificationName:SET_TIME object:nil userInfo:@{@"success":[headStr isEqualToString:@"00"]? @YES : @NO}];
        }else if ([headStr isEqualToString:@"03"] || [headStr isEqualToString:@"83"]) {
            //解析获取的步数数据
            manridyModel *model =  [[AnalysisProcotolTool shareInstance] analysisGetSportData:value WithHeadStr:headStr];
            [[NSNotificationCenter defaultCenter] postNotificationName:GET_MOTION_DATA object:model];
        }else if ([headStr isEqualToString:@"06"] || [headStr isEqualToString:@"86"]) {
            //用户信息推送
            [[NSNotificationCenter defaultCenter] postNotificationName:SET_USER_INFO object:nil userInfo:@{@"success":[headStr isEqualToString:@"06"]? @YES : @NO}];
        }else if ([headStr isEqualToString:@"0f"] || [headStr isEqualToString:@"8f"]) {
            //设备维护指令
            manridyModel *model = [[AnalysisProcotolTool shareInstance] analysisFirmwareData:value WithHeadStr:headStr];
            [[NSNotificationCenter defaultCenter] postNotificationName:SET_FIRMWARE object:model];
        }else if ([headStr isEqualToString:@"1a"] || [headStr isEqualToString:@"9a"]) {
            //分段计步数据
            manridyModel *model = [[AnalysisProcotolTool shareInstance] analysisSegmentedStep:value WithHeadStr:headStr];
            [[NSNotificationCenter defaultCenter] postNotificationName:GET_SEGEMENT_STEP object:model];
        }else if ([headStr isEqualToString:@"42"]) {
            //PM2.5数据
            
        }
    }
}

#pragma mark - 通知

#pragma mark - 懒加载
- (NSMutableArray *)deviceArr
{
    if (!_deviceArr) {
        _deviceArr = [NSMutableArray array];
    }
    
    return _deviceArr;
}


@end

