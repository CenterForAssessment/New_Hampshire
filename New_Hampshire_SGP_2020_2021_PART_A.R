############################################################################################
###                                                                                      ###
###                New Hampshire COVID Skip-year SGP analyses for 2020-2021              ###
###                                                                                      ###
############################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/New_Hampshire_SGP.Rdata")
load("Data/New_Hampshire_Data_LONG_2020_2021.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("NH", "2020_2021")

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2020_2021/PART_A/READING.R")
source("SGP_CONFIG/2020_2021/PART_A/MATHEMATICS.R")

NH_CONFIG <- c(READING_2020_2021.config, MATHEMATICS_2020_2021.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   Run updateSGP analysis
#####

New_Hampshire_SGP <- updateSGP(
        what_sgp_object = New_Hampshire_SGP,
        with_sgp_data_LONG = New_Hampshire_Data_LONG_2020_2021,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = NH_CONFIG,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

###   Save results
#save(New_Hampshire_SGP, file="New_Hampshire_SGP.Rdata"))
