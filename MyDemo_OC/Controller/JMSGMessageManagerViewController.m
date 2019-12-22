//
//  JMSGMessageManagerViewController.m
//  JMessageDemo
//
//  Created by HXHG on 16/8/4.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGMessageManagerViewController.h"
#import <JMessage/JMessage.h>
#import "JMSGTools.h"

@interface JMSGMessageManagerViewController () <JMessageDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    UIImagePickerController *_imagePickerController;
    UIImage *selectImage;
    
    JMSGMessage *lastSendMessage;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *gid;
@property (weak, nonatomic) IBOutlet UITextField *at_userName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation JMSGMessageManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"消息管理";
    [self addGesture];
    [JMessage addDelegate:self withConversation:nil];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - single
- (IBAction)sendMessage:(id)sender {
    JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:@"this is text content"];
    JMSGMessage *message = [JMSGMessage createSingleMessageWithContent:textContent username:self.userName.text];
    [JMSGMessage sendMessage:message];
}

- (IBAction)sendSingleTextMessage:(id)sender {
    [JMSGMessage sendSingleTextMessage:@"this is sendSingleTextMessage content" toUser:self.userName.text];
}

- (IBAction)sendSingleImageMessage:(id)sender {
    [[JMSGTools shareTools] getImageWithComplete:^(NSData *imageData, NSString *format, NSError *error) {
        if (imageData) {
            [JMSGMessage sendSingleImageMessage:imageData toUser:self.userName.text];
        }
    }];
    
}

- (IBAction)sendSingleVoiceMessage:(id)sender {
    [JMSGMessage sendSingleVoiceMessage:[JMSGTools getTestVoiceDate] voiceDuration:@(20) toUser:self.userName.text];
}

- (IBAction)sendSingleFileMessage:(id)sender {
    [JMSGMessage sendSingleFileMessage:[JMSGTools getTestFileDate] fileName:@"zipFile.zip" toUser:self.userName.text];
}

- (IBAction)sendSingleLocationMessage:(id)sender {
    [JMSGMessage sendSingleLocationMessage:@(132) longitude:@(43) scale:@(1) address:@"your site" toUser:self.userName.text];
}

- (IBAction)retractMessageAction:(UIButton *)sender {
    [JMSGMessage retractMessage:lastSendMessage completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"消息撤回成功");
            [JMSGTools showResponseResultWithInfo:@"消息撤回成功" error:nil];
        }else{
            NSLog(@"消息撤回失败，error：%@",error);
            [JMSGTools showResponseResultWithInfo:@"消息撤回失败" error:error];
        }
    }];
    
}
- (IBAction)sendOptionMessageAction:(id)sender {
    
    [JMSGTools showResponseResultWithInfo:@"请查看 ViewController 里的具体实现代码" error:nil];
    
    // 具体实现如下
    /*
     
     JMSGTextContent *content = [[JMSGTextContent alloc] initWithText:@"123"];
     JMSGMessage *message =[JMSGMessage createSingleMessageWithContent:content username:self.userName.text];
     
     // 下面的配置选项，开发者请查看具体 API 文档，查看每个属性的作用
     JMSGCustomNotification *custion = [[JMSGCustomNotification alloc] init];
     custion.enabled = YES;
     custion.title =@"title";
     custion.alert = @"fromname:alter";
     
     JMSGOptionalContent *option = [[JMSGOptionalContent alloc] init];
     option.noSaveOffline = ;
     option.noSaveNotification = ;
     option.needReadReceipt = ;//设置这条消息的发送是否需要对方发送已读回执，NO，默认值
     option.customNotification = custion;
     
     [JMSGMessage sendMessage:message optionalContent:option];
     
     */
    
}
- (IBAction)sendVideoMessage:(id)sender {
    
    [[JMSGTools shareTools] shootVideoWithComplete:^(NSData *videoData, NSData *thumbData, NSNumber *duration, NSString *format, NSError *error) {
        if (!error) {
            [MBProgressHUD showMessage:@"发送中····" toView:self.view];
            
            JMSGVideoContent *videoContent = [[JMSGVideoContent alloc] initWithVideoData:videoData thumbData:thumbData duration:duration];
            videoContent.format = format;//最好设置后缀，系统方法无法播放无后缀的文件
            videoContent.fileName = @"videoname";

            JMSGMessage *message = [JMSGMessage createSingleMessageWithContent:videoContent username:self.userName.text];
            [JMSGMessage sendMessage:message];
        }
    }];
}


#pragma mark - group
- (IBAction)sendGroupMessage:(id)sender {
    JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:@"this is text content"];
    if ([self isHaveAtUser]) {
        [JMSGUser userInfoArrayWithUsernameArray:@[self.at_userName.text] completionHandler:^(id resultObject, NSError *error) {
            NSArray *users = (NSArray *)resultObject;
            if (users.count > 0) {
                JMSGMessage *message = [JMSGMessage createGroupMessageWithContent:textContent groupId:self.gid.text at_list:@[users.firstObject]];
                [JMSGMessage sendMessage:message];
            } else {
                NSLog(@"@用户不存在");
            }
        }];
        
    } else {
        JMSGMessage *message = [JMSGMessage createGroupMessageWithContent:textContent groupId:self.gid.text];
        [JMSGMessage sendMessage:message];
    }
    
}

- (IBAction)sendGroupTextMessage:(id)sender {
    [JMSGMessage sendGroupTextMessage:@"this is sendGroupTextMessage content" toGroup:self.gid.text];
}

- (IBAction)sendGroupImageMessage:(id)sender {
    [[JMSGTools shareTools] getImageWithComplete:^(NSData *imageData, NSString *format, NSError *error) {
        if (imageData) {
            [JMSGMessage sendGroupImageMessage:imageData toGroup:self.gid.text];
        }
    }];
    
}

- (IBAction)sendGroupVoiceMessage:(id)sender {
    [JMSGMessage sendGroupVoiceMessage:[JMSGTools getTestVoiceDate] voiceDuration:@(20) toGroup:self.gid.text];
}

- (IBAction)sendGroupFileMessage:(id)sender {
    [JMSGMessage sendGroupFileMessage:[JMSGTools getTestFileDate] fileName:@"zipFile.zip" toGroup:self.gid.text];
}

- (IBAction)sendGroupLocationMessage:(id)sender {
    [JMSGMessage sendGroupLocationMessage:@(132) longitude:@(43) scale:@(1) address:@"your site" toGroup:self.gid.text];
}
- (IBAction)sendNeedReceipMessage:(id)sender {
    [JMSGTools showResponseResultWithInfo:@"请查看 ViewController 里的具体实现代码" error:nil];
    
    // 具体实现如下
    /*
     
     JMSGTextContent *content = [[JMSGTextContent alloc] initWithText:@"123"];
     JMSGMessage *message =[JMSGMessage createSingleMessageWithContent:content username:self.userName.text];
     
     JMSGOptionalContent *option = [[JMSGOptionalContent alloc] init];
     option.needReadReceipt = YES;//设置这条消息的发送是否需要对方发送已读回执，NO，默认值
     
     [JMSGMessage sendMessage:message optionalContent:option];
     */
}
- (IBAction)checkMessageReceipStatus:(id)sender {
    [JMSGTools showMessage:@"请查看 ViewController 里的具体实现代码"];
    // 发送方
    //message 为发送出去的消息
    //NSLog(@"消息是否已读:%@",message.isHaveRead?@"是":@"否");
}
- (IBAction)messageReceiptDetail:(id)sender {
    [JMSGTools showMessage:@"请查看 ViewController 里的具体实现代码"];
    
    // 发送方
    //message 为发送出去的消息
    /*
    if (message.isReceived) {
        NSLog(@"只有你发送的消息才有未读数列表，这是你收到的消息");
    }else{
        [message messageReadDetailHandler:^(NSArray * _Nullable readUsers, NSArray * _Nullable unreadUsers, NSError * _Nullable error) {
            NSLog(@"\n 已读列表：%@，\n 未读列表：%@",readUsers,unreadUsers);
        }];
    }
     */
}
- (IBAction)setMessageReceipt:(id)sender {
    [JMSGTools showMessage:@"请查看 ViewController 里的具体实现代码"];
    // 接收方
    //message 为接收的消息
    /*
     if (message.isReceived) {
         [message setMessageHaveRead:^(id resultObject, NSError *error) {
             NSLog(@"发送已读回执:%@",error?@"失败":@"成功");
         }];
     } else{
         NSLog(@"这是你自己发的消息，不需要设置已读回执。");
     }
     */
    
}


#pragma mark 添加手势识别器
- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tap];
}

#pragma mark 点击的方法
- (void)tapClick:(id)sender {
    [self.scrollView endEditing:YES];
}

#pragma mark - JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error {
    NSLog(@"Event - sendMessageResponse");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (!error) {
        lastSendMessage = message;
    }
    [JMSGTools showResponseResultWithInfo:[NSString stringWithFormat:@"send message:%@", message] error:error];
}

- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    [JMSGTools showResponseResultWithInfo:[NSString stringWithFormat:@"receive message: %@",  message] error:error];
}

- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message {
    NSLog(@"onReceiveMessageDownloadFailed: %@", message);
}

- (BOOL)isHaveAtUser {
    if (!self.at_userName.text || [self.at_userName.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

@end
