//
//  SettingViewController.m
//  Respirator
//
//  Created by JustFei on 2017/7/21.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingContentView.h"

@interface SettingViewController ()

@property (strong, nonatomic) NSArray *vcArr;
@property (strong, nonatomic) SettingContentView *contentView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

#pragma mark - init UI
- (void)setupUI
{
    self.contentView.backgroundColor = CViewBgColor;
    __weak __typeof__(self) weakSelf = self;
    self.contentView.selectVCNumberBlock = ^(NSInteger number) {
        id pushVC = [[NSClassFromString(weakSelf.vcArr[number]) alloc] init];
        [weakSelf.navigationController pushViewController:pushVC animated:YES];
    };
}

#pragma mark - Lazy
- (NSArray *)vcArr
{
    if (!_vcArr) {
        _vcArr = @[@"UserInfoViewController",@"BindPeripheralViewController",@"RemindViewController",@"UserLocationViewController",@"WorkModeViewController",@"AboutViewController"];
    }
    
    return _vcArr;
}

- (SettingContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[SettingContentView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right);
            make.left.equalTo(self.view.mas_left);
            make.bottom.equalTo(self.view.mas_bottom);
            make.top.equalTo(self.view.mas_top);
        }];
    }
    
    return _contentView;
}

@end
