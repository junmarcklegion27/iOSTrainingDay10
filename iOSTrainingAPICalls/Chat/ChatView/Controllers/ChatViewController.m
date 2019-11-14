//
//  ChatViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/13/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "ChatViewController.h"
#import "../../Utility/AppSettings.h"
#import <JSQMessagesToolbarContentView.h>

@interface ChatViewController ()

@property FIRFirestore *messageDb;
@property FIRCollectionReference *messageRef;
@property Channel *channel;
@property NSMutableArray<Message *> *messages;
@property FIRUser *user;

@end

@implementation ChatViewController

+ (instancetype)initWithChannel:(Channel *)channel firUser:(FIRUser *)user{
    ChatViewController *instance = [[ChatViewController alloc] initWithNibName:nil bundle:nil];
    instance.channel = channel;
    instance.user = user;
    instance.messages = [[NSMutableArray alloc] init];
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _channel.channelName;
    
    self.inputToolbar.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self setUp];
}

-(void)onTapCancel:(UIBarButtonItem*)item{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUp {
    self.inputToolbar.enablesSendButtonAutomatically = YES;
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    _messageDb = [FIRFirestore firestore];
    NSString *stringUrl = [NSString stringWithFormat:@"channel/%@/thread", _channel.channelId];
    _messageRef = [_messageDb collectionWithPath:stringUrl];
    
    [_messageRef addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil) {
            [self showWithMessage:error.localizedDescription];
            return;
        }
        for (FIRDocumentChange *change in [snapshot documentChanges]) {
            [self handleDocumentChange:change];
        }
    }];
}

- (void)handleDocumentChange:(FIRDocumentChange *)change {    Message *msg = [Message initWithDocument:change.document];
    if (msg == nil) {
        return;
    }
    
    switch (change.type) {
            case FIRDocumentChangeTypeAdded:
            [self addMessageToTable:msg];
            break;
            
        default:
            break;
    }
}

- (void)addMessageToTable:(Message *)msg {
    [_messages addObject:msg];
    [self.collectionView reloadData];
    [self scrollToBottomAnimated:YES];
    
}


- (void)showWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Channel" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_messages count];
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _messages[indexPath.row];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGSize contentSize = [self.collectionView.collectionViewLayout collectionViewContentSize];
    if (contentSize.height > self.collectionView.bounds.size.height) {
        CGPoint targetContentOffset = CGPointMake(0.0f, contentSize.height - self.collectionView.bounds.size.height);
        [self.collectionView setContentOffset:targetContentOffset];
    }
    
}

#pragma avatar

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesAvatarImageFactory *avatar = [[JSQMessagesAvatarImageFactory alloc] init];
    Message *msg = _messages[indexPath.row];
    NSString *initial = @"?";
    if (![msg.senderDisplayName isEqualToString:@""]) {
        initial = [[msg.senderDisplayName substringToIndex:1] capitalizedString];
    }
    
    return [avatar avatarImageWithUserInitials:initial backgroundColor:UIColor.yellowColor textColor:UIColor.blackColor font:[UIFont systemFontOfSize:14.0]];
}

#pragma bubble

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesBubbleImageFactory *bubble = [[JSQMessagesBubbleImageFactory alloc] init];
    Message *msg = _messages[indexPath.row];
    if ([self.senderId isEqualToString:msg.senderId]) {
        return [bubble outgoingMessagesBubbleImageWithColor:UIColor.orangeColor];
    }
    return [bubble incomingMessagesBubbleImageWithColor:UIColor.purpleColor];
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 16.0;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 12.0;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg =_messages[indexPath.row];
    NSString *formattedData = msg.senderDisplayName;
    return [[NSMutableAttributedString alloc] initWithString:formattedData];
}

-(NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg =_messages[indexPath.row];
    NSString *dateSent = [NSString stringWithFormat:@"%@", msg.date];
    NSArray *data = [dateSent componentsSeparatedByString:@" "];
    NSString *formattedData = [NSString stringWithFormat:@"\t   %@ %@", data[0], data[1]];
    return [[NSMutableAttributedString alloc] initWithString:formattedData];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg = _messages[indexPath.row];
    NSLog(@"Message: %@", msg.text);
}

#pragma user defaults

- (NSString *)senderId {
    return _user.uid;
}

- (NSString *)senderDisplayName {
    return [AppSettings.shared getUsername];
}

#pragma chat

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    [self setShowTypingIndicator:YES];
    Message *msg = [Message messageWithSenderId:senderId displayName:senderDisplayName text:text];
    [self sendMessage:msg];
    [self scrollToBottomAnimated:YES];
    self.inputToolbar.contentView.textView.text = @"";}

- (void)didPressAccessoryButton:(UIButton *)sender {
    
}

- (void)sendMessage: (Message *) msg{
    [_messageRef addDocumentWithData:msg.channelDictionary completion:^(NSError * _Nullable error) {
        if (error != nil) {
            [self showWithMessage:error.localizedDescription];
        }
    }];
    [self setShowTypingIndicator:NO];
}

@end
