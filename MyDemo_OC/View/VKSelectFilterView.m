//
//  VKSelectFilterView.m
//  MyDemo_OC
//
//  Created by zcy on 2019/8/26.
//  Copyright © 2019 CY. All rights reserved.
//

#import "VKSelectFilterView.h"
#import "CYSelectFilterViewCell.h"
#import "CYSelectFilterReusableView.h"

@interface VKSelectFilterView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollecView;

@end

@implementation VKSelectFilterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)hiddenFilterView:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.origin = CGPointMake(MainScreenWidth, 0);
    }];
    
}

- (void)showFilterView {
    [UIView animateWithDuration:0.5 animations:^{
        self.origin = CGPointMake(0, 0);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.itemArr count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSDictionary *dic1 = self.itemArr[indexPath.section];
//    NSArray *arr1 = dic1[@"itemArr"];
//    NSString *str = arr1[indexPath.row];
//    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] maxW:200];
    
    return CGSizeMake(90, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(MainScreenWidth, 100);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dic1 = self.itemArr[section];
    NSArray *arr1 = dic1[@"itemArr"];
    return [arr1 count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CYSelectFilterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
    NSDictionary *dic1 = self.itemArr[indexPath.section];
    NSArray *arr1 = dic1[@"itemArr"];
    cell.titleLab.text = arr1[indexPath.row];
    if (indexPath.section == 1) {
    }

    if ([dic1[@"selectItem"] isEqualToString:cell.titleLab.text]) {
        cell.backgroundColor = DefaultRedColor;
    }else {
        cell.backgroundColor = DefaultHintGrayColor;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CYSelectFilterReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID" forIndexPath:indexPath];
    NSDictionary *dic1 = self.itemArr[indexPath.section];
    headerView.titleLab.text = dic1[@"title"];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic1 = self.itemArr[indexPath.section];
    NSArray *arr1 = dic1[@"itemArr"];
    [dic1 setValue:arr1[indexPath.row] forKey:@"selectItem"];
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [collectionView reloadSections:reloadSet];
    }];
}

- (void)setItemArr:(NSArray *)itemArr {
    _itemArr = itemArr;
    [self.myCollecView registerClass:[CYSelectFilterViewCell class] forCellWithReuseIdentifier:@"CELLID"];
    [self.myCollecView registerClass:[CYSelectFilterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID"];
    [self.myCollecView reloadData];
}


@end
