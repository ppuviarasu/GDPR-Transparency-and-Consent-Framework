//
//  AppDelegate.h
//  ExampleAppNexusMobileSDKIntegration
//




#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate , CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite) CLLocationManager *locationManager;


@end

