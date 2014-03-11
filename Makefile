MD = header.md titlepage.md abstract.md toc.md introduction.md problem_statement.md existing_robot.md goals.md architecture.md hardware.md software.md computer_vision.md discussion.md conclusion.md references.md
BIB = bibliography.bib
ARGS = --number-sections --bibliography=$(BIB)

all: report.pdf

report.pdf: $(MD) $(BIB)
	pandoc $(ARGS) -o report.pdf $(MD)
