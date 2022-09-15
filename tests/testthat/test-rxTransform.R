

test_that("default rxTransform works", {
  expect_equal(
    rxTransform(data.InARes$BL, data.InARes$induced, ctrl = "n"), 
    test.data$BL_rx
    )
})

test_that("rxTransform for plasticity works", {
  expect_equal(
    rxTransform(data.InARes$BL, data.InARes$induced, ctrl = "n", usemc = TRUE), 
    test.data$BL_uw
  )
})
