provider "aws" {
  region = "us-west-2"
  alias  = "oregon"
  default_tags {
    tags = {
      Product             = "Platform"
      Service             = "UptimeEvaluationService"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      InfrastructureOwner = "S and C Platform / Security and Compliance_Earth@nice.com"
      ApplicationOwner    = "S andC Platform / Security and Compliance_Earth@nice.com"
    }
  }
}