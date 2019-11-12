//
//  LoginView.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/12/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
- (IBAction)onClickedSignin:(id)sender {
    if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(onClickedSignin)]) {
        [self.loginDelegate onClickedSignin];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
