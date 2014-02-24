/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
*/
#import "AppDelegate+fetch.h"
#import "BackgroundPlugin.h"
#import <objc/runtime.h>

@implementation AppDelegate (fetch)

- (id)getCommandInstance:(NSString *)className {
    return [self.viewController getCommandInstance:className];
}

// its dangerous to override a method from within a category.
// Instead we will use method swizzling. we set this up in the load call.
+ (void)load {
    Method original, swizzled;

    original = class_getInstanceMethod(self, @selector(init));
    swizzled = class_getInstanceMethod(self, @selector(swizzled_init));
    method_exchangeImplementations(original, swizzled);
}

- (AppDelegate *)swizzled_init {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerBackgroundFetch:)
                                                 name:@"UIApplicationDidFinishLaunchingNotification" object:nil];

    // This actually calls the original init method over in AppDelegate. Equivalent to calling super
    // on an overrided method, this is not recursive, although it appears that way. neat huh?
    return [self swizzled_init];
}

// This code will be called immediately after application:didFinishLaunchingWithOptions:.
- (void)registerBackgroundFetch:(NSNotification *)notification {
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
}

- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    BackgroundPlugin *plugin = [self getCommandInstance:@"BackgroundFetch"];
    [plugin performSelectorOnMainThread:@selector(backgroundFetch:userInfo:) withObject:completionHandler waitUntilDone:YES];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    if ([userInfo valueForKeyPath:@"aps.content-available"]) {
        BackgroundPlugin *plugin = [self getCommandInstance:@"BackgroundFetch"];
        [plugin backgroundFetch:completionHandler userInfo:userInfo];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"device token %@", token);
}


@end
