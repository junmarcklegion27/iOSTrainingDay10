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
#import <FirebaseAuth/FirebaseAuth.h>
#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <JSQMessagesAvatarImageFactory.h>
#import <JSQMessagesBubbleImageFactory.h>
#import "../../Channels/Models/Channel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : JSQMessagesViewController <JSQMessagesCollectionViewDataSource, JSQMessagesInputToolbarDelegate, JSQMessageBubbleImageDataSource, JSQMessageAvatarImageDataSource>

+ (instancetype)initWithChannel:(Channel *)channel firUser:(FIRUser *)user;

@end

NS_ASSUME_NONNULL_END
