//
//  Message.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/13/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../../Channels/Models/DatabasePresentation.h"
#import <JSQMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : JSQMessage <DatabasePresentation>

@end

NS_ASSUME_NONNULL_END
