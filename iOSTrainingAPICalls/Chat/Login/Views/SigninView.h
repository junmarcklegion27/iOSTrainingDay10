//
//  SigninView.h
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/15/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LoginDelegate <NSObject>

@required
-(void) onClickedSignin;
-(void) onClickedSigninGuest;

@end

@interface SigninView : UIView
@property (weak, nonatomic) IBOutlet UITextField *userNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextView;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (weak, nonatomic) IBOutlet UIButton *signinGuestButton;
@property (strong) id<LoginDelegate> loginDelegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;


@end

NS_ASSUME_NONNULL_END
