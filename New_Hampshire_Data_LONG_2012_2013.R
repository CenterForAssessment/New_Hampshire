######################################################################
###
### R syntax to produce New Hampshire long data file for 2012-2013
###
######################################################################

### Load data.table package

require(data.table)


### Load base data file

New_Hampshire_Data_LONG_2012_2013 <- read.table("Data/Base_Files/New_Hampshire_Data_LONG_BASE_FILE_2012_2013.txt", sep="|", header=TRUE, comment.char="", quote="")


### Take only 2012 data

New_Hampshire_Data_LONG_2012_2013 <- subset(New_Hampshire_Data_LONG_2012_2013, YEAR==2012)


### Tidy up data

my.ethnicity.labels <- c("No Primary Race/Ethnicity Reported", "American Indian or Alaskan Native", "Asian",
        "Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Multiple Ethnicities Reported")
my.lep.labels <- c("Non-LEP Student", "Currently Receiving LEP Services", "Former LEP Student - Monitoring Year 1",
        "Former LEP Student - Monitoring Year 2")
my.iep.labels <- c("Students with Disabilities (SWD/IEP)", "Students without Disabilities (Non-SWD/IEP)")

names(New_Hampshire_Data_LONG_2012_2013)[c(1,6,14)] <- c("VALID_CASE", "DISTRICT_NUMBER", "ETHNICITY")
levels(New_Hampshire_Data_LONG_2012_2013$CONTENT_AREA) <- c("MATHEMATICS", "READING")
New_Hampshire_Data_LONG_2012_2013[["CONTENT_AREA"]] <- as.character(New_Hampshire_Data_LONG_2012_2013[["CONTENT_AREA"]])
New_Hampshire_Data_LONG_2012_2013$YEAR <- "2012_2013"
New_Hampshire_Data_LONG_2012_2013[["ID"]] <- as.character(New_Hampshire_Data_LONG_2012_2013[["ID"]])
New_Hampshire_Data_LONG_2012_2013[["GRADE"]] <- as.character(New_Hampshire_Data_LONG_2012_2013[["GRADE"]])
New_Hampshire_Data_LONG_2012_2013$DISTRICT_NAME[New_Hampshire_Data_LONG_2012_2013$DISTRICT_NAME==""] <- NA
New_Hampshire_Data_LONG_2012_2013$DISTRICT_NAME <- factor(New_Hampshire_Data_LONG_2012_2013$DISTRICT_NAME)
New_Hampshire_Data_LONG_2012_2013$DISTRICT_NUMBER_TESTING_YEAR <- as.integer(New_Hampshire_Data_LONG_2012_2013$DISTRICT_NUMBER_TESTING_YEAR)
New_Hampshire_Data_LONG_2012_2013$DISTRICT_NAME_TESTING_YEAR <- as.factor(New_Hampshire_Data_LONG_2012_2013$DISTRICT_NAME_TESTING_YEAR) 
New_Hampshire_Data_LONG_2012_2013$SCHOOL_NAME[New_Hampshire_Data_LONG_2012_2013$SCHOOL_NAME==""] <- NA
New_Hampshire_Data_LONG_2012_2013$SCHOOL_NAME <- factor(New_Hampshire_Data_LONG_2012_2013$SCHOOL_NAME)
New_Hampshire_Data_LONG_2012_2013$SCHOOL_NUMBER_TESTING_YEAR <- as.integer(New_Hampshire_Data_LONG_2012_2013$SCHOOL_NUMBER_TESTING_YEAR)
New_Hampshire_Data_LONG_2012_2013$SCHOOL_NAME_TESTING_YEAR <- as.factor(New_Hampshire_Data_LONG_2012_2013$SCHOOL_NAME_TESTING_YEAR) 
New_Hampshire_Data_LONG_2012_2013$ETHNICITY[New_Hampshire_Data_LONG_2012_2013$ETHNICITY==""] <- NA
New_Hampshire_Data_LONG_2012_2013$ETHNICITY <- factor(New_Hampshire_Data_LONG_2012_2013$ETHNICITY)
New_Hampshire_Data_LONG_2012_2013$ELL_STATUS[New_Hampshire_Data_LONG_2012_2013$ELL_STATUS==""] <- NA
New_Hampshire_Data_LONG_2012_2013$ELL_STATUS <- factor(New_Hampshire_Data_LONG_2012_2013$ELL_STATUS)

New_Hampshire_Data_LONG_2012_2013$ELL_MULTI_CATEGORY_STATUS <- New_Hampshire_Data_LONG_2012_2013$ELL_STATUS
New_Hampshire_Data_LONG_2012_2013$ELL_STATUS <- NULL
New_Hampshire_Data_LONG_2012_2013$ELL_STATUS <- factor(1, levels=1:2, labels=c("Non-English Language Learners (Non-EL)", "English Language Learners (EL) with Composite >= 4.0"))
New_Hampshire_Data_LONG_2012_2013$ELL_STATUS[New_Hampshire_Data_LONG_2012_2013$ELL_MULTI_CATEGORY_STATUS != "Not ELL"] <- "English Language Learners (EL) with Composite >= 4.0"

New_Hampshire_Data_LONG_2012_2013$IEP_STATUS[New_Hampshire_Data_LONG_2012_2013$IEP_STATUS==""] <- NA
New_Hampshire_Data_LONG_2012_2013$IEP_STATUS <- factor(New_Hampshire_Data_LONG_2012_2013$IEP_STATUS)
levels(New_Hampshire_Data_LONG_2012_2013$IEP_STATUS) <- my.iep.labels
New_Hampshire_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS[New_Hampshire_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS==""] <- NA
New_Hampshire_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS <- droplevels(New_Hampshire_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS)
levels(New_Hampshire_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS) <- c("Economically Disadvantaged (SES)", "Not Economically Disadvantaged (Non-SES)")
New_Hampshire_Data_LONG_2012_2013$SCALE_SCORE <- as.numeric(New_Hampshire_Data_LONG_2012_2013$SCALE_SCORE)
New_Hampshire_Data_LONG_2012_2013$ACHIEVEMENT_LEVEL <- factor(New_Hampshire_Data_LONG_2012_2013$ACHIEVEMENT, levels=1:4, 
	labels=c("Substantially Below Proficient", "Partially Proficient", "Proficient", "Proficient with Distinction"))
New_Hampshire_Data_LONG_2012_2013$TEST_STATUS <- NULL
New_Hampshire_Data_LONG_2012_2013$STATE_ENROLLMENT_STATUS <- factor(New_Hampshire_Data_LONG_2012_2013$STATE_ENROLLMENT_STATUS, levels=1:2, labels=c("Enrolled State: Yes", "Enrolled State: No"))
New_Hampshire_Data_LONG_2012_2013$DISTRICT_ENROLLMENT_STATUS <- factor(1, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))
New_Hampshire_Data_LONG_2012_2013$SCHOOL_ENROLLMENT_STATUS <- factor(1, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))
New_Hampshire_Data_LONG_2012_2013$EMH_LEVEL[New_Hampshire_Data_LONG_2012_2013$EMH_LEVEL==""] <- NA
New_Hampshire_Data_LONG_2012_2013$EMH_LEVEL <- factor(New_Hampshire_Data_LONG_2012_2013$EMH_LEVEL)
levels(New_Hampshire_Data_LONG_2012_2013$EMH_LEVEL) <- c("Elementary", "High", "Middle")
New_Hampshire_Data_LONG_2012_2013$GENDER[New_Hampshire_Data_LONG_2012_2013$GENDER==""] <- NA
New_Hampshire_Data_LONG_2012_2013$GENDER <- factor(New_Hampshire_Data_LONG_2012_2013$GENDER)

New_Hampshire_Data_LONG_2012_2013$STUDENT_GROUP <- 
	factor(4, levels=1:4, c("English Language Learners (EL) Group with Composite >= 4.0",  "Students with Disabilities (SWD/IEP) Group (not EL)", "Economically Disadvantaged (SES) Group (not EL or SWD)", "All Other Students Group (Not EL, Not SWD, Not SES)"))
New_Hampshire_Data_LONG_2012_2013$STUDENT_GROUP[New_Hampshire_Data_LONG_2012_2013$ELL_STATUS=="English Language Learners (EL) with Composite >= 4.0"] <- "English Language Learners (EL) Group with Composite >= 4.0"
New_Hampshire_Data_LONG_2012_2013$STUDENT_GROUP[New_Hampshire_Data_LONG_2012_2013$ELL_STATUS=="Non-English Language Learners (Non-EL)" & New_Hampshire_Data_LONG_2012_2013$IEP_STATUS=="Students with Disabilities (SWD/IEP)"] <- 
	"Students with Disabilities (SWD/IEP) Group (not EL)"
New_Hampshire_Data_LONG_2012_2013$STUDENT_GROUP[
	New_Hampshire_Data_LONG_2012_2013$ELL_STATUS=="Non-English Language Learners (Non-EL)" & 
	New_Hampshire_Data_LONG_2012_2013$IEP_STATUS=="Students without Disabilities (Non-SWD/IEP)" & 
	New_Hampshire_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS=="Economically Disadvantaged (SES)"] <- "Economically Disadvantaged (SES) Group (not EL or SWD)"


### Change TESTING_YEAR to CURRENT

names(New_Hampshire_Data_LONG_2012_2013)[names(New_Hampshire_Data_LONG_2012_2013)=="DISTRICT_NUMBER_TESTING_YEAR"] <- "DISTRICT_NUMBER_CURRENT"
names(New_Hampshire_Data_LONG_2012_2013)[names(New_Hampshire_Data_LONG_2012_2013)=="DISTRICT_NAME_TESTING_YEAR"] <- "DISTRICT_NAME_CURRENT"
names(New_Hampshire_Data_LONG_2012_2013)[names(New_Hampshire_Data_LONG_2012_2013)=="SCHOOL_NUMBER_TESTING_YEAR"] <- "SCHOOL_NUMBER_CURRENT"
names(New_Hampshire_Data_LONG_2012_2013)[names(New_Hampshire_Data_LONG_2012_2013)=="SCHOOL_NAME_TESTING_YEAR"] <- "SCHOOL_NAME_CURRENT"

### Identify VALID_CASES and INVALID_CASES

New_Hampshire_Data_LONG_2012_2013[["VALID_CASE"]] <- "VALID_CASE"
New_Hampshire_Data_LONG_2012_2013[["VALID_CASE"]][New_Hampshire_Data_LONG_2012_2013$GRADE==11] <- "INVALID_CASE"

New_Hampshire_Data_LONG_2012_2013 <- as.data.table(New_Hampshire_Data_LONG_2012_2013)
setkeyv(New_Hampshire_Data_LONG_2012_2013, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID", "GRADE", "SCALE_SCORE"))
setkeyv(New_Hampshire_Data_LONG_2012_2013, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))
New_Hampshire_Data_LONG_2012_2013[["VALID_CASE"]][which(duplicated(New_Hampshire_Data_LONG_2012_2013))-1] <- "INVALID_CASE"
New_Hampshire_Data_LONG_2012_2013[["VALID_CASE"]][New_Hampshire_Data_LONG_2012_2013$InvalidSessions != 0] <- "INVALID_CASE"

New_Hampshire_Data_LONG_2012_2013$InvalidSessions <- NULL


### Convert back to data.frame and Save output

New_Hampshire_Data_LONG_2012_2013 <- as.data.frame(New_Hampshire_Data_LONG_2012_2013)
save(New_Hampshire_Data_LONG_2012_2013, file="Data/New_Hampshire_Data_LONG_2012_2013.Rdata")

