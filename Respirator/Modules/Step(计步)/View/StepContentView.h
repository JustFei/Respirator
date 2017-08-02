//
//  StepContentView.h
//  Respirator
//
//  Created by JustFei on 2017/7/22.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepContentView : UIView

//更新当前数据
- (void)updateUIWithStepModel:(StepModel *)model;

//更新图表视图
- (void)updateStepUIWithDataArr:(NSArray *)dbArr;

@end
