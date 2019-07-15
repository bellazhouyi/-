//
//  EditViewController.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/15.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "EditViewController.h"
#import <Masonry/Masonry.h>
#import "UIViewController+Config.h"
#import "UIView+ResignFirstResponder.h"
#import "NSDate+Formatter.h"
#import "NSArray+Safety.h"
#import "EditCell.h"
#import "ChangeView.h"
#import "Money+CoreDataProperties.h"
#import "CoreDataStackManager.h"
#import "FetchRequestManager.h"
#import "Constant.h"
#import "MoneyModel.h"

typedef NS_ENUM(NSInteger, TextFieldEditType) {
    TextFieldEditType_takeMoreNotes = 1000, //备注
    TextFieldEditType_inputMoney = 1001 //金额
};
@interface EditViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ChangeViewDelegate>
@property (weak, nonatomic) IBOutlet ChangeView *changeView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *safeAreaBottomEqualBottomViewBottom;
@property (weak, nonatomic) IBOutlet UIView *datePickerContentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (nonatomic, strong) NSArray *increaseTypeNameArray;
@property (nonatomic, strong) NSArray *decreaseTypeNameArray;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) ResourceType type;
@property (nonatomic, assign) NSInteger selectIndexOfItem;
@property (nonatomic, strong) MoneyModel *moneyInstance;
@end

static NSString * cellIdentifier = @"editCell";
@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configOriginalUI];
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.type) {
        case ResourceType_increase:
            _count = self.increaseTypeNameArray.count;
            break;
        case ResourceType_decrease:
            _count = self.decreaseTypeNameArray.count;
            break;
    }
    return _count ;//+ 1;// +1 表示自定义
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.item < _count) {
        NSString *iconName = @"";
        switch (self.type) {
            case ResourceType_increase:
            {
                if (indexPath.item == self.selectIndexOfItem) {
                    iconName = [NSString stringWithFormat:@"1_%ld_1",indexPath.item];
                }else {
                    iconName = [NSString stringWithFormat:@"1_%ld_0",indexPath.item];
                }
                [cell.iconButton setTitle:[NSString stringWithFormat:@"%@",[self.increaseTypeNameArray safeObjectAtIndex:indexPath.item]] forState:UIControlStateNormal];
            }
                break;
            case ResourceType_decrease:
            {
                if (indexPath.item == self.selectIndexOfItem) {
                    iconName = [NSString stringWithFormat:@"%ld_1",indexPath.item];
                }else {
                    iconName = [NSString stringWithFormat:@"%ld_0",indexPath.item];
                }
                [cell.iconButton setTitle:[NSString stringWithFormat:@"%@",[self.decreaseTypeNameArray safeObjectAtIndex:indexPath.item]] forState:UIControlStateNormal];
            }
                break;
        }
        
        [cell.iconButton setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    }else {
        [cell.iconButton setImage:[UIImage imageNamed:@"0"] forState:UIControlStateNormal];
        [cell.iconButton setTitle:@"自定义" forState:UIControlStateNormal];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndexOfItem = indexPath.item;
    [self.collectionView reloadData];
    self.moneyInstance.smallType = indexPath.item;
}
- (IBAction)textFieldEditDidEnd:(UITextField *)sender {
    
    switch (sender.tag) {
        case TextFieldEditType_inputMoney:
        {
            NSLog(@"金钱");
            self.moneyInstance.money = [sender.text floatValue];
        }
            break;
            
        case TextFieldEditType_takeMoreNotes:
        {
            NSLog(@"备注");
            self.moneyInstance.note = sender.text;
        }
            break;
    }
}

- (void)changingAnimatedBySender:(UIButton *)sender {
    [UIView resignTheFirstResponder];
    switch (sender.tag) {
        case ResourceType_increase:
        {
            self.safeAreaBottomEqualBottomViewBottom.constant = 380;
            self.moneyInstance.bigType = MoneyBigType_income;
        }
            break;
            
        case ResourceType_decrease:
        {
            self.safeAreaBottomEqualBottomViewBottom.constant = 100;
            self.moneyInstance.bigType = MoneyBigType_outgoing;
        }
            break;
    }
    self.type = sender.tag;
    self.selectIndexOfItem = -1;
    [self.collectionView reloadData];
}
#pragma mark - action
- (IBAction)cancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)confirmAction:(UIButton *)sender {
    if (self.moneyInstance.money <= 0) {
        return;
    }
    if (self.moneyInstance.time == nil) {
        return;
    }
    if (self.moneyInstance.smallType == -1) {
        return;
    }
    NSLog(@"时间：%@ smallType:%d", self.moneyInstance.time, self.moneyInstance.smallType);
    //跟数据库中的表名创建一个实体描述对象。
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([Money class]) inManagedObjectContext:CoreDataStackManager.shareInstance.managerContenxt];
    //加入到被管理对象上下文中。
    Money *moneyInstance = [[Money alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:CoreDataStackManager.shareInstance.managerContenxt];
    //给实体对象的各个属性赋值
    moneyInstance.userID = _moneyInstance.userID;
    moneyInstance.smallType = _moneyInstance.smallType;
    moneyInstance.bigType = _moneyInstance.bigType;
    moneyInstance.note = _moneyInstance.note;
    moneyInstance.money = _moneyInstance.money;
    moneyInstance.time = _moneyInstance.time;
    moneyInstance.weekStr = _moneyInstance.weekStr;
    moneyInstance.moneyID = [[NSDate date] dateToStringByFormatterString:@"yyyyMMDDHHmmss"];
    [[CoreDataStackManager shareInstance] save];
    NSLog(@"写进数据库：%@",moneyInstance);
    [kDefaultCenter postNotificationName:notification_fetchMoneyTable object:nil];
    self.moneyInstance = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)selectDateAction:(UIButton *)sender {
    [UIView resignTheFirstResponder];
    self.datePickerContentView.hidden = NO;
}
- (IBAction)confirmDateAction:(UIButton *)sender {
    [self.timeButton setTitle:[self.datePicker.date dateToStringByFormatterString:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    [self.timeButton setTitleColor:kColorWithRGB(49, 112, 184) forState:UIControlStateNormal];
    self.moneyInstance.time = [self.datePicker.date dateToDateByFormatterString:@"yyyy-MM-dd"];
    NSLog(@"星期几：%@",[self.datePicker.date dateToWeekString]);
    self.moneyInstance.weekStr = [self.datePicker.date dateToWeekString];
    self.datePickerContentView.hidden = YES;
}
- (IBAction)cancelDateSelectAction:(UIButton *)sender {
    self.datePickerContentView.hidden = YES;
}
- (IBAction)tapDatePickerContentView:(UITapGestureRecognizer *)sender {
    self.datePickerContentView.hidden = YES;
}
#pragma mark - private
- (void)configOriginalUI {
    self.type = ResourceType_increase;
    self.safeAreaBottomEqualBottomViewBottom.constant = 380;
    self.selectIndexOfItem = -1;
    self.changeView.delegate = self;
    self.datePickerContentView.hidden = YES;
    [self.timeButton setTitle:[[NSDate date] dateToStringByFormatterString:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    self.moneyInstance.bigType = MoneyBigType_income;
    self.moneyInstance.userID = 1;
    self.moneyInstance.smallType = -1;
}
#pragma mark - getter
- (NSArray *)increaseTypeNameArray {
    if (!_increaseTypeNameArray) {
        _increaseTypeNameArray = [Constant smallTypeUnderIncomeMoney];
    }
    return _increaseTypeNameArray;
}
- (NSArray *)decreaseTypeNameArray {
    if (!_decreaseTypeNameArray) {
        _decreaseTypeNameArray = [Constant smallTypeUnderOutgoingMoney];
    }
    return _decreaseTypeNameArray;
}
- (MoneyModel *)moneyInstance {
    if (!_moneyInstance) {
        _moneyInstance = [MoneyModel new];
    }
    return _moneyInstance;
}
@end
