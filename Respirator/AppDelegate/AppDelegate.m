//
//  AppDelegate.m
//  Respirator
//
//  Created by JustFei on 2017/7/19.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () < BleConnectDelegate, BleDiscoverDelegate >

@property (nonatomic, strong) MDSnackbar *stateBar;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [BleManager shareInstance].connectDelegate = self;
//    self.myBleManager = [BleManager shareInstance];
//    self.myBleManager.discoverDelegate = self;
//    self.myBleManager.
//    self.myBleManager.searchDelegate = self;
    
    //初始化window
    [self initWindow];
    
    //初始化app服务
    [self initService];
    
    //初始化 主页面
    [self initTabbarController];
    
    //广告页
    [AppManager appStart];
    
    return YES;
}

#pragma mark - bleConnectDelegate
- (void)manridyBLEDidConnectDevice:(BleDevice *)device
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SyncTool shareInstance] syncAllData];
    });
}


@end
