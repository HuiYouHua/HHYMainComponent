//
//  CTMediator+HHYComponentC.h
//  HHYComponentC
//
//  Created by 华惠友 on 2018/11/30.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (HHYComponentC)
- (UIViewController *)HHYComponentCWithCallback:(void(^)(NSString *result))callback;
@end

NS_ASSUME_NONNULL_END
