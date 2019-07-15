//
//  DetailViewController.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/16.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "DetailViewController.h"
#import "NSDate+Formatter.h"
#import "UIViewController+Config.h"
#import "DetailCell.h"
#import "Money+CoreDataProperties.h"
#import "Constant.h"
typedef NS_ENUM(NSInteger, DetailCellType) {
    DetailCellType_note = 0,
    DetailCellType_date,
    DetailCellType_resourceType
};
@interface DetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *smallTypeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smallTypeIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
static NSString * const cellIdentifier = @"detailCell";
@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configOriginalUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case DetailCellType_note:
        {
            cell.leftLabel.text = @"备注";
            cell.rightLabel.text = _moneyModel.note;
        }
            break;
        case DetailCellType_date:
        {
            cell.leftLabel.text = @"日期";
            cell.rightLabel.text = [_moneyModel.time dateToStringByFormatterString:@"yyyy-MM-dd"];
        }
            break;
        case DetailCellType_resourceType:
        {
            cell.leftLabel.text = @"类型";
            switch (_moneyModel.bigType) {
                case MoneyBigType_outgoing:
                    cell.rightLabel.text = @"支出";
                    break;
                    
                case MoneyBigType_income:
                    cell.rightLabel.text = @"收入";
                    break;
            }
        }
            break;
    }
    return cell;
}
#pragma mark - private
- (void)configOriginalUI {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedSectionHeaderHeight = 0.01;
    self.tableView.estimatedRowHeight = 44.;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
#pragma mark - setter
- (void)setMoneyModel:(Money *)moneyModel {
    _moneyModel = moneyModel;
    switch (moneyModel.bigType) {
        case MoneyBigType_income:
        {
            self.smallTypeIconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"1_%d_1",moneyModel.smallType]];
            self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",moneyModel.money];
             self.smallTypeNameLabel.text = [NSString stringWithFormat:@"%@",[[Constant smallTypeUnderIncomeMoney] objectAtIndex:moneyModel.smallType]];
        }
            break;
            
        case MoneyBigType_outgoing:
        {
            self.smallTypeIconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_1",moneyModel.smallType]];
            self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",moneyModel.money];
            self.smallTypeNameLabel.text = [NSString stringWithFormat:@"%@",[[Constant smallTypeUnderOutgoingMoney] objectAtIndex:moneyModel.smallType]];
        }
            break;
    }
}
@end
