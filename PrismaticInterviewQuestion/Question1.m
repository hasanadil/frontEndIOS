//
//  Question1.m
//  PrismaticInterviewQuestion
//
//  Created by Aria Haghighi on 11/4/12.
//  Copyright (c) 2012 Prismatic. All rights reserved.
//

#import "Question1.h"

@implementation Question1

+ (void) onBackgroundThread:(VoidFn)callback {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.0 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   callback);
}

+ (void) onMainThread:(VoidFn)callback {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   callback);
}

+ (void) asyncMap:(NSArray*)fns whenDone:(CallbackFn)whenDone {
    
    NSMutableArray* fnResults = [NSMutableArray array];
    void (^CallbackFn)(id) = ^(id fnResult) {
        [fnResults addObject:fnResult];
    };
    
    if ([fns count] > 0) {
        [Question1 runFnFromList:fns at:0 usingCallback:CallbackFn];
    }
    
    whenDone(fnResults);
}

+(void) runFnFromList:(NSArray*)fns at:(NSInteger)index usingCallback:(CallbackFn)callback
{
    if (index < [fns count]) {
        void (^ asyncFn)(CallbackFn) = [fns objectAtIndex:index];
        
        void (^Completion)(id) = ^(id result) {
            callback(result);
            [Question1 runFnFromList:fns at:index+1 usingCallback:callback];
        };
        
        asyncFn(Completion);
    }
}

@end






































