//
//  Question3.h
//  PrismaticInterviewQuestion
//
//  Created by Aria Haghighi on 11/6/12.
//  Copyright (c) 2012 Prismatic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question1.h"

@interface Question2 : NSObject

// You will be given a tree, where each node
// has a function associated with it. Each function will be an AsyncFn and
// take a single CallbackFn (see Question1.h) that it will call once it's async operation
// has completed.

// The functions at each node are meant to be executed in a particular order:
// a function can only begin execution after each of its children node's
// function have completed (called the callback function they were executed with).
// The siblings can be 'executing' at the same time.

// A node will be represented as an array where the first element
// is the AsyncFn at that node and the rest of the array are children:

//  @[f1, @[f2, f3], f4, f5]
//  where f1,f2,f3,f4, f5 are instances of AsyncFn

// So in this example f3 must complete before f2 can start and f2,f4, and f5
// must complete before f1 can start

// @param: tree is either an array or a function (tree leaf)
// execute the functions in tree and call onComplete
// when the root function has finished
// HINT: [myBlock isKindOfClass:NSClassFromString(@"NSBlock")]
// will check if an 'id' is a block or not

// NOTE: Some of the CallbackFns you write may ignore their
// single id argument
+ (void) asyncTree:(id)root whenDone:(CallbackFn)whenDone;

@end
