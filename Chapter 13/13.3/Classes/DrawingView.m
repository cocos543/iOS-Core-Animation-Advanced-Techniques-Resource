//
//  DrawingView.m
//
//  Created by Nick Lockwood on 27/02/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "DrawingView.h"
#import <QuartzCore/QuartzCore.h>

#define BRUSH_SIZE 32

@interface DrawingView ()

@property (nonatomic, strong) NSMutableArray *strokes;

@end

@implementation DrawingView

- (void)awakeFromNib
{
    //create array
    self.strokes = [NSMutableArray array];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //add brush stroke
    [self addBrushStrokeAtPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //add brush stroke
    [self addBrushStrokeAtPoint:point];
}

- (void)addBrushStrokeAtPoint:(CGPoint)point
{
    //add brush stroke to array
    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
    
    //needs redraw
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //redraw strokes
    for (NSValue *value in self.strokes)
    {
        //get point
        CGPoint point = [value CGPointValue];
        
        //get brush rect
        CGRect brushRect = CGRectMake(point.x - BRUSH_SIZE/2,
                                      point.y - BRUSH_SIZE/2,
                                      BRUSH_SIZE, BRUSH_SIZE);
        
        //draw brush stroke
        [[UIImage imageNamed:@"Chalk.png"] drawInRect:brushRect];
    }
}

@end
