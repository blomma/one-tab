'use babel';

import { CompositeDisposable } from 'atom';

class OneTab {
	activate(state) {
		this.subscriptions = new CompositeDisposable();
		this.subscriptions.add(atom.workspace.observePanes(pane => {
			this.initPane(pane);
		}));
	}

	deactivate() {
		this.subscriptions.dispose();
	}

	initPane(pane) {
		this.updateTabBarVisibility(pane);

		const subscription = new CompositeDisposable();
		subscription.add(pane.onDidDestroy(() => {
			subscription.dispose()
			this.subscriptions.remove(subscription)
		}));

		subscription.add(pane.onDidAddItem(() => {
			this.updateTabBarVisibility(pane);
		}));

		subscription.add(pane.onDidRemoveItem(() => {
			this.updateTabBarVisibility(pane);
		}));

		this.subscriptions.add(subscription)
	}

	updateTabBarVisibility(pane) {
		const paneView = atom.views.getView(pane);

		if (pane.getItems().length === 1) {
			paneView.setAttribute('data-one-tab', true);
		} else {
			paneView.removeAttribute('data-one-tab');
		}
	}
}

export default new OneTab();
