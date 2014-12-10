//
//  MainViewController.m
//  Zoigl
//
//  Created by Frischholz Tobias on 02.01.12.
//  Copyright (c) 2012 Tobi. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize background, sheets, bierfilzl;
@synthesize dateLabel = _dateLabel;

- (void)reloadUI {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 180, 260, 250) style:UITableViewStylePlain];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *deLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
            [dateFormatter setLocale:deLocale];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            NSString *dateString = [dateFormatter stringFromDate:delegate.today];
            self.dateLabel.text = dateString;
            
            NSArray *relevantZoiglStubn;
            relevantZoiglStubn = [delegate getRelevantZoiglStubn];
            if ([relevantZoiglStubn count] != 0) {
                [self.view addSubview:tableView];
                tableView.dataSource = self;
                tableView.delegate = self;
                tableView.contentOffset = tableViewPosition;
            }
            else {
                [self.view addSubview:tableView];
                tableView.dataSource = self;
                tableView.delegate = self;
                tableView.contentOffset = tableViewPosition;
                bierfilzl.image = [UIImage imageNamed:@"0zoiglstubn.png"];
            }
        }
        if(result.height == 568)
        {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 180, 260, 340) style:UITableViewStylePlain];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *deLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
            [dateFormatter setLocale:deLocale];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            NSString *dateString = [dateFormatter stringFromDate:delegate.today];
            self.dateLabel.text = dateString;
            
            NSArray *relevantZoiglStubn;
            relevantZoiglStubn = [delegate getRelevantZoiglStubn];
            
            if ([relevantZoiglStubn count] != 0) {
                [self.view addSubview:tableView];
                tableView.dataSource = self;
                tableView.delegate = self;
                tableView.contentOffset = tableViewPosition;
            }
            else {
                [self.view addSubview:tableView];
                tableView.dataSource = self;
                tableView.delegate = self;
                tableView.contentOffset = tableViewPosition;
                bierfilzl.image = [UIImage imageNamed:@"0zoiglstubn.png"];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *relevantZoiglStubn;
    relevantZoiglStubn = [delegate getRelevantZoiglStubn];
    NSString *filename = [NSString stringWithFormat:@"%dzoiglstubn.png", [relevantZoiglStubn count]];
    if ([relevantZoiglStubn count] != 0) {
        if ([relevantZoiglStubn count] < 13) {
            bierfilzl.image = [UIImage imageNamed:filename];
        }
        else {
            bierfilzl.image = [UIImage imageNamed:@"sauvuelzoiglstubn.png"];
        }
    }
    
    return [relevantZoiglStubn count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *relevantZoiglStubn = [delegate getRelevantZoiglStubn];
    NSArray *zoiglStubn = [relevantZoiglStubn valueForKey:@"zoiglstubn"];
    NSString *specificZoiglStubn = [zoiglStubn objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", specificZoiglStubn];
    
    NSArray *ort = [relevantZoiglStubn valueForKey:@"ort"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [ort objectAtIndex:indexPath.row]];
    
    tableViewPosition = tableView.contentOffset;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailedViewController *detailedViewController = [[DetailedViewController alloc] init];
    detailedViewController = [[DetailedViewController alloc] initWithNibName:@"DetailedViewController" bundle:nil];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *relevantZoiglStubn = [delegate getRelevantZoiglStubn];
    
    detailedViewController.relevantZoiglStubn = relevantZoiglStubn;
    detailedViewController.position = indexPath.row;
    
    [self presentModalViewController:detailedViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            background.image = [UIImage imageNamed:@"newWood.png"];
        }
        if(result.height == 568)
        {
            background.image = [UIImage imageNamed:@"newWoodiPhone5.png"];
        }
    }
    
    
    sheets.image = [UIImage imageNamed:@"sheetsOfPaper.png"];
    
//    [self reloadUI];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUI) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidUnload
{
    [self setDateLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadUI];
}

- (void)viewDidAppear:(BOOL)animated
{   
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
