//
//  ViewController.m
//  Minion
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *signOutButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;



@end

@implementation ViewController

#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.signOutButton.enabled = false;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)pushDetailViewController{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CHECK WEATHER"];
    [self.navigationController pushViewController: vc animated:YES];
}

#pragma mark -


#pragma mark Private Methods

- (IBAction)signinTapped:(id)sender {
    if ([self checkUser ]) {
        self.signOutButton.enabled = true;
        self.userName.hidden = true;
        self.password.hidden = true;
        self.messageLabel.text = @"Welcome to Minions";
        self.signInButton.hidden = true;
        [self pushDetailViewController];
    }else{
        [self handleError];
    }
}

- (BOOL)checkUser{
    BOOL authentication = false;
    if ([self.userName.text  isEqual: @"user@test.com"] && [self.password.text isEqual:@"pass"] ) {
        authentication = true;
    }
    return authentication;
}

- (void) handleError{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:@"Incorrect Credentials"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark -





- (IBAction)signOutAction:(id)sender {
    self.userName.text = @"";
    self.password.text = @"";
    self.userName.hidden= false;
    self.password.hidden = false;
    self.messageLabel.text = @"";
    self.signInButton.hidden = false;
    self.signOutButton.enabled = false;
}
@end
