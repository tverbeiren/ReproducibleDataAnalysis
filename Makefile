FILE=RR
THTML=template-html
TPDF=template-pdf

all: $(FILE)-simple.html $(FILE).html $(FILE).pdf $(FILE)-simple.pdf $(FILE)-slides.html $(FILE).docx

clean:
	rm $(FILE).docx
	rm $(FILE).pdf
	rm $(FILE)-simple.pdf
	rm $(FILE).html
	rm $(FILE)-slides.html
	rm $(FILE)-simple.html

$(FILE).md: $(FILE).Rmd
	Rscript -e "library(knitr); knit('$(FILE).Rmd')"

# Strip the horizontal lines when this is a document
$(FILE)s.md : $(FILE).md
		cat $(FILE).md | grep -v -e '- - -' -e '\\ ' > $(FILE)s.md

$(FILE)-simple.html: $(FILE)s.md
	pandoc $(FILE)s.md -o $(FILE)-simple.html \
			-t html5 \
			--highlight-style=tango --mathjax \
			--toc --toc-depth 2
			
$(FILE).html: $(FILE)s.md
	pandoc $(FILE)s.md -o $(FILE).html \
			-t html5 \
			--template $(THTML)/template.html \
			--css $(THTML)/template.css \
			--highlight-style=tango --mathjax \
			--toc --toc-depth 1
			
$(FILE).pdf: $(FILE)s.md
	pandoc $(FILE)s.md -o $(FILE).pdf \
			--template $(TPDF)/mytemplate.tex \
			--highlight-style tango \
			--variable paper=letterpaper \
			--variable ebook  \
			--toc --variable toc-depth=1 \
			--variable tables \
			--variable numbersections \
			--variable documentclass=book \
			--variable graphics 

$(FILE)-simple.pdf: $(FILE)s.md
	pandoc $(FILE)s.md -o $(FILE)-simple.pdf \
			--highlight-style tango \
			--variable paper=a4paper \
			--toc --toc-depth 2 \
			--variable tables

$(FILE)-slides.html: $(FILE).md
	pandoc $(FILE).md -o $(FILE)-slides.html \
			-t revealjs \
			--slide-level=1 \
			--variable revealjs-url=template-reveal/reveal.js-2.6.2 \
			-s --variable theme=moon \
			--variable transition=fade \
			--highlight-style espresso \
			--template template-reveal/reveal-template.html \
			--no-highlight --variable hlss=zenburn --mathjax

$(FILE).docx: $(FILE)s.md
	pandoc $(FILE)s.md -o $(FILE).docx

