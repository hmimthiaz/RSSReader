//
//  NewsListViewController.m
//  RSSReader
//
//  Created by Imthiaz Rafiq @hmimthiaz
//  http://imthi.com
//  https://github.com/hmimthiaz/RSSReader
//


#import "NewsListViewController.h"
#import "RSSListViewController.h"

@implementation NewsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"RSS Reader";
        _newsSourceList = [[NSMutableArray alloc] init];
        
        NSDictionary * newsSourceItem;
        newsSourceItem = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"BBC Top Stories",@"http://feeds.bbci.co.uk/news/rss.xml", nil]
                                                     forKeys:[NSArray arrayWithObjects:@"title",@"url",nil]];
        [_newsSourceList addObject:newsSourceItem];

        newsSourceItem = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"UAE News",@"http://gulfnews.com/cmlink/1.446094", nil]
                                                     forKeys:[NSArray arrayWithObjects:@"title",@"url",nil]];
        [_newsSourceList addObject:newsSourceItem];
        
        newsSourceItem = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"The Unofficial Apple Weblog",@"http://www.tuaw.com/rss.xml", nil]
                                                     forKeys:[NSArray arrayWithObjects:@"title",@"url",nil]];
        [_newsSourceList addObject:newsSourceItem];

        newsSourceItem = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Engadget",@"http://www.engadget.com/rss.xml", nil]
                                                     forKeys:[NSArray arrayWithObjects:@"title",@"url",nil]];
        [_newsSourceList addObject:newsSourceItem];

        newsSourceItem = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Flip Media Blog",@"http://www.flipcorp.com/en/section/read/blog/feed", nil]
                                                     forKeys:[NSArray arrayWithObjects:@"title",@"url",nil]];
        [_newsSourceList addObject:newsSourceItem];
        
        newsSourceItem = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"imthi.com",@"http://feeds.feedburner.com/hmimthiaz", nil]
                                                     forKeys:[NSArray arrayWithObjects:@"title",@"url",nil]];
        [_newsSourceList addObject:newsSourceItem];
 
    }
    return self;
}

- (void)dealloc{
    [_newsSourceList release];
    _newsSourceList = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [_newsSourceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary * newsSourceItem = (NSDictionary *)[_newsSourceList objectAtIndex:indexPath.row];
    [cell.textLabel setText:[newsSourceItem objectForKey:@"title"]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary * newsSourceItem = (NSDictionary *)[_newsSourceList objectAtIndex:indexPath.row];
    
    
    RSSListViewController * rssListViewController = [[RSSListViewController alloc] initWithRSSURL:[newsSourceItem objectForKey:@"url"]];
    [rssListViewController setTitle:[newsSourceItem objectForKey:@"title"]];
    
    [self.navigationController pushViewController:rssListViewController animated:YES];
    [rssListViewController release];
}

@end
