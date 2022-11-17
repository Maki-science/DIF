######## InARes() ###############
#' Calculation of the Index for Adaptive Responses
#' 
#' @description
#' Calculates the Index for Adaptive Responses from several rex transformed traits:
#' if as.defined = TRUE: InARes = sum((-1) * rex(x) / max( |rex|(all treatments) )) / number of parameter
#' or
#' if as.defined = FALSE (default): InARes = sum((-1) * rex(x) / ( max( |rex|(all treatments) )) * median(treatment) / |median(treatment)| ) / number of parameter
#' The (-1) is only necessary, if we believe that the increase of one trait is maladaptive. 
#' rexmax will be 1 when usemc = 1 was selected in rex transformation.
#' At the current state, everything that is not control is considered as one treatment. If there are several 
#' treatments in the data set, we recommend to subset the data accordingly.
#'
#' @param data A data.frame to be used, which contains the rex transformed values of all traits that should be included.
#' @param traits The names of the columns that contains the rex transformed values 
#'        of the traits to be incorporated where the adaptiveness is unknown or an increase is considered an adaptation.
#' @param traits.mal The names of the columns that contains the rex transformed values 
#'        of the traits to be incorporated where an increase is considered as a maladaptation.
#' @param as.defined if TRUE the sign of rexmax will be positive for traits and negative
#'        for traits.mal when used as weighing parameter. If set to FALSE (default) the sign might be 
#'        positive or negative for traits (since their adaptiveness is considered unknown), but always negative for traits.mal.
#'        This parameter is thought for cases where the functionality of the traits are unclear and the Index will be evaluated using dContribution().
#' @param treatCol column name of the treatments (defaults to 'treatment'). At the current state, everything that is not control is
#'        considered as one treatment. If there are several treatments in the data set, we recommend to subset the data accordingly.
#' @param ctrl the name of the control treatment as set in treatCol (defaults to 'control'). 
#' @param rexmax.adapt a vector containing values for rexmax for each trait provided in traits. 
#'        It can be specified, if one wants to calculate values comparable with other experiments or the literature.
#'        rexmax has to be set for all traits or an NA should be included. Order should be similar to as set
#'        in traits. Each value must be between -1 and 1. Defaults to FALSE (not considered unless provided).
#' @param rexmax.mal a vector containing values for rexmax for each trait provided in traits.mal 
#'        (works similar as for rexmax.adapt). Order should be similar to as set in traits.
#'        Each value must be between -1 and 1. Defaults to FALSE (not considered unless provided).
#' @param na.action Defines the way, how NAs are treated (row wise). Can be either "omit", "keep", or "interpolate". 
#'        Defaults to "keep".
#'        When "keep" the InARes value will be NA, if one or more of the trait values contain NA. Usually 
#'        recommended for unbiased estimates! 
#'        In case of "interpolate", it will use the median value of the trait of the current treatment. However, 
#'        this might bias your estimates in some way, if the median of the treatment in this trait is not ´fitting adequately, 
#'        but it helps if a lot of NAs occur in fields of different traits. We recommend this way, as a conservative
#'        way to prevent NAs. However, if there are a lot of gaps in your trait data, it may bias the outcome strongly.
#'        When "omit" it calculates the InARes with traits where an NA occurs. In this case, NA-traits are 
#'        ignored and number of traits reduced by the number of traits with NA (for each individual). This, however, 
#'        may bias the outcome or the later estimation of each traits' contribution. The values may be misleading. 
#'        This way is not recommended and should only be used if you are certain about what you do!
#' @param as.PI can be set TRUE if the aim is to use this function for calculating an overall plasticity index. 
#'        In this case, all traits should be transformed with Trex(..., usemc = 1). Additionally, all traits
#'        should be provided via traits (not traits.mal) and as.defined should be set TRUE. Now you will receive
#'        values that are measures of the mean deviation over all traits from the control mean.
#'
#' @return Returns a list containing the transformed data and additional information like rexmax.
#'
#' @export
#' @importFrom stats median
#'
InARes <- function(data, traits = FALSE, traits.mal = FALSE, treatCol = "treatment", ctrl = "control", as.defined = FALSE, rexmax.adapt = FALSE, rexmax.mal = FALSE, na.action = "keep", as.PI = FALSE){
  
  # check whether function should be used to calculate a plasticity index. 
  # if yes, traits.mal and both rexmax shouldn't be set and as.defined should be TRUE
  if(as.PI == TRUE){
    if(traits.mal[1] != FALSE){
      stop("If you want to calculate a plasticity index, you should not include adaptive and maladaptive traits.
 Put all traits that should be included into traits, or set as.PI = FALSE (in case you want the InARes to be calculated).")
    }
    if(rexmax.adapt[1] != FALSE || rexmax.mal[1] != FALSE){
      stop("You set some rexmax values. In case you want to calculate a plasticity index you should not provide rexmax values (they are used for weighing), 
 or set as.PI = FALSE if you don't want to calculate a plasticity index.")
    }
    if(as.defined != TRUE){
      as.defined <- TRUE
      cat("Warning: It is expected that you want to calculate a plasticity index since you set as.PI = TRUE.
 Therefore, as.defined was set automatically to TRUE.")
    }
  }
  
  # check whether the vectors of rexmax and traits are equally long if they are set.
  if(traits[1] != FALSE && rexmax.adapt[1] != FALSE){
    if(length(traits) != length(rexmax.adapt)){
      stop("Length of traits is unequal to length rexmax.adapt. Please recheck your input.")
    }
  }
  if(traits.mal[1] != FALSE && rexmax.mal[1] != FALSE){
    if(length(traits.mal) != length(rexmax.mal)){
      stop("Length of traits.mal is unequal to length rexmax.mal. Please recheck your input.")
    }
  }
  
  
  # all parameters
  suppressWarnings(
    if(traits.mal[1] != FALSE && traits[1] != FALSE){
      params <- c(traits, traits.mal)
    }
    else if(traits[1] == FALSE && traits.mal[1] != FALSE){
      params <- c(traits.mal)
    }
    else if(traits[1] != FALSE && traits.mal[1] == FALSE){
      params <- traits
    }
    else{
      stop("You did not select any trait.")
    }
  )
  
  # object to store results
  obj <- list()
  
  # prepare the df with rexmax values
  rexmaxVector <- data.frame(trait = params, rexmax = 0)
  
  D <- c() # D is the index (in former times it was Defence Index)
  for(i in 1:nrow(data)){
    
    # sum up all defensive traits and divide by the respective n
    singleDs_adapt <- c()
    
    if(as.defined == TRUE){ # if as.defined == TRUE use the sign as defined (positive for traits,
      # and negative for traits.mal)
      suppressWarnings(
      if(traits[1] != FALSE){
        for(j in 1:length(traits)){
          # use rexmax as defined (adaptive or maladaptive) - a description of rexmax is given further below
          if(rexmax.adapt[1] != FALSE && is.na(rexmax.adapt[j]) == FALSE){
            #if rexmax are set (e.g. from literature), insert into this df
            rexmax <- rexmax.adapt[j]
          }
          else{
            rexmax <- max( abs(data[,traits[j]]), na.rm = T )
          }
          # write rexmax into rexmaxVector for later reporting
          rexmaxVector$rexmax[which(rexmaxVector$trait == traits[j])] <- rexmax
          
          # if trait value is NA keep NA thus far
          if(is.na(data[,traits[j]][i]) && na.action != "interpolate"){
            singleDs_adapt[j] <- NA
          }
          else if(is.na(data[,traits[j]][i]) && na.action == "interpolate"){ # use median of the non-NA values to fill the gap
            picor <- 1 # correction factor if a plasticity index should be calculated
            intpolVal <- median(data[,traits[j]][which( data[,treatCol] == data[,treatCol][i] )], na.rm = T ) # interpolated value
            
            if(as.PI == TRUE){
              picor <- intpolVal/abs(intpolVal)
            }
            
            singleDs_adapt[j] <- ( intpolVal * picor) / rexmax
          }
          else{
            # calculate the weighted D for the current trait (d / rexmax)
            picor <- 1 # correction factor if a plasticity index should be calculated
            
            if(as.PI == TRUE){
              picor <- data[,traits[j]][i]/abs(data[,traits[j]][i])
            }
            
            singleDs_adapt[j] <- (data[,traits[j]][i] * picor) / rexmax
          }
        } # end for j
      } # end if traits != FALSE
      ) # end supressWarnings
      
      singleDs_mal <- c()
      suppressWarnings(
        if(traits.mal[1] != FALSE){
          for(j in 1:length(traits.mal)){
            if(rexmax.mal[1] != FALSE && is.na(rexmax.mal[j]) == FALSE){
              rexmax <- rexmax.mal[j]
            }
            else{
              rexmax <- max( abs(data[,traits.mal[j]]), na.rm = T ) * -1
            }
            # write rexmax into rexmaxVector for later reporting
            rexmaxVector$rexmax[which(rexmaxVector$trait == traits.mal[j])] <- rexmax
            
            # if trait value is NA keep NA thus far
            if(is.na(data[,traits.mal[j]][i]) && na.action != "interpolate"){
              singleDs_mal[j] <- NA
            }
            else if(is.na(data[,traits.mal[j]][i]) && na.action == "interpolate"){ # use median of the non-NA values to fill the gap
              singleDs_mal[j] <- median(data[,traits.mal[j]][which( data[,treatCol] == data[,treatCol][i] )], na.rm = T ) / rexmax
            }
            else{
              # in case of maladaptations, an increase in this trait is negative. Thus, this term is
              # multiplied with -1 (is done further below).
              singleDs_mal[j] <- (data[,traits.mal[j]][i] / rexmax ) 
            }
          } # end for j
        } # end if traits.mal != FALSE
      ) # end supressWarnings
    } # end if as.defined == TRUE
    else{ # if as.defined === FALSE, the sign of traits can be negative or positive, depending
      # on whether the median of the treatment is negative or positive
      # meaning, that if the treatments median is higher than control, the trait is counted as adaptive,
      # while if it is lower compared to control, it is counted as maladaptive
      # rexmax is the most pronounced deviation from control mean
      # usually, if adaptive, the most pronounced deviation should be exhibited in the treatment
      # if this is not the case, the contribution of this trait to D will be diminished, which is
      # intended. It implies, that traits, that are exhibited strongly negative (considering d) in some cases or
      # have a very high variance in its expression are supposed to be less important.
      suppressWarnings(
      if(traits[1] != FALSE){
        for(j in 1:length(traits)){
          
          # in this case we select rexmax as before, but we will keep the sign (-/+) of the treatments median
          if(rexmax.adapt[1] != FALSE && is.na(rexmax.adapt[j]) == FALSE){
            rexmax <- rexmax.adapt[j]
          }
          else{
            rexmax <- max( abs(data[,traits[j]]), na.rm = T ) * 
              ( median(data[,traits[j]][which( data[,treatCol] != ctrl )], na.rm = T) /
                  abs( median(data[,traits[j]][which( data[,treatCol] != ctrl )], na.rm = T ) ) 
              )
          }
          
          # write rexmax into rexmaxVector for later reporting
          rexmaxVector$rexmax[which(rexmaxVector$trait == traits[j])] <- rexmax
          
          # if trait value is NA keep NA thus far
          if(is.na(data[,traits[j]][i]) && na.action != "interpolate"){
            singleDs_adapt[j] <- NA
          }
          else if(is.na(data[,traits[j]][i]) && na.action == "interpolate"){ # use median of the non-NA values to fill the gap
            singleDs_adapt[j] <- median(data[,traits[j]][which( data[,treatCol] == data[,treatCol][i] )], na.rm = T ) / rexmax
          }
          else{
            singleDs_adapt[j] <- data[,traits[j]][i] / rexmax
          }
        } # end for j
      } # end if traits != FALSE
      ) # end supressWarnings
      
      singleDs_mal <- c()
      suppressWarnings(
        if(traits.mal[1] != FALSE){
          for(j in 1:length(traits.mal)){
            if(rexmax.mal[1] != FALSE && is.na(rexmax.mal[j]) == FALSE){
              rexmax <- rexmax.mal[j]
            }
            else{
              rexmax <- max( abs(data[,traits.mal[j]]), na.rm = T ) * -1
            }
            # write rexmax into rexmaxVector for later reporting
            rexmaxVector$rexmax[which(rexmaxVector$trait == traits.mal[j])] <- rexmax
            
            # if trait value is NA keep NA thus far
            if(is.na(data[,traits.mal[j]][i]) && na.action != "interpolate"){
              singleDs_mal[j] <- NA
            }
            else if(is.na(data[,traits.mal[j]][i]) && na.action == "interpolate"){ # use median of the non-NA values to fill the gap
              singleDs_mal[j] <- median(data[,traits.mal[j]][which( data[,treatCol] == data[,treatCol][i] )], na.rm = T ) / rexmax
            }
            else{
              # in case of maladaptations, an increase in this trait is negative. Thus, this term is
              # multiplied with -1 (this is done further below).
              singleDs_mal[j] <- (data[,traits.mal[j]][i] / rexmax )
            }
          }
        }
      )
    }
    
    suppressWarnings(
      # check how to deal with NAs (read head for detail)
      # ignore NAs
      if(na.action == "omit"){
        if(traits.mal[1] != FALSE){
          nNAs <- sum(is.na(singleDs_adapt), is.na(singleDs_mal)) # if there were NA in one trait of the row, still calculate but reduce the number of traits
          D[i] <- sum(singleDs_adapt, singleDs_mal, na.rm = T) / ( length(traits) + length(traits.mal) - nNAs)
        }
        else{
          nNAs <- sum(is.na(singleDs_adapt))
          D[i] <- sum(singleDs_adapt, na.rm = T) / ( length(traits) - nNAs )
        }
      }
      
      # keep NAs -> DI will be NA
      # the interpolation takes place, above when singleDs are calculated
      else if(na.action == "keep"|| na.action == "interpolate"){
        if(traits.mal[1] != FALSE){
          nNAs <- sum(is.na(singleDs_adapt), is.na(singleDs_mal)) # if there were NA in one trait of the row, still calculate but reduce the number of traits
          if(nNAs == 0){
            D[i] <- sum(singleDs_adapt, singleDs_mal, na.rm = T) / ( length(traits) + length(traits.mal) )
          }
          else{
            D[i] <- NA
          }
        }
        else{
          nNAs <- sum(is.na(singleDs_adapt))
          if(nNAs == 0){
            D[i] <- sum(singleDs_adapt, na.rm = T) / ( length(traits) )
          }
          else{
            D[i] <- NA
          }
        }
      }
    )
    
  }# end for nrow(data)
  
  obj$index <- D
  obj$rexmax <- rexmaxVector
  
  
  return(obj)
}
