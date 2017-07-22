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
        
        [self setBindView];
        
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
        make.centerY.equalTo(self.mas_top).offset(134.5);
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
    
    _pmLabel = [[UILabel alloc] init];
    [_pmLabel setFont:[UIFont systemFontOfSize:82]];
    [_pmLabel setTextColor:CNavBgColor];
    [self addSubview:_pmLabel];
    [_pmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleImgView.mas_centerX);
        make.centerY.equalTo(circleImgView.mas_centerY);
        make.height.equalTo(@82);
    }];
    [_pmLabel setText:@"26"];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_titleLabel setTextColor:KBlackColor];
    [_titleLabel setText:@"当前PM浓度"];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleImgView.mas_centerX);
        make.bottom.equalTo(_pmLabel.mas_top).offset(-10);
    }];
    
    _airLabel = [[UILabel alloc] init];
    [_airLabel setFont:[UIFont systemFontOfSize:12]];
    [_airLabel setTextColor:KBlackColor];
    [_airLabel setText:@"空气"];
    [self addSubview:_airLabel];
    [_airLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pmLabel.mas_bottom).offset(20);
        make.centerX.equalTo(_pmLabel.mas_centerX).offset(-10);
    }];
    
    _gradeLabel = [[UILabel alloc] init];
    [_gradeLabel setFont:[UIFont systemFontOfSize:17]];
    [_gradeLabel setTextColor:UIColorHex(0x00a84e)];
    [_gradeLabel setText:@"优"];
    [self addSubview:_gradeLabel];
    [_gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_airLabel.mas_centerY);
        make.centerX.equalTo(_pmLabel.mas_centerX).offset(20);
    }];
}

- (void)setBindView
{
    _unBindBtn.hidden = YES;
    _titleLabel.hidden = NO;
    _pmLabel.hidden = NO;
    _airLabel.hidden = NO;
    _gradeLabel.hidden = NO;
}

- (void)setUnbindView
{
    _unBindBtn.hidden = NO;
    _titleLabel.hidden = YES;
    _pmLabel.hidden = YES;
    _airLabel.hidden = YES;
    _gradeLabel.hidden = YES;
}

@end
