//
//  FaceDetector.h
//  ME
//
//  Created by Jack Rogers on 5/5/16.
//  Copyright © 2016 Jack Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceDetector : NSObject

- (NSArray *)facesFromImage:(UIImage *)image;

- (UIImage *)faceImageFromImage:(UIImage *)image
                     faceBounds:(CGRect)faceBounds;

@end
