//
//  BrowserViewController.h
//  RSSReader
//
//  Created by Imthiaz Rafiq @hmimthiaz
//  http://imthi.com
//  https://github.com/hmimthiaz/RSSReader
//


#import <UIKit/UIKit.h>


@interface BrowserViewController : UIViewController <UIWebViewDelegate> {
    UIWebView * _webview;
    NSURLRequest * _loadRequest;
}

@property (nonatomic, retain) IBOutlet UIWebView * webview;

@property (nonatomic, retain) NSURLRequest * loadRequest;

- (id)initWithLoadRequest:(NSURLRequest *)request;

- (void)startActivity:(id)sender;

- (void)stopActivity:(id)sender;


@end
