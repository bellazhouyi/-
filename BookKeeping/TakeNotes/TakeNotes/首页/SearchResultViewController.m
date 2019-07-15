//
//  SearchResultViewController.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/6/8.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "SearchResultViewController.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
#import "NSDate+Formatter.h"
#import "NSArray+Safety.h"
#import "A_BillCell.h"
#import "A_BillTableHeader.h"
#import "FetchRequestManager.h"
#import "Money+CoreDataProperties.h"
#import "Constant.h"
@interface SearchResultViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchResult;
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self searchCoreData];
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.searchResult.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.searchResult objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    A_BillCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Money *instance = [[self.searchResult objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    switch (_searchForBigType) {
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
    Money *instance = [[self.searchResult safeObjectAtIndex:section] safeObjectAtIndex:0];
    header.timeLabel.text = [instance.time dateToStringByFormatterString:@"MM-dd"];
    header.weekLabel.text = instance.weekStr;
    float income = 0.0, outgoing = 0.0;
    for (Money *instance in [self.searchResult safeObjectAtIndex:section]) {
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

#pragma mark - private
- (void)searchCoreData {
    NSString *predicateDesc = @"";
    switch (_searchForSmallType) {
        case -1:
            predicateDesc = [NSString stringWithFormat:@"bigType == %d",_searchForBigType];
            break;
            
        default:
            predicateDesc = [NSString stringWithFormat:@"bigType == %d && smallType == %d",_searchForBigType,_searchForSmallType];
            break;
    }
    NSArray *array = [FetchRequestManager fetchByEntityName:NSStringFromClass([Money class]) predicateDesc:predicateDesc sortDescriptors:@[] isPredicate:YES];
    NSMutableArray *tempExitsData = [@[] mutableCopy];
    for (Money *instance in array) {
        NSMutableArray *sameDateData = [@[instance] mutableCopy];
        for (Money *nextInstance in array) {
            if ([tempExitsData containsObject:instance]) {
                [sameDateData removeAllObjects];
                break;
            }
            if (instance != nextInstance && [[instance.time dateToStringByFormatterString:@"yyyy-MM-dd"] isEqualToString:[nextInstance.time dateToStringByFormatterString:@"yyyy-MM-dd"]]) {
                [sameDateData addObject:nextInstance];
                [tempExitsData addObject:nextInstance];
            }
        }
        if (sameDateData.count != 0) {
            [self.searchResult addObject:sameDateData];
        }
    }
    [self.tableView reloadData];
}
- (void)configUI {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44.;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImage:[UIImage imageNamed:@"noData"] titleStr:@"" detailStr:@"暂时没有相关数据"];
}
#pragma mark - setter
- (void)setSearchKeyword:(NSString *)searchKeyword {
    _searchKeyword = searchKeyword;
    self.title = searchKeyword;
}
- (void)setSearchForBigType:(int16_t)searchForBigType {
    _searchForBigType = searchForBigType;
}
- (void)setSearchForSmallType:(int16_t)searchForSmallType {
    _searchForSmallType = searchForSmallType;
}
#pragma mark - getter
- (NSMutableArray *)searchResult {
    if (!_searchResult) {
        _searchResult = [@[] mutableCopy];
    }
    return _searchResult;
}
@end
