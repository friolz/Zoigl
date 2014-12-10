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

@property (strong, nonatomic) NSDate * beginn;
@property (strong, nonatomic) NSString * latitude;
@property (strong, nonatomic) NSString * longitude;
@property (strong, nonatomic) NSString * ort;
@property (strong, nonatomic) NSString * zoiglstubn;
@property (strong, nonatomic) NSDate * ende;

@end
