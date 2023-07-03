### Installation

Add the following to your pubspec.yaml under the **dev_dependencies**
```yaml
dev_dependencies:
  localization_tools:
    git:
      url: "https://github.com/damattl/localization-tools.git"
```
Then run
```shell
dart run pub get
```
<br>

If you plan to use the translator you need to add the *translator-config.json* to the base of your project dir / working dir. There you have to add following json: <br>
```yaml
{
   "auth_key": "YOUR_PERSONAL_DEEPL_AUTH_KEY",
    "lang": {
        "DE": "de-DE.json",
        "EN-GB": "en-US.json",
        "ES": "es-ES.json",
        "FR": "fr-FR.json",
        "NL": "nl-NL.json"

        # Base structure, remove when copying:
        "LANGUAGE_KEY": "LANGUAGE_FILE RELATIVE TO LANGUAGE_BASE_DIR" 
    }
}
```
Language keys must be supported by the DeepL API:

[DeepL API Request Parameters](https://www.deepl.com/de/docs-api/translating-text/request/)

If you don't have an <code>auth_key</code> create an DeepL-Account first:

[DeepL API](https://www.deepl.com/de/docs-api/)
<br>
<br>


### Supported json syntax guide

Add a new tag to the specified base language file (file to be translated) like this: <br>
```yaml
{
  "main/label-loading": "Laden...",
  
  # Base structure, remove when copying:
  "KEY": "TEXT",
}
```

To specify that a given tag should not be overwritten in some output files, use the options syntax: <br>
```yaml
{
  "main/label-loading": ["Laden...", {"no-overwrite": "es-ES"}],
}
```
At the time being, it is not possible to disable overwrite for multiple languages

### Using the translator

Run the translator with the following command <br>
```shell
dart run localization_tools -d LANGUAGE_FILES_DIR translate
-b BASE_FILE
-c FILE_TO_COMPARE_AGAINST
```
If you omit the input flags, the default values are used instead. <br>
<table>
<tr>
<th>Flag</th><th>Description</th><th>Default</th>
</tr>
<tr>
<td>-d</td><td>Directory where the translation files are stored</td><td>/assets/lang</td>
</tr>
<tr>
<td>-b</td><td>The base file</td><td>base.json</td>
</tr>
<tr>
<td>-c</td><td>The file to compare the base file against</td><td>de-DE.json</td>
</tr>
</table>


Missing language-tags will automatically be added to the other files.
<br>
<br>
**IMPORTANT:** The base file and the file you compare against, should always be of the same language - otherwise all
keys will be marked as changed!


#### VS Code

To launch the script with one click add following lines to your <code>launch.json</code> (via _Run -> Add Configuration_):

```yaml
"configurations": [
        {
            "name": "Translate",
            "type": "dart",

            "request": "launch",
            "program": "localization_tools",
            "args": [
                "-d",
                "../assets/lang",
                "translate"
                "-b",
                "base.json",
                "-c",
                "de-DE.json"
            ],
            "console": "integratedTerminal",
            "cwd": "${workspaceFolder}\\translation-script",
            "justMyCode": true
        },
    ]
```


#### Android Studio / InteliJ

Add new Configuration via <br>
_Run -> Edit Configurations... -> + -> Shell Script_ <br>
Select _Script text_ as execution mode and add:
```shell
dart run localization_tools -d ../assets/lang translate -b base.json -c de-DE.json
``` 
<br>


### Key Generator
To use the key generator run:
```shell
dart run localization_tools -d LANGUAGE_FILES_DIR keys
-b BASE_FILE
-o OUTPUT_DIR
-n OUTPUT_NAME
```
If you omit the input flags, the default values are used instead. <br>
<table>
<tr>
<th>Flag</th><th>Description</th><th>Default</th>
</tr>
<tr>
<td>-d</td><td>Directory where the translation files are stored</td><td>/assets/lang</td>
</tr>
<tr>
<td>-b</td><td>The base file</td><td>base.json</td>
</tr>
<tr>
<td>-o</td><td>The output directory for the generated file</td><td>lib/generated</td>
</tr>
<tr>
<td>-n</td><td>The name of the generated file</td><td>translation_keys.g.dart</td>
</tr>
</table>
