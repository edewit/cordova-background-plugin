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
#import "BackgroundPlugin.h"

@implementation BackgroundPlugin {
    BOOL fetchOnStartup;
}

@synthesize callback;
@synthesize completionHandler;

- (void)register:(CDVInvokedUrlCommand*)command {
    NSLog(@"register %@", command.callbackId);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];

    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    [result setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:result callbackId:callback];
    self.callback = command.callbackId;

    if (fetchOnStartup) {
        [self backgroundFetch:self.completionHandler userInfo:nil ];
        fetchOnStartup = NO;
    }
}

- (void)setContentAvailable:(CDVInvokedUrlCommand*)command {
    NSLog(@"setContentAvailable");
    NSMutableDictionary *options = [command.arguments objectAtIndex:0];
    NSString *type = [options objectForKey:@"type"];
    self.completionHandler((UIBackgroundFetchResult) [type intValue]);
}

- (void)backgroundFetch:(void (^)(UIBackgroundFetchResult))handler userInfo:(NSDictionary *)userInfo {
    NSLog(@"Background Fetch");

    self.completionHandler = handler;
    if (self.callback) {
        NSDictionary *message = [userInfo objectForKey:@"aps"];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
        [result setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:result callbackId:callback];
    } else {
        fetchOnStartup = YES;
    }
}

@end
