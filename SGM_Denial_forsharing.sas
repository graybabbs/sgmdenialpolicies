/*This code corresponds to "Sexual and Gender Minority University 
Students Report Distress due to Discriminatory Healthcare Policies"
as published in Stigma and Health. Any questions should be directed
to Gray Babbs (gray_babbs@brown.edu)*/

libname hms /*insert file path*/;

/*import file*/
proc import out=hms.newfile
  datafile = /*insert file path*/
  DBMS = DTA replace;
run;

/**PROC CONTENTS DATA=hms.newfile; RUN;**/

proc format;
	value sexualf 1="Heterosexual" 2="Lesbian" 3="Gay" 4="Bisexual" 5="Queer" 6="Questioning or Self-Identified";
	value gendercatf 1="Transfeminine" 2="Transmasculine" 3="Other Gender Minority AFAB" 4="Other Gender Minority AMAB" 5="Cis Man" 6="Cis Woman";
run;


/**data step**/
data hms.hms_full;
	set hms.newfile;
	if survey_2=1;
	
	/*formats*/
	format sexual sexualf. gender_cat gendercatf.;
	
	
	/*create sex_min (sexual minority) variable*/
	if sexual_bi = 1 OR 
	   sexual_g = 1 OR 
	   sexual_l = 1 OR 
	   sexual_quest = 1 OR 
	   sexual_queer = 1 OR
	   sexual_other = 1 
   		then sex_min = 1;
   		
   	if sexual_bi = . AND 
	   sexual_g = . AND 
	   sexual_l = . AND 
	   sexual_quest = . AND 
	   sexual_queer = . AND
	   sexual_other = . 
   		then sex_min = .;
   		
   if sexual_h = 1
   		then sex_min = 0;
   		
   	/*create sexual orientation categorical var*/
   	if sexual_h = 1 then sexual = 1;
   		else if sexual_l = 1 then sexual = 2;
   		else if sexual_g = 1 then sexual = 3;
   		else if sexual_bi = 1 then sexual = 4;
   		else if sexual_queer = 1 then sexual = 5;
   		else if sexual_quest = 1 then sexual = 6;
   		else if sexual_other = 1 then sexual = 6;
   		
   	/*create combined sexual_othquest var*/
   	
   	if sexual_quest = . AND sexual_other = . then sexual_othquest = .;
   		else if sexual_other = 1 then sexual_othquest = 1;
   		else if sexual_quest = 1 then sexual_othquest = 1;
   		else sexual_othquest = 0;
   	
	/*create transmasc and transfemme vars*/
	if gender = . 
		then trans_f = .;
	else if gender = 4 
		then trans_f = 1;	
	else if gender = 2 AND sex_birth = 2
		then trans_f = 1;
	else trans_f = 0;
	
	if gender = .
		then trans_m = .;
	else if gender = 3
		then trans_m = 1;
	else if gender = 1 AND sex_birth = 1
		then trans_m = 1;
	else trans_m = 0;
		
	if gender = . 
		then trans = .;
	else if trans_f = 1 OR trans_m = 1
		then trans = 1;
	else trans = 0;
		
	/*create genderqueer/gnc variable*/	
	if gender = 5 
		then gq = 1;
	else if gender = 6
		then gq = 1;
	else gq = 0;	
	
	if gq = . OR sex_birth = .
		then gq_mab = .;
	else if gq = 0 
		then gq_mab = 0;
	else if gq = 1 AND sex_birth = 1
		then gq_mab = 0;
	else if gq = 1 AND sex_birth = 2
		then gq_mab = 1;

	if gq = . OR sex_birth = .
		then gq_fab = .;
	else if gq = 0 
		then gq_fab = 0;
	else if gq = 1 AND sex_birth = 1
		then gq_fab = 1;
	else if gq = 1 AND sex_birth = 2
		then gq_fab = 0;
		
	/*create gen_min variable*/
	if gender = .
		then gen_min = .;
	else if trans = 1
		then gen_min = 1;
	else if gender = 5
		then gen_min = 1;
	else if gender = 6
		then gen_min = 1;
	else gen_min = 0;
	
	/*create categorical gender variable*/
	if gender = .
		then gender_cat = .;
	else if trans_f = 1
		then gender_cat = 1;
	else if trans_m = 1
		then gender_cat = 2;
	else if gq_fab = 1
		then gender_cat = 3;
	else if gq_mab = 1
		then gender_cat = 4;
	else if gender = 1
		then gender_cat = 5;
	else if gender = 2
		then gender_cat = 6;
		
	/*create cisman and ciswoman vars*/
	if gender_cat = .
		then cisman = .;
	else if gender_cat = 5 AND sex_birth = 2
		then cisman = 1;
	else cisman = 0;
	
	if gender_cat = .
		then ciswoman = .;
	else if gender_cat = 6 AND sex_birth = 1
		then ciswoman = 1;
	else ciswoman = 0;
	
	/*create lgbtq variable*/
	if gen_min = 1 then lgbtq = 1;
		else if sex_min = 1 then lgbtq = 1;
		else lgbtq = 0;
	

	/*create ll_disclose variables*/
	if 0<free_dis_sexual<=2 then ll_disclose_sexual = 1;
		else if 3<=free_dis_sexual<=5 then ll_disclose_sexual = 0;
	
	if 0<free_dis_gender<=2 then ll_disclose_gender = 1;
		else if 3<=free_dis_gender<=5 then ll_disclose_gender = 0;
		
	/*create disdis (distress/disclosure) variable*/
	if free_dis_sexual = 1
		then free_dis_sexual_o = 5;
	else if free_dis_sexual = 2
		then free_dis_sexual_o = 4;
	else if free_dis_sexual = 3
		then free_dis_sexual_o = 3;
	else if free_dis_sexual = 4
		then free_dis_sexual_o = 2;
	else if free_dis_sexual = 5
		then free_dis_sexual_o = 1;
	
	if free_dis_gender = 1
		then free_dis_gender_o = 5;
	else if free_dis_gender = 2
		then free_dis_gender_o = 4;
	else if free_dis_gender = 3
		then free_dis_gender_o = 3;
	else if free_dis_gender = 4
		then free_dis_gender_o = 2;
	else if free_dis_gender = 5
		then free_dis_gender_o = 1;
		
	if free_if_sexual = 11
		then free_if_sexual = .;
	if free_know_sexual = 11
		then free_know_sexual = .;
	if free_if_gender = 11
		then free_if_gender = .;
	if free_know_gender = 11
		then free_know_gender = .;
		
	disdis_sexual = sum(free_dis_sexual_o, free_if_sexual, free_know_sexual);
	disdis_gender = sum(free_dis_gender_o, free_if_gender, free_know_gender);
	
	
	if missing(free_dis_gender) & missing(free_dis_sexual) & missing(free_if_gender) & missing(free_if_sexual) & missing(free_know_gender) & missing(free_know_sexual)
		then delete;
	
run;

/*subset datasets into all lgbt, gender minority, and sexual minority*/
data hms.lgbtq;
	set hms.hms_full;
	if lgbtq = 1;
	
	if lgbtq = .
		then delete;
run;

data hms.genmin;
	set hms.lgbtq;
	if gen_min = 1;
run;

data hms.sexmin;
	set hms.lgbtq;
	if sex_min = 1;
run;


/*find sample sizes*/
proc freq data=hms.hms_full;
	tables sex_min;
run;

proc freq data=hms.hms_full;
	tables gen_min;
run;

proc freq data=hms.lgbtq;
	tables sex_min * gen_min;
run;

proc freq data=hms.lgbtq;
	tables sex_min * cisman;
run;

proc freq data=hms.lgbtq;
	tables sex_min * ciswoman;
run;

/*sex min, knowing that care could be denied*/
proc surveyfreq data = hms.sexmin;
	weight nrweight;
	tables free_know_sexual/expected row col cl;
run;

proc surveymeans data = hms.sexmin mean quartile;
	weight nrweight;
	var free_know_sexual;
run;

/*sex min, if care was denied*/
proc surveyfreq data = hms.sexmin;
	weight nrweight;
	tables free_if_sexual/expected row col cl;
run;

proc surveymeans data = hms.sexmin mean quartile;
	weight nrweight;
	var free_if_sexual;
run;


/*gen min, knowing that care could be denied*/
proc surveyfreq data = hms.genmin;
	weight nrweight;
	tables free_know_gender/expected row col cl;
run;

proc surveymeans data = hms.genmin mean quartile;
	weight nrweight;
	var free_know_gender;
run;


/*gen min, if care was denied*/
proc surveyfreq data = hms.genmin;
	weight nrweight;
	tables free_if_gender/expected row col cl;
run;

proc surveymeans data = hms.genmin mean quartile;
	weight nrweight;
	var free_if_gender;
run;

/*gen min, likelihood to disclose to a new provider*/
proc surveyfreq data = hms.genmin;
	weight nrweight;
	tables free_dis_gender/expected row col cl;
run;

proc surveymeans data = hms.genmin mean quartile;
	weight nrweight;
	var free_dis_gender;
run;

/*sex min, likelihood to disclose to a new provider*/
proc surveyfreq data = hms.sexmin;
	weight nrweight;
	tables free_dis_sexual/expected row col cl;
run;

proc surveymeans data = hms.sexmin mean quartile;
	weight nrweight;
	var free_dis_sexual;
run;

proc surveyfreq data = hms.lgbtq;
	weight nrweight;
	tables free_know_sexual/expected row col cl;
run;

/**for figures**/

/*prevent duplicates*/
data hms.genmin_ex;
	set hms.genmin;
	
	keep free_dis_sexual_o free_if_sexual free_know_sexual free_dis_gender_o free_if_gender free_know_gender gen_min sex_min group;
		
	free_dis_sexual_o=.;
	free_if_sexual=.;
	free_know_sexual=.;
	sex_min=.;
	group="gender";
	
run;
				
data hms.sexmin_ex;
	set hms.sexmin;
	
	keep free_dis_sexual_o free_if_sexual free_know_sexual free_dis_gender_o free_if_gender free_know_gender gen_min sex_min group;
		
	free_dis_gender_o=.;
	free_if_gender=.;
	free_know_gender=.;
	gen_min=.;
	group="sexual";
run;		


/*prep for export for making figures*/
data hms.forexport;
	set hms.genmin_ex hms.sexmin_ex;
	
	free_know= sum(free_know_sexual, free_know_gender);
	free_if=sum(free_if_sexual,free_if_gender);
	/*free_dis=sum(free_dis_sexual_o,free_dis_gender_o);*/
	
run;

proc means data=hms.forexport;
	var free_if_sexual;
run;
	
proc export data=hms.forexport
     outfile="/home/u45189067/HMS/forexport.csv"
     dbms=csv 
     replace;
run;