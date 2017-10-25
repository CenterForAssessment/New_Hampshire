######################################################################
###
### R syntax to produce New Hampshire long data file for 2016-2017
###
######################################################################

### Load data.table package

require(data.table)


### Load base data file

New_Hampshire_Data_LONG_2016_2017 <- fread("Data/Base_Files/New_Hampshire_Data_LONG_SBAC_2016_2017.txt", colClasses=rep("character", 26))


### Tidy up data

my.iep.labels <- c("Students with Disabilities (SWD/IEP)", "Students without Disabilities (Non-SWD/IEP)")

setnames(New_Hampshire_Data_LONG_2016_2017, c("DISNUMBER", "ETHNIC"), c("DISTRICT_NUMBER", "ETHNICITY"))

New_Hampshire_Data_LONG_2016_2017[,CONTENT_AREA:=as.factor(CONTENT_AREA)]
levels(New_Hampshire_Data_LONG_2016_2017$CONTENT_AREA) <- c("MATHEMATICS", "READING")
New_Hampshire_Data_LONG_2016_2017[,CONTENT_AREA:=as.character(CONTENT_AREA)]

New_Hampshire_Data_LONG_2016_2017[,YEAR:="2016_2017"]

#New_Hampshire_Data_LONG_2016_2017[,DISTRICT_NAME:=factor(DISTRICT_NAME)]

New_Hampshire_Data_LONG_2016_2017[,DISTRICT_NUMBER_TESTING_YEAR:=NULL]
New_Hampshire_Data_LONG_2016_2017[,DISTRICT_NAME_TESTING_YEAR:=NULL]

#New_Hampshire_Data_LONG_2016_2017[,SCHOOL_NAME:=factor(SCHOOL_NAME)]

New_Hampshire_Data_LONG_2016_2017[,SCHOOL_NUMBER_TESTING_YEAR:=NULL]
New_Hampshire_Data_LONG_2016_2017[,SCHOOL_NAME_TESTING_YEAR:=NULL]

New_Hampshire_Data_LONG_2016_2017[,ETHNICITY:=factor(ETHNICITY)]

New_Hampshire_Data_LONG_2016_2017[,ELL_STATUS:=factor(ELL_STATUS)]

New_Hampshire_Data_LONG_2016_2017[,ELL_MULTI_CATEGORY_STATUS:=ELL_STATUS]

New_Hampshire_Data_LONG_2016_2017[,ELL_STATUS:=NULL]

New_Hampshire_Data_LONG_2016_2017[,ELL_STATUS:=factor(1, levels=1:2, labels=c("Non-English Language Learners (Non-EL)", "English Language Learners (EL) with Composite >= 4.0"))]
New_Hampshire_Data_LONG_2016_2017[ELL_MULTI_CATEGORY_STATUS != "Not ELL", ELL_STATUS:="English Language Learners (EL) with Composite >= 4.0"]

New_Hampshire_Data_LONG_2016_2017[,IEP_STATUS:=factor(IEP_STATUS)]
setattr(New_Hampshire_Data_LONG_2016_2017$IEP_STATUS, "levels", my.iep.labels)

New_Hampshire_Data_LONG_2016_2017[,FREE_REDUCED_LUNCH_STATUS:=factor(FREE_REDUCED_LUNCH_STATUS)]
setattr(New_Hampshire_Data_LONG_2016_2017$FREE_REDUCED_LUNCH_STATUS, "levels", c("Economically Disadvantaged (SES)", "Not Economically Disadvantaged (Non-SES)"))

New_Hampshire_Data_LONG_2016_2017[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

New_Hampshire_Data_LONG_2016_2017[,ACHIEVEMENT_LEVEL:=paste("Level", ACHIEVEMENT_LEVEL)]

New_Hampshire_Data_LONG_2016_2017[,TEST_STATUS:=NULL]

New_Hampshire_Data_LONG_2016_2017[,STATE_ENROLLMENT_STATUS:=factor(STATE_ENROLLMENT_STATUS, levels=0:1, labels=c("Enrolled State: No", "Enrolled State: Yes"))]

New_Hampshire_Data_LONG_2016_2017[,DISTRICT_ENROLLMENT_STATUS:=factor(DISTRICT_ENROLLMENT_STATUS)]
setattr(New_Hampshire_Data_LONG_2016_2017$DISTRICT_ENROLLMENT_STATUS, "levels", c("Enrolled District: No", "Enrolled District: Yes"))

New_Hampshire_Data_LONG_2016_2017[,SCHOOL_ENROLLMENT_STATUS:=factor(SCHOOL_ENROLLMENT_STATUS)]
setattr(New_Hampshire_Data_LONG_2016_2017$SCHOOL_ENROLLMENT_STATUS, "levels", c("Enrolled School: No", "Enrolled School: Yes"))

New_Hampshire_Data_LONG_2016_2017[,EMH_LEVEL:=factor(EMH_LEVEL)]
setattr(New_Hampshire_Data_LONG_2016_2017$EMH_LEVEL, "levels", c("Elementary", "High", "Middle"))

New_Hampshire_Data_LONG_2016_2017[,GENDER:=factor(GENDER)]

New_Hampshire_Data_LONG_2016_2017[,STUDENT_GROUP:=
	factor(4, levels=1:4, c("English Language Learners (EL) Group with Composite >= 4.0",  "Students with Disabilities (SWD/IEP) Group (not EL)", "Economically Disadvantaged (SES) Group (not EL or SWD)", "All Other Students Group (Not EL, Not SWD, Not SES)"))]
New_Hampshire_Data_LONG_2016_2017[ELL_STATUS=="English Language Learners (EL) with Composite >= 4.0", STUDENT_GROUP:="English Language Learners (EL) Group with Composite >= 4.0"]
New_Hampshire_Data_LONG_2016_2017[ELL_STATUS=="Non-English Language Learners (Non-EL)" & IEP_STATUS=="Students with Disabilities (SWD/IEP)", STUDENT_GROUP:="Students with Disabilities (SWD/IEP) Group (not EL)"]
New_Hampshire_Data_LONG_2016_2017[ELL_STATUS=="Non-English Language Learners (Non-EL)" & IEP_STATUS=="Students without Disabilities (Non-SWD/IEP)" & FREE_REDUCED_LUNCH_STATUS=="Economically Disadvantaged (SES)", STUDENT_GROUP:="Economically Disadvantaged (SES) Group (not EL or SWD)"]

New_Hampshire_Data_LONG_2016_2017[,InvalidSessions:=NULL]


### Identify VALID_CASES and INVALID_CASES

New_Hampshire_Data_LONG_2016_2017[,VALID_CASE:="VALID_CASE"]
New_Hampshire_Data_LONG_2016_2017[GRADE==11, VALID_CASE:="INVALID_CASE"]
setkey(New_Hampshire_Data_LONG_2016_2017, VALID_CASE, CONTENT_AREA, YEAR, ID, SCALE_SCORE)
setkey(New_Hampshire_Data_LONG_2016_2017, VALID_CASE, CONTENT_AREA, YEAR, ID)
New_Hampshire_Data_LONG_2016_2017[which(duplicated(New_Hampshire_Data_LONG_2016_2017, by=key(New_Hampshire_Data_LONG_2016_2017)))-1, VALID_CASE:="INVALID_CASE"]


### Save output

save(New_Hampshire_Data_LONG_2016_2017, file="Data/New_Hampshire_Data_LONG_2016_2017.Rdata")
