//
//  HomeViewController.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/8/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Views/HomeView.h"
#import <AFNetworking/AFNetworking.h>
#import "../Models/Categories.h"
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (strong, nonatomic) HomeView *homeView;
@property (strong, readwrite) NSMutableArray *categories;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *clLocation;
@property (strong, nonatomic) NSString *currentLatitude;
@property (strong, nonatomic) NSString *currentLongitude;

@end

NS_ASSUME_NONNULL_END
