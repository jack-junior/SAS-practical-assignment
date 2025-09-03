/* ====================================================
   Assignment 4 - Reporting and Visualization
   Author   : Gayi Komi Selassi
   ID       : RA2422021010003
   Program  : MSc Epidemiology & Biostatistics
   ==================================================== */

/* ----------------------------------------------------
   Step 1. Setup ODS for Output
   ---------------------------------------------------- */

/* Escape character for hyperlinks */
ods escapechar="^";

/* Define PDF output file */
ods pdf file="/home/u64176007/sas_pratical_assignment/assignment_4_reporting_visualization/assignment_4_output.pdf"
        style=journal;

/* Disable automatic page breaks initially */
ods pdf startpage=never;  

/* Custom footer*/
footnote j=l "GAYI KOMI SELASSI, RA2422021010003, MSc Epidemiology & Biostatistics";

/* Cover page title */
title "Exploratory Analysis of the HEART Dataset: Data Analysis";

/* Links to GitHub and Portfolio */
proc odstext;
    p "Access the GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
    p "Portfolio: ^{style [url='https://sites.google.com/view/gayikomiselassi/home'] Click Here}";
run;


/* ----------------------------------------------------
   Step 2. 
   ---------------------------------------------------- */

data data.data_assignment_2;
   set data.heart;
   
   proc sgplot data=data.data_assignment_3;
    title "Count of Patients by Heart Disease Status";
    vbar Heart_Disease / response=Count stat=count;
    xaxis display=(nolabel);
    yaxis label="Count";
run;
   



/* ----------------------------------------------------
   Step 3. 
   ---------------------------------------------------- */

proc sgplot data=data.data_assignment_3;
    title "Box Plot of Cholesterol by Heart Disease";
    vbox chol / category=Heart_Disease;
    xaxis label="Heart Disease Status";
    yaxis label="Cholesterol (mg/dL)";
run;


/* Insert interpretation comments into PDF */
proc odstext;
    p "COMMENT:" / style=[font_weight=bold];
    p "";
    
run;
ods pdf startpage=now;


/* ----------------------------------------------------
   Step 4. 
   ---------------------------------------------------- */

proc odstext;
    p " :" / style=[font_weight=bold];
run;

proc sgplot data=data.data_assignment_3;
    title "Scatter Plot of Age vs. Cholesterol by Heart Disease";
    scatter x=age y=chol / group=Heart_Disease;
    xaxis label="Age";
    yaxis label="Cholesterol (mg/dL)";
run;

proc odstext;
    p "COMMENT:" / style=[font_weight=bold];
    p "";
    
run;


/* ----------------------------------------------------
   Step 5. Close Output
   ---------------------------------------------------- */
ods pdf close;
title;
footnote;
