//
//  UserInfoViewController.m
//  Respirator
//
//  Created by JustFei on 2017/8/1.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "UserHeadimageCell.h"

@class UserInfoCellModel;

static NSString *const UserInfoTableViewCellID = @"UserInfoTableViewCell";
static NSString *const UserHeadimageCellID = @"UserHeadimageCell";

@interface UserInfoViewController () < UITableViewDataSource, UITableViewDelegate >

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArr;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = SETTING_BACKGROUND_COLOR;
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UserHeadimageCell *cell = [tableView dequeueReusableCellWithIdentifier:UserHeadimageCellID];
        [cell.titleLabel setText:NSLocalizedString(@"头像", nil)];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_HEADIMAGE_SETTING]) {
            UIImage *headImage = [[NSUserDefaults standardUserDefaults] objectForKey:USER_HEADIMAGE_SETTING];
            [cell.headImage setImage:headImage];
        }else {
            [cell.headImage setImage:[UIImage imageNamed:@"set_avatar"]];
        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else {
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoTableViewCellID];
        cell.model = self.dataArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 16;
    }else {
        return 0;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 57;
    }else {
        return 44;
    }
    
    return 0;
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:NSClassFromString(UserInfoTableViewCellID) forCellReuseIdentifier:UserInfoTableViewCellID];
        [_tableView registerClass:NSClassFromString(UserHeadimageCellID) forCellReuseIdentifier:UserHeadimageCellID];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSArray *)dataArr
{
    if (!_dataArr) {
        NSArray *titleArr = @[@"姓名",@"性别",@"年龄",@"体重",@"身高",@"步长"];
        NSMutableArray *mutArr = [NSMutableArray array];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [path stringByAppendingPathComponent:@"UserInfo.data"];
        // 解档
        UserInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (model) {
            for (int index = 0; index < titleArr.count; index ++) {
                UserInfoCellModel *cellModel = [[UserInfoCellModel alloc] init];
                cellModel.title = titleArr[index];
                switch (index) {
                    case 0:
                        cellModel.info = model.userName;
                        break;
                    case 1:
                        cellModel.info = model.gender == GenderMan ? NSLocalizedString(@"男", nil) : NSLocalizedString(@"女", nil);
                        break;
                    case 2:
                        cellModel.info = model.age;
                        break;
                    case 3:
                        cellModel.info = [NSString stringWithFormat:@"%@ cm", model.weight];
                        break;
                    case 4:
                        cellModel.info = [NSString stringWithFormat:@"%@ kg", model.height];
                        break;
                    case 5:
                        cellModel.info = [NSString stringWithFormat:@"%ld cm", model.stepLength];
                        break;
                        
                    default:
                        break;
                }
                [mutArr addObject:cellModel];
            }
            _dataArr = mutArr;
        }else {
            for (int index = 0; index < titleArr.count; index ++) {
                UserInfoCellModel *cellModel = [[UserInfoCellModel alloc] init];
                cellModel.title = titleArr[index];
                cellModel.info = @"test";
                [mutArr addObject:cellModel];
            }
            _dataArr = mutArr;
        }
    }
    
    return _dataArr;
}

@end
