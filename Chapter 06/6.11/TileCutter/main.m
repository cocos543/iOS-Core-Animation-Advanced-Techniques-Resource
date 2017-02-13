//
//  main.m
//
//  Created by Nick Lockwood on 09/03/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import <AppKit/AppKit.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        //handle incorrect arguments
        if (argc < 2)
        {
            NSLog(@"TileCutter arguments: inputfile");
            return 0;
        }
        
        //input file
        NSString *inputFile = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];

        //tile size
        CGFloat tileSize = 256;

        //output path
        NSString *outputPath = [inputFile stringByDeletingPathExtension];
        
        //load image
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:inputFile];
        NSSize size = [image size];
        NSArray *representations = [image representations];
        if ([representations count])
        {
            NSBitmapImageRep *representation = representations[0];
            size.width = [representation pixelsWide];
            size.height = [representation pixelsHigh];
        }
        NSRect rect = NSMakeRect(0.0, 0.0, size.width, size.height);
        CGImageRef imageRef = [image CGImageForProposedRect:&rect context:NULL hints:nil];
        
        //calculate rows and columns
        NSInteger rows = ceil(size.height / tileSize);
        NSInteger cols = ceil(size.width / tileSize);
        
        //generate tiles
        for (int y = 0; y < rows; ++y)
        {
            for (int x = 0; x < cols; ++x)
            {
                //extract tile image
                CGRect tileRect = CGRectMake(x*tileSize, y*tileSize, tileSize, tileSize);
                CGImageRef tileImage = CGImageCreateWithImageInRect(imageRef, tileRect);
                
                //convert to jpeg data
                NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithCGImage:tileImage];
                NSData *data = [imageRep representationUsingType:NSJPEGFileType properties:nil];
                CGImageRelease(tileImage);
                
                //save file
                NSString *path = [outputPath stringByAppendingFormat:@"_%02i_%02i.jpg", x, y];
                [data writeToFile:path atomically:NO];
            }
        }
    }
    return 0;
}

