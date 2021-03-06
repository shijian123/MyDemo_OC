//
//  ViewController.m
//  MyDome_OC
//
//  Created by zcy on 2019/6/4.
//  Copyright © 2019 CY. All rights reserved.
//

#import "ViewController.h"
#import "DMHeartFlyView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <mach/mach.h>

typedef enum : NSUInteger {
    // 按位或操作符
    MyEnumValueNone = 0,
    MyEnumValueA    = 1<<0,
    MyEnumValueB    = 1<<1,
    MyEnumValueC    = 1<<2,
    
    //
//    MyEnumValueA    = 1,
//    MyEnumValueB    = 2,
//    MyEnumValueC    = 3,
} MyEnum;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableV;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *controllerArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"导航";
    [self.view addSubview:self.myTableV];
    
    //禁止系统进入休眠，保持屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    DMHeartFlyView *view = [[DMHeartFlyView alloc] initWithFrame:CGRectMake(100, 200, 200, 200) ];
    [view animateInView:self.view];
    [self.view addSubview:view];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    
//    [self addEnum: MyEnumValueC | MyEnumValueA];
}

- (void)addEnum:(MyEnum)enum1 {
    //MyEnumValueA | MyEnumValueC
}
/// InjectionIII 动态修改代码
-(void)injected{
//    NSLog(@"I've been reinjected: %@", self);
//    NSLog(@"这里调用修改页面布局 或者属性设置的代码");
    
    self.myTableV.backgroundColor = [UIColor orangeColor];
    
}

///  内存警告⚠️
- (void)didReceiveMemoryWarning {
    // 当前任务信息
    struct mach_task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kernReturn = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &size);
    if (kernReturn != KERN_SUCCESS) {
        return;
    }
    
    float used_mem = info.resident_size;
    NSLog(@"used %f MB", used_mem/1024.0f/1024.0f);
}

#pragma mark - delegate
#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLID"];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    UIViewController *vc;
    NSMutableString *vcStr = [NSMutableString stringWithString:self.controllerArr[indexPath.row]];
    /*
     当我们用 initWithNibName 初始化控制器对象，需要传一个nibName参数
     1、如果指定了xib的名称，那么就去加载这个指定的xib
     2、如果传入nil
     2.1 首先会判断有没有和控制器相同名称的xib文件，如果有就去加载和控制器相同名称的xib
     2.2 如果没有和控制器相同名称的xib文件，就去加载控制器名称去掉Controller的xib文件（控制器名称：RootViewController xib名称：RootView）
     */
//    if ([vcStr containsString:@"_xib"]) {//controller是否为XIB
//        [vcStr deleteCharactersInRange:NSMakeRange(vcStr.length-4, 4)];
//        vc = [[NSClassFromString(vcStr) alloc] initWithNibName:vcStr bundle:nil];
//    }else {
//        vc = [[NSClassFromString(vcStr) alloc] init];
//    }
    vc = [[NSClassFromString(vcStr) alloc] init];

    vc.title = self.titleArr[indexPath.row];
//    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self presentViewController:vc animated:YES completion:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setters && getters

- (UITableView *)myTableV {
    if (_myTableV == nil) {
        _myTableV = [[UITableView alloc] initWithFrame:self.view.bounds];
        _myTableV.delegate = self;
        _myTableV.dataSource = self;
        _myTableV.backgroundColor = [UIColor whiteColor];
    }
    return _myTableV;
}

- (NSArray *)titleArr {
    NSArray *arr = @[@"inAppPurchase", @"PHPicker", @"DynamicLaunchImage", @"PicInPic", @"CYEncode", @"FileAPP", @"Snapshot", @"AnimateReset", @"LifeCycle_V&C_xib", @"wkwebview-post",@"PresentVC", @"PropertyRuntime", @"ScrollBGImg", @"LottieAnim", @"SystemShare", @"FaceBeauty", @"CameraMovie", @"FaceLicense", @"ChatVC", @"BlockTest", @"JMSGMessageManager", @"WXPay", @"ImageWebView", @"UpLoad", @"FloatView", @"MyCalendar", @"CYSelectItem", @"AssignRound", @"Excel-Kit", @"playAudio", @"CYStackViewTest", @"CYAutoTest", @"drawHeart", @"customPageControl", @"Localization", @"FireAnim", @"RippleEffect", @"CircleLoad", @"QQVoiceDemo", @"CYRunLoop", ];
    return arr;
}

/**
 使用这个方法后，不仅调用方便，而且可以不用import各个Controller
 */
- (NSArray *)controllerArr {
    NSArray *arr = @[@"CYInAppPurchaseController", @"CYPHPickerController", @"CYDynamicLaunchController", @"CYPicInPicController", @"CYEncodeController", @"CYFileAPPController", @"CYSnapshotController", @"CYAnimateResetController", @"CYLifeCycleController", @"CYRequestWebController",@"CYPresentController", @"CYPropertyRuntimeController", @"CYScrollBGImgController", @"CYLottieAnimationController", @"CYSystemShareController", @"CYFaceBeautyController", @"CYCameraMovieController", @"CYFaceLicenseController", @"LHChatVC", @"CYBlockTestController", @"JMSGMessageManagerViewController", @"CYWXPayController", @"CYImageWebController", @"CYUploadContentController", @"CYFloatController", @"CYMyCalendarController", @"CYSelectItemController", @"CYRoundController", @"CYExcelController", @"CYPlayAudioController", @"CYStackTestController", @"CYAutoTestController", @"CYDrawHeartController", @"CYCustomPageControlController", @"CYLocalizationController", @"CYFireAnimController", @"CYRippleAnimController", @"CYCircleLoadController", @"QQVoiceDemoController", @"CYRunLoopController"];
    return arr;
}

@end
