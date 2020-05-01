
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shrtcts

<!-- badges: start -->

<!-- badges: end -->

**shrtcts** lets you make anything an RStudio shortcut\!

## Installation

You can install the `shrtcts` from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("gadenbuie/shrtcts")
```

## Quick Intro

Store your shortcuts in `~/.config/.shrtcts.yaml` or `~/.shrtcts.yaml`.
Each shortcut should look something like the example below, but you can
include *any R code you want* as the shortcut `Binding`.

``` yaml
- Name: Say Something Nice
  Description: A demo of cool things
  Binding: praise::praise
  Interactive: true
```

Then add this to your `~/.Rprofile` (use `usethis::edit_r_profile()` to
find this file quickly).

``` r
if (interactive() & requireNamespace("shrtcts", quietly = TRUE)) {
  shrtcts::add_rstudio_shortcuts()
}
```

After restarting your R session, you’ll find your new shortcut **Say
Something Nice** in your RStudio Addins menu\!

If you store your `.shrtcts.yaml` file in your home directory, you could
also just run `shrtcts::add_rstudio_shortcuts()` whenever you update the
YAML file instead of adding the above code to your `~/.Rprofile`.

## Details

### shrtcts YAML format

Use the following template to organize your `.shrtcts.yaml`. Each
shortcut is a YAML list item with the following structure:

``` yaml
- Name: Say Something Nice
  Description: A demo of cool things
  Binding: praise::praise
  Interactive: true
```

This format follows the format used by RStudio in the `addins.dcf` file.
The minimum required fields are `Name` and `Binding`. Use the
`example_shortcuts_yaml()` function to see a complete example YAML file.
Note that unlike the `addins.dcf` file format, in `.shrtcts.yaml`, the
`Binding` field is an R function or arbitrary R code. If your shortcut
calls a function in another package, you can simply set `Binding` to the
function name, as in the example above. Otherwise, you can use a
multi-line literal- style YAML block to write your R code:

``` yaml
- Name: Remind me where I am
  Binding: |
    current_directory <- getwd()
    message("Working directory: ", current_directory)
  Interactive: false
```

Note that when `Interactive` is `false`, no output will be shown unless
you explicitly call a `print()` or a similar function.

Save your shortcuts YAML file to `.config/.shrtcts.yaml` or
`.shrtcts.yaml` in your home directory (i.e. \[fs::path\_home\_r()\] or
\[fs::path\_home()\]), and run `add_rstudio_shortcuts()` to install your
shortcuts. You’ll need to restart your R session for RStudio to learn
your shortcuts.

Once RStudio has learned about your shortcuts, you can create keyboard
shortcuts to trigger each action. Note that the order of the shortcuts
in your YAML file is important. `shrtcts` comes with are 100 “slots” for
RStudio addins. Changing the order of the shortcuts in the YAML file
will change which slot is used for each shortcut, which could break your
keyboard shortcuts. To avoid this, specifically set the id of any
shortcut to a number between 1 and 100, to ensure that keyboard
shortcuts remain the same.

    - Name: Make A Noise
      Binding: beepr::beep()
      id: 42

### RStudio Keyboard Shortcuts

Once you’ve setup an RStudio Addin via `shrtcts`, you can create a
keyboard shortcut for the addin using the *Tools* \> *Modify keyboard
shortcuts* menu.

If you create a shortcut for an addin via `shrtcts`, it’s a good idea to
set the `id` of the shortcut (see the section above).

Keyboard shortcuts persist even if you update the list of shortcuts, but
re-installing the `shrtcts` package will break any previously-installed
shortcuts. As far as I know, there’s no way to save and restore these
shortcuts, so use caution.
