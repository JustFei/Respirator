//
//  UserHeadimageCell.m
//  Respirator
//
//  Created by JustFei on 2017/8/1.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "UserHeadimageCell.h"

@implementation UserHeadimageCell

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
        
        _headImage = [[UIImageView alloc] init];
        [self addSubview:_headImage];
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-16);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        _headImage.layer.cornerRadius = 20;
        _headImage.layer.masksToBounds = YES;
    }
    return self;
}

@end
