//
//  ChannelsViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/12/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "ChannelsViewController.h"
#import "../Views/Cells/ChannelTableViewCell.h"
#import "../../ChatView/Controllers/ChatViewController.h"

@interface ChannelsViewController ()

@property FIRFirestore *channelDb;
@property FIRCollectionReference *channelRef;
@property UIAlertController *alertController;
@property NSMutableArray *channels;

@end

@implementation ChannelsViewController
- (IBAction)onClickedSignout:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.channelsView = (ChannelsView *)[[[NSBundle mainBundle] loadNibNamed:@"ChannelsView" owner:self options:nil] objectAtIndex:0];
    
    self.channelsView.channelsTableView.delegate = self;
    self.channelsView.channelsTableView.dataSource = self;
    
    self.channelsView.frame = self.view.bounds;
    self.channelsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.channelsView];
    self.navigationItem.title = @"Channels";
    [self.channelsView.channelsTableView registerNib:[UINib nibWithNibName:@"ChannelTableViewCell" bundle:nil] forCellReuseIdentifier:@"channelCell"];
    self.channelsView.usernameLabel.text = [[AppSettings shared] getUsername];
    _channelDb = [FIRFirestore firestore];
    _channelRef = [_channelDb collectionWithPath:@"channel"];
    [self setUp];
}

- (IBAction)onClickedAdd:(id)sender {
    UIAlertController *addChannel = [UIAlertController alertControllerWithTitle:@"Add Channel" message:@"Input Channel" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         [self onClickedOK];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    [addChannel addAction:okAction];
    [addChannel addTextFieldWithConfigurationHandler:^(UITextField *channelField) {
        channelField.placeholder = @"Enter Channel Name here...";
    }];
    [addChannel addAction:cancelAction];
    [self presentViewController:addChannel animated:YES completion:nil];
    _alertController = addChannel;
    
}

- (void)onClickedOK {
    UITextField *channelField = _alertController.textFields[0];
    NSString *channelName = channelField.text;
    if (channelField == nil) {
        return;
    } else {
        for (Channel *channel in _channels) {
            if ([channel.channelName isEqualToString:channelName]) {
                [self showWithMessage:@"Name already exist"];
                return;
            }
        }
    }
    ChannelsViewController *channelVC = self;
    
    Channel *channel = [Channel initWithChannelName:channelName];
    [_channelRef addDocumentWithData:[channel channelDictionary] completion:^(NSError *error) {
        NSString *errorMessage = @"Channel Added Successfully";
        if (error != nil) {
            errorMessage = [NSString stringWithFormat:@"Failed to add channel: %@", error.localizedDescription];
        }
        [channelVC showWithMessage:errorMessage];
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

- (void)setUp{
    _channels = [[NSMutableArray alloc] init];
    ChannelsViewController *channelVC = self;
    [_channelRef addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil) {
            [channelVC showWithMessage:error.localizedDescription];
            return;
        }
        for (FIRDocumentChange *change in [snapshot documentChanges]) {
            [channelVC handleDocumentChange:change];
        }
    }];
}

- (void)handleDocumentChange:(FIRDocumentChange *)change {
    Channel *channel = [Channel initWithDocument:change.document];
    if (channel == nil) {
        return;
    }
    switch (change.type) {
            case FIRDocumentChangeTypeAdded:
            [self addChannelToTable:channel];
            break;
            
            case FIRDocumentChangeTypeModified:
            [self updateChannelToTable:channel];
            break;
            
            case FIRDocumentChangeTypeRemoved:
            [self deleteChannelToTable:channel];
            break;
            
        default:
            break;
    }
    
}

#pragma cell modifier

- (void)addChannelToTable:(Channel *)channel {
    if ([_channels containsObject:channel]) {
        return;
    }
    [_channels addObject:channel];
    NSInteger index = [_channels count] - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSArray *paths = [NSArray arrayWithObject:indexPath];
    [self.channelsView.channelsTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateChannelToTable:(Channel *)channel {
    int count = 0;
    for (Channel *channelObj in _channels) {
        if ([channelObj.channelName isEqualToString:channel.channelName]){
            _channels[count] = channel;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count inSection:0];
            NSArray *paths = [NSArray arrayWithObject:indexPath];
            [self.channelsView.channelsTableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        count++;
    }
}
- (void)deleteChannelToTable:(Channel *)channel {
    int count = 0;
    for (Channel *channelObj in _channels) {
        if ([channelObj.channelName isEqualToString:channel.channelName]){
            [_channels removeObjectAtIndex:count];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count inSection:0];
            NSArray *paths = [NSArray arrayWithObject:indexPath];
            [self.channelsView.channelsTableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        count++;
    }
}

#pragma delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"channelCell"];
    Channel *channel = _channels[indexPath.row];
    cell.channelLabel.text = channel.channelName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Channel *channel = _channels[indexPath.row];
    if (channel == nil) {
        return;
    }
    ChatViewController *chatVc = [ChatViewController initWithChannel:channel firUser:_user];
    if ([self navigationController] != nil) {
        [[self navigationController] showViewController:chatVc sender:nil];
    } else {
        [self showViewController:chatVc sender:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Channel *channel = _channels[indexPath.row];
        [[_channelRef documentWithPath:channel.channelId] deleteDocument];
        
    }
}

@end
