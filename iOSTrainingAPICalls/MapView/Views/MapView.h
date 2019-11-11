//
//  MapView.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/11/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapView : UIView
@property (weak, nonatomic) IBOutlet GMSMapView *googleMapView;

@end

NS_ASSUME_NONNULL_END
