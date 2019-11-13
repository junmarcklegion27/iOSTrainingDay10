//
//  Channel.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/13/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "Channel.h"

@implementation Channel

+ (instancetype)initWithChannelName:(NSString *)channelName {
    Channel *channel = [[Channel alloc] init];
    channel.channelName = channelName;
    return channel;
}

+ (instancetype)initWithDocument:(FIRQueryDocumentSnapshot *)document {
    NSDictionary *channels = document.data;
    NSString *name = channels[@"name"];
    if (name == nil) {
        return nil;
    }
    Channel *channel = [Channel initWithChannelName:name];
    channel.channelId = [document documentID];
    return channel;
}

-(NSDictionary *)channelDictionary {
    NSDictionary *channelReturnVal;
    channelReturnVal = @{@"name": _channelName};
    return channelReturnVal;
}

@end
