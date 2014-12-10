//
//  MyAnnotation.m
//  Zoigl
//
//  Created by Frischholz Tobias on 04.01.12.
//  Copyright (c) 2012 Tobi. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate, title, subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord placeName:(NSString *)place description:(NSString *)description {
    coordinate = coord;
    title = place;
    subtitle = description;
    return self;
}

@end
