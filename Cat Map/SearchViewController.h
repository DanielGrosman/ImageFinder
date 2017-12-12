//
//  SearchViewController.h
//  Cat Map
//
//  Created by Daniel Grosman on 2017-11-21.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FetchDataDelegate <NSObject>

-(void)fetchData:(NSString*)fetchSearchString;

@end

@interface SearchViewController : UIViewController

@property (nonatomic, weak) id<FetchDataDelegate>delegate;


@end
