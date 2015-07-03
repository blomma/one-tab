{CompositeDisposable} = require 'atom'

class OneTab
    activate: ->
        atom.packages.onDidActivatePackage (p) ->
            console.log p

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

        @handlePaneItemEvent pane

    handlePaneItemEvent: (pane) ->
        paneView = atom.views.getView pane
        tabView = paneView.querySelector '.tab-bar'

        if pane.getItems().length == 1
            tabView.setAttribute 'one-tab', tabView.style.height
            tabView.style.height = "1px"
        else
            tabView.style.height = tabView.getAttribute 'one-tab'

module.exports = new OneTab()
