#####################################################################################
###                                                                               ###
###           SGP LAGGED projections for skip year SGP analyses for 2020-2021     ###
###                                                                               ###
#####################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/New_Hampshire_SGP.Rdata")

###   Load configurations
source("SGP_CONFIG/2020_2021/PART_C/READING.R")
source("SGP_CONFIG/2020_2021/PART_C/MATHEMATICS.R")

NH_CONFIG <- c(READING_2020_2021.config, MATHEMATICS_2020_2021.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

###   Add Baseline matrices to SGPstateData and update SGPstateData
SGPstateData <- addBaselineMatrices("NH", "2020_2021")
SGPstateData[["NH"]][["Growth"]][["System_Type"]] <- "Baseline Referenced"

#  Establish required meta-data for LAGGED projection sequences
SGPstateData[["NH"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    READING_GRADE_3=c("3", "4", "5", "6", "7", "8"),
    READING_GRADE_4=c("3", "4", "5", "6", "7", "8"),
    READING_GRADE_5=c("3", "5", "6", "7", "8"),
    READING_GRADE_6=c("3", "4", "6", "7", "8"),
    READING_GRADE_7=c("3", "4", "5", "7", "8"),
    READING_GRADE_8=c("3", "4", "5", "6", "8"),
    MATHEMATICS_GRADE_3=c("3", "4", "5", "6", "7", "8"),
    MATHEMATICS_GRADE_4=c("3", "4", "5", "6", "7", "8"),
    MATHEMATICS_GRADE_5=c("3", "5", "6", "7", "8"),
    MATHEMATICS_GRADE_6=c("3", "4", "6", "7", "8"),
    MATHEMATICS_GRADE_7=c("3", "4", "5", "7", "8"),
    MATHEMATICS_GRADE_8=c("3", "4", "5", "6", "8"))
SGPstateData[["NH"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    READING_GRADE_3=rep("READING", 6),
    READING_GRADE_4=rep("READING", 6),
    READING_GRADE_5=rep("READING", 5),
    READING_GRADE_6=rep("READING", 5),
    READING_GRADE_7=rep("READING", 5),
    READING_GRADE_8=rep("READING", 5),
    MATHEMATICS_GRADE_3=rep("MATHEMATICS", 6),
    MATHEMATICS_GRADE_4=rep("MATHEMATICS", 6),
    MATHEMATICS_GRADE_5=rep("MATHEMATICS", 5),
    MATHEMATICS_GRADE_6=rep("MATHEMATICS", 5),
    MATHEMATICS_GRADE_7=rep("MATHEMATICS", 5),
    MATHEMATICS_GRADE_8=rep("MATHEMATICS", 5))
SGPstateData[["NH"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    READING_GRADE_3=3,
    READING_GRADE_4=3,
    READING_GRADE_5=3,
    READING_GRADE_6=3,
    READING_GRADE_7=3,
    READING_GRADE_8=3,
    MATHEMATICS_GRADE_3=3,
    MATHEMATICS_GRADE_4=3,
    MATHEMATICS_GRADE_5=3,
    MATHEMATICS_GRADE_6=3,
    MATHEMATICS_GRADE_7=3,
    MATHEMATICS_GRADE_8=3)


### Run analysis

New_Hampshire_SGP <- abcSGP(
        New_Hampshire_SGP,
        steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config=NH_CONFIG,
        sgp.percentiles=FALSE,
        sgp.projections=FALSE,
        sgp.projections.lagged=FALSE,
        sgp.percentiles.baseline=FALSE,
        sgp.projections.baseline=FALSE,
        sgp.projections.lagged.baseline=TRUE,
        sgp.target.scale.scores=TRUE,
        parallel.config=parallel.config
)


###  Save results
save(New_Hampshire_SGP, file="Data/New_Hampshire_SGP.Rdata")
