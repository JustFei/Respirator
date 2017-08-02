//
//  AppDelegate+AppService.m
//  Respirator
//
//  Created by JustFei on 2017/7/21.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "AppDelegate+AppService.h"

@implementation AppDelegate (AppService)

#pragma mark ————— 初始化服务 —————
-(void)initService
{
    //蓝牙状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bleStateChange:)
                                                 name:KNotificationBleStateChange
                                               object:nil];
}

#pragma mark ————— 初始化window —————
-(void)initWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = KWhiteColor;
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];
    //    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = KWhiteColor;
}

#pragma mark ————— 登录状态处理 —————
- (void)initTabbarController
{
    //为避免自动登录成功刷新tabbar
    if (!self.mainTabBar || ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
        self.mainTabBar = [MainTabBarController new];
        
        CATransition *anima = [CATransition animation];
        anima.type = @"cube";//设置动画的类型
        anima.subtype = kCATransitionFromRight; //设置动画的方向
        anima.duration = 0.3f;
        
        self.window.rootViewController = self.mainTabBar;
        
        [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
    }
    //展示FPS
    [AppManager showFPS];
}

#pragma mark - 处理通知
- (void)bleStateChange:(NSNotification *)noti
{
    NSNumber *state = [noti object];
    switch (state.integerValue) {
        case 4:
        {
//            self.stateBar.text = NSLocalizedString(@"bleNotOpen", nil);
//            [self.stateBar show];
        }
            break;
        case 5:
        {
            if ([BleManager shareInstance].connectState == kBLEstateDisConnected) {
                [self isBindPeripheral];
            }
        }
            break;
            
        default:
            break;
    }
}

/** 判断是否绑定 */
- (void)isBindPeripheral
{
    BOOL isBind = [[NSUserDefaults standardUserDefaults] boolForKey:IS_BIND];
    NSLog(@"有没有绑定设备 == %d",isBind);
    if (isBind) {
//        self.stateBar.text = NSLocalizedString(@"正在连接中", nil);
        [self connectBLE];
    }else {
    }
}

/** 连接已绑定的设备 */
- (void)connectBLE
{
    BOOL systemConnect = [[BleManager shareInstance] retrievePeripherals];
    if (!systemConnect) {
        [[BleManager shareInstance] scanDevice];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[BleManager shareInstance] stopScan];
            
            if ([BleManager shareInstance].connectState == kBLEstateDisConnected) {
                
            }
        });
    }
}

+ (AppDelegate *)shareAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else if ([superVC isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController*)superVC).viewControllers.lastObject;
    }
    return superVC;
}

@end
