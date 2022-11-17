######## contARes() ###############
#' Calculating the trait contribution to adaptive responses
#' 
#' @description
#' This function is part of the InARes framework.
#' Estimating the contribution of single traits to the Index for Adaptive Responses InARes.
#' We can calculate the individual proportional contribution of each parameter, 
#' for induced animals, but also for control separately, and then calculate a ratio
#' between both, to see which trait has changed its contribution when exposed 
#' to predators.
#' Instead of the mean, we use the median. Using the mean often provided strange results
#' as there were some few but extreme low values in the treatment, while there were 
#' some few but extreme high values in control as well. As most of the animals 
#' performed as expected, we tried to assess this problem via using the median 
#' instead of the mean. Apparently, this resulted in more reasonable and appropriate
#' results and using the median makes this evaluation more robust to outliers.
#' Values are provided for single treatments as well as for the change. However, these
#' values do not exactly reflect the numeric contribution to the InARes. But they can be 
#' ordered ordinary by their absolute value for qualitative importance assessment.
#' An automated interpretation is also provided.
#' However, it is just a rough idea, which traits might be interesting to have a 
#' closer look at. It should not be understood as a quantitative approach, but 
#' rather a qualitative estimation of the importance of a trait. Furthermore, it 
#' is worth to notice that interactions cannot be covered (separately) with this approach. In 
#' case of low or intermediate values of proportional contribution, it might be 
#' that some parameters interact with each other, which may leads to latent 
#' contribution to the adaptive response. Therefore, these values can be assessed more 
#' reliably concerning single term effects, but not concerning interactions. 
#' Therefore, again, this evaluation is just a rough idea and should be used 
#' with caution (maybe as a tool for experimental design to investigate single 
#' traits in more detail).
#' 
#'
#' @param data A data.frame to be used.
#' @param params Vector of column names of parameters or traits that are rex transformed
#' and were all incorporated in InARes. Please make sure, that all traits are included here, that were
#' also included in InARes and vice versa. Otherwise the results are not meaningful. 
#' @param InAResCol Column name where the values of the InARes are stored.
#' @param treatCol Column name where the treatments are mentioned. So far, we recommend to use only control and one treatment.
#' In case you have more treatments, we would recommend to subset accordingly and run this function steptwise. However, 
#' it should be able to deal with several treatments (but is not tested exhaustively, so far).
#' @param ctrl How the control is named in treatCol.
#' @param th.change the threshold value at which a change in contribution might indicate an important trait (defaults to 0.05)
#' @param th.sd the sd of the threshold at which it indicates an indefinite trait, and therefore, a potential interaction with other traits
#'
#' @return Returns a list containing the contribution of each trait. For each
#'         treatment a separate data frame is created and stored within the list.
#'         Furthermore, an automated, qualitative interpretation is provided.
#'         
#' @usage contARes(data, 
#'                 params, 
#'                 InAResCol, 
#'                 treatCol = "treatment", 
#'                 ctrl = "control", 
#'                 th.change = 0.05, 
#'                 th.sd = 0.5)
#'         
#' @examples
#' # load example data
#' library(InARes)
#' mydata <- data.InARes
#' 
#' # first transform trait values with Trex
#' params <- c("BL", "SL", "BW", "BWL", "Forn", "Furca", "SBAd", "SBAv", "meansld", "meanslv")
#' for(i in 1:length(params)){
#'   mydata[, paste(params[i], "_rex", sep = "")] <- Trex(x = mydata[,params[i]],
#'                                                        y = mydata$induced,
#'                                                        ctrl = "n")
#' }
#' 
#' # calculate the InARes in its default form (without a priori knowledge)
#' results <- InARes(data = mydata,
#'                   traits = c("BL_rex", "SL_rex", "BW_rex", "BWL_rex", "Forn_rex", 
#'                              "Furca_rex", "SBAd_rex", "SBAv_rex", "meansld_rex", "meanslv_rex"),
#'                   treatCol = "induced",
#'                   ctrl = "n")
#' # results contains two parts: index and rexmax                 
#' # InARes contains a vector with the calculated values
#' mydata$InARes <- results$index
#' 
#' # calculate each trait's contribution to the index
#' contARes(data = mydata, 
#'          params = c("BL_rex", "SL_rex", "BW_rex", "BWL_rex", "Forn_rex", 
#'                     "Furca_rex", "SBAd_rex", "SBAv_rex", "meansld_rex", "meanslv_rex"),
#'          InAResCol = "InARes",
#'          treatCol = "induced",
#'          ctrl = "n")
#' # results are provided numerically and as plain text
#' 
#' @seealso 
#' InARes(), calculates a weighted mean of all rex transformed trait values.
#' 
#' Trex(), transforms trait values to a relative expression value.
#' 
#' @references TODO: Link to the Publication         
#'
#' @export
#' @importFrom stats sd
#'
contARes <- function(data, params, InAResCol, treatCol = "treatment", ctrl = "control", th.change = 0.05, th.sd = 0.5){
  # formerly it was the Defence Index, thus some terms in this code are still referring to this ;)
  # We cannot directly take dx, but the complete term of dx (which is: d/max(|d|) / 10 ) and calculate its proportional contribution
  
  # contribution of each parameter has to be calculated on the individual level
  # then we can take the mean
  obj <- list()
  data[,treatCol] <- as.factor(data[,treatCol])
  
  # iterate over the amount of treatments other than control. For each treatment a new
  # data frame will be created and stored into a list object.
  treats <- levels(data[,treatCol])[which(levels(data[,treatCol]) != ctrl)]
  
  for(n in 1:length(treats)){
    
    dcontr <- data.frame(trait = params)
    for(i in 1:length(params)){
      
      tempContr <- c()
      for(j in 1:nrow(data)){
        
        tempContr <- c(tempContr, 
                       (data[, params[i]][j] / max(abs(data[, params[i]]), na.rm = T) / length(params) / data[,InAResCol][j])
        )
      }
      
      # get the median and sd of the contribution of predator treatment and control separately
      # for each treatment other than control a separate iteration will run and a separate
      # data frame is stored into a list
      dcontr$meancontrC[i] <- median(tempContr[which(data[treatCol] == ctrl)], na.rm = T)
      dcontr$contrSDC[i] <- sd(tempContr[which(data[treatCol] == ctrl)], na.rm = T)
      dcontr$meancontrT[i] <- median(tempContr[which(data[treatCol] == treats[n])], na.rm = T)
      dcontr$contrSDT[i] <- sd(tempContr[which(data[treatCol] == treats[n])], na.rm = T)
      
      # calculate the change in contribution = mean contribution treatment - mean contribution C *
      # | median(D(control)) / median(D(treatment)) |
      # the factor in the end is to correct the high values in control, due to a low D value
      # therefore, we use the relative difference between D of control and D of the treatment to correct
      dcontr$contributionChange[i] <- dcontr$meancontrT[i] - dcontr$meancontrC[i] * abs(median(data[,InAResCol][which(data[,treatCol] == ctrl)], na.rm = T) / median(data[,InAResCol][which(data[,treatCol] != ctrl)], na.rm = T))
      
    } # end for i
    
    obj[[paste(treats[n], "values", sep=".")]] <- dcontr
    
    # creating qualitative summary
    for(o in 1:nrow(dcontr)){
      
      if(
        dcontr$contributionChange[o] >= th.change && 
        abs(dcontr$contrSDT[o] / dcontr$meancontrT[o]) >= th.sd
      ){
        obj[[paste(treats[n], "summary", dcontr$trait[o], sep=".")]] <- "An increase in this trait seem to be adaptive. However, there might be interactions with other traits."
      }
      else if(
        dcontr$contributionChange[o] >= th.change && 
        abs(dcontr$contrSDT[o] / dcontr$meancontrT[o]) <= th.sd
      ){
        obj[[paste(treats[n], "summary", dcontr$trait[o], sep=".")]] <- "An increase in this trait seem to be adaptive."
      }
      else if(
        dcontr$contributionChange[o] <= -th.change && 
        abs(dcontr$contrSDT[o] / dcontr$meancontrT[o]) >= th.sd
      ){
        obj[[paste(treats[n], "summary", dcontr$trait[o], sep=".")]] <- "An increase in this trait seem to be maladaptative. However, there might be interactions with other traits."
      }
      else if(
        dcontr$contributionChange[o] <= -th.change && 
        abs(dcontr$contrSDT[o] / dcontr$meancontrT[o]) <= th.sd
      ){
        obj[[paste(treats[n], "summary", dcontr$trait[o], sep=".")]] <- "An increase in this trait seem to be maladaptative."
      }
      else if(
        abs(dcontr$contrSDT[o] / dcontr$meancontrT[o]) >= th.sd
      ){
        obj[[paste(treats[n], "summary", dcontr$trait[o], sep=".")]] <- "This trait is indefinite in its change in contribution. There might be an interaction with other traits."
      }
      else{
        obj[[paste(treats[n], "summary", dcontr$trait[o], sep=".")]] <- "There seem no (mal-)adaptive function in this trait."
      }
    }
    
  } # end for n treats
  return(obj)
}