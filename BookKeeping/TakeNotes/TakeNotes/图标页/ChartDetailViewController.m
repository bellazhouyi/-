//
//  ChartDetailViewController.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/17.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "ChartDetailViewController.h"
#import "UIViewController+Config.h"
#import "ChartDetailCell.h"
@interface ChartDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
static NSString * const cellIdentifier = @"chartDetailCell";
@implementation ChartDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configOriginalUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - delgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChartDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}
#pragma mark - private
- (void)configOriginalUI {
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedSectionHeaderHeight = 0.01;
}
@end
