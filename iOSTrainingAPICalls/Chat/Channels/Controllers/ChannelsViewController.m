//
//  ChannelsViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/12/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "ChannelsViewController.h"

@interface ChannelsViewController ()

@end

@implementation ChannelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.channelsView = (ChannelsView *)[[[NSBundle mainBundle] loadNibNamed:@"ChannelsView" owner:self options:nil] objectAtIndex:0];
    self.channelsView.frame = self.view.bounds;
    self.channelsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.channelsUIView addSubview:self.channelsView];
    self.navigationItem.title = @"Channels";
    [self.channelsView.channelsTableView registerNib:[UINib nibWithNibName:@"ChannelTableViewCell" bundle:nil] forCellReuseIdentifier:@"channelCell"];
    self.channelsView.usernameLabel.text = [[AppSettings shared] getUsername];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
