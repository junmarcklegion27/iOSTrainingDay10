//
//  Header.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/13/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <FirebaseFirestore/FirebaseFirestore.h>
#import <Foundation/Foundation.h>
#ifndef Header_h
#define Header_h

@protocol DatabasePresentation <NSObject>

- (NSDictionary *)channelDictionary;
+ (instancetype)initWithDocument:(FIRQueryDocumentSnapshot *)document;

@end

#endif /* Header_h */
