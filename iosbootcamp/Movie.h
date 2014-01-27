//
//  Movie.h
//  iosbootcamp
//
//  Created by Brent on 2014-01-19.
//  Copyright (c) 2014 Brenton Morse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * imageLink;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSNumber * userRating;
@property (nonatomic, retain) NSNumber * criticRating;

@end
