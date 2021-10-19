import { ensureDir } from 'https://deno.land/std@0.95.0/fs/mod.ts'
import Variables from './variables.ts'

const TEMPLATES = ['content.html', 'copyright.html', 'cover.html', 'dict.opf']

const WORD_TEMPLATE = await Deno.readTextFile(new URL(`templates/word.html`, import.meta.url).pathname)

for (let [language, languageVariables] of Object.entries(Variables)) {
  await ensureDir(languageVariables.outputPath)

  // Generate word list
  const words = (await Deno.readTextFile(languageVariables.wordListPath)).split('@')
  let i = 0
  languageVariables.parsedWordList = '<p>'
  for (let word of words) {
    if (i++ % 1000 == 0) languageVariables.parsedWordList += '</p><p>'

    const [original, ...translation] = word.split('\n')
    
    const parsed = WORD_TEMPLATE.replaceAll('{{original}}', original)
      .replaceAll('{{translation}}', translation.join('\n'))

    languageVariables.parsedWordList += parsed
  }
  languageVariables.parsedWordList += '</p>'
  
  // Copy template files
  for (const file of TEMPLATES) {
    let content = await Deno.readTextFile(new URL(`templates/${file}`, import.meta.url).pathname)

    for (const [key, value] of Object.entries(languageVariables)) {
      content = content.replaceAll(`{{${key}}}`, value)
    }

    await Deno.writeTextFile(`${languageVariables.outputPath}/${file}`, content)
  }
}