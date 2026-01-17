test_that("Loading LSTextras after LSTbook masks point_plot()", {
  # Ensure LSTbook is attached first
  if (!"package:LSTbook" %in% search()) {
    library(LSTbook)
  }

  # Attach LSTextras AFTER so it should mask point_plot
  if (!"package:LSTextras" %in% search()) {
    library(LSTextras)
  } else {
    # If already attached but not last, re-attach to move it to the top
    detach("package:LSTextras", unload = TRUE, character.only = TRUE)
    library(LSTextras)
  }

  where <- find("point_plot")
  expect_true(length(where) >= 1)
  expect_identical(where[[1]], "package:LSTextras")

  # Now call without namespace qualification
  p <- mpg |>
    point_plot(cty ~ 1, annot = "model", interval = "none")

  expect_s3_class(p, "ggplot")
})
