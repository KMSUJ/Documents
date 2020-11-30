DOCS=$(filter-out README.md,$(wildcard *.md))

all:
	@echo "Supported commands:"
	@echo "  make pdf"
	@echo "  make docx"

pdf: $(DOCS:.md=.pdf)
docx: $(DOCS:.md=.docx)

%.pdf %.tex: %.md
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

%.docx: %.md
	pandoc \
		-o $@ \
		--number-sections \
		$<

clean:
	$(RM) *.pdf
	$(RM) *.docx
