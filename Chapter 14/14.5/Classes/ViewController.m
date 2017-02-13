//
//  ViewController.m
//
//  Created by Nick Lockwood on 03/02/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ViewController.h"

@interface ViewController() <UICollectionViewDataSource>

@property (nonatomic, copy) NSArray *imagePaths;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    //set up data
    self.imagePaths =
        [[NSBundle mainBundle] pathsForResourcesOfType:@"png"
                                           inDirectory:@"Vacation Photos"];
    
    //register cell class
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:@"Cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.imagePaths count];
}

- (UIImage *)loadImageAtIndex:(NSUInteger)index
{
    //set up cache
    static NSCache *cache = nil;
    if (!cache)
    {
        cache = [[NSCache alloc] init];
    }
    
    //if already cached, return immediately
    UIImage *image = [cache objectForKey:@(index)];
    if (image)
    {
        return [image isKindOfClass:[NSNull class]]? nil: image;
    }
    
    //set placeholder to avoid reloading image multiple times
    [cache setObject:[NSNull null] forKey:@(index)];
    
    //switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //load image
        NSString *imagePath = self.imagePaths[index];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        //redraw image using device context
        UIGraphicsBeginImageContextWithOptions(image.size, YES, 0);
        [image drawAtPoint:CGPointZero];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //set image for correct image view
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //cache the image
            [cache setObject:image forKey:@(index)];
            
            //display the image
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            UIImageView *imageView = [cell.contentView.subviews lastObject];
            imageView.image = image;
        });
    });
    
    //not loaded yet
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //dequeue cell
    UICollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                  forIndexPath:indexPath];
    
    //add image view
    const NSInteger imageTag = 99;
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:imageTag];
    if (!imageView)
    {
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.tag = imageTag;
        [cell.contentView addSubview:imageView];
    }
    
    //set or load image for this index
    imageView.image = [self loadImageAtIndex:indexPath.item];
    
    //preload image for previous and next index
    if (indexPath.item < [self.imagePaths count] - 1)
    {
        [self loadImageAtIndex:indexPath.item + 1];
    }
    if (indexPath.item > 0)
    {
       [self loadImageAtIndex:indexPath.item - 1];
    }
    
    return cell;
}

@end