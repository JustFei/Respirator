//
//  WorkModeViewController.m
//  Respirator
//
//  Created by JustFei on 2017/8/1.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "WorkModeViewController.h"
#import "RemindCell.h"

static NSString *const RemindCellID = @"RemindCell";

@interface WorkModeViewController ()< UITableViewDelegate, UITableViewDataSource >

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArr;

@end

@implementation WorkModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"工作模式", nil);
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    UILabel *tipLabel = [[UILabel alloc] init];
    [tipLabel setText:@"开机每隔5分钟测量一次，测量时间1分钟，放置5分钟后，停止运行，运行2分钟，重新运行，循环该过程。"];
    tipLabel.numberOfLines = 0;
    [tipLabel setTextColor:TEXT_BLACK_COLOR_LEVEL3];
    [tipLabel setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(16);
        make.top.equalTo(view.mas_top).offset(8);
        make.right.equalTo(view.mas_right).offset(-16);
//        make.bottom.equalTo(view.mas_bottom).offset(-16);
    }];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
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
        _dataArr = @[@{@"title":@"智能测量", @"isOpen":@1}];
    }
    
    return _dataArr;
}

@end
