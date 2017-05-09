version=2

# mmnormalize types for lmod log lines

type=@lmod_info:username=%username:char-to{"extradata": ","}%, cluster=%cluster:char-to{"extradata": ","}%, jobid=%jobid:char-sep{"extradata": ","}%
type=@lmod_module:module=%name:char-to{"extradata": "/"}%/%version:char-to{"extradata": ","}%
