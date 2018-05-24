//
//  DebugViewController.m
//  ExampleAppNexusMobileSDKIntegration
//
//  Created by Abhishek.Sharma on 5/24/18.
//  Copyright © 2018 AppNexus. All rights reserved.
//

#import "DebugViewController.h"

@interface DebugViewController ()

@property (weak, nonatomic) IBOutlet UITextView *lbLogViewOutelt;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation DebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLog];
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)btSegmentAction:(id)sender {
    [self loadLog];
}

NSString * const  kANUniversalAdFetcherWillRequestAdNotification                 = @"kANUniversalAdFetcherWillRequestAdNotification";
NSString * const  kANUniversalAdFetcherAdRequestURLKey                           = @"kANUniversalAdFetcherAdRequestURLKey";
NSString * const  kANUniversalAdFetcherWillInstantiateMediatedClassNotification  = @"kANUniversalAdFetcherWillInstantiateMediatedClassNotification";
NSString * const  kANUniversalAdFetcherMediatedClassKey                          = @"kANUniversalAdFetcherMediatedClassKey";

NSString * const  kANUniversalAdFetcherDidReceiveResponseNotification            = @"kANUniversalAdFetcherDidReceiveResponseNotification";
NSString * const  kANUniversalAdFetcherAdResponseKey                             = @"kANUniversalAdFetcherAdResponseKey";

-(void)loadLog{
    
    NSString* json = @"";
    if(self.jsonRequestLog != nil && self.jsonResponseLog != nil){
        if (_segmentedControl.selectedSegmentIndex == 0) {
            json = self.jsonRequestLog[@"kANUniversalAdFetcherAdRequestURLKey"];// [self.jsonRequestLog objectForKey:@"kANUniversalAdFetcherAdRequestURLKey"];
            json = [json stringByReplacingOccurrencesOfString:@"http://mediation.adnxs.com/ut/v2 /n" withString:@""];
        } else if(_segmentedControl.selectedSegmentIndex == 1) {
            json = self.jsonResponseLog[@"kANUniversalAdFetcherAdResponseKey"];
        }
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonLog = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.lbLogViewOutelt.text = [NSString stringWithFormat:@"%@",jsonLog];
    }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
