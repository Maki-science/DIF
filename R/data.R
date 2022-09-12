#' Results of predation trials with Daphnia magna and Triops cancriformis
#'
#' Contains all data of a huge predation experiment with Daphnia magna as prey and Triops cancriformis as predator.
#' Part of the InARes package. For detailed information how the experiment has been performed, have a look into the corresponding study.
#'
#' @format A data frame with 704 rows and 69 variables:
#' \describe{
#'   \item{eventID}{Faktor - ID of predation event (running number). One prey animal can be attacked several times.}
#'   \item{animalID}{Faktor - Number of the prey animal in the respective predation trial. 157 animals have been evaluated. A few have been dropped because the video was bad.}
#'   \item{clone}{Faktor - 'Name' of Daphnia clone. Three clones have been used here.}
#'   \item{induced}{Faktor - Whether animal has been induced by Triops before the trial or not. Either n (no) or y (yes).}
#'   \item{Ausw}{Faktor - Abreviation of person, who evaluated the video}
#'   \item{TriopsID}{Faktor - ID of the predator individual. 55 predators have been used. Not all were hunting -> some numbers are missing}
#'   \item{D_T_video}{Faktor - Video of Daphnia # and Triops #}
#'   \item{TriopsBL}{numeric - Body length of Triops}
#'   \item{n_eaten}{numeric - Number of already eaten prey before this trial. Used as proxy for predator saturation.}
#'   \item{expday}{integer - Day of the experiment where this trial was performed.}
#'   \item{time}{Faktor - Time where the trial started.}
#'   \item{success}{Faktor - Whether predator was successful in this trial. No: prey survived; yes: prey was eaten; (yes): prey was killed but not completely eaten.}
#'   \item{esc}{Faktor - Whether the prey escaped or not.}
#'   \item{event_success}{Faktor - Whether the single event was successful or not.}
#'   \item{BL}{numeric - Body length of the daphnid.}
#'   \item{SL}{numeric - Tail spine length of the daphnid.}
#'   \item{BW}{numeric - Dorso-ventral body width of the daphnid.}
#'   \item{BWL}{numeric - Lateral body width of the daphnid.}
#'   \item{Forn}{numeric - Distance between the two fornices of the daphnid.}
#'   \item{Furca}{numeric - Length of the furca (postabdomial claw) of the daphnid.}
#'   \item{SBAd}{numeric - Length of the dorsal spinule bearing area of the daphnid.}
#'   \item{SBAv}{numeric - Length of the ventral spinule bearing area of the daphnid.}
#'   \item{sld1}{numeric - Length of 1. dorsal spinules of the daphnid.}
#'   \item{sld2}{numeric - Length of 2. dorsal spinules of the daphnid.}
#'   \item{sld3}{numeric - Length of 3. dorsal spinules of the daphnid.}
#'   \item{sld4}{numeric - Length of 4. dorsal spinules of the daphnid.}
#'   \item{sld5}{numeric - Length of 5. dorsal spinules of the daphnid.}
#'   \item{slv1}{numeric - Length of 1. ventral spinules of the daphnid.}
#'   \item{slv2}{numeric - Length of 2. ventral spinules of the daphnid.}
#'   \item{slv3}{numeric - Length of 3. ventral spinules of the daphnid.}
#'   \item{slv4}{numeric - Length of 4. ventral spinules of the daphnid.}
#'   \item{slv5}{numeric - Length of 5. ventral spinules of the daphnid.}
#'   \item{meansld}{numeric - Mean length of the 5 dorsal spinules.}
#'   \item{meanslv}{numeric - Mean length of the 5 ventral spinules.}
#'   \item{successbin}{numeric - Binary value whether trial was successful (1) or not (0).}
#'   \item{event_success_bin}{numeric - Binary value whether event was successful (1) or not (0).}
#'   \item{event_esc_bin}{numeric - Binary value whether event ended in escape (1) or not (0).}
#'   \item{trials_run}{numeric - Number of performed attacks during current trial. Used as proxy for potential learning capability.}
#'   \item{trials_ovall}{numeric - Number of performed attacks across all trials with this Triops. Used as proxy for potential learning capability.}
#' }
#' @source \url{http://www.diamondse.info/}
"data.InARes"


