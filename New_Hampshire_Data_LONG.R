######################################################################
###
### R syntax to produce New Hampshire long data file for 2016-2017
###
######################################################################

### Load data.table package

require(data.table)


### Load base data file

New_Hampshire_Data_LONG_2015_2016 <- fread("Data/Base_Files/New_Hampshire_Data_LONG_2015_2016_NEW_IDS.txt", colClasses=rep("character", 26))
New_Hampshire_Data_LONG_2016_2017 <- fread("Data/Base_Files/New_Hampshire_Data_LONG_2016_2017_NEW_IDS.txt", colClasses=rep("character", 26))
New_Hampshire_Data_LONG_2017_2018 <- fread("Data/Base_Files/New_Hampshire_Data_LONG_2017_2018_NEW_IDS.txt", colClasses=rep("character", 26))
New_Hampshire_Data_LONG <- rbindlist(list(New_Hampshire_Data_LONG_2015_2016, New_Hampshire_Data_LONG_2016_2017, New_Hampshire_Data_LONG_2017_2018))

### Tidy up data

setnames(New_Hampshire_Data_LONG, "VAID_CASE", "VALID_CASE")

my.iep.labels <- c("Students with Disabilities (SWD/IEP)", "Students without Disabilities (Non-SWD/IEP)")

setnames(New_Hampshire_Data_LONG, c("DISNUMBER", "ETHNIC"), c("DISTRICT_NUMBER", "ETHNICITY"))

New_Hampshire_Data_LONG[,CONTENT_AREA:=as.factor(CONTENT_AREA)]
levels(New_Hampshire_Data_LONG$CONTENT_AREA) <- c("MATHEMATICS", "READING")
New_Hampshire_Data_LONG[,CONTENT_AREA:=as.character(CONTENT_AREA)]

New_Hampshire_Data_LONG <- New_Hampshire_Data_LONG[YEAR=="2016",YEAR:="2015_2016"]
New_Hampshire_Data_LONG <- New_Hampshire_Data_LONG[YEAR=="2017",YEAR:="2016_2017"]
New_Hampshire_Data_LONG <- New_Hampshire_Data_LONG[YEAR=="2018",YEAR:="2017_2018"]

New_Hampshire_Data_LONG[DISTRICT_NUMBER=="NULL", DISTRICT_NUMBER:=as.character(NA)]
New_Hampshire_Data_LONG[DISTRICT_NAME=="NULL", DISTRICT_NAME:=as.character(NA)]

New_Hampshire_Data_LONG[,DISTRICT_NUMBER_TESTING_YEAR:=NULL]
New_Hampshire_Data_LONG[,DISTRICT_NAME_TESTING_YEAR:=NULL]

New_Hampshire_Data_LONG[,SCHOOL_NUMBER_TESTING_YEAR:=NULL]
New_Hampshire_Data_LONG[,SCHOOL_NAME_TESTING_YEAR:=NULL]

New_Hampshire_Data_LONG[,ETHNICITY:=factor(ETHNICITY)]

New_Hampshire_Data_LONG[ELL_STATUS=="NULL",ELL_STATUS:=as.character(NA)]
New_Hampshire_Data_LONG[,ELL_STATUS:=factor(ELL_STATUS)]

New_Hampshire_Data_LONG[,ELL_MULTI_CATEGORY_STATUS:=ELL_STATUS]

New_Hampshire_Data_LONG[,ELL_STATUS:=NULL]

New_Hampshire_Data_LONG[,ELL_STATUS:=factor(1, levels=1:2, labels=c("Non-English Language Learners (Non-EL)", "English Language Learners (EL) with Composite >= 4.0"))]
New_Hampshire_Data_LONG[,ELL_STATUS:=as.character(ELL_STATUS)]
New_Hampshire_Data_LONG[ELL_MULTI_CATEGORY_STATUS != "Not ELL", ELL_STATUS:="English Language Learners (EL) with Composite >= 4.0"]
New_Hampshire_Data_LONG[,ELL_MULTI_CATEGORY_STATUS:=as.character(ELL_MULTI_CATEGORY_STATUS)]

New_Hampshire_Data_LONG[,IEP_STATUS:=factor(IEP_STATUS)]
setattr(New_Hampshire_Data_LONG$IEP_STATUS, "levels", my.iep.labels)

New_Hampshire_Data_LONG[,FREE_REDUCED_LUNCH_STATUS:=factor(FREE_REDUCED_LUNCH_STATUS)]
setattr(New_Hampshire_Data_LONG$FREE_REDUCED_LUNCH_STATUS, "levels", c("Economically Disadvantaged (SES)", "Not Economically Disadvantaged (Non-SES)"))

New_Hampshire_Data_LONG[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

New_Hampshire_Data_LONG[,ACHIEVEMENT_LEVEL:=paste("Level", ACHIEVEMENT_LEVEL)]

New_Hampshire_Data_LONG[,TEST_STATUS:=NULL]

New_Hampshire_Data_LONG[,STATE_ENROLLMENT_STATUS:=factor(STATE_ENROLLMENT_STATUS, levels=0:1, labels=c("Enrolled State: No", "Enrolled State: Yes"))]

New_Hampshire_Data_LONG[,DISTRICT_ENROLLMENT_STATUS:=factor(DISTRICT_ENROLLMENT_STATUS)]
setattr(New_Hampshire_Data_LONG$DISTRICT_ENROLLMENT_STATUS, "levels", c("Enrolled District: No", "Enrolled District: Yes"))

New_Hampshire_Data_LONG[,SCHOOL_ENROLLMENT_STATUS:=factor(SCHOOL_ENROLLMENT_STATUS)]
setattr(New_Hampshire_Data_LONG$SCHOOL_ENROLLMENT_STATUS, "levels", c("Enrolled School: No", "Enrolled School: Yes"))

New_Hampshire_Data_LONG[EMH_LEVEL=="NULL",EMH_LEVEL:=as.character(NA)]

New_Hampshire_Data_LONG[,GENDER:=factor(GENDER)]

New_Hampshire_Data_LONG[,STUDENT_GROUP:=
	factor(4, levels=1:4, c("English Language Learners (EL) Group with Composite >= 4.0",  "Students with Disabilities (SWD/IEP) Group (not EL)", "Economically Disadvantaged (SES) Group (not EL or SWD)", "All Other Students Group (Not EL, Not SWD, Not SES)"))]
New_Hampshire_Data_LONG[ELL_STATUS=="English Language Learners (EL) with Composite >= 4.0", STUDENT_GROUP:="English Language Learners (EL) Group with Composite >= 4.0"]
New_Hampshire_Data_LONG[ELL_STATUS=="Non-English Language Learners (Non-EL)" & IEP_STATUS=="Students with Disabilities (SWD/IEP)", STUDENT_GROUP:="Students with Disabilities (SWD/IEP) Group (not EL)"]
New_Hampshire_Data_LONG[ELL_STATUS=="Non-English Language Learners (Non-EL)" & IEP_STATUS=="Students without Disabilities (Non-SWD/IEP)" & FREE_REDUCED_LUNCH_STATUS=="Economically Disadvantaged (SES)", STUDENT_GROUP:="Economically Disadvantaged (SES) Group (not EL or SWD)"]
New_Hampshire_Data_LONG[,STUDENT_GROUP:=as.character(STUDENT_GROUP)]

New_Hampshire_Data_LONG[,InvalidSessions:=NULL]


### Identify VALID_CASES and INVALID_CASES

New_Hampshire_Data_LONG[,VALID_CASE:="VALID_CASE"]
New_Hampshire_Data_LONG[GRADE==11, VALID_CASE:="INVALID_CASE"]


### Setkey

setkey(New_Hampshire_Data_LONG, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)


### Rename file

New_Hampshire_Data_LONG_2015_2016_to_2017_2018 <- New_Hampshire_Data_LONG


### Save output

save(New_Hampshire_Data_LONG_2015_2016_to_2017_2018, file="Data/New_Hampshire_Data_LONG_2015_2016_to_2017_2018.Rdata")
