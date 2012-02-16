//
//  RSSParser.m
//  RSSReader
//
//  Created by Imthiaz Rafiq @hmimthiaz
//  http://imthi.com
//  https://github.com/hmimthiaz/RSSReader
//


#import "RssParser.h"
#import "RSSItem.h"

@interface RSSParser (Private)

- (NSString *)trimString:(NSString *)originalString;

@end

@implementation RSSParser

@synthesize rssItems = _rssItems;
@synthesize delegate = _delegate;
@synthesize RSSURL = _rssURL;


- (id)initWithRSSURL:(NSString *)rssURL{
    self = [super init];
    if (self) {
        _rssItems = [[NSMutableArray alloc]init];
        self.RSSURL = rssURL;
    }
    return self;
}


- (void)start{
	[_rssItems removeAllObjects];
    
    NSURL * url = [NSURL URLWithString:self.RSSURL];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLConnection * download = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    [download start];
    
}

#pragma mark -
#pragma mark Private Functions


- (NSString *)trimString:(NSString *)originalString{
    NSString * trimmedString;
    trimmedString  = [originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}


#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //This function is called when the download begins.
    //You can get all the response headers
    if (_downloadedData!=nil) {
        [_downloadedData release];
        _downloadedData = nil;
    }
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //This function is called whenever there is downloaded data available
    //It will be called multiple times and each time you will get part of downloaded data
    [_downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //This function is called once the download is complete
    //The next step is parse the downloaded xml feed
    
	NSXMLParser * xmlParser = [[[NSXMLParser alloc] initWithData:_downloadedData] autorelease];
	[xmlParser setDelegate:self];
	[xmlParser setShouldProcessNamespaces:YES];
	[xmlParser setShouldReportNamespacePrefixes:YES];
	[xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //
}


#pragma mark -
#pragma mark NSXMLParserDelegate


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	if(nil != qualifiedName){
		elementName = qualifiedName;
	}
    _parseElement = NO;
	if ([elementName isEqualToString:@"item"]) {
        _currentItem = [[RSSItem alloc] init];
	} else if([elementName isEqualToString:@"title"] || 
			  [elementName isEqualToString:@"guid"] ||
			  [elementName isEqualToString:@"description"] ||
			  [elementName isEqualToString:@"content:encoded"] ||
			  [elementName isEqualToString:@"link"] ||
			  [elementName isEqualToString:@"category"] ||
			  [elementName isEqualToString:@"dc:creator"] ||
			  [elementName isEqualToString:@"pubDate"]) {
        _parseElement = YES;
	} else if([elementName isEqualToString:@"media:thumbnail"] && _currentItem.imageURL ==nil ) {
        [_currentItem setImageURL:[attributeDict objectForKey:@"url"]];
    }	
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if(nil != qName){
		elementName = qName;
	}
    NSString * parsedElementContent = nil;
    if (_parsedElementData != nil) {
        parsedElementContent = [[NSString alloc] initWithData:_parsedElementData encoding:NSUTF8StringEncoding];
    } else if (_parsedElementString != nil) {
        parsedElementContent = [[NSString alloc] initWithString:_parsedElementString];
    }
    
	if([elementName isEqualToString:@"title"]){
        [_currentItem setTitle:[self trimString:parsedElementContent]];
	}else if([elementName isEqualToString:@"guid"]){
        [_currentItem setGuid:[self trimString:parsedElementContent]];
	}else if([elementName isEqualToString:@"description"]){
        [_currentItem setSummary:[self trimString:parsedElementContent]];
	}else if([elementName isEqualToString:@"content:encoded"]){
        [_currentItem setContent:[self trimString:parsedElementContent]];
	}else if([elementName isEqualToString:@"link"]){
        [_currentItem setLinkURL:[self trimString:parsedElementContent]];
	}else if([elementName isEqualToString:@"category"]){
        [_currentItem addCategory:[self trimString:parsedElementContent]];
	}else if([elementName isEqualToString:@"dc:creator"]){
        [_currentItem setAuthor:[self trimString:parsedElementContent]];
	}else if([elementName isEqualToString:@"pubDate"]){
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
        [_currentItem setPubDate:[formatter dateFromString:[self trimString:parsedElementContent]]];
		[formatter release];
	}else if([elementName isEqualToString:@"item"]){
        [_rssItems addObject:_currentItem];
        [_currentItem release];
        _currentItem = nil;
	}
    
    if (parsedElementContent!=nil) {
        [parsedElementContent release];
        parsedElementContent = nil;
    }
    
    if (_parsedElementString!=nil) {
        [_parsedElementString release];
        _parsedElementString = nil;
    }

    if (_parsedElementData!=nil) {
        [_parsedElementData release];
        _parsedElementData = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!_parseElement) {
        return;
    }
    if (_parsedElementString==nil) {
        _parsedElementString = [[NSMutableString alloc] init];
    }
    [_parsedElementString appendString:string];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    if (!_parseElement) {
        return;
    }
    if (_parsedElementData==nil) {
        _parsedElementData = [[NSMutableData alloc] init];
    }
    [_parsedElementData appendData:CDATABlock];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"Error: %@",[parseError description]);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (_downloadedData!=nil) {
        [_downloadedData release];
        _downloadedData = nil;
    }
    [self.delegate RSSParserDidCompleteParsing];
}


-(void)dealloc{
    if (_parsedElementString!=nil) {
        [_parsedElementString release];
        _parsedElementString = nil;
    }
    
    if (_currentItem!=nil) {
        [_currentItem release];
        _currentItem = nil;
    }    
    
    [_rssItems removeAllObjects];
	[_rssItems release];
    _rssItems = nil;
    
    if (_downloadedData!=nil) {
        [_downloadedData release];
        _downloadedData = nil;
    }    
	[super dealloc];
}

@end
