%test

% -------------------------------- NEW DATA FOR TEST --------------------------------
str = [ ...
%     "Haci nerdesin yahu."
%     "Ankara Grand Hotel buyuk indirimi kacirmayin. Hepinizi acilisda bekliyoruz buyuk indirim var."
    "La bu is basimiza bela oldu."
%     "Eskisehir HAMAM buyuk indirim, bu firsat kacmaz."
    ];
fid = fopen('new_sms.txt', 'wt');
fprintf(fid, "%s", str);
fclose(fid);

commandStr = 'python StemTest.py';
[status, commandOut] = system(commandStr);

newSMS = extractFileText("cleaned_sms.txt")

documentsNew = preprocess(newSMS);
XNew = encode(bag,documentsNew);
labelsNew = predict(mdl,XNew)



function documents = preprocess(textData)
words = [" da" " ki" " ve" " veya" " ile" " en" " de " " ama " " ancak " " bile " " çünkü " " dahi " " demek ki " " fakat " " gene " " halbuki " " hatta " " hele " " hem " " hemde " " ise " " madem " " oysa " " oysaki " " öyleyse " " üstelik " " veyahut " " ya da " " yalnýz " " yine " " yoksa "];

% Tokenize the text.
documents = tokenizedDocument(textData);

% Adding title like adverb-adjective-noun-verb
documents = addPartOfSpeechDetails(documents);

% Bunu Türkçeye göre düzenlememiz lazým
documents = removeStopWords(documents);


% remove the words that in the match
%documents = erase(documents,match);
documents = removeWords(documents,words)

% Lemmatizer (This is not work for Turkish, alternative solution used begining of the code, python Code that doint lemmatizer)
%documents = normalizeWords(documents,'Style','stem');

documents = erasePunctuation(documents); % nokta, virgül vs. (  .,!'^+?=_  )
documents = removeShortWords(documents,2);
documents = removeLongWords(documents,10);

end