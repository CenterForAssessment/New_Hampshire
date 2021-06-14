######################################################################################
###                                                                                ###
###       New Hampshire Learning Loss Analyses -- Create Baseline Matrices         ###
###                                                                                ###
######################################################################################

### Load necessary packages
require(SGP)
require(data.table)
options(warn=2)

###   Load the results data from the 'official' 2019 SGP analyses
load("Data/Archive/Pre_COVID/New_Hampshire_SGP_LONG_Data.Rdata")

###   Create a smaller subset of the LONG data to work with.
New_Hampshire_Baseline_Data <- data.table(New_Hampshire_SGP_LONG_Data[, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID", "GRADE", "SCALE_SCORE", "ACHIEVEMENT_LEVEL"),])

### Modify knots/boundaries in SGPstateData to use equated scale scores properly
SGPstateData[["NH"]][["Achievement"]][["Knots_Boundaries"]][["READING"]] <- SGPstateData[["NH"]][["Achievement"]][["Knots_Boundaries"]][["READING.2017_2018"]]
SGPstateData[["NH"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS"]] <- SGPstateData[["NH"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2017_2018"]]
SGPstateData[["NH"]][["Achievement"]][["Knots_Boundaries"]][["READING.2014_2015"]] <- NULL
SGPstateData[["NH"]][["Achievement"]][["Knots_Boundaries"]][["READING.2017_2018"]] <- NULL
SGPstateData[["NH"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2014_2015"]] <- NULL
SGPstateData[["NH"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2017_2018"]] <- NULL

### Put 2015_2016 and 2016_2017 scores on NHCAS scale (>= 2017_2018) -- Just READING and MATHEMATICS Grades 3 to 8
SGPstateData[["NH"]][["Assessment_Program_Information"]][["Assessment_Transition"]][["Year"]] <- "2017_2018"

data.for.equate <- New_Hampshire_Baseline_Data[YEAR <= "2017_2018" & CONTENT_AREA %in% c("READING", "MATHEMATICS")]
tmp.equate.linkages <- SGP:::equateSGP(
                                tmp.data=data.for.equate,
                                state="NH",
                                current.year="2017_2018",
                                equating.method=c("identity", "mean", "linear", "equipercentile"))

setkey(data.for.equate, VALID_CASE, CONTENT_AREA, YEAR, GRADE, SCALE_SCORE)

data.for.equate <- SGP:::convertScaleScore(data.for.equate, "2017_2018", tmp.equate.linkages, "OLD_TO_NEW", "equipercentile", "NH")
data.for.equate[YEAR %in% c("2015_2016", "2016_2017"), SCALE_SCORE:=SCALE_SCORE_EQUATED_EQUIPERCENTILE_OLD_TO_NEW]
data.for.equate[,SCALE_SCORE_EQUATED_EQUIPERCENTILE_OLD_TO_NEW:=NULL]

New_Hampshire_Baseline_Data <- rbindlist(list(data.for.equate, New_Hampshire_Baseline_Data[YEAR >= "2018_2019"], New_Hampshire_Baseline_Data[YEAR <= "2017_2018" & !CONTENT_AREA %in% c("READING", "MATHEMATICS")]))
setkey(New_Hampshire_Baseline_Data, VALID_CASE, CONTENT_AREA, YEAR, ID)

###   Read in Baseline SGP Configuration Scripts and Combine
source("SGP_CONFIG/2018_2019/BASELINE/Matrices/READING.R")
source("SGP_CONFIG/2018_2019/BASELINE/Matrices/MATHEMATICS.R")

NH_BASELINE_CONFIG <- c(
	READING_BASELINE.config,
	MATHEMATICS_BASELINE.config
)

###
###   Create Baseline Matrices

New_Hampshire_SGP <- prepareSGP(New_Hampshire_Baseline_Data, create.additional.variables=FALSE)

NH_Baseline_Matrices <- baselineSGP(
				New_Hampshire_SGP,
				sgp.baseline.config=NH_BASELINE_CONFIG,
				return.matrices.only=TRUE,
				calculate.baseline.sgps=FALSE,
				goodness.of.fit.print=FALSE,
				parallel.config = list(
					BACKEND="PARALLEL", WORKERS=list(TAUS=7))
)

###   Save results
save(NH_Baseline_Matrices, file="Data/NH_Baseline_Matrices.Rdata")

### Create SCALE_SCORE_NON_EQUATED and turn (2016 and 2017) SCALE_SCORE into SCALE_SCORE_EQUATED to New_Hampshire_SGP_LONG_Data and save results
setkey(New_Hampshire_SGP_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
setkey(New_Hampshire_Baseline_Data, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
New_Hampshire_SGP_LONG_Data[,SCALE_SCORE_NON_EQUATED:=SCALE_SCORE]
New_Hampshire_SGP_LONG_Data[,SCALE_SCORE:=New_Hampshire_Baseline_Data$SCALE_SCORE]

save(New_Hampshire_SGP_LONG_Data, file="Data/New_Hampshire_SGP_LONG_Data.Rdata")
