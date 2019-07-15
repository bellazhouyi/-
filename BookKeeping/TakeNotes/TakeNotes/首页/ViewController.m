//
//  ViewController.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/13.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "ViewController.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIViewController+Config.h"
#import "NSDate+Formatter.h"
#import "NSArray+Safety.h"
#import "A_BillCell.h"
#import "A_BillTableHeader.h"
#import "DetailViewController.h"
#import "SearchViewController.h"
#import "Money+CoreDataProperties.h"
#import "FetchRequestManager.h"
#import "CoreDataStackManager.h"
#import "Constant.h"
#import "TouchIDHandler.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerContentView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UILabel *leaveMoneyDescLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *monthOutgoingLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthBalanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;
@property (nonatomic, strong) NSMutableArray *moneyInstaceByTimeArray;
@property (nonatomic, strong) NSString *currentShowMonth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configOriginalUI];
    [self addNotification];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if ([TouchIDHandler sharedTouchIDHandler].openGlobleSwitchForTouchID) {
        [[TouchIDHandler sharedTouchIDHandler] openTouchIDResult:^(BOOL result, NSString * _Nonnull msg) {
            if (result) {
                [self loadCoreData];
            }else {
                
            }
        }];
    }else {
        [self loadCoreData];
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.moneyInstaceByTimeArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.moneyInstaceByTimeArray safeObjectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    A_BillCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Money *instance = [[self.moneyInstaceByTimeArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    cell.noteLabel.text = instance.note;
    switch (instance.bigType) {
        case MoneyBigType_income:
        {
            cell.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",instance.money];
            cell.smallTypeLabel.text = [[Constant smallTypeUnderIncomeMoney] safeObjectAtIndex:instance.smallType];
            [cell.smallTypeIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"1_%d_1",instance.smallType]]];
        }
            break;
            
        case MoneyBigType_outgoing:
        {
            cell.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",instance.money];
            cell.smallTypeLabel.text = [[Constant smallTypeUnderOutgoingMoney] safeObjectAtIndex:instance.smallType];
            [cell.smallTypeIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d_1",instance.smallType]]];
        }
            break;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    A_BillTableHeader *header = [A_BillTableHeader xibInstance];
    Money *instance = [[self.moneyInstaceByTimeArray safeObjectAtIndex:section] safeObjectAtIndex:0];
    header.timeLabel.text = [instance.time dateToStringByFormatterString:@"MM-dd"];
    header.weekLabel.text = instance.weekStr;
    float income = 0.0, outgoing = 0.0;
    for (Money *instance in [self.moneyInstaceByTimeArray safeObjectAtIndex:section]) {
        switch (instance.bigType) {
            case MoneyBigType_income:
                income += instance.money;
                break;
                
            case MoneyBigType_outgoing:
                outgoing += instance.money;
                break;
        }
    }
    header.incomeMoneyLabel.text = [NSString stringWithFormat:@"%.2f",income];
    header.outgoingMoneyLabel.text = [NSString stringWithFormat:@"%.2f",outgoing];
    return header;
}
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        Money *instance = [[self.moneyInstaceByTimeArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
        BOOL result = [FetchRequestManager deleteByEntityName:NSStringFromClass([Money class]) predicateDesc:[NSString stringWithFormat:@"moneyID == %@",instance.moneyID]];
        [kDefaultCenter postNotificationName:notification_fetchMoneyTable object:nil];
        NSLog(@"删除成功111111  %d",result);
    }];
    deleteRowAction.title = @"删除";
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}
#pragma mark - action
- (IBAction)confirmSelectMonthAction:(UIButton *)sender {
    self.datePickerContentView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.currentShowMonth = [self.datePicker.date dateToStringByFormatterString:@"yyyy-MM"];
    [self.monthButton setTitle:[self.datePicker.date dateToStringByFormatterString:@"yyyy年MM月"] forState:UIControlStateNormal];
    [self.monthButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    [self loadCoreData];
}
- (IBAction)selectMonthAction:(UIButton *)sender {
    self.datePickerContentView.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (IBAction)tapDatePickerContentView:(UITapGestureRecognizer *)sender {
    self.datePickerContentView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
- (IBAction)searchAction:(UIButton *)sender {
}
#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //判断哪条segue
    if ([segue.identifier isEqualToString:@"toDetailVCSegue"]) {
        A_BillCell *cell = (A_BillCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        DetailViewController *detailVCInstance = segue.destinationViewController;
        detailVCInstance.view.backgroundColor = [UIColor whiteColor];
        detailVCInstance.moneyModel = [[self.moneyInstaceByTimeArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    }
}
#pragma mark - private
//MARK: UI
- (void)configOriginalUI {
    self.centerView.layer.cornerRadius = 10;
    self.centerView.layer.shadowOffset = CGSizeZero;
    self.centerView.layer.shadowRadius = 5;
    self.centerView.layer.shadowOpacity = .5;
    self.centerView.layer.shadowColor = kColorWithRGB(19, 114, 232).CGColor;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedSectionHeaderHeight = 0.01;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.datePickerContentView.hidden = YES;
    self.currentShowMonth = [[NSDate date] dateToStringByFormatterString:@"yyyy-MM"];
    [self.monthButton setTitle:[[NSDate date] dateToStringByFormatterString:@"yyyy年MM月"] forState:UIControlStateNormal];
    [self.monthButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImage:[UIImage imageNamed:@"noData"] titleStr:@"" detailStr:@"暂无数据"];
}
- (void)loadCoreData {
    [self.moneyInstaceByTimeArray removeAllObjects];
    NSArray *result = [self allMoneyData];
    float monthIncome = 0.0, monthOutgoing = 0.0;
    NSMutableArray *tempResult = [@[] mutableCopy];//用于记录已经归类过的对象
    for (Money *instance in result) {
        NSMutableArray *instanceSameTimeArray = [@[] mutableCopy];
        //计算本月的收支
        if (instance.time != nil && [[instance.time dateToStringByFormatterString:@"yyyy-MM"] isEqualToString:_currentShowMonth]) {
            switch (instance.bigType) {
                case MoneyBigType_outgoing:
                    monthOutgoing += instance.money;
                    break;
                case MoneyBigType_income:
                    monthIncome += instance.money;
                    break;
            }
            //开始本月的号数分组
            [instanceSameTimeArray addObject:instance];
            for (Money *nextInstance in result) {
                if ([tempResult containsObject:instance]) {
                    [instanceSameTimeArray removeAllObjects];
                    break;
                }
                if (instance != nextInstance && [[instance.time dateToStringByFormatterString:@"yyyy-MM-dd"] isEqualToString:[nextInstance.time dateToStringByFormatterString:@"yyyy-MM-dd"]]) {
                    [instanceSameTimeArray addObject:nextInstance];
                    [tempResult addObject:nextInstance];
                }
            }
            if (instanceSameTimeArray.count != 0) {
                [self.moneyInstaceByTimeArray addObject:instanceSameTimeArray];
            }
        }
    }
    self.monthIncomeLabel.text = [NSString stringWithFormat:@"%.2f",monthIncome];
    self.monthOutgoingLabel.text = [NSString stringWithFormat:@"%.2f",monthOutgoing];
    float leaveMoney = monthIncome - monthOutgoing;
    self.leaveMoneyDescLabel.text = [NSString stringWithFormat:@"%@(元)",leaveMoney>=0?@"结余":@"负债"];
    self.monthBalanceLabel.text = leaveMoney >= 0?[NSString stringWithFormat:@"%.2f",leaveMoney]:[NSString stringWithFormat:@"%.2f",-leaveMoney];
    [self.tableView reloadData];
}
- (void)addNotification {
    [kDefaultCenter addObserver:self selector:@selector(loadCoreData) name:notification_fetchMoneyTable object:nil];
}
#pragma mark - getter
- (NSMutableArray *)moneyInstaceByTimeArray {
    if (!_moneyInstaceByTimeArray) {
        _moneyInstaceByTimeArray = [@[] mutableCopy];
    }
    return _moneyInstaceByTimeArray;
}
@end
