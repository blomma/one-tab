{CompositeDisposable} = require 'atom'

class OneTab
    activate: (state) ->
        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.workspace.observePanes (pane) =>
            @initPane pane

    deactivate: ->
        @subscriptions.dispose()

    initPane: (pane) ->
        @updateTabBarVisibility pane

        subscription = new CompositeDisposable
        subscription.add pane.onDidDestroy ->
            subscription.dispose()

        subscription.add pane.onDidAddItem =>
            @updateTabBarVisibility pane

        subscription.add pane.onDidRemoveItem =>
            @updateTabBarVisibility pane

    updateTabBarVisibility: (pane) ->
        paneView = atom.views.getView pane

        if pane.getItems().length is 1
            paneView.setAttribute 'data-one-tab', true
        else
            paneView.removeAttribute 'data-one-tab'

module.exports = new OneTab()
