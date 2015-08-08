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
            @updateTabBarVisibility pane

        subscription.add pane.onDidRemoveItem =>
            @updateTabBarVisibility pane

        @updateTabBarVisibility pane

    updateTabBarVisibility: (pane) ->
        paneView = atom.views.getView pane
        tabView = paneView.querySelector '.tab-bar'

        if pane.getItems().length is 1
            tabView.setAttribute 'data-one-tab-display', tabView.style.display
            tabView.style.display = 'none'
        else
            oldValue = tabView.getAttribute 'data-one-tab-display'
            if oldValue isnt null
                tabView.style.display = oldValue
                tabView.removeAttribute 'data-one-tab-display'

module.exports = new OneTab()
