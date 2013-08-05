@EventCtrl = ["$scope", ($scope) ->
  $scope.event = {}
  $scope.showExtra = (field)->
    $scope.extras.indexOf(field.field_type) > -1
  $scope.addField = ()->
    $scope.event.fields.push {field_type: 'string'}
  $scope.removeField = (idx)->
    $scope.event.fields[idx]._destroy = true
]
