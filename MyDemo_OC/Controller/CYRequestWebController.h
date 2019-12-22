//
//  CYRequestWebController.h
//  MyDemo_OC
//
//  Created by zcy on 2019/9/6.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYRequestWebController : CYBaseController
@property (nonatomic, copy) NSString *postUrl;
@property (nonatomic, copy) NSString *postBody;

@end

NS_ASSUME_NONNULL_END
