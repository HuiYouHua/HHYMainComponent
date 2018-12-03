//
//  Target_HHYComponentC.m
//  HHYComponentC
//
//  Created by 华惠友 on 2018/11/30.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "Target_HHYComponentC.h"
#import "HHYComponentCViewController.h"

@interface Target_HHYComponentC ()

typedef void (^CallbackBlock)(NSString *result);

@end

@implementation Target_HHYComponentC

- (UIViewController *)Action_HHYComponentC:(NSDictionary *)params {
    HHYComponentCViewController *VC = [[HHYComponentCViewController alloc] init];
    CallbackBlock callbackBlock = params[@"callback"];
    if (callbackBlock) {
        callbackBlock(@"回传的参数");
    }
    return VC;
}
@end
