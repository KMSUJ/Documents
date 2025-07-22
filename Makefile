MD=$(wildcard files/*.md)
TEX=$(wildcard files/*.tex)

all:
	@echo "Supported commands:"
	@echo "  make tex"
	@echo "  make pdf"
	@echo "  make tex-to-pdf"
	@echo "  make docx"

tex: $(MD:.md=.tex)
tex-to-pdf: $(TEX:.tex=.pdf)
pdf: $(MD:.md=.pdf)
docx: $(MD:.md=.docx)

%.pdf: %.md
	pandoc \
		-o source.tex \
		--variable documentclass=scrartcl \
		--variable fontsize=12pt \
		--variable papersize=a4 \
		--variable graphics \
		--variable geometry=lmargin=25mm \
		--variable geometry=rmargin=25mm \
		--variable geometry=tmargin=55mm \
		--variable geometry=headheight=35mm \
		--number-sections \
		--include-in-header include/kmsuj.tex \
		$<
	python3 include/polskie_cudzyslowy.py source.tex
	pdflatex -jobname $(basename $@) source.tex
	$(RM) source.tex files/*aux files/*log

%.tex: %.md
	pandoc \
		-o $@ \
		--variable documentclass=scrartcl \
		--variable fontsize=12pt \
		--variable papersize=a4 \
		--variable graphics \
		--variable geometry=lmargin=25mm \
		--variable geometry=rmargin=25mm \
		--variable geometry=tmargin=55mm \
		--variable geometry=headheight=35mm \
		--number-sections \
		--include-in-header include/kmsuj.tex \
		$<
	python3 include/polskie_cudzyslowy.py $@

%.pdf: %.tex
	pdflatex -jobname $@ $<
	$(RM) files/*aux files/*log

%.docx: %.md
	pandoc \
		-o $@ \
		--number-sections \
		$<

clean:
	$(RM) files/*.pdf
	$(RM) files/*.docx
	$(RM) files/*.tex
