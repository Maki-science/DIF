######## Trex() #################
#' Transformation to relative expression of traits
#'
#' @description
#' Part of the Index for Adaptive Responses (InARes).
#' Transforms trait values of a treatment (or similar data) in relation to a control (or similar data).
#' This results in transformed values that reflect the relative expression (therefore rex) of a trait of 
#' a treated organism in relation to a control organism. They are standardized and normalized.
#' The transformation is calculated as:
#' (value - mean of control values) / (max - min of the control and value treatments)
#' This transformation is the first step of calculating the Index for Adaptive Responses, followed by
#' the functions InARes() and (optionally) dContribution().
#'
#' @param x A vector with the trait values (observations) that should be transformed. Should have the same length as treat.
#' @param y A vector containing the treatment for each observation. Should have the same length as trait.
#' @param ctrl The name of the factor for your control group as to be found in treat. This is important for standardization.
#' @param usemc Can be either FALSE (default) or TRUE. In case of FALSE, the values are standardized by the span of 
#'     treatment and control (max-min)). In case of TRUE., mean control is used to standardize the values. In this case, 
#'     values will be standardized for the experiment. Therefore, values are completely independent of the experimental
#'     design and other factors. This increases the comparability with other studies, regarding the original values. 
#'     However, when using this for calculation of the Index for Adaptive Responses, the weighing (dmax) of the traits 
#'     will be TRUE. in each case. Therefore, no real weighing takes place. This might be desired, if the InARes framework
#'     is used as plasticity index.
#'
#' @return Returns a vector containing the transformed data.
#'
#' @usage 
#' Trex(x, y, ctrl = "control", usemc = FALSE)
#' 
#' @examples 
#' # load example data
#' library(InARes)
#' mydata <- data.InARes
#' 
#' # transform one trait for calculating the Index for Adaptive Responses in a next step
#' mydata$BL_rex <- Trex(x = mydata$BL,
#'                       y = mydata$induced,
#'                       ctrl = "n")
#' 
#' # transform a set of traits for calculating the Index for Adaptive Responses in a next step
#' params <- c("BL", "SL", "BW", "BWL", "Forn", "Furca", "SBAd", "SBAv", "meansld", "meanslv")
#' for(i in 1:length(params)){
#'   mydata[, paste(params[i], "_rex", sep = "")] <- Trex(x = mydata[,params[i]],
#'                                                        y = mydata$induced,
#'                                                        ctrl = "n")
#' }
#' 
#' # transform one trait to use it in a plasticity index
#' mydata$BL_uw <- Trex(x = mydata$BL,
#'                      y = mydata$induced,
#'                      ctrl = "n",
#'                      usemc = 1)
#' 
#' 
#' @seealso 
#' InARes(), calculates a weighted mean of all rex transformed trait values.
#' 
#' contARes(), can be used to estmate each traits' contribution to the Index of Adaptive Responses.
#' 
#' @references TODO: Link to the Publication
#' 
#' @export
#'
Trex <- function(x, y, ctrl = "control", usemc = FALSE){
  
  # calculate control values mean, max, min (used later several times)
  mean_control <- mean(x[which(y == ctrl)], na.rm = T)
  max_control <- max(x[which(y == ctrl)], na.rm = T)
  min_control <- min(x[which(y == ctrl)], na.rm = T)
  
  # check amount of treatments
  treatments <- unique(y)
  
  # create a vector for the transformed values
  tval <- vector(mode = "numeric", length = length(x))
  
  # iterate over treatments
  for (i in 1:length(treatments)){
    t_temp <- x[y == treatments[i]]
    
    # check whether there is a higher or lower value in the treatment compared to control
    # if true, set new max/min
    # used to standardize further below
    max <- max_control
    min <- min_control
    
    if(max(t_temp, na.rm = T) >= max_control){
      max <- max(t_temp, na.rm = T)
    }
    if(min(t_temp, na.rm = T) <= min_control){
      min <- min(t_temp, na.rm = T)
    }
    
    # if data should be standardized on the experiment
    if(usemc == TRUE){
      # get the value, with the maximum distance to control mean
      max <- max( abs( mean_control - x), na.rm = T ) + mean_control
    }
    
    # iterate over all lines of the treatment and calculate d
    for (j in 1:length(x)){
      if(y[j] == treatments[i]){ # only calculate for this line, when treatment is the current treatment
        # if the value is NA -> just write NA again (keep NA-value)
        if(is.na(x[j])){
          tval[j] <- NA
        }
        else{
          # if data should be standardized on the experiment using the control mean
          if(usemc == TRUE){
            tval[j] <- (x[j] - mean_control) / (max - mean_control)
          }
          else{ # if data should be transformed according to the span of control and treatment
            tval[j] <- (x[j] - mean_control) / (max - min)
          }
        }
      }
    } # end for(length x)
  } # end for(treatments)
  
  cat("transformend data (normalised and standardised to control).")
  # return vektor with calculated values
  return(tval)
}
