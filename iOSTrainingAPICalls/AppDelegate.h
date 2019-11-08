//
//  AppDelegate.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/8/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

