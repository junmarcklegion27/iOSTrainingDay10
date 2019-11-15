//
//  AppSettings.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/12/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#ifndef AppSettings_h
#define AppSettings_h

@interface AppSettings : NSObject
@property (strong, nonatomic) NSString *username;

+(instancetype)shared;
- (NSString *)getUsername;
- (void)deleteUsername;
- (void)setUsername:(NSString *)username;

@end

#endif /* AppSettings_h */

