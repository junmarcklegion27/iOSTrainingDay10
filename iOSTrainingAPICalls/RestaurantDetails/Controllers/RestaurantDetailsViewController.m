//
//  RestaurantDetailsViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/9/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "RestaurantDetailsViewController.h"

@interface RestaurantDetailsViewController ()

@end

@implementation RestaurantDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.restaurantsDetailsView = (RestaurantDetailsView *)[[[NSBundle mainBundle] loadNibNamed:@"RestaurantDetailsView" owner:self options:nil] objectAtIndex:0];
    self.restaurantsDetailsView.frame = self.view.bounds;
    self.restaurantsDetailsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.restaurantsDetailsView];
    self.navigationItem.title = @"Restaurant";
    [self getRestaurant];
}

- (void)getRestaurant {self.restaurantsDetailsView.restaurantNameLabel.text = self.restaurant.restaurantName;
    self.restaurantsDetailsView.restaurantCuisineLabel.text = self.restaurant.restaurantCuisines;
    self.restaurantsDetailsView.restaurantRatingLabel.text = [NSString stringWithFormat:@"%.02f", self.restaurant.restaurantUserRating];
    self.restaurantsDetailsView.restaurantAddressLabel.text = self.restaurant.restaurantLocation;
    self.restaurantsDetailsView.restaurantTiming.text = self.restaurant.restaurantTiming;
    self.restaurantsDetailsView.averageCostForTwoLabel.text = [NSString stringWithFormat:@"%.02f", self.restaurant.restaurantAverageCostForTwo];
    
    NSArray  *data = [self.restaurant.restaurantThumb componentsSeparatedByString:@"?"];
    for(NSString* str in data)
    {
        if([NSURLConnection canHandleRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]]) {
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: str]];
            self.restaurantsDetailsView.restaurantImageView.image = [UIImage imageWithData: imageData];
            NSLog(@"%@",[[NSString alloc ] initWithFormat:@"Found a URL: %@",str]);
        }
    }
}

@end
