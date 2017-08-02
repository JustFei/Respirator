//
//  StepContentView.m
//  Respirator
//
//  Created by JustFei on 2017/7/22.
//  Copyright © 2017年 manridy.com. All rights reserved.
//

#import "StepContentView.h"

@interface StepContentView () < PNChartDelegate >

@property (strong, nonatomic) UILabel *stepLabel;
@property (strong, nonatomic) UILabel *mileageLabel;
@property (strong, nonatomic) UILabel *kcalLabel;
@property (strong, nonatomic) UILabel *todayStep;
@property (nonatomic, strong) PNBarChart *stepBarChart;
@property (nonatomic, strong) FMDBManager *myFmdbManager;

@property (nonatomic, strong) NSMutableArray *dateArr;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation StepContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - init UI
- (void)setupUI
{
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"step_walkicon"]];
    headImageView.backgroundColor = KClearColor;
    [self addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(9);
    }];
    
    _stepLabel = [[UILabel alloc] init];
    [_stepLabel setFont:[UIFont systemFontOfSize:59]];
    [_stepLabel setTextColor:KBlackColor];
    [_stepLabel setText:@"0"];
    [self addSubview:_stepLabel];
    [_stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(headImageView.mas_bottom).offset(18);
        make.height.equalTo(@59);
    }];
    
    _mileageLabel = [[UILabel alloc] init];
    [_mileageLabel setFont:[UIFont systemFontOfSize:40]];
    [_mileageLabel setTextColor:KBlackColor];
    [_mileageLabel setText:@"0"];
    [self addSubview:_mileageLabel];
    [_mileageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(-(self.bounds.size.width / 4));
        make.top.equalTo(_stepLabel.mas_bottom).offset(28);
        make.height.equalTo(@40);
    }];
    
    UILabel *mileageUnit = [[UILabel alloc] init];
    [mileageUnit setFont:[UIFont systemFontOfSize:12]];
    [mileageUnit setTextColor:KBlackColor];
    [mileageUnit setText:@"里程/km"];
    [self addSubview:mileageUnit];
    [mileageUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mileageLabel.mas_centerX);
        make.top.equalTo(_mileageLabel.mas_bottom).offset(10);
    }];
    
    _kcalLabel = [[UILabel alloc] init];
    [_kcalLabel setFont:[UIFont systemFontOfSize:40]];
    [_kcalLabel setTextColor:KBlackColor];
    [_kcalLabel setText:@"0"];
    [self addSubview:_kcalLabel];
    [_kcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(self.bounds.size.width / 4);
        make.top.equalTo(_stepLabel.mas_bottom).offset(28);
        make.height.equalTo(@40);
    }];
    
    UILabel *kcalUnit = [[UILabel alloc] init];
    [kcalUnit setFont:[UIFont systemFontOfSize:12]];
    [kcalUnit setTextColor:KBlackColor];
    [kcalUnit setText:@"卡路里/kcal"];
    [self addSubview:kcalUnit];
    [kcalUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_kcalLabel.mas_centerX);
        make.top.equalTo(_kcalLabel.mas_bottom).offset(10);
    }];
    
    _todayStep = [[UILabel alloc] init];
    [_todayStep setFont:[UIFont systemFontOfSize:17]];
    [_todayStep setTextColor:CNavBgColor];
    [_todayStep setText:@"今日步数"];
    [self addSubview:_todayStep];
    [_todayStep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(kcalUnit.mas_bottom).offset(64);
    }];
    
    self.stepBarChart.backgroundColor = TEXT_BLACK_COLOR_LEVEL0;
    [self.stepBarChart strokeChart];
}

- (void)updateUIWithStepModel:(StepModel *)model
{
    [self.stepLabel setText:[NSString stringWithFormat:@"%@", model.stepNumber]];
    [self.mileageLabel setText:[NSString stringWithFormat:@"%.3f", model.mileageNumber.floatValue / 1000]];
    [self.kcalLabel setText:[NSString stringWithFormat:@"%@", model.kCalNumber]];
}

#pragma mark - PNChartDelegate
- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
{
    NSLog(@"点击了 stepBarChart 的%ld", barIndex);
}

#pragma mark - noti motion
//- (void)getMotionData:(NSNotification *)noti
//{
//    manridyModel *model = [noti object];
//    if (model.sportModel.motionType == MotionTypeStepAndkCal) {
//        if ([model.sportModel.stepNumber isEqualToString:@"0"]) {
//            [self.stepLabel setText:@"--"];
//        }else {
//            [self.stepLabel setText:[NSString stringWithFormat:@"%@", model.sportModel.stepNumber]];
//            
//            
//            [self.stepLabel setText:[NSString stringWithFormat:@"%@", model.sportModel.stepNumber]];
//            [self.mileageLabel setText:[NSString stringWithFormat:@"%.3f", model.sportModel.mileageNumber.floatValue / 1000]];
//            [self.kcalLabel setText:[NSString stringWithFormat:@"%@", model.sportModel.kCalNumber]];
//            
//            //保存motion数据到数据库
//            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//            [dateformatter setDateFormat:@"yyyy/MM/dd"];
//            NSDate *currentDate = [NSDate date];
//            NSString *currentDateString = [dateformatter stringFromDate:currentDate];
//            //存储至数据库
//            NSArray *stepArr = [self.myFmdbManager queryStepWithDate:currentDateString];
//            if (stepArr.count == 0) {
//                [self.myFmdbManager insertStepModel:model.sportModel];
//                
//            }else {
//                [self.myFmdbManager modifyStepWithDate:currentDateString model:model.sportModel];
//            }
//        }
//    }
//}

/** 更新图表视图 */
- (void)updateStepUIWithDataArr:(NSArray *)dbArr
{
    /**
     1.更新按小时记录的柱状图
     */
    [self.dataArr removeAllObjects];
    [self.dateArr removeAllObjects];
//    [self.milArr removeAllObjects];
//    [self.kcalArr removeAllObjects];
    if (dbArr.count == 0) {
//        [self showNoDataView];
        return ;
    }else {
//        self.noDataLabel.hidden = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableDictionary *dbDic = [NSMutableDictionary dictionaryWithCapacity:dbArr.count];
            for (SegmentedStepModel *model in dbArr) {
                //            [self.dataArr addObject:@(model.stepNumber.integerValue)];
                [dbDic setObject:model  forKey:[model.startTime substringWithRange:NSMakeRange(11, 2)]];
                //设置数据源的最大值为 barChart 的最大值的2/3
                if (model.stepNumber.integerValue > self.stepBarChart.yMaxValue * 0.7) {
                    self.stepBarChart.yMaxValue = model.stepNumber.integerValue * 1.3;
                }
            }
            NSMutableArray *indexArr = [NSMutableArray array];
            for (int index = 0; index < 24; index ++) {
                [indexArr addObject:[NSString stringWithFormat:@"%02d", index]];
//                [self.dateArr addObject:@""];
            }
            
            //从数组中取出该时间有没有计步信息，没有的填充0
            for (NSString *index in indexArr) {
                SegmentedStepModel *model = dbDic[index];
                if (model) {
                    [self.dataArr addObject:@(model.stepNumber.integerValue)];
//                    [self.milArr addObject:@(model.mileageNumber.integerValue)];
//                    [self.kcalArr addObject:@(model.kCalNumber.integerValue)];
                    NSLog(@"-----------kcal == %ld", model.kCalNumber.integerValue);
                }else {
                    [self.dataArr addObject:@(0)];
//                    [self.milArr addObject:@(0)];
//                    [self.kcalArr addObject:@(0)];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回主线程更新 UI
                [self.stepBarChart setXLabels:self.dateArr];
                [self.stepBarChart setYValues:self.dataArr];
                [self.stepBarChart updateChartData:self.dataArr];
            });
        });
    }
}

#pragma mark - lazy
- (PNBarChart *)stepBarChart
{
    if (!_stepBarChart) {
        _stepBarChart = [[PNBarChart alloc] init];
        [_stepBarChart setStrokeColor:NAVIGATION_BAR_COLOR];
        _stepBarChart.barBackgroundColor = [UIColor clearColor];
        _stepBarChart.yChartLabelWidth = 20.0;
        _stepBarChart.chartMarginLeft = 0;
        _stepBarChart.chartMarginRight = 0;
        _stepBarChart.chartMarginTop = 0;
        _stepBarChart.chartMarginBottom = 0;
        _stepBarChart.yMinValue = 0;
        _stepBarChart.yMaxValue = 200;
        _stepBarChart.barWidth = 12;
        _stepBarChart.barRadius = 0;
        _stepBarChart.showLabel = NO;
        _stepBarChart.showChartBorder = NO;
        _stepBarChart.isShowNumbers = NO;
        _stepBarChart.isGradientShow = NO;
        _stepBarChart.delegate = self;
        
        [self addSubview:_stepBarChart];
        [_stepBarChart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.top.equalTo(self.todayStep.mas_bottom).offset(10);
        }];
    }
    
    return _stepBarChart;
}

- (FMDBManager *)myFmdbManager
{
    if (!_myFmdbManager) {
        _myFmdbManager = [[FMDBManager alloc] initWithPath:DB_NAME];
    }
    
    return _myFmdbManager;
}

- (NSMutableArray *)dateArr
{
    if (!_dateArr) {
        _dateArr = [NSMutableArray array];
    }
    
    return _dateArr;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
}

@end
