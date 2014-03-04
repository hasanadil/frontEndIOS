//
//  API.m
//  PrismaticInterviewQuestion
//
//  Created by Aria Haghighi on 11/7/12.
//  Copyright (c) 2012 Prismatic. All rights reserved.
//

#import "API.h"
#import "Question1.h"

@implementation API

static NSMutableArray* _friends;
static NSMutableSet* _addedIds;

+ (void) initialize {
    // Mock data
    _friends = [NSMutableArray new];
    _addedIds = [NSMutableSet new];
    for (int idx=0; idx < 25; ++idx) {
        [_friends addObject:
            @{@"id": [NSNumber numberWithInt:idx],
             @"name": [NSString stringWithFormat:@"Friend(%d)",idx],
             @"strength":[NSNumber numberWithDouble:(idx/25.0)] }];
    }
}

// always called on background thread
+ (void) listenForFriendActions:(FriendActionsCallback)callback {
    [Question1 onBackgroundThread:^{
        while (true) {
           [NSThread sleepForTimeInterval:3.0];
            NSMutableArray* actions = [NSMutableArray new];
            int n = 1 + (arc4random()%3);
            for (int i=0; i < n; ++i) {
                int randIdx = arc4random() % _friends.count;
                NSDictionary* f = _friends[randIdx];
                NSString* act = [_addedIds containsObject:f[@"id"]] ? @"remove" : @"add";
                [actions addObject:@{@"action":act, @"friend":f}];
                if ([act isEqualToString:@"add"]) [_addedIds addObject:f[@"id"]];
                else [_addedIds removeObject:f[@"id"]];
            }
            callback(actions);        
        }
    }];

}

+ (void) submitFriendDeletes:(NSArray*)friends {
    // no-op
}

@end
