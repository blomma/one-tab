{CompositeDisposable} = require 'atom'

class OneTab
  activate: ->
    atom.packages.onDidActivateInitialPackages =>
      @subscriptions = new CompositeDisposable
      @subscriptions.add atom.workspace.observePanes (pane) =>
        @initPane pane

  deactivate: ->
    @subscriptions.dispose()

  initPane: (pane) ->
    subscription = new CompositeDisposable

    subscription.add pane.onDidDestroy ->
      subscription.dispose()

    subscription.add pane.onDidAddItem =>
      @handlePaneItemEvent pane

    subscription.add pane.onDidRemoveItem =>
      @handlePaneItemEvent pane

    @handlePaneItemEvent pane, 0

  handlePaneItemEvent: (pane, delay = 150) ->
    paneView = atom.views.getView pane
    tabView = paneView.querySelector '.tab-bar'

    if pane.getItems().length == 1
      tabView.setAttribute 'one-tab', tabView.style.display
      tabView.style.display = "none"
    else
      tabView.style.display = tabView.getAttribute 'one-tab'

module.exports = new OneTab()
