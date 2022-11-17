
test_that("calculation of the index (AR) works", {
  expect_equal(InARes(data = test.data,
                      traits = c("BL_rx", "BW_rx", "BWL_rx", "SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      treatCol = "induced",
                      ctrl = "n")$index,
               test.data$AR)
}) # inititally passing

test_that("calculation of the plasticity index (PI) works", {
  expect_equal(InARes(data = test.data,
                      traits = c("BL_uw", "BW_uw", "BWL_uw", "SL_uw", "Forn_uw", "Furca_uw", "meansld_uw", "meanslv_uw", "SBAd_uw", "SBAv_uw"),
                      treatCol = "induced",
                      ctrl = "n",
                      as.defined = TRUE,
                      as.PI = TRUE)$index, 
               test.data$PI)
  
  expect_equal(InARes(data = test.data,
                      traits = c("BL_uw", "BW_uw", "BWL_uw", "SL_uw", "Forn_uw", "Furca_uw", "meansld_uw", "meanslv_uw", "SBAd_uw", "SBAv_uw"),
                      treatCol = "induced",
                      ctrl = "n",
                      as.PI = TRUE)$index, 
               test.data$PI)
}) # inititally passing

test_that("calculation of the index (AR_change_dmax) works with customized rexmax", {
  expect_equal(InARes(data = test.data,
                      traits = c("BL_rx", "BW_rx", "BWL_rx", "SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      rexmax.adapt = c(-0.6, 0.8, 0.7, -0.8, 0.6, 0.6, 0.6, 0.5, 0.7, 0.8),
                      treatCol = "induced",
                      ctrl = "n")$index, 
               test.data$AR_change_rexmax)
}) # inititally passing

test_that("calculation of the index (AR_just_traits.mal) works with only traits.mal", {
  expect_equal(InARes(data = test.data,
                      traits.mal = c("BL_rx", "BW_rx", "BWL_rx", "SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      treatCol = "induced",
                      ctrl = "n")$index, 
               test.data$AR_just_traits.mal)
}) # inititally passing

test_that("calculation of the index (AR_adaptAndmal) works with adaptive and maladaptive traits at once", {
  expect_equal(InARes(data = test.data,
                      traits = c("SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      traits.mal = c("BL_rx", "BW_rx", "BWL_rx"),
                      treatCol = "induced",
                      ctrl = "n")$index,
               test.data$AR_adaptAndmal)
}) # inititally passing

test_that("calculation of the index (AR_adaptAndmalasdefined) works with adaptive and maladaptive traits at once with as.defined = TRUE", {
  expect_equal(InARes(data = test.data,
                      traits = c("SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      traits.mal = c("BL_rx", "BW_rx", "BWL_rx"),
                      treatCol = "induced",
                      as.defined = TRUE,
                      ctrl = "n")$index,
               test.data$AR_adaptAndmalasdefined)
}) # inititally passing

test_that("calculation of the index (ARjustadaptiveasdefined) works with as.defined and only adaptive traits", {
  expect_equal(InARes(data = test.data,
                      traits = c("BL_rx", "BW_rx", "BWL_rx", "SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      treatCol = "induced",
                      as.defined = TRUE,
                      ctrl = "n")$index,
               test.data$ARjustadaptiveasdefined)
}) # inititally passing

test_that("calculation of the index (ARadaptivemaladrexmaxadaptive) works with rexmax values provided for adaptive but not for maladaptive", {
  expect_equal(InARes(data = test.data,
                      traits = c("SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      traits.mal = c("BL_rx", "BW_rx", "BWL_rx"),
                      rexmax.adapt = c(-0.6, 0.8, 0.7, -0.8, 0.6, 0.6, 0.6),
                      treatCol = "induced",
                      ctrl = "n")$index,
               test.data$ARadaptivemaladrexmaxadaptive)
}) # inititally passing


test_that("calculation of the index (ARadaptivemaladrexmaxmal) works with rexmax values provided for mal but not for adaptive", {
  expect_equal(InARes(data = test.data,
                      traits = c("SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      traits.mal = c("BL_rx", "BW_rx", "BWL_rx"),
                      rexmax.mal = c(-0.6, 0.8, 0.7),
                      treatCol = "induced",
                      ctrl = "n")$index,
               test.data$ARadaptivemaladrexmaxmal)
}) # inititally passing

test_that("calculation of the index (ARadaptivemaladrexmaxboth) works with rexmax values provided for both", {
  expect_equal(InARes(data = test.data,
                      traits = c("SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      traits.mal = c("BL_rx", "BW_rx", "BWL_rx"),
                      rexmax.adapt = c(-0.6, 0.8, 0.7, -0.8, 0.6, 0.6, 0.6),
                      rexmax.mal = c(-0.6, 0.8, 0.7),
                      treatCol = "induced",
                      ctrl = "n")$index,
               test.data$ARadaptivemaladrexmaxboth)
}) # inititally passing

test_that("calculation of the index (ARadaptivemaladrexmaxbothNAs) works with rexmax values provided for both with NAs", {
  expect_equal(InARes(data = test.data,
                      traits = c("SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      traits.mal = c("BL_rx", "BW_rx", "BWL_rx"),
                      rexmax.adapt = c(-0.6, 0.8, NA, -0.8, 0.6, 0.6, 0.6),
                      rexmax.mal = c(-0.6, 0.8, NA),
                      treatCol = "induced",
                      ctrl = "n")$index,
               test.data$ARadaptivemaladrexmaxbothNAs)
}) # inititally passing


test_that("calculation of the index (ARwithbothNAkeep) works with keep of NAs", {
  
  temp <- test.data
  temp[c(1:10, 100:110),"BL_rx"] <- NA
  temp[c(20:30, 200:210),"Forn_rx"] <- NA
  temp[c(20:30, 200:210),"meansld_rx"] <- NA
  
  expect_equal(InARes(data = temp,
                      traits = c("SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      traits.mal = c("BL_rx", "BW_rx", "BWL_rx"),
                      treatCol = "induced",
                      ctrl = "n",
                      na.action = "keep")$index,
               test.data$ARwithbothNAkeep)
}) # inititally passing

test_that("calculation of the index (ARwithbothNAinterpolate) works with interpolate of NAs", {
  
  temp <- test.data
  temp[c(1:10, 100:110),"BL_rx"] <- NA
  temp[c(20:30, 200:210),"Forn_rx"] <- NA
  temp[c(20:30, 200:210),"meansld_rx"] <- NA
  
  expect_equal(InARes(data = temp,
                      traits = c("SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      traits.mal = c("BL_rx", "BW_rx", "BWL_rx"),
                      treatCol = "induced",
                      ctrl = "n",
                      na.action = "interpolate")$index,
               test.data$ARwithbothNAinterpolate)
}) # inititally passing


test_that("calculation of the index (ARwithbothNAomit) works with omit of NAs", {
  
  temp <- test.data
  temp[c(1:10, 100:110),"BL_rx"] <- NA
  temp[c(20:30, 200:210),"Forn_rx"] <- NA
  temp[c(20:30, 200:210),"meansld_rx"] <- NA
  
  expect_equal(InARes(data = temp,
                      traits = c("SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
                      traits.mal = c("BL_rx", "BW_rx", "BWL_rx"),
                      treatCol = "induced",
                      ctrl = "n",
                      na.action = "omit")$index,
               test.data$ARwithbothNAomit)
}) # inititally passing

# test.data$ARwithbothNAomit <- InARes(data = temp,
#                                             traits = c("SL_rx", "Forn_rx", "Furca_rx", "meansld_rx", "meanslv_rx", "SBAd_rx", "SBAv_rx"),
#                                             traits.mal = c("BL_rx", "BW_rx", "BWL_rx"),
#                                             treatCol = "induced",
#                                             ctrl = "n",
#                                             na.action = "omit")$index
# usethis::use_data(test.contr, test.data, test.dmax, internal = TRUE, overwrite = TRUE)







