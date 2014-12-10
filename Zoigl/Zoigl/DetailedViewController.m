//
//  DetailedViewController.m
//  Zoigl
//
//  Created by Frischholz Tobias on 03.01.12.
//  Copyright (c) 2012 Tobi. All rights reserved.
//

#import "DetailedViewController.h"
#import <Twitter/Twitter.h>

@implementation DetailedViewController

@synthesize zoigl, zoiglLabel, zoiglBusinessHours, mapView;
@synthesize relevantZoiglStubn, position;

- (IBAction)cancelView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)facebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        
        NSArray *specificZoiglStubn = [relevantZoiglStubn objectAtIndex:position];
        NSString *specificZoiglStubnName = [specificZoiglStubn valueForKey:@"zoiglstubn"];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Heid gäje afn Zoigl: %@.", specificZoiglStubnName]];
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://bit.ly/wlwzaw"]];
        
//        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Test", mySLComposerSheet.serviceType]]; //the message you want to post
//        [mySLComposerSheet addImage:yourimage]; //an image you could post
        //for more instance methodes, go here:https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Reference/SLComposeViewController_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40012205
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Obrocha!";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Sauba!";
                break;
            default:
                break;
        } //check if everythink worked properly. Give out a message on the state.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
}
    
- (IBAction)twitter:(id)sender {
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    NSArray *specificZoiglStubn = [relevantZoiglStubn objectAtIndex:position];
    NSString *specificZoiglStubnName = [specificZoiglStubn valueForKey:@"zoiglstubn"];
    [twitter setInitialText:[NSString stringWithFormat:@"Heid gäje afn #Zoigl: %@.", specificZoiglStubnName]];
    [twitter addURL:[NSURL URLWithString:@"http://bit.ly/wlwzaw"]];
    
    if ([TWTweetComposeViewController canSendTweet]) {
        [self presentViewController:twitter animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gäjd niad!" message:@"Du houst grod koi Netzweakvabindung!" delegate:nil cancelButtonTitle:@"Ja mei" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
    /*    if (TWTweetComposeViewControllerResultDone) {
            UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:@"Sauguad!" message:@"Dei Tweet is fuat!" delegate:nil cancelButtonTitle:@"Lou me z'ruck!" otherButtonTitles:nil];
            [doneAlert show];
        } else if (TWTweetComposeViewControllerResultCancelled) {
            UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"Zefix!" message:@"Dou houd wos niad hieg'haut!" delegate:nil cancelButtonTitle:@"Mei!" otherButtonTitles:nil];
            [cancelAlert show];
        }*/
        [self dismissModalViewControllerAnimated:YES];
    };
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.layer.cornerRadius = 10.0;

    zoigl.image = [UIImage imageNamed:@"beer.png"];
    zoiglLabel.font = [UIFont fontWithName:@"WetArial-Black" size:32];
    
    NSArray *specificZoiglStubn = [relevantZoiglStubn objectAtIndex:position];
    NSString *specificZoiglStubnName = [specificZoiglStubn valueForKey:@"zoiglstubn"];
    NSString *specificZoiglStubnNameUpperCase = [specificZoiglStubnName uppercaseString];
    zoiglLabel.text = specificZoiglStubnNameUpperCase;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM."];
        
    NSDate *startDate = [specificZoiglStubn valueForKey:@"beginn"];
    NSString *startDateFormatted = [dateFormatter stringFromDate:startDate];
    NSDate *endDate = [specificZoiglStubn valueForKey:@"ende"];
    NSString *endDateFormatted = [dateFormatter stringFromDate:endDate];
    
    if (![startDateFormatted isEqualToString:endDateFormatted]) {
        NSString *separator = @"-";
        NSString *dateRange = [NSString stringWithFormat:@"%@ %@ %@", startDateFormatted, separator, endDateFormatted];
        
        zoiglBusinessHours.text = dateRange;
    }
    
    else {
        zoiglBusinessHours.text = startDateFormatted;
    }
    
    NSString *latitude = [specificZoiglStubn valueForKey:@"latitude"];
    NSString *longitude = [specificZoiglStubn valueForKey:@"longitude"];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [latitude doubleValue];
    zoomLocation.longitude = [longitude doubleValue];

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:zoomLocation.latitude longitude:zoomLocation.longitude];
    __block NSString *street;
    __block NSString *town;
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                street = [NSString stringWithFormat:@"%@ %@", placemark.thoroughfare, placemark.subThoroughfare];
                town = [NSString stringWithFormat:@"%@ %@", placemark.postalCode, placemark.locality];
                MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinate:zoomLocation placeName:street description:town];
                [mapView addAnnotation:annotation];
                [mapView setRegion:adjustedRegion animated:YES];
                [mapView selectAnnotation:annotation animated:YES];
            }
        }
    }];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
