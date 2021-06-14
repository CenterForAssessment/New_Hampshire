###########################################################################################
###                                                                                     ###
###   New_Hampshire Learning Loss Analyses -- 2018-2019 Baseline Growth Percentiles     ###
###                                                                                     ###
###########################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data and remove years that will not be used.
load("Data/New_Hampshire_SGP_LONG_Data.Rdata")

###   Add single-cohort baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("NH", "2020_2021")

### NULL out assessment transition in 2019 (since already dealth with)
SGPstateData[["NH"]][["Assessment_Program_Information"]][["Assessment_Transition"]] <- NULL
SGPstateData[["NH"]][["Assessment_Program_Information"]][["Scale_Change"]] <- NULL

###   Read in BASELINE percentiles configuration scripts and combine
source("SGP_CONFIG/2018_2019/BASELINE/Percentiles/READING.R")
source("SGP_CONFIG/2018_2019/BASELINE/Percentiles/MATHEMATICS.R")

NH_2018_2019_Baseline_Config <- c(
	READING_2018_2019.config,
	MATHEMATICS_2018_2019.config
)

#####
###   Run BASELINE SGP analysis - create new New_Hampshire_SGP object with historical data
#####

###   Temporarily set names of prior scores from sequential/cohort analyses
data.table::setnames(New_Hampshire_SGP_LONG_Data,
	c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"),
	c("SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"))

SGPstateData[["NH"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

New_Hampshire_SGP <- abcSGP(
        sgp_object = New_Hampshire_SGP_LONG_Data,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = NH_2018_2019_Baseline_Config,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,  #  Skip year SGPs for 2021 comparisons
        sgp.projections.baseline = FALSE, #  Calculated in next step
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
					BACKEND = "PARALLEL",
					WORKERS=list(BASELINE_PERCENTILES=8))
)

###   Re-set and rename prior scores (one set for sequential/cohort, another for skip-year/baseline)
data.table::setnames(New_Hampshire_SGP@Data,
  c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"),
  c("SCALE_SCORE_PRIOR_BASELINE", "SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"))

###   Save results
save(New_Hampshire_SGP, file="Data/New_Hampshire_SGP.Rdata")
