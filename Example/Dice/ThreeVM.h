//  Project name: Dice
//  File name   : ThreeVM.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/23/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 BurtK. All rights reserved.
//  --------------------------------------------------------------

#import <GLKit/GLKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface ThreeVM : NSObject {
}

@property (nonatomic, assign) float_t cameraWidth;
@property (nonatomic, assign) float_t cameraHeight;


/// Build camera matrix.
- (void)constructCameraMatrix;

- (void)validateFrame:(CVImageBufferRef)frame;

/// Construct world position from camera position.
- (GLKMatrix4)constructWorldPositionFromScreenPosition:(CGPoint)point;

@end
