//
//  RestaurantDetailsViewController.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/9/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Views/RestaurantDetailsView.h"
#import "../../Restaurants/Models/Restaurants.h"
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

@interface RestaurantDetailsViewController : UIViewController

@property (strong, nonatomic) RestaurantDetailsView *restaurantsDetailsView;
@property (strong, readwrite) Restaurants *restaurant;
@property (assign, nonatomic) BOOL isBackbuttonShown;
@property (strong, nonatomic) NSString *currentLatitude;
@property (strong, nonatomic) NSString *currentLongitude;
@property (strong, nonatomic) CLLocation *clLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

NS_ASSUME_NONNULL_END
