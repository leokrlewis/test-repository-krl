//
//  AppDelegate.m
//  PictureMe
//
//  Created by Kenneth R. Lewis on 1/11/12.
//  Copyright (c) 2012 Killers Software. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "PictureViewController.h"

@interface AppDelegate () <ViewControllerDelegate, PictureViewControllerDelegate>
@property (nonatomic, retain) PictureViewController* editPicture;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize editPicture;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    } else {
        _viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    _viewController.delegate = self;
    _window.rootViewController = _viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)loadViewController {
    if (nil != editPicture) {
        editPicture.delegate = nil;
    }
    _viewController.delegate = self;
    _window.rootViewController = _viewController;
    [self.window makeKeyAndVisible];    
}

- (void)cancelledPictureView:(PictureViewController *)sender {
    [self loadViewController];
}

- (void)savedPictureView:(PictureViewController *)sender {
    [self loadViewController];
}

- (void)loadSelectedPicture {
    if (nil == editPicture) {
        editPicture = [[PictureViewController alloc] initWithNibName:@"PictureViewController" bundle:nil];
    }
    UIView* _view = editPicture.view;
    if (_view) { // force the view to load
        editPicture.imageView.image = _viewController.savedPicture;
        editPicture.delegate = self;
    }
    _viewController.delegate = nil;
    _window.rootViewController = editPicture;
    [self.window makeKeyAndVisible];
}

- (void)didSelectPicture:(ViewController *)sender {
    [self loadSelectedPicture];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
