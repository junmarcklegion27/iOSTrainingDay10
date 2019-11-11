//
//  MapViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/11/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

const float zoom = 15.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = (MapView *)[[[NSBundle mainBundle] loadNibNamed:@"MapView" owner:self options:nil] objectAtIndex:0];
    self.mapView.frame = self.view.bounds;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.mapView];
    [self initLocationServices];
    [self settingUpMap];
    NSLog(@"%@", self.restaurants);
}

- (void)initLocationServices {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
    }
}

- (void)centerToLocation:(CLLocation *)location {
    GMSCameraPosition *camera = [GMSMutableCameraPosition cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude zoom:zoom];
    self.mapView.googleMapView.camera = camera;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *clLocation = [locations lastObject];
    [self centerToLocation:clLocation];
}

- (void)settingUpMap {
    CLLocationCoordinate2D carolinaMallLocation;
    carolinaMallLocation.latitude = 14.2190864;
    carolinaMallLocation.longitude = 121.8449656;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:carolinaMallLocation.latitude longitude:carolinaMallLocation.longitude];
    [self centerToLocation:location];
    self.mapView.googleMapView.myLocationEnabled = YES;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = carolinaMallLocation;
    marker.title = @"Workplace";
    marker.snippet = @"Snippet";
    marker.map = self.mapView.googleMapView;
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
