//
//  CYConst.h
//  MyDemo_OC
//
//  Created by zcy on 2019/8/27.
//  Copyright © 2019 CY. All rights reserved.
//


#import "CYNavigationController.h"
#import "CYBaseController.h"
#import "MBProgressHUD+CY.h"
#import "CYHelperTool.h"
#import "NSString+CY.h"
#import "UIButton+CY.h"
#import "UIColor+CY.h"
#import "UIView+CY.h"
#import "NSDate+CY.h"
#import "Masonry.h"



extern NSString *const CYDeviceBangKey;
extern NSString *const CYFaceIDImageKey;

extern CGFloat const kChatBarHeight;
extern CGFloat const kNavBarHeight;
extern CGFloat const kTabBarHeight;
extern CGFloat const kYYkitWidth;

#pragma mark - IM模块常量
// 头像大小
extern CGFloat const HEAD_SIZE;
// 头像到cell的内间距和头像到bubble的间距
extern CGFloat const HEAD_PADDING;
// 头像x
extern CGFloat const HEAD_X;
// Cell之间间距
extern CGFloat const CELLPADDING;
// nameLabel宽度
extern CGFloat const NAME_LABEL_WIDTH;
// nameLabel 高度
extern CGFloat const NAME_LABEL_HEIGHT;
// nameLabel间距
extern CGFloat const NAME_LABEL_PADDING;
// 字体
extern CGFloat const NAME_LABEL_FONT_SIZE;
// bubbleView中，箭头的宽度
extern CGFloat const BUBBLE_ARROW_WIDTH;
// bubbleView 与 在其中的控件内边距
extern CGFloat const BUBBLE_VIEW_PADDING;
// 文字在右侧时,bubble用于拉伸点的X坐标
extern CGFloat const BUBBLE_RIGHT_LEFT_CAP_WIDTH;
// 文字在右侧时,bubble用于拉伸点的Y坐标
extern CGFloat const BUBBLE_RIGHT_TOP_CAP_HEIGHT;
// 文字在左侧时,bubble用于拉伸点的X坐标
extern CGFloat const BUBBLE_LEFT_LEFT_CAP_WIDTH;
// 文字在左侧时,bubble用于拉伸点的Y坐标
extern CGFloat const BUBBLE_LEFT_TOP_CAP_HEIGHT;
// progressView 高度
extern CGFloat const BUBBLE_PROGRESSVIEW_HEIGHT;


#define MainScreenSize [UIScreen mainScreen].bounds.size
#define MainScreenWidth MainScreenSize.width
#define MainScreenHeight MainScreenSize.height
#define IPHONE_X [CYHelperTool isHaveBang]
#define     BORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)

#define CY_WeakSelf __weak __typeof(&*self)weakSelf = self;

/*
 统一背景色
 */
#define DefineBlueColor [UIColor colorWithHex:0x3c7cf2]
//按钮颜色/重要文字显示颜色
#define DefaultRedColor [UIColor colorWithHex:0xF86965]

//可点文字颜色/标签显示颜色
#define DefaultPurpleColor [UIColor colorWithHex:0x924ea9]
//项目进度条/评级下调文字显示颜色
#define DefaultGreenColor [UIColor colorWithHex:0x389b31]
//项目编号及标题显示颜色 待调整为：000000
#define DefaultTextBlackColor [UIColor colorWithHex:0x333333]
//次要文字显示颜色
#define DefaultTextGrayColor [UIColor colorWithHex:0x666666]
//约定年化利率等提示文字显示颜色
#define DefaultHintGrayColor [UIColor colorWithHex:0xaaaaaa]
//辅助线/分界线显示颜色
#define DefaultCalendarGrayColor [UIColor colorWithHex:0xEEEEEE]
//底层背景色
#define DefaultBackgroundColor [UIColor colorWithHex:0xF7F8FA]

//版本号
#define DeviceValue [UIDevice currentDevice].systemVersion.doubleValue

// 自定义log打印
#ifdef DEBUG
#define CYLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif


#define CYUserDefaults [NSUserDefaults  standardUserDefaults]
#define CYNotificationCenter [NSNotificationCenter defaultCenter]


//人脸license授权
#define FACE_LICENSE_NAME    @"idl-license"
#define FACE_LICENSE_SUFFIX  @"face-ios"
#define FACE_LICENSE_ID      @"comdaokouyun-face-ios"

// wkwebview 的 post
#define CYPOST_JS @"function my_post(path, params) {\
var method = \"POST\";\
var form = document.createElement(\"form\");\
form.setAttribute(\"method\", method);\
form.setAttribute(\"action\", path);\
for(var key in params){\
    if (params.hasOwnProperty(key)) {\
        var hiddenFild = document.createElement(\"input\");\
        hiddenFild.setAttribute(\"type\", \"hidden\");\
        hiddenFild.setAttribute(\"name\", key);\
        hiddenFild.setAttribute(\"value\", params[key]);\
    }\
    form.appendChild(hiddenFild);\
}\
document.body.appendChild(form);\
form.submit();\
}"
