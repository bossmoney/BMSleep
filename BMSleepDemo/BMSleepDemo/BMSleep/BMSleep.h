//
//  BMSleep.h
//  test
//
//  Created by BossMoney on 2019/1/14.
//  Copyright © 2019 BossMoney. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMSleep : NSObject

/**
 当前线程一直睡眠，标记name

 @discussion 可以给多个线程标记相同name
 @param name 当前线程标记
 */
+ (void)sleepForName:(NSString *)name;

/**
 当前线程睡眠ti秒，标记name

 @discussion 可以给多个线程标记相同name
 @param name 当前线程标记
 @param ti 休眠秒数
 */
+ (void)sleepForName:(NSString *)name timeInterval:(NSTimeInterval)ti;

/**
 唤醒标记为name的线程

 @discussion 可能唤醒相同name的多个线程
 @param name 线程标记
 */
+ (void)wakeUpForName:(NSString *)name;

/**
 唤醒所有线程
 */
+ (void)wakeUpAll;

/**
 获取所有线程标记名称,线程安全的
 */
@property(class,nonatomic,strong,readonly)NSArray<NSString *> *sleepNames;
@end

NS_ASSUME_NONNULL_END
