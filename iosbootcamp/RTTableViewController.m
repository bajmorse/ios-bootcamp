//
//  RTTableViewController.m
//  com.bajmorse.iosbootcamp
//
//  Created by Brent on 2014-01-15.
//  Copyright (c) 2014 Brenton Morse. All rights reserved.
//

#import "RTTableViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "CurrentMovie.h"
#import "Movie.h"

@interface RTTableViewController () {
    NSMutableData *_responseData;
    NSMutableArray *_currentMovies;
    NSString *_searchString;
    NSMutableDictionary *_cachedImages;
}

@end

@implementation RTTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        _searchString = nil;
        _currentMovies = [[NSMutableArray alloc] init];
        _cachedImages = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithSearch:(NSString *)search
{
    self = [super init];
    if (self) {
        _searchString = search;
        _currentMovies = [[NSMutableArray alloc] init];
        _cachedImages = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _searchString = nil;
        _currentMovies = [[NSMutableArray alloc] init];
        _cachedImages = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [self parseRTData];
    [NSTimer scheduledTimerWithTimeInterval:30.f target:self selector:@selector(parseRTData) userInfo:Nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)parseRTData
{
    if (_searchString == nil)
        return;
    
    NSURL *url = [[NSURL alloc] initWithString:_searchString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    NSURLConnection *rcParse = [[NSURLConnection alloc] initWithRequest:request delegate:self];
#pragma clang diagnostic pop
}

- (void)newSearch:(NSString *)search
{
    _searchString = search;
    [self parseRTData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentMovies.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentMovies.count <= 0)
        return 0;
    
    CurrentMovie *cellMovie = (CurrentMovie *)[_currentMovies objectAtIndex:0];
    NSURL *imageURL = [NSURL URLWithString:cellMovie.imageLink];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *thumbnail = [UIImage imageWithData:imageData];
    return thumbnail.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }

    if ([_currentMovies count] > indexPath.row) {
        CurrentMovie *cellMovie = (CurrentMovie *)[_currentMovies objectAtIndex:indexPath.row];
        
        UIImage *poster = [_cachedImages objectForKey:[NSString stringWithFormat:@"%i-%i", indexPath.section, indexPath.row]];
        UIImageView *thumbnailView;
        if (poster == nil) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *imageURL = [NSURL URLWithString:cellMovie.imageLink];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *thumbnail = [UIImage imageWithData:imageData];
                UIImageView *thumbnailView = [[UIImageView alloc] initWithImage:thumbnail];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell addSubview:thumbnailView];
                    [_cachedImages setObject:thumbnail forKey:[NSString stringWithFormat:@"%i-%i", indexPath.section, indexPath.row]];
                });
            });
        } else {
            thumbnailView = [[UIImageView alloc] initWithImage:poster];
            [cell addSubview:thumbnailView];
        }
        
        UILabel *movieLabel = [[UILabel alloc] initWithFrame:CGRectApplyAffineTransform(CGRectMake(0, 5, cell.frame.size.width-61.f-15.f, 20.f), CGAffineTransformMakeTranslation(61.f+10.f, 0.f))];
        movieLabel.text = ((Movie *)[_currentMovies objectAtIndex:indexPath.row]).title;
        movieLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        movieLabel.backgroundColor = [UIColor redColor];
        [cell addSubview:movieLabel];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectApplyAffineTransform(CGRectMake(0, 10, cell.frame.size.width-61.f-10.f, 91.f-10.f), CGAffineTransformMakeTranslation(61.f+10.f, movieLabel.frame.size.height-15))];
        infoLabel.text = cellMovie.info;
        infoLabel.font = [UIFont systemFontOfSize:10];
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel.numberOfLines = 5;
//        infoLabel.backgroundColor = [UIColor blueColor];
        [cell addSubview:infoLabel];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    UIViewController *linkViewController = [[UIViewController alloc] init];
    UIWebView *linkView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    CurrentMovie *cellMovie = (CurrentMovie *)[_currentMovies objectAtIndex:indexPath.row];
    NSLog(@"%@", cellMovie.link);
    NSURL *linkURL = [NSURL URLWithString:cellMovie.link];
    NSURLRequest *linkRequest = [NSURLRequest requestWithURL:linkURL];
    [linkView loadRequest:linkRequest];
    linkViewController.view = linkView;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController pushViewController:linkViewController animated:true];
}

#pragma mark - URL delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *jsonParsingError = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&jsonParsingError];
    
    if (jsonParsingError) {
        NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
    } else {
        NSDictionary *dic = obj;
        NSArray *movieArr = [dic valueForKey:@"movies"];
        [_currentMovies removeAllObjects];
        
        for (NSDictionary *movieDic in movieArr) {
            CurrentMovie *movie = [[CurrentMovie alloc] init];
            movie.title = [movieDic valueForKey:@"title"];
            movie.link = [[movieDic valueForKey:@"links"] valueForKey:@"alternate"];
            movie.imageLink = [[movieDic valueForKey:@"posters"] valueForKey:@"thumbnail"];
            movie.runtime = [movieDic valueForKey:@"runtime"];
            movie.userRating = [[movieDic valueForKey:@"ratings"] valueForKey:@"audience_score"];
            movie.criticRating = [[movieDic valueForKey:@"ratings"] valueForKey:@"critics_score"];
            movie.info = [movieDic valueForKey:@"synopsis"];
            [_currentMovies addObject:movie];
        }
        
        [self.tableView reloadData];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}


@end
