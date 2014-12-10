//
//  MyAnnotation.h
//  Zoigl
//
//  Created by Frischholz Tobias on 04.01.12.
//  Copyright (c) 2012 Tobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord placeName:(NSString *)place description:(NSString *)description;

@end
