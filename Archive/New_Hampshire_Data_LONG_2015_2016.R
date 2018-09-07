######################################################################
###
### R syntax to produce New Hampshire long data file for 2015-2016
###
######################################################################

### Load data.table package

require(data.table)


### Load base data file

New_Hampshire_Data_LONG_2015_2016 <- fread("Data/Base_Files/New_Hampshire_Data_LONG_SBAC_2014_2015_and_2015_2016.txt", colClasses=rep("character", 26))


### Take only 2015 data

New_Hampshire_Data_LONG_2015_2016 <- New_Hampshire_Data_LONG_2015_2016[YEAR=="2016"]


### Tidy up data

my.iep.labels <- c("Students with Disabilities (SWD/IEP)", "Students without Disabilities (Non-SWD/IEP)")

setnames(New_Hampshire_Data_LONG_2015_2016, c("VAID_CASE", "DISNUMBER", "ETHNIC"), c("VALID_CASE", "DISTRICT_NUMBER", "ETHNICITY"))

New_Hampshire_Data_LONG_2015_2016[,CONTENT_AREA:=as.factor(CONTENT_AREA)]
levels(New_Hampshire_Data_LONG_2015_2016$CONTENT_AREA) <- c("MATHEMATICS", "READING")
New_Hampshire_Data_LONG_2015_2016[,CONTENT_AREA:=as.character(CONTENT_AREA)]

New_Hampshire_Data_LONG_2015_2016[,YEAR:="2015_2016"]

#New_Hampshire_Data_LONG_2015_2016[,DISTRICT_NAME:=factor(DISTRICT_NAME)]

New_Hampshire_Data_LONG_2015_2016[,DISTRICT_NUMBER_TESTING_YEAR:=NULL]
New_Hampshire_Data_LONG_2015_2016[,DISTRICT_NAME_TESTING_YEAR:=NULL]

#New_Hampshire_Data_LONG_2015_2016[,SCHOOL_NAME:=factor(SCHOOL_NAME)]

New_Hampshire_Data_LONG_2015_2016[,SCHOOL_NUMBER_TESTING_YEAR:=NULL]
New_Hampshire_Data_LONG_2015_2016[,SCHOOL_NAME_TESTING_YEAR:=NULL]

New_Hampshire_Data_LONG_2015_2016[,ETHNICITY:=factor(ETHNICITY)]

New_Hampshire_Data_LONG_2015_2016[,ELL_STATUS:=factor(ELL_STATUS)]

New_Hampshire_Data_LONG_2015_2016[,ELL_MULTI_CATEGORY_STATUS:=ELL_STATUS]

New_Hampshire_Data_LONG_2015_2016[,ELL_STATUS:=NULL]

New_Hampshire_Data_LONG_2015_2016[,ELL_STATUS:=factor(1, levels=1:2, labels=c("Non-English Language Learners (Non-EL)", "English Language Learners (EL) with Composite >= 4.0"))]
New_Hampshire_Data_LONG_2015_2016[ELL_MULTI_CATEGORY_STATUS != "Not ELL", ELL_STATUS:="English Language Learners (EL) with Composite >= 4.0"]

New_Hampshire_Data_LONG_2015_2016[,IEP_STATUS:=factor(IEP_STATUS)]
setattr(New_Hampshire_Data_LONG_2015_2016$IEP_STATUS, "levels", my.iep.labels)

New_Hampshire_Data_LONG_2015_2016[,FREE_REDUCED_LUNCH_STATUS:=factor(FREE_REDUCED_LUNCH_STATUS)]
setattr(New_Hampshire_Data_LONG_2015_2016$FREE_REDUCED_LUNCH_STATUS, "levels", c("Economically Disadvantaged (SES)", "Not Economically Disadvantaged (Non-SES)"))

New_Hampshire_Data_LONG_2015_2016[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

New_Hampshire_Data_LONG_2015_2016[,ACHIEVEMENT_LEVEL:=paste("Level", ACHIEVEMENT_LEVEL)]

New_Hampshire_Data_LONG_2015_2016[,TEST_STATUS:=NULL]

New_Hampshire_Data_LONG_2015_2016[,STATE_ENROLLMENT_STATUS:=factor(STATE_ENROLLMENT_STATUS, levels=0:1, labels=c("Enrolled State: No", "Enrolled State: Yes"))]

New_Hampshire_Data_LONG_2015_2016[,DISTRICT_ENROLLMENT_STATUS:=factor(DISTRICT_ENROLLMENT_STATUS)]
setattr(New_Hampshire_Data_LONG_2015_2016$DISTRICT_ENROLLMENT_STATUS, "levels", c("Enrolled District: No", "Enrolled District: Yes"))

New_Hampshire_Data_LONG_2015_2016[,SCHOOL_ENROLLMENT_STATUS:=factor(SCHOOL_ENROLLMENT_STATUS)]
setattr(New_Hampshire_Data_LONG_2015_2016$SCHOOL_ENROLLMENT_STATUS, "levels", c("Enrolled School: No", "Enrolled School: Yes"))

New_Hampshire_Data_LONG_2015_2016[,EMH_LEVEL:=factor(EMH_LEVEL)]
setattr(New_Hampshire_Data_LONG_2015_2016$EMH_LEVEL, "levels", c("Elementary", "High", "Middle"))

New_Hampshire_Data_LONG_2015_2016[,GENDER:=factor(GENDER)]

New_Hampshire_Data_LONG_2015_2016[,STUDENT_GROUP:=
	factor(4, levels=1:4, c("English Language Learners (EL) Group with Composite >= 4.0",  "Students with Disabilities (SWD/IEP) Group (not EL)", "Economically Disadvantaged (SES) Group (not EL or SWD)", "All Other Students Group (Not EL, Not SWD, Not SES)"))]
New_Hampshire_Data_LONG_2015_2016[ELL_STATUS=="English Language Learners (EL) with Composite >= 4.0", STUDENT_GROUP:="English Language Learners (EL) Group with Composite >= 4.0"]
New_Hampshire_Data_LONG_2015_2016[ELL_STATUS=="Non-English Language Learners (Non-EL)" & IEP_STATUS=="Students with Disabilities (SWD/IEP)", STUDENT_GROUP:="Students with Disabilities (SWD/IEP) Group (not EL)"]
New_Hampshire_Data_LONG_2015_2016[ELL_STATUS=="Non-English Language Learners (Non-EL)" & IEP_STATUS=="Students without Disabilities (Non-SWD/IEP)" & FREE_REDUCED_LUNCH_STATUS=="Economically Disadvantaged (SES)", STUDENT_GROUP:="Economically Disadvantaged (SES) Group (not EL or SWD)"]

New_Hampshire_Data_LONG_2015_2016[,InvalidSessions:=NULL]


### Identify VALID_CASES and INVALID_CASES

New_Hampshire_Data_LONG_2015_2016[,VALID_CASE:="VALID_CASE"]
New_Hampshire_Data_LONG_2015_2016[GRADE==11, VALID_CASE:="INVALID_CASE"]


### Save output

save(New_Hampshire_Data_LONG_2015_2016, file="Data/New_Hampshire_Data_LONG_2015_2016.Rdata")
