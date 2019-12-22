//
//  UIDevice+FCUUID.m
//
//  Created by Fabio Caccamo on 19/11/15.
//  Copyright © 2015 Fabio Caccamo. All rights reserved.
//

#import "UIDevice+JKUUID.h"

@implementation UIDevice (JKUUID)

-(NSString *)uuid
{
    return [JKUUID uuidForDevice];
}

@end
