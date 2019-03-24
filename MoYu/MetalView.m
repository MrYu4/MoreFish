//
// Created by yu on 2019-03-11.
// Copyright (c) 2019 JingJing.com. All rights reserved.
//

#import "MetalView.h"
#import <Metal/Metal.h>
#import "ShaderType.h"

@interface MetalView()

@property (nonatomic, strong) id<MTLDevice> deviece;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) CAMetalLayer *myLayer;
@property (nonatomic, strong) id<MTLRenderPipelineState> renderPipelineState;
@end
@implementation MetalView {

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if ([super initWithCoder:aDecoder]) {
        [self commentInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if ([super initWithFrame:frame]) {
        [self commentInit];

    }
    return self;
}

- (void)commentInit {

    self.deviece = MTLCreateSystemDefaultDevice();
    self.commandQueue = [self.deviece newCommandQueue];
    self.myLayer.device = self.deviece;
    self.myLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    [self setupPipelineState];
}

- (void)didMoveToWindow {

    [super didMoveToWindow];

    [self render];
}

- (void)setupPipelineState {

    id<MTLLibrary> library = [self.deviece newDefaultLibrary];
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertexShader"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"framgmentShader"];

    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = self.myLayer.pixelFormat;
    self.renderPipelineState = [self.deviece newRenderPipelineStateWithDescriptor:pipelineDescriptor error:nil];
}

- (void)render {

    id<CAMetalDrawable> drawable = self.myLayer.nextDrawable;
    if (!drawable) {
        return;
    }
    MTLRenderPassDescriptor *passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
    passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1);
    passDescriptor.colorAttachments[0].texture = drawable.texture;
    passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    id<MTLCommandBuffer> buffer = self.commandQueue.commandBuffer;
    id<MTLRenderCommandEncoder> renderCommandEncoder = [buffer renderCommandEncoderWithDescriptor:passDescriptor];
    [renderCommandEncoder setRenderPipelineState:self.renderPipelineState];

    static const ColorVertex vertexs[] = {
            {{-.5, -0.5}, {1, 0, 0, 1}}, {{-0.5, 0.5}, {0, 1, 0, 1}}, {{0.5, 0.5}, {0, 0, 1, 1}},
    };
//    YLZVertexInputIndexVertices
    [renderCommandEncoder setVertexBytes:&vertexs length:sizeof(vertexs) atIndex:0];
    [renderCommandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];

    [renderCommandEncoder endEncoding];
    [buffer presentDrawable:drawable];
    [buffer commit];
}

+ (Class)layerClass {

    return [CAMetalLayer class];
}

- (CAMetalLayer *)myLayer {

    if (!_myLayer) {
        _myLayer = [CAMetalLayer new];

    }
    return _myLayer;
}

- (CALayer *)layer {

    return self.myLayer;
}

@end
