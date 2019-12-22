//
//  CYUploadContentController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/8/28.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYUploadContentController.h"
#import "TZImagePickerController.h"
#import "CYUploadPhotoCell.h"
#import "UITextView+CY.h"
#import <Photos/Photos.h>

#define WordsLimitNum 200
#define MaxPhotoNum 9

@interface CYUploadContentController ()<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLab;
@property (weak, nonatomic) IBOutlet UILabel *wordsNumLab;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollecView;
@property (nonatomic) NSInteger textLength;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;


@end

@implementation CYUploadContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.photoCollecView registerNib:[UINib nibWithNibName:@"CYUploadPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"CYUploadPhotoCell"];
}

- (void)textViewDidChange:(UITextView *)textView{
    //设置全局字符数
    self.textLength = textView.text.length;
    //显示字符数字
    NSString *str = @"";
    //限制输入字数为200
    if (textView.text.length > WordsLimitNum) {
        str = [NSString stringWithFormat:@"%d/%d",WordsLimitNum,WordsLimitNum];
        
        if ([textView limitTVWithLength:WordsLimitNum]==NO) {
            self.textLength = WordsLimitNum;
            NSString *str2 = [textView.text substringWithRange:NSMakeRange(0, WordsLimitNum)];
            
            self.contentTV.text = str2;
        }
    }else{
        str = [NSString stringWithFormat:@"%ld/%d", self.textLength,WordsLimitNum];
    }
    //设置一些属性
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.031 green:0.651 blue:0.941 alpha:1.000] range:NSMakeRange(0, str.length - 4)];
    //赋值回去
    self.wordsNumLab.attributedText = attStr;
    if (self.textLength > 0) {
        self.placeholderLab.hidden = YES;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.selectedPhotos.count >= 9) {
        return self.selectedPhotos.count;
    }
    return self.selectedPhotos.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CYUploadPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYUploadPhotoCell" forIndexPath:indexPath];
    if (indexPath.item == self.selectedPhotos.count && self.selectedPhotos.count != MaxPhotoNum) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
    }else {
        cell.imageView.image = self.selectedPhotos[indexPath.item];
        cell.asset = self.selectedAssets[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.selectedPhotos.count && self.selectedPhotos.count != MaxPhotoNum) {// 选择照片
        [self pushTZImagePickerController];
    }else {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.item];
        imagePickerVc.maxImagesCount = 9;
        imagePickerVc.showSelectedIndex = YES;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
            self.selectedAssets = [NSMutableArray arrayWithArray:assets];
            [self.photoCollecView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:9 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
        self.selectedAssets = [NSMutableArray arrayWithArray:assets];
        [self.photoCollecView reloadData];

    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
