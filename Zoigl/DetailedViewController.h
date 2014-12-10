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

@interface DetailedViewController : UIViewController <MKAnnotation, MKMapViewDelegate> {
    SLComposeViewController *mySLComposerSheet;
}

@property (weak, nonatomic) IBOutlet UIImageView *zoigl;
@property (weak, nonatomic) IBOutlet UILabel *zoiglLabel;
@property (weak, nonatomic) IBOutlet UILabel *zoiglBusinessHours;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *relevantZoiglStubn;
@property (nonatomic) NSInteger position;

- (IBAction)cancelView:(id)sender;
- (IBAction)twitter:(id)sender;
- (IBAction)facebook:(id)sender;

@end
