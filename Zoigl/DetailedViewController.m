//
//  DetailedViewController.m
//  Zoigl
//
//  Created by Frischholz Tobias on 03.01.12.
//  Copyright (c) 2012 Tobi. All rights reserved.
//

#import "DetailedViewController.h"

@implementation DetailedViewController

@synthesize zoigl, zoiglLabel, zoiglBusinessHours, mapView;
@synthesize relevantZoiglStubn, position;

- (IBAction)cancelView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)facebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        mySLComposerSheet = [[SLComposeViewController alloc] init];
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSArray *specificZoiglStubn = [relevantZoiglStubn objectAtIndex:position];
        NSString *specificZoiglStubnName = [specificZoiglStubn valueForKey:@"zoiglstubn"];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Heid gäje afn Zoigl: %@.", specificZoiglStubnName]];
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://bit.ly/wlwzaw"]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ja frale!!" message:@"Du moust bei Facebook agmeldt sa!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}


- (IBAction)twitter:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        mySLComposerSheet = [[SLComposeViewController alloc] init];
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSArray *specificZoiglStubn = [relevantZoiglStubn objectAtIndex:position];
        NSString *specificZoiglStubnName = [specificZoiglStubn valueForKey:@"zoiglstubn"];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Heid gäje afn #Zoigl: %@.", specificZoiglStubnName]];
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://bit.ly/wlwzaw"]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ja frale!!" message:@"Du moust bei Twitter agmeldt sa!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
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
                mapView.delegate = self;
                [mapView addAnnotation:annotation];
                [mapView setRegion:adjustedRegion animated:NO];
                [mapView selectAnnotation:annotation animated:YES];
            }
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSArray *specificZoiglStubn = [relevantZoiglStubn objectAtIndex:position];
    NSString *specificZoiglStubnName = [specificZoiglStubn valueForKey:@"zoiglstubn"];
    NSString *latitude = [specificZoiglStubn valueForKey:@"latitude"];
    NSString *longitude = [specificZoiglStubn valueForKey:@"longitude"];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [latitude doubleValue];
    zoomLocation.longitude = [longitude doubleValue];
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:zoomLocation addressDictionary:nil]];
    toLocation.name = specificZoiglStubnName;
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                 forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.relevantZoiglStubn = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
