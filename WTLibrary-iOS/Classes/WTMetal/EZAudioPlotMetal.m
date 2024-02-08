//
//  Class.m
//  MTankSSS
//
//  Created by mini2022 on 18/1/2567 BE.
//  Copyright © 2567 BE Wat Wongtanuwat. All rights reserved.
//

#import "EZAudioPlotMetal.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <EZAudio/EZAudioDisplayLink.h>
#import <EZAudio/EZAudioUtilities.h>
//#import <EZAudio/EZAudioPlot.h>
//#import <EZAudio/EZAudio.h>
//#import "EZAudioDisplayLink.h"
//#import "EZAudioUtilities.h"
//#import "EZAudioPlot.h"

UInt32 const EZAudioPlotDefaultHistoryBufferLengthMT = 512;
UInt32 const EZAudioPlotDefaultMaxHistoryBufferLengthMT = 8192;

//------------------------------------------------------------------------------
#pragma mark - Data Structures
//------------------------------------------------------------------------------

typedef struct
{
    BOOL                interpolated;
    EZPlotHistoryInfo  *historyInfo;
    EZAudioPlotGLPoint *points;
    UInt32              pointCount;
    GLuint              vbo;
    GLuint              vab;
} EZAudioPlotGLInfo;

//------------------------------------------------------------------------------
#pragma mark - EZAudioPlotGL (Interface Extension)
//------------------------------------------------------------------------------

@interface EZAudioPlotMetal () <EZAudioDisplayLinkDelegate>
@property (nonatomic, strong) GLKBaseEffect      *baseEffect;
@property (nonatomic, strong) EZAudioDisplayLink *displayLink;
@property (nonatomic, assign) EZAudioPlotGLInfo  *info;

@property (nonatomic, strong) id<MTLDevice> metalDevice;
@property (nonatomic, strong) id<MTLCommandQueue> metalCommandQueue;

@end

//------------------------------------------------------------------------------
#pragma mark - EZAudioPlotGL (Implementation)
//------------------------------------------------------------------------------

@implementation EZAudioPlotMetal

- (NSString *)description{
//    return [NSString stringWithFormat:@"\
//            \n presetName: = %@\
//            \n cutIn: = %@ , playMode: = %lu\
//            \n crossfadeTime: = %f\
//            \n autoFadeoutTime: = %f\
//            \n speed: = %f , pitch: = %f\
//            \n lockMixerVol: = %@\
//            \n sampler list: = %@",
//            _presetName,
//            WTBOOL(_cutIn),(unsigned long)_playMode,
//            _crossfadeTime,
//            _autoFadeoutTime,
//            _speed, _pitch,
//            WTBOOL(_lockMixerVol),
//            _samplerSoundItemArray
//    ];
    return @"";
}

//------------------------------------------------------------------------------
#pragma mark - Dealloc
//------------------------------------------------------------------------------

- (void)dealloc
{
    [self.displayLink stop];
    self.displayLink = nil;
    [EZAudioUtilities freeHistoryInfo:self.info->historyInfo];
#if !TARGET_OS_IPHONE
    glDeleteVertexArrays(1, &self.info->vab);
#endif
    glDeleteBuffers(1, &self.info->vbo);
    free(self.info->points);
    free(self.info);
    self.baseEffect = nil;
}

//------------------------------------------------------------------------------
#pragma mark - Initialization
//------------------------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

//------------------------------------------------------------------------------

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

//------------------------------------------------------------------------------

- (instancetype)initWithFrame:(EZRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

//------------------------------------------------------------------------------

#if TARGET_OS_IPHONE
- (instancetype)initWithFrame:(CGRect)frame
                      device:(id<MTLDevice>)device
{
    self = [super initWithFrame:frame device:device];
    if (self)
    {
        [self setup];
    }
    return self;
}
#elif TARGET_OS_MAC
- (instancetype)initWithFrame:(NSRect)frameRect
                  pixelFormat:(NSOpenGLPixelFormat *)format
{
    self = [super initWithFrame:frameRect pixelFormat:format];
    if (self)
    {
        [self setup];
    }
    return self;
}
#endif

//------------------------------------------------------------------------------
#pragma mark - Setup
//------------------------------------------------------------------------------

- (void)setup
{
    //
    // Setup info data structure
    //
    self.info = (EZAudioPlotGLInfo *)malloc(sizeof(EZAudioPlotGLInfo));
    memset(self.info, 0, sizeof(EZAudioPlotGLInfo));
    
    //
    // Create points array
    //
    UInt32 pointCount = [self maximumRollingHistoryLength];
    self.info->points = (EZAudioPlotGLPoint *)calloc(sizeof(EZAudioPlotGLPoint), pointCount);
    self.info->pointCount = pointCount;
    
    //
    // Create the history data structure to hold the rolling data
    //
    self.info->historyInfo = [EZAudioUtilities historyInfoWithDefaultLength:[self defaultRollingHistoryLength]
                                                              maximumLength:[self maximumRollingHistoryLength]];
    
    //
    // Setup Metal specific stuff
    //
    [self setupMetal];
    
    //
    // Setup view properties
    //
    self.gain = 1.0f;
#if TARGET_OS_IPHONE
    self.backgroundColor = [UIColor colorWithRed:0.569f green:0.82f blue:0.478f alpha:1.0f];
    self.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
#elif TARGET_OS_MAC
    self.backgroundColor = [NSColor colorWithCalibratedRed:0.569f green:0.82f blue:0.478f alpha:1.0f];
    self.color = [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
#endif
    
    //
    // Allow subclass to initialize plot
    //
    [self setupPlot];
    
    //
    // Create the display link
    //
    self.displayLink = [EZAudioDisplayLink displayLinkWithDelegate:self];
    [self.displayLink start];
}

//------------------------------------------------------------------------------

- (void)setupPlot
{
    //
    // Override in subclass
    //
}

//------------------------------------------------------------------------------

- (void)setupOpenGL
{
//    self.baseEffect = [[GLKBaseEffect alloc] init];
//    self.baseEffect.useConstantColor = YES;
//#if TARGET_OS_IPHONE
//    if (!self.context)
//    {
//        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    }
//    [EAGLContext setCurrentContext:self.context];
//    self.drawableColorFormat   = GLKViewDrawableColorFormatRGBA8888;
//    self.drawableDepthFormat   = GLKViewDrawableDepthFormat24;
//    self.drawableStencilFormat = GLKViewDrawableStencilFormat8;
//    self.drawableMultisample   = GLKViewDrawableMultisample4X;
//    self.opaque                = NO;
//    self.enableSetNeedsDisplay = NO;
//#elif TARGET_OS_MAC
//    self.wantsBestResolutionOpenGLSurface = YES;
//    self.wantsLayer = YES;
//    self.layer.opaque = YES;
//    self.layer.backgroundColor = [NSColor clearColor].CGColor;
//    if (!self.pixelFormat)
//    {
//        NSOpenGLPixelFormatAttribute attrs[] =
//        {
//            NSOpenGLPFADoubleBuffer,
//            NSOpenGLPFAMultisample,
//            NSOpenGLPFASampleBuffers,      1,
//            NSOpenGLPFASamples,            4,
//            NSOpenGLPFADepthSize,          24,
//            NSOpenGLPFAOpenGLProfile,
//            NSOpenGLProfileVersion3_2Core, 0
//        };
//        self.pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
//    }
//#if DEBUG
//    NSAssert(self.pixelFormat, @"Could not create OpenGL pixel format so context is not valid");
//#endif
//    self.openGLContext = [[NSOpenGLContext alloc] initWithFormat:self.pixelFormat
//                                                    shareContext:nil];
//    GLint swapInt = 1; GLint surfaceOpacity = 0;
//    [self.openGLContext setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
//    [self.openGLContext setValues:&surfaceOpacity forParameter:NSOpenGLCPSurfaceOpacity];
//    [self.openGLContext lock];
//    glGenVertexArrays(1, &self.info->vab);
//    glBindVertexArray(self.info->vab);
//#endif
//    glGenBuffers(1, &self.info->vbo);
//    glBindBuffer(GL_ARRAY_BUFFER, self.info->vbo);
//    glBufferData(GL_ARRAY_BUFFER,
//                 self.info->pointCount * sizeof(EZAudioPlotGLPoint),
//                 self.info->points,
//                 GL_STREAM_DRAW);
//#if !TARGET_OS_IPHONE
//    [self.openGLContext unlock];
//#endif
//    self.frame = self.frame;
}
- (void)setupMetal
{
    self.metalDevice = MTLCreateSystemDefaultDevice();
    self.metalCommandQueue = [self.metalDevice newCommandQueue];
    self.device = self.metalDevice;
    self.delegate = self;
    
//            id<MTLLibrary> library = [device newDefaultLibrary];
//            id<MTLFunction> kernelFunction = [library newFunctionWithName:@"add"];
//            //----------------------------------------------------------------------
//            // pipeline
//            NSError *error = NULL;
//            [commandQueue commandBuffer];
//            id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
//            id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];
//            [encoder setComputePipelineState:[device newComputePipelineStateWithFunction:kernelFunction error:&error]];
//            //----------------------------------------------------------------------
//            // Set Data
//            float input[] = {1,2};
//            NSInteger dataSize = sizeof(input);
//
//            [encoder setBuffer:[device newBufferWithBytes:input length:dataSize options:0]
//                        offset:0
//                       atIndex:0];
//
//            id<MTLBuffer> outputBuffer = [device newBufferWithLength:sizeof(float) options:0];
//            [encoder setBuffer:outputBuffer offset:0 atIndex:1];
//            //----------------------------------------------------------------------
//            // Run Kernel
//            MTLSize numThreadgroups = {1,1,1};
//            MTLSize numgroups = {1,1,1};
//            [encoder dispatchThreadgroups:numThreadgroups threadsPerThreadgroup:numgroups];
//            [encoder endEncoding];
//            [commandBuffer commit];
//            [commandBuffer waitUntilCompleted];
//            //----------------------------------------------------------------------
//            // Results
//            float *output = [outputBuffer contents];
//            printf("result = %f\n", output[0]);
    
//    self.baseEffect = [[GLKBaseEffect alloc] init];
//    self.baseEffect.useConstantColor = YES;
//#if TARGET_OS_IPHONE
//    if (!self.context)
//    {
//        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    }
//    [EAGLContext setCurrentContext:self.context];
//    self.drawableColorFormat   = GLKViewDrawableColorFormatRGBA8888;
//    self.drawableDepthFormat   = GLKViewDrawableDepthFormat24;
//    self.drawableStencilFormat = GLKViewDrawableStencilFormat8;
//    self.drawableMultisample   = GLKViewDrawableMultisample4X;
//    self.opaque                = NO;
//    self.enableSetNeedsDisplay = NO;
//#elif TARGET_OS_MAC
//    self.wantsBestResolutionOpenGLSurface = YES;
//    self.wantsLayer = YES;
//    self.layer.opaque = YES;
//    self.layer.backgroundColor = [NSColor clearColor].CGColor;
//    if (!self.pixelFormat)
//    {
//        NSOpenGLPixelFormatAttribute attrs[] =
//        {
//            NSOpenGLPFADoubleBuffer,
//            NSOpenGLPFAMultisample,
//            NSOpenGLPFASampleBuffers,      1,
//            NSOpenGLPFASamples,            4,
//            NSOpenGLPFADepthSize,          24,
//            NSOpenGLPFAOpenGLProfile,
//            NSOpenGLProfileVersion3_2Core, 0
//        };
//        self.pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
//    }
//#if DEBUG
//    NSAssert(self.pixelFormat, @"Could not create OpenGL pixel format so context is not valid");
//#endif
//    self.openGLContext = [[NSOpenGLContext alloc] initWithFormat:self.pixelFormat
//                                                    shareContext:nil];
//    GLint swapInt = 1; GLint surfaceOpacity = 0;
//    [self.openGLContext setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
//    [self.openGLContext setValues:&surfaceOpacity forParameter:NSOpenGLCPSurfaceOpacity];
//    [self.openGLContext lock];
//    glGenVertexArrays(1, &self.info->vab);
//    glBindVertexArray(self.info->vab);
//#endif
//    glGenBuffers(1, &self.info->vbo);
//    glBindBuffer(GL_ARRAY_BUFFER, self.info->vbo);
//    glBufferData(GL_ARRAY_BUFFER,
//                 self.info->pointCount * sizeof(EZAudioPlotGLPoint),
//                 self.info->points,
//                 GL_STREAM_DRAW);
//#if !TARGET_OS_IPHONE
//    [self.openGLContext unlock];
//#endif
    self.frame = self.frame;
}

//------------------------------------------------------------------------------
#pragma mark - Updating The Plot
//------------------------------------------------------------------------------

- (void)updateBuffer:(float *)buffer withBufferSize:(UInt32)bufferSize
{
    //
    // Update history
    //
    [EZAudioUtilities appendBufferRMS:buffer
                       withBufferSize:bufferSize
                        toHistoryInfo:self.info->historyInfo];

    //
    // Convert this data to point data
    //
    switch (self.plotType)
    {
        case EZPlotTypeBuffer:
            [self setSampleData:buffer
                         length:bufferSize];
            break;
        case EZPlotTypeRolling:
            [self setSampleData:self.info->historyInfo->buffer
                         length:self.info->historyInfo->bufferSize];
            break;
        default:
            break;
    }
}

//------------------------------------------------------------------------------

- (void)setSampleData:(float *)data length:(int)length
{
    int pointCount = self.shouldFill ? length * 2 : length;
    EZAudioPlotGLPoint *points = self.info->points;
    for (int i = 0; i < length; i++)
    {
        if (self.shouldFill)
        {
            points[i * 2].x = points[i * 2 + 1].x = i;
            points[i * 2].y = data[i];
            points[i * 2 + 1].y = 0.0f;
        }
        else
        {
            points[i].x = i;
            points[i].y = data[i];
        }
    }
    points[0].y = points[pointCount - 1].y = 0.0f;
    self.info->pointCount = pointCount;
    self.info->interpolated = self.shouldFill;
#if !TARGET_OS_IPHONE
    [self.openGLContext lock];
    glBindVertexArray(self.info->vab);
#endif
    glBindBuffer(GL_ARRAY_BUFFER, self.info->vbo);
    glBufferSubData(GL_ARRAY_BUFFER,
                    0,
                    pointCount * sizeof(EZAudioPlotGLPoint),
                    self.info->points);
#if !TARGET_OS_IPHONE
    [self.openGLContext unlock];
#endif
}

//------------------------------------------------------------------------------
#pragma mark - Adjusting History Resolution
//------------------------------------------------------------------------------

- (int)rollingHistoryLength
{
    return self.info->historyInfo->bufferSize;
}

//------------------------------------------------------------------------------

- (int)setRollingHistoryLength:(int)historyLength
{
    self.info->historyInfo->bufferSize = MIN(EZAudioPlotDefaultMaxHistoryBufferLengthMT, historyLength);
    return self.info->historyInfo->bufferSize;
}

//------------------------------------------------------------------------------
#pragma mark - Clearing The Plot
//------------------------------------------------------------------------------

- (void)clear
{
    float emptyBuffer[1];
    emptyBuffer[0] = 0.0f;
    [self setSampleData:emptyBuffer length:1];
    [EZAudioUtilities clearHistoryInfo:self.info->historyInfo];
#if TARGET_OS_IPHONE
    [self draw];
#elif TARGET_OS_MAC
    [self redraw];
#endif
}

//------------------------------------------------------------------------------
#pragma mark - Start/Stop Display Link
//------------------------------------------------------------------------------

- (void)pauseDrawing
{
    [self.displayLink stop];
}

//------------------------------------------------------------------------------

- (void)resumeDrawing
{
    [self.displayLink start];
}

//------------------------------------------------------------------------------
#pragma mark - Setters
//------------------------------------------------------------------------------

- (void)setBackgroundColor:(id)backgroundColor
{
    _backgroundColor = backgroundColor;
    if (backgroundColor)
    {
        CGColorRef colorRef = [backgroundColor CGColor];
        CGFloat red; CGFloat green; CGFloat blue; CGFloat alpha;
        [EZAudioUtilities getColorComponentsFromCGColor:colorRef
                                                    red:&red
                                                  green:&green
                                                   blue:&blue
                                                  alpha:&alpha];
        //
        // Note! If you set the alpha to be 0 on mac for a transparent view
        // the EZAudioPlotGL will make the superview layer-backed to make
        // sure there is a surface to display itself on (or else you will get
        // some pretty weird drawing glitches
        //
#if !TARGET_OS_IPHONE
        if (alpha == 0.0f)
        {
            [self.superview setWantsLayer:YES];
        }
#endif
        glClearColor(red, green, blue, alpha);
    }
    else
    {
        glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    }
}

//------------------------------------------------------------------------------

- (void)setColor:(id)color
{
    _color = color;
    if (color)
    {
        CGColorRef colorRef = [color CGColor];
        CGFloat red; CGFloat green; CGFloat blue; CGFloat alpha;
        [EZAudioUtilities getColorComponentsFromCGColor:colorRef
                                                    red:&red
                                                  green:&green
                                                   blue:&blue
                                                  alpha:&alpha];
        self.baseEffect.constantColor = GLKVector4Make(red, green, blue, alpha);
    }
    else
    {
        self.baseEffect.constantColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f);
    }
}

//------------------------------------------------------------------------------
#pragma mark - Drawing
//------------------------------------------------------------------------------

- (void)drawRect:(EZRect)rect
{
    [self redraw];
}

//------------------------------------------------------------------------------

- (void)redraw
{
#if !TARGET_OS_IPHONE
    [self.openGLContext makeCurrentContext];
    [self.openGLContext lock];
#endif
    [self redrawWithPoints:self.info->points
                pointCount:self.info->pointCount
                baseEffect:self.baseEffect
        vertexBufferObject:self.info->vbo
         vertexArrayBuffer:self.info->vab
              interpolated:self.info->interpolated
                  mirrored:self.shouldMirror
                      gain:self.gain];
#if !TARGET_OS_IPHONE
    [self.openGLContext flushBuffer];
    [self.openGLContext unlock];
#endif
}

//------------------------------------------------------------------------------

- (void)redrawWithPoints:(EZAudioPlotGLPoint *)points
              pointCount:(UInt32)pointCount
              baseEffect:(GLKBaseEffect *)baseEffect
      vertexBufferObject:(GLuint)vbo
       vertexArrayBuffer:(GLuint)vab
            interpolated:(BOOL)interpolated
                mirrored:(BOOL)mirrored
                    gain:(float)gain
{
    glClear(GL_COLOR_BUFFER_BIT);
    GLenum mode = interpolated ? GL_TRIANGLE_STRIP : GL_LINE_STRIP;
    float interpolatedFactor = interpolated ? 2.0f : 1.0f;
    float xscale = 2.0f / ((float)pointCount / interpolatedFactor);
    float yscale = 1.0f * gain;
    GLKMatrix4 transform = GLKMatrix4MakeTranslation(-1.0f, 0.0f, 0.0f);
    transform = GLKMatrix4Scale(transform, xscale, yscale, 1.0f);
    baseEffect.transform.modelviewMatrix = transform;
#if !TARGET_OS_IPHONE
    glBindVertexArray(vab);
#endif
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    [baseEffect prepareToDraw];
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(EZAudioPlotGLPoint),
                          NULL);
    glDrawArrays(mode, 0, pointCount);
    if (mirrored)
    {
        baseEffect.transform.modelviewMatrix = GLKMatrix4Rotate(transform, M_PI, 1.0f, 0.0f, 0.0f);
        [baseEffect prepareToDraw];
        glDrawArrays(mode, 0, pointCount);
    }
}

//------------------------------------------------------------------------------
#pragma mark - Subclass
//------------------------------------------------------------------------------

- (int)defaultRollingHistoryLength
{
    return EZAudioPlotDefaultHistoryBufferLengthMT;
}

//------------------------------------------------------------------------------

- (int)maximumRollingHistoryLength
{
    return EZAudioPlotDefaultMaxHistoryBufferLengthMT;
}

//------------------------------------------------------------------------------
#pragma mark - EZAudioDisplayLinkDelegate
//------------------------------------------------------------------------------

- (void)displayLinkNeedsDisplay:(EZAudioDisplayLink *)displayLink
{
#if TARGET_OS_IPHONE
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        [self draw];
    }
#elif TARGET_OS_MAC
    [self redraw];
#endif
}

//------------------------------------------------------------------------------
#pragma mark - Delegate
//------------------------------------------------------------------------------

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
    
}

- (void)drawInMTKView:(nonnull MTKView *)view
{
    [self redrawWithPoints:self.info->points
                pointCount:self.info->pointCount
                baseEffect:self.baseEffect
        vertexBufferObject:self.info->vbo
         vertexArrayBuffer:self.info->vab
              interpolated:self.info->interpolated
                  mirrored:self.shouldMirror
                      gain:self.gain];
}

//------------------------------------------------------------------------------


@end
