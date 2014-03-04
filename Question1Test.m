//
//  Question1Test.m
//  PrismaticInterviewQuestion
//
//  Created by Aria Haghighi on 11/6/12.
//  Copyright (c) 2012 Prismatic. All rights reserved.
//

#import "Question1Test.h"
#import "Question1.h"

@implementation Question1Test

- (void)testQuestion1 {
    NSArray* fns = @[
        ^(CallbackFn callback) {
           callback(@"a");
        },
        ^(CallbackFn callback) {
            callback(@"b");
        },
        ^(CallbackFn callback) {
            callback(@"b");
        }
    ];
    
    
    [Question1 asyncMap:fns whenDone:^(NSArray* res) {
        NSArray* trg = @[@"a",@"b",@"c"];
        NSLog("@HEY!");
        STAssertTrue([res isEqualToArray: trg], @"") ;
    }];
    
	
}

@end
