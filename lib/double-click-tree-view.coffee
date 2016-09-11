'use strict'

class DoubleClickTreeView
  activate: ->
    atom.packages.activatePackage('tree-view').then (treeViewPkg) =>
      @treeView = treeViewPkg.mainModule.createView()
      @treeView.originalEntryClicked = @treeView.entryClicked

      @treeView.entryClicked = (e) ->
        false

      @treeView.on 'dblclick', '.entry', (e) =>
        @treeView.openSelectedEntry.call(@treeView)
        false

      @treeView.on 'click', '.entry.list-nested-item > .list-item', (e) =>
        if (e.target == e.currentTarget)
          span = e.currentTarget.querySelector(':scope >.name')

          if (span && e.offsetX < span.offsetLeft)
            @treeView.openSelectedEntry.call(@treeView)
        false

  deactivate: ->
    @treeView.entryClicked = @treeView.originalEntryClicked
    delete @treeView.originalEntryClicked
    @treeView.off 'dblclick', '.entry'

  entryDoubleClicked: (e) ->
    @originalEntryClicked(e)

module.exports = new DoubleClickTreeView()
