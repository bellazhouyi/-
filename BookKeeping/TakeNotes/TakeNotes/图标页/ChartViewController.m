//
//  ChartViewController.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/16.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "ChartViewController.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
#import "UIViewController+Config.h"
#import "NSDate+Formatter.h"
#import "ChangeView.h"
#import "ChartCell.h"
#import "Money+CoreDataClass.h"
#import "PieChartView.h"
#import "ChartDetailViewController.h"
#import "Constant.h"
#import "TouchIDHandler.h"
typedef NS_ENUM(NSInteger, ChartSegmentType) {
    ChartSegmentType_month,
    ChartSegmentType_year
};
@interface ChartViewController ()<UITableViewDataSource, UITableViewDelegate, ChangeViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ChangeView *changeView;
@property (weak, nonatomic) IBOutlet PieChartView *pieView;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *smallTypesRankLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *smallTypeRankScaleLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *smallTypeColorView;
@property (weak, nonatomic) IBOutlet UIView *datePickerContentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) ChartSegmentType selectedType;
@property (nonatomic, assign) MoneyBigType bigType;
@property (nonatomic, copy) NSDate *selectedMonth;
@property (nonatomic, strong) NSArray *billScaleArray; //账单内部的前四类型
@end
static NSString * const cellIdentifier = @"chartCell";
@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configOriginalUI];
    [self addNotification];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
#pragma mark - delgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.billScaleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSArray *sameSmallTypeArray = [self.billScaleArray objectAtIndex:indexPath.row];
    float totalMoney = 0.0;
    int i = 0;
    for (Money *instance in sameSmallTypeArray) {
        totalMoney += instance.money;
        if (i == 0) {
            switch (instance.bigType) {
                case MoneyBigType_income:
                {
                    cell.smallTypeNameLabel.text = [[Constant smallTypeUnderIncomeMoney] objectAtIndex:instance.smallType];
                    cell.smallTypeIconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"1_%d_1", instance.smallType]];
                }
                    break;
                    
                case MoneyBigType_outgoing:
                {
                    cell.smallTypeNameLabel.text = [[Constant smallTypeUnderOutgoingMoney] objectAtIndex:instance.smallType];
                    cell.smallTypeIconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_1", instance.smallType]];
                }
                    break;
            }
        }
        i++;
    }
    cell.smallTypeGroupMoney.text = [NSString stringWithFormat:@"%.2f",totalMoney];
    return cell;
}
- (void)changingAnimatedBySender:(UIButton *)sender {
    switch (sender.tag) {
        case ResourceType_increase:
        {
            self.bigType = MoneyBigType_income;
        }
            break;
            
        case ResourceType_decrease:
        {
            self.bigType = MoneyBigType_outgoing;
        }
            break;
    }
    [self sortOutBySegmentType:self.selectedType];
}
#pragma mark - action
- (IBAction)touchSegmentedControl:(UISegmentedControl *)sender {
    self.selectedType = sender.selectedSegmentIndex;
    [self updatePieView];
}
- (IBAction)touchSelectMonth:(UIButton *)sender {
    self.datePickerContentView.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (IBAction)tapDatePickerContentBg:(UITapGestureRecognizer *)sender {
    self.datePickerContentView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
- (IBAction)confirmSelectedDateAction:(UIButton *)sender {
    [self.monthButton setTitle:[self.datePicker.date dateToStringByFormatterString:@"yyyy年MM月"] forState:UIControlStateNormal];
    self.selectedMonth = self.datePicker.date;
    self.datePickerContentView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self updatePieView];
}
#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //判断哪条segue
    if ([segue.identifier isEqualToString:@"showPhotoList"]) {
        ChartCell *cell = (ChartCell *)[[sender superview]superview];
        ChartDetailViewController *plvc = segue.destinationViewController;
        // plvc.model = [_photoLibraryArray objectAtIndex:[_tableView indexPathForCell:cell].row];
    }
}
#pragma mark - private
- (void)addNotification {
    [kDefaultCenter addObserver:self selector:@selector(updatePieView) name:notification_fetchMoneyTable object:nil];
}
- (void)configOriginalUI {
    self.datePickerContentView.hidden = YES;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedSectionHeaderHeight = 0.01;
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImage:[UIImage imageNamed:@"noData"] titleStr:@"" detailStr:@"暂无数据"];
    
    self.changeView.delegate = self;
    self.selectedType = ChartSegmentType_month;
    self.bigType = MoneyBigType_income;
    self.selectedMonth = [NSDate date];
    [self.monthButton setTitle:[[NSDate date] dateToStringByFormatterString:@"yyyy年MM月"] forState:UIControlStateNormal];
    [self.monthButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self sortOutBySegmentType:ChartSegmentType_month];
}
- (void)updatePieView {
    [self sortOutBySegmentType:self.selectedType];
}
- (void)sortOutBySegmentType:(ChartSegmentType)type {
    switch (self.bigType) {
        case MoneyBigType_income:
            self.pieView.centerTitleLabel.text = @"总收入";
            break;
        case MoneyBigType_outgoing:
            self.pieView.centerTitleLabel.text = @"总支出";
            break;
    }
    NSArray *allMoneyDataArray = [self allMoneyData];
    NSMutableArray *monthArray = [@[] mutableCopy];
    float totalMoney = 0.00;
    switch (type) {
        case ChartSegmentType_month:
        {
            for (Money *instance in allMoneyDataArray) {
                if ([[instance.time dateToStringByFormatterString:@"yyyy-MM"] isEqualToString:[self.selectedMonth dateToStringByFormatterString:@"yyyy-MM"]] && self.bigType == instance.bigType) {
                    //组成当月 并且 bigType相同的数组
                    [monthArray addObject:instance];
                    totalMoney += instance.money;
                }
            }
        }
            break;
            
        case ChartSegmentType_year:
        {
            for (Money *instance in allMoneyDataArray) {
                if ([[instance.time dateToStringByFormatterString:@"yyyy"] isEqualToString:[self.selectedMonth dateToStringByFormatterString:@"yyyy"]] && self.bigType == instance.bigType) {
                    //组成当月 并且 bigType相同的数组
                    [monthArray addObject:instance];
                    totalMoney += instance.money;
                }
            }
        }
            break;
    }
    
    NSMutableArray *exitsSmallTypeArray = [@[] mutableCopy];
    NSMutableArray *groupArrayBySmallType = [@[] mutableCopy];
    for (Money *instance in monthArray) {
        //选小类型
        NSMutableArray *smallTypeArray = [@[instance] mutableCopy];
        for (Money *nextInstance in monthArray) {
            if ([exitsSmallTypeArray containsObject:instance]) {
                [smallTypeArray removeAllObjects];
                break;
            }
            if (instance != nextInstance && instance.smallType == nextInstance.smallType) {
                [smallTypeArray addObject:nextInstance];
                [exitsSmallTypeArray addObject:nextInstance];
            }
        }
        if (smallTypeArray.count != 0) {
            [groupArrayBySmallType addObject:smallTypeArray];
        }
    }
    //从高到低 排序
    [groupArrayBySmallType sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        float obj1Value = 0.00;
        for (Money *instance in obj1) {
            obj1Value += instance.money;
        }
        float obj2Value = 0.00;
        for (Money *instance in obj2) {
            obj2Value += instance.money;
        }
        return obj1Value < obj2Value;
    }];
    {
        // 改变账单 cell
        self.billScaleArray = groupArrayBySmallType;
        [self.tableView reloadData];
    }
    //计算 份额
    NSMutableArray *scaleArray = [@[] mutableCopy];
    //下个周来改 这里 加起来等于1，做修正
    float maxScale = 0.0;
    float tempMaxScale = 0.0;
    for (NSArray *array in groupArrayBySmallType) {
        float money = 0.00;
        float eachGroupScale = 0.0;
        for (Money *instance in array) {
            money += instance.money;
        }
        eachGroupScale = money/totalMoney;
        tempMaxScale += eachGroupScale;
        if (tempMaxScale > 1.0) {
            eachGroupScale = 1.0 - maxScale;
        }else {
            maxScale += eachGroupScale;
        }
        if (scaleArray.count > 4) {
            [scaleArray replaceObjectAtIndex:3 withObject:@((1- [[scaleArray objectAtIndex:0] floatValue] - [[scaleArray objectAtIndex:1] floatValue] - [[scaleArray objectAtIndex:2] floatValue]))];
        }else {
            [scaleArray addObject:@(eachGroupScale)];
        }
    }
    if (scaleArray.count == 0) {
        [self.pieView drawPieWithScaleArray:@[@(1.0)] colors:@[[UIColor lightGrayColor]]];
    }else {
        [self.pieView drawPieWithScaleArray:scaleArray colors:nil];
    }
    self.pieView.centerMoneyLabel.text = [NSString stringWithFormat:@"%.2f",totalMoney];
    NSArray *array = self.bigType==MoneyBigType_income?[Constant smallTypeUnderIncomeMoney]:[Constant smallTypeUnderOutgoingMoney];
    for (UILabel *label in self.smallTypesRankLabel) {
        if (label.tag - 1000 < groupArrayBySmallType.count) {
            label.hidden = NO;
            if (scaleArray.count < 5) {
                label.text = [array objectAtIndex:[[[groupArrayBySmallType objectAtIndex:(label.tag - 1000)] firstObject] smallType]];
            }else {
                if (label.tag - 1000 == 3) {
                    label.text = @"其他";
                }else {
                    label.text = [array objectAtIndex:[[[groupArrayBySmallType objectAtIndex:(label.tag - 1000)] firstObject] smallType]];
                }
            }
        }else {
            label.hidden = YES;
        }
    }
    for (UILabel *label in self.smallTypeRankScaleLabel) {
        if (label.tag - 1000 < groupArrayBySmallType.count) {
            label.hidden = NO;
            label.text = [NSString stringWithFormat:@"%.2f%%",[[scaleArray objectAtIndex:(label.tag - 1000)] floatValue]*100];
        }else {
            label.hidden = YES;
        }
    }
    for (UIView *view in self.smallTypeColorView) {
        if (view.tag - 1000 < groupArrayBySmallType.count) {
            view.hidden = NO;
        }else {
            view.hidden = YES;
        }
    }
}
@end
