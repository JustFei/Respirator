//
//  SettingHeaderView.m
//  New_iwear
//
//  Created by Faith on 2017/5/3.
//  Copyright © 2017年 manridy. All rights reserved.
//

#import "SettingHeaderView.h"
#import "Masonry.h"

@implementation SettingHeaderView

- (void)drawRect:(CGRect)rect
{
    _headImageView = [[UIImageView alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_HEADIMAGE_SETTING]) {
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:USER_HEADIMAGE_SETTING];
        [_headImageView setImage:[UIImage imageWithData:imageData]];
    }else {
        [_headImageView setImage:[UIImage imageNamed:@"set_avatar"]];
    }
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.cornerRadius = 40;
    
    [self addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(13);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    _userNameLabel = [[UILabel alloc] init];
    [_userNameLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_SETTING] ? [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_SETTING] : NSLocalizedString(@"用户名", nil)];
    [_userNameLabel setTextColor:TEXT_BLACK_COLOR_LEVEL1];
    [_userNameLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_headImageView.mas_bottom).offset(15);
    }];
    
    _userInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userInfoButton setTitle:NSLocalizedString(@"个人信息", nil) forState:UIControlStateNormal];
    [_userInfoButton setTitleColor:TEXT_BLACK_COLOR_LEVEL2 forState:UIControlStateNormal];
    [_userInfoButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_userInfoButton addTarget:self action:@selector(userInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_userInfoButton];
    [_userInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_userNameLabel.mas_bottom).offset(5);
        make.width.equalTo(@70);
        make.height.equalTo(@20);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [arrowImageView setImage:[UIImage imageNamed:@"ic_chevron_right"]];
    [self addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userInfoButton.mas_centerY);
        make.left.equalTo(_userInfoButton.mas_right).offset(8);
    }];
    
    UIView *viewBottom = [[UIView alloc] init];
    viewBottom.backgroundColor = COLOR_WITH_HEX(0xeeeef3, 1);
    [self addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@56);
    }];
    
    UILabel *peripheralConnectLabel = [[UILabel alloc] init];
    [peripheralConnectLabel setText:NSLocalizedString(@"设备连接", nil)];
    [peripheralConnectLabel setTextColor:TEXT_BLACK_COLOR_LEVEL3];
    [peripheralConnectLabel setFont:[UIFont systemFontOfSize:14]];
    [viewBottom addSubview:peripheralConnectLabel];
    [peripheralConnectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
    }];
}

- (void)userInfoAction:(UIButton *)sender
{
    if (self.userInfoButtonClickBlock) {
        self.userInfoButtonClickBlock();
    }
}

@end
