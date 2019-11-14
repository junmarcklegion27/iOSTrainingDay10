//
//  Message.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/13/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "Message.h"

@implementation Message

+ (instancetype)initWithDocument:(FIRQueryDocumentSnapshot *)document {
    NSDictionary *data = document.data;
    NSString *senderId = data[@"senderId"];
    NSString *senderName = data[@"senderName"];
    NSString *textSent = data[@"text"];
    FIRTimestamp *timeStampSent = data[@"date"];
    if (senderId == nil) {
        return nil;
    }
    Message *message = [[Message alloc] initWithSenderId:senderId senderDisplayName:senderName date:[timeStampSent dateValue] text:textSent];
    return message;
}

- (NSDictionary *)channelDictionary {
    NSDictionary *data;
    data = @{ @"senderId" : [self senderId],
              @"senderName" : [self senderDisplayName],
              @"date" : [self date],
              @"text" : [self text]
    };
    return data;
}

@end
