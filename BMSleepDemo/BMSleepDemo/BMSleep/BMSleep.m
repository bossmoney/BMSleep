//
//  BMSleep.m
//  test
//
//  Created by BossMoney on 2019/1/14.
//  Copyright © 2019 BossMoney. All rights reserved.
//

#import "BMSleep.h"

@interface BMSleep ()
@property(nonatomic,strong)NSMutableDictionary *threadDic;
@property(nonatomic,strong)dispatch_semaphore_t semaphore;
@end

@implementation BMSleep

+ (instancetype)sharedManager{
    static BMSleep *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super new];
        manager.threadDic = NSMutableDictionary.new;
        manager.semaphore = dispatch_semaphore_create(1);
    });
    return manager;
}

+ (void)sleepForName:(NSString *)name{
    [BMSleep sleepForName:name timeInterval:-1];
}

+ (void)sleepForName:(NSString *)name timeInterval:(NSTimeInterval)ti{
    BMSleep *manager = BMSleep.sharedManager;
    NSCondition *cond = NSCondition.new;
    dispatch_semaphore_wait(manager.semaphore, DISPATCH_TIME_FOREVER);
    if ([manager.threadDic objectForKey:name] == nil) {
        [manager.threadDic setObject:@[cond].mutableCopy forKey:name];
    }else{
        NSMutableArray *condArr = [manager.threadDic objectForKey:name];
        [condArr addObject:cond];
    }
    dispatch_semaphore_signal(manager.semaphore);
    [cond lock];
    if (![cond.name isEqualToString:@"signaled"]) {
        if (ti<0) {
            [cond wait];
        }else{
            [cond waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:ti]];
        }
    }
    [cond unlock];
    
    [BMSleep wakeUpForName:name];
}

+ (void)wakeUpForName:(NSString *)name{
    BMSleep *manager = BMSleep.sharedManager;
    dispatch_semaphore_wait(manager.semaphore, DISPATCH_TIME_FOREVER);
    NSMutableArray *condArr = [manager.threadDic objectForKey:name];
    if (condArr) {
        for (NSCondition *cond in condArr) {
            [cond lock];
            [cond signal];
            cond.name = @"signaled";
            [cond unlock];
        }
    }
    [manager.threadDic removeObjectForKey:name];
    dispatch_semaphore_signal(manager.semaphore);
}

+ (void)wakeUpAll{
    BMSleep *manager = BMSleep.sharedManager;
    dispatch_semaphore_wait(manager.semaphore, DISPATCH_TIME_FOREVER);
    for (NSString *name in BMSleep.sleepNames) {
        [BMSleep wakeUpForName:name];
    }
    dispatch_semaphore_signal(manager.semaphore);
}

+ (NSArray<NSString *> *)sleepNames{
    BMSleep *manager = BMSleep.sharedManager;
    dispatch_semaphore_wait(manager.semaphore, DISPATCH_TIME_FOREVER);
    NSArray *result = manager.threadDic.allKeys;
    dispatch_semaphore_signal(manager.semaphore);
    return result;
}

@end
