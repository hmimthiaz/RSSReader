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
    NSMutableArray * viewControllers = [[NSMutableArray alloc] init];
    
    //plist file full path
    NSString * subscriptionListFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"RSS_Subscription.plist"];
    //Load plist file as dictionary
    NSDictionary * subscriptionList = [[NSDictionary alloc] initWithContentsOfFile:subscriptionListFile];
    //Get the folder array
    NSArray * subscriptionFolders = [subscriptionList objectForKey:@"Folders"];
    
    NewsListViewController * newsController = nil;
    UINavigationController * newsNavigationController = nil;
    for (NSDictionary * folderDetails in subscriptionFolders) {

        NSArray * newsItems = [folderDetails objectForKey:@"Items"];
        NSString * folderTitle = [folderDetails objectForKey:@"FolderName"];
        NSString * folderIcon = [folderDetails objectForKey:@"FolderIcon"];
        UIImage * folderIconImage = [UIImage imageNamed:folderIcon];

        newsController = [[NewsListViewController alloc] initWithNewsSourceList:newsItems];
        [newsController setTitle:folderTitle];
        
        newsNavigationController = [[UINavigationController alloc] initWithRootViewController:newsController];
        [newsNavigationController setTitle:folderTitle];
        [newsNavigationController.tabBarItem setImage:folderIconImage];
        
        [viewControllers addObject:newsNavigationController];
        [newsNavigationController release];
        [newsController release];
    }
    [self.tabBarController setViewControllers:viewControllers];
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
