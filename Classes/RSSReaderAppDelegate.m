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

@synthesize navigationController = _navigationController;
@synthesize newsViewController = _newsViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    self.newsViewController = [[[NewsListViewController alloc] initWithNibName:@"NewsListViewController"
                                                                        bundle:nil] autorelease]; 
    
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:self.newsViewController] autorelease];
    
    [self.window addSubview:self.navigationController.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc{
    
    self.newsViewController = nil;

    self.navigationController = nil;
    
    [_window release];
    [super dealloc];
}

@end
