@EventCtrl = ["$scope", ($scope) ->
  $scope.event = {}
  $scope.showExtra = (field)->
    $scope.extras.indexOf(field.field_type) > -1
  $scope.addField = ->
    newField = {field_type: 'string'}
    $scope.event.fields.splice($scope.fieldsLength(), 0, newField)
    $scope.editField newField
    $scope.orderPriority()
  $scope.addDelegation = ->
    $scope.event.delegations.push {}
  $scope.removeDelegation = (idx)->
    $scope.event.delegations[idx]._destroy = true
  $scope.removeField = (idx)->
    fs = $scope.event.fields
    fs[idx]._destroy = true
    fs.push fs[idx]
    fs.splice(idx, 1)
    $scope.orderPriority()
  $scope.fieldUp = (idx)->
    fs = $scope.event.fields
    obj = fs[idx - 1]
    fs[idx - 1] = fs[idx]
    fs[idx] = obj
    $scope.orderPriority()
  $scope.fieldDown = (idx)->
    fs = $scope.event.fields
    obj = fs[idx + 1]
    fs[idx + 1] = fs[idx]
    fs[idx] = obj
    $scope.orderPriority()
  $scope.fieldsLength = ->
    i = 0
    for field in $scope.event.fields
      i++ unless field._destroy
    i
  $scope.orderPriority = ->
    p = 1
    for field in $scope.event.fields
      field.priority = p++ unless field._destroy
    null
  $scope.editField = (f)->
    for field in $scope.event.fields
      field.editing = false
    f.editing = true
]
