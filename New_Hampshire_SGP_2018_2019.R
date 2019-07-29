###########################################################
###
### New Hampshire SGP Analysis for 2018-2019
###
###########################################################

### Load SGP Package

require(SGP)


### Load data

load("Data/New_Hampshire_SGP.Rdata")
load("Data/New_Hampshire_Data_LONG_2018_2019.Rdata")


### Calculate SGPs

New_Hampshire_SGP <- updateSGP(
		what_sgp_object=New_Hampshire_SGP,
		with_sgp_data_LONG=New_Hampshire_Data_LONG_2018_2019,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "visualizeSGP", "outputSGP"),
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		sgp.percentiles.equated=TRUE,
		sgp.target.scale.scores=TRUE,
		sgPlot.demo.report=TRUE,
		parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=5, BASELINE_PERCENTILES=5, PROJECTIONS=5, LAGGED_PROJECTIONS=5, SUMMARY=5, GA_PLOTS=5, SG_PLOTS=1)))


### Save results

#save(New_Hampshire_SGP, file="Data/New_Hampshire_SGP.Rdata")
