@WikiCtrl = ["$scope", ($scope) ->
  $scope.wiki = {}
  $scope.converter = new Showdown.converter()
  $scope.preview = ->
    $scope.converter.makeHtml('#' + $scope.wiki.title + '\n\n' + $scope.wiki.content)
]
