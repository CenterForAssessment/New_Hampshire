#########################################################################################
###                                                                                   ###
###          New_Hampshire 2018-2019 consecutive-year BASELINE SGP analyses           ###
###          NOTE: Doing this in 2021-2022 thus the file name                         ###
###                                                                                   ###
#########################################################################################

###   Load packages
require(SGP)
require(data.table)
require(SGPmatrices)

###   Load data
load("Data/New_Hampshire_SGP.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("NH", "2020_2021")
SGPstateData[["NH"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

###   Rename the skip-year SGP variables and objects

##    We can simply rename the BASELINE variables. We only have 2019/21 skip yr
# table(New_Hampshire_SGP@Data[!is.na(SGP_BASELINE),
#         .(CONTENT_AREA, YEAR), GRADE], exclude = NULL)
baseline.names <- grep("BASELINE", names(New_Hampshire_SGP@Data), value = TRUE)
setnames(New_Hampshire_SGP@Data,
         baseline.names,
         paste0(baseline.names, "_SKIP_YEAR"))

sgps.2018_2019 <- grep(".2018_2019.BASELINE", names(New_Hampshire_SGP@SGP[["SGPercentiles"]]))
names(New_Hampshire_SGP@SGP[["SGPercentiles"]])[sgps.2018_2019] <-
    gsub(".2018_2019.BASELINE",
         ".2018_2019.SKIP_YEAR_BLINE",
         names(New_Hampshire_SGP@SGP[["SGPercentiles"]])[sgps.2018_2019])


###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2021_2022/PART_A/READING.R")
source("SGP_CONFIG/2021_2022/PART_A/MATHEMATICS.R")

NH_Baseline_Config_2018_2019 <- c(
  READING.2018_2019.config,
  MATHEMATICS.2018_2019.config
)

###   Parallel Config
parallel.config <- list(BACKEND = "PARALLEL",
                        WORKERS = list(BASELINE_PERCENTILES = 8))


#####
###   Run abcSGP analysis
#####

New_Hampshire_SGP <-
    abcSGP(sgp_object = New_Hampshire_SGP,
           years = "2018_2019",
           steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
           sgp.config = NH_Baseline_Config_2018_2019,
           sgp.percentiles = FALSE,
           sgp.projections = FALSE,
           sgp.projections.lagged = FALSE,
           sgp.percentiles.baseline = TRUE,
           sgp.projections.baseline = FALSE,
           sgp.projections.lagged.baseline = FALSE,
           simulate.sgps = FALSE,
           parallel.config = parallel.config)

###   Save results
save(New_Hampshire_SGP, file = "Data/New_Hampshire_SGP.Rdata")
