//
//  AboutTableViewCell.m
//  Respirator
//
//  Created by JustFei on 2017/8/2.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "AboutTableViewCell.h"

@implementation AboutTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = WHITE_COLOR;
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.top.equalTo(self.mas_top).offset(8);
        }];
        
        _subTitleLabel = [[UILabel alloc] init];
        [_subTitleLabel setFont:[UIFont systemFontOfSize:12]];
        [_subTitleLabel setTextColor:TEXT_BLACK_COLOR_LEVEL3];
        [self addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        }];
    }
    
    return self;
}

@end
