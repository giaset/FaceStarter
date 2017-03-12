//
//  ViewController.m
//  ME
//
//  Created by Jack Rogers on 5/4/16.
//  Copyright © 2016 Jack Rogers. All rights reserved.
//

#import "ViewController.h"
#import "ClarifaiClient.h"
#import "FaceDetector.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //populate these values with your own appID and appSecret.
  NSString *appID = @"Au7oy8WFvhMXGVFWvpZmrOcKg6sKUIHH4asWAfXa";
  NSString *appSecret = @"luabv1TNQn0gXMaTkfz20ho4_AjOF7Wp3xNkQ8Ye";
  
  ClarifaiClient *client = [[ClarifaiClient alloc] initWithAppID:appID appSecret:appSecret];
  client.enableFaceModel = YES;
  client.enableEmbed = YES;
  
  FaceDetector *faceDetector = [[FaceDetector alloc] init];
  
  UIImage *lorne = [UIImage imageNamed:@"geth.jpg"];
  NSArray *faces = [faceDetector facesFromImage:lorne];
  NSMutableArray *faceJpegs = [NSMutableArray array];
  for (NSValue *faceBounds in faces) {
    UIImage *faceImage = [faceDetector faceImageFromImage:lorne faceBounds:faceBounds.CGRectValue];
    [faceJpegs addObject:UIImageJPEGRepresentation(faceImage, 0.9)];
  }
  
  [client recognizeJpegs:faceJpegs completion:^(NSArray<ClarifaiResult *> *results, NSError *error) {
    NSLog(@"embedding: %@", results[0].embed);
  }];
  
}

@end
