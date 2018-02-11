%script to send email
%works from iceberg worker
%includes attachement
setpref('Internet','SMTP_Server','mailhost.shef.ac.uk')
setpref('Internet','E_mail','m.griffiths@sheffield.ac.uk')
sendmail('wrgrid-training@sheffield.ac.uk','subject is matlab sending email','Message from iceberg worker see attachment',{'email.m'})
