//
//  AppDelegate.m
//  Zoigl
//
//  Created by Frischholz Tobias on 02.01.12.
//  Copyright (c) 2012 Tobi. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize today = _today;

- (NSArray *)getRelevantZoiglStubn {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Zoigl" inManagedObjectContext:__managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];

    NSSortDescriptor *datesAscending = [[NSSortDescriptor alloc] initWithKey:@"beginn" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:datesAscending];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *dateString = [dateFormatter stringFromDate:self.today];
    NSDate *dateWithoutTime = [dateFormatter dateFromString:dateString];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(beginn <= %@ && ende >= %@)", dateWithoutTime, dateWithoutTime];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *relevantZoiglStubn = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return relevantZoiglStubn;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    MainViewController *controller = (MainViewController *)self.window.rootViewController;
    controller.managedObjectContext = self.managedObjectContext;
    
    self.today = [NSDate date];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            UIStoryboard *iPhoneStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            UIViewController *initialViewController = [iPhoneStoryboard instantiateInitialViewController];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController  = initialViewController;
            [self.window makeKeyAndVisible];
        }
        if(result.height == 568)
        {
            UIStoryboard *iPhone5Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard5" bundle:nil];
            UIViewController *initialViewController = [iPhone5Storyboard instantiateInitialViewController];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController  = initialViewController;
            [self.window makeKeyAndVisible];
        }
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.today = [NSDate date];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Zoigl" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Zoigl.sqlite"];
    NSString *storeString = [[NSBundle mainBundle] pathForResource:@"Zoigl" ofType:@"sqlite"];
    NSURL *storeURL = [NSURL fileURLWithPath:storeString];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
