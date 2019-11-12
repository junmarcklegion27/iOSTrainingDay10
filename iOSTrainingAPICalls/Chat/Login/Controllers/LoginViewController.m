//
//  LoginViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/12/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "LoginViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginView = (LoginView *)[[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] objectAtIndex:0];
    self.loginView.frame = self.view.bounds;
    self.loginView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.loginView];
    self.loginView.loginDelegate = self;
    self.navigationItem.title = @"Sign-in";
}

- (void)onClickedSignin {
    NSString *username = self.loginView.loginTextField.text;
    [[AppSettings shared] setUsername:username];
    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRAuthDataResult *authResult, NSError *error) {
        [self performSegueWithIdentifier:@"loginToChannels" sender:nil];
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end