version=2

# mmnormalize types for nfs log lines

type=@IPorHostname:%-:ipv4%
type=@NFSServer:server %server:ipv4% %reason:rest%
type=@NFSGeneral:%reason:string-to{"extradata": " on NFSv4 server"}% on NFSv4 server %server:ipv4%
