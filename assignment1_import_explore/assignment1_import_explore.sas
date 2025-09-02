/* 1. Create user-defined library */
libname data '/home/u64176007/SAS pratical assinment/data';

/* 2. Import CSV */
proc import datafile="/home/u64176007/SAS pratical assinment/data/heart.csv"
    out=data.heart
    dbms=csv
    replace;
    getnames=yes;
run;

/* 3. Enable escape character for hyperlinks */
ods escapechar="^";

/* 4. Define PDF output */
ods pdf file="/home/u64176007/SAS pratical assinment/assignment1_import_explore/results/assigment_1_output.pdf"
        style=journal;

/* Disable automatic page breaks */
ods pdf startpage=never;

/* 5. Assign descriptive labels */
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

/* 6. Custom footer with your info (static text) */
footnote j=l "GAYI KOMI SELASSI, RA2422021010003, MSc Epidemiology & Biostatistics";

/* 7. Cover page */
title "Exploratory Analysis of the HEART Dataset";

/* 8. Add clickable links using PROC ODSTEXT */
proc odstext;
    p "Access the GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
    p "Portfolio: ^{style [url='https://sites.google.com/view/gayikomiselassi/home'] Click Here}";
run;

/* 9. First 10 observations */
proc odstext;
    p "First 10 Observations of the HEART Dataset:" / style=[font_weight=bold];
run;
/* title2 "First 10 Observations of the HEART Dataset"; */
proc print data=data.heart(obs=10) noobs label;
run;

/* If you want a new page after this block, you can enable it */
ods pdf startpage=now;

/* 10. Variable metadata */
title2 "Variable Attributes and Metadata";
proc contents data=data.heart varnum;
run;
ods pdf startpage=now;

/* 11. Insert interpretation comments into PDF */
proc odstext;
    p "COMMENT:" / style=[font_weight=bold];
    p "All variables are numeric (Type = Num).";
    p "Length (Len=8) indicates the memory allocated per variable.";
    p "Format/Informat = BEST12. means values are displayed with default numeric formatting.";
    p "Labels were added to make variables more interpretable.";
run;
ods pdf startpage=now;

/* 12. Summary statistics */
title2 "Summary Statistics (Mean, Median, Minimum, Maximum)";
proc means data=data.heart mean median min max maxdec=2;
run;

ods pdf startpage=now;

/* 13. Missing values */
title2 "Missing Values by Variable";
proc means data=data.heart n nmiss;
run;

/* Add clickable links using PROC ODSTEXT */
proc odstext;
    p "GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
    p "Portfolio: ^{style [url='https://sites.google.com/view/gayikomiselassi/home'] Click Here}";
run;

/* 14. Close PDF */
ods pdf close;
title;
footnote;
