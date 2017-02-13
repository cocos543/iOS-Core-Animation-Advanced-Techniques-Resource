//
//  ViewController.m
//
//  Created by Nick Lockwood on 03/02/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *button1;
@property (nonatomic, weak) IBOutlet UIView *button2;

@end

@implementation ViewController

- (void)addStretchableImage:(UIImage *)image
          withContentCenter:(CGRect)rect
                    toLayer:(CALayer *)layer
{
    //set image
    layer.contents = (__bridge id)image.CGImage;

    //set contentsCenter
    layer.contentsCenter = rect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //load button image
    UIImage *image = [UIImage imageNamed:@"Button.png"];

    //set button 1
    [self addStretchableImage:image
            withContentCenter:CGRectMake(0.25, 0.25, 0.5, 0.5)
                      toLayer:self.button1.layer];
    
    //set button 2
    [self addStretchableImage:image
            withContentCenter:CGRectMake(0.25, 0.25, 0.5, 0.5)
                      toLayer:self.button2.layer];
}

@end
