*****Author: Luis Ortiz III****
*****Date: 12/11/23*****;

*****Task 1*****;

*****Make libname statement***;

Libname lortiz "/home/u63548610/Fall 2023";

*****Access the file using the URL statement****;
Filename ncsuwolf URL "https://www4.stat.ncsu.edu/~online/ST307/Data/lortiz_house.csv";

******This PROC step is to import the datafile into SAS*****;

PROC IMPORT datafile = ncsuwolf
replace
dbms = csv
out = work.import;
getnames = yes;
RUN;

***This is the start of the datastep that will copy the bean dataset from permanent to temporary library.;

DATA work.import;
SET work.import;

****This removes observations where the MoSold variable takes on a value less than or equal to 4.***;

IF (MoSold <= 4) THEN DELETE;

*****This is used to create a new variable with a name of my choosing and divided by 10000***;

PriceInMillions = SalesPrice/10000;

*****This is used to drop the variables.*****;

DROP BsmtUnfSF;
DROP RoofMatl;
RUN;

****This step is using a PROC step to create a scatter plot on the x and y axis and colors them****;

PROC SGPLOT DATA = work.import;
SCATTER X = YearRemodAdd Y = SalePrice/GROUP = ExterQual;
RUN;

****From this PROC step above, I can observe that the year 2000 for the variable YearRemodAdd has the most residual plots****;

****From this PROC step above, I will observe that the variable GrLivArea has the most plots between 1000 and 2000*****;

****This step is used to fit a multiple linear regression model using SalePrice as the response varibale with YearRemodAdd and GrLivArea as predictors****;
PROC GLM DATA = work.import plots = all;
model SalePrice = YearRemodAdd GrLivArea/CLPARM;
RUN;
quit;

****What is the interpretation of the 95% confidence interval?**** We are 95% confident that the true slope between 1200.926 and 1541.188*****;
****The fitted line is y = -2670461.931 + 1371.057(YearRemodAdd) + 87.073(GrLivArea)******;



*********Task 2*********;


*******https://catalog.data.gov/dataset/retail-food-stores;

*******This dataset is of interest to me because of the fact that as 
*******a marketer, I will use this data from New York to understand where consumers make purchases across the state in terms of retail food stores;

****Observing the variables, county, operation type, establishment type, street name, city, and state is categorical.;
****Establishment type of whether if the establishment is a JAC, JACK, A, or JABC.;
****Operation type is if it is a store or another type of place to sell products.;
****License number, zip code, street number, and georeference are quantitative variables.;
*******https://catalog.data.gov/dataset/retail-food-stores;

*****Make a libname statement*****;
Libname ncsu "/home/u63548610/Fall 2023";

*******Access the file using URL:;
FILENAME FOOD '/home/u63548610/Fall 2023/Retail_Food_Stores.csv';

****This proc step is used to import the datafile****;
PROC IMPORT REPLACE DATAFILE = "/home/u63548610/Fall 2023/Retail_Food_Stores.csv"
DBMS = CSV
OUT = work.import;
GETNAMES = YES;
RUN;

PROC CONTENTS DATA = work.import;
RUN;

***This is the start of the datastep that will copy the bean dataset from permanent to temporary library.;
data work.import; 
set work.import;

***This is used to rename variables to suffice with SAS standards.;
rename 
'Zip Code'n = zip_code
'Street Number'n = street_number
'License Number'n = license_number
'Operation Type'n = operation_type
'Street Name'n = street_name
'Square Footage'n = square_footage
'Establishment Type'n = establishment_type;
run;

****This code is used to display which counties have the most stores to carry the product and the percentage of each.;
****Looking at this code, I was surprised I had to rename variables of this length.;

PROC FREQ DATA = work.import;
TABLES county;
RUN; 

***This PROC step explains how many stores have a certain amount of frequency across the state of NY without cumulative percentages.;
 
PROC FREQ DATA = work.import;
TABLES square_footage/nopercent nocum;
RUN;

****This PROC step is used to calculate the number, mean, median, std, min, and max of the square footage.;

PROC MEANS DATA = work.import N MEAN STD MIN MAX;
VAR square_footage;
RUN;


***This barplot describes which county has the most stores for the product;

PROC SGPLOT DATA = work.import;
VBAR county;
run;

****Which county has the stores for the product to be marketed? The answer is Kings.;
****Observing this code, I was surprised that Kings county had a significantly larger amount of stores to sell a product.;

***This code discusses which establishment type in the state of New York has the most square footage.;


PROC SGPANEL DATA = work.import;
PANELBY state;
SCATTER X = establishment_type y = square_footage/group = county;
RUN;

****Using the previous code to fit into a linear regression model*****;

PROC GLM DATA = work.import PLOTS(MAXPOINTS=500000)= all;
CLASS establishment_type;
model square_footage = establishment_type/CLPARM;
RUN;
QUIT;

Data work.import;
Set work.import;
log_square_footage_plus5 = log(square_footage + 5);
run;

****This GLM procedure also is from previous line saboved modified to re-analyze the data*****;

PROC GLM DATA = work.import PLOTS(MAXPOINTS=500000) = all;
CLASS establishment_type;
model log_square_footage_plus5 = establishment_type/CLPARM;
RUN;
QUIT;

*******Because the P value is small, we can conclude that at least one mean differs*****;

****Which establishment type has the most square footage in the state of NY so it can be marketed? The answer is the JAC one with 500,000 square feet compared to JABC having 350,000 square feet.; 

*****Is there a relationship between the independent and dependent variables? Between log_square_footage_5 and establishment_type, there is a relationship because there is significance.;
*****Between square_footage and establishment_type, there is a relationship as there is also significance between the two variables.;
*****log_square_footage_5 and square_footage are numeric variables.;

****Looking at the graph, I was shocked to see one establishment type have a significantly larger size of square footage.;

