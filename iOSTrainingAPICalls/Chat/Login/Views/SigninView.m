//
//  SigninView.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/15/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "SigninView.h"

@implementation SigninView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)onClickedSignin:(id)sender {
    if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(onClickedSignin)]) {
        [self.loginDelegate onClickedSignin];
    }

    
}
- (IBAction)onClickedSigninGuest:(id)sender {
    if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(onClickedSigninGuest)]) {
        [self.loginDelegate onClickedSigninGuest];
    }

    
}


@end
