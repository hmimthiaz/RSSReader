//
//  RSSReaderAppDelegate.h
//  RSSReader
//
//  Created by Imthiaz Rafiq @hmimthiaz
//  http://imthi.com
//  https://github.com/hmimthiaz/RSSReader
//


#import <UIKit/UIKit.h>

@interface RSSReaderAppDelegate : NSObject <UIApplicationDelegate> {
    UITabBarController * _tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow * window;
@property (nonatomic, retain) UITabBarController * tabBarController;

@end
