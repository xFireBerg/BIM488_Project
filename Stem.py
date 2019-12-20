import os
import re
from TurkishStemmer import TurkishStemmer


legitFile = open("./sms_legitimate.txt", "r", encoding="utf-8")
cleanedFile = open("./cleaned_legit.txt", "w+", encoding="utf-8")

spamFile = open("./sms_spam.txt", "r", encoding="utf-8")
cleanedSpam = open("./cleaned_spam.txt", "w+", encoding="utf-8")

stemmer = TurkishStemmer()
  
with open("./cleaned_legit.txt", "a+", encoding="utf-8") as f:
	for i in range(430):
		cleaned_words = ""
		line = legitFile.readline()
		line = line.lower()
		words = re.split('[;,.-: /()?]', line)
		for j in words:
			cleaned_words += stemmer.stem(j) + " "
		f.write(cleaned_words)

with open("./cleaned_spam.txt", "a+", encoding="utf-8") as f:
	for i in range(420):
		cleaned_words = ""
		line = spamFile.readline()
		line = line.lower()
		words = re.split('[;,.-: /()?]', line)
		for j in words:
			cleaned_words += stemmer.stem(j) + " "
		f.write(cleaned_words)

