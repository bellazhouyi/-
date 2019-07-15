//
//  SearchViewController.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/31.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "SearchCell.h"
#import "SearchGroupHeader.h"
#import "Constant.h"
@interface SearchViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
static NSString *cellIdentifier = @"searchCell";
@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return [[Constant smallTypeUnderOutgoingMoney] count] + 1;
    }else {
        return [[Constant smallTypeUnderIncomeMoney] count] + 1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            cell.typeNameLabel.text = @"全部支出";
        }else {
            cell.typeNameLabel.text = [[Constant smallTypeUnderOutgoingMoney] objectAtIndex:(indexPath.item -1)];
        }
    }else {
        if (indexPath.item == 0) {
            cell.typeNameLabel.text = @"全部收入";
        }else {
            cell.typeNameLabel.text = [[Constant smallTypeUnderIncomeMoney] objectAtIndex:(indexPath.item -1)];
        }
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil ;
    
    if (kind == UICollectionElementKindSectionHeader ){
        
        SearchGroupHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader withReuseIdentifier:@"searchGroupHeader" forIndexPath :indexPath];
        if (indexPath.section == 0) {
            headerView.nameLabel.text = @"支出";
        }else {
            headerView.nameLabel.text = @"收入";
        }
        reusableview = headerView;
        
    }
    return reusableview;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"搜索：%@",indexPath);
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //判断哪条segue
    if ([segue.identifier isEqualToString:@"toSearchResultVCSegue"]) {
        SearchCell *cell = (SearchCell *)sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        SearchResultViewController *searchResultInstance = segue.destinationViewController;
        searchResultInstance.view.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 0) {
            searchResultInstance.searchForBigType = MoneyBigType_outgoing;
            if (indexPath.item == 0) {
                searchResultInstance.searchForSmallType = -1;
                searchResultInstance.searchKeyword = @"全部支出";
            }else {
                searchResultInstance.searchForSmallType = indexPath.item -1;
                searchResultInstance.searchKeyword = [[Constant smallTypeUnderOutgoingMoney] objectAtIndex:(indexPath.item -1)];
            }
        }else {
            searchResultInstance.searchForBigType = MoneyBigType_income;
            if (indexPath.item == 0) {
                searchResultInstance.searchForSmallType = -1;
                searchResultInstance.searchKeyword = @"全部收入";
            }else {
                searchResultInstance.searchForSmallType = indexPath.item -1;
                searchResultInstance.searchKeyword = [[Constant smallTypeUnderIncomeMoney] objectAtIndex:(indexPath.item -1)];
            }
        }
    }
}
@end
