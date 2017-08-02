//
//  AboutViewController.m
//  Respirator
//
//  Created by JustFei on 2017/8/2.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutTableViewCell.h"

static NSString *const AboutTableViewCellID = @"AboutTableViewCell";

@interface AboutViewController () < UITableViewDelegate, UITableViewDataSource >

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArr;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"关于口罩", nil);
    self.view.backgroundColor = SETTING_BACKGROUND_COLOR;
    self.tableView.backgroundColor = CLEAR_COLOR;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutTableViewCellID];
    cell.titleLabel.text = @"版本升级";
    cell.subTitleLabel.text = @"V1.0.0";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = NAVIGATION_BAR_COLOR;
    
    UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_img"]];
    [view addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY).offset(-16);
    }];
    
    UILabel *airLabel = [[UILabel alloc] init];
    [airLabel setTextColor:WHITE_COLOR];
    [airLabel setText:@"AIR"];
    [view addSubview:airLabel];
    [airLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(headImage.mas_bottom).offset(12);
    }];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    [versionLabel setTextColor:WHITE_COLOR];
    [versionLabel setText:@"当前版本：V1.0.0"];
    [view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom).offset(-32);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = SETTING_BACKGROUND_COLOR;
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(view.mas_bottom);
        make.height.equalTo(@16);
    }];
    
    return  view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 225;
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:NSClassFromString(AboutTableViewCellID) forCellReuseIdentifier:AboutTableViewCellID];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

@end
