import MetalPerformanceShaders

public typealias Kernel = (height: Int, width: Int)
public typealias Strides = (height: Int, width: Int)
public typealias Dilations = (height: Int, width: Int)
public typealias Pads = (top: Int, left: Int, bottom: Int, right: Int)
public typealias Padding = (height: Int, width: Int)
public typealias Scales = (height: Int, width: Int)

@objc(ONNXConvolutionPadding) public class ONNXConvolutionPadding: NSObject, NSSecureCoding, MPSNNPadding {
    public let kernel: Kernel
    public let dilations: Dilations
    public let strides: Strides
    public let pads: Pads
    public let outputPadding: Padding
    public let isTranspose: Bool

    public init(kernel: Kernel,
                strides: Strides,
                dilations: Dilations,
                pads: Pads,
                outputPadding: Padding,
                isTranspose: Bool) {
        self.kernel = kernel
        self.dilations = dilations
        self.strides = strides
        self.pads = pads
        self.outputPadding = outputPadding
        self.isTranspose = isTranspose
    }

    private enum CodingKeys {
        static let kernelHeight = "kernelHeight"
        static let kernelWidth = "kernelWidth"
        static let strideHeight = "strideHeight"
        static let strideWidth = "strideWidth"
        static let dilationHeight = "dilationHeight"
        static let dilationWidth = "dilationWidth"
        static let padTop = "padTop"
        static let padLeft = "padLeft"
        static let padBottom = "padBottom"
        static let padRight = "padRight"
        static let outputPaddingHeight = "outputPaddingHeight"
        static let outputPaddingWidth = "outputPaddingWidth"
        static let isTranspose = "isTranspose"
    }

    required convenience public init?(coder aDecoder: NSCoder) {
        let kernel: Kernel = (
            height: aDecoder.decodeInteger(forKey: CodingKeys.kernelHeight),
            width: aDecoder.decodeInteger(forKey: CodingKeys.kernelWidth)
        )
        let strides: Strides = (
            height: aDecoder.decodeInteger(forKey: CodingKeys.strideHeight),
            width: aDecoder.decodeInteger(forKey: CodingKeys.strideWidth)
        )
        let dilations: Dilations = (
            height: aDecoder.decodeInteger(forKey: CodingKeys.dilationHeight),
            width: aDecoder.decodeInteger(forKey: CodingKeys.dilationWidth)
        )
        let pads: Pads = (
            top: aDecoder.decodeInteger(forKey: CodingKeys.padTop),
            left: aDecoder.decodeInteger(forKey: CodingKeys.padLeft),
            bottom: aDecoder.decodeInteger(forKey: CodingKeys.padBottom),
            right: aDecoder.decodeInteger(forKey: CodingKeys.padRight)
        )
        let outputPadding: Padding = (
            height: aDecoder.decodeInteger(forKey: CodingKeys.outputPaddingHeight),
            width: aDecoder.decodeInteger(forKey: CodingKeys.outputPaddingWidth)
        )
        let isTranspose = aDecoder.decodeBool(forKey: CodingKeys.isTranspose)

        self.init(kernel: kernel,
                  strides: strides,
                  dilations: dilations,
                  pads: pads,
                  outputPadding: outputPadding,
                  isTranspose: isTranspose)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.kernel.height, forKey: CodingKeys.kernelHeight)
        aCoder.encode(self.kernel.width, forKey: CodingKeys.kernelWidth)
        aCoder.encode(self.strides.height, forKey: CodingKeys.strideHeight)
        aCoder.encode(self.strides.width, forKey: CodingKeys.strideWidth)
        aCoder.encode(self.dilations.height, forKey: CodingKeys.dilationHeight)
        aCoder.encode(self.dilations.width, forKey: CodingKeys.dilationWidth)
        aCoder.encode(self.pads.top, forKey: CodingKeys.padTop)
        aCoder.encode(self.pads.left, forKey: CodingKeys.padLeft)
        aCoder.encode(self.pads.bottom, forKey: CodingKeys.padBottom)
        aCoder.encode(self.pads.right, forKey: CodingKeys.padRight)
        aCoder.encode(self.outputPadding.height, forKey: CodingKeys.outputPaddingHeight)
        aCoder.encode(self.outputPadding.width, forKey: CodingKeys.outputPaddingWidth)
        aCoder.encode(self.isTranspose, forKey: CodingKeys.isTranspose)
    }

    public func paddingMethod() -> MPSNNPaddingMethod {
        return [.custom]
    }

    public func destinationImageDescriptor(forSourceImages sourceImages: [MPSImage],
                                           sourceStates: [MPSState]?,
                                           for kernel: MPSKernel,
                                           suggestedDescriptor inDescriptor: MPSImageDescriptor) -> MPSImageDescriptor {
        let inputHeight = sourceImages[0].height
        let inputWidth = sourceImages[0].width

        if self.isTranspose {
            let conv = kernel as! MPSCNNConvolutionTranspose
            conv.offset = MPSOffset(x: 0, y: 0, z: 0)
            conv.edgeMode = .zero
            conv.kernelOffsetX = self.kernel.width / 2 - self.kernel.width + 1 + self.pads.left
            conv.kernelOffsetY = self.kernel.height / 2 - self.kernel.height + 1 + self.pads.top
        } else {
            let conv = kernel as! MPSCNNConvolution
            conv.offset = MPSOffset(x: self.kernel.width / 2 - self.pads.left,
                                    y: self.kernel.height / 2 - self.pads.top,
                                    z: 0)
            conv.edgeMode = .zero
        }
        let paddedSize = self.paddedSize(inputWidth: inputWidth,
                                         inputHeight: inputHeight)
        inDescriptor.height = paddedSize.height
        inDescriptor.width = paddedSize.width

        return inDescriptor
    }

    public func paddedSize(inputWidth: Int,
                           inputHeight: Int) -> (width: Int, height: Int) {
        let height: Int
        let width: Int
        if self.isTranspose {
            height = (inputHeight - 1) * self.strides.height
                - self.pads.top - self.pads.bottom
                + self.kernel.height + self.outputPadding.height
            width = (inputWidth - 1) * self.strides.width
                - self.pads.left - self.pads.right
                + self.kernel.width + self.outputPadding.width
        } else {
            height = (inputHeight + self.pads.top
                + self.pads.bottom - self.kernel.height)
                / self.strides.height + 1
            width = (inputWidth + self.pads.left
                + self.pads.right - self.kernel.width)
                / self.strides.width + 1
        }
        return (width, height)
    }

    public static var supportsSecureCoding: Bool { true }
}
