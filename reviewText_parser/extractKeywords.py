print "Importing NLTK (this may take a while)...\n"
import nltk
#paragraph = "This is a paragraph to test the system.  It has multiple sentences.  Also I am awesome, great, totally hot, and an amazing programmer.  Hopefully, that is enough adjectives for this thing to find useful stuff.  Also hotels are cool."
print "Loading data (this may take a while)...\n"
with open ("test.txt", "r") as input:
	data = input.read()
#print data

adjectives = open("adjectives.txt", "w")
adverbs = open("adverbs.txt", "w")
gerunds = open("gerunds.txt", "w")

#sentences = nltk.sent_tokenize(paragraph)
print "Tokenizing data into sentences (this may take a while)...\n"
sentences = nltk.sent_tokenize(data)
ind = 1
for sent in sentences:
	#print sent
	print "Parsing sentence: "
	print ind
	print "\n"
	ind = ind + 1
	tagged_tokens = nltk.pos_tag(nltk.word_tokenize(sent))
	for pair in tagged_tokens:
		if (pair[1] == 'JJ') or (pair[1] == 'JJR') or (pair[1] == 'JJS'):
			adjectives.write(pair[0])
			adjectives.write("\r\n")
			#print pair[0]
		if (pair[1] == 'RB') or (pair[1] == 'RBR') or (pair[1] == 'RBS') or (pair[1] == 'WRB'):
			adverbs.write(pair[0])
			adverbs.write("\r\n")		
		if (pair[1] == 'VBG'):
			gerunds.write(pair[0])
			gerunds.write("\r\n")

adjectives.close()
adverbs.close()
gerunds.close()
	