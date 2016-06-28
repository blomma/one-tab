'use babel';

import { CompositeDisposable } from 'atom';

class OneTab {
    activate(state) {
        this.subscriptions = new CompositeDisposable();
        return this.subscriptions.add(atom.workspace.observePanes(pane => {
            return this.initPane(pane);
        }));
    }

    deactivate() {
        return this.subscriptions.dispose();
    }

    initPane(pane) {
        this.updateTabBarVisibility(pane);

        let subscription = new CompositeDisposable();
        subscription.add(pane.onDidDestroy(() => subscription.dispose()));

        subscription.add(pane.onDidAddItem(() => {
            return this.updateTabBarVisibility(pane);
        }));

        return subscription.add(pane.onDidRemoveItem(() => {
            return this.updateTabBarVisibility(pane);
        }));
    }

    updateTabBarVisibility(pane) {
        let paneView = atom.views.getView(pane);

        if (pane.getItems().length === 1) {
            return paneView.setAttribute('data-one-tab', true);
        } else {
            return paneView.removeAttribute('data-one-tab');
        }
    }
}

export default new OneTab();
