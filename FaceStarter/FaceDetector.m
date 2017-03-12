//
//  FaceDetector.m
//  ME
//
//  Created by Jack Rogers on 5/5/16.
//  Copyright © 2016 Jack Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceDetector.h"

@interface FaceDetector ()

@property (strong, nonatomic) CIDetector *faceDetector;

@end

@implementation FaceDetector

static CGPoint rectCenter(CGRect rect) {
  return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

- (CGRect)UIBoundsFromCGBounds:(CGRect)bounds imageHeight:(CGFloat)imageHeight {
  CGFloat y = imageHeight - bounds.size.height - bounds.origin.y;
  return CGRectMake(bounds.origin.x, y, bounds.size.width, bounds.size.height);
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                           context:nil
                                           options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
  }
  return self;
}

- (UIImage *)faceImageFromImage:(UIImage *)image
                     faceBounds:(CGRect)faceBounds {
  // Scale the face bounds to input image size.
  CGPoint faceCenter = rectCenter(faceBounds);
  
  // The API requires images to be a certain size. Compute this size and set up graphics context.
  CGSize outSize = [self apiImageSizeForBounds:faceBounds];
  UIGraphicsBeginImageContext(outSize);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // Translate to image center, rotate, then translate back to the image edge, then scale
  // (applied to the transformation matrix in reverse order).
  CGContextScaleCTM(context, outSize.width / faceBounds.size.width, outSize.width / faceBounds.size.width);
  CGContextTranslateCTM(context, faceBounds.size.width / 2, faceBounds.size.height / 2);
  
  CGContextTranslateCTM(context, -faceCenter.x, -faceCenter.y);
  [image drawAtPoint:CGPointZero];
  UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return result;
}

/** Returns the size of the image to send to the API for a face with given bounds. */
- (CGSize)apiImageSizeForBounds:(CGRect)bounds {
  CGSize newSize;
  CGFloat aspectRatio = bounds.size.width / bounds.size.height;
  if (aspectRatio >= 1) {
    newSize.width = round(128 * aspectRatio);
    newSize.height = 128;
  } else {
    newSize.width = 128;
    newSize.height = round(128 / aspectRatio);
  }
  return newSize;
}

- (NSArray *)facesFromImage:(UIImage *)image {
  CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
  
  NSMutableArray *faces = [[NSMutableArray alloc] init];
  CIDetector *detector = self.faceDetector;
  for (CIFaceFeature *feature in [detector featuresInImage:ciImage]) {
    // The returned bounds are in the CoreGraphics coordinate system (origin in lower-left).
    // Transform to UIKit coordinate system with origin in upper-left.
    CGRect bounds = [self UIBoundsFromCGBounds:feature.bounds
                                   imageHeight:image.size.height];
    [faces addObject:[NSValue valueWithCGRect:bounds]];
  }
  return faces;
}

// Need to process photo taken by the camera with this method (to fix its underlying orientation) before face detection.
// Reference: http://blog.logichigh.com/2008/06/05/uiimage-fix/
- (UIImage *)scaleAndRotateImageForRecognition:(UIImage *)image {
  static int kMaxResolution = 960;
  
  CGImageRef imgRef = image.CGImage;
  CGFloat width = CGImageGetWidth(imgRef);
  CGFloat height = CGImageGetHeight(imgRef);
  
  CGAffineTransform transform = CGAffineTransformIdentity;
  CGRect bounds = CGRectMake(0, 0, width, height);
  if (width > kMaxResolution || height > kMaxResolution) {
    CGFloat ratio = width/height;
    if (ratio > 1) {
      bounds.size.width = kMaxResolution;
      bounds.size.height = bounds.size.width / ratio;
    } else {
      bounds.size.height = kMaxResolution;
      bounds.size.width = bounds.size.height * ratio;
    }
  }
  
  CGFloat scaleRatio = bounds.size.width / width;
  CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
  CGFloat boundHeight;
  
  UIImageOrientation orient = image.imageOrientation;
  switch(orient) {
    case UIImageOrientationUp:
      transform = CGAffineTransformIdentity;
      break;
    case UIImageOrientationUpMirrored:
      transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      break;
    case UIImageOrientationDown:
      transform = CGAffineTransformMakeTranslation
      (imageSize.width, imageSize.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
      transform = CGAffineTransformScale(transform, 1.0, -1.0);
      break;
    case UIImageOrientationLeftMirrored:
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation
      (imageSize.height, imageSize.width);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
      break;
    case UIImageOrientationLeft:
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
      break;
    case UIImageOrientationRightMirrored:
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeScale(-1.0, 1.0);
      transform = CGAffineTransformRotate(transform, M_PI / 2.0);
      break;
    case UIImageOrientationRight:
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
      transform = CGAffineTransformRotate(transform, M_PI / 2.0);
      break;
    default:
      [NSException raise:NSInternalInconsistencyException
                  format:@"Invalid image orientation"];
  }
  
  UIGraphicsBeginImageContext(bounds.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
    CGContextScaleCTM(context, -scaleRatio, scaleRatio);
    CGContextTranslateCTM(context, -height, 0);
  } else {
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
  }
  CGContextConcatCTM(context, transform);
  CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
  UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return returnImage;
}

@end
