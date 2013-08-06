@WikiCtrl = ["$scope", ($scope) ->
  $scope.wiki = {}
  $scope.converter = new Showdown.converter()
  $scope.preview = ->
    title = ''
    if $scope.wiki.title
      title = '# ' + $scope.wiki.title + '\n\n'
    $scope.converter.makeHtml(title + ($scope.wiki.content || ''))
  $scope.name = ->
    return $scope.wiki.name if $scope.wiki.name
    return '' unless $scope.wiki.title
    text = $scope.wiki.title
    text = text.replace(new RegExp('[ÁÀÂÃ]','gi'), 'a');
    text = text.replace(new RegExp('[ÉÈÊ]','gi'), 'e');
    text = text.replace(new RegExp('[ÍÌÎ]','gi'), 'i');
    text = text.replace(new RegExp('[ÓÒÔÕ]','gi'), 'o');
    text = text.replace(new RegExp('[ÚÙÛ]','gi'), 'u');
    text = text.replace(new RegExp('[Ç]','gi'), 'c');
    text = text.replace(new RegExp('\\s','gi'), '-');
    text.replace(/[^\w_\-]/gi, '').toLowerCase()
]
