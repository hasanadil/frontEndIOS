//
//  PrismaticInterviewQuestionTests.m
//  PrismaticInterviewQuestionTests
//
//  Created by Aria Haghighi on 11/4/12.
//  Copyright (c) 2012 Prismatic. All rights reserved.
//

#import "PrismaticInterviewQuestionTests.h"
#import "Question1.h"
#import "Question2.h"

@implementation PrismaticInterviewQuestionTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testQuestion1 {
    NSLog(@"%s", __FUNCTION__);
    VoidFn randPause = ^{
        [NSThread sleepForTimeInterval: ((double)arc4random() / 0x100000000)];
    };
    
    NSArray* fns = @[
    ^(CallbackFn callback) {
        randPause();
        callback(@"a");
    },
    ^(CallbackFn callback) {
        randPause();
        callback(@"b");
    },
    ^(CallbackFn callback) {
        randPause();
        callback(@"c");
    }
    ];
    
    __block NSArray* res ;
    NSConditionLock * tl = [[NSConditionLock alloc] initWithCondition:0];
    [Question1 asyncMap:fns whenDone:^(NSArray* res0) {
        res = res0;
        NSLog(@"%s res: %@", __FUNCTION__, res);
        [tl unlockWithCondition:1];
    }];
    [tl lockWhenCondition:1];
    NSArray* trg = @[@"a",@"b",@"c"];
    STAssertTrue([res isEqualToArray: trg], @"");
}

// Adds to array fnId when the returned asyncFn is called
// used to observe order of AsyncFn calls
- (AsyncFn) monitoredObserver:(NSMutableArray*)observer withId:(NSString*)fnId {
    return ^(CallbackFn callback) {
        @synchronized(observer) {
          [observer addObject:fnId];
        }
        callback(fnId);
    };
}


- (void)testQuestion2 {
    NSMutableArray* observer = [NSMutableArray new];
    
    AsyncFn f1 =[[self monitoredObserver:observer withId:@"f1"] copy];
    AsyncFn f2 =[[self monitoredObserver:observer withId:@"f2"] copy];
    AsyncFn f3 =[[self monitoredObserver:observer withId:@"f3"] copy];
    AsyncFn f4 =[[self monitoredObserver:observer withId:@"f4"] copy];
    AsyncFn f5 =[[self monitoredObserver:observer withId:@"f5"] copy];
    
    id tree = @[f1, @[f2, f3], f4, f5];
    NSConditionLock * tl = [[NSConditionLock alloc] initWithCondition:0];

    [Question2 asyncTree:tree whenDone:^(id finalId0) {
        [tl unlockWithCondition:1];
    }];
    [tl lockWhenCondition:1];
    BOOL (^happensBefore)(id, id) = ^(id a, id b) {
        // Believe it or not you need to do this to compile
        BOOL resp = [observer indexOfObject:a] < [observer indexOfObject:b];
        return resp;
    };
    // Check each node was hit before its parent
    STAssertTrue(happensBefore(@"f3",@"f2"), @"") ;
    STAssertTrue(happensBefore(@"f4",@"f1"), @"") ;
    STAssertTrue(happensBefore(@"f5",@"f1"), @"") ;
    STAssertTrue(happensBefore(@"f2",@"f1"), @"") ;
}

@end
