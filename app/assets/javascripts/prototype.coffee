if !Array::remove
  Array::remove = (val, all) ->
    i = undefined
    removedItems = []
    if all
      i = @length
      while i--
        if @[i] == val
          removedItems.push @splice(i, 1)[0]
    else
      #same as before...
      i = @indexOf(val)
      if i > -1
        removedItems = @splice(i, 1)
    removedItems
