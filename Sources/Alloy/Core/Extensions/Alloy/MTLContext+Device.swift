import Foundation
import Metal

public extension MTLContext {

    // MARK: - Alloy API

    func maxTextureSize(desiredSize: MTLSize) -> MTLSize {
        return self.device
                   .maxTextureSize(desiredSize: desiredSize)
    }

    func library(from file: URL,
                 options: MTLCompileOptions? = nil) throws -> MTLLibrary {
        return try self.device
                       .library(from: file,
                                options: options)
    }

    func multisampleRenderTargetPair(width: Int, height: Int,
                                     pixelFormat: MTLPixelFormat,
                                     sampleCount: Int = 4) throws -> (main: MTLTexture,
                                                                      resolve: MTLTexture) {
        return try self.device
                       .multisampleRenderTargetPair(width: width,
                                                    height: height,
                                                    pixelFormat: pixelFormat,
                                                    sampleCount: sampleCount)
    }

    func texture(width: Int,
                 height: Int,
                 pixelFormat: MTLPixelFormat,
                 usage: MTLTextureUsage = [.shaderRead]) throws -> MTLTexture {
        return try self.device
                       .texture(width: width,
                                height: height,
                                pixelFormat: pixelFormat,
                                usage: usage)
    }

    func depthState(depthCompareFunction: MTLCompareFunction,
                    isDepthWriteEnabled: Bool = true) throws -> MTLDepthStencilState {
        return try self.device
                       .depthState(depthCompareFunction: depthCompareFunction,
                                   isDepthWriteEnabled: isDepthWriteEnabled)
    }

    func depthBuffer(width: Int,
                     height: Int,
                     usage: MTLTextureUsage = [],
                     storageMode: MTLStorageMode? = nil) throws -> MTLTexture {
        return try self.device
                       .depthBuffer(width: width,
                                    height: height,
                                    usage: usage,
                                    storageMode: storageMode)
    }

    func buffer<T>(for type: T.Type,
                   count: Int = 1,
                   options: MTLResourceOptions) throws -> MTLBuffer {
        return try self.device
                       .buffer(for: type,
                               count: count,
                               options: options)
    }

    func buffer<T>(with value: T,
                   options: MTLResourceOptions) throws -> MTLBuffer {
        return try self.device
                       .buffer(with: value,
                               options: options)
    }

    func buffer<T>(with values: [T],
                   options: MTLResourceOptions) throws -> MTLBuffer {
        return try self.device
                       .buffer(with: values,
                               options: options)
    }

    func heap(size: Int,
              storageMode: MTLStorageMode,
              cpuCacheMode: MTLCPUCacheMode = .defaultCache) throws -> MTLHeap {
        return try self.device
                       .heap(size: size,
                             storageMode: storageMode,
                             cpuCacheMode: cpuCacheMode)
    }

    // MARK: - Vanilla API

    var maxThreadgroupMemoryLength: Int {
        self.device
            .maxThreadgroupMemoryLength
    }

    @available(iOS 12.0, macOS 10.14, *)
    var maxArgumentBufferSamplerCount: Int {
        self.device
            .maxArgumentBufferSamplerCount
    }

    var areProgrammableSamplePositionsSupported: Bool {
        self.device
            .areProgrammableSamplePositionsSupported
    }

    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 13.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    var sparseTileSizeInBytes: Int {
        self.device
            .sparseTileSizeInBytes
    }
    #endif

    @available(iOS 12.0, macOS 10.14, *)
    var maxBufferLength: Int {
        self.device
            .maxBufferLength
    }

    var deviceName: String {
        return self.device
                   .name
    }

    var registryID: UInt64 {
        return self.device
                   .registryID
    }

    var maxThreadsPerThreadgroup: MTLSize {
        return self.device
                   .maxThreadsPerThreadgroup
    }

    @available(iOS 13.0, macOS 10.15, *)
    var hasUnifiedMemory: Bool {
        return self.device
                   .hasUnifiedMemory
    }

    var readWriteTextureSupport: MTLReadWriteTextureTier {
        return self.device
                   .readWriteTextureSupport
    }

    var argumentBuffersSupport: MTLArgumentBuffersTier {
        return self.device
                   .argumentBuffersSupport
    }

    var areRasterOrderGroupsSupported: Bool {
        return self.device
                   .areRasterOrderGroupsSupported
    }

    var currentAllocatedSize: Int {
        return self.device
                   .currentAllocatedSize
    }

    func heapTextureSizeAndAlign(descriptor desc: MTLTextureDescriptor) -> MTLSizeAndAlign {
        return self.device
                   .heapTextureSizeAndAlign(descriptor: desc)
    }

    func heapBufferSizeAndAlign(length: Int,
                                options: MTLResourceOptions = []) -> MTLSizeAndAlign {
        return self.device
                   .heapBufferSizeAndAlign(length: length,
                                           options: options)
    }

    func heap(descriptor: MTLHeapDescriptor) -> MTLHeap? {
        return self.device
                   .makeHeap(descriptor: descriptor)
    }

    func buffer(length: Int,
                options: MTLResourceOptions = []) -> MTLBuffer? {
        return self.device
                   .makeBuffer(length: length,
                               options: options)
    }

    func buffer(bytes pointer: UnsafeRawPointer,
                length: Int,
                options: MTLResourceOptions = []) -> MTLBuffer? {
        return self.device
                   .makeBuffer(bytes: pointer,
                               length: length,
                               options: options)
    }

    func buffer(bytesNoCopy pointer: UnsafeMutableRawPointer,
                length: Int,
                options: MTLResourceOptions = [],
                deallocator: (@Sendable (UnsafeMutableRawPointer, Int) -> Void)? = nil) -> MTLBuffer? {
        return self.device
                   .makeBuffer(bytesNoCopy: pointer,
                               length: length,
                               options: options,
                               deallocator: deallocator)
    }

    func depthStencilState(descriptor: MTLDepthStencilDescriptor) -> MTLDepthStencilState? {
        return self.device
                   .makeDepthStencilState(descriptor: descriptor)
    }

    func texture(descriptor: MTLTextureDescriptor) throws -> MTLTexture {
        guard let texture = self.device
                                .makeTexture(descriptor: descriptor)
        else { throw MetalError.MTLDeviceError.textureCreationFailed }
        return texture
    }

    func texture(descriptor: MTLTextureDescriptor,
                 iosurface: IOSurfaceRef,
                 plane: Int) throws -> MTLTexture {
        guard let texture = self.device
                                .makeTexture(descriptor: descriptor,
                                             iosurface: iosurface,
                                             plane: plane)
        else { throw MetalError.MTLDeviceError.textureCreationFailed }
        return texture
    }

    #if !targetEnvironment(simulator)
    // Probably it's a bug, but simulator's version of `MTLDevice`
    // doesn't know about `makeSharedTexture`.
    @available(iOS 13.0, macOS 10.14, *)
    func sharedTexture(descriptor: MTLTextureDescriptor) throws -> MTLTexture {
        guard let texture = self.device
                                .makeSharedTexture(descriptor: descriptor)
        else { throw MetalError.MTLDeviceError.textureCreationFailed }
        return texture
    }

    @available(iOS 13.0, macOS 10.14, *)
    func sharedTexture(handle sharedHandle: MTLSharedTextureHandle) throws -> MTLTexture {
        guard let texture = self.device
                                .makeSharedTexture(handle: sharedHandle)
        else { throw MetalError.MTLDeviceError.textureCreationFailed }
        return texture
    }
    #endif

    func samplerState(descriptor: MTLSamplerDescriptor) throws -> MTLSamplerState {
        guard let samplerState = self.device
                                     .makeSamplerState(descriptor: descriptor)
        else { throw MetalError.MTLDeviceError.samplerStateCreationFailed }
        return samplerState
    }

    func library(filepath: String) throws -> MTLLibrary {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, *) {
            return try self.device
                           .makeLibrary(URL: URL(fileURLWithPath: filepath))
        } else {
            return try self.device
                           .makeLibrary(filepath: filepath)
        }
    }

    func library(URL url: URL) throws -> MTLLibrary {
        return try self.device
                       .makeLibrary(URL: url)
    }

    func library(data: __DispatchData) throws -> MTLLibrary {
        return try self.device
                       .makeLibrary(data: data)
    }

    func library(source: String,
                 options: MTLCompileOptions?) throws -> MTLLibrary {
        return try self.device
                       .makeLibrary(source: source,
                                    options: options)
    }

    func library(source: String,
                 options: MTLCompileOptions?,
                 completionHandler: @escaping @Sendable (MTLLibrary?, Error?) -> Void) {
        return self.device
                   .makeLibrary(source: source,
                                options: options,
                                completionHandler: completionHandler)
    }

    func renderPipelineState(descriptor: MTLRenderPipelineDescriptor) throws -> MTLRenderPipelineState {
        return try self.device
                       .makeRenderPipelineState(descriptor: descriptor)
    }

    func renderPipelineState(descriptor: MTLRenderPipelineDescriptor,
                             options: MTLPipelineOption,
                             reflection: AutoreleasingUnsafeMutablePointer<MTLAutoreleasedRenderPipelineReflection?>?) throws -> MTLRenderPipelineState {
        return try self.device
                       .makeRenderPipelineState(descriptor: descriptor,
                                                options: options,
                                                reflection: reflection)
    }

    func renderPipelineState(descriptor: MTLRenderPipelineDescriptor,
                             completionHandler: @escaping @Sendable (MTLRenderPipelineState?, Error?) -> Void) {
        return self.device
                   .makeRenderPipelineState(descriptor: descriptor,
                                            completionHandler: completionHandler)
    }

    func renderPipelineState(descriptor: MTLRenderPipelineDescriptor,
                             options: MTLPipelineOption,
                             completionHandler: @escaping @Sendable (MTLRenderPipelineState?, MTLRenderPipelineReflection?, Error?) -> Void) {
        return self.device
                   .makeRenderPipelineState(descriptor: descriptor,
                                            options: options,
                                            completionHandler: completionHandler)
    }

    func computePipelineState(function computeFunction: MTLFunction) throws -> MTLComputePipelineState {
        return try self.device
                       .makeComputePipelineState(function: computeFunction)
    }

    func computePipelineState(function computeFunction: MTLFunction,
                              options: MTLPipelineOption,
                              reflection: AutoreleasingUnsafeMutablePointer<MTLAutoreleasedComputePipelineReflection?>?) throws -> MTLComputePipelineState {
        return try self.device
                       .makeComputePipelineState(function: computeFunction,
                                                 options: options,
                                                 reflection: reflection)
    }

    func computePipelineState(function computeFunction: MTLFunction,
                              completionHandler: @escaping @Sendable (MTLComputePipelineState?, Error?) -> Void) {
        return self.device
                   .makeComputePipelineState(function: computeFunction,
                                             completionHandler: completionHandler)
    }

    func computePipelineState(function computeFunction: MTLFunction,
                              options: MTLPipelineOption,
                              completionHandler: @escaping @Sendable (MTLComputePipelineState?, MTLComputePipelineReflection?, Error?) -> Void) {
        return self.device
                   .makeComputePipelineState(function: computeFunction,
                                             options: options,
                                             completionHandler: completionHandler)
    }

    func computePipelineState(descriptor: MTLComputePipelineDescriptor,
                              options: MTLPipelineOption,
                              reflection: AutoreleasingUnsafeMutablePointer<MTLAutoreleasedComputePipelineReflection?>?) throws -> MTLComputePipelineState {
        return try self.device
                       .makeComputePipelineState(descriptor: descriptor,
                                                 options: options,
                                                 reflection: reflection)
    }

    func computePipelineState(descriptor: MTLComputePipelineDescriptor,
                              options: MTLPipelineOption,
                              completionHandler: @escaping @Sendable (MTLComputePipelineState?, MTLComputePipelineReflection?, Error?) -> Void) {
        self.device
            .makeComputePipelineState(descriptor: descriptor,
                                      options: options,
                                      completionHandler: completionHandler)
    }

    func fence() throws -> MTLFence {
        guard let fence = self.device
                              .makeFence()
        else { throw MetalError.MTLDeviceError.fenceCreationFailed }
        return fence
    }

    @available(macOS, deprecated: 13.0, message: "Use supportsFamily instead")
    @available(iOS, deprecated: 16.0, message: "Use supportsFamily instead")
    @available(tvOS, deprecated: 16.0, message: "Use supportsFamily instead")
    func supportsFeatureSet(_ featureSet: MTLFeatureSet) -> Bool {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, *) {
            return self.invokeSupportsFeatureSetDynamically(featureSet)
        } else {
            return self.device.supportsFeatureSet(featureSet)
        }
    }

    @available(iOS 13.0, macOS 10.15, *)
    func supportsFamily(_ gpuFamily: MTLGPUFamily) -> Bool {
        return self.device
                   .supportsFamily(gpuFamily)
    }

    func supportsTextureSampleCount(_ sampleCount: Int) -> Bool {
        return self.device
                   .supportsTextureSampleCount(sampleCount)
    }

    func minimumLinearTextureAlignment(for format: MTLPixelFormat) -> Int {
        return self.device
                   .minimumLinearTextureAlignment(for: format)
    }

    @available(iOS 12.0, macOS 10.14, *)
    func minimumTextureBufferAlignment(for format: MTLPixelFormat) -> Int {
        return self.device
                   .minimumTextureBufferAlignment(for: format)
    }

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, *)
    @available(macOS, deprecated: 13.0, message: "Use supportsFamily instead")
    @available(iOS, deprecated: 16.0, message: "Use supportsFamily instead")
    @available(tvOS, deprecated: 16.0, message: "Use supportsFamily instead")
    private func invokeSupportsFeatureSetDynamically(_ featureSet: MTLFeatureSet) -> Bool {
        let selector = NSSelectorFromString("supportsFeatureSet:")
        guard let nsDevice = self.device as? NSObject,
              nsDevice.responds(to: selector),
              let implementation = nsDevice.method(for: selector) else {
            return false
        }
        typealias SupportsFeatureSetIMP = @convention(c) (AnyObject, Selector, MTLFeatureSet) -> Bool
        let function = unsafeBitCast(implementation, to: SupportsFeatureSetIMP.self)
        return function(nsDevice as AnyObject, selector, featureSet)
    }

    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    func renderPipelineState(tileDescriptor descriptor: MTLTileRenderPipelineDescriptor,
                             options: MTLPipelineOption,
                             reflection: AutoreleasingUnsafeMutablePointer<MTLAutoreleasedRenderPipelineReflection?>?) throws -> MTLRenderPipelineState {
        return try self.device
                       .makeRenderPipelineState(tileDescriptor: descriptor,
                                                options: options,
                                                reflection: reflection)
    }

    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    func renderPipelineState(tileDescriptor descriptor: MTLTileRenderPipelineDescriptor,
                             options: MTLPipelineOption,
                             completionHandler: @escaping @Sendable (MTLRenderPipelineState?, MTLRenderPipelineReflection?, Error?) -> Void) {
        self.device
            .makeRenderPipelineState(tileDescriptor: descriptor,
                                     options: options,
                                     completionHandler: completionHandler)
    }
    #endif

    func defaultSamplePositions(_ positions: UnsafeMutablePointer<MTLSamplePosition>,
                                count: Int) {
        self.device
            .__getDefaultSamplePositions(positions,
                                         count: count)
    }

    func argumentEncoder(arguments: [MTLArgumentDescriptor]) throws -> MTLArgumentEncoder {
        guard let encoder = self.device
                                .makeArgumentEncoder(arguments: arguments)
        else { throw MetalError.MTLDeviceError.argumentEncoderCreationFailed }
        return encoder
    }

    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 13.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    func supportsRasterizationRateMap(layerCount: Int) -> Bool {
        return self.device
                   .supportsRasterizationRateMap(layerCount: layerCount)
    }

    @available(iOS 13.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    func rasterizationRateMap(descriptor: MTLRasterizationRateMapDescriptor) throws -> MTLRasterizationRateMap {
        guard let map = self.device
                            .makeRasterizationRateMap(descriptor: descriptor)
        else { throw MetalError.MTLDeviceError.rasterizationRateMapCreationFailed }
        return map
    }
    #endif

    @available(iOS 12.0, macOS 10.14, *)
    func indirectCommandBuffer(descriptor: MTLIndirectCommandBufferDescriptor,
                               maxCommandCount maxCount: Int,
                               options: MTLResourceOptions = []) throws -> MTLIndirectCommandBuffer {
        guard let indirectCommandBuffer = self.device
                                              .makeIndirectCommandBuffer(descriptor: descriptor,
                                                                         maxCommandCount: maxCount,
                                                                         options: options)
        else { throw MetalError.MTLDeviceError.indirectCommandBufferCreationFailed }
        return indirectCommandBuffer
    }

    @available(iOS 12.0, macOS 10.14, *)
    func event() throws -> MTLEvent {
        guard let event = self.device
                              .makeEvent()
        else { throw MetalError.MTLDeviceError.eventCreationFailed }
        return event
    }

    @available(iOS 12.0, macOS 10.14, *)
    func sharedEvent() throws -> MTLSharedEvent {
        guard let event = self.device
                              .makeSharedEvent()
        else { throw MetalError.MTLDeviceError.eventCreationFailed }
        return event
    }

    @available(iOS 12.0, macOS 10.14, *)
    func sharedEvent(handle sharedEventHandle: MTLSharedEventHandle) throws -> MTLSharedEvent {
        guard let event = self.device
                              .makeSharedEvent(handle: sharedEventHandle)
        else { throw MetalError.MTLDeviceError.eventCreationFailed }
        return event
    }

    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 13.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    func sparseTileSize(with textureType: MTLTextureType,
                        pixelFormat: MTLPixelFormat,
                        sampleCount: Int) -> MTLSize {
        return self.device
                   .sparseTileSize(with: textureType,
                                   pixelFormat: pixelFormat,
                                   sampleCount: sampleCount)
    }

    @available(iOS 13.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    func supportsVertexAmplificationCount(_ count: Int) -> Bool {
        return self.device
                   .supportsVertexAmplificationCount(count)
    }
    #endif

    func defaultSamplePositions(sampleCount: Int) -> [MTLSamplePosition] {
        return self.device
                   .getDefaultSamplePositions(sampleCount: sampleCount)
    }

}
