######################################################################################
###                                                                                ###
###                New Hampshire SGP analyses for 2024-2025                        ###
###                                                                                ###
######################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/New_Hampshire_SGP.Rdata")
load("Data/New_Hampshire_Data_LONG_2024_2025.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("NH", "2024_2025")

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2024_2025/READING.R")
source("SGP_CONFIG/2024_2025/MATHEMATICS.R")

NH_CONFIG <- c(READING_2024_2025.config, MATHEMATICS_2024_2025.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   Run updateSGP analysis
#####

New_Hampshire_SGP <- updateSGP(
        what_sgp_object = New_Hampshire_SGP,
        with_sgp_data_LONG = New_Hampshire_Data_LONG_2024_2025,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = NH_CONFIG,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

###   Save results
save(New_Hampshire_SGP, file="Data/New_Hampshire_SGP.Rdata")
