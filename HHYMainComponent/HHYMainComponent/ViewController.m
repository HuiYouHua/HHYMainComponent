//
//  ViewController.m
//  HHYMainComponent
//
//  Created by 华惠友 on 2018/11/30.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "ViewController.h"
#import <HHYComponentA/HHYComponentA.h>

#import <HHYComponentB/CTMediator+HHYComponentB.h>

#import <HHYComponentC/CTMediator+HHYComponentC.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)componentA:(id)sender {
    HHYUser *user = [HHYUser new];
    user.name = @"huayoyu";
    user.age = 18;
    UIViewController *vc = [[CTMediator sharedInstance] HHYComponentA:user];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)componentB:(id)sender {
    NSArray *array = @[@"1", @"2", @"3", @"4"];
    UIViewController *vc = [[CTMediator sharedInstance] HHYComponentB:array WithCallback:^(NSArray * _Nonnull dataArray) {
        NSLog(@"%@",dataArray);
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)componentC:(id)sender {
    UIViewController *vc = [[CTMediator sharedInstance] HHYComponentCWithCallback:^(NSString * _Nonnull result) {
        NSLog(@"%@", result);
    }];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
