//
//  API.h
//  PrismaticInterviewQuestion
//
//  Created by Aria Haghighi on 11/7/12.
//  Copyright (c) 2012 Prismatic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FriendActionsCallback)(NSArray* actions);

@interface API : NSObject

+ (void) listenForFriendActions:(FriendActionsCallback)callback;
+ (void) submitFriendDeletes:(NSArray*)friends;

@end
