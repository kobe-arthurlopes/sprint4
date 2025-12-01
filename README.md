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

	<br>

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

    <br>
    
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

	<br>

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

    <br>
	
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

- Para armazenamento das imagens classificadas pelo Google ML Kit, o app utiliza o ``Supabase`` como o ``serviço em nuvem`` que armazena seu banco de dados
- Em toda criação de tabelas e policies, ativação de RLS e configuração de storage foi usada a seção ``SQL Editor`` do Supabase. Foram 3 objetos criados: ``Label``, ``ImageLabelResult`` e ``Prediction``

- ``Label`` representa uma das 446 categorias disponibilizadas pelo ML Kit para o Image Labeling
  <details>
	<summary>SQL</summary>

	<br>
  	<p>
		- Criação da tabela 'labels':
	</p>

	```sql
	create table public.labels(
	id integer primary key,
	text text unique not null
	);
	```
	<br>
	<p>
		- Ativação do RLS:
	</p>

 	```sql
  	alter table public.labels enable row level security;
  	```

  	<br>
	<p>
		- Policies:
	</p>

  	```sql
    -- Permite que qualquer usuário possa ler os dados dessa tabela
	create policy "Anyone can read labels"
	on public.labels
	for select
	using (true);
   	```
 
  </details>

- ``ImageLabelResult`` representa o resultado de uma imagem classificada pelo ML Kit
  <details>	
	<summary>SQL</summary>

	<br>
	<p>
		- Criação da tabela 'image_label_results':
	</p>
	  
	```sql
	-- Método gen_random_uuid() sempre gera um UUID aleatório para a propriedade id
	-- A propriedade user_id aponta para auth.users(id), que guarda o id dos usuários logados
	-- 'on delete cascade' significa que se um user for removido, os ImageLabelResults relacionados a ele também serão
	-- file_path é o caminho para a imagem classificada
	create table public.image_label_results(
	id uuid primary key default gen_random_uuid(),
	user_id uuid not null references auth.users(id) on delete cascade, 
	file_path text not null
	);
 	```

	<br>
	<p>
		- Ativação do RLS:
	</p>
	
 	```sql
	alter table public.image_label_results enable row level security;
 	```

	<br>
	<p>
		- Policies:
	</p>

	```sql
	-- Usuários poderão ler todas as ImageLabelResults que tiverem user_id
	-- igual ao seu id de usário
	create policy “Users can read their own results”
	on public.image_label_results
	for select
	using ((select auth.uid()) = user_id);
	
	-- Usuários poderão criar uma ImageLabelResult com user_id
	-- obrigatoriamente igual ao seu id de usuário
	create policy “Users can create their own results”
	on public.image_label_results
	for insert
	with check ((select auth.uid()) = user_id);
	
	-- Usuários poderão atualizar uma ImageLabelResult com user_id
	-- obrigatoriamente igual ao seu id de usuário e sem poderem alterar essa propriedade
	create policy “Users can update their own results”
	on public.image_label_results
	for update
	using ((select auth.uid()) = user_id)
	with check ((select auth.uid()) = user_id);

 	-- Usuários poderão deletar uma ImageLabelResult com user_id
	-- obrigatoriamente igual ao seu id de usuário
	create policy “Users can delete their own results”
	on public.image_label_results
	for delete
	using ((select auth.uid()) = user_id);
	```
 
  </details>

- ``Prediction`` representa uma previsão do ML Kit sobre uma imagem, sendo uma junção entre uma Label e uma porcentagem de confiança
  <details>
	<summary>SQL</summary>

	<br>
	<p>
		- Criação da tabela 'predictions':
	</p>

	```sql
 	-- Está necessariamente ligada a uma Label e a um ImageLabelResult
 	create table public.predictions(
	id uuid primary key default gen_random_uuid(),
	result_id uuid not null references public.image_label_results(id) on delete cascade,
	label_id integer not null references public.labels(id) on delete cascade,
	confidence decimal(10,2) not null
	);
 	```

	<br>
	<p>
		- Ativação do RLS':
	</p>
	
  
 	```sql
 	alter table public.predictions enable row level security;
 	```

	<br>
	<p>
		- Policies:
	</p>

	```sql
 	-- Usuários poderão ler todas as Predictions que tiverem user_id
	-- igual ao seu id de usário
 	create policy “Users can read their own predictions”
	on public.predictions
	for select
	using (
 		exists(
  			select 1
  			from public.image_label_results result
  			where result.id = result_id
  			and result.user_id = (select auth.uid())
 		)
	);

 	-- Usuários poderão criar uma Prediction com user_id
	-- obrigatoriamente igual ao seu id de usuário
	create policy “Users can create their own predictions”
		on public.predictions
		for insert
		with check (
	 		exists(
	  			select 1
	  			from public.image_label_results result
	  			where result.id = result_id
	  			and result.user_id = (select auth.uid())
	 		)
		);

 	-- Usuários poderão atualizar uma Prediction com user_id
	-- obrigatoriamente igual ao seu id de usuário e sem poderem alterar essa propriedade
	create policy “Users can update their own predictions”
		on public.predictions
		for update
		using (
	 		exists(
	 			select 1
	  			from public.image_label_results result
	  			where result.id = result_id
	 			and result.user_id = (select auth.uid())
	 		)
		)
		with check (
	 		exists(
	  			select 1
	  			from public.image_label_results result
	  			where result.id = result_id
	  			and result.user_id = (select auth.uid())
	 		)
		);

 	-- Usuários poderão deletar uma Prediction com user_id
	-- obrigatoriamente igual ao seu id de usuário
	create policy “Users can delete their own predictions”
		on public.predictions
		for delete
		using (
	 		exists(
	  			select 1
	  			from public.image_label_results result
	  			where result.id = result_id
	  			and result.user_id = (select auth.uid())
	 		)
		);
 	
 	```

  </details>

- Autenticação: para que o usuário se autentique ao Supabase e tenha acesso ao seu banco de dados foram usados 3 métodos: ``Apple``, ``Google`` e ``Email``

- ``Apple``: dependência ``sign_in_with_apple`` e configuração do Provider da Apple no Authentication do Supabase

- ``Google``: dependência ``google_sign_in`` e configuração do Provider do Google no Authentication do Supabase

- ``Email``: uso do método ``signInWithPassword`` do ``supabase_flutter`` e configuração do Provider do Email no Authentication do Supabase

----

**Testes Automatizados**


https://github.com/user-attachments/assets/f3bafc5a-5161-4b59-9d65-92a9b9a620d9

----

**Acessibilidade**

- O aplicativo possui adaptação para o uso de leitores de tela como VoiceOver, especialmente na página de login, onde a maior parte das ações do usuário é esperada. Para isso, o widget nativo Semantic foi usado. Essa tecnologia ajusta elementos, ações e mensagens estejam corretamente expostos. Isso inclui rótulos, hints, agrupamentos semânticos e anúncios de feedback em tempo real.


