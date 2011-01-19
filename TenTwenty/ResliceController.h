//
//  ResliceController.h
//  TenTwenty
//
//  Created by John Haitas on 12/14/10.
//  Copyright 2010 Vanderbilt University. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PluginFilter.h"
#import "MPRHeaders.h"

@interface ResliceController : NSObject {
    MPRDCMView *view;
}

- (id) initWithView: (MPRDCMView *) theView;

- (void) planeWithVertex: (Point3D *) vertexPt
              withPoint1: (Point3D *) point1Pt
              withPoint2: (Point3D *) point2Pt;

- (void) point3d: (Point3D *) point toWorldCoords: (float *) worldCoords;

@end
