//
//  LoginViewController.m
//  iOSTrainingAPICalls
//
//  Created by OPS on 11/12/19.
//  Copyright © 2019 OPSolutions. All rights reserved.
//

#import "LoginViewController.h"
#import "../../Channels/Controllers/ChannelsViewController.h"
@interface LoginViewController ()

@property UIAlertController *alertController;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.signinView = (SigninView *)[[[NSBundle mainBundle] loadNibNamed:@"SigninView" owner:self options:nil] objectAtIndex:0];
    self.signinView.frame = self.view.bounds;
    self.signinView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.signinView];
    self.signinView.loginDelegate = self;
    self.navigationItem.title = @"Sign-in";
}

- (void)showWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onClickedSignin {
    NSString *username = self.signinView.userNameTextView.text;
    NSString *password = self.signinView.passwordTextView.text;
    if ([username isEqualToString:@""]) {
        [self showWithMessage:@"Please enter a username"];
        return;
    }
    [self.signinView.loginActivityIndicator startAnimating];
    self.signinView.userNameTextView.enabled = NO;
    self.signinView.passwordTextView.enabled = NO;
    self.signinView.signinButton.enabled = NO;
    self.signinView.signinGuestButton.enabled = NO;
    [[AppSettings shared] setUsername:username];
    [[FIRAuth auth] signInWithEmail:username password:password completion:^(FIRAuthDataResult *authResult, NSError *error) {
        self.signinView.userNameTextView.text = @"";
        self.signinView.passwordTextView.text = @"";
        [self.signinView.loginActivityIndicator stopAnimating];
        self.signinView.userNameTextView.enabled = YES;
        self.signinView.passwordTextView.enabled = YES;
        self.signinView.signinButton.enabled = YES;
        self.signinView.signinGuestButton.enabled = YES;
        if (error != nil) {
            [self showWithMessage:@"Username or password doesm't match!"];
            return;
        }
        [self performSegueWithIdentifier:@"loginToChannels" sender:[authResult user]];
    }];
    
}

- (void)signinAsGuest {
    NSString *username = self.alertController.textFields[0].text;
    if ([username isEqualToString:@""]) {
        [self showWithMessage:@"Please enter a username"];
        return;
    }    [[AppSettings shared] setUsername:username];
    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRAuthDataResult *authResult, NSError *error) {
        self.signinView.userNameTextView.text = @"";
        [self performSegueWithIdentifier:@"loginToChannels" sender:[authResult user]];
    }];
}

- (void)onClickedSigninGuest{
    UIAlertController *addChannel = [UIAlertController alertControllerWithTitle:@"Sign in as guest" message:@"Please User Name" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         [self signinAsGuest];
                                                     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {}];
    
    [addChannel addAction:okAction];
    [addChannel addTextFieldWithConfigurationHandler:^(UITextField *channelField) {
        channelField.placeholder = @"Enter User Name here...";
    }];
    [addChannel addAction:cancelAction];
    [self presentViewController:addChannel animated:YES completion:nil];
    _alertController = addChannel;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginToChannels"]) {
        UINavigationController *navVC = [segue destinationViewController];
        ChannelsViewController *channelVc = navVC.viewControllers[0];
        FIRUser *user = sender;
        channelVc.user = user;
    }
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
