//
//  SettingContentView.h
//  Respirator
//
//  Created by JustFei on 2017/7/25.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectVCNumberBlock)(NSInteger number);

@interface SettingContentView : UIView

@property (copy, nonatomic) SelectVCNumberBlock selectVCNumberBlock;

@end
