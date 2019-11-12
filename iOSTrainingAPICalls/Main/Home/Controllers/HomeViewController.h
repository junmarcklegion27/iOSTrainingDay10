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


NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) HomeView *homeView;
@property (strong, readwrite) NSMutableArray *categories;
@property (strong, nonatomic) NSString *categoryId;

@end

NS_ASSUME_NONNULL_END
