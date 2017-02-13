//
//  ViewController.m
//
//  Created by Nick Lockwood on 03/02/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "chipmunk.h"

@interface Crate : UIImageView

@property (nonatomic, assign) cpBody *body;
@property (nonatomic, assign) cpShape *shape;

@end

@implementation Crate

#define MASS 100

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        //set image
        self.image = [UIImage imageNamed:@"Crate.png"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        //create the body
        self.body = cpBodyNew(MASS, cpMomentForBox(MASS, frame.size.width,
                                                   frame.size.height));
        
        //create the shape
        cpVect corners[] = {
            cpv(0, 0),
            cpv(0, frame.size.height),
            cpv(frame.size.width, frame.size.height),
            cpv(frame.size.width, 0),
        };
        self.shape = cpPolyShapeNew(self.body, 4, corners,
                                    cpv(-frame.size.width/2,
                                        -frame.size.height/2));
        
        //set shape friction & elasticity
        cpShapeSetFriction(self.shape, 0.5);
        cpShapeSetElasticity(self.shape, 0.8);
        
        //link the crate to the shape
        //so we can refer to crate from callback later on
        self.shape->data = (__bridge void *)self;
        
        //set the body position to match view
        cpBodySetPos(self.body, cpv(frame.origin.x + frame.size.width/2,
                     300 - frame.origin.y - frame.size.height/2));
        
    }
    return self;
}

- (void)dealloc
{
    //release shape and body
    cpShapeFree(_shape);
    cpBodyFree(_body);
}

@end

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, assign) cpSpace *space;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, assign) CFTimeInterval lastStep;

@end

@implementation ViewController

#define GRAVITY 1000

- (void)viewDidLoad
{
    //invert view coordinate system to match physics
    self.containerView.layer.geometryFlipped = YES;
    
    //set up physics space
    self.space = cpSpaceNew();
    cpSpaceSetGravity(self.space, cpv(0, -GRAVITY));
    
    //add a crate
    Crate *crate = [[Crate alloc] initWithFrame:CGRectMake(100, 0, 100, 100)];
    [self.containerView addSubview:crate];
    cpSpaceAddBody(self.space, crate.body);
    cpSpaceAddShape(self.space, crate.shape);

    //start the timer
    self.lastStep = CACurrentMediaTime();
    self.timer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(step:)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSDefaultRunLoopMode];
}

void updateShape(cpShape *shape, void *unused)
{
    //get the crate object associated with the shape
    Crate *crate = (__bridge Crate *)shape->data;
    
    //update crate view position and angle to match physics shape
    cpBody *body = shape->body;
    crate.center = cpBodyGetPos(body);
    crate.transform = CGAffineTransformMakeRotation(cpBodyGetAngle(body));
}

- (void)step:(CADisplayLink *)timer
{
    //calculate step duration
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
    self.lastStep = thisStep;
    
    //update physics
    cpSpaceStep(self.space, stepDuration);
    
    //update all the shapes
    cpSpaceEachShape(self.space, &updateShape, NULL);
}

@end
