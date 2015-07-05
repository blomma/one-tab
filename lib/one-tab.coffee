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
            tabView.setAttribute 'one-tab-height', tabView.style.height
            tabView.style.height = '1px'
        else
            oldValue = tabView.getAttribute 'one-tab-height'
            if oldValue isnt null
                tabView.style.height = oldValue
                tabView.removeAttribute 'one-tab-height'

module.exports = new OneTab()
