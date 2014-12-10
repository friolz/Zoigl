//
//  Zoigl.h
//  Zoigl
//
//  Created by Frischholz Tobias on 06.01.12.
//  Copyright (c) 2012 Tobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Zoigl : NSManagedObject

@property (nonatomic, retain) NSDate * beginn;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * ort;
@property (nonatomic, retain) NSString * zoiglstubn;
@property (nonatomic, retain) NSDate * ende;

@end
