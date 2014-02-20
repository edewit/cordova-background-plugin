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

@implementation BackgroundPlugin

@synthesize callbackId;
@synthesize completionHandler;

- (void)register:(CDVInvokedUrlCommand*)command {
    self.callbackId = command.callbackId;
}

- (void)setContentAvailable:(CDVInvokedUrlCommand*)command {
    NSLog(@"setContentAvailable");
    NSMutableDictionary *options = [command.arguments objectAtIndex:0];
    NSString *type = [options objectForKey:@"type"];
    self.completionHandler((UIBackgroundFetchResult) [type intValue]);
}

- (void)backgroundFetch:(void (^)(UIBackgroundFetchResult))handler {
    NSLog(@"Background Fetch");

    self.completionHandler = handler;
    if (self.callbackId) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    }
}


@end
