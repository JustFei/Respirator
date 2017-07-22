//
//  StepViewController.m
//  Respirator
//
//  Created by JustFei on 2017/7/21.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "StepViewController.h"
#import "StepContentView.h"

@interface StepViewController ()

@property (strong, nonatomic) StepContentView *contentView;

@end

@implementation StepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - init UI
- (void)setupUI
{
    [self addNavigationItemWithImageNames:@[@"pm_historyicon"] isLeft:YES target:self action:@selector(showStepHistoryVC) tags:@[@1000]];
    self.contentView.backgroundColor = CViewBgColor;
}

#pragma mark - Action
- (void)showStepHistoryVC
{
    
}

#pragma mark - Lazy
- (StepContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[StepContentView alloc] initWithFrame:self.view.bounds];
        //DLog(@"self.view.bounds == %@", self.view.bounds);
        [self.view addSubview:_contentView];
    }
    
    return _contentView;
}

@end
