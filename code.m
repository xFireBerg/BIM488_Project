clear all
clc
% Lemmatizer
commandStr = 'python Stem.py';
[status, commandOut] = system(commandStr);
if status==0
    %fprintf('squared result is %d\n',str2num(commandOut));
end
% Read file
legitimateFile = "sms_legitimate.txt";
spamFile = "sms_spam.txt";
legitimate = extractFileText(legitimateFile);
spam = extractFileText(spamFile);

% Split line by line
legitimateData = split(legitimate,newline);
spamData = split(spam,newline);

%size of data
sizeL=size(legitimateData,1);
sizeS=size(spamData,1);

% Combine two data
data(1:sizeL,1)=legitimateData;
data(sizeL+1:sizeL+sizeS,1) = spamData;

% Label
label(1:sizeL,1:1) = ["legitimate"];
label(sizeL+1:sizeL+sizeS,1:1) = ["spam"];

%convert to tablo to be able to use cvpartition
data(:,2)=label;
data = array2table(data,...
    'VariableNames',{'sms' 'label'});



% Divide train-test
cvp = cvpartition(data.label,'Holdout',0.3);
dataTrain = data(cvp.training,:);
dataTest = data(cvp.test,:);

x_train=dataTrain.sms;
y_train=dataTrain.label;
x_test=dataTest.sms;
y_test=dataTest.label;

documents = preprocess(x_train);
bag = bagOfWords(documents);
bag = removeInfrequentWords(bag,2);
[bag,idx] = removeEmptyDocuments(bag); % We don't have empty Document prob.
y_train(idx) = [];
bag


x_train = bag.Counts;
mdl = fitcecoc(x_train,y_train,'Learners','linear');

% --------------------------------Test Classifier--------------------------------

documentsTest = preprocess(x_test);
x_test = encode(bag,documentsTest);


y_pred = predict(mdl,x_test);
acc = sum(y_pred == y_test)/numel(y_test)


% NEW DATA FOR TEST
str = [ ...
    "Hac� nerdesin yahu."
    "Ankara Grand Hotel b�y�k indirimi ka��rmay�n. Hepinizi a��l���m�za bekliyoruz b�y�k indirim var."
    "La bu i� bas��m�za bela oldu."
    "ESK�SEH�R HAMAM b�y�k indirim, bu firsat ka�maz."
    ];
documentsNew = preprocess(str);
XNew = encode(bag,documentsNew);
labelsNew = predict(mdl,XNew)

function documents = preprocess(textData)
%match = [" da"," ki"," ve"," veya"," ile"," en"," de"];

% Tokenize the text.
documents = tokenizedDocument(textData);

% Adding title like adverb-adjective-noun-verb
documents = addPartOfSpeechDetails(documents);

% Bunu T�rk�eye g�re d�zenlememiz laz�m
documents = removeStopWords(documents);


% remove the words that in the match
%documents = erase(documents,match);

% Lemmatizer (This is not work for Turkish, alternative solution used begining of the code, python Code that doint lemmatizer)
%documents = normalizeWords(documents,'Style','stem');

documents = erasePunctuation(documents); % nokta, virg�l vs. (  .,!'^+?=_  )
documents = removeShortWords(documents,2);
documents = removeLongWords(documents,10);

end