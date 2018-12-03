//
//  HHYComponentAViewController.m
//  HHYComponentA
//
//  Created by 华惠友 on 2018/11/30.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "HHYComponentAViewController.h"

@interface HHYComponentAViewController ()

@end

@implementation HHYComponentAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"name: %@",self.user.name);
    NSLog(@"age: %ld",(long)self.user.age);
}


@end
