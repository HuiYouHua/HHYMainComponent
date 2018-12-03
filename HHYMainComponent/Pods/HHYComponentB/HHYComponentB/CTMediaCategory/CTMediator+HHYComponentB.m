//
//  CTMediator+HHYComponentB.m
//  HHYComponentB
//
//  Created by 华惠友 on 2018/11/30.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "CTMediator+HHYComponentB.h"

@implementation CTMediator (HHYComponentB)

- (UIViewController *)HHYComponentB:(NSArray *)dataArray WithCallback:(void(^)(NSArray *dataArray))callback {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"dataArray"] = dataArray;
    params[@"callback"] = callback;
    return [self performTarget:@"HHYComponentB" action:@"HHYComponentB" params:params shouldCacheTarget:NO];
}

@end
