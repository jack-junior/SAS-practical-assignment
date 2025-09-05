/* ====================================================
   Assignment 2 - Data Cleaning and Transformation
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
ods pdf file="/home/u64176007/sas_pratical_assignment/assignment_2_cleaning_and_transformation/assignment_2_output.pdf"
        style=journal;
        
proc odstext;
    p "Assignment 2 - Data Cleaning and Transformation" / style=[font_weight=bold];
    p "Author   : Gayi Komi Selassi";
    p "ID       : RA2422021010003";
    p "Program  : MSc Epidemiology & Biostatistics";
    p "Portfolio: ^{style [url='https://sites.google.com/view/gayikomiselassi/home'] Click Here}";
 run; 

/* Disable automatic page breaks initially */
ods pdf startpage=never;  

/* Custom footer*/
footnote j=l "GAYI KOMI SELASSI, RA2422021010003, MSc Epidemiology & Biostatistics";

/* Cover page title */
title "Exploratory Analysis of the HEART Dataset: Assignment 2";

/* Links to GitHub*/
proc odstext;
    p "Access the GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
run;


/* ----------------------------------------------------
   Step 2. Create New Variables (Age_Group, Heart_Disease)
   ---------------------------------------------------- */
/* Define library */
libname data '/home/u64176007/sas_pratical_assignment/data';

data data.data_assignment_2;
   set data.heart;
   
   /* Ensure proper variable lengths */
   length Age_Group $12 Heart_Disease $5;
   
   /* 1. Create Age_Group variable */
   if age < 40 then Age_Group = "Young";
   else if 40 <= age <= 60 then Age_Group = "Middle-Aged";
   else Age_Group = "Senior";

   /* 2. Convert target into a character variable Heart_Disease */
   if target = 0 then Heart_Disease = "No";
   else if target = 1 then Heart_Disease = "Yes";
run;


/* ----------------------------------------------------
   Step 3. Display Sample of New Variables
   ---------------------------------------------------- */

proc odstext;
    p "1. First 20 Observations of the new created variables:" / style=[font_weight=bold];
run;

proc print data=data.data_assignment_2(obs=20) label;
   var age Age_Group target Heart_Disease; 
   label age="Age"
         Age_Group="Age Group"
         target="Target"
         Heart_Disease="Heart Disease (Yes/No)";
run;

/* Insert interpretation comments into PDF */
proc odstext;
    p "COMMENT:" / style=[font_weight=bold];
    p "Age Group and Heart Disease character variables were successfully created";
    p "- < 40 = Young ; 40-60 = Middle-Aged  ; >60 = Senior";
    p "- target (0) = No ; target (1) = Yes";
    p "Labels were added to make variables more interpretable.";
run;
ods pdf startpage=now;


/* ----------------------------------------------------
   Step 4. Check Missing Values
   ---------------------------------------------------- */

proc odstext;
    p "2. Check for missing values in the new variables using missin option in te frequency procedure :" / style=[font_weight=bold];
run;

proc freq data=data.data_assignment_2;
   tables Age_Group Heart_Disease / missing;
run;

proc odstext;
    p "COMMENT:" / style=[font_weight=bold];
    p "No missing value were identify in te new created variables";
    p " ";
    p " ";
    
run;

/* ----------------------------------------------------
   Step 5. Add References (Links)
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
