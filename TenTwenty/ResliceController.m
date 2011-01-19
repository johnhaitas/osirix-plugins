//
//  ResliceController.m
//  TenTwenty
//
//  Created by John Haitas on 12/14/10.
//  Copyright 2010 Vanderbilt University. All rights reserved.
//

#import "ResliceController.h"

#define VECTOR(vec,origin,endopint) \
    vec[0]=endopint[0]-origin[0]; \
    vec[1]=endopint[1]-origin[1]; \
    vec[2]=endopint[2]-origin[2];

#define MAG(v1) sqrt(v1[0]*v1[0]+v1[1]*v1[1]+v1[2]*v1[2]);

#define UNIT(unitVec,vec) \
    unitVec[0]=vec[0]/MAG(vec); \
    unitVec[1]=vec[1]/MAG(vec); \
    unitVec[2]=vec[2]/MAG(vec);

#define CROSS(dest,v1,v2) \
    dest[0]=v1[1]*v2[2]-v1[2]*v2[1]; \
    dest[1]=v1[2]*v2[0]-v1[0]*v2[2]; \
    dest[2]=v1[0]*v2[1]-v1[1]*v2[0];

@implementation ResliceController

- (id) initWithView: (MPRDCMView *) theView
{
    if (self = [super init]) {
        view = theView;
    } else {
        NSLog(@"failed to initialize ResliceController");
    }

    return self;
}

- (void) planeWithVertex: (Point3D *) vertexPt
              withPoint1: (Point3D *) point1Pt
              withPoint2: (Point3D *) point2Pt
{
    float   vertex[3],point1[3],point2[3];
    float   vector1[3],vector2[3],camPos[3],direction[3],viewUp[3];
    float   unitDirection[3],unitViewUp[3];
    float   clipRange;
    
    // get 3d positions of each point
    [self point3d: vertexPt toWorldCoords:vertex];
    [self point3d: point1Pt toWorldCoords:point1];
    [self point3d: point2Pt toWorldCoords:point2];
    
    // set camera position as average position
    camPos[0] = ( vertex[0] + point1[0] + point2[0] ) / 3.0;
    camPos[1] = ( vertex[1] + point1[1] + point2[1] ) / 3.0;
    camPos[2] = ( vertex[2] + point1[2] + point2[2] ) / 3.0;
    
    // define vectors
    VECTOR(vector1,vertex,point1);
    VECTOR(vector2,vertex,point2);
    
    // direction is the cross product of the two vectors...
    // the order of operations is important..
    // cross product is anticommutative...
    CROSS(direction,vector2,vector1);
    
    // view up points at the vertex from camera position
    VECTOR(viewUp,camPos,vertex);
    
    // turn these vectors into unit vectors
    UNIT(unitDirection,direction);
    UNIT(unitViewUp,viewUp);
    
    // compute clipping range for proper positioning
    clipRange = ( view.camera.clippingRangeFar - view.camera.clippingRangeNear ) / 2.0;
    
    // adjust camera position to account for clipping range...
    // ... clipping range is 
    camPos[0] -= clipRange * unitDirection[0];
    camPos[1] -= clipRange * unitDirection[1];
    camPos[2] -= clipRange * unitDirection[2];
    
    // release existing position, focalPoint and viewUp ...
    // ... we are about to allocate new objects in their place
    [view.camera.position release];
    [view.camera.focalPoint release];
    [view.camera.viewUp release];
    
    // set the position
    view.camera.position    = [Point3D pointWithX:camPos[0]
                                                y:camPos[1]
                                                z:camPos[2] ];
    // set the viewUp
    view.camera.viewUp      = [Point3D pointWithX:unitViewUp[0]
                                                y:unitViewUp[1]
                                                z:unitViewUp[2] ];
    
    // the focal point is the camera direction added to the position
    view.camera.focalPoint = [[Point3D alloc] initWithPoint3D:view.camera.position];
    [view.camera.focalPoint add:[Point3D pointWithX:unitDirection[0]
                                                  y:unitDirection[1]
                                                  z:unitDirection[2]]];
    
    // inform the view of the new camera properties
    [view restoreCamera];
    
    // update the view
    [view display];
}

- (void) point3d: (Point3D *) point toWorldCoords: (float [3]) worldCoords
{
    float factor;
    factor = [view.vrView factor];
    worldCoords[0] = point.x * factor;
    worldCoords[1] = point.y * factor;
    worldCoords[2] = point.z * factor;
}

@end
