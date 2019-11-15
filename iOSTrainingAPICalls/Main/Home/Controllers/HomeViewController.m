//
//  HomeViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/8/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "HomeViewController.h"
#import "../Views/Cells/HomeTableViewCell.h"
#import "../../Restaurants/Controllers/RestaurantsViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeView = (HomeView *)[[[NSBundle mainBundle] loadNibNamed:@"HomeView" owner:self options:nil] objectAtIndex:0];
    self.homeView.homeTableView.delegate = self;
    self.homeView.homeTableView.dataSource = self;
    self.homeView.frame = self.view.bounds;
    self.homeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.homeView];
    [self.homeView.homeActivityIndicator startAnimating];
    self.navigationItem.title = @"Categories";
    [self.homeView.homeTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeCell"];
    [self initLocationServices];
    [self checkLocationServicesAccess];
    [self getCategories];
}

- (void) getCategories {
    NSString *categoriesUrl = @"https://developers.zomato.com/api/v2.1/categories";
    NSString *apiKey = @"9255d38e382f43e03af2ce0c42737385";
    NSDictionary *parameters = @{@"res-id" : @"216"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"user-key"];
    [manager GET:categoriesUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDictionary = responseObject;
        NSArray *responseArray = responseDictionary[@"categories"];
        self.categories = [[NSMutableArray alloc] init];
        for (id item in responseArray) {
            NSDictionary *responseCategory = item[@"categories"];
            Categories *category = [Categories
                                        categoryId:[responseCategory[@"id"] intValue]
                                        name:responseCategory[@"name"]];
            [self.categories addObject:category];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.homeView.homeTableView reloadData];
            [self.homeView.homeActivityIndicator stopAnimating];
        });
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    cell.cellContentView.layer.cornerRadius = 10;
    cell.cellContentView.layer.masksToBounds = YES;
    Categories *category = self.categories[indexPath.row];
    cell.homeCellLabel.text = category.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Categories *category = self.categories[indexPath.row];
    _categoryId = [NSString stringWithFormat:@"%i", category.categoryId];
    [self performSegueWithIdentifier:@"categoryToCollection" sender:nil];
    [self.homeView.homeTableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"categoryToCollection"]) {
        RestaurantsViewController *restaurantsVc = [segue destinationViewController];
        restaurantsVc.categoryId = self.categoryId;
        restaurantsVc.currentLatitude = self.currentLatitude;
        restaurantsVc.currentLongitude = self.currentLongitude;
        restaurantsVc.clLocation = self.clLocation;
    }
}

#pragma - Location

- (void)initLocationServices {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
    }
}

- (void)checkLocationServicesAccess {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
            case kCLAuthorizationStatusDenied:
            [_locationManager requestWhenInUseAuthorization];
            break;
            case kCLAuthorizationStatusRestricted:
            break;
            case kCLAuthorizationStatusNotDetermined:
            [_locationManager requestWhenInUseAuthorization];
            break;
            case kCLAuthorizationStatusAuthorizedAlways:
            break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (_clLocation != nil) {
        [_locationManager stopUpdatingLocation];
        return;
    }
    _clLocation = [locations lastObject];
    NSLog(@"CLLocation%@", _clLocation);
    [self settingLocation:_clLocation];
    NSLog(@"Location Updated: %@",_clLocation);
}

- (void)settingLocation:(CLLocation *)location {
    _currentLongitude = [NSString stringWithFormat:@"%.8f", location.coordinate.longitude];
    _currentLatitude = [NSString stringWithFormat:@"%.8f", location.coordinate.latitude];

    NSLog(@"Longitude: %@, Latitude: %@", _currentLongitude, _currentLatitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location Error: %@", error);
}

@end
