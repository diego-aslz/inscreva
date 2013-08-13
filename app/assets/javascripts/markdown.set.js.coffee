window.mdSettings =
  previewParserPath: "/markitup/preview"
  previewInElement: ".md-page"
  previewAutoRefresh: false
  onShiftEnter:
    keepDefault:false
    openWith:'\n\n'
  markupSet: [
    {
      name:'Cabeçalho de Nível 1'
      key:'1'
      placeHolder:'Título aqui...'
      closeWith: (markItUp) ->
        miu.markdownTitle(markItUp, '=')
    },
    {
      name:'Cabeçalho de Nível 2'
      key:'2'
      placeHolder:'Título aqui...'
      closeWith: (markItUp) ->
        miu.markdownTitle(markItUp, '-')
    },
    {name:'Cabeçalho 3', key:'3', openWith:'### ', placeHolder:'Título aqui...' },
    {name:'Cabeçalho 4', key:'4', openWith:'#### ', placeHolder:'Título aqui...' },
    {name:'Cabeçalho 5', key:'5', openWith:'##### ', placeHolder:'Título aqui...' },
    {name:'Cabeçalho 6', key:'6', openWith:'###### ', placeHolder:'Título aqui...' },
    {separator:'---------------' },
    {name:'Negrito', key:'B', openWith:'**', closeWith:'**'},
    {name:'Itálico', key:'I', openWith:'_', closeWith:'_'},
    {separator:'---------------' },
    {name:'Lista', openWith:'- ' },
    {
      name:'Lista Enumerada'
      openWith: (markItUp) ->
        markItUp.line + '. '
    },
    {separator:'---------------' },
    {name:'Imagem', key:'P', replaceWith:'![[![Texto Descritivo]!]]([![Url:!:http://]!] "[![Título]!]")'},
    {name:'Link', key:'L', openWith:'[', closeWith:']([![Url:!:http://]!] "[![Título]!]")', placeHolder:'Texto do link...' },
    {separator:'---------------'},
    {name:'Comentário', openWith:'> '},
    {name:'Bloco', openWith:'(!(\t|!|`)!)', closeWith:'(!(`)!)'},
    {separator:'---------------'},
    {name:'Pré-visualizar', call:'preview', className:"preview"}
  ]

# mIu nameSpace to avoid conflict.
window.miu =
  markdownTitle: (markItUp, char) ->
    heading = ''
    n = $.trim(markItUp.selection||markItUp.placeHolder).length
    for i in [0..n-1]
      heading += char
    '\n' + heading
