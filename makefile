# Open Publishing Package
# github.com/dylandegeling/open-publishing-package

all:
	@ if [ ! -f *.docx ] ;\
	then echo "\n... Sorry, no docx could be found.\n" ;\
	else make yml ;\
	make epub ;\
	make html ;\
	make icml ;\
	make docx ;\
	fi

yml:
	@ if [ ! -f *.docx ] ;\
	then echo "\n... Sorry, no docx could be found.\n" ;\
	fi ;\
	\
	for i in $(wildcard *.docx) ;\
	do echo "\n----- $$i -----\n" ;\
	\
	pub=`basename $$i .docx` ;\
	dir=publications/$$pub ;\
	echo "CREATING METADATA YML" ;\
	\
	echo "1. Preparing" ;\
	rm -rf $$dir/yml ;\
	mkdir -p $$dir/yml ;\
	echo "... Done!\n" ;\
	\
	echo "2. Setting metadata\n" \
	"\nA couple of questions to set the metadata for $$pub.docx" \
	"\nPress return to confirm and leave empty to skip." ;\
	echo "---" >> $$dir/yml/$$pub.yml ;\
	echo "\nEnter the language (ENG, NL, DE):" ;\
	read language ;\
	echo "lang: '$$language'" >> $$dir/yml/$$pub.yml ;\
	echo "\nEnter the title?" ;\
	read title ;\
	echo "title: '$$title'" >> $$dir/yml/$$pub.yml ;\
	echo "\nEnter the subtitle?" ;\
	read subtitle ;\
	echo "subtitle: '$$subtitle'" >> $$dir/yml/$$pub.yml ;\
	echo "\nEnter keywords (separated by a ', '):" ;\
	read keywords ;\
	echo "keywords: [$$keywords]" >> $$dir/yml/$$pub.yml ;\
	echo "subject: [$$keywords]" >> $$dir/yml/$$pub.yml ;\
	echo "\nEnter a short description (150-160 characters):" ;\
	read description ;\
	echo "description: '$$description'" >> $$dir/yml/$$pub.yml ;\
	echo "\nEnter the name of the publisher:" ;\
	read publisher ;\
	echo "publisher: '$$publisher'" >> $$dir/yml/$$pub.yml ;\
	echo "\nEnter the publishing date (YYYY-MM-DD):" ;\
	read date ;\
	echo "date: '$$date'" >> $$dir/yml/$$pub.yml ;\
	echo "\nEnter an identifier:" ;\
	read identifier ;\
	echo "identifier: '$$identifier'" >> $$dir/yml/$$pub.yml ;\
	echo "\nEnter copyright statement or license:" ;\
	read rights ;\
	echo "rights: '$$rights'" >> $$dir/yml/$$pub.yml ;\
	echo "author:" >> $$dir/yml/$$pub.yml ;\
	echo "\nEnter the amount of authors:" ;\
	read amount ;\
	if [ "$$amount" != "" ] && [ "$$amount" -eq "$$amount" ] 2>/dev/null ;\
	then for (( a=1; a<=$$amount; a++ )) ;\
	do echo "\nEnter the name of author $$a:" ;\
	read author ;\
	echo "- $$author" >> $$dir/yml/$$pub.yml ;\
	done fi ;\
	echo "---" >> $$dir/yml/$$pub.yml ;\
	echo "\n... Done!\n" ;\
	done

epub:
	@ if [ ! -f *.docx ] ;\
	then echo "\n... Sorry, no docx could be found.\n" ;\
	fi ;\
	\
	for i in $(wildcard *.docx) ;\
	do echo "\n----- $$i -----\n" ;\
	\
	pub=`basename $$i .docx` ;\
	dir=publications/$$pub ;\
	echo "CONVERTING TO EPUB" ;\
	if [ ! -f $$dir/yml/$$pub.yml ] ;\
	then echo "... Sorry, no metadata was found. Please run 'make yml'.\n" ;\
	elif [ ! -f $$pub.png ] ;\
	then echo "... Please add a cover image with the name $$pub.png to the main folder.\n" ;\
	\
	else echo "1. Preparing" ;\
	rm -rf $$dir/epub ;\
	mkdir -p $$dir/epub ;\
	echo "... Done!\n" ;\
	\
	echo "2. Converting" ;\
	pandoc $$pub.docx \
	--output=$$pub.md \
	--from=docx \
	--to=markdown_strict+footnotes \
	--parse-raw \
	--extract-media=. ;\
	csplit -s -f table -n 1 -k $$pub.md "/<table>/" {9999} ;\
	for file in table* ;\
	do if [[ "$$file" != "table0" ]] ;\
	then echo "\nConverting $$file" ;\
	table=$$(grep -n "</table>" $$file | cut -f1 -d:) ;\
	sed -n "1,$$table p" $$file > $$file.html ;\
	echo "<style type='text/css'>" >> $$file.html ;\
	cat resources/epub/table.css >> $$file.html ;\
	echo "\n</style>" >> $$file.html ;\
	wkhtmltoimage $$file.html $$file.png ;\
	mv $$file.png media/ ;\
	comm -23 $$file $$file.html > $$file.txt ;\
	mv $$file.txt $$file.md ;\
	sed -i ".bak" "1s/^/\<img alt='Table' src\='media\/$$file.png'\/\>/" $$file.md ;\
	rm $$file ;\
	rm $$file.html ;\
	rm $$file.md.bak ;\
	else mv $$file $$file.md ;\
	fi ;\
	done ;\
	pngquant --force --ext .png media/*.png ;\
	rm $$pub.md ;\
	cat table* > $$pub.md;\
	sed -i ".bak" "s/\<table\>//g" $$pub.md ;\
	sed -i ".bak" "s/\<img src/\<img alt\='Image' src/g" $$pub.md ;\
	pandoc -s $$pub.md $$dir/yml/$$pub.yml \
	--output=$$dir/epub/$$pub.epub \
	--from=markdown \
	--to=epub \
	--standalone \
	--normalize \
	--toc-depth=2 \
	--epub-stylesheet="resources/epub/style.css" \
	--epub-embed-font="resources/epub/fonts/OpenSans-*.ttf" \
	--epub-cover-image=$$pub.png ;\
	echo "... Done!\n" ;\
	\
	echo "3. Cleaning" ;\
	rm table* ;\
	rm $$pub.md ;\
	rm $$pub.md.bak ;\
	rm $$pub.png ;\
	rm -rf media ;\
	echo "... Done!\n" ;\
	fi ;\
	done

html:
	@ if [ ! -f *.docx ] ;\
	then echo "\n... Sorry, no docx could be found.\n" ;\
	fi ;\
	\
	for i in $(wildcard *.docx) ;\
	do echo "\n----- $$i -----\n" ;\
	pub=`basename $$i .docx` ;\
	dir=publications/$$pub ;\
	echo "CONVERTING TO HTML" ;\
	if [ ! -f $$dir/yml/$$pub.yml ] ;\
	then echo "... Sorry, no metadata was found. Please run 'make yml'.\n" ;\
	else echo "1. Cleaning" ;\
	rm -rf $$dir/html ;\
	mkdir -p $$dir/html ;\
	echo "... Done!\n" ;\
	\
	echo "2. Converting" ;\
	pandoc $$pub.docx \
	--output=$$pub.md \
	--from=docx \
	--to=markdown \
	--standalone \
	--toc \
	--toc-depth=2 \
	--normalize \
	--extract-media=. ;\
	pandoc $$pub.md $$dir/yml/$$pub.yml \
	--output=$$dir/html/$$pub.html \
	--from=markdown \
	--to=html5 \
	--standalone \
	--include-in-header=resources/html/in_header.html \
	--include-before-body=resources/html/before_body.html \
	--include-after-body=resources/html/after_body.html ;\
	description=$$(sed -e "s/description: '//" -e "7!d" -e "s/.$$//" $$dir/yml/$$pub.yml) ;\
	sed -i ".bak" "s/descriptionLocation/$$description/g" $$dir/html/$$pub.html ;\
	sed -i ".bak" "/style type=/d" $$dir/html/$$pub.html ;\
	cp resources/html/style.css $$dir/html ;\
	cp resources/html/scripts.js $$dir/html ;\
	pngquant --force --ext .png media/*.png ;\
	mv -f media $$dir/html ;\
	echo "... Done!\n" ;\
	\
	echo "3. Cleaning" ;\
	rm $$pub.md ;\
	rm $$dir/html/*.bak ;\
	echo "... Done!\n" ;\
	fi ;\
	done

icml:
	@ if [ ! -f *.docx ] ;\
	then echo "\n... Sorry, no docx could be found.\n" ;\
	fi ;\
	\
	for i in $(wildcard *.docx) ;\
	do echo "\n----- $$i -----\n" ;\
	pub=`basename $$i .docx` ;\
	dir=publications/$$pub ;\
	if [ ! -f $$dir/yml/$$pub.yml ] ;\
	then echo "... Sorry, no metadata was found. Please run 'make yml'.\n" ;\
	else echo "1. Preparing" ;\
	rm -rf $$dir/pdf ;\
	mkdir -p $$dir/pdf ;\
	echo "... Done!\n" ;\
	\
	echo "2. Converting" ;\
	pandoc $$pub.docx \
	--output=$$pub.md \
	--from=docx \
	--to=markdown \
	--standalone \
	--normalize \
	--extract-media=. ;\
	pandoc $$pub.md $$dir/yml/$$pub.yml \
	--output=$$dir/pdf/$$pub.icml \
	--from=markdown \
	--to=icml \
	--standalone ;\
	pngquant --force --ext .png media/*.png ;\
	mv -f media $$dir/pdf/media ;\
	echo "... Done!\n" ;\
	\
	echo "3. Cleaning" ;\
	rm $$pub.md ;\
	echo "... Done!\n" ;\
	fi ;\
	done

docx:
	@ if [ ! -f *.docx ] ;\
	then echo "\n... Sorry, no docx could be found.\n" ;\
	fi ;\
	\
	for i in $(wildcard *.docx) ;\
	do echo "\n----- $$i -----\n" ;\
	\
	pub=`basename $$i .docx` ;\
	dir=publications/$$pub ;\
	echo "STORING DOCX" ;\
	\
	echo "1. Preparing" ;\
	rm -rf $$dir/docx ;\
	mkdir -p $$dir/docx ;\
	echo "... Done!\n" ;\
	\
	echo "2. Storing" ;\
	mv $$pub.docx $$dir/docx ;\
	echo "... Done!\n" ;\
	done

update:
	@ if [ -f publications/*/docx/* ] ;\
	then mv publications/*/docx/* . ;\
	fi ;\
	make html ;\
	make epub ;\
	make icml ;\
	make docx

reset:
	@ if [ -f publications/*/docx/* ] ;\
	then mv publications/*/docx/* . ;\
	fi ;\
	rm -rf publications ;\
	echo "\n... Directory has been reset!\n"

readme:
	@ echo "\n-----\n" ;\
	cat README.md ;\
	echo "\n\n-----\n"

license:
	@ echo "\n-----\n" ;\
	cat LICENSE.txt ;\
	echo "\n\n-----\n"
