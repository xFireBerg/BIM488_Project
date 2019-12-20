import os
import re
from TurkishStemmer import TurkishStemmer

newSMS = open("./new_sms.txt", "r", encoding="utf-8")
cleanedSMS = open("./cleaned_sms.txt", "w+", encoding="utf-8")

stemmer = TurkishStemmer()

with open("./cleaned_sms.txt", "a+", encoding="utf-8") as f:
    cleaned_words = ""
    line = newSMS.readline()
    line = line.lower()
    words = re.split('[;,.-: /()?]', line)
    for j in words:
        cleaned_words += stemmer.stem(j) + " "
    f.write(cleaned_words)
