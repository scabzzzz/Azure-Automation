#initial data transfer, with switches to mirror directory, retry once on failure, wait 1 second, and tee progress with log failure
robocopy \\source_server_unc_path\SharedFolder \\dest_server_unc_path\SharedFolder /e /ZB /MIR /fp /w:1 /r:1 /COPYALL /tee /log+:e:\folder\robocopy_log_initial.txt

#delta data transfer with attribute repair, no mirror, only changed data
robocopy \\source_server_unc_path\SharedFolder \\dest_server_unc_path\SharedFolder /e /ZB /XO /PURGE /fp /w:1 /r:1 /SECFIX /DCOPY /log+:e\folder\robocopy_log_initial.txt


#bonus cmdlets for cmd prompt
#Takes ownership of shares, subdirs, etc. Assumes logged in user
takeown /F <Filename> /r /d y

#Changes ACL and grants user access
icacls <foldername> /grant concept:f /T

#Find files by largest size. First 10 largest files
Get-ChildItem -r| sort -descending -property length | select -first 10 name, length

