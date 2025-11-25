import Foundation
import Flutter
import MLKitVision
import MLKitImageLabeling

final class ImageLabelingService {
    private init() {}
    
    static func labelImage(withBytes bytes: FlutterStandardTypedData? = nil, result: @escaping FlutterResult) {
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

