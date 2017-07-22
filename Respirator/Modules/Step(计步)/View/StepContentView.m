//
//  StepContentView.m
//  Respirator
//
//  Created by JustFei on 2017/7/22.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "StepContentView.h"

@interface StepContentView ()

@property (strong, nonatomic) UILabel *stepLabel;
@property (strong, nonatomic) UILabel *mileageLabel;
@property (strong, nonatomic) UILabel *kcalLabel;

//@property (strong, nonatomic) PNChart *barChart;

@end

@implementation StepContentView

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
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"step_walkicon"]];
    headImageView.backgroundColor = KClearColor;
    [self addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(9);
    }];
    
    _stepLabel = [[UILabel alloc] init];
    [_stepLabel setFont:[UIFont systemFontOfSize:59]];
    [_stepLabel setTextColor:KBlackColor];
    [_stepLabel setText:@"0"];
    [self addSubview:_stepLabel];
    [_stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(headImageView.mas_bottom).offset(18);
        make.height.equalTo(@59);
    }];
    
    _mileageLabel = [[UILabel alloc] init];
    [_mileageLabel setFont:[UIFont systemFontOfSize:40]];
    [_mileageLabel setTextColor:KBlackColor];
    [_mileageLabel setText:@"0"];
    [self addSubview:_mileageLabel];
    [_mileageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(-(self.bounds.size.width / 4));
        make.top.equalTo(_stepLabel.mas_bottom).offset(28);
        make.height.equalTo(@40);
    }];
    
    UILabel *mileageUnit = [[UILabel alloc] init];
    [mileageUnit setFont:[UIFont systemFontOfSize:12]];
    [mileageUnit setTextColor:KBlackColor];
    [mileageUnit setText:@"里程/km"];
    [self addSubview:mileageUnit];
    [mileageUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mileageLabel.mas_centerX);
        make.top.equalTo(_mileageLabel.mas_bottom).offset(10);
    }];
    
    _kcalLabel = [[UILabel alloc] init];
    [_kcalLabel setFont:[UIFont systemFontOfSize:40]];
    [_kcalLabel setTextColor:KBlackColor];
    [_kcalLabel setText:@"0"];
    [self addSubview:_kcalLabel];
    [_kcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(self.bounds.size.width / 4);
        make.top.equalTo(_stepLabel.mas_bottom).offset(28);
        make.height.equalTo(@40);
    }];
    
    UILabel *kcalUnit = [[UILabel alloc] init];
    [kcalUnit setFont:[UIFont systemFontOfSize:12]];
    [kcalUnit setTextColor:KBlackColor];
    [kcalUnit setText:@"卡路里/kcal"];
    [self addSubview:kcalUnit];
    [kcalUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_kcalLabel.mas_centerX);
        make.top.equalTo(_kcalLabel.mas_bottom).offset(10);
    }];
    
    UILabel *todayStep = [[UILabel alloc] init];
    [todayStep setFont:[UIFont systemFontOfSize:17]];
    [todayStep setTextColor:CNavBgColor];
    [todayStep setText:@"今日步数"];
    [self addSubview:todayStep];
    [todayStep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(kcalUnit.mas_bottom).offset(64);
    }];
}

@end
