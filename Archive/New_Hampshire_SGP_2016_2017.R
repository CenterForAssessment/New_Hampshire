################################################################################
###                                                                          ###
###               Calculate SGPs for New Hampshire - 2016-2017               ###
###                                                                          ###
################################################################################

### Load packages

require(SGP)


### Load data

load("Data/New_Hampshire_SGP.Rdata")
load("Data/New_Hampshire_Data_LONG_2016_2017.Rdata")


###  updateSGP

New_Hampshire_SGP <- updateSGP(
			New_Hampshire_SGP,
			with_sgp_data_LONG = New_Hampshire_Data_LONG_2016_2017,
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			save.intermediate.results=FALSE,
			sgPlot.demo.report=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=2, PROJECTIONS=2, LAGGED_PROJECTIONS=2, SUMMARY=2, GA_PLOTS=2, SG_PLOTS=1)))

### Save results

#save(New_Hampshire_SGP, file="Data/New_Hampshire_SGP.Rdata")
