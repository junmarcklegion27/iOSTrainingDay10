//
//  ChannelsViewController.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/12/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Views/ChannelsView.h"
#import "../../Utility/AppSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChannelsViewController : UIViewController

@property (strong) ChannelsView *channelsView;
@property (weak, nonatomic) IBOutlet UIView *channelsUIView;

@end

NS_ASSUME_NONNULL_END
