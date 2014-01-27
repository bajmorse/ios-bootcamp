//
//  CurrentMoviesViewController.m
//  iosbootcamp
//
//  Created by Brent on 2014-01-20.
//  Copyright (c) 2014 Brenton Morse. All rights reserved.
//

#import "CurrentMoviesViewController.h"
#import "SearchViewController.h"
#import "RTTableViewController.h"
#import "AppDelegate.h"

@interface CurrentMoviesViewController ()

@end

@implementation CurrentMoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchRT)];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    RTTableViewController *moviesTableViewController = [[RTTableViewController alloc] initWithSearch:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=zh2cxpyjubvtbqzjujkcjhs5"];
    [moviesTableViewController.tableView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height,0,0,0)];
    [self.view addSubview:moviesTableViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchRT
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    [appDelegate.navigationController pushViewController:searchViewController animated:YES];
}

@end
