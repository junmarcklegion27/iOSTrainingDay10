//
//  ChatViewController.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/13/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/Message.h"
#import <FirebaseFirestore/FirebaseFirestore.h>
#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import "../../Channels/Models/Channel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : JSQMessagesViewController

+ (instancetype)initWithChannel:(Channel *)channel;

@end

NS_ASSUME_NONNULL_END
