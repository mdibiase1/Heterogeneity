clear all
close all


% similarities discrepancies for older (Ye's codes) ICD9 and new ICD9
run('Set_data_path.m');

prompt = "Please specify user for path definition purposes\nFor Maria press 1\nFor Ye press 2\nFor Hadis press 3\nFor others press 4\n";
x = input(prompt);


% change paths for the corresponding user
switch x
    case 1
        In_private = In_private_Maria;
        In_open = In_open_Maria;
        path_old_dx = path_old_dx_Maria;
        Out_open = Out_open_Maria;
    case 2
        In_private = In_private_Ye;
        In_open = In_open_Ye;
        path_old_dx = path_old_dx_Ye;
    case 3
        In_private = In_private_Hadis;
        In_open = In_open_Hadis;
        path_old_dx = path_old_dx_Hadis;
    otherwise
        In_private = In_private_Other;
        In_open = In_open_Other;
        path_old_dx = path_old_dx_Other;
end

filename = [Out_open 'vars_to_crosscheck.mat'];
load(filename);

load([path_old_dx,'DiseaseCode2.mat'])


labels_new_icd9 = cell(0);
description_new_icd9=cell(0);
code_new_icd9 = cell(0);
cross_check_icd9 = cell(0);
description_old_icd9 = cell(0);
code_old_icd9 = cell(0);

for i=1:length(dGrp)
    idc = find(contains(dx_labels, caseInsensitivePattern(dGrp(i))));
    idx = (idc(1));
    code9_trimmed=string(code9{i});

    % find codes and descriptions that are present in both versions 1 and 2
    [overlapping_code ind_code_icd9_v2 ind_code9]=intersect(code_icd9_v2{idx},code9_trimmed);
    [a1, a2, ~] = intersect(convertCharsToStrings(txt_icd9(:,1)), overlapping_code);

    
    % find codes and descriptions that are present in version 1 but not in
    % version 2
    [discrepant_code ind]=setdiff(code9_trimmed, code_icd9_v2{idx});
    [x1, x2, ~] = intersect(convertCharsToStrings(txt_icd9(:,1)), discrepant_code);

    % find codes and descriptions that are present in version 2 but not in
    % version 1
    [discrepant_code_v2 ind_v2]=setdiff(code_icd9_v2{idx}, code9_trimmed);
    [x1_v2, x2_v2, ~] = intersect(convertCharsToStrings(txt_icd9(:,1)), discrepant_code_v2);

    cross_check_overlaps = cell(length(overlapping_code),1);
    cross_check_overlaps(:) = {'overlaps'};

    cross_check_missing = cell(length(x1_v2),1);
    cross_check_missing(:) = {'missing'};

    description_new_tmp = [txt_icd9(a2,2); txt_icd9(x2_v2,2)];
    code_new_tmp = [txt_icd9(a2,1); txt_icd9(x2_v2,1)];
    cross_check_tmp = [cross_check_overlaps; cross_check_missing];
    description_old_tmp = [txt_icd9(x2,2);];
    code_old_tmp = [txt_icd9(x2,1);];

    add_empties = length(description_new_tmp)-length(description_old_tmp);
    empties = cell(abs(add_empties),1);
    empties(:) = {''};
    if add_empties > 0
        description_old_tmp = [description_old_tmp; empties];
        code_old_tmp = [code_old_tmp; empties];
    elseif add_empties < 0
        description_new_tmp = [description_new_tmp; empties];
        code_new_tmp = [code_new_tmp; empties];
        cross_check_tmp = [cross_check_tmp; empties];

    end
    
    labels_tmp = cell(length(description_new_tmp),1);
    labels_tmp(:) = dGrp(i);
    labels_new_icd9=[labels_new_icd9; labels_tmp]; 
    description_new_icd9 = [description_new_icd9; description_new_tmp];
    code_new_icd9 = [code_new_icd9; code_new_tmp];
    cross_check_icd9 = [cross_check_icd9; cross_check_tmp];
    description_old_icd9 = [description_old_icd9; description_old_tmp];
    code_old_icd9 = [code_old_icd9; code_old_tmp];
end


% new diseases for ICD9

description_others = cell(0);
code_others = cell(0);
label_others = cell(0);

for i=1:length(dx_labels)
    if (contains(dx_labels(i), caseInsensitivePattern(dGrp))) 
        continue
    end
    description_others= [description_others; description_icd9{i}];
    code_others = [code_others; code_icd9_v2{i}];
    labels_tmp = cell(length(description_icd9{i}),1);
    labels_tmp(:)=dx_labels(i);
    label_others = [label_others; labels_tmp];
end
cross_check_others = cell(length(description_others),1);
cross_check_others(:) = {''};
description_old_others  =cell(length(description_others),1);
description_old_others(:) = {''};
code_old_others  = cell(length(description_others),1);
code_old_others(:) = {''};

labels_new_icd9 = [labels_new_icd9; label_others];
description_new_icd9 = [description_new_icd9; description_others];
code_new_icd9 = [code_new_icd9; code_others];
cross_check_icd9 = [cross_check_icd9; cross_check_others];
description_old_icd9 = [description_old_icd9; description_old_others];
code_old_icd9 = [code_old_icd9; code_old_others];


% similarities discrepancies for older ICD10 and new ICD10

labels_new_icd10 = cell(0);
description_new_icd10=cell(0);
code_new_icd10 = cell(0);
cross_check_icd10 = cell(0);
description_old_icd10 = cell(0);
code_old_icd10 = cell(0);

for i=1:length(dGrp)
    idc = find(contains(dx_labels, caseInsensitivePattern(dGrp(i))));
    idx = (idc(1));
    code10_trimmed=strtrim(string(code10{i}));

    % find codes and descriptions that are present in both versions 1 and 2
    [overlapping_code ind_code_icd10_v2 ind_code10]=intersect(code_icd10_v2{idx},code10_trimmed);
    [a1, a2, ~] = intersect(convertCharsToStrings(txt_icd10(:,1)), overlapping_code);

    % find codes and descriptions that are present in version 1 but not in
    % version 2
    [discrepant_code ind]=setdiff(code10_trimmed, code_icd10_v2{idx});
    [x1, x2, ~] = intersect(convertCharsToStrings(txt_icd10(:,1)), discrepant_code);

    % find codes and descriptions that are present in version 2 but not in
    % version 1
    [discrepant_code_v2 ind_v2]=setdiff(code_icd10_v2{idx}, code10_trimmed);
    [x1_v2, x2_v2, ~] = intersect(convertCharsToStrings(txt_icd10(:,1)), discrepant_code_v2);

    cross_check_overlaps = cell(length(a1),1);
    cross_check_overlaps(:) = {'overlaps'};

    cross_check_missing = cell(length(x1_v2),1);
    cross_check_missing(:) = {'missing'};

    description_new_tmp = [txt_icd10(a2,5); txt_icd10(x2_v2,5)];
    code_new_tmp = [txt_icd10(a2,1); txt_icd10(x2_v2,1)];
    cross_check_tmp = [cross_check_overlaps; cross_check_missing];
    description_old_tmp = [txt_icd10(x2,5);];
    code_old_tmp = [txt_icd10(x2,1);];

    add_empties = length(description_new_tmp)-length(description_old_tmp);
    empties = cell(abs(add_empties),1);
    empties(:) = {''};
    if add_empties > 0
        description_old_tmp = [description_old_tmp; empties];
        code_old_tmp = [code_old_tmp; empties];
    elseif add_empties < 0
        description_new_tmp = [description_new_tmp; empties];
        code_new_tmp = [code_new_tmp; empties];
        cross_check_tmp = [cross_check_tmp; empties];
    end

    labels_tmp = cell(length(description_new_tmp),1);
    labels_tmp(:) = dGrp(i);
    labels_new_icd10=[labels_new_icd10; labels_tmp]; 
    description_new_icd10 = [description_new_icd10; description_new_tmp];
    code_new_icd10 = [code_new_icd10; code_new_tmp];
    cross_check_icd10 = [cross_check_icd10; cross_check_tmp];
    description_old_icd10 = [description_old_icd10; description_old_tmp];
    code_old_icd10 = [code_old_icd10; code_old_tmp];
    
end

% new diseases for ICD10

description_others = cell(0);
code_others = cell(0);
label_others = cell(0);

for i=1:length(dx_labels)
    if (contains(dx_labels(i), caseInsensitivePattern(dGrp))) 
        continue
    end
    description_others= [description_others; description_icd10{i}];
    code_others = [code_others; code_icd10_v2{i}];
    labels_tmp = cell(length(description_icd10{i}),1);
    labels_tmp(:)=dx_labels(i);
    label_others = [label_others; labels_tmp];
end
cross_check_others = cell(length(description_others),1);
cross_check_others(:) = {''};
description_old_others  =cell(length(description_others),1);
description_old_others(:) = {''};
code_old_others  = cell(length(description_others),1);
code_old_others(:) = {''};

description_new_icd10 = [description_new_icd10; description_others];
code_new_icd10 = [code_new_icd10; code_others];
cross_check_icd10 = [cross_check_icd10; cross_check_others];
description_old_icd10 = [description_old_icd10; description_old_others];
code_old_icd10 = [code_old_icd10; code_old_others];
labels_new_icd10 = [labels_new_icd10; label_others];

filename = [Out_open 'description_codes_v1_v2.xlsx'];
T_icd9 = table(labels_new_icd9, description_new_icd9, code_new_icd9, cross_check_icd9, description_old_icd9, code_old_icd9);
T_icd10 = table(labels_new_icd10, description_new_icd10, code_new_icd10, cross_check_icd10, description_old_icd10, code_old_icd10);

writetable(T_icd9, filename, 'Sheet', 'icd9','Range','A1');
writetable(T_icd10, filename, 'Sheet', 'icd10','Range','A1');