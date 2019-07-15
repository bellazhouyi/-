//
//  MineViewController.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/17.
//  Copyright © 2019 BellaZhou. All rights reserved.
//
#import "MineViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UIViewController+Config.h"
#import "NSDate+Formatter.h"
#import "Money+CoreDataProperties.h"
#import "Account+CoreDataProperties.h"
#import "TouchIDHandler.h"
#import "CoreDataStackManager.h"
#import "FetchRequestManager.h"
typedef NS_ENUM(NSInteger, FunctionCellType) {
    FunctionCellType_password = 0,
    FunctionCellType_trouble,
    FunctionCellType_setting
};
@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *signDayNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeNotesTotalDayNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeNotesTotalNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userPortraitImgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Account *account;
@end
static NSString * const cellIdentifier = @"chartCell";
@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configOriginalUI];
    [self loadCoreData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
#pragma mark - delgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    switch (indexPath.row) {
        case FunctionCellType_password:
            switch ([TouchIDHandler sharedTouchIDHandler].openGlobleSwitchForTouchID) {
                case 1:
                    cell.textLabel.text = @"关闭指纹密码";
                    break;
                case 0:
                    cell.textLabel.text = @"开启指纹密码";
                    break;
            }
            break;
        case FunctionCellType_trouble:
            cell.textLabel.text = @"常见问题";
            break;
        case FunctionCellType_setting:
            cell.textLabel.text = @"设置";
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case FunctionCellType_password:
        {
            [TouchIDHandler sharedTouchIDHandler].openGlobleSwitchForTouchID = ![TouchIDHandler sharedTouchIDHandler].openGlobleSwitchForTouchID;
            [self.tableView reloadData];
        }
            break;
        case FunctionCellType_trouble:
        {
            
        }
            break;
        case FunctionCellType_setting:
        {
            
        }
            break;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    
    self.account.name = textField.text;
    _account.userID = 1;
    [[CoreDataStackManager shareInstance] save];
}
#pragma mark - private
- (void)configOriginalUI {
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedSectionHeaderHeight = 0.01;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [IQKeyboardManager sharedManager].enable = YES;
    self.userNameTextField.text = self.account.name.length == 0 ?@"小伙计": _account.name;
}
- (void)loadCoreData {
    NSArray *allData = [self allMoneyData];
    self.takeNotesTotalNumberLabel.text =  [NSString stringWithFormat:@"%lu",(unsigned long)allData.count];
    
    int totalDayNumber = 0;
    NSString *tempLastDayStr = @"";
    for (Money *instance in allData) {
        NSString *currentDayStr = [instance.time dateToStringByFormatterString:@"yyyy-MM-dd"];
        if (![tempLastDayStr isEqualToString:currentDayStr]) {
            totalDayNumber++;
            tempLastDayStr = currentDayStr;
        }
    }
    self.takeNotesTotalDayNumberLabel.text =  [NSString stringWithFormat:@"%d",totalDayNumber];
}
#pragma mark - getter
- (Account *)account {
    _account = (Account *)[[FetchRequestManager fetchByEntityName:NSStringFromClass([Account class]) predicateDesc:[NSString stringWithFormat:@"userID == 1"] sortDescriptors:@[] isPredicate:YES] firstObject];
    if (!_account) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([Account class]) inManagedObjectContext:CoreDataStackManager.shareInstance.managerContenxt];
        //加入到被管理对象上下文中。
        _account = [[Account alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:CoreDataStackManager.shareInstance.managerContenxt];
    }
    return _account;
}
@end
