//
//  Question3.m
//  PrismaticInterviewQuestion
//
//  Created by Aria Haghighi on 11/6/12.
//  Copyright (c) 2012 Prismatic. All rights reserved.
//

#import "Question2.h"
#import "Question1.h"

@implementation Question2

// check [myBlock isKindOfClass:NSClassFromString(@"NSBlock")]
// if an object is a block or not
// NOTE: it's ok if some of your CallbackFns ignore their arguments
+ (void) asyncTree:(id)tree whenDone:(CallbackFn)whenDone {

    //convert the tree into a list of ordered function
    NSMutableArray* fns = [NSMutableArray array];
    [Question2 parseTree:tree into:fns];
    
    //fns is currently starting with the root, we can reverse the ordered list
    //to satisfy the requirement that child nodes execute first
    
    //use the answer in question1 to run the list of functions
    [Question1 asyncMap:[[fns reverseObjectEnumerator] allObjects] whenDone:whenDone];
}

+(void) parseTree:(id)obj into:(NSMutableArray*)fns
{
    if (!obj) {
        return;
    }
    
    if ([obj isKindOfClass:[NSArray class]]) {
        //cast is for some typing help from the compiler
        NSArray* tree = (NSArray*)obj;
        
        for (int i=0; i < [tree count]; i++) {
            id leaf = [tree objectAtIndex:i];
            
            if ([leaf isKindOfClass:[NSArray class]]) {
                [Question2 parseTree:leaf into:fns];
            }
            else {
                [fns addObject:leaf];
            }
        }
    }
    else {
        [fns addObject:obj];
    }
}

@end
