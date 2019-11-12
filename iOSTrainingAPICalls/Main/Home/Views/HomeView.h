//
//  HomeView.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/8/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cells/HomeTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeView : UIView
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *homeActivityIndicator;

@end

NS_ASSUME_NONNULL_END
