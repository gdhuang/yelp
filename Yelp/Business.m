//
//  Business.m
//  Yelp
//
//  Created by GD Huang on 6/19/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    
    if(self) {
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryName = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryName addObject:obj[0]];
        }];
        
        self.categories = [categoryName componentsJoinedByString:@", "];
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"image_url"];
        NSString *street = ([[dictionary valueForKeyPath:@"location.address"] count]) ? [dictionary valueForKeyPath:@"location.address"][0] : @"no address provided";
        NSString *neighborhood = [dictionary valueForKeyPath:@"location.neighborhoods"][0];
        self.address = [NSString stringWithFormat:@"%@, %@", street, neighborhood ];
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        float milesPerMeter = 0.00621371;
        self.distance = [dictionary[@"distance"] integerValue] * milesPerMeter;
    }
    
    return self;
}


+ (NSArray*) businessWithDictionaries:(NSDictionary*) dictionaries {
    NSMutableArray *businesses = [NSMutableArray array];
    
    for(NSDictionary *dictionary in dictionaries) {
        NSLog(@"%@", dictionary);
        Business *business = [[Business alloc] initWithDictionary:dictionary];
        [businesses addObject:business];
    }
    return businesses;
    
}

@end
