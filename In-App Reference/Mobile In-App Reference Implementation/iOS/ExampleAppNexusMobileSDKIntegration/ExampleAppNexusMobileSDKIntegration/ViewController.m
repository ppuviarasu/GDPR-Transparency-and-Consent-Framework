//
//  ViewController.m
//  ExampleAppNexusMobileSDKIntegration
//




#import "ViewController.h"
#import <CMPReference/CMPStorage.h>
#import <CMPReference/CMPConsentViewController.h>
#import <AppNexusSDK/ANBannerAdView.h>
#import <CoreLocation/CoreLocation.h>
#import <AppNexusSDK/ANLocation.h>
#import <AppNexusSDK/ANLogManager.h>
#import "DebugViewController.h"
#import <AppNexusSDK/ANGlobal.h>
@interface ViewController () <CMPConsentViewControllerDelegate , ANBannerAdViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *GDPRConsentStringLabel;
@property (nonatomic, readwrite, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet ANBannerAdView *bannerAdView;
@property (weak, nonatomic) IBOutlet UIButton *btDebugOutlet;

@property (strong, nonatomic) NSDictionary *jsonRequestLog;
@property (strong, nonatomic) NSDictionary *jsonResponseLog;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ANLogManager setANLogLevel:ANLogLevelAll];
    
    ANSetNotificationsEnabled(YES);

    CMPStorage *consentStorageVC = [[CMPStorage alloc] init];
    if(consentStorageVC.cmpPresent  && consentStorageVC.consentString.length != 0){
        self.GDPRConsentStringLabel.text = consentStorageVC.consentString;
    }
    
    
    self.btDebugOutlet.userInteractionEnabled = false;
    [self addObserver];
    
}
-(void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kANUniversalAdFetcherWillRequestAdNotification:) name:@"kANUniversalAdFetcherWillRequestAdNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kANUniversalAdFetcherDidReceiveResponseNotification:) name:@"kANUniversalAdFetcherDidReceiveResponseNotification" object:nil];
}

- (void)kANUniversalAdFetcherWillRequestAdNotification:(NSNotification *)notification {
    NSLog(@"Received Notification - Someone seems to have logged in");
    NSDictionary *userInfo = [notification  userInfo];
    self.jsonRequestLog = userInfo;
    self.btDebugOutlet.userInteractionEnabled = true;
    
}

- (void)kANUniversalAdFetcherDidReceiveResponseNotification:(NSNotification *)notification {
    NSLog(@"Received Notification - Someone seems to have logged in");
    NSDictionary *userInfo = [notification  userInfo];
    self.jsonResponseLog = userInfo;
    
    
    
}



- (IBAction)showGDPRConsentTool:(id)sender {

    CMPConsentViewController *consentToolVC = [[CMPConsentViewController alloc] init];
    // Both the Android and iOS versions are implemented as a wrapper around modified Web CMP reference.
    // Instruction on how to install and configure the WebCMP JS reference can be found inside the reference folder of this repo.
    // This example uses a demo page setup using the same instructions.
    consentToolVC.cmpSettings.cmpURL = @"https://acdn.adnxs.com/mobile/democmp/docs/mobilecomplete.html";
    consentToolVC.cmpSettings.subjectToGDPR = @"1";
    consentToolVC.cmpSettings.cmpPresent = YES;
    consentToolVC.delegate = self;
    [self presentViewController:consentToolVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark CMPConsentToolViewController delegate
-(void)consentToolViewController:(CMPConsentViewController *)consentToolViewController didReceiveConsentString:(NSString *)consentString {
    [consentToolViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.GDPRConsentStringLabel.text = consentString;
    
    NSLog(@"CMPConsentToolViewControllerDelegate - didReceiveConsentString: %@", consentString);
    NSLog(@"IsSubjectToGDPR from CMPDataStorage: %ld", (long)consentToolViewController.cmpSettings.subjectToGDPR);
    NSLog(@"ConsentString from CMPDataStorage: %@", consentToolViewController.cmpSettings.consentString);
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
#pragma mark - Button's Action

- (IBAction)btLoanAppNexusAdAction:(id)sender {
    [self loadAppNexusBannerAd];
    
}
#pragma mark - Load Banner Ad Using AppNexus Ads

- (void)loadAppNexusBannerAd
{
    
    int adWidth  = 300;
    int adHeight = 250;
    NSString *adID = @"1281482";
    
    // We want to center our ad on the screen.
    CGFloat originX = self.bannerAdView.frame.origin.x;
    CGFloat originY = self.bannerAdView.frame.origin.y;
    
    // Needed for when we create our ad view.
    CGRect rect = CGRectMake(originX, originY, adWidth, adHeight);
    CGSize size = CGSizeMake(adWidth, adHeight);
    
    // Make a banner ad view.
    ANBannerAdView *banner = [ANBannerAdView adViewWithFrame:rect placementId:adID adSize:size];
    banner.rootViewController = self;
    banner.delegate = self;
    [self.view addSubview:banner];
    
    // Since this example is for testing, we'll turn on PSAs and verbose logging.
    banner.shouldServePublicServiceAnnouncements = true;
    [ANLogManager setANLogLevel:ANLogLevelDebug];
    
    // Load an ad.
    [banner loadAd];
    
    [self locationSetup]; // If you want to pass location...
    self.bannerAdView = banner;
    
}

- (void)locationSetup {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

// We implement the delegate method from the `CLLocationManagerDelegate` protocol.  This allows
// us to update the banner's location whenever the device's location is updated.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    self.bannerAdView.location = [ANLocation getLocationWithLatitude:location.coordinate.latitude
                                                           longitude:location.coordinate.longitude
                                                           timestamp:location.timestamp
                                                  horizontalAccuracy:location.horizontalAccuracy];
}

- (void)adDidReceiveAd:(id<ANAdProtocol>)ad {
    NSLog(@"Ad did receive ad");
    NSLog(@"Creative Id %@",ad.creativeId);
}


- (void)adDidClose:(id<ANAdProtocol>)ad {
    NSLog(@"Ad did close");
}

- (void)adWasClicked:(id<ANAdProtocol>)ad {
    NSLog(@"Ad was clicked");
}

- (void)ad:(id<ANAdProtocol>)ad requestFailedWithError:(NSError *)error {
    NSLog(@"Ad failed to load: %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btDebugAppNexusAdAction:(id)sender {
    [self performSegueWithIdentifier:@"ShowDebugView" sender:self];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowDebugView"])
    {
        DebugViewController *vc = [segue destinationViewController];
        [vc setJsonRequestLog:self.jsonRequestLog];
        [vc setJsonResponseLog:self.jsonResponseLog];

    }
}


@end
