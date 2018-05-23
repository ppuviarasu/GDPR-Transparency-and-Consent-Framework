//
//  ViewController.m
//  ExampleAppNexusMobileSDKIntegration
//




#import "ViewController.h"
#import <CMPReference/CMPStorage.h>
#import <CMPReference/CMPConsentViewController.h>




@interface ViewController () <CMPConsentViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *GDPRConsentStringLabel;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CMPStorage *consentStorageVC = [[CMPStorage alloc] init];
    if(consentStorageVC.cmpPresent  && consentStorageVC.consentString.length != 0){
        self.GDPRConsentStringLabel.text = consentStorageVC.consentString;
    }
}

- (IBAction)showGDPRConsentTool:(id)sender {

    CMPConsentViewController *consentToolVC = [[CMPConsentViewController alloc] init];
    consentToolVC.consentToolAPI.cmpURL = @"https://acdn.adnxs.com/mobile/democmp/docs/mobilecomplete.html";
    consentToolVC.consentToolAPI.subjectToGDPR = @"1";
    consentToolVC.consentToolAPI.cmpPresent = YES;
    consentToolVC.delegate = self;
    [self presentViewController:consentToolVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark CMPConsentToolViewController delegate
-(void)consentToolViewController:(CMPConsentViewController *)consentToolViewController didReceiveConsentString:(NSString *)consentString {
    [consentToolViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.GDPRConsentStringLabel.text = consentString;
    
    NSLog(@"CMPConsentToolViewControllerDelegate - didReceiveConsentString: %@", consentString);
    NSLog(@"IsSubjectToGDPR from CMPDataStorage: %ld", (long)consentToolViewController.consentToolAPI.subjectToGDPR);
    NSLog(@"ConsentString from CMPDataStorage: %@", consentToolViewController.consentToolAPI.consentString);
}

- (void)consentToolViewController:(CMPConsentViewController *)consentToolViewController didReceiveURL:(NSURL *)url{
    
    UIApplication *application = [UIApplication sharedApplication];
    if (@available(iOS 10.0, *)) {
        [application openURL:url options:@{} completionHandler:nil];
    } else {
        // Fallback on earlier versions
        [[UIApplication sharedApplication] openURL:url];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
