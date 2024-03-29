/**
 *   @file
 *   MyBudget
 *
 *   Created by Arevik Tunyan on 2/14/12.
 *   &copy; 2012 MyBudget. All rights reserved.
 */

#import "ColorPickerImageView.h"
#import "ColorPickerViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/CoreAnimation.h>

@implementation ColorPickerImageView

@synthesize lastColor;
@synthesize pickedColorDelegate;

-(id) initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self]; //where image was tapped
	self.lastColor = [self pixelColorAtLocation:point]; 
	[pickedColorDelegate pickedColor:(UIColor*)self.lastColor];
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self]; //where image was tapped
	self.lastColor = [self pixelColorAtLocation:point]; 
	[pickedColorDelegate pickedColor:(UIColor*)self.lastColor];
}


- (UIColor*) pixelColorAtLocation:(CGPoint)point {
	UIColor* color = nil;
	CGImageRef inImage = self.image.CGImage;
	CGContextRef cgctx = [self newARGBBitmapContextFromImage:inImage];
	if (cgctx == NULL) {
        return nil; /* error */
    }
	
    size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}}; 
	
	// Draw the image to the bitmap context. Once we draw, the memory 
	// allocated for the context for rendering will then contain the 
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, inImage); 
	
	// Now we can get a pointer to the image data associated with the bitmap
	// context.
	unsigned char* data = CGBitmapContextGetData (cgctx);
	if (data != NULL) {
		//offset locates the pixel in the data from x,y. 
		//4 for 4 bytes of data per pixel, w is width of one row of data.
		int offset = 4*((w*round(point.y))+round(point.x));
		int alpha =  data[offset]; 
		int red = data[offset+1]; 
		int green = data[offset+2]; 
		int blue = data[offset+3]; 
		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
		color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
	}
	
	// When finished, release the context
    if (cgctx) {
        CGContextRelease(cgctx); 
    }
	// Free image data memory for the context
	if (data) { free(data); }
	
	return color;
}

- (CGContextRef) newARGBBitmapContextFromImage:(CGImageRef) inImage {
	
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	// Get image width, height. We'll use the entire image.
	size_t pixelsWide = CGImageGetWidth(inImage);
	size_t pixelsHigh = CGImageGetHeight(inImage);
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	// Use the generic RGB color space.
	colorSpace = CGColorSpaceCreateDeviceRGB();

	if (colorSpace == NULL) {
        NSLog(@"Error allocating color space\n");
		return NULL;
	}
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL) {
        NSLog(@"Memory is not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
    context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedFirst);
	if (context == NULL) {
		free (bitmapData);
        NSLog(@"Context is not created!");
	}
	
	// Make sure and release colorspace before returning
	CGColorSpaceRelease(colorSpace);
	
	return context;
}

@end
