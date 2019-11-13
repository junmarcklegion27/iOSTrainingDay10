//
//  Channel.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/13/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabasePresentation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Channel : NSObject <DatabasePresentation>

@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *channelName;

+ (instancetype) initWithChannelName:(NSString *) channelName;

@end

NS_ASSUME_NONNULL_END
