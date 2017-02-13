//
//  ViewController.m
//
//  Created by Nick Lockwood on 03/02/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //load color image
    UIImage *image = [UIImage imageNamed:@"Snowman.jpg"];
    
    //load mask image
    UIImage *mask = [UIImage imageNamed:@"SnowmanMask.png"];
    
    //convert mask to correct format
    CGColorSpaceRef graySpace = CGColorSpaceCreateDeviceGray();
    CGImageRef maskRef = CGImageCreateCopyWithColorSpace(mask.CGImage, graySpace);
    CGColorSpaceRelease(graySpace);
    
    //combine images
    CGImageRef resultRef = CGImageCreateWithMask(image.CGImage, maskRef);
    UIImage *result = [UIImage imageWithCGImage:resultRef];
    CGImageRelease(resultRef);
    CGImageRelease(maskRef);
    
    //display result
    self.imageView.image = result;
}

@end