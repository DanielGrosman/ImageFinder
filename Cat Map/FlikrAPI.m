//
//  FlikrAPI.m
//  Cat Map
//
//  Created by Daniel Grosman on 2017-11-21.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

#import "FlikrAPI.h"

@implementation FlikrAPI

+ (void)searchFor:(NSString *)tag complete:(void (^)(NSArray *))done
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=e964fc126bef919ee109fc1f63bee761&tags=%@&has_geo=1&extras=url_m%%2Curl_sq&format=json&nojsoncallback=1", tag]];
    NSURLSessionTask *task =
    [[NSURLSession sharedSession]
     dataTaskWithURL:url
     completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
         if (error != nil) {
             NSLog(@"Error while making request: %@", error.localizedDescription);
             abort();
         }
         NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
         if (resp.statusCode > 299) {
             NSLog(@"Bad status code: %ld", resp.statusCode);
             abort();
         }
         NSError *err = nil;
         NSDictionary *result = [NSJSONSerialization
                                 JSONObjectWithData:data
                                 options:0
                                 error:&err];
         if (err != nil) {
             NSLog(@"Something has gone wrong parsing JSON: %@", err.localizedDescription);
             abort();
         }
         NSMutableArray *photos = [[NSMutableArray alloc] init];
         for (NSDictionary *photoInfo in result[@"photos"][@"photo"]) {
             [photos addObject:[[Photo alloc] initWithInfo:photoInfo]];
         }
         done([NSArray arrayWithArray:photos]);
     }];
    
    [task resume];
}

+ (void)loadImage:(Photo*)currentPhoto completionHandler:(void (^)(UIImage *))finishedCallback
{
    if (currentPhoto.image != nil) {
        finishedCallback(currentPhoto.image);
    } else {
        NSURLSessionTask *task =
        [[NSURLSession sharedSession]
         downloadTaskWithURL:currentPhoto.url
         completionHandler:^(NSURL* location, NSURLResponse* response, NSError* error) {
             UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
             currentPhoto.image = img;
             finishedCallback(img);
         }];
        
        [task resume];
    }
}

+ (void)getCoordinate:(NSString *)photoID complete:(void (^)(CLLocationCoordinate2D))done
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=e964fc126bef919ee109fc1f63bee761&photo_id=%@&format=json&nojsoncallback=1", photoID]];
    NSURLSessionTask *task =
    [[NSURLSession sharedSession]
     dataTaskWithURL:url
     completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
         if (error != nil) {
             NSLog(@"Error while making request: %@", error.localizedDescription);
             abort();
         }
         NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
         if (resp.statusCode > 299) {
             NSLog(@"Bad status code: %ld", resp.statusCode);
             abort();
         }
         NSError *err = nil;
         NSDictionary *result = [NSJSONSerialization
                                 JSONObjectWithData:data
                                 options:0
                                 error:&err];
         if (err != nil) {
             NSLog(@"Something has gone wrong parsing JSON: %@", err.localizedDescription);
             abort();
         }
         NSDictionary *location = result[@"photo"][@"location"];
         double latitude = [location[@"latitude"] doubleValue];
         double longitude = [location[@"longitude"] doubleValue];
         CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
         done(coordinate);
     }];
    
    [task resume];
}




@end
