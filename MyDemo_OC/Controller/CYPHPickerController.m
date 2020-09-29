//
//  CYPHPickerController.m
//  MyDemo_OC
//
//  Created by zcy on 2020/9/28.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYPHPickerController.h"
#import <PhotosUI/PhotosUI.h>
#import "CYPHPickerImgCell.h"

@interface CYPHPickerController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, PHPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *imgNumLab;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollecView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollecViewH;

@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, strong) NSMutableArray *assetsArr;

@end

@implementation CYPHPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imagesArr = [NSMutableArray array];
    self.assetsArr = [NSMutableArray array];
    [self.myCollecView registerNib:[UINib nibWithNibName:@"CYPHPickerImgCell" bundle:nil] forCellWithReuseIdentifier:@"CYPHPickerImgCell"];
    self.myCollecViewH.constant = (MainScreenWidth-20-40)/3.0 + 20;
}

#pragma mark - custom method

/// 跳转到照片选择控制器
- (void)selectFeedbackImage {
    if (@available(iOS 14, *)) {
        PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
//        configuration.filter = [PHPickerFilter anyFilterMatchingSubfilters:@[[PHPickerFilter imagesFilter], [PHPickerFilter livePhotosFilter]]];
        configuration.filter = [PHPickerFilter imagesFilter];
        configuration.selectionLimit = 5;
        // automatic 模式可能会在导出时对视频进行转码处理，如果 App 本地能够处理 HEVC 格式的视频，可以指定为 current 模式来跳过转码的过程
        configuration.preferredAssetRepresentationMode = PHPickerConfigurationAssetRepresentationModeCurrent;
        
        PHPickerViewController *pickVC = [[PHPickerViewController alloc] initWithConfiguration:configuration];
        pickVC.delegate = self;
        [self presentViewController:pickVC animated:YES completion:nil];
    }else {
        NSLog(@"系统不支持");
    }
    
}

/// 更新反馈图片
- (void)updateImagesCollection{
    if (self.imagesArr.count > 2) {
        self.myCollecViewH.constant = (MainScreenWidth-20-40)/3.0*2 + 30;
    }else {
        self.myCollecViewH.constant = (MainScreenWidth-20-40)/3.0 + 20;
    }
    self.imgNumLab.text = [NSString stringWithFormat:@"%lu/5", (unsigned long)self.imagesArr.count];
    [self.myCollecView reloadData];
}

- (IBAction)saveImgAction:(id)sender {
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imagesArr.count >= 5) {
        return 5;
    }else {
        return self.imagesArr.count+1;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((MainScreenWidth-20-40)/3.0, (MainScreenWidth-20-40)/3.0);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CYPHPickerImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYPHPickerImgCell" forIndexPath:indexPath];
    cell.tag = 100+indexPath.row;
    cell.deleteBtn.hidden = NO;
    if (self.imagesArr.count >= 5) {
        cell.imgView.image = self.imagesArr[indexPath.row];
    }else {
        if (indexPath.row == self.imagesArr.count) {
            cell.imgView.image = [UIImage imageNamed:@"account_add_pic"];
            cell.deleteBtn.hidden = YES;
        }else {
            cell.imgView.image = self.imagesArr[indexPath.row];
        }
    }
    CY_WeakSelf;
    cell.deleteItemBlock = ^(CYPHPickerImgCell * _Nonnull cell) {
        [weakSelf.imagesArr removeObjectAtIndex:cell.tag-100];
        [weakSelf updateImagesCollection];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectFeedbackImage];
}


#pragma mark - PHPickerViewControllerDelegate

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results  API_AVAILABLE(ios(14)){
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    for (PHPickerResult *result in results) {
        NSItemProvider *itemPro = result.itemProvider;
//        [itemPro loadFileRepresentationForTypeIdentifier:@"public.movie" completionHandler:^(NSURL * _Nullable url, NSError * _Nullable error) {
//
//        }];
        if ([itemPro canLoadObjectOfClass:UIImage.class]) {
            [itemPro loadObjectOfClass:UIImage.class completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
                if (object) {
                    if (self.imagesArr.count < 5) {// 最多5个
                        [self.imagesArr addObject:object];
                    }
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self updateImagesCollection];
                });
            }];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
