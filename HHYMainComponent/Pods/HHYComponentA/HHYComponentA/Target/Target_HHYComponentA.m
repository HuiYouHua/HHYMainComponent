//
//  Target_HHYComponentA.m
//  HHYComponentA
//
//  Created by 华惠友 on 2018/11/30.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "Target_HHYComponentA.h"
#import "HHYComponentAViewController.h"

#import "HHYUser.h"

@implementation Target_HHYComponentA

- (UIViewController *)Action_HHYComponentA:(NSDictionary *)params {
    HHYComponentAViewController *VC = [[HHYComponentAViewController alloc] init];
    VC.user = params[@"user"];
    return VC;
}

@end
