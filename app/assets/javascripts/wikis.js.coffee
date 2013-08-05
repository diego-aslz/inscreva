@WikiCtrl = ["$scope", ($scope) ->
  $scope.wiki = {}
  $scope.converter = new Showdown.converter()
]
