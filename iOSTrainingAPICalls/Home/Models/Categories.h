//
//  Categories.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/8/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Categories : NSObject

@property (assign) int categoryId;
@property (strong, nonatomic) NSString *name;

- (id) categoryId:(int)categoryId name:(NSString *)name;
+ (instancetype)categoryId:(int)categoryId name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
