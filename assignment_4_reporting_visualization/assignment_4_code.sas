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
ods graphics / reset=all;                

/* Disable automatic page breaks initially */
ods pdf startpage=never; 

proc odstext;
    p "Assignment 4 - Reporting and Visualization" / style=[font_weight=bold];
    p "Author   : Gayi Komi Selassi";
    p "ID       : RA2422021010003";
    p "Program  : MSc Epidemiology & Biostatistics";
    p "Portfolio: ^{style [url='https://sites.google.com/view/gayikomiselassi/home'] Click Here}";
 run; 


/* Cover page title */
title "Exploratory Analysis of the HEART Dataset: Reporting and Visualization";

/* Links to GitHub and Portfolio */
proc odstext;
    p "Access the GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
run;


/* ----------------------------------------------------
   Step 2. Create a bar chart showing counts of patients 
   by Heart_Disease status.
   ---------------------------------------------------- */

/* 1. Define library */
libname data '/home/u64176007/sas_pratical_assignment/data';

data data.data_assignment_4;
   set data.data_assignment_2;

proc odstext;
    p "1. Count of Patients by Heart Disease Status :" / style=[font_weight=bold];
run;
   
proc sgplot data=data.data_assignment_4;
    title2 "Count of Patients by Heart Disease Status";
    vbar Heart_Disease ;
    xaxis label= "Heart Disease Status";
    yaxis label="Count" grid;
    
run;

ods pdf startpage=now;

/* ----------------------------------------------------
   Step 3. Box Plot of Cholesterol by Heart Disease
   ---------------------------------------------------- */

proc odstext;
    p " 2. Box Plot of Cholesterol by Heart Disease :" / style=[font_weight=bold];
run;

proc sgplot data=data.data_assignment_4;
    title2 "Box Plot of Cholesterol by Heart Disease";
    vbox chol / category=Heart_Disease;
    xaxis label="Heart Disease Status";
    yaxis label="Cholesterol (mg/dL)" grid;
run;

ods pdf startpage=now;


/* ----------------------------------------------------
   Step 4. Scatter Plot of Age vs. Cholesterol by Heart Disease
   ---------------------------------------------------- */

proc odstext;
    p " 3. Scatter Plot of Age vs. Cholesterol by Heart Disease:" / style=[font_weight=bold];
run;

proc sgplot data=data.data_assignment_3;
    title2 "Scatter Plot of Age vs. Cholesterol by Heart Disease";
    scatter x=age y=chol / group=Heart_Disease ;
    xaxis label="Age";
    yaxis label="Cholesterol (mg/dL)";
run;



ods pdf startpage=now;


  

/* ----------------------------------------------------
   Step 5. References (Links)
   ---------------------------------------------------- */

proc odstext;
    p "GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
    p "Portfolio: ^{style [url='https://sites.google.com/view/gayikomiselassi/home'] Click Here}";
run;


/* ----------------------------------------------------
   Step 6. Close Output
   ---------------------------------------------------- */
ods pdf close;
title;
footnote;
