//
//  FlikrAPI.h
//  Cat Map
//
//  Created by Daniel Grosman on 2017-11-21.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import <MapKit/MapKit.h>

@interface FlikrAPI : NSObject

+ (void)searchFor:(NSString*)tag complete:(void (^)(NSArray *results))done;

+ (void)loadImage:(Photo*)currentPhoto completionHandler:(void (^)(UIImage *image))finishedCallback;

+ (void)getCoordinate:(NSString *)photoID complete:(void (^)(CLLocationCoordinate2D))done;

@end
