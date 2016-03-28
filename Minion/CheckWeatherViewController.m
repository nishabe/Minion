//
//  CheckWeatherViewController.m
//  Minion
//

#import "CheckWeatherViewController.h"

@interface CheckWeatherViewController ()

@property (weak, nonatomic) IBOutlet UITextField *cityName;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation CheckWeatherViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.resultLabel.hidden = true;
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)checkWeatherTapped:(id)sender {
    if (self.cityName.text!=nil) {
        self.resultLabel.text = @"";
        self.errorLabel.text = @"";
        [self getWeatherInformationforZipcode];
    }
}
- (NSString*)formatResponse:(NSString*)response{
    NSString* finalResult = @"";
    NSArray* resultCollection = [response componentsSeparatedByString:@"<span class=\"phrase\">"];
    if (resultCollection.count>1) {
        NSString* summaryDescription = resultCollection[1];
        NSArray* summaryCollection = [summaryDescription componentsSeparatedByString:@"</span></span></span></p>"];
        finalResult = summaryCollection[0];
        finalResult = [finalResult stringByReplacingOccurrencesOfString:@"&deg;" withString:@"º"];
    }
    else{
        [self handleError];
    }
    return finalResult;
}
-(void)getWeatherInformationforZipcode {
    NSString *urlData = [NSString stringWithFormat:@"http://www.weather-forecast.com/locations/%@/forecasts/latest",[self.cityName.text stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
    NSURL *url = [NSURL URLWithString:urlData];
    if (url) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil ) {
                NSString * result = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // This block will be executed asynchronously on the main thread.
                    self.resultLabel.hidden = false;
                    self.resultLabel.text = [self formatResponse:result];
                });
            }
            else{
                [self handleError];
            }
        }];
        [dataTask resume];
    }
    else{
        [self handleError];
    }

}
- (void)handleError{
    dispatch_async(dispatch_get_main_queue(), ^{
        // This block will be executed asynchronously on the main thread.
        self.errorLabel.text = @"There was en error. Could not load result.";
    });
}
@end
