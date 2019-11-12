//
//  MapViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/11/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "MapViewController.h"
#import "../../Restaurants/Models/Restaurants.h"
#import "../../RestaurantDetails/Controllers/RestaurantDetailsViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

const float zoom = 15.0f;
- (IBAction)tappedBackBarItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = (MapView *)[[[NSBundle mainBundle] loadNibNamed:@"MapView" owner:self options:nil] objectAtIndex:0];
    self.mapView.frame = self.view.bounds;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.mapView];
    [self initLocationServices];
    [self settingUpMap];}

- (void)initLocationServices {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
//        _locationManager.delegate = self;
        self.mapView.googleMapView.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
    }
}

- (void)centerToLocation:(CLLocation *)location {
    GMSCameraPosition *camera = [GMSMutableCameraPosition cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude zoom:zoom];
    self.mapView.googleMapView.camera = camera;
}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"%@", error);
//}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    CLLocation *clLocation = [locations lastObject];
//    [self centerToLocation:clLocation];
//}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    for (Restaurants *restaurantObj in self.restaurants) {
        if ([restaurantObj.restaurantId isEqualToString:marker.snippet]) {
            self.restaurant = restaurantObj;
            NSLog(@"Marker tapped");
            [self performSegueWithIdentifier:@"mapToDetails" sender:nil];
            return YES;
        }
    }
    return NO;
}

- (void)settingUpMap {
    CLLocationCoordinate2D restaurantLocation;
    int count = 0;
    for (Restaurants *restaurant in self.restaurants) {
        CLLocationCoordinate2D restoLocation;
        restoLocation.latitude = [restaurant.restaurantLatitude floatValue];
        restoLocation.longitude = [restaurant.restaurantLongitude floatValue];
        
        if (count == 0) {
            restaurantLocation = restoLocation;
        }
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = restoLocation;
        marker.title = restaurant.restaurantName;
        marker.snippet = restaurant.restaurantId;
        marker.map = self.mapView.googleMapView;
        marker.tappable = YES;
        count ++;
    }

    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:restaurantLocation.latitude longitude:restaurantLocation.longitude];
    [self centerToLocation:location];
    self.mapView.googleMapView.myLocationEnabled = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mapToDetails"]) {
        UINavigationController *navVc = [segue destinationViewController];
        NSLog(@"%@", navVc.viewControllers[1]);
        
        RestaurantDetailsViewController *restaurantDetailsVc = navVc.viewControllers[2];
        restaurantDetailsVc.restaurant = self.restaurant;

//        RestaurantDetailsViewController *restaurantDetailsVc = [segue destinationViewController];
//        restaurantDetailsVc.restaurant = self.restaurant;
//        NSLog(@"Object: %@,", self.restaurant.restaurantName);
    }
}

@end
