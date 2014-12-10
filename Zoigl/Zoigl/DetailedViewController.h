//
//  DetailedViewController.h
//  Zoigl
//
//  Created by Frischholz Tobias on 03.01.12.
//  Copyright (c) 2012 Tobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MyAnnotation.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#define METERS_PER_MILE 1609.344

@interface DetailedViewController : UIViewController {
    SLComposeViewController *mySLComposerSheet;
}

@property (nonatomic, retain) IBOutlet UIImageView *zoigl;
@property (nonatomic, retain) IBOutlet UILabel *zoiglLabel;
@property (nonatomic, retain) IBOutlet UILabel *zoiglBusinessHours;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) NSArray *relevantZoiglStubn;
@property (nonatomic) NSInteger position;

- (IBAction)cancelView:(id)sender;
- (IBAction)twitter:(id)sender;
- (IBAction)facebook:(id)sender;

@end
