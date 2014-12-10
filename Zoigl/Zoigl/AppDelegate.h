//
//  AppDelegate.h
//  Zoigl
//
//  Created by Frischholz Tobias on 02.01.12.
//  Copyright (c) 2012 Tobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Zoigl.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSDate *today;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray *)getRelevantZoiglStubn;

@end
