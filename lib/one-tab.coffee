{CompositeDisposable} = require 'atom'

class OneTab
    activate: ->
        atom.packages.onDidActivateInitialPackages =>
            @subscriptions = new CompositeDisposable
            @subscriptions.add atom.workspaceView.eachPaneView (paneView) =>
                @initPaneView(paneView)

    deactivate: ->
        @subscriptions.dispose()

    # Handles setup for each pane
    initPaneView: (paneView) ->
        subscription = new CompositeDisposable

        subscription.add paneView.model.onDidDestroy ->
            subscription.dispose()

        subscription.add paneView.model.onDidAddItem =>
            @handlePaneViewItemEvent paneView

        subscription.add paneView.model.onDidRemoveItem =>
            @handlePaneViewItemEvent paneView

        # Initial hide
        @handlePaneViewItemEvent paneView, 0

    handlePaneViewItemEvent: (paneView, delay = 150) ->
        tabView = paneView.find '.tab-bar'
        if paneView.model.getItems().length == 1
            tabView.hide(delay)
        else
            tabView.show(delay)

module.exports = new OneTab()
