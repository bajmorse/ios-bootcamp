//
//  RTTableViewController.h
//  com.bajmorse.iosbootcamp
//
//  Created by Brent on 2014-01-15.
//  Copyright (c) 2014 Brenton Morse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>

- (id)initWithSearch:(NSString *)search;
- (void)newSearch:(NSString *)search; 

@end
