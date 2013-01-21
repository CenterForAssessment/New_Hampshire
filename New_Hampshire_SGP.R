###########################################################
###
### New Hampshire SGP Analysis
###
###########################################################

### Load SGP Package

require(SGP)


### Load data

load("Data/New_Hampshire_Data_LONG.Rdata")


### Calculate SGPs

New_Hampshire_SGP <- abcSGP(
			New_Hampshire_Data_LONG,
			save.intermediate.results=TRUE,
			sgPlot.demo.report=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=30, BASELINE_PERCENTILES=30, PROJECTIONS=14, LAGGED_PROJECTIONS=14, SUMMARY=30, GA_PLOTS=10, SG_PLOTS=1)))


### Save results

save(New_Hampshire_SGP, file="Data/New_Hampshire_SGP.Rdata")
