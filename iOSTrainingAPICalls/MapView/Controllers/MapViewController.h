//
//  MapViewController.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/11/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Views/MapView.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) MapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *restaurants;

@end

NS_ASSUME_NONNULL_END
