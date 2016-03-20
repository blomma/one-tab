# One Tab package

This package fixes a shortcoming in the default tabs package that gets shipped with atom, namely that if you have more than one pane it will not properly hide the tab bar.

Some astute observer in the audience might have noticed that in some themes when the tab bar gets hidden we are left with no border on top, this is something that the ui theme sets or not sets depending on how it wants to look.

For a theme like one-ui-dark this is how you add that border back. Add this line to your ```styles.less```. Depending on what theme you have you need to tweak this to make it work.

    atom-workspace.theme-one-dark-ui atom-pane-container  {
        atom-pane[data-one-tab="true"] {
            .item-views {
                border-top: 1px solid @pane-item-border-color;
            }
        }
    }
