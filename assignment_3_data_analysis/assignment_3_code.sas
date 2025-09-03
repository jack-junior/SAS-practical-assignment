/* ====================================================
   Assignment 3 - Data Analysis
   Author   : Gayi Komi Selassi
   ID       : RA2422021010003
   Program  : MSc Epidemiology & Biostatistics
   ==================================================== */


/* ----------------------------------------------------
   Step 1. Setup ODS for Output
   ---------------------------------------------------- */
proc odstext;
    p "Assignment 3 - Data Analysis" / style=[font_weight=bold];
    p "Author   : Gayi Komi Selassi";
    p "ID       : RA2422021010003";
    p "Program  : MSc Epidemiology & Biostatistics";
    p "Portfolio: ^{style [url='https://sites.google.com/view/gayikomiselassi/home'] Click Here}";
 run; 
 
/* Escape character for hyperlinks */
ods escapechar="^";

/* Define PDF output file */
ods pdf file="/home/u64176007/sas_pratical_assignment/assignment_3_data_analysis/assignment_3_output.pdf"
        style=journal;

/* Disable automatic page breaks initially */
ods pdf startpage=never;  

/* Custom footer*/
footnote j=l "GAYI KOMI SELASSI, RA2422021010003, MSc Epidemiology & Biostatistics";

/* Cover page title */
title "Exploratory Analysis of the HEART Dataset: Assignment 3";

/* Links to GitHub */
proc odstext;
    p "Access the GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
run;


/* ----------------------------------------------------
   Step 2. Frequency tables for Age_Group and Heart_Disease
   ---------------------------------------------------- */
/* 1. Define library */
libname data '/home/u64176007/sas_pratical_assignment/data';

/*Set new dataset for the assignment 3  */
data data.data_assignment_3;
   Line_Number = _N_;
   set data.data_assignment_2;
   
run;

/* set a title for the frequency table without using the global statement title */
proc odstext;
    p "1. Frequency tables for Age_Group and Heart_Disease :" / style=[font_weight=bold];
run;

/* Compute frequency */
proc freq data=data.data_assignment_3;
    tables Age_Group Heart_Disease;
    label Age_Group = "Age Group"
    	  Heart_Disease = "Heart Disease";
run;

ods pdf startpage=now;  /*Insert Break page*/


/* ------------------------------------------------------------------------
   Step 3. Average cholesterol (chol) and resting blood pressure (trestbps) 
   grouped by Heart_Disease 
   ------------------------------------------------------------------------ */

/* set a title for te frequency table witout using the globale statement title */
proc odstext;
    p "2. Average cholesterol (chol) and resting blood pressure (trestbps) grouped by Heart_Disease :" / style=[font_weight=bold];
run;

/* Compute means */
proc means data=data.data_assignment_3 mean maxdec=2;
    class Heart_Disease;
    var chol trestbps;
run;

/* Insert interpretation comments into the output PDF */
proc odstext;
    p "COMMENT:" / style=[font_weight=bold];
    p "The average cholesterol (chol) was slightly higher in patients without heart disease (251.29 mg/dL) compared to those with heart disease (240.98 mg/dL).";
    p "The average resting blood pressure (trestbps) was also higher in patients without heart disease (134.11 mm Hg) than in those with heart disease (129.25 mm Hg).";
    p "This result may appear counterintuitive, but it could be explained by treatment effects or other confounding factors (e.g., age, sex, lifestyle, or medication use).";
    p "Therefore, cholesterol and blood pressure alone are not sufficient predictors of heart disease in this dataset, and further statistical testing or multivariate analysis is recommended.";
run;

ods pdf startpage=now;


/* ----------------------------------------------------
   Step 4. Relationship between sex and Heart_Disease
   ---------------------------------------------------- */

proc odstext;
    p "3. Relationship between sex and Heart_Disease:" / style=[font_weight=bold];
run;

proc freq data=data.data_assignment_3;
    tables sex*Heart_Disease / chisq norow nocol nopercent;
    label sex      = "0 = Female, 1 = Male";
run;

proc odstext;
    p "COMMENT:" / style=[font_weight=bold];
    p "Among females (sex=0), 86 had no heart disease while 226 had heart disease.";
    p "Among males (sex=1), 413 had no heart disease while 300 had heart disease.";
    p "The Chi-Square test shows a highly significant association between sex and heart disease (Chi-Square=80.07, p<0.0001).";
    p "This suggests that sex is strongly related to the prevalence of heart disease in this dataset.";
    p "Interpretation: Females have proportionally more cases of heart disease compared to males, even though the absolute number of male patients is higher.";
    p "Effect size measures (Phi = -0.28, Cramer's V = -0.28) indicate a moderate strength of association.";
run;

ods pdf startpage=now;

/* ----------------------------------------------------
   Step 5. Top 5 oldest patients with heart disease
   ---------------------------------------------------- */

proc odstext;
    p "4. Top 5 oldest patients with heart disease with some variables:" / style=[font_weight=bold];
run;

proc sql outobs=5;
    select Line_Number, age, sex, Age_Group, Heart_Disease, trestbps, chol, restecg,  thal 
    from data.data_assignment_3
    where Heart_Disease = 'Yes'
    order by age desc;
quit;


/* ----------------------------------------------------
   Step 6. References (Links)
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
