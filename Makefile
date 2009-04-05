RSYNC_OPTS = -a -x -H --delete-during --stats -hh -F --max-size=2G
MOUNTPOINT = /media/portable
BACKUPDIR = $(MOUNTPOINT)/backup
TODAY := $(shell date +%Y-%m-%d)
LOGFILE = /tmp/backup.log
LATEST = $(PWD)/latest
TARGET = $(HOME)/

all:;@echo use backup target

# some tests
prereq:
	mountpoint -q $(MOUNTPOINT)
	test -d $(BACKUPDIR) -a -w $(BACKUPDIR)

backup: prereq
	@rsync $(RSYNC_OPTS) --log-file=$(LOGFILE) --link-dest=$(LATEST) $(TARGET) $(BACKUPDIR)/backup-$(TODAY).incomplete || echo rsync exit code: $$?
	@mv -T $(BACKUPDIR)/backup-$(TODAY).incomplete $(BACKUPDIR)/backup-$(TODAY)
	@ln -sfT backup-$(TODAY) $(LATEST)
	@echo see logfile: $(LOGFILE)
	@echo latest backup now is:
	@readlink -e $(LATEST)

.PHONY: backup prereq
