/* ====================================================
   Assignment 1 - Import and Explore Data
   Author   : Gayi Komi Selassi
   ID       : RA2422021010003
   Program  : MSc Epidemiology & Biostatistics
   ==================================================== */

/* ----------------------------------------------------
   Step 1. Create User-Defined Library & Import Data
   ---------------------------------------------------- */

/* 1. Define library */
libname data '/home/u64176007/sas_pratical_assignment/data';

/* 2. Import CSV into SAS dataset */
proc import datafile="/home/u64176007/sas_pratical_assignment/data/heart.csv"
    out=data.heart
    dbms=csv
    replace;
    getnames=yes;
run;


/* ----------------------------------------------------
   Step 2. Setup ODS for PDF Output
   ---------------------------------------------------- * 
 
/* Escape character for clickable links */
ods escapechar="^";

/* Define PDF output file */
ods pdf file="/home/u64176007/sas_pratical_assignment/assignment_1_import_explore/assignment_1_output.pdf"
        style=journal;
        
proc odstext;
    p "Assignment 1 - Import and Explore Data" / style=[font_weight=bold];
    p "Author   : Gayi Komi Selassi";
    p "ID       : RA2422021010003";
    p "Program  : MSc Epidemiology & Biostatistics";
    p "Portfolio: ^{style [url='https://sites.google.com/view/gayikomiselassi/home'] Click Here}";
 run;        

/* Disable automatic page breaks initially */
ods pdf startpage=never;

/* Add footer with student information */
footnote j=l "GAYI KOMI SELASSI, RA2422021010003, MSc Epidemiology & Biostatistics";

/* Cover page title */
title "Exploratory Analysis of the HEART Dataset: Assignment 1";

/* Links to GitHub and Portfolio */
proc odstext;
    p "Access the GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
run;


/* ----------------------------------------------------
   Step 3. Add Descriptive Labels to Variables
   ---------------------------------------------------- */

proc datasets library=data nolist;
    modify heart;
    label 
        age      = "Age (years)"
        sex      = "Sex (0 = Female, 1 = Male)"
        cp       = "Chest Pain Type"
        trestbps = "Resting Blood Pressure (mm Hg)"
        chol     = "Serum Cholesterol (mg/dL)"
        fbs      = "Fasting Blood Sugar > 120 mg/dL (1 = Yes, 0 = No)"
        restecg  = "Resting Electrocardiographic Results"
        thalach  = "Maximum Heart Rate Achieved"
        exang    = "Exercise Induced Angina (1 = Yes, 0 = No)"
        oldpeak  = "ST Depression Induced by Exercise"
        slope    = "Slope of Peak Exercise ST Segment"
        ca       = "Number of Major Vessels Colored by Fluoroscopy"
        thal     = "Thalassemia (3 = Normal, 6 = Fixed Defect, 7 = Reversible Defect)"
        target   = "Heart Disease Diagnosis (1 = Disease, 0 = No Disease)";
quit;


/* ----------------------------------------------------
   Step 4. Explore the Dataset
   ---------------------------------------------------- */

/* First 10 observations */
proc odstext;
    p "1. First 10 Observations of the HEART Dataset:" / style=[font_weight=bold];
run;

proc print data=data.heart(obs=10) noobs label;
run;

ods pdf startpage=now;


/* ----------------------------------------------------
   Step 5. Variable Metadata
   ---------------------------------------------------- */

title2 "2. Variable Attributes and Metadata";

proc contents data=data.heart varnum;
run;

ods pdf startpage=now;


/* ----------------------------------------------------
   Step 6. Interpretation of Metadata
   ---------------------------------------------------- */

proc odstext;
    p "COMMENT:" / style=[font_weight=bold];
    p "All variables are numeric (Type = Num).";
    p "Length (Len=8) indicates the memory allocated per variable.";
    p "Format/Informat = BEST12. means values are displayed with default numeric formatting.";
    p "Labels were added to make variables more interpretable.";
run;

ods pdf startpage=now;


/* ----------------------------------------------------
   Step 7. Summary Statistics
   ---------------------------------------------------- */

title2 "3. Summary Statistics (Mean, Median, Minimum, Maximum)";

proc means data=data.heart mean median min max maxdec=2;
run;

ods pdf startpage=now;


/* ----------------------------------------------------
   Step 8. Missing Values Analysis
   ---------------------------------------------------- */

title2 "4. Missing Values by Variable";

proc means data=data.heart n nmiss;
run;


/* ----------------------------------------------------
   Step 9. Add References (Links)
   ---------------------------------------------------- */

proc odstext;
    p "GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
    p "Portfolio: ^{style [url='https://sites.google.com/view/gayikomiselassi/home'] Click Here}";
run;


/* ----------------------------------------------------
   Step 10. Close PDF
   ---------------------------------------------------- */

ods pdf close;
title;
footnote;
