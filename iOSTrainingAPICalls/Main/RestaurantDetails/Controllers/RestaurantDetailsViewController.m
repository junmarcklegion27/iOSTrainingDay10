//
//  RestaurantDetailsViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/9/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "RestaurantDetailsViewController.h"

@interface RestaurantDetailsViewController ()

@property double kDegreesToRadians;

@end

@implementation RestaurantDetailsViewController
- (IBAction)onClickedBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.restaurantsDetailsView = (RestaurantDetailsView *)[[[NSBundle mainBundle] loadNibNamed:@"RestaurantDetailsView" owner:self options:nil] objectAtIndex:0];
    self.restaurantsDetailsView.frame = self.view.bounds;
    self.restaurantsDetailsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.restaurantsDetailsView];
    self.navigationItem.title = @"Restaurant";
    [self getRestaurant];
    [self settingUpMap];
}

- (void)getRestaurant {
    self.restaurantsDetailsView.restaurantNameLabel.text = self.restaurant.restaurantName;
    self.restaurantsDetailsView.restaurantCuisineLabel.text = [NSString stringWithFormat:@"Cuisine/s: %@", self.restaurant.restaurantCuisines];
    self.restaurantsDetailsView.restaurantRatingLabel.text = [NSString stringWithFormat:@"%.1f", self.restaurant.restaurantUserRating];
    self.restaurantsDetailsView.ratingView.layer.cornerRadius = 10;
    self.restaurantsDetailsView.ratingView.layer.masksToBounds = YES;
    self.restaurantsDetailsView.restaurantAddressLabel.text = [NSString stringWithFormat:@"Address: %@", self.restaurant.restaurantLocation];
    self.restaurantsDetailsView.restaurantTiming.text = self.restaurant.restaurantTiming;
    self.restaurantsDetailsView.averageCostForTwoLabel.text = [NSString stringWithFormat:@"Average cost for two: %.02f Php", self.restaurant.restaurantAverageCostForTwo];
    
    CLLocationDistance distance = [self distanceBetweenCoordinate:[self getCoordinate] andCoordinate:[self getSecondCoordinate]];
    self.restaurantsDetailsView.distanceLabel.text = [NSString stringWithFormat:@"Distance from restaurant: %.4f km\nDisclaimer: This distance is not via Road network.", distance];
    
    NSArray  *data = [self.restaurant.restaurantThumb componentsSeparatedByString:@"?"];
    for(NSString* str in data) {
        if([NSURLConnection canHandleRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]]) {
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: str]];
            self.restaurantsDetailsView.restaurantImageView.image = [UIImage imageWithData: imageData];
        }
    }
}

- (void)initLocationServices {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
    }
}

- (CLLocationCoordinate2D)getCoordinate {
    CLLocationCoordinate2D newCoordinate;
    newCoordinate.latitude = [_currentLatitude floatValue];
    newCoordinate.longitude = [_currentLongitude floatValue];
    return newCoordinate;
}

- (CLLocationCoordinate2D)getSecondCoordinate {
    CLLocationCoordinate2D newCoordinate;
    newCoordinate.latitude = [self.restaurant.restaurantLatitude floatValue];
    newCoordinate.longitude = [self.restaurant.restaurantLongitude floatValue];
    return newCoordinate;
}

- (CLLocationDistance)distanceBetweenCoordinate:(CLLocationCoordinate2D)originCoordinate andCoordinate:(CLLocationCoordinate2D)destinationCoordinate {
    CLLocation *originLocation = [[CLLocation alloc] initWithLatitude:originCoordinate.latitude longitude:originCoordinate.longitude];
    CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:destinationCoordinate.latitude longitude:destinationCoordinate.longitude];
    CLLocationDistance distance = [originLocation distanceFromLocation:destinationLocation];
    
    return distance / 1000;
}

- (void)settingUpMap {
    CLLocationCoordinate2D restoLocation;
    restoLocation.latitude = [self.restaurant.restaurantLatitude floatValue];
    restoLocation.longitude = [self.restaurant.restaurantLongitude floatValue];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = restoLocation;
    marker.title = self.restaurant.restaurantName;
    marker.snippet = self.restaurant.restaurantId;
    marker.map = self.restaurantsDetailsView.miniMapView;
    
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:[self getCoordinate]];
    [path addCoordinate:[self getSecondCoordinate]];
    
    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
    rectangle.strokeWidth = 2.f;
    rectangle.map = self.restaurantsDetailsView.miniMapView;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:restoLocation.latitude longitude:restoLocation.longitude];
    [self centerToLocation:location];
    self.restaurantsDetailsView.miniMapView.myLocationEnabled = YES;
}

- (void)centerToLocation:(CLLocation *)location {
    GMSCameraPosition *camera = [GMSMutableCameraPosition cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude zoom:12];
    self.restaurantsDetailsView.miniMapView.camera = camera;
}

@end
