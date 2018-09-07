###########################################################
###
### New Hampshire SGP Analysis for 2012_2013
###
###########################################################

### Load SGP Package

require(SGP)


### Load previous SGP object and 2012_2013 data

load("Data/New_Hampshire_SGP.Rdata")
load("Data/New_Hampshire_Data_LONG_2012_2013.Rdata")


### Update SGPs

New_Hampshire_SGP <- updateSGP(
			New_Hampshire_SGP,
			New_Hampshire_Data_LONG_2012_2013,
			sgPlot.demo.report=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SUMMARY=4, GA_PLOTS=4, SG_PLOTS=1)))


### Save results

save(New_Hampshire_SGP, file="Data/New_Hampshire_SGP.Rdata")
