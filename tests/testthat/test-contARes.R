test_that("contARes works in default form", {
  expect_equal(contARes(data = test.data,
                        params = c("BL_rx", "BW_rx", "BWL_rx", "SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                        InAResCol = "AR",
                        treatCol = "induced",
                        ctrl = "n"),
               test.contr.default)
}) # inititally passing

test_that("contARes works with low thresholds", {
  expect_equal(contARes(data = test.data,
                        params = c("BL_rx", "BW_rx", "BWL_rx", "SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                        InAResCol = "AR",
                        treatCol = "induced",
                        ctrl = "n",
                        th.change = 0.01,
                        th.sd = 0.01),
               test.contr.thchangedlow)
}) # inititally passing

test_that("contARes works with high thresholds", {
  expect_equal(contARes(data = test.data,
                        params = c("BL_rx", "BW_rx", "BWL_rx", "SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                        InAResCol = "AR",
                        treatCol = "induced",
                        ctrl = "n",
                        th.change = 0.5,
                        th.sd = 1),
               test.contr.thchangedhigh)
}) # inititally passing


# test.contr.thchangedlow <- contARes(data = test.data,
#                                     params = c("BL_rx", "BW_rx", "BWL_rx", "SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
#                                     InAResCol = "AR",
#                                     treatCol = "induced",
#                                     ctrl = "n",
#                                     th.change = 0.01,
#                                     th.sd = 0.01)
# usethis::use_data(test.contr.default, test.data, test.contr.thchangedlow, test.contr.thchangedhigh, internal = TRUE, overwrite = TRUE)
