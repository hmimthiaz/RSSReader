//
//  RSSListViewController.h
//  RSSReader
//
//  Created by Imthiaz Rafiq @hmimthiaz
//  http://imthi.com
//  https://github.com/hmimthiaz/RSSReader
//


#import <UIKit/UIKit.h>
#import "RSSParser.h"


@interface RSSListViewController : UITableViewController <RSSParserDelegate> {
    RSSParser * _rssParser;
}

- (id)initWithRSSURL:(NSString *)rssURL;

- (void)startActivity:(id)sender;

- (void)stopActivity:(id)sender;

@end
