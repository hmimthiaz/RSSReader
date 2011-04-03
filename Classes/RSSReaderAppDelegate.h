//
//  RSSReaderAppDelegate.h
//  RSSReader
//
//  Created by Imthiaz Rafiq @hmimthiaz
//  http://imthi.com
//  https://github.com/hmimthiaz/RSSReader
//


#import <UIKit/UIKit.h>
#import "RSSParser.h"

@class NewsListViewController;

@interface RSSReaderAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController * _navigationController;
    NewsListViewController * _newsViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow * window;

@property (nonatomic, retain) UINavigationController * navigationController;

@property (nonatomic, retain) NewsListViewController * newsViewController;

@end
