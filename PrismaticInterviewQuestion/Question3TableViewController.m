//
//  Question3ViewController.m
//  PrismaticInterviewQuestion
//
//  Created by Aria Haghighi on 11/7/12.
//  Copyright (c) 2012 Prismatic. All rights reserved.
//

#import "Question3TableViewController.h"
#import "Question1.h"
#import "API.h"

@interface Question3TableViewController ()

@property (strong) NSMutableArray* friends;
@property (strong) NSMutableArray* friendsToDelete;

@end

@implementation Question3TableViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.view.frame = [UIScreen mainScreen].bounds;
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self setFriends:[NSMutableArray array]];
        [self setFriendsToDelete:[NSMutableArray array]];
        
        NSMutableArray* fns = [NSMutableArray array];
        
        // All callbacks happen on background thread
        [API listenForFriendActions:^(NSArray* actionInfos) {
            
            //create array to functions
            for (NSDictionary* actionInfo in actionInfos) {
                
                NSString* action = [actionInfo objectForKey:@"action"];
                NSMutableDictionary* friend = [NSMutableDictionary dictionaryWithDictionary:[actionInfo objectForKey:@"friend"]];
                [friend setObject:@NO forKey:@"touched"];
                [friend setObject:action forKey:@"action"];
                
                if ([action isEqualToString:@"add"]) {
                    
                    AsyncFn fn = ^(CallbackFn callback) {
                        [self.friends addObject:friend];
                        callback([NSString stringWithFormat:@"added %@", [friend objectForKey:@"id"]]);
                    };
                    
                    [fns addObject:fn];
                }
                else if ([action isEqualToString:@"remove"]) {
                    
                    AsyncFn fn = ^(CallbackFn callback) {
                        if ([self isBeingRemoved:friend]) {
                            
                            for (NSDictionary* currentFriend in self.friends) {
                                if ([[currentFriend objectForKey:@"id"] isEqual:[friend objectForKey:@"id"]]) {
                                    [self.friends removeObject:currentFriend];
                                    [self.friendsToDelete addObject:currentFriend];
                                    break;
                                }
                            }
                            
                            callback([NSString stringWithFormat:@"removed %@", [friend objectForKey:@"id"]]);
                        }
                        else {
                            callback([NSString stringWithFormat:@"not removed %@", [friend objectForKey:@"id"]]);
                        }
                    };
                    
                    [fns addObject:fn];
                }
            }
            
            [Question1 asyncMap:fns whenDone:^(NSArray* res0) {
                [fns removeAllObjects];
                [Question1 onMainThread:^{
                    [[self tableView] reloadData];
                }];
            }];
        }];

    }
    return self;
}

#pragma Table Data Source

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
    }
    
    NSDictionary* friend = [self.friends objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[friend objectForKey:@"name"]];
    
    [[cell textLabel] setTextColor:[UIColor blackColor]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    if ([self isTouched:friend]) {
        if ([self isBeingRemoved:friend]) {
            [[cell textLabel] setTextColor:[UIColor redColor]];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    
    return cell;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionNum {
    return [self.friends count];
}

#pragma Table Delegate

// Table Cell Touch
- (void)  tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary* friend = [self.friends objectAtIndex:indexPath.row];
    if ([self isTouched:friend]) {
        if ([self isBeingRemoved:friend]) {
            [friend setObject:@"" forKey:@"action"];
        }
    }
    else {
        [friend setObject:@YES forKey:@"touched"];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(BOOL) isTouched:(NSDictionary*)friend
{
    return [[friend objectForKey:@"touched"] boolValue];
}

-(BOOL) isBeingRemoved:(NSDictionary*)friend
{
    return [[friend objectForKey:@"action"] isEqualToString:@"remove"];
}

#pragma Shake Gesture

- (void) onShake {
    [API submitFriendDeletes:[self.friendsToDelete copy]];
    [self.friendsToDelete removeAllObjects];
}

@end













