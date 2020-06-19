//
//  CYSnapshotDetailController.h
//  MyDemo_OC
//
//  Created by zcy on 2020/6/16.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYBaseController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SnapshotDetail_collection,
    SnapshotDetail_tableView,
    SnapshotDetail_webview,
} CYSnapshotDetailStyle;

@interface CYSnapshotDetailController : CYBaseController
@property (nonatomic) CYSnapshotDetailStyle detailStyle;
@end

NS_ASSUME_NONNULL_END
