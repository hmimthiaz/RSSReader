//
//  NewsListViewController.h
//  RSSReader
//
//  Created by Imthiaz Rafiq @hmimthiaz
//  http://imthi.com
//  https://github.com/hmimthiaz/RSSReader
//

#import <UIKit/UIKit.h>


@interface NewsListViewController : UITableViewController {
    NSArray * _newsSourceList;
}

@property (nonatomic, retain) NSArray * newsSourceList;

- (id)initWithNewsSourceList:(NSArray * )list ;

@end
