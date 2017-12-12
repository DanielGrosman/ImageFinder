//
//  DetailViewController.m
//  Cat Map
//
//  Created by Daniel Grosman on 2017-11-21.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FlikrAPI getCoordinate:self.detailPhoto.photoID complete:^(CLLocationCoordinate2D results) {
        self.currentCoordinate = results;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            MKCoordinateSpan span = MKCoordinateSpanMake(.5f, .5f);
            self.mapView.region = MKCoordinateRegionMake(self.currentCoordinate, span);
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:self.currentCoordinate];
            [annotation setTitle:self.detailPhoto.title];
            [self.mapView addAnnotation:annotation];
        }];
        NSLog(@"Coordinate are (%.4f, %.4f).",self.currentCoordinate.latitude, self.currentCoordinate.longitude);
    }];
}

#pragma mark  - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        return nil;
    }
    NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];

    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
    }

    NSData *imageData = [[NSData alloc] initWithContentsOfURL: self.detailPhoto.smallURL];
    UIImage *image = [UIImage imageWithData:imageData];
    [annotationView setImage:image];
    annotationView.annotation = annotation;
    return annotationView;
}


@end
