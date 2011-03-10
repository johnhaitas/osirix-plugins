//
//  StereotaxPointController.m
//  StereotaxPoint
//
//  Created by John Haitas on 1/6/11.
//  Copyright 2011 Vanderbilt University. All rights reserved.
//

#import "StereotaxPointController.h"


@implementation StereotaxPointController

@synthesize apViewSelect,mlViewSelect,dvViewSelect;
@synthesize originX,originY,originZ;
@synthesize apX,apY,apZ;
@synthesize mlX,mlY,mlZ;
@synthesize dvX,dvY,dvZ;
@synthesize pointColor;
@synthesize pointAP,pointML,pointDV;

- (id) init
{
    if (self = [super init]) {
        [NSBundle loadNibNamed:@"StereotaxPointHUD" owner:self];
    }
    return self;
}

- (void) prepareStereotaxPoint: (PluginFilter *) stereotaxPointFilter
{

    owner = stereotaxPointFilter;

    viewerController    = [owner valueForKey:@"viewerController"];

    // get name of study and series for saving and archiving data
    studyName = [[[[viewerController imageView] seriesObj] valueForKey:@"study"] valueForKey:@"name"];
    seriesName = [[[viewerController imageView] seriesObj] valueForKey:@"name"];

    fileManager     = [NSFileManager defaultManager];
    saveFileName    = [NSString stringWithFormat:@"%@/stereotaxOrientation.plist",[self pathForSeriesData]];

    // for some reason saveFileName goes out of scope outside of this method
    [saveFileName retain];

    if ([fileManager fileExistsAtPath:saveFileName]) {
        NSDictionary    *stereotaxOrientation;
        
        stereotaxOrientation = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:saveFileName]];
        
        [self setOrientationFromDictionary:stereotaxOrientation];
    }

}

- (IBAction) open3dMpr: (id) sender
{
    // create a new MPR viewer
    mprViewer = [viewerController openMPRViewer];
    [viewerController place3DViewerWindow:(NSWindowController *)mprViewer];
    [mprViewer showWindow:self];
    [[mprViewer window] setTitle: [NSString stringWithFormat:@"%@: %@", [[mprViewer window] title], [[viewerController window] title]]];
}


- (IBAction) saveOrientation: (id) sender
{
    NSDictionary *stereotaxOrientation;

    stereotaxOrientation = [self generateOrientationDictionary];

    [stereotaxOrientation writeToURL:[NSURL fileURLWithPath:saveFileName] atomically:YES];
}

- (IBAction) loadOrientation: (id) sender
{
    NSDictionary    *stereotaxOrientation;
     
    stereotaxOrientation = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:saveFileName]];

    [self setOrientationFromDictionary:stereotaxOrientation];
}

- (IBAction) flipAPSigns: (id) sender
{
    [apX setFloatValue: -[apX floatValue]];
    [apY setFloatValue: -[apY floatValue]];
    [apZ setFloatValue: -[apZ floatValue]];
}

- (IBAction) flipMLSigns: (id) sender
{
    [mlX setFloatValue: -[mlX floatValue]];
    [mlY setFloatValue: -[mlY floatValue]];
    [mlZ setFloatValue: -[mlZ floatValue]];
}

- (IBAction) flipDVSigns: (id) sender
{
    [dvX setFloatValue: -[dvX floatValue]];
    [dvY setFloatValue: -[dvY floatValue]];
    [dvZ setFloatValue: -[dvZ floatValue]];
}

- (IBAction) setOriginAndDirections: (id) sender
{
    float factor,clipRange;
    float dir[3],unitDir[3],displacement[3],origin[3];
    Point3D *thisDirection,*thisPosition;
    Camera  *cam;
    MPRDCMView *apView,*mlView,*dvView;

    cam = mprViewer.mprView1.camera;

    factor = [mprViewer.mprView1.vrView factor];
    clipRange = ( cam.clippingRangeFar - cam.clippingRangeNear ) / 2.0;

    thisPosition = [[Point3D alloc] initWithPoint3D:cam.position];

    // compute direction of camera for computing clipping plane
    thisDirection = [[Point3D alloc] initWithPoint3D:cam.focalPoint];
    [thisDirection subtract:thisPosition];
    dir[0] = thisDirection.x;
    dir[1] = thisDirection.y;
    dir[2] = thisDirection.z;
    UNIT(unitDir,dir);
    [thisDirection release];
    thisDirection = nil;

    displacement[0] = clipRange * unitDir[0];
    displacement[1] = clipRange * unitDir[1];
    displacement[2] = clipRange * unitDir[2];

    // compute the origin by adding diplacement to position and convert back to DICOM coords
    origin[0] = (thisPosition.x + displacement[0]) / factor;
    origin[1] = (thisPosition.y + displacement[1]) / factor;
    origin[2] = (thisPosition.z + displacement[2]) / factor;

    // set origin   
    [originX setFloatValue: origin[0]];
    [originY setFloatValue: origin[1]];
    [originZ setFloatValue: origin[2]];

    // get view selections from interface
    apView = [mprViewer valueForKey:[apViewSelect stringValue]];
    mlView = [mprViewer valueForKey:[mlViewSelect stringValue]];
    dvView = [mprViewer valueForKey:[dvViewSelect stringValue]];

    // AP vector
    [self setAxisComponents: apView
                     xField: apX
                     yField: apY
                     zField: apZ        ];

    // ML vector
    [self setAxisComponents: mlView
                     xField: mlX
                     yField: mlY
                     zField: mlZ        ];

    // DV vector
    [self setAxisComponents: dvView
                     xField: dvX
                     yField: dvY
                     zField: dvZ        ];

    // release allocated object
    [thisPosition release];
}

- (IBAction) openVrViewer: (id) sender
{
    float           iwl, iww;

    vrViewer = [viewerController openVRViewerForMode:@"VR"];

    [vrViewer ApplyCLUTString: [viewerController curCLUTMenu]];
    [[viewerController imageView] getWLWW:&iwl :&iww];
    [vrViewer setWLWW:iwl :iww];
    [viewerController place3DViewerWindow: vrViewer];
    [vrViewer load3DState];
    [vrViewer showWindow:viewerController];			
    [[vrViewer window] makeKeyAndOrderFront:viewerController];
    [[vrViewer window] display];

    [self getVrViewer3dPointColor];
}

- (IBAction) importCSV: (id) sender
{
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];

    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];

    // Disable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:NO];

    // Disable the ability to select multiple files
    [openDlg setAllowsMultipleSelection:NO];

    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton )
    {        
        // We only want one file - first element of URLs array        
        NSURL* fileName = [[[openDlg URLs] objectAtIndex:0] retain];

        [self readCsvFromURL:fileName];
    }
}

- (IBAction) addPoint: (id) sender
{
    NSDictionary *point;

    point = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithFloat:[pointAP floatValue]],@"ap",
                                                        [NSNumber numberWithFloat:[pointML floatValue]],@"ml",
                                                        [NSNumber numberWithFloat:[pointDV floatValue]],@"dv",
                                                        nil                                                     ];

    [self setPoint:point];
}

- (BOOL)readCsvFromURL:(NSURL *)absoluteURL
{
    NSString *fileContents;
    NSArray *rows;

    fileContents = [NSString stringWithContentsOfURL:absoluteURL
                                          encoding:NSUTF8StringEncoding
                                             error:nil];

    if ( nil == fileContents ) return NO;

    rows = [fileContents componentsSeparatedByString:@"\r"];

    for (NSString *row in rows) {
        NSArray *cells = [row componentsSeparatedByString:@","];

        NSDictionary *point = [NSDictionary dictionaryWithObjectsAndKeys:[cells objectAtIndex:0],@"name",
                                                                         [NSNumber numberWithFloat:[[cells objectAtIndex:1] floatValue]],@"ap",
                                                                         [NSNumber numberWithFloat:[[cells objectAtIndex:2] floatValue]],@"ml",
                                                                         [NSNumber numberWithFloat:[[cells objectAtIndex:3] floatValue]],@"dv",
                                                                         nil];

        [self setPoint:point];
    }
    return YES;
}

- (void) setAxisComponents: (MPRDCMView *) view
                    xField: (NSTextField *) xField
                    yField: (NSTextField *) yField
                    zField: (NSTextField *) zField
{
    Point3D *thisDirection;
    float   thisComp[3],unitComp[3];
    thisDirection = [[Point3D alloc] initWithPoint3D:view.camera.focalPoint];
    [thisDirection subtract:view.camera.position];
    thisComp[0] = thisDirection.x;
    thisComp[1] = thisDirection.y;
    thisComp[2] = thisDirection.z;
    [thisDirection release];
    thisDirection = nil;
    UNIT(unitComp,thisComp);
    [xField setFloatValue:unitComp[0]];
    [yField setFloatValue:unitComp[1]];
    [zField setFloatValue:unitComp[2]];
}

- (void) setPoint:(NSDictionary *) dict
{
    enum planes{AP,ML,DV};
    float x,y,z;
    float distAP,distML,distDV;
    float xDiff[3],yDiff[3],zDiff[3];

    // get the AP,ML,DV distances from origin
    distAP = [[dict objectForKey:@"ap"] floatValue];
    distML = [[dict objectForKey:@"dv"] floatValue];
    distDV = [[dict objectForKey:@"ml"] floatValue];

    // compute x,y,z components of AP plane
    xDiff[AP] = distAP * [apX floatValue];
    yDiff[AP] = distAP * [apY floatValue];
    zDiff[AP] = distAP * [apZ floatValue];

    // compute x,y,z components of ML plane
    xDiff[ML] = distML * [mlX floatValue];
    yDiff[ML] = distML * [mlY floatValue];
    zDiff[ML] = distML * [mlZ floatValue];

    // compute x,y,z components of DV plane
    xDiff[DV] = distDV * [dvX floatValue];
    yDiff[DV] = distDV * [dvY floatValue];
    zDiff[DV] = distDV * [dvZ floatValue];

    // compute x,y,z by adding AP,ML,and DV components to stereotax origin
    x = [originX floatValue] + xDiff[AP] + xDiff[ML] + xDiff[DV];
    y = [originY floatValue] + yDiff[AP] + yDiff[ML] + yDiff[DV];
    z = [originZ floatValue] + zDiff[AP] + zDiff[ML] + zDiff[DV];

    [vrViewer.view add3DPoint: x 
                             : y 
                             : z 
                             : [[vrViewer.view valueForKey:@"point3DDefaultRadius"] floatValue]
                             : [[pointColor color] redComponent] 
                             : [[pointColor color] greenComponent] 
                             : [[pointColor color] blueComponent]                               ];
    
    DLog(@"x,y,z = %f,%f,%f",x,y,z);

    // update the display
    [vrViewer.view display];
}

- (void) getVrViewer3dPointColor
{
    [pointColor setColor:[NSColor colorWithCalibratedRed: [[vrViewer.view valueForKey:@"point3DDefaultColorRed"] floatValue]
                                                   green: [[vrViewer.view valueForKey:@"point3DDefaultColorGreen"] floatValue]
                                                    blue: [[vrViewer.view valueForKey:@"point3DDefaultColorBlue"] floatValue]
                                                   alpha: [[vrViewer.view valueForKey:@"point3DDefaultColorAlpha"] floatValue] ]];   
}

- (NSString *) pathForStereotaxPointData
{    
    NSString *folder = @"~/Library/Application Support/OsiriX/StereotaxPoint";
    folder = [folder stringByExpandingTildeInPath];

    // create the folder if it doesn't exist    
    if ([fileManager fileExistsAtPath: folder] == NO) {
        DLog(@"Creating StereotaxPoint data folder at: %@",folder);
        [fileManager createDirectoryAtPath: folder attributes: nil];
    }

    return folder;
}

- (NSString *) pathForStudyData
{
    NSString *studyFolder;

    studyFolder     = [[self pathForStereotaxPointData] stringByAppendingFormat:@"/%@",studyName];

    // create the study folder if it doesn't exist    
    if ([fileManager fileExistsAtPath: studyFolder] == NO) {
        DLog(@"Creating study folder at: %@",studyFolder);
        [fileManager createDirectoryAtPath: studyFolder attributes: nil];
    }

    return studyFolder;
}

- (NSString *) pathForSeriesData
{
    NSString *seriesFolder;

    seriesFolder    = [[self pathForStudyData] stringByAppendingFormat:@"/%@",seriesName];

    // create the series folder if it doesn't exist    
    if ([fileManager fileExistsAtPath: seriesFolder] == NO) {
        DLog(@"Creating series folder at: %@",seriesFolder);
        [fileManager createDirectoryAtPath: seriesFolder attributes: nil];
    }

    return seriesFolder;
}

- (NSDictionary *) generateOrientationDictionary
{
    NSDictionary *stereotaxOrientation,*origin,*axes,*ap,*ml,*dv;

    // origin components
    origin = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:[originX floatValue]],@"x",
                                                        [NSNumber numberWithFloat:[originY floatValue]],@"y",
                                                        [NSNumber numberWithFloat:[originZ floatValue]],@"z",
                                                        nil                                                     ];

    // AP axis components
    ap = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:[apX floatValue]],@"x",
                                                    [NSNumber numberWithFloat:[apY floatValue]],@"y",
                                                    [NSNumber numberWithFloat:[apZ floatValue]],@"z",
                                                    nil                                                 ];

    // ML axis components
    ml = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:[mlX floatValue]],@"x",
                                                    [NSNumber numberWithFloat:[mlY floatValue]],@"y",
                                                    [NSNumber numberWithFloat:[mlZ floatValue]],@"z",
                                                    nil                                                 ];

    // DV axis components
    dv = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:[dvX floatValue]],@"x",
                                                    [NSNumber numberWithFloat:[dvY floatValue]],@"y",
                                                    [NSNumber numberWithFloat:[dvZ floatValue]],@"z",
                                                    nil                                                 ];

    // Axes
    axes = [NSDictionary dictionaryWithObjectsAndKeys:ap,@"AP",ml,@"ML",dv,@"DV",nil];

    // Complete dictionary for saving
    stereotaxOrientation = [NSDictionary dictionaryWithObjectsAndKeys:origin,@"Origin",axes,@"Axes",nil];

    return stereotaxOrientation;
}

- (void) setOrientationFromDictionary: (NSDictionary *) stereotaxOrientation
{
    NSDictionary *origin,*axes,*ap,*ml,*dv;

    origin = [stereotaxOrientation objectForKey:@"Origin"];
    axes = [stereotaxOrientation objectForKey:@"Axes"];
    ap = [axes objectForKey:@"AP"];
    ml = [axes objectForKey:@"ML"];
    dv = [axes objectForKey:@"DV"];

    [originX setFloatValue:[[origin objectForKey:@"x"] floatValue]];
    [originY setFloatValue:[[origin objectForKey:@"y"] floatValue]];
    [originZ setFloatValue:[[origin objectForKey:@"z"] floatValue]];

    [apX setFloatValue:[[ap objectForKey:@"x"] floatValue]];
    [apY setFloatValue:[[ap objectForKey:@"y"] floatValue]];
    [apZ setFloatValue:[[ap objectForKey:@"z"] floatValue]];

    [mlX setFloatValue:[[ml objectForKey:@"x"] floatValue]];
    [mlY setFloatValue:[[ml objectForKey:@"y"] floatValue]];
    [mlZ setFloatValue:[[ml objectForKey:@"z"] floatValue]];

    [dvX setFloatValue:[[dv objectForKey:@"x"] floatValue]];
    [dvY setFloatValue:[[dv objectForKey:@"y"] floatValue]];
    [dvZ setFloatValue:[[dv objectForKey:@"z"] floatValue]];
}

@end
