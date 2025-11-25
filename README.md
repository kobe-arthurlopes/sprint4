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

- Captura de imagens -> Para permitir que o usuário selecione imagens da galeria ou da câmera, foi utilizada a dependência do Flutter ``image_picker``. Esta dependência não exige integração nativa manual, mas funciona em conjunto com o ``MethodChannel`` que envia os bytes da     imagem para o código nativo realizar o processamento via ML Kit.

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

---------

**Serviços em Nuvem**

- Para armazenamento das imagens classificadas pelo Google ML Kit, o app utiliza o ``Supabase`` como 0 serviço em nuvem que armazena seu banco de dados.
- Todas as tabelas, ativação de Row-Level Security, policies e configuração de storage foi usado a seção ``SQL Editor`` do Supabase. As tabelas criadas foram:

  ```sql
  -- Criação da tabela para o objeto Label
  -- Label representa as 446 categorias disponibilizadas pelo ML Kit para o Image Labeling
  create table public.labels(
    id integer primary key,
    text text unique not null
  );

  -- Aciona RLS (Row-Level Security) para a tabela 'labels'
  alter table public.labels enable row level security;

  -- Depois de ativar o RLS, cria-se policies que indicam regras para o acesso da tabela 'labels'
  -- Essa policy permite que qualquer pessoa possa ler os dados dessa tabela
  create policy "Anyone can read labels"
	on public.labels
	for select
	using (true);
  ```

  ```sql
  -- Criação da tabela para o objeto ImageLabelResult
  -- ImageLabelResult representa o resultado de uma imagem classificada pelo ML Kit
  -- o método gen_random_uuid() sempre gera um UUID aleatório para a propriedade id
  -- a propriedade user_id aponta para auth.users(id), que guarda o id dos usuários logados
  -- 'on delete cascade' significa que se um user for removido, seus ImageLabelResults também serão
  -- file_path é o caminho para a imagem classificada
  
  create table public.image_label_results(
  	id uuid primary key default gen_random_uuid(),
  	user_id uuid not null references auth.users(id) on delete cascade, 
  	file_path text not null
  );

  -- Aciona RLS para a tabela 'image_label_results'
  alter table public.image_label_results enable row level security;

  -- Criação das policies da tabela:

  -- Usuários poderão ler todas as ImageLabelResults que tiverem user_id
  -- igual ao seu id de usário
  create policy “Users can read their own results”
	on public.image_label_results
	for select
	using (auth.uid() = user_id);

  -- Usuários poderão criar ImageLabelResults que tenham user_id
  -- igual ao seu id de usuário
  create policy “Users can create their own results”
  on public.image_label_results
  for insert
  with check (auth.uid() = user_id);

  -- Usuários poderão atualizar ImageLabelResults que tiverem
  -- user_id igual ao seu id de usuário
  create policy “Users can update their own results”
  on public.image_label_results
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
  
  create policy “Users can delete their own results”
  on public.image_label_results
  for delete
  using (auth.uid() = user_id);
  ```

