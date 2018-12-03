//
//  CTMediator+HHYComponentA.m
//  HHYComponentA
//
//  Created by 华惠友 on 2018/11/30.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "CTMediator+HHYComponentA.h"
#import "HHYUser.h"

@implementation CTMediator (HHYComponentA)

- (UIViewController *)HHYComponentA:(HHYUser *)user {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"user"] = user;
    return [self performTarget:@"HHYComponentA" action:@"HHYComponentA" params:params shouldCacheTarget:NO];
}

@end
