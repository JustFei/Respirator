//
//  UserInfoTableViewCell.m
//  Respirator
//
//  Created by JustFei on 2017/8/1.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@interface UserInfoTableViewCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *infoLabel;

@end

@implementation UserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = WHITE_COLOR;
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:TEXT_BLACK_COLOR_LEVEL3];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        _infoLabel = [[UILabel alloc] init];
        [_infoLabel setTextColor:TEXT_BLACK_COLOR_LEVEL3];
        [_infoLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_infoLabel];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-32);
        }];
    }
    return self;
}

- (void)setModel:(UserInfoCellModel *)model
{
    if (model) {
        _model = model;
        [self.titleLabel setText:model.title];
        [self.infoLabel setText:model.info];
    }
}

@end
