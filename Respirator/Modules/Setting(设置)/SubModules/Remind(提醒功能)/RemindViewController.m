//
//  RemindViewController.m
//  Respirator
//
//  Created by JustFei on 2017/8/2.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "RemindViewController.h"
#import "RemindCell.h"

static NSString *const RemindCellID = @"RemindCell";

@interface RemindViewController () < UITableViewDelegate, UITableViewDataSource >

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArr;

@end

@implementation RemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"提醒功能", nil);
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
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindCell *cell = [tableView dequeueReusableCellWithIdentifier:RemindCellID];
    NSDictionary *dic = self.dataArr[indexPath.row];
    [cell.titleLabel setText:dic[@"title"]];
    [cell.funSith setOn:((NSNumber *)dic[@"isOpen"]).integerValue];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = CLEAR_COLOR;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        _tableView.scrollEnabled = NO;
        
        [_tableView registerClass:NSClassFromString(RemindCellID) forCellReuseIdentifier:RemindCellID];
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = @[@{@"title":@"PM2.5超标提醒", @"isOpen":@1},@{@"title":@"PM2.5合格提醒", @"isOpen":@0},@{@"title":@"口罩防丢提醒", @"isOpen":@0}];
    }
    
    return _dataArr;
}

@end
