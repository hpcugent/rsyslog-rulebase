version=2
# Rulebase for rsyslog messages that should be turned into some normalised JSON form

include=lmod.rb

# 
# type=@TorqueWalltime:%days:number%:%hours:number%:%minutes:number%:%seconds:number%
# type=@TorqueWalltime:%hours:number%:%minutes:number%:%seconds:number%
# type=@TorqueWalltime:%minutes:number%:%seconds:number%
# type=@TorqueWalltime:%seconds:number%
# 
# type=@TorqueResourceList:%[
# 	{"type": "literal", "text": "Resource_List.nodes="}, {"type": "repeat", "name": "nodes",
#          "parser": [
#              {"type": "char-to", "name": "host", "extradata": ":"},
#              {"type": "literal", "text": ":ppn="},
#              {"type": "number", "name": "ppn"}
#          ],
#          "while": {"type": "literal", "text": "+"}}, {"type": "whitespace"},
#         {"type": "literal", "text": "Resource_List.vmem="}, {"type": "word", "name": "vmem"}, {"type": "whitespace"},
#         {"type": "literal", "text": "Resource_List.nodect="}, {"type": "number", "name": "nodect"}, {"type": "whitespace"},
#         {"type": "literal", "text": "Resource_List.neednodes="}, {"type": "repeat", "name": "neednodes",
#          "parser": [
#              {"type": "char-to", "name": "host", "extradata": ":"},
#              {"type": "literal", "text": ":ppn="},
#              {"type": "number", "name": "ppn"}
#          ],
#          "while": {"type": "literal", "text": "+"}}, {"type": "whitespace"},
#         {"type": "literal", "text": "Resource_List.nice="}, {"type": "number", "name": "nice"}, {"type": "whitespace"},
#         {"type": "literal", "text": "Resource_List.walltime="}, {"type": "@TorqueWalltime", "name": "walltime"}
#     ]%
# 
# #type=@Foo:resources_used.cput=%cputime:number% resources_used.energy_used=%emergy_used:number% resources_used.mem=%mem:word% resources_used.vmem=%vmem:word% resources_used.walltime=%walltime:@TorqueWalltime%
# #{"type": "literal", "text": "resources_used.cput="}, {"type": "number", "name": "cputime"}, {"type": "whitespace"},
# #     {"type": "literal", "text": "resources_used.energy_used="}, {"type": "number", "name": "energy_used"}, {"type": "whitespace"},
# #     {"type": "literal", "text": "resources_used.mem="}, {"type": "word", "name": "mem"}, {"type": "whitespace"},
# #     {"type": "literal", "text": "resources_used.vmem="}, {"type": "word", "name": "vmem"}, {"type": "whitespace"},
# #     {"type": "literal", "text": "resources_used.walltime="}, {"type": "@TorqueWalltime", "name": "walltime"}
# #]%
# 
# # Test messages
# rule=:%[
#     { "type": "literal", "text": " huppel " },
#     { "type": "number", "name": "id" }
#   ]%
# 
# 
# # 04/05/2017 13:03:52;E;44.master23.banette.gent.vsc;user=vsc40075 group=vsc40075 jobname=STDIN queue=short ctime=1491389271 qtime=1491389271 etime=1491389271 start=1491389281 owner=vsc40075@gligar01.gligar.gent.vsc exec_host=node2801.banette.gent.vsc/0-1+node2802.banette.gent.vsc/0-1 Resource_List.nodes=2:ppn=2 Resource_List.walltime=01:00:00 Resource_List.vmem=8449062912b Resource_List.nodect=2 Resource_List.neednodes=2:ppn=2 Resource_List.nice=0 session=13786 total_execution_slots=4 unique_node_count=2 end=1491390232 Exit_status=265 resources_used.cput=0 resources_used.energy_used=0 resources_used.mem=57804kb resources_used.vmem=302552kb resources_used.walltime=00:15:46
# #
# 
# 
# rule=torque:%[
#     {"type": "char-to", "extradata":";"},
#     {"type": "literal", "text": ";E;"},
#     {"type": "char-to", "name": "jobid", "extradata": "."},
#     {"type": "literal", "text": "."},
#     {"type": "char-to", "name": "master", "extradata": "."},
#     {"type": "literal", "text": "."},
#     {"type": "char-to", "name": "cluster", "extradata": "."},
#     {"type": "literal", "text": ".gent.vsc;"},
#     {"type": "literal", "text": "user="}, {"type": "word", "name": "user"}, {"type": "whitespace"},
#     {"type": "literal", "text": "group="}, {"type": "word", "name": "group"}, {"type": "whitespace"},
#     {"type": "literal", "text": "jobname="}, {"type": "word", "name": "jobname"}, {"type": "whitespace"},
#     {"type": "literal", "text": "queue="}, {"type": "word", "name": "queue"}, {"type": "whitespace"},
#     {"type": "literal", "text": "ctime="}, {"type": "word", "name": "ctime"}, {"type": "whitespace"},
#     {"type": "literal", "text": "qtime="}, {"type": "word", "name": "qtime"}, {"type": "whitespace"},
#     {"type": "literal", "text": "etime="}, {"type": "word", "name": "etime"}, {"type": "whitespace"},
#     {"type": "literal", "text": "start="}, {"type": "word", "name": "start"}, {"type": "whitespace"},
#     {"type": "literal", "text": "owner="}, {"type": "word", "name": "owner"}, {"type": "whitespace"},
#     {"type": "literal", "text": "exec_host="}, {"type": "repeat", "name": "exec_host",
#          "parser": [
#              {"type": "char-to", "name": "host", "extradata": "/"},
#              {"type": "literal", "text": "/"},
#              {"type": "number", "name": "core_lower"},
#              {"type": "literal", "text": "-"},
#              {"type": "number", "name": "core_upper"}
#          ],
#          "while": [{"type": "literal", "text": "+"}]}, {"type": "whitespace"},
#     {"type": "@TorqueResourceList", "name": "resource_list"}, {"type": "whitespace"},
#     {"type": "literal", "text": "session="}, {"type": "number", "name": "session"}, {"type": "whitespace"},
#     {"type": "literal", "text": "total_execution_slots="}, {"type": "number", "name": "total_execution_slots"}, {"type": "whitespace"},
#     {"type": "literal", "text": "unique_node_count="}, {"type": "number", "name": "unique_node_count"}, {"type": "whitespace"},
#     {"type": "literal", "text": "end="}, {"type": "number", "name": "end"}, {"type": "whitespace"},
#     {"type": "literal", "text": "Exit_status="}, {"type": "number", "name": "exit_status"}
# 
#   ]%
# 
# rule=lmod_load:%[
#     {"type": "literal", "text": "lmod::"},
#     {"type": "whitespace" },
#     {"type": "literal", "text": "username="},
#     {"type": "char-to", "extradata": ",", "name": "username"},
#     {"type": "literal", "text": ","},
#     {"type": "whitespace"},
#     {"type": "literal", "text": "cluster="},
#     {"type": "char-to", "extradata": ",", "name": "cluster"},
#     {"type": "literal", "text": ","},
#     {"type": "whitespace"},
#     {"type": "literal", "text": "jobid="},
#     {"type": "char-sep", "extradata": ",", "name": "jobid"},
#     {"type": "literal", "text": ","},
#     {"type": "whitespace"},
#     {"type": "literal", "text": "userload="},
#     {"type": "char-to", "extradata": ",", "name": "userload"},
#     {"type": "literal", "text": ","},
#     {"type": "whitespace"},
#     {"type": "literal", "text": "module="},
#     {"type": "char-to", "extradata": "/", "name": "module_name"},
#     {"type": "literal", "text": "/"},
#     {"type": "char-to", "extradata": ",", "name": "module_version"},
#     {"type": "literal", "text": ","},
#     {"type": "whitespace"},
#     {"type": "literal", "text": "fn="},
#     {"type": "rest", "name": "module_path="}
#   ]%
# 
# rule=lmod_cmd:%[
#     {"type": "literal", "text": " - lmod::"},
#     {"type": "whitespace" },
#     {"type": "literal", "text": "username="},
#     {"type": "char-to", "extradata": ",", "name": "username"},
#     {"type": "literal", "text": ","},
#     {"type": "whitespace"},
#     {"type": "literal", "text": "cluster="},
#     {"type": "char-to", "extradata": ",", "name": "cluster"},
#     {"type": "literal", "text": ","},
#     {"type": "whitespace"},
#     {"type": "literal", "text": "jobid="},
#     {"type": "char-to", "extradata": ",", "name": "jobid"},
#     {"type": "literal", "text": ","},
#     {"type": "whitespace"},
#     {"type": "literal", "text": "cmd="},
#     {"type": "char-to", "extradata": ",", "name": "command"},
#     {"type": "whitespace"},
#     {"type": "literal", "text": "args="},
#     {"type": "rest", "name": "arguments"}
#   ]%
# 
