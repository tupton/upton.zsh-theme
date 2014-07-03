## Upton, my personal oh-my-zsh theme

First, [make sure oh-my-zsh is installed][omz]. They have great setup instructions.

Then, clone this repository into the `custom/` directory. I like to put themes in
`custom/themes/<theme-name>/`.

In your `.zshrc`, use the theme with the following assignment. Note the `<theme-name>/<theme>` naming scheme;
this is a side effect of putting the theme in its own directory. The benefits of being able to put
multiple custom themes in this directory are bigger than the one-time cost of this "weirder" naming
scheme. If there's a better way to do this, I'm open to suggestions.

    ZSH_THEME="upton/upton"
