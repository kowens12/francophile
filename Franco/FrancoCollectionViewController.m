//
//  FrancoCollectionViewController.m
//  Franco
//
//  Created by Katherine Owens on 3/23/17.
//  Copyright © 2017 Katherine Owens. All rights reserved.
//

#import "FrancoCollectionViewController.h"
#import "FrancoCollectionViewCell.h"

@interface FrancoCollectionViewController () {
    NSArray *francoPhotos;
    UIImage *selectedFranco;
}

@end

@implementation FrancoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Register cell classes
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FrancoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    francoPhotos = [NSArray arrayWithObjects:@"francoPractice1", @"francoPractice2", @"francoPractice3", @"francopractice4", @"francopractice5", @"francopractice6", @"francopractice7", @"francopractice8", @"francopractice9", @"francopractice10", @"francopractice11", @"francopractice12", @"francopractice13", @"francopractice14", nil];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return francoPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FrancoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImage *francoImage = [UIImage imageNamed:[francoPhotos objectAtIndex:indexPath.row]];
    cell.francoImageView.image = francoImage;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedFranco = francoPhotos[indexPath.item];
    NSDictionary *francoDictionary = @{@"newFranco": selectedFranco};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"francoNotification" object:nil userInfo:francoDictionary];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
