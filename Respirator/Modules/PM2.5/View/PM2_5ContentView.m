//
//  PM2_5ContentView.m
//  Respirator
//
//  Created by JustFei on 2017/7/21.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "PM2_5ContentView.h"

@interface PM2_5ContentView ()

@property (strong, nonatomic) UIButton *unBindBtn;  //未绑定设备按钮
@property (strong, nonatomic) UILabel *titleLabel;  //当前 PM 浓度
@property (strong, nonatomic) UILabel *pmLabel;     //具体 PM 值
@property (strong, nonatomic) UILabel *unitLabel;   //ug/m3 PM 单位
@property (strong, nonatomic) UILabel *airLabel;    //空气
@property (strong, nonatomic) UILabel *gradeLabel;  //优，良，差的评级
@property (strong, nonatomic) UILabel *subTitleLabel;//PM2.5浓度变化

//@property (strong, nonatomic) PNChart *lineChart;


@end

@implementation PM2_5ContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - init UI
- (void)setupUI
{
    UIImageView *circleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pm_halfring"]];
    circleImgView.backgroundColor = KClearColor;
    [self addSubview:circleImgView];
    [circleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_top).offset(134.5 + 64);
    }];
    
    _unBindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_unBindBtn setTitle:@"请先绑定设备" forState:UIControlStateNormal];
    [_unBindBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [_unBindBtn setTitleColor:CNavBgColor forState:UIControlStateNormal];
    [_unBindBtn addTarget:self action:@selector(showBindPerVC:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_unBindBtn];
    [_unBindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleImgView.mas_centerX);
        make.centerY.equalTo(circleImgView.mas_centerY);
    }];
}

@end
