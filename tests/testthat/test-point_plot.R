test_that("LSTextras::point_plot handles y ~ 1 in model/none mode", {
  p <- mpg |>
    LSTextras::point_plot(cty ~ 1, annot = "model", interval = "none")

  expect_s3_class(p, "ggplot")
})

test_that("LSTextras::point_plot handles y ~ numeric in model/none mode", {
  p <- mpg |>
    LSTextras::point_plot(cty ~ displ, annot = "model", interval = "none")

  expect_s3_class(p, "ggplot")
})

test_that("LSTextras::point_plot handles y ~ numeric + categorical in model/none mode", {
  p <- mpg |>
    LSTextras::point_plot(cty ~ displ + drv, annot = "model", interval = "none")

  expect_s3_class(p, "ggplot")
})

test_that("LSTextras::point_plot delegates when not in model/none mode", {
  # This is *your* contract: delegation should return a ggplot and not error.
  # We avoid testing LSTbook-specific quirks.
  p <- mpg |>
    LSTextras::point_plot(cty ~ displ, annot = "model", interval = "confidence")

  expect_s3_class(p, "ggplot")
})
