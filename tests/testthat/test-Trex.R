

test_that("default Trex works", {
  # tbc <- Trex(data.InARes$BL, data.InARes$induced, ctrl = "n")
  # for(i in 1:length(tbc)){
  #   expect_e
  # }
  expect_equal(
    Trex(data.InARes$BL, data.InARes$induced, ctrl = "n"), 
    test.data$BL_rx
    )
})

test_that("Trex for plasticity works", {
  expect_equal(
    Trex(data.InARes$BL, data.InARes$induced, ctrl = "n", usemc = TRUE), 
    test.data$BL_uw
  )
})
