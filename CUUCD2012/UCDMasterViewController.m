//
//  UCDMasterViewController.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDMasterViewController.h"
#import "UCDAppDelegate.h"
#import "UCDStyleManager.h"
#import "UCDPlacesViewController.h"
#import "UCDSettingsViewController.h"

NSString * const UCDMasterViewControllerCellReuseIdentifier = @"MasterViewControllerCellReuseIdentifier";

typedef NS_ENUM(NSUInteger, UCDMasterViewControllerTableViewSectionType) {
    UCDMasterViewControllerTableViewSectionTypePing,
    UCDMasterViewControllerTableViewSectionTypeSettings,
    UCDMasterViewControllerTableViewSectionTypeCount,
};

@interface UCDMasterViewController ()

@property (nonatomic, strong) NSDictionary *paneViewControllerTitles;
@property (nonatomic, strong) NSDictionary *paneViewControllerClasses;
@property (nonatomic, strong) NSArray *tableViewSectionBreaks;

@end

@implementation UCDMasterViewController

#pragma mark - UIViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.paneViewControllerType = NSUIntegerMax;
        self.paneViewControllerTitles = @{
            @(UCDPaneViewControllerTypePlaces) : @"Places",
            @(UCDPaneViewControllerTypeSettings) : @"Settings",
        };
        self.paneViewControllerClasses = @{
            @(UCDPaneViewControllerTypePlaces) : UCDPlacesViewController.class,
            @(UCDPaneViewControllerTypeSettings) : UCDSettingsViewController.class,
        };
        self.tableViewSectionBreaks = @[
            @(UCDPaneViewControllerTypeSettings),
            @(UCDPaneViewControllerTypeCount)
        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:UCDMasterViewControllerCellReuseIdentifier];
}

#pragma mark - UCDMasterViewController

- (UCDPaneViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath *)indexPath
{
    UCDPaneViewControllerType paneViewControllerType;
    if (indexPath.section == 0) {
        paneViewControllerType = indexPath.row;
    } else {
        paneViewControllerType = [self.tableViewSectionBreaks[indexPath.section - 1] integerValue] + indexPath.row;
    }
    NSAssert(paneViewControllerType < UCDPaneViewControllerTypeCount, @"Invalid Index Path");
    return paneViewControllerType;
}

- (void)transitionToViewController:(UCDPaneViewControllerType)paneViewControllerType
{
    if (paneViewControllerType == self.paneViewControllerType) {
        [self.navigationPaneViewController setPaneState:MSNavigationPaneStateClosed animated:YES];
        return;
    }
    
    BOOL animateTransition = self.navigationPaneViewController.paneViewController != nil;
    
    Class paneViewControllerClass = self.paneViewControllerClasses[@(paneViewControllerType)];
    NSParameterAssert([paneViewControllerClass isSubclassOfClass:UIViewController.class]);
    UIViewController *paneViewController = (UIViewController *)[[paneViewControllerClass alloc] init];
    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    __weak typeof(self) blockSelf = self;
    paneViewController.navigationItem.leftBarButtonItem = [[UCDStyleManager sharedManager] barButtonItemWithImage:[UIImage imageNamed:@"MSBarButtonIconNavigationPane.png"] action:^{
        [blockSelf.navigationPaneViewController setPaneState:MSNavigationPaneStateOpen animated:YES];
    }];
    
    if ([paneViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
        [paneViewController performSelector:@selector(setManagedObjectContext:) withObject:[[UCDAppDelegate sharedAppDelegate] managedObjectContext]];
    }
    
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    
    [self.navigationPaneViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    
    self.paneViewControllerType = paneViewControllerType;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return UCDMasterViewControllerTableViewSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.tableViewSectionBreaks[section] integerValue];
    } else {
        return ([self.tableViewSectionBreaks[section] integerValue] - [self.tableViewSectionBreaks[(section - 1)] integerValue]);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case UCDMasterViewControllerTableViewSectionTypePing:
            return @"Ping";
        case UCDMasterViewControllerTableViewSectionTypeSettings:
            return @"Configuration";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UCDMasterViewControllerCellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.paneViewControllerTitles[@([self paneViewControllerTypeForIndexPath:indexPath])];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self transitionToViewController:[self paneViewControllerTypeForIndexPath:indexPath]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end