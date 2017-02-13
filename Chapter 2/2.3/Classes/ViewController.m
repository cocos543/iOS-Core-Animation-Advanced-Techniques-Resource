//
//  ViewController.m
//
//  Created by Nick Lockwood on 03/02/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *coneView;
@property (nonatomic, weak) IBOutlet UIView *shipView;
@property (nonatomic, weak) IBOutlet UIView *iglooView;
@property (nonatomic, weak) IBOutlet UIView *anchorView;

@end

@implementation ViewController

- (void)addSpriteImage:(UIImage *)image
       withContentRect:(CGRect)rect
               toLayer:(CALayer *)layer
{
    //set image
    layer.contents = (__bridge id)image.CGImage;
    
    //scale contents to fit
    layer.contentsGravity = kCAGravityResizeAspect;

    //set contentsRect
    layer.contentsRect = rect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //load sprite sheet
    UIImage *image = [UIImage imageNamed:@"Sprites.png"];

    //set igloo sprite
    [self addSpriteImage:image
         withContentRect:CGRectMake(0, 0, 0.5, 0.5)
                 toLayer:self.iglooView.layer];
    
    //set cone sprite
    [self addSpriteImage:image
         withContentRect:CGRectMake(0.5, 0, 0.5, 0.5)
                 toLayer:self.coneView.layer];
    
    //set anchor sprite
    [self addSpriteImage:image
         withContentRect:CGRectMake(0, 0.5, 0.5, 0.5)
                 toLayer:self.anchorView.layer];
    
    //set spaceship sprite
    [self addSpriteImage:image
         withContentRect:CGRectMake(0.5, 0.5, 0.5, 0.5)
                 toLayer:self.shipView.layer];
}

@end
