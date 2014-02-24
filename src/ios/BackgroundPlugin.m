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
    NSLog(@"register");
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];

    NSMutableDictionary *options = [command.arguments objectAtIndex:0];
    self.callback = [options objectForKey:@"callback"];
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
        NSString *jsCallBack = [NSString stringWithFormat:@"%@(%@);", self.callback, [self toJson:userInfo]];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
    } else {
        fetchOnStartup = YES;
    }
}

- (NSMutableString *)toJson:(NSDictionary *)userInfo {
    NSMutableString *jsonStr = [NSMutableString stringWithString:@"{"];
    if (userInfo) {
        [self parseDictionary:userInfo intoJSON:jsonStr];
    }

    [jsonStr appendString:@"}"];
    return jsonStr;
}

- (void)parseDictionary:(NSDictionary *)inDictionary intoJSON:(NSMutableString *)jsonString {
    NSArray *keys = [inDictionary allKeys];
    NSString *key;

    for (key in keys) {
        id thisObject = [inDictionary objectForKey:key];

        if ([thisObject isKindOfClass:[NSDictionary class]])
            [self parseDictionary:thisObject intoJSON:jsonString];
        else
            [jsonString appendFormat:@"'%@':'%@',", key, [inDictionary objectForKey:key]];
    }
}

@end
