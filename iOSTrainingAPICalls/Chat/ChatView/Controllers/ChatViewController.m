//
//  ChatViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/13/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@property FIRFirestore *messageDb;
@property FIRCollectionReference *messageRef;
@property Channel *channel;

@end

@implementation ChatViewController

+ (instancetype)initWithChannel:(Channel *)channel {
    ChatViewController *instance = [[ChatViewController alloc] initWithNibName:nil bundle:nil];
    instance.channel = channel;
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar* navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width, 50)];
    navbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:@"Chat"];
    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTapCancel:)];
    navItem.leftBarButtonItem = cancelBtn;
    
//    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTapDone:)];
//    navItem.rightBarButtonItem = doneBtn;
    
    [navbar setItems:@[navItem]];
    [self.view addSubview:navbar];
    [self setUp];
}

-(void)onTapDone:(UIBarButtonItem*)item{
    
}

-(void)onTapCancel:(UIBarButtonItem*)item{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUp {
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

- (void)showWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Channel" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)handleDocumentChange:(FIRDocumentChange *)change {
    //TODO
}


@end
