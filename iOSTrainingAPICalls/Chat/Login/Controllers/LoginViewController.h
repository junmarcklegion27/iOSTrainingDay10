//
//  LoginViewController.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/12/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Views/SigninView.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import "../../Utility/AppSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController<LoginDelegate>

//@property (strong, nonatomic) LoginView *loginView;
@property (strong, nonatomic) SigninView *signinView;

@end

NS_ASSUME_NONNULL_END
