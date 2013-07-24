SHELL = /bin/bash


BACKUPDIR := $(shell mktemp -d)
PWD := $(shell pwd)

install : backup
	@echo "Linking files"
	ln -s "$(PWD)/inputrc" "$(HOME)/.inputrc"
	ln -s "$(PWD)/pentadactylrc" "$(HOME)/.pentadactylrc"
	ln -s "$(PWD)/tmux.conf" "$(HOME)/.tmux.conf"
	ln -s "$(PWD)/ctags.conf" "$(HOME)/.ctags.conf"

backup :
	@echo "Backing up existing files " $(BACKUPDIR)
	[ ! -f "$(HOME)/.inputrc" ] || mv "$(HOME)/.inputrc" $(BACKUPDIR)
	[ ! -f "$(HOME)/.pentadactylrc" ] || mv "$(HOME)/.pentadactylrc" $(BACKUPDIR)
	[ ! -f "$(HOME)/.tmux.conf" ] || mv "$(HOME)/.tmux.conf" $(BACKUPDIR)
	[ ! -f "$(HOME)/.ctags.conf" ] || mv "$(HOME)/.ctags.conf" $(BACKUPDIR)

.PHONY : install backup
