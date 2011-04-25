//
//  TraceController.h
//  TenTwenty
//
//  Created by John Haitas on 12/16/10.
//  Copyright 2010 Vanderbilt University. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OsiriXAPI/PluginFilter.h>
#import <OsiriXAPI/MPRDCMView.h>

@interface TraceController : NSObject {
    DCMPix      *pix;
    float       minScalp,maxSkull;
    int         numPoints;
    ROI         *trace;
    NSArray     *searchPaths;
}

@property (readonly)    ROI     *trace;
@property (readonly)    NSArray *searchPaths;
@property (assign)      float   minScalp,maxSkull;

- (id) initWithPix: (DCMPix *)  thePix
          minScalp: (float)     theMinScalp
          maxSkull: (float)     theMaxSkull
         numPoints: (int)       theNumPoints;

- (void) traceFromPtA: (Point3D *) pointAPt
             toPointB: (Point3D *) pointBPt
           withVertex: (Point3D *) vertexPt;

- (NSPoint) findFromPosition: (float [3]) position
                 inDirection: (float [3]) direction;

- (BOOL) isPointOnPix: (NSPoint) point;

- (void) point3d: (Point3D *) point
   toDicomCoords: (float [3]) dicomCoords;

@end
