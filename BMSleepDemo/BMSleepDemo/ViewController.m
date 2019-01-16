//
//  ViewController.m
//  BMSleepDemo
//
//  Created by BossMoney on 2019/1/15.
//  Copyright © 2019 BossMoney. All rights reserved.
//

#import "ViewController.h"
#import "BMSleep.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
    
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)test1{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"one start");
        [BMSleep sleepForName:@"one"];
        NSLog(@"one end");
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"two start");
        [BMSleep sleepForName:@"two"];
        NSLog(@"two end");
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@",BMSleep.sleepNames);
    });
    NSLog(@"main start");
    [BMSleep sleepForName:@"main" timeInterval:2];
    [BMSleep wakeUpForName:@"two"];
    [BMSleep sleepForName:@"main" timeInterval:2];
    [BMSleep wakeUpForName:@"one"];
    NSLog(@"main end");
}

@end
