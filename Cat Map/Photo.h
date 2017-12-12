//
//  Photo.h
//  Cat Map
//
//  Created by Daniel Grosman on 2017-11-21.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>

@interface Photo : NSObject

@property (nonatomic,strong) NSString *photoID;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSURL *smallURL;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) UIImage *image;

- (instancetype)initWithInfo:(NSDictionary*)info;

@end
