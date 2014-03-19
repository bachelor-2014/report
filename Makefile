MD = header.md titlepage.md abstract.md toc.md introduction.md problem_statement.md existing_robot.md goals.md architecture.md hardware.md choice_of_language.md gui.md programmability.md logging.md tracking.md scanning.md discussion.md conclusion.md acknowledgements.md references.md
BIB = bibliography.bib
ARGS = --number-sections --bibliography=$(BIB)

all: report.pdf

report.pdf: $(MD) $(BIB)
	pandoc $(ARGS) -o report.pdf $(MD)

report.tex: $(MD) $(BIB)
	pandoc $(ARGS) -o report.tex $(MD)
report2.pdf: report.tex
	pandoc $(ARGS) -o report2.pdf report.tex
