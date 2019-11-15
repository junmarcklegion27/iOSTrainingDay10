//
//  AppSettings.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/12/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppSettings.h"

@implementation AppSettings

- (NSString *)getUsername {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _username = [defaults objectForKey:@"username"];
    return _username;
}

- (void)setUsername: (NSString *)username {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"username"];
}

- (void)deleteUsername {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
}

+(instancetype)shared {
    static AppSettings *sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettings = [[self alloc] init];
    });
    return sharedSettings;
}

@end
