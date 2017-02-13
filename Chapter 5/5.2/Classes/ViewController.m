//
//  ViewController.m
//
//  Created by Nick Lockwood on 03/02/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *layerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //create a new transform
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    //scale by 50%
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    
    //rotate by 30 degrees
    transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 30.0);
    
    //translate by 200 points
    transform = CGAffineTransformTranslate(transform, 200, 0);
    
    //apply transform to layer
    self.layerView.layer.affineTransform = transform;
}

@end