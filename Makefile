MD=$(shell find files -name '*.md')
TEX=$(shell find files -name '*.tex')

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
	$(RM) source.tex $(basename $@).aux $(basename $@).log

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
	pdflatex -jobname $(basename $@) $<
	$(RM) $(basename $@).aux $(basename $@).log

%.docx: %.md
	pandoc \
		-o $@ \
		--number-sections \
		$<

clean:
	$(RM) $(MD:.md=.pdf) $(MD:.md=.docx) $(MD:.md=.tex)
