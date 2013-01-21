######################################################################
###
### Script to produce New Hampshire long data file
###
######################################################################

### Load SGP package

require(SGP)


### Load base data file

New_Hampshire_Data_LONG <- read.table("Data/Base_Files/New_Hampshire_Data_LONG_BASE_FILE.txt", sep="|", header=TRUE, comment.char="", quote="")


### Tidy up data

my.ethnicity.labels <- c("No Primary Race/Ethnicity Reported", "American Indian or Alaskan Native", "Asian",
        "Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Multiple Ethnicities Reported")
my.lep.labels <- c("Non-LEP Student", "Currently Receiving LEP Services", "Former LEP Student - Monitoring Year 1",
        "Former LEP Student - Monitoring Year 2")
my.iep.labels <- c("Students with Disabilities (SWD/IEP)", "Students without Disabilities (Non-SWD/IEP)")

names(New_Hampshire_Data_LONG)[c(1,6,14)] <- c("VALID_CASE", "DISTRICT_NUMBER", "ETHNICITY")
levels(New_Hampshire_Data_LONG$CONTENT_AREA) <- c("MATHEMATICS", "READING")
New_Hampshire_Data_LONG$YEAR <- as.factor(New_Hampshire_Data_LONG$YEAR)
levels(New_Hampshire_Data_LONG$YEAR) <- c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012")
New_Hampshire_Data_LONG[["ID"]] <- as.factor(New_Hampshire_Data_LONG[["ID"]])
New_Hampshire_Data_LONG$DISTRICT_NAME[New_Hampshire_Data_LONG$DISTRICT_NAME==""] <- NA
New_Hampshire_Data_LONG$DISTRICT_NAME <- factor(New_Hampshire_Data_LONG$DISTRICT_NAME)
New_Hampshire_Data_LONG$DISTRICT_NUMBER_TESTING_YEAR <- as.integer(New_Hampshire_Data_LONG$DISTRICT_NUMBER_TESTING_YEAR)
New_Hampshire_Data_LONG$DISTRICT_NAME_TESTING_YEAR <- as.factor(New_Hampshire_Data_LONG$DISTRICT_NAME_TESTING_YEAR) 
New_Hampshire_Data_LONG$SCHOOL_NAME[New_Hampshire_Data_LONG$SCHOOL_NAME==""] <- NA
New_Hampshire_Data_LONG$SCHOOL_NAME <- factor(New_Hampshire_Data_LONG$SCHOOL_NAME)
New_Hampshire_Data_LONG$SCHOOL_NUMBER_TESTING_YEAR <- as.integer(New_Hampshire_Data_LONG$SCHOOL_NUMBER_TESTING_YEAR)
New_Hampshire_Data_LONG$SCHOOL_NAME_TESTING_YEAR <- as.factor(New_Hampshire_Data_LONG$SCHOOL_NAME_TESTING_YEAR) 
New_Hampshire_Data_LONG$ETHNICITY[New_Hampshire_Data_LONG$ETHNICITY==""] <- NA
New_Hampshire_Data_LONG$ETHNICITY <- factor(New_Hampshire_Data_LONG$ETHNICITY)
New_Hampshire_Data_LONG$ELL_STATUS[New_Hampshire_Data_LONG$ELL_STATUS==""] <- NA
New_Hampshire_Data_LONG$ELL_STATUS <- factor(New_Hampshire_Data_LONG$ELL_STATUS)

New_Hampshire_Data_LONG$ELL_MULTI_CATEGORY_STATUS <- New_Hampshire_Data_LONG$ELL_STATUS
New_Hampshire_Data_LONG$ELL_STATUS <- NULL
New_Hampshire_Data_LONG$ELL_STATUS <- factor(1, levels=1:2, labels=c("Non-English Language Learners (Non-EL)", "English Language Learners (EL) with Composite >= 4.0"))
New_Hampshire_Data_LONG$ELL_STATUS[New_Hampshire_Data_LONG$ELL_MULTI_CATEGORY_STATUS != "Not ELL"] <- "English Language Learners (EL) with Composite >= 4.0"

New_Hampshire_Data_LONG$IEP_STATUS[New_Hampshire_Data_LONG$IEP_STATUS==""] <- NA
New_Hampshire_Data_LONG$IEP_STATUS <- factor(New_Hampshire_Data_LONG$IEP_STATUS)
levels(New_Hampshire_Data_LONG$IEP_STATUS) <- my.iep.labels
New_Hampshire_Data_LONG$FREE_REDUCED_LUNCH_STATUS[New_Hampshire_Data_LONG$FREE_REDUCED_LUNCH_STATUS==""] <- NA
New_Hampshire_Data_LONG$FREE_REDUCED_LUNCH_STATUS <- droplevels(New_Hampshire_Data_LONG$FREE_REDUCED_LUNCH_STATUS)
levels(New_Hampshire_Data_LONG$FREE_REDUCED_LUNCH_STATUS) <- c("Economically Disadvantaged (SES)", "Not Economically Disadvantaged (Non-SES)")
New_Hampshire_Data_LONG$SCALE_SCORE <- as.numeric(New_Hampshire_Data_LONG$SCALE_SCORE)
New_Hampshire_Data_LONG$ACHIEVEMENT_LEVEL <- factor(New_Hampshire_Data_LONG$ACHIEVEMENT, levels=1:4, 
	labels=c("Substantially Below Proficient", "Partially Proficient", "Proficient", "Proficient with Distinction"))
New_Hampshire_Data_LONG$TEST_STATUS <- NULL
New_Hampshire_Data_LONG$STATE_ENROLLMENT_STATUS <- factor(New_Hampshire_Data_LONG$STATE_ENROLLMENT_STATUS, levels=1:2, labels=c("Enrolled State: Yes", "Enrolled State: No"))
levels(New_Hampshire_Data_LONG$DISTRICT_ENROLLMENT_STATUS) <- c("Enrolled District: No", "Enrolled District: Yes")
levels(New_Hampshire_Data_LONG$SCHOOL_ENROLLMENT_STATUS) <- c("Enrolled School: No", "Enrolled School: Yes")
New_Hampshire_Data_LONG$EMH_LEVEL[New_Hampshire_Data_LONG$EMH_LEVEL==""] <- NA
New_Hampshire_Data_LONG$EMH_LEVEL <- factor(New_Hampshire_Data_LONG$EMH_LEVEL)
levels(New_Hampshire_Data_LONG$EMH_LEVEL) <- c("Elementary", "High", "Middle")
New_Hampshire_Data_LONG$GENDER[New_Hampshire_Data_LONG$GENDER==""] <- NA
New_Hampshire_Data_LONG$GENDER <- factor(New_Hampshire_Data_LONG$GENDER)

New_Hampshire_Data_LONG$STUDENT_GROUP <- 
	factor(4, levels=1:4, c("English Language Learners (EL) Group with Composite >= 4.0",  "Students with Disabilities (SWD/IEP) Group (not EL)", "Economically Disadvantaged (SES) Group (not EL or SWD)", "All Other Students Group (Not EL, Not SWD, Not SES)"))
New_Hampshire_Data_LONG$STUDENT_GROUP[New_Hampshire_Data_LONG$ELL_STATUS=="English Language Learners (EL) with Composite >= 4.0"] <- "English Language Learners (EL) Group with Composite >= 4.0"
New_Hampshire_Data_LONG$STUDENT_GROUP[New_Hampshire_Data_LONG$ELL_STATUS=="Non-English Language Learners (Non-EL)" & New_Hampshire_Data_LONG$IEP_STATUS=="Students with Disabilities (SWD/IEP)"] <- 
	"Students with Disabilities (SWD/IEP) Group (not EL)"
New_Hampshire_Data_LONG$STUDENT_GROUP[
	New_Hampshire_Data_LONG$ELL_STATUS=="Non-English Language Learners (Non-EL)" & 
	New_Hampshire_Data_LONG$IEP_STATUS=="Students without Disabilities (Non-SWD/IEP)" & 
	New_Hampshire_Data_LONG$FREE_REDUCED_LUNCH_STATUS=="Economically Disadvantaged (SES)"] <- "Economically Disadvantaged (SES) Group (not EL or SWD)"


### Change TESTING_YEAR to CURRENT

names(New_Hampshire_Data_LONG)[names(New_Hampshire_Data_LONG)=="DISTRICT_NUMBER_TESTING_YEAR"] <- "DISTRICT_NUMBER_CURRENT"
names(New_Hampshire_Data_LONG)[names(New_Hampshire_Data_LONG)=="DISTRICT_NAME_TESTING_YEAR"] <- "DISTRICT_NAME_CURRENT"
names(New_Hampshire_Data_LONG)[names(New_Hampshire_Data_LONG)=="SCHOOL_NUMBER_TESTING_YEAR"] <- "SCHOOL_NUMBER_CURRENT"
names(New_Hampshire_Data_LONG)[names(New_Hampshire_Data_LONG)=="SCHOOL_NAME_TESTING_YEAR"] <- "SCHOOL_NAME_CURRENT"

### Identify VALID_CASES and INVALID_CASES

New_Hampshire_Data_LONG[["VALID_CASE"]] <- factor(1, levels=1:2, labels=c("VALID_CASE", "INVALID_CASE"))
New_Hampshire_Data_LONG[["VALID_CASE"]][New_Hampshire_Data_LONG$GRADE==11] <- "INVALID_CASE"

New_Hampshire_Data_LONG <- as.data.table(New_Hampshire_Data_LONG)
setkeyv(New_Hampshire_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID", "GRADE", "SCALE_SCORE"))
setkeyv(New_Hampshire_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))
New_Hampshire_Data_LONG[["VALID_CASE"]][which(duplicated(New_Hampshire_Data_LONG))-1] <- "INVALID_CASE"
New_Hampshire_Data_LONG[["VALID_CASE"]][New_Hampshire_Data_LONG$InvalidSessions != 0] <- "INVALID_CASE"

New_Hampshire_Data_LONG$InvalidSessions <- NULL


### Convert back to data.frame and Save output

New_Hampshire_Data_LONG <- as.data.frame(New_Hampshire_Data_LONG)
save(New_Hampshire_Data_LONG, file="Data/New_Hampshire_Data_LONG.Rdata")

