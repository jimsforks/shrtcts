describe("parse_shortcuts_r()", {
  it("works with packaged functions", {
    text <- "
#' Shortcut Title
#'
#' Shortcut Description
#'
#' @id 5
#' @interactive
shrtcts:::test_fun"

    sh <- parse_shortcuts_text(text)
    expect_true(is_shrtcts(sh))
    expect_true(is_shrtcts_r(sh))
    expect_equal(sh[[1]]$Name, "Shortcut Title")
    expect_equal(sh[[1]]$Description, "Shortcut Description")
    expect_equal(sh[[1]]$id, 5L)
    expect_equal(sh[[1]]$`function`, "shrtcts:::test_fun")
    expect_true(sh[[1]]$Interactive)
    expect_equal(sh[[1]]$Binding, "shortcut_05")
    expect_true(is_likely_packaged_fn(sh[[1]]$`function`))
  })

  it("requires a title", {
    text <- "
#' @interactive
message"

    expect_error(parse_shortcuts_text(text))
  })

  it("requires only a title and a function", {
    text <- "
#' Title
message
"
    sh <- parse_shortcuts_text(text)
    expect_true(is_shrtcts(sh))
    expect_true(is_shrtcts_r(sh))
    expect_equal(sh[[1]]$Name, "Title")
    expect_equal(sh[[1]]$Description, "")
    expect_equal(sh[[1]]$id, 1L)
    expect_equal(sh[[1]]$`function`, "message")
    expect_false(sh[[1]]$Interactive)
    expect_equal(sh[[1]]$Binding, "shortcut_01")
    expect_false(is_likely_packaged_fn(sh[[1]]$`function`))
  })

  it("requires a function", {
    text <- "
#' @title nothing
#' @interactive
NULL"

    sh <- parse_shortcuts_text(text)
    expect_true(is_shrtcts(sh))
    expect_true(is_shrtcts_r(sh))
    expect_equal(length(sh), 0)
  })

  it("handles named function", {
    text <- "
#' @title named function
test <- function() 'apple'
"

    sh <- parse_shortcuts_text(text)
    expect_true(is_shrtcts(sh))
    expect_true(is_shrtcts_r(sh))
    expect_equal(sh[[1]]$Name, "named function")
    expect_equal(sh[[1]]$Description, "")
    expect_equal(sh[[1]]$id, 1L)
    expect_equal(sh[[1]]$`function`, 'function() "apple"')
    expect_false(sh[[1]]$Interactive)
    expect_equal(sh[[1]]$Binding, "shortcut_01")
    expect_false(is_likely_packaged_fn(sh[[1]]$`function`))
  })

  it("returns keyboard shortcut", {
    text <- "
#' Title
#'
#' @id 42
#' @shortcut Cmd+Alt+J
function() message('hello')
"
    sh <- parse_shortcuts_text(text)
  })
})

test_that("parse_shortcuts_r() and parse_shortcuts_yaml() are equivalent", {
  txt_r <- "
#' Shortcut Title
#'
#' Shortcut Description
#'
#' @id 5
#' @shortcut Ctrl+Alt+Shift+R
#' @interactive
shrtcts:::test_fun"

  txt_yml <- "
- name: Shortcut Title
  description: Shortcut Description
  id: 5
  shortcut: Ctrl+Alt+Shift+R
  Interactive: true
  Binding: shrtcts:::test_fun
"
  sh_r <- parse_shortcuts_text(txt_r, "R")[[1]]
  sh_r <- lapply(sh_r, as.character)
  sh_yml <- parse_shortcuts_text(txt_yml, "yml")[[1]]
  sh_yml <- lapply(sh_yml, as.character)

  expect_setequal(names(sh_r), names(sh_yml))
  expect_equal(sh_r, sh_yml[names(sh_r)])
})
