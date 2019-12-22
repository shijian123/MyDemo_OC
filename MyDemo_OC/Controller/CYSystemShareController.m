//
//  CYSystemShareController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/17.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYSystemShareController.h"
#import <QuickLook/QuickLook.h>
#import "CYDocument.h"

@interface CYSystemShareController ()< UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate,QLPreviewControllerDelegate,QLPreviewControllerDataSource, UIDocumentPickerDelegate, UIDocumentBrowserViewControllerDelegate>
@property (nonatomic, strong) NSURL *openURl;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (nonatomic, strong) QLPreviewController * qlpreView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *itemArr;

@end

@implementation CYSystemShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.itemArr = @[@"Activity分享图片", @"Activity分享pdf", @"Document预览pdf", @"Document显示到第三方app——pdf", @"Document-OptionsMenu-pdf", @"查看pdf", @"保存pdf", @"DocumentPicker", @"DocumentBrowser"];
    [self.view addSubview:self.myTableView];
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:[[NSBundle mainBundle] URLForResource:@"Steve" withExtension:@"pdf"]];
    _documentController.delegate = self;
}

#pragma mark - custom method

- (void)clickSharePicAction{
    
    NSString *textToShare = @"要分享的文本内容";
    UIImage *imageToShare = [UIImage imageNamed:@"海贼路飞.jpg"];
    NSURL *urlToShare = [NSURL URLWithString:@"http://blog.csdn.net/hitwhylz"];
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToTwitter];
    [self presentViewController:activityVC animated:YES completion:nil];
    
    activityVC.completionWithItemsHandler = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        
    };
    
}

- (void)clickSharePDFAction{
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[[[NSBundle mainBundle] URLForResource:@"Steve" withExtension:@"pdf"]] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToTwitter];
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

- (void)clickLookPDFAction{
    self.openURl = [[NSBundle mainBundle] URLForResource:@"Steve" withExtension:@"pdf"];
    [self.qlpreView reloadData];
    [self presentViewController:self.qlpreView animated:YES completion:nil];
}

- (void)clickSavePDFAction{
    //保存到files中
    NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Steve" withExtension:@"pdf"]];
    [self saveData:data dataName:@"stave.pdf"];
}

- (void)saveData:(NSData *)data dataName:(NSString *)dataName{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dataName]; //Add the file name
    [data writeToFile:filePath atomically:YES];
    [MBProgressHUD showText:@"保存成功"];
}
/*
 DocumentTypes
 https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
 */

- (void)clickLookFilesAction {
    
    NSArray *typesArr = @[@"com.apple.iwork.pages.pages", @"com.apple.iwork.numbers.numbers", @"com.apple.iwork.keynote.key",@"public.image", @"com.apple.application", @"public.item",@"public.data", @"public.content", @"public.audiovisual-content", @"public.movie", @"public.audiovisual-content", @"public.video", @"public.audio", @"public.text", @"public.data", @"public.zip-archive", @"com.pkware.zip-archive", @"public.composite-content", @"public.text"];
    
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:typesArr inMode:UIDocumentPickerModeOpen];
    documentPicker.delegate = self;
    documentPicker.allowsMultipleSelection = YES;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];

}

- (void)lookFileWithDocumentBrowser {
    NSArray *typesArr = @[@"com.apple.iwork.pages.pages", @"com.apple.iwork.numbers.numbers", @"com.apple.iwork.keynote.key",@"public.image", @"com.apple.application", @"public.item",@"public.data", @"public.content", @"public.audiovisual-content", @"public.movie", @"public.audiovisual-content", @"public.video", @"public.audio", @"public.text", @"public.data", @"public.zip-archive", @"com.pkware.zip-archive", @"public.composite-content", @"public.text"];

    UIDocumentBrowserViewController *browserVC = [[UIDocumentBrowserViewController alloc] initForOpeningFilesWithContentTypes:typesArr];
    browserVC.allowsPickingMultipleItems = YES;
    browserVC.delegate = self;
    [self presentViewController:browserVC animated:YES completion:nil];

}

#pragma mark - private

- (void)presentPreview {
    // display PDF contents by Quick Look framework
    [self.documentController presentPreviewAnimated:YES];
}

- (void)presentOpenInMenu {
    // display third-party apps
    [self.documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

- (void)presentOptionsMenu {
    // display third-party apps as well as actions, such as Copy, Print, Save Image, Quick Look
    [_documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELLID"];
    }
    cell.textLabel.text = self.itemArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self clickSharePicAction];
    }else if (indexPath.row == 1) {
        [self clickSharePDFAction];
    }else if (indexPath.row == 2) {
        [self presentPreview];
    }else if (indexPath.row == 3) {
        [self presentOpenInMenu];
    }else if (indexPath.row == 4) {
        [self presentOptionsMenu];
    }else if (indexPath.row == 5) {
        [self clickLookPDFAction];
    }else if (indexPath.row == 6) {
        [self clickSavePDFAction];
    }else if (indexPath.row == 7) {
        [self clickLookFilesAction];
    }else if (indexPath.row == 8){
        [self lookFileWithDocumentBrowser];
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

#pragma mark - QLPreviewControllerDelegate,QLPreviewControllerDataSource

//返回文件的个数
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}
//即将要退出浏览文件时执行此方法
-(void)previewControllerWillDismiss:(QLPreviewController *)controller {
    
}
//文件地址
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return self.openURl;
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    NSLog(@"取消选中");
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSLog(@"选择的内容：%@", urls);
    NSURL *url = urls.firstObject;
    BOOL canAccessingResource = [url startAccessingSecurityScopedResource];
    if(canAccessingResource) {
        
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
            
            UIDocumentInteractionController *documentCon = [UIDocumentInteractionController interactionControllerWithURL:newURL];
            documentCon.delegate = self;
            [documentCon presentPreviewAnimated:YES];

            
//            self.openURl = newURL;
//            [self presentViewController:self.qlpreView animated:YES completion:nil];
//            [self.qlpreView reloadData];

            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-books://file:///private/var/mobile/Library/Mobile%20Documents/com~apple~CloudDocs/%E5%9B%BE%E4%B9%A6/%E8%96%9B%E5%85%86%E4%B8%B0%E7%BB%8F%E6%B5%8E%E5%AD%A6%E8%AE%B2%E4%B9%89.epub"]];
            
            //file:///private/var/mobile/Library/Mobile%20Documents/com~apple~CloudDocs/%E5%9B%BE%E4%B9%A6/%E8%96%9B%E5%85%86%E4%B8%B0%E7%BB%8F%E6%B5%8E%E5%AD%A6%E8%AE%B2%E4%B9%89.epub
            
            //            NSData *fileData = [NSData dataWithContentsOfURL:newURL];
            //            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            //            NSString *documentPath = [arr lastObject];
            //            NSString *desFileName = [documentPath stringByAppendingPathComponent:@"myFile"];
            //            [fileData writeToFile:desFileName atomically:YES];
            //            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        if (error) {
            // error handing
        }
    } else {
        // startAccessingSecurityScopedResource fail
    }
    [url stopAccessingSecurityScopedResource];
    
    
    
    /*
     
     UIDocumentBrowserViewController *browserVC = [[UIDocumentBrowserViewController alloc] initForOpeningFilesWithContentTypes:@[@"public.avi", @"public.mpeg-4", @"public.mp3", @"public.truetype-ttf-font", @"public.png", @"public.jpeg", @"public.rtf", @"public.plain-text"]];
     browserVC.allowsPickingMultipleItems = YES;
     browserVC.delegate = self;
     [self presentViewController:browserVC animated:YES completion:nil];
     */
    
}


#pragma mark - UIDocumentBrowserViewControllerDelegate

/**
 iOS11~iOS12
 */
- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didPickDocumentURLs:(NSArray<NSURL *> *)documentURLs {
    
}

/**
 iOS12
 */
- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)documentURLs {
    NSLog(@"选择的内容：%@", documentURLs);
    NSURL *url = documentURLs.firstObject;
    CYDocument *document = [[CYDocument alloc] initWithFileURL:url];
    [document openWithCompletionHandler:^(BOOL success) {
        
    }];
    
    return;
    BOOL canAccessingResource = [url startAccessingSecurityScopedResource];
    if(canAccessingResource) {
        
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
            self.openURl = newURL;
            [self.qlpreView reloadData];
            [self presentViewController:self.qlpreView animated:YES completion:nil];

        }];
        if (error) {
            // error handing
        }
    } else {
        // startAccessingSecurityScopedResource fail
    }
    [url stopAccessingSecurityScopedResource];
}

#pragma mark - setters && getters

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
    }
    return _myTableView;
}

- (QLPreviewController *)qlpreView {
    if (_qlpreView == nil) {
        _qlpreView = [[QLPreviewController alloc]init];
        _qlpreView.view.frame = self.view.bounds;
        _qlpreView.delegate = self;
        _qlpreView.dataSource = self;
    }
    return _qlpreView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
