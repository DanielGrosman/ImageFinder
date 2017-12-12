//
//  DetailViewController.h
//  Cat Map
//
//  Created by Daniel Grosman on 2017-11-21.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
#import "FlikrAPI.h"
#import "Photo.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Photo *detailPhoto;

@end
