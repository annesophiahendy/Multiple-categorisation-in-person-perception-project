* Encoding: UTF-8.

******************************************************************************************
Open data file - Trimmed Evaluations 10Oct2017 and run the following syntax
******************************************************************************************

*Recodes keyboard codes into meaninfulg metric. 'Yes' answers become 1. 'No' answers become 0.

recode response 
(18 = 1) (23 = 0)
into Answer.

execute. 



*Recodes different label orders into the same groups.

recode stimulusitem1 
('Pro-green movement  Pro-gay marriage' = 1)
('Pro-green movement  Anti-gay marriage' = 3)
('Anti-green movement  Pro-gay marriage' = 2)
('Anti-green movement  Anti-gay marriage' = 4)
('Pro-gay marriage  Pro-green movement' = 1)
('Anti-gay marriage  Pro-green movement' = 3)
('Pro-gay marriage  Anti-green movement' = 2)
('Anti-gay marriage  Anti-green movement' = 4)
into TargetGroup.

execute. 



*sorts data to organize file for next command

SORT CASES BY subject(A) TrialCode(A) TargetGroup(A).



*Createds new data file 'TEMP' that sums participants' answers about the four different groups for both questions.

DATASET DECLARE TEMP.
AGGREGATE
  /OUTFILE='TEMP'
  /BREAK=subject TrialCode TargetGroup
  /Answer_sum=SUM(Answer).

*Tranforms the data file so that it is one row per subject. 

DATASET ACTIVATE TEMP.
CASESTOVARS 
/ID = subject.



*Assigns labels to Key variables. P and A stand for Pro and Anti. Ga and Gr stand for Gay and Green. Gut and Con stand for gut decision and considered decision. 

VARIABLE LABELS answer_sum.1 'P_Ga P_Gr Gut'.
VARIABLE LABELS answer_sum.2 'P_Ga A_Gr Gut'.
VARIABLE LABELS answer_sum.3 'A_Ga P_Gr Gut'.
VARIABLE LABELS answer_sum.4 'A_Ga A_Gr Gut'.
VARIABLE LABELS answer_sum.5 'P_Ga P_Gr Con'.
VARIABLE LABELS answer_sum.6 'P_Ga A_Gr Con'.
VARIABLE LABELS answer_sum.7 'A_Ga P_Gr Con'.
VARIABLE LABELS answer_sum.8 'A_Ga A_Gr Con'.


******************************************************************
*1.Open Data file Demographics 10Oct2017
*2. Merge TEMP into the Demographics data file. 
*    Data -> Merge Files -> Add variables
*    Then match by subject number
*3. Run the syntax below.
****************************************************************** 



*Recodes participants group memberships to identify participants who were pro-gay marraige.

Recode
gayGroup 
('I am pro-gay marriage' = 1) (else = 0)
into GayIngroup. 



*Recodes participants group memberships to identify participants who were pro-green movement.

Recode
GreenGroup 
('I am pro-green movement' = 1) (else = 0)
into GreenIngroup. 

Execute.


*Filters out participants who are not pro-gay marraige or pro-green movement.

*Recodes participants group memberships to identify participants who were Anti-gay marraige - DEACTIVATED
*
Recode
gayGroup
('I am anti-gay marriage' = 1) (else = 0)
into AntiGay. 
*
Execute. 

*Recodes participants group memberships to identify participants who were Anti-green movement - DEACTIVATED
*
Recode
GreenGroup
('I am anti-green movement' = 1) (else = 0)
into AntiGreen. 
*
Execute.


*Filters out participants who are not pro-gay marraige or pro-green movement.

USE ALL.
COMPUTE filter_$=(GayIngroup = 1 and GreenIngroup = 1 and subject ~='09fm' and subject ~= '13vp').
VARIABLE LABELS filter_$ 'GayIngroup = 1 and GreenIngroup = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

