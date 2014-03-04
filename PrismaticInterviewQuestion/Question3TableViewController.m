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
@property (strong) NSMutableArray* fns;

@end

@implementation Question3TableViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.view.frame = [UIScreen mainScreen].bounds;
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self setFriends:[NSMutableArray array]];
        [self setFns:[NSMutableArray array]];
        
        // All callbacks happen on background thread
        [API listenForFriendActions:^(NSArray* actionInfos) {
            //NSLog(@"actionInfos %@", actionInfos);
            
            CallbackFn callback = ^(id obj) {
                NSLog(@"%@", obj);
            };
            
            //create array to functions
            for (NSDictionary* actionInfo in actionInfos) {
                
                NSString* action = [actionInfo objectForKey:@"action"];
                NSDictionary* friend = [actionInfo objectForKey:@"friend"];
                
                if ([action isEqualToString:@"add"]) {
                    NSLog(@"adding %@", [friend objectForKey:@"id"]);
                    
                    AsyncFn fn = ^(CallbackFn callback) {
                        [self.friends addObject:friend];
                        callback([NSString stringWithFormat:@"added %@", [friend objectForKey:@"id"]]);
                    };
                    
                    [self.fns addObject:fn];
                }
                else if ([action isEqualToString:@"remove"]) {
                    NSLog(@"removing %@", [friend objectForKey:@"id"]);
                    
                    AsyncFn fn = ^(CallbackFn callback) {
                        [self.friends removeObject:friend];
                        callback([NSString stringWithFormat:@"removed %@", [friend objectForKey:@"id"]]);
                    };
                    
                    [self.fns addObject:fn];
                }
            }
            NSLog(@"fns count %d", [self.fns count]);
            NSLog(@"");
            
            [Question1 asyncMap:self.fns whenDone:^(NSArray* res0) {
                //NSLog(@"%@", self.friends);
                [self.fns removeAllObjects];
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
    
    [[cell textLabel] setText:[[self.friends objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    return cell;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionNum {
    return [self.friends count];
}

#pragma Table Delegate

// Table Cell Touch
- (void)  tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
}

#pragma Shake Gesture

- (void) onShake {
    // YOUR CODE HERE
}

@end













