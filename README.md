# Chrome history unique link cleaner 🛡️

![chrome-history-unique-link-cleaner](https://github.com/user-attachments/assets/422b056b-2db7-48e9-b8f6-2914f7535d05)


## Description on 🇺🇸 English, Descricion en 🇪🇸 Español, e Descrição em 🇧🇷 Português

### **Description**
A bash script to clean a specific link (URL) on Google Chrome history. Why? Chrome history stores so many entries for a unique URL like e.g., facebook.com ( 😒 🧲 `fb.com/1` 🧲 `fb.com/2` 🧲 `fb.com/a` 🧲 `fb.com/b` or 🧲 ` fb.com/huashdausidhaisdu`), inflating and spamming with so many complex and extensible URL chains on the database Chrome history.

### **What you need?**
Just use the script, type the desired URL (e.g., 🧲 `facebook.com` or 🧲 `translate.google.com`) to the script make the deep cleaning on all spamming URLs stored on your Google Chrome browse History.

```
sudo rm link-cleaner.sh 2>/dev/null || true &&

wget https://raw.githubusercontent.com/atorresbr/chrome-history-unique-link-cleaner/refs/heads/main/link-cleaner.sh &&

sudo chmod +x link-cleaner.sh && ./link-cleaner.sh

```

### **How the script works (Detailed)**
The script performs a surgical operation on the browser's internal architecture:
*   **Process Termination:** It forcefully closes all Chrome/Chromium instances to lift the "Database Lock" state, allowing [SQLite3](https://sqlite.org) to modify the files safely.
*   **Path Discovery:** It recursively scans your `$HOME` directory to find every `History`, `Login Data`, and `Web Data` file, covering Native, Snap, and Flatpak installations.
*   **Relational Purge:** It doesn't just delete a URL; it uses nested SQL queries to find every "Visit ID" associated with that URL and wipes them from the `visits` table to ensure no ghost entries remain.
*   **Data Scrubbing:** It cleans specific tables including `keyword_search_terms` (Omnibox suggestions) and `segment_usage` (Most Visited tiles).
*   **Disk Vacuum:** It executes a `VACUUM` command, which defragments the database files and physically removes deleted data fragments from your storage.

### **Database Optimization ⚡**
Beyond cleaning, the script performs a **Deep Optimization** using the [VACUUM command](https://www.sqlite.org):
*   **Speed Recovery:** Over time, deleting thousands of URLs (like 🧲 `fb.com/1` 🧲 `fb.com/2` 🧲 `fb.com/a` 🧲 `fb.com/b` or 🧲 ` fb.com/huashdausidhaisdu`) leaves "holes" in the database file. `VACUUM` rebuilds the database, making it smaller and significantly faster to load.
*   **Fragment Removal:** This ensures that deleted data is physically overwritten and removed from the disk sectors, not just "marked as deleted."

### **Technical Mapping (SQL Architecture)**

| Database File | Table Name | Purpose |
| :--- | :--- | :--- |
| **History** | `urls` | Main storage for the URL strings. |
| **History** | `visits` | Timestamps and reference IDs for every site load. |
| **History** | `keyword_search_terms` | Search queries and auto-complete predictions in the address bar. |
| **History** | `segment_usage` | Metrics used to display the "Most Visited" tiles on a new tab. |
| **Login Data** | `logins` | Saved usernames and encrypted passwords for the domain. |
| **Web Data** | `autofill` | Saved form data and field entries. |
| **Favicons** | `icon_mapping` | Links between URLs and cached site icons. |

### **Safety & Logging 🛡️**
*   **Automatic Logging:** Every action is recorded in `~/chrome_purge_report.log`, including profiles scanned and match counts.
*   **Integrity Protection:** The script removes `-journal` and `-wal` temporary files before processing to prevent database corruption.
*   **Self-Verification:** It performs a "before and after" check to confirm that 0 matches remain in the database.

### **Sample Log Output (`chrome_purge_report.log`)**
```text
--- Chrome Purge Session: Sat Jan 31 12:41:00 GMT 2026 ---
PROFILE: Default
  >> Matches Found: 142
  >> SUCCESS: Verified (0 matches remaining).
  >> Database Optimized (VACUUM complete).
 ```
### **Warning 🛸**
If you are logged on **Google Chrome sync**, you need to clean **MANUALLY** the History on [My Activity](https://myactivity.google.com) to prevent the Chrome reload all history activity locally for your URL cleaned.


 # Chrome history unique link clean 🛡️

## 🇧🇷 Português (BR)

### **Descrição**
Um script bash para limpar um link específico (URL) no histórico do Google Chrome. Por quê? O histórico do Chrome armazena tantas entradas para uma única URL como, por exemplo, facebook.com ( 😒 🧲 `fb.com/1` 🧲 `fb.com/2` 🧲 `fb.com/a` 🧲 `fb.com/b` ou 🧲 ` fb.com/huashdausidhaisdu`), inflando e gerando spam com cadeias de URLs complexas e extensas no banco de dados do histórico do Chrome.

### **O que você precisa?**
Basta usar o script, digitar a URL desejada (ex: 🧲 `facebook.com` ou 🧲 `translate.google.com`) para que o script faça a limpeza profunda de todas as URLs de spam armazenadas no seu histórico de navegação do Google Chrome.

### **Como o script funciona (Detalhado)**
O script realiza uma operação cirúrgica na arquitetura interna do navegador:
*   **Finalização de Processos:** Encerra forçadamente todas as instâncias do Chrome/Chromium para liberar o estado de "Database Lock", permitindo que o [SQLite3](https://sqlite.org) modifique os arquivos com segurança.
*   **Descoberta de Caminhos:** Varre recursivamente seu diretório `$HOME` para encontrar todos os arquivos de `History`, `Login Data` e `Web Data`, cobrindo instalações Nativas, Snap e Flatpak.
*   **Purga Relacional:** Não deleta apenas uma URL; utiliza consultas SQL aninhadas para encontrar cada "ID de Visita" associado àquela URL e os apaga da tabela `visits`, garantindo que não restem entradas fantasmas.
*   **Limpeza de Dados:** Limpa tabelas específicas, incluindo `keyword_search_terms` (sugestões da barra de endereços) e `segment_usage` (blocos de sites mais visitados).
*   **Vacuum de Disco:** Executa o comando `VACUUM`, que desfragmenta os arquivos do banco de dados e remove fisicamente os fragmentos de dados deletados do seu armazenamento.

### **Otimização de Banco de Dados ⚡**
Além da limpeza, o script realiza uma **Otimização Profunda** usando o [comando VACUUM](https://www.sqlite.org):
*   **Recuperação de Velocidade:** Com o tempo, deletar milhares de URLs (como 🧲 `fb.com/1` 🧲 `fb.com/2` 🧲 `fb.com/a` 🧲 `fb.com/b` ou 🧲 ` fb.com/huashdausidhaisdu`) deixa "buracos" no arquivo do banco de dados. O `VACUUM` reconstrói o banco, tornando-o menor e significativamente mais rápido para carregar.
*   **Remoção de Fragmentos:** Isso garante que os dados deletados sejam fisicamente sobrescritos e removidos dos setores do disco, e não apenas "marcados como excluídos".

### **Mapeamento Técnico (Arquitetura SQL)**

| Arquivo de Banco | Nome da Tabela | Propósito |
| :--- | :--- | :--- |
| **History** | `urls` | Armazenamento principal das strings de URL. |
| **History** | `visits` | Carimbos de data/hora e IDs de referência para cada acesso. |
| **History** | `keyword_search_terms` | Consultas de pesquisa e previsões de preenchimento automático na barra de endereços. |
| **History** | `segment_usage` | Métricas para exibir os "Sites Mais Visitados" na nova guia. |
| **Login Data** | `logins` | Nomes de usuário e senhas criptografadas salvos para o domínio. |
| **Web Data** | `autofill` | Dados de formulários e entradas de campos salvos. |
| **Favicons** | `icon_mapping` | Vínculos entre URLs e ícones de sites (favicons) em cache. |

### **Segurança & Logs 🛡️**
*   **Log Automático:** Todas as ações são registradas em `~/chrome_purge_report.log`, incluindo perfis verificados e contagem de correspondências.
*   **Proteção de Integridade:** O script remove arquivos temporários `-journal` e `-wal` antes de processar para evitar a corrupção do banco de dados.
*   **Auto-Verificação:** Realiza uma checagem "antes e depois" para confirmar que restam 0 correspondências no banco de dados.

### **Exemplo de Log de Saída (`chrome_purge_report.log`)**
```text
--- Sessão de Purga do Chrome: Sat Jan 31 12:41:00 GMT 2026 ---
PROFILE: Default
  >> Correspondências Encontradas: 142
  >> SUCESSO: Verificado (0 correspondências restantes).
  >> Banco de Dados Otimizado (VACUUM concluído).
```
### **Aviso 🛸**
Se você estiver logado na **sincronização do Google Chrome**, você precisa limpar **MANUALMENTE** o histórico no [Minha Atividade do Google](https://myactivity.google.com) para evitar que o Chrome recarregue toda a atividade do histórico localmente para a URL que você limpou.



# Chrome history unique link clean 🛡️

## 🇪🇸 Español

### **Descripción**
Un script bash para limpiar un enlace específico (URL) en el historial de Google Chrome. ¿Por qué? El historial de Chrome almacena tantas entradas para una URL única como, por ejemplo, facebook.com ( 😒 🧲 `fb.com/1` 🧲 `fb.com/2` 🧲 `fb.com/a` 🧲 `fb.com/b` o 🧲 ` fb.com/huashdausidhaisdu`), inflando y llenando de spam con cadenas de URL complejas y extensas en la base de datos del historial de Chrome.

### **¿Qué necesitas?**
Simplemente usa el script, escribe la URL deseada (ej: 🧲 `facebook.com` o 🧲 `translate.google.com`) para que el script realice la limpieza profunda de todas las URLs de spam almacenadas en tu historial de navegación de Google Chrome.

### **Cómo funciona el script (Detallado)**
El script realiza una operación quirúrgica en la arquitectura interna del navegador:
*   **Finalización de Procesos:** Cierra forzosamente todas las instancias de Chrome/Chromium para liberar el estado de "Database Lock", permitiendo que [SQLite3](https://sqlite.org) modifique los archivos de forma segura.
*   **Descubrimiento de Rutas:** Escanea recursivamente tu directorio `$HOME` para encontrar cada archivo de `History`, `Login Data` y `Web Data`, cubriendo instalaciones Nativas, Snap y Flatpak.
*   **Purga Relacional:** No solo borra una URL; utiliza consultas SQL anidadas para encontrar cada "ID de Visita" asociado con esa URL y los elimina de la tabla `visits` para asegurar que no queden entradas fantasma.
*   **Limpieza de Datos:** Limpia tablas específicas incluyendo `keyword_search_terms` (sugerencias de la barra de direcciones) y `segment_usage` (mosaicos de sitios más visitados).
*   **Vacío de Disco:** Ejecuta el comando `VACUUM`, que desfragmenta los archivos de la base de datos y elimina físicamente los fragmentos de datos borrados de tu almacenamiento.

### **Optimización de Base de Datos ⚡**
Además de la limpieza, el script realiza una **Optimización Profunda** usando el [comando VACUUM](https://www.sqlite.org):
*   **Recuperación de Velocidade:** Con el tiempo, borrar miles de URLs (como 🧲 `fb.com/1` 🧲 `fb.com/2` 🧲 `fb.com/a` 🧲 `fb.com/b` o 🧲 ` fb.com/huashdausidhaisdu`) deja "huecos" en el archivo de la base de datos. `VACUUM` reconstruye la base de datos, haciéndola más pequeña y significativamente más rápida de cargar.
*   **Eliminación de Fragmentos:** Esto asegura que los datos borrados sean físicamente sobrescritos y eliminados de los sectores del disco, y no solo "marcados como eliminados".

### **Mapeo Técnico (Arquitectura SQL)**

| Archivo de Base de Datos | Nombre de Tabla | Propósito |
| :--- | :--- | :--- |
| **History** | `urls` | Almacenamiento principal de las cadenas de URL. |
| **History** | `visits` | Marcas de tiempo e IDs de referencia para cada acceso al sitio. |
| **History** | `keyword_search_terms` | Consultas de búsqueda y predicciones de autocompletado en la barra de direcciones. |
| **History** | `segment_usage` | Métricas para mostrar los mosaicos de "Sitios más visitados" en una pestaña nova. |
| **Login Data** | `logins` | Nombres de usuario y contraseñas cifradas guardadas para el dominio. |
| **Web Data** | `autofill` | Datos de formularios y campos guardados. |
| **Favicons** | `icon_mapping` | Vínculos entre URLs e iconos de sitios (favicons) en caché. |

### **Seguridad & Registro 🛡️**
*   **Registro Automático:** Todas las acciones se registran en `~/chrome_purge_report.log`, incluyendo perfiles escaneados y recuentos de coincidencias.
*   **Protección de Integridad:** El script elimina los archivos temporales `-journal` e `-wal` antes de procesar para evitar la corrupción de la base de datos.
*   **Auto-Verificación:** Realiza una comprobación de "antes y después" para confirmar que quedan 0 coincidencias en la base de datos.

### **Ejemplo de Registro de Salida (`chrome_purge_report.log`)**
```text
--- Sesión de Purga de Chrome: Sat Jan 31 12:41:00 GMT 2026 ---
PROFILE: Default
  >> Coincidencias Encontradas: 142
  >> ÉXITO: Verificado (0 coincidencias restantes).
  >> Base de Datos Optimizada (VACUUM completo).
```

### **Advertencia 🛸**
Si has iniciado sesión en la **sincronización de Google Chrome**, debes limpiar **MANUALMENTE** el historial en [Mi Actividad de Google](https://myactivity.google.com) para evitar que Chrome recargue localmente toda la atividade del historial para la URL que has limpiado.

  
