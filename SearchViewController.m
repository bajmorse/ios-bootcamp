//
//  SearchViewController.m
//  iosbootcamp
//
//  Created by Brent on 2014-01-20.
//  Copyright (c) 2014 Brenton Morse. All rights reserved.
//

#import "SearchViewController.h"
#import "RTTableViewController.h"

@interface SearchViewController ()
{
    RTTableViewController * _moviesTableViewController;
}

@end

@implementation SearchViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 225, 40)];
    searchBar.delegate = self;
    searchBar.placeholder = @"Search                               ";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    
    _moviesTableViewController = [[RTTableViewController alloc] init];
    [_moviesTableViewController.tableView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height,0,0,0)];
    [self.view addSubview:_moviesTableViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - search bar delegate


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *search = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=zh2cxpyjubvtbqzjujkcjhs5&q=%@&page_limit=20", [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [_moviesTableViewController newSearch:search];
    
    [searchBar resignFirstResponder];
}

@end

