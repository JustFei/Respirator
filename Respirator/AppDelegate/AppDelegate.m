//
//  AppDelegate.m
//  Respirator
//
//  Created by JustFei on 2017/7/19.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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

@end
