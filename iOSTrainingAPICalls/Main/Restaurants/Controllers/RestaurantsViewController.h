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
#import <CoreLocation/CoreLocation.h>

#import "../Models/Restaurants.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantsViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate>

@property (strong, nonatomic) RestaurantsView *restaurantsView;
@property (strong, readwrite) NSMutableArray *restaurants;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) Restaurants *restaurant;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *currentLatitude;
@property (strong, nonatomic) NSString *currentLongitude;


@end

NS_ASSUME_NONNULL_END
