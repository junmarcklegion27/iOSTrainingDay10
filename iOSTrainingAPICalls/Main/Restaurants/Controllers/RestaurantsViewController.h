//
//  RestaurantsViewController.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/9/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Views/RestaurantsView.h"
#import <AFNetworking/AFNetworking.h>
#import "../Models/Restaurants.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantsViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) RestaurantsView *restaurantsView;
@property (strong, readwrite) NSMutableArray *restaurants;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) Restaurants *restaurant;
@property (strong, nonatomic) NSString *currentLatitude;
@property (strong, nonatomic) NSString *currentLongitude;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewMapButton;
@property (strong, nonatomic) CLLocation *clLocation;

@end

NS_ASSUME_NONNULL_END
