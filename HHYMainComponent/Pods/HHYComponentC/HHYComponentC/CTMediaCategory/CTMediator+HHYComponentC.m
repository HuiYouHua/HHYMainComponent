//
//  CTMediator+HHYComponentC.m
//  HHYComponentC
//
//  Created by 华惠友 on 2018/11/30.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "CTMediator+HHYComponentC.h"

@implementation CTMediator (HHYComponentC)

- (UIViewController *)HHYComponentCWithCallback:(void(^)(NSString *result))callback {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"callback"] = callback;
    return [self performTarget:@"HHYComponentC" action:@"HHYComponentC" params:params shouldCacheTarget:NO];
}

@end
