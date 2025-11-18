import Foundation
import Flutter
import MLKitVision
import MLKitImageLabeling

class MethodChannelService {
    private let channelName = "com.sprint4/image_labeling"
    private let channel: FlutterMethodChannel
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: channelName, binaryMessenger: binaryMessenger)
    }
    
    func setMethodCallHandler() {
        channel.setMethodCallHandler {
            [weak self] call,
            result in
            guard let self else { return }
            
            if call.method == "labelImage" {
                guard let args = call.arguments as? [String: Any],
                      let bytes = args["bytes"] as? FlutterStandardTypedData else {
                    
                  result(FlutterError(
                    code: "INVALID_ARGUMENTS",
                    message: "Missing image bytes",
                    details: nil
                  ))
                    
                  return
                }
                
                self.labelImage(withBytes: bytes, result: result)
                
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func labelImage(withBytes bytes: FlutterStandardTypedData? = nil, result: @escaping FlutterResult) {
        guard let bytes, let uiImage = UIImage(data: bytes.data) else {
            result(FlutterError(
                code: "INVALID_IMAGE",
                message: "Could not create UIImage from bytes",
                details: nil
            ))
            
           return
        }
        
        let visionImage = VisionImage(image: uiImage)
        visionImage.orientation = uiImage.imageOrientation
        
        let options = ImageLabelerOptions()
        options.confidenceThreshold = 0.5
        
        let labeler = ImageLabeler.imageLabeler(options: options)
        
        labeler.process(visionImage) { labels, error in
            if let error {
                result(
                    FlutterError(
                        code: "MLKIT_ERROR",
                        message: error.localizedDescription,
                        details: nil
                    )
                )
                
                return
            }
            
            guard let labels else {
                result([])
                return
            }
            
            let labelData = labels.map { label in
                return [
                    "text": label.text,
                    "confidence": label.confidence,
                    "index": label.index
                ] as [String : Any]
            }
            
            result(labelData)
        }
    }
}
