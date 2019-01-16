# bmsleep
iOS之睡眠以及唤醒特定线程

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
