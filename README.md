# BMSleep
iOS之线程睡眠以及唤醒特定线程

```objc
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
```

```objc
2019-01-16 10:45:41.300956+0800 BMSleepDemo[15217:591951] main start
2019-01-16 10:45:41.300965+0800 BMSleepDemo[15217:592077] one start
2019-01-16 10:45:41.300979+0800 BMSleepDemo[15217:592079] two start
2019-01-16 10:45:42.301109+0800 BMSleepDemo[15217:592078] (
two,
main,
one
)
2019-01-16 10:45:43.302255+0800 BMSleepDemo[15217:592079] two end
2019-01-16 10:45:45.303452+0800 BMSleepDemo[15217:591951] main end
2019-01-16 10:45:45.303500+0800 BMSleepDemo[15217:592077] one end
```
