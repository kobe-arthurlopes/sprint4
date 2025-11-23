import Foundation
import Flutter

enum MethodChannelType {
    case imageLabeling
    case platformIdentifier
    
    var propertyName: String {
        switch self {
            case .imageLabeling:
                "image_labeling"
            case .platformIdentifier:
                "platform_identifier"
        }
    }
    
    var methodName: String {
        switch self {
            case .imageLabeling:
                "labelImage"
            case .platformIdentifier:
                "identifyPlatform"
        }
    }
    
    private func channel(binaryMessenger: FlutterBinaryMessenger) -> FlutterMethodChannel {
        let channelName = "com.sprint4" + "/" + propertyName
        return FlutterMethodChannel(name: channelName, binaryMessenger: binaryMessenger)
    }
    
    func setMethodCallHandler(binaryMessenger: FlutterBinaryMessenger) {
        let channel = channel(binaryMessenger: binaryMessenger)
        
        channel.setMethodCallHandler {
            call,
            result in
            
            handleCall(call: call, result: result)
        }
    }
    
    private func handleCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard call.method == methodName else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        switch self {
            case .imageLabeling:
                guard let args = call.arguments as? [String: Any],
                      let bytes = args["bytes"] as? FlutterStandardTypedData else {
                    
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Missing image bytes",
                        details: nil
                    ))
                    
                    return
                }
            
                ImageLabelingService.labelImage(withBytes: bytes, result: result)
            default:
                return
        }
    }
}
