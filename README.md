***Sprint 4 App***

---------

**Integração nativa**

- Este aplicativo possui uma camada de integração nativa desenvolvida em ``Kotlin (Android)`` e ``Swift (iOS)`` para acessar recursos que não são totalmente expostos pelo Flutter. 
A comunicação entre Flutter e o código nativo é realizada por meio de ``Method Channels``.

- ``Google ML Kit`` -> Foi utilizado o recurso de <a href="https://developers.google.com/ml-kit/vision/image-labeling" target="_blank">Image Labeling</a>
do <a href="https://developers.google.com/ml-kit" target="_blank">Google ML Kit</a>, implementado nas duas plataformas sem uso de plugins prontos do Flutter.

- ``iOS (Swift)`` -> Uso direto do ML Kit via CocoaPods. Dependência adicionada ao ``Podfile``:

  ```ruby
  pod 'GoogleMLKit/ImageLabeling', '8.0.0'
  ```
  Trecho responsável pelo processamento da imagem:

  <details>
    <summary>Ver código</summary>

      ```swift
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
      ```
    
  </details>
  

- ``Android (Kotlin)`` -> Uso direto do ML Kit via Gradle. A seguinte dependência é adicionada ao arquivo ``build.gradle.kts``:

  ```kotlin
  dependencies {
    implementation("com.google.mlkit:image-labeling:17.0.9")
  }
  ```

  Trecho responsável pelo processamento da imagem:

  <details>
    <summary>Ver código</summary>

      ```kotlin
      private fun labelImage(bytes: ByteArray, result: MethodChannel.Result) {
        try {
          val inputStream = ByteArrayInputStream(bytes)
          val bitmap = BitmapFactory.decodeStream(inputStream)

          if (bitmap == null) {
            result.error("INVALID_IMAGE", "Could not decode image", null)
            return
          }

          val image = InputImage.fromBitmap(bitmap, 0)
          val labeler = ImageLabeling.getClient(
            ImageLabelerOptions.Builder()
              .setConfidenceThreshold(0.5f)
              .build()
          )

          labeler.process(image)
            .addOnSuccessListener { labels ->
              val labelData = labels.map { label ->
                mapOf(
                  "text" to label.text,
                  "confidence" to label.confidence,
                  "index" to label.index
                )
              }

              result.success(labelData)
            }
            .addOnFailureListener { error ->
              result.error("ML_KIT_ERROR", error.localizedMessage, null)
            }
        } catch (exception: Exception) {
          result.error("EXCEPTION", exception.localizedMessage, null)
        }
      }
      ```
  </details>
  

- Envio de imagens -> As imagens são enviadas do Flutter para as plataformas nativas via ``MethodChannel``:

  ```dart
  // Fluter (Dart)
  
  const channel = MethodChannel('com.sprint4/image_labeling');
  await channel.invokeMethod('labelImage', {'bytes': list});
  ```

- Retorno dos resultados para Flutter:

  ```swift
  // iOS (Swift)
  
  let channel = FlutterMethodChannel(name: channelName, binaryMessenger: binaryMessenger)
  channel.setMethodCallHandler { call, result in
    // Processamento...
  }
  ```

  ```kotlin
  // Android (Kotlin)
  
  val channel: MethodChannel = MethodChannel(binaryMessenger, channelName)
  channel.setMethodCallHandler { call, result ->
    // Processamento...
  }
  ```

