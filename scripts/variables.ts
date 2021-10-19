export default {
  vnde: {
    language: 'vn',
    output: 'de',
    title: 'Vietnamesisch-Deutsches Wörterbuch',
    author: 'Von Christopher Mühl',
    copyrightNotice: 'blub',
    outputPath: new URL('../output/vnde', import.meta.url).pathname,
    wordListPath: new URL('../download/vd12K.dict', import.meta.url).pathname,
    parsedWordList: '',
  },
  devn: {
    language: 'de',
    output: 'vn',
    title: 'Duc',
    author: 'Cua Christopher Mühl',
    copyrightNotice: 'blub2',
    outputPath: new URL('../output/devn', import.meta.url).pathname,
    wordListPath: new URL('../download/dv45K.dict', import.meta.url).pathname,
    parsedWordList: '',
  }
}
