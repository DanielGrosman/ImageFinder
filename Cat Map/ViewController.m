//
//  ViewController.m
//  Cat Map
//
//  Created by Daniel Grosman on 2017-11-21.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

#import "ViewController.h"
#import "FlikrAPI.h"
#import "Photo.h"
#import "PhotoCollectionViewCell.h"
#import "DetailViewController.h"
#import "SearchViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MBProgressHUD.h"

@interface ViewController () <UICollectionViewDataSource, FetchDataDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray<Photo*>* photos;
@property (nonatomic,strong) NSString *searchItem;
@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
}

-(void) setupHUD {
    self.hud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.contentColor= [UIColor blackColor];
    self.hud.label.text = @"Loading";
}

-(void) hideHUD {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
        });
    });
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
        Photo *photo = self.photos[indexPath.item];
        DetailViewController *controller = (DetailViewController*)[segue destinationViewController];
        [controller setDetailPhoto:photo];
    }
    if([[segue identifier] isEqualToString:@"fetch"]){
        SearchViewController *controller = (SearchViewController *)[segue destinationViewController];
        controller.delegate = self;
    }
}

-(void)fetchData:(NSString *)searchString {
    [self setupHUD];
    self.searchItem = searchString;
    [FlikrAPI searchFor:searchString complete:^(NSArray *results) {
        self.photos = results;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
                [self hideHUD];
        }];
    }];
}

#pragma mark - Collection View

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Photo *currentPhoto = self.photos[indexPath.item];
    [FlikrAPI loadImage:currentPhoto completionHandler:^(UIImage *image) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.image.image = image;
            cell.label.text = currentPhoto.title;
        }];
    }];
    return cell;
}

#pragma mark - EmptyCollectionView

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Welcome to ImageFinder";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Tap 'Search for Photos' on the top of the screen to find images, then click on an image to see where it was taken";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
