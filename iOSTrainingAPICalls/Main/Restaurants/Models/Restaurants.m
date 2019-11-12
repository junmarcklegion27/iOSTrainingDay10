//
//  Restaurants.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/9/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "Restaurants.h"

@implementation Restaurants

- (id) restaurantId:(NSString *)restaurantId {
    if (self) {
        self.restaurantId = restaurantId;
    }
    return self;
}

+ (instancetype)restaurantId:(NSString *)restaurantId{
    Restaurants *restaurant = [[Restaurants alloc] restaurantId:restaurantId];
    return restaurant;
}

@end
