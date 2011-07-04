//
//  RSSReaderAppDelegate.m
//  RSSReader
//
//  Created by Imthiaz Rafiq @hmimthiaz
//  http://imthi.com
//  https://github.com/hmimthiaz/RSSReader
//


#import "RSSReaderAppDelegate.h"
#import "RSSParser.h"
#import "NewsListViewController.h"

@implementation RSSReaderAppDelegate


@synthesize window=_window;

@synthesize tabBarController = _tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    
    
    NewsListViewController * newsController = [[NewsListViewController alloc] initWithNibName:@"NewsListViewController" bundle:nil];
    
    UINavigationController * newsNavigationController = [[UINavigationController alloc] initWithRootViewController:newsController];
    [self.tabBarController setViewControllers:[NSArray arrayWithObject:newsNavigationController]];

    [newsNavigationController release];
    [newsController release];
     
    [self.window addSubview:self.tabBarController.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc{
    
    self.tabBarController = nil;
    
    [_window release];
    [super dealloc];
}

@end
