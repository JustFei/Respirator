//
//  SettingContentView.m
//  Respirator
//
//  Created by JustFei on 2017/7/25.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "SettingContentView.h"
#import "SettingPeripheralTableViewCell.h"
#import "SettingTableViewCell.h"
#import "SettingHeaderView.h"

static NSString *const periperlCellID = @"peripheralCell";
static NSString *const settingCellID = @"settingCell";
static NSString *const settingHeaderID = @"settingHeader";

@interface SettingContentView () < UITableViewDelegate, UITableViewDataSource >

//@property (nonatomic, strong) HKHealthStore *hkStore;
@property (nonatomic, strong) UITableView *tableView;
/** 第一组 cell 的数据源 */
@property (nonatomic, strong) NSArray *groupFirstDataSourceArr;
/** 第二组 cell 的数据源 */
@property (nonatomic, strong) NSArray *groupSecondDataSourceArr;
/** 跳转控制器的名字 */
@property (nonatomic, strong) NSArray *vcArray;

@end

@implementation SettingContentView

- (void)layoutSubviews
{
    self.tableView.backgroundColor = SETTING_BACKGROUND_COLOR;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.groupFirstDataSourceArr.count : self.groupSecondDataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SettingPeripheralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:periperlCellID];
        cell.peripheralModel = self.groupFirstDataSourceArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellID];
        cell.model = self.groupSecondDataSourceArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 72;
    }else {
        return 48;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        SettingHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:settingHeaderID];
        /** 这种方法可以改变 HeaderView 的背景颜色 */
        UIView *backgroundView = [[UIView alloc] initWithFrame:view.bounds];
        backgroundView.backgroundColor = SETTING_BACKGROUND_COLOR;
        view.userInfoButtonClickBlock = ^ {
            if (self.selectVCNumberBlock) {
                self.selectVCNumberBlock(0);
            }
        };
        view.backgroundView = backgroundView;
        return view;
    }else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = CLEAR_COLOR;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = COLOR_WITH_HEX(0xeeeef3, 1);
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top);
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
            make.bottom.equalTo(view.mas_top).offset(20);
        }];
        
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 225;
    }else {
        return 20;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (self.selectVCNumberBlock) {
            self.selectVCNumberBlock(1);
        }
    }else if (indexPath.section == 1) {
        if (self.selectVCNumberBlock) {
            self.selectVCNumberBlock(indexPath.row + 2);
        }
    }
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        [self layoutIfNeeded];
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        /** 注册 cell 和 headerView */
        [_tableView registerNib:[UINib nibWithNibName:@"SettingPeripheralTableViewCell" bundle:nil] forCellReuseIdentifier:periperlCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:settingCellID];
        [_tableView registerClass:NSClassFromString(@"SettingHeaderView") forHeaderFooterViewReuseIdentifier:settingHeaderID];
        
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.backgroundColor = SETTING_BACKGROUND_COLOR;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.allowsMultipleSelection = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSArray *)groupFirstDataSourceArr
{
    if (!_groupFirstDataSourceArr) {
        PeripheralCellModel *model = [[PeripheralCellModel alloc] init];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_BIND]) {
            model.isBind = [[NSUserDefaults standardUserDefaults] boolForKey:IS_BIND];
            model.peripheralName = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindPeripheralName"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"bindPeripheralName"] : NSLocalizedString(@"notBindPer", nil);
//            model.isConnect = [BleManager shareInstance].connectState == kBLEstateDidConnected ? YES : NO;
            model.battery = [[NSUserDefaults standardUserDefaults] objectForKey:ELECTRICITY_INFO_SETTING] ? [[NSUserDefaults standardUserDefaults] objectForKey:ELECTRICITY_INFO_SETTING] : @"--";
        }else {
            model.isBind = NO;
        }
        
        _groupFirstDataSourceArr = @[model];
    }
    
    return _groupFirstDataSourceArr;
}

- (NSArray *)groupSecondDataSourceArr
{
    if (!_groupSecondDataSourceArr) {
        NSArray *fucName = @[NSLocalizedString(@"提醒功能", nil),NSLocalizedString(@"使用场景", nil),NSLocalizedString(@"工作模式", nil),NSLocalizedString(@"关于口罩", nil)];
        NSArray *imageName = @[@"set_remind",@"set_location",@"set_mode",@"set_about"];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (int i = 0; i < fucName.count; i ++) {
            SettingCellModel *model = [[SettingCellModel alloc] init];
            model.fucName = fucName[i];
            model.headImageName = imageName[i];
            [dataArr addObject:model];
        }
        _groupSecondDataSourceArr = [NSArray arrayWithArray:dataArr];
    }
    
    return _groupSecondDataSourceArr;
}

- (NSArray *)vcArray
{
    if (!_vcArray) {
        _vcArray = @[@"InterfaceSelectionViewController", @"TakePhotoViewController", @"FindMyPeriphearlViewController", @"RemindViewController"];
    }
    
    return _vcArray;
}

@end
