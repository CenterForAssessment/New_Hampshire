################################################################################
###                                                                          ###
###               Calculate SGPs for New Hampshire - 2015-2016               ###
###                                                                          ###
################################################################################

library(SGP)
library(data.table)

load("Data/New_Hampshire_Data_LONG_2012_2013.Rdata")
load("Data/New_Hampshire_Data_LONG_2013_2014.Rdata")
load("Data/New_Hampshire_Data_LONG_2014_2015.Rdata")
load("Data/New_Hampshire_Data_LONG_2015_2016.Rdata")

###
###  Create SBAC Knots and Boundaries
###

NH_SBAC_Knots_Boundaries <- createKnotsBoundaries(rbindlist(list(New_Hampshire_Data_LONG_2014_2015, New_Hampshire_Data_LONG_2015_2016), fill=TRUE))
names(NH_SBAC_Knots_Boundaries) <- c("MATHEMATICS.2014_2015", "READING.2014_2015")

save(NH_SBAC_Knots_Boundaries, file="NH_SBAC_Knots_Boundaries.Rdata")  #  Add to SGPstateData/SGP packages and re-compile


###
### Calculate SGPs
###

New_Hampshire_Data_LONG <- rbindlist(
                                list(New_Hampshire_Data_LONG_2012_2013,
                                     New_Hampshire_Data_LONG_2013_2014,
                                     New_Hampshire_Data_LONG_2014_2015), fill=TRUE)[GRADE != "11"]

###  Run abcSGP to establish New_Hampshire_SGP and run 2014_2015 SGPs and EQUATED SGPs

New_Hampshire_SGP <- abcSGP(
			New_Hampshire_Data_LONG,
			steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
			sgp.percentiles=TRUE,
			sgp.percentiles.equated=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			save.intermediate.results=FALSE,
			goodness.of.fit.print="GROB",
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=20)))


###  Run updateSGP to calculate 2015_2016 SGPs, projections, summaries and visualizations etc.

New_Hampshire_SGP <- updateSGP(
			New_Hampshire_SGP,
			with_sgp_data_LONG = New_Hampshire_Data_LONG_2015_2016,
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			save.intermediate.results=FALSE,
			sgPlot.demo.report=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=20, PROJECTIONS=10, LAGGED_PROJECTIONS=10, SUMMARY=20, GA_PLOTS=20, SG_PLOTS=1)))

### Save results

save(New_Hampshire_SGP, file="Data/New_Hampshire_SGP.Rdata")
