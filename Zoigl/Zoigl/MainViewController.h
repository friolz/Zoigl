//
//  MainViewController.h
//  Zoigl
//
//  Created by Frischholz Tobias on 02.01.12.
//  Copyright (c) 2012 Tobi. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailedViewController.h"

#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    CGPoint tableViewPosition;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIImageView *background;
@property (nonatomic, retain) IBOutlet UIImageView *sheets;
@property (nonatomic, retain) IBOutlet UIImageView *bierfilzl;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)reloadUI;

@end