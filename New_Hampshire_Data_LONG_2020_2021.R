######################################################################
###
### R syntax to produce New Hampshire long data file for 2020-2021
###
######################################################################

### Load data.table package
require(data.table)


### Load base data file
#New_Hampshire_Data_LONG_2020_2021 <- fread("Data/Base_Files/New_Hampshire_Data_LONG_2020_2021.txt", colClasses=rep("character", 31))
New_Hampshire_Data_LONG_2020_2021 <- fread("Data/Base_Files/New_Hampshire_Data_LONG_2020_2021_with_MISSING.txt", colClasses=rep("character", 31), na.strings=c("", "NA", "NULL"))

my.iep.labels <- c("Students with Disabilities (SWD/IEP)", "Students without Disabilities (Non-SWD/IEP)")
my.achievement.level.labels <- c("Below Proficient", "Approaching Proficient", "Proficient", "Above Proficient")

setnames(New_Hampshire_Data_LONG_2020_2021, c("VAID_CASE", "DISNUMBER", "ETHNIC", "SCHOOL_NUMBER", "SCHOOL_NUMBER_TESTING_YEAR"), c("VALID_CASE", "DISTRICT_NUMBER", "ETHNICITY", "SCHOOL_NUMBER_TESTING_YEAR", "SCHOOL_NUMBER"))

New_Hampshire_Data_LONG_2020_2021[,CONTENT_AREA:=as.factor(CONTENT_AREA)]
levels(New_Hampshire_Data_LONG_2020_2021$CONTENT_AREA) <- c("MATHEMATICS", "READING", "SCIENCE")
New_Hampshire_Data_LONG_2020_2021[,CONTENT_AREA:=as.character(CONTENT_AREA)]

New_Hampshire_Data_LONG_2020_2021[YEAR=="2021",YEAR:="2020_2021"]

New_Hampshire_Data_LONG_2020_2021[,DISTRICT_NUMBER_TESTING_YEAR:=NULL]
New_Hampshire_Data_LONG_2020_2021[,DISTRICT_NAME_TESTING_YEAR:=NULL]

New_Hampshire_Data_LONG_2020_2021[,SCHOOL_NUMBER_TESTING_YEAR:=NULL]
New_Hampshire_Data_LONG_2020_2021[,SCHOOL_NAME_TESTING_YEAR:=NULL]

New_Hampshire_Data_LONG_2020_2021[,ETHNICITY:=factor(ETHNICITY)]

New_Hampshire_Data_LONG_2020_2021[ELL_STATUS=="NULL",ELL_STATUS:=as.character(NA)]
New_Hampshire_Data_LONG_2020_2021[,ELL_STATUS:=factor(ELL_STATUS)]

New_Hampshire_Data_LONG_2020_2021[,ELL_MULTI_CATEGORY_STATUS:=ELL_STATUS]

New_Hampshire_Data_LONG_2020_2021[,ELL_STATUS:=NULL]

New_Hampshire_Data_LONG_2020_2021[,ELL_STATUS:=factor(1, levels=1:2, labels=c("Non-English Language Learners (Non-EL)", "English Language Learners (EL) with Composite >= 4.0"))]
New_Hampshire_Data_LONG_2020_2021[,ELL_STATUS:=as.character(ELL_STATUS)]
New_Hampshire_Data_LONG_2020_2021[ELL_MULTI_CATEGORY_STATUS != "Not ELL", ELL_STATUS:="English Language Learners (EL) with Composite >= 4.0"]
New_Hampshire_Data_LONG_2020_2021[,ELL_MULTI_CATEGORY_STATUS:=as.character(ELL_MULTI_CATEGORY_STATUS)]

New_Hampshire_Data_LONG_2020_2021[,IEP_STATUS:=factor(IEP_STATUS)]
setattr(New_Hampshire_Data_LONG_2020_2021$IEP_STATUS, "levels", my.iep.labels)

New_Hampshire_Data_LONG_2020_2021[,FREE_REDUCED_LUNCH_STATUS:=factor(FREE_REDUCED_LUNCH_STATUS)]
setattr(New_Hampshire_Data_LONG_2020_2021$FREE_REDUCED_LUNCH_STATUS, "levels", c("Economically Disadvantaged (SES)", "Not Economically Disadvantaged (Non-SES)"))

New_Hampshire_Data_LONG_2020_2021[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

New_Hampshire_Data_LONG_2020_2021[!is.na(ACHIEVEMENT_LEVEL), ACHIEVEMENT_LEVEL:=paste("Level", ACHIEVEMENT_LEVEL)]
New_Hampshire_Data_LONG_2020_2021[,ACHIEVEMENT_LEVEL:=as.factor(ACHIEVEMENT_LEVEL)]
setattr(New_Hampshire_Data_LONG_2020_2021$ACHIEVEMENT_LEVEL, "levels", my.achievement.level.labels)
New_Hampshire_Data_LONG_2020_2021[,ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]

New_Hampshire_Data_LONG_2020_2021[,TEST_STATUS:=NULL]

New_Hampshire_Data_LONG_2020_2021[,STATE_ENROLLMENT_STATUS:=factor(STATE_ENROLLMENT_STATUS, levels=0:1, labels=c("Enrolled State: No", "Enrolled State: Yes"))]

New_Hampshire_Data_LONG_2020_2021[,DISTRICT_ENROLLMENT_STATUS:=factor(DISTRICT_ENROLLMENT_STATUS)]
setattr(New_Hampshire_Data_LONG_2020_2021$DISTRICT_ENROLLMENT_STATUS, "levels", c("Enrolled District: No", "Enrolled District: Yes"))

New_Hampshire_Data_LONG_2020_2021[,SCHOOL_ENROLLMENT_STATUS:=factor(SCHOOL_ENROLLMENT_STATUS)]
setattr(New_Hampshire_Data_LONG_2020_2021$SCHOOL_ENROLLMENT_STATUS, "levels", c("Enrolled School: No", "Enrolled School: Yes"))

New_Hampshire_Data_LONG_2020_2021[EMH_LEVEL=="NULL",EMH_LEVEL:=as.character(NA)]

New_Hampshire_Data_LONG_2020_2021[GENDER=="NULL",GENDER:=as.character(NA)]
New_Hampshire_Data_LONG_2020_2021[,GENDER:=factor(GENDER)]

New_Hampshire_Data_LONG_2020_2021[,STUDENT_GROUP:=
	factor(4, levels=1:4, c("English Language Learners (EL) Group with Composite >= 4.0",  "Students with Disabilities (SWD/IEP) Group (not EL)", "Economically Disadvantaged (SES) Group (not EL or SWD)", "All Other Students Group (Not EL, Not SWD, Not SES)"))]
New_Hampshire_Data_LONG_2020_2021[ELL_STATUS=="English Language Learners (EL) with Composite >= 4.0", STUDENT_GROUP:="English Language Learners (EL) Group with Composite >= 4.0"]
New_Hampshire_Data_LONG_2020_2021[ELL_STATUS=="Non-English Language Learners (Non-EL)" & IEP_STATUS=="Students with Disabilities (SWD/IEP)", STUDENT_GROUP:="Students with Disabilities (SWD/IEP) Group (not EL)"]
New_Hampshire_Data_LONG_2020_2021[ELL_STATUS=="Non-English Language Learners (Non-EL)" & IEP_STATUS=="Students without Disabilities (Non-SWD/IEP)" & FREE_REDUCED_LUNCH_STATUS=="Economically Disadvantaged (SES)", STUDENT_GROUP:="Economically Disadvantaged (SES) Group (not EL or SWD)"]
New_Hampshire_Data_LONG_2020_2021[,STUDENT_GROUP:=as.character(STUDENT_GROUP)]

New_Hampshire_Data_LONG_2020_2021[,c("InvalidSessions", "SAUName", "AlternateStudentID", "Typeofdata", "DateGenerated"):=NULL]


### Identify VALID_CASES and INVALID_CASES

New_Hampshire_Data_LONG_2020_2021[,VALID_CASE:="VALID_CASE"]
New_Hampshire_Data_LONG_2020_2021[GRADE==11|CONTENT_AREA=="SCIENCE", VALID_CASE:="INVALID_CASE"]


#######################################################
###
### Add in Additional Variable on Virtual Instruction
###
#######################################################

Virtual_Instruction_Percentage <- fread("Data/Base_Files/StudentLevelVirtualInstPct.csv")
setnames(Virtual_Instruction_Percentage, c("YEAR", "ID", "SAUID", "DISTRICT_NUMBER", "SCHOOL_NUMBER", "VIRTUAL_INSTRUCTION_PERCENTAGE"))
Virtual_Instruction_Percentage[,ID:=as.character(ID)]
Virtual_Instruction_Percentage[,SCHOOL_NUMBER:=as.character(SCHOOL_NUMBER)]
Virtual_Instruction_Percentage <- Virtual_Instruction_Percentage[,c("ID", "SCHOOL_NUMBER", "VIRTUAL_INSTRUCTION_PERCENTAGE"), with=FALSE]
Virtual_Instruction_Percentage[,YEAR:="2020_2021"]

setkey(New_Hampshire_Data_LONG_2020_2021, YEAR, SCHOOL_NUMBER, ID)
setkey(Virtual_Instruction_Percentage, YEAR, SCHOOL_NUMBER, ID)
New_Hampshire_Data_LONG_2020_2021 <- Virtual_Instruction_Percentage[New_Hampshire_Data_LONG_2020_2021]

setcolorder(New_Hampshire_Data_LONG_2020_2021, c(1,2,4:24, 3))

### Setkey

setkey(New_Hampshire_Data_LONG_2020_2021, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)

### Save output

save(New_Hampshire_Data_LONG_2020_2021, file="Data/New_Hampshire_Data_LONG_2020_2021.Rdata")
