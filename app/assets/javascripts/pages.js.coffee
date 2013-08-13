@PageCtrl = ["$scope", ($scope) ->
  $scope.page = {}
  $scope.previewButton = null
  $scope.name = ->
    return $scope.page.name if $scope.page.name
    return '' unless $scope.page.title
    text = $scope.page.title
    text = text.replace(new RegExp('[ÁÀÂÃ]','gi'), 'a');
    text = text.replace(new RegExp('[ÉÈÊ]','gi'), 'e');
    text = text.replace(new RegExp('[ÍÌÎ]','gi'), 'i');
    text = text.replace(new RegExp('[ÓÒÔÕ]','gi'), 'o');
    text = text.replace(new RegExp('[ÚÙÛ]','gi'), 'u');
    text = text.replace(new RegExp('[Ç]','gi'), 'c');
    text = text.replace(new RegExp('\\s','gi'), '-');
    text.replace(/[^\w_\-]/gi, '').toLowerCase()
  $scope.addFile = ->
    $scope.page.files.push {}
  $scope.removeFile = (idx)->
    fs = $scope.page.files
    fs[idx]._destroy = true
  $scope.refreshPreview = ->
    $scope.previewButton = $('.preview a') unless $scope.previewButton
    $scope.previewButton.trigger('mouseup')
]
