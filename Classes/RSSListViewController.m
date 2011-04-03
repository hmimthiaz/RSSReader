//
//  RSSListViewController.m
//  RSSReader
//
//  Created by Imthiaz Rafiq @hmimthiaz
//  http://imthi.com
//  https://github.com/hmimthiaz/RSSReader
//


#import "RSSListViewController.h"

#import "RSSParser.h"
#import "RSSItem.h"

#import "BrowserViewController.h"

@implementation RSSListViewController

- (id)initWithRSSURL:(NSString *)rssURL{
    self = [super initWithNibName:@"RSSListViewController" bundle:nil];
    if (self) {
        _rssParser = [[RSSParser alloc] initWithRSSURL:rssURL];
    }
    return self;
}

- (void)dealloc{
    
    [_rssParser release];
    _rssParser = nil;

    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark RSSParserDelegate

-(void)RSSParserDidCompleteParsing{
    [self.tableView reloadData];
    [self stopActivity:nil];
}

-(void)RSSParserHasError:(NSError *)error{
    [self stopActivity:nil];
}


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];

    //Create an instance of activity indicator view
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    //set the initial property
    [activityIndicator stopAnimating];
    [activityIndicator hidesWhenStopped];
    //Create an instance of Bar button item with custome view which is of activity indicator
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    //Set the bar button the navigation bar
    [self navigationItem].rightBarButtonItem = barButton;
    //Memory clean up
    [activityIndicator release];
    [barButton release];
    
    [self.tableView setRowHeight:120.0];

    [_rssParser setDelegate:self];
    [_rssParser start];
    [self startActivity:nil];

}


-(void)startActivity:(id)sender{
    //Send startAnimating message to the view
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
}

-(void)stopActivity:(id)sender{
    //Send stopAnimating message to the view
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [_rssParser.rssItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        [cell.textLabel setNumberOfLines:2];
        [cell.detailTextLabel setNumberOfLines:3];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    RSSItem * rssItem = (RSSItem *)[_rssParser.rssItems objectAtIndex:indexPath.row];
    [cell.textLabel setText:rssItem.title];
    [cell.detailTextLabel setText:rssItem.summary];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    RSSItem * rssItem = (RSSItem *)[_rssParser.rssItems objectAtIndex:indexPath.row];
    
    BrowserViewController * browser = [[BrowserViewController alloc] initWithLoadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:rssItem.linkURL]]];
    [browser setTitle:rssItem.title];
    
    [self.navigationController pushViewController:browser animated:YES];
    [browser release];
}

@end
