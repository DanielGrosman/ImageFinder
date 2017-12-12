//
//  Photo.m
//  Cat Map
//
//  Created by Daniel Grosman on 2017-11-21.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

#import "Photo.h"


@implementation Photo

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _photoID = info[@"id"];
        _url = [NSURL URLWithString:info[@"url_m"]];
        _smallURL = [NSURL URLWithString:info[@"url_sq"]];
        _title = info[@"title"];
    }
    return self;
}



@end
