//
//  RestaurantsView.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/9/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cells/RestaurantViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantsView : UIView
@property (weak, nonatomic) IBOutlet UICollectionView *restaurantsCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *restaurantsActivityIndicator;

@end

NS_ASSUME_NONNULL_END
