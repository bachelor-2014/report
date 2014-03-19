MD = titlepage.md abstract.md toc.md introduction.md problem_statement.md existing_robot.md goals.md architecture.md hardware.md choice_of_language.md gui.md programmability.md logging.md tracking.md scanning.md discussion.md conclusion.md acknowledgements.md references.md
BIB = bibliography.bib
ARGS = --number-sections --bibliography=$(BIB) --include-in-head=header.tex --chapters

default: report.pdf

report.pdf: $(MD) $(BIB)
	pandoc $(ARGS) -o report.pdf $(MD)
