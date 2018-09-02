###########################################################
###
### New Hampshire SGP Analysis
###
###########################################################

### Load SGP Package

require(SGP)


### Load data

load("Data/New_Hampshire_Data_LONG_2015_2016_to_2017_2018.Rdata")


### Calculate SGPs

New_Hampshire_SGP <- abcSGP(
		New_Hampshire_Data_LONG_2015_2016_to_2017_2018,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "summarizeSGP", "outputSGP"),
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		save.intermediate.results=TRUE,
		sgPlot.demo.report=TRUE,
		parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=5, BASELINE_PERCENTILES=5, PROJECTIONS=5, LAGGED_PROJECTIONS=5, SUMMARY=5, GA_PLOTS=5, SG_PLOTS=1)))


### Save results
save(New_Hampshire_SGP, file="Data/New_Hampshire_SGP.Rdata")
