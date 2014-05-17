MD = titlepage.md abstract.md toc.md introduction.md hardware.md software.md calibration.md tracking.md scanning.md experiment_interaction.md logging.md human_interaction.md conclusion.md references.md
BIB = bibliography.bib
ARGS = --number-sections --bibliography=$(BIB) --include-in-head=header.tex --chapters --variable documentclass=report

default: report.pdf

report.pdf: $(MD) header.tex $(BIB)
	pandoc $(ARGS) -o report.pdf $(MD)

images/client_sequence.pdf: client_sequence.tex
	pdflatex --output-directory images client_sequence.tex
	-@rm images/client_sequence.{aux,log}
