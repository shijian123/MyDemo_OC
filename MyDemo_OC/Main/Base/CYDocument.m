//
//  CYDocument.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/18.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYDocument.h"

@implementation CYDocument
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    
    self.data = contents;
    
    return YES;
}
@end
