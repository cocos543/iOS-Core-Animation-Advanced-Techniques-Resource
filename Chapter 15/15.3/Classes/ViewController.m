//
//  ViewController.m
//
//  Created by Nick Lockwood on 03/02/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define WIDTH 10
#define HEIGHT 10
#define DEPTH 10

#define SIZE 100
#define SPACING 150

#define CAMERA_DISTANCE 500

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set content size
    self.scrollView.contentSize = CGSizeMake((WIDTH - 1)*SPACING,
                                             (HEIGHT - 1)*SPACING);
    
    //set up perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / CAMERA_DISTANCE;
    self.scrollView.layer.sublayerTransform = transform;
    
    //create layers
    for (int z = DEPTH - 1; z >= 0; z--)
    {
        for (int y = 0; y < HEIGHT; y++)
        {
            for (int x = 0; x < WIDTH; x++)
            {
                //create layer
                CALayer *layer = [CALayer layer];
                layer.frame = CGRectMake(0, 0, SIZE, SIZE);
                layer.position = CGPointMake(x*SPACING, y*SPACING);
                layer.zPosition = -z*SPACING;
                
                //set background color
                layer.backgroundColor = [UIColor colorWithWhite:1 - z*(1.0/DEPTH)
                                                          alpha:1].CGColor;
                
                //attach to scroll view
                [self.scrollView.layer addSublayer:layer];
            }
        }
    }
    
    //log
    NSLog(@"displayed: %i", DEPTH*HEIGHT*WIDTH);
}

@end
