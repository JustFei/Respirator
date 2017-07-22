//
//  PM2_5ViewController.m
//  Respirator
//
//  Created by JustFei on 2017/7/21.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "PM2_5ViewController.h"
#import "PM2_5ContentView.h"

@interface PM2_5ViewController ()

@property (strong, nonatomic) PM2_5ContentView *contentView;

@end

@implementation PM2_5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - init UI
- (void)setupUI
{
    [self addNavigationItemWithImageNames:@[@"pm_historyicon"] isLeft:YES target:self action:@selector(showPM2_5HistoryVC) tags:@[@1000]];
    self.contentView.backgroundColor = CViewBgColor;
}

#pragma mark - Action
- (void)showPM2_5HistoryVC
{
    
}

#pragma mark - Lazy
- (PM2_5ContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[PM2_5ContentView alloc] initWithFrame:self.view.bounds];
        //DLog(@"self.view.bounds == %@", self.view.bounds);
        [self.view addSubview:_contentView];
    }
    
    return _contentView;
}

@end
