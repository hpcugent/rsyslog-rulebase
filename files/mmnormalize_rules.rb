version=2
# Rulebase for rsyslog messages that should be turned into some normalised JSON form

include=lmod.rb
include=nfs.rb


# lmod
rule=lmod,load:%program:literal{"text": "lmod"}%::  %info:@lmod_info%, userload=%userload:char-to{"extradata": ","}%, %module:@lmod_module%, fn=%filename:word%
rule=lmod,command:%program:literal{"text": "lmod"}%::  %info:@lmod_info%, cmd=%command:char-to{"extradata": ","}%, args=%arguments:word%

# nfs
rule=nfs,server:%program:literal{"text": "kernel"}%:: nfs: %nfs:@NFSServer%
rule=nfs,error:%program:literal{"text": "kernel"}%:: Error: %nfs:@NFSGeneral%%-:rest%
