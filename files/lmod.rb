version=2

type=@lmod_info:username=%username:char-to{"extradata":","}%, cluster=%cluster:char-to{"extradata": ","}%, jobid=%jobid:char-sep{"extradata": ","}%
type=@lmod_module:module=%name:char-to{"extradata": "/"}%/%version:char-to{"extradata": ","}%

rule=lmod_load:lmod::  %info:@lmod_info%, userload=%userload:char-to{"extradata": ","}%, %module:@lmod_module%, fn=%filename:word%

rule=lmod_command:lmod::  %info:@lmod_info%, cmd=%command:char-to{"extradata": ","}%, args=%arguments:word%
