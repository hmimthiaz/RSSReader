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

@synthesize newsSourceList = _newsSourceList;

- (id)initWithNewsSourceList:(NSArray * )list {
    self = [super initWithNibName:@"NewsListViewController" bundle:nil];
    if (self) {
        self.newsSourceList = list;
    }
    return self;
}

- (void)dealloc{
    self.newsSourceList = nil;
    
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
    [cell.textLabel setText:[newsSourceItem objectForKey:@"BlogTitle"]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary * newsSourceItem = (NSDictionary *)[_newsSourceList objectAtIndex:indexPath.row];
    
    
    RSSListViewController * rssListViewController = [[RSSListViewController alloc] initWithRSSURL:[newsSourceItem objectForKey:@"BlogURL"]];
    [rssListViewController setTitle:[newsSourceItem objectForKey:@"BlogTitle"]];
    
    [self.navigationController pushViewController:rssListViewController animated:YES];
    [rssListViewController release];
}

@end
