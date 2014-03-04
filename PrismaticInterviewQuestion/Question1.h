//
//  Question1.h
//  PrismaticInterviewQuestion
//
//  Created by Aria Haghighi on 11/4/12.
//  Copyright (c) 2012 Prismatic. All rights reserved.
//

#import <Foundation/Foundation.h>

// Fill in the implementation of asyncMap:whenDone:
// NOTE: There is a simple test in PrismaticInterviewQuestionTests.m

// A block which takes no args
typedef void (^VoidFn)(void);

// A block which takes a single object argument
// usually the data the caller has been waiting for
typedef void (^CallbackFn)(id);

// A function which only takes a CallbackFn
// the argument given to the CallbackFn
// is usually the data made by the AsyncFn
typedef void (^AsyncFn)(CallbackFn);


@interface Question1 : NSObject

// GIVEN: execute block on background thread
+ (void) onBackgroundThread:(VoidFn)callback;

// GIVEN: execute block on main (UI) thread
+ (void) onMainThread:(VoidFn)callback;


// fns: array of AsyncFn
// Execute all of the AsyncFn in fns (on background thread) and once all of them
// have completed, then call whenDone where the argument
// is an array of the data in each of the AsyncFns callbacks
// (see the Unit Test for an example)
+ (void) asyncMap:(NSArray*)fns whenDone:(CallbackFn)whenDone;


@end
