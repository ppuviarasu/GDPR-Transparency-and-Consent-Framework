//
//  DebugViewController.h
//  ExampleAppNexusMobileSDKIntegration
//
//  Created by Abhishek.Sharma on 5/24/18.
//  Copyright © 2018 AppNexus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugViewController : UIViewController

@property (copy, nonatomic  ) NSDictionary *jsonRequestLog;
@property (copy, nonatomic) NSDictionary *jsonResponseLog;

@end
