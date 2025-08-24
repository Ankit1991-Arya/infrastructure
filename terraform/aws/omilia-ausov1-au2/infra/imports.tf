#import {
#  id = "/ocp/stage/redis/redis_password"
#  to = module.omilia.module.redis.aws_ssm_parameter.redis_pass
#}
#
#import {
#  id = "/k8s/stage/kafka/brokers_tls"
#  to = module.omilia.module.msk.aws_ssm_parameter.bootstrap_servers_param[0]
#}
#
#import {
#  id = "Z00924631PUS5QOF298N2_opensearch.ocp.nicecxone-sov1.au_CNAME"
#  to = module.omilia.aws_route53_record.opensearch_domain_record[0]
#}
#