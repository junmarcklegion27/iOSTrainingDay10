//
//  RestaurantsViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/9/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "../Views/Cells/RestaurantViewCell.h"
#import "../../RestaurantDetails/Controllers/RestaurantDetailsViewController.h"
#import "../../MapView/Controllers/MapViewController.h"

@interface RestaurantsViewController ()

@end

@implementation RestaurantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.restaurantsView = (RestaurantsView *)[[[NSBundle mainBundle] loadNibNamed:@"RestaurantsView" owner:self options:nil] objectAtIndex:0];
    self.restaurantsView.restaurantsCollectionView.delegate = self;
    self.restaurantsView.restaurantsCollectionView.dataSource = self;
    self.restaurantsView.frame = self.view.bounds;
    self.restaurantsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.restaurantsView.restaurantsActivityIndicator startAnimating];
    [self.view addSubview:self.restaurantsView];
    self.navigationItem.title = @"Restaurants";
    [self.restaurantsView.restaurantsCollectionView registerNib:[UINib nibWithNibName:@"RestaurantViewCell" bundle:nil] forCellWithReuseIdentifier:@"restaurantCell"];
    _viewMapButton.enabled = NO;
    NSLog(@"Latitude %@", _currentLatitude);
    NSLog(@"Longitude %@", _currentLongitude);

    [self getRestaurants];
}

- (void) getRestaurants {
    NSString *categoriesUrl = @"https://developers.zomato.com/api/v2.1/search";
    NSString *apiKey = @"9255d38e382f43e03af2ce0c42737385";
//    _currentLongitude = @"121.037037";
//    _currentLatitude = @"14.219866";
    NSDictionary *parameters = @{@"category" : _categoryId,
                                 @"lat" : _currentLatitude,
                                 @"lon" : _currentLongitude,
                                 @"radius" : @"2000",
                                 @"sort" : @"real_distance"
                                 };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"user-key"];
    [manager GET:categoriesUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDictionary = responseObject;
        NSArray *responseArray = responseDictionary[@"restaurants"];
        self.restaurants = [[NSMutableArray alloc] init];
        for (id item in responseArray) {
            NSDictionary *responseCategory = item[@"restaurant"];
            Restaurants *restaurant = [Restaurants restaurantId:responseCategory[@"id"]];
            NSDictionary *location = responseCategory[@"location"];
            NSDictionary *userRating = responseCategory[@"user_rating"];
            restaurant.restaurantName = responseCategory[@"name"];
            restaurant.restaurantLocation = location[@"address"];
            restaurant.restaurantThumb = responseCategory[@"thumb"];
            restaurant.restaurantUserRating = [userRating[@"aggregate_rating"] floatValue];
            restaurant.restaurantCuisines = responseCategory[@"cuisines"];
            restaurant.restaurantTiming = responseCategory[@"timings"];
            restaurant.restaurantAverageCostForTwo = [responseCategory[@"average_cost_for_two"] floatValue];
            restaurant.restaurantLatitude = location[@"latitude"];
            restaurant.restaurantLongitude = location[@"longitude"];
            [self.restaurants addObject:restaurant];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.restaurantsView.restaurantsCollectionView reloadData];
            [self.restaurantsView.restaurantsActivityIndicator stopAnimating];
            self.viewMapButton.enabled = YES;
        });
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"restaurantCell" forIndexPath:indexPath];
    cell.cellContentView.layer.cornerRadius = 5;
    cell.cellContentView.layer.masksToBounds = YES;
    Restaurants *restaurant = self.restaurants[indexPath.row];
    cell.restaurantNameLabel.text = restaurant.restaurantName;
    cell.timingLabel.text = restaurant.restaurantTiming;
    [cell.imageActivityIndicator startAnimating];
    if ([restaurant.restaurantThumb isEqualToString:@""]) {
        UIImage *noImage = [UIImage imageNamed:@"ic_no_image"];
        cell.restaurantImageView.image = noImage;
        [cell.imageActivityIndicator stopAnimating];
        return cell;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:restaurant.restaurantThumb];
        NSData * imageData = [NSData dataWithContentsOfURL: url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            cell.restaurantImageView.image = image;
            [cell.imageActivityIndicator stopAnimating];
        });
    });
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.restaurants count];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Restaurants *restaurant = self.restaurants[indexPath.item];
    self.restaurant = restaurant;
    [self performSegueWithIdentifier:@"collectionToDetails" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"collectionToDetails"]) {
        UINavigationController *navVc = [segue destinationViewController];
        RestaurantDetailsViewController *restaurantDetailsVc = navVc.viewControllers[0];
        restaurantDetailsVc.restaurant = self.restaurant;
        restaurantDetailsVc.clLocation = self.clLocation;
        restaurantDetailsVc.currentLongitude = self.currentLongitude;
        restaurantDetailsVc.currentLatitude = self.currentLatitude;
    } else if ([segue.identifier isEqualToString:@"restaurantToMap"]) {
        UINavigationController *navVc = [segue destinationViewController];
        MapViewController *mapVc = navVc.viewControllers[0];
        mapVc.restaurants = self.restaurants;
        mapVc.clLocation = self.clLocation;
        mapVc.currentLongitude = self.currentLongitude;
        mapVc.currentLatitude = self.currentLatitude;
    }
}


@end
