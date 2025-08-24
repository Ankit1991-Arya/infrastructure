variable "group_adname" {
  type = map(any)
  default = {
    Dept_CloudNativeCore     = "e69f471f-c6e9-4b5f-9370-cc316e58df1c"
    Dept_CloudOps            = "8bf5c300-927a-4ec4-bb88-f75d906af964"
    Dept_NICE-DevOps         = "ec97cc03-f16c-4d72-9e0d-65959c486e8f"
    Dept_SystemsArchitecture = "b414317f-5c50-4b50-8f50-a89677cd8b63"
    Dept_SystemsEngineering  = "c5fbae91-ef32-4918-a74c-03e4fcbaf133"
    Dept_NOC                 = "486c88ce-773c-40b0-bd83-211333c8c4b6"
  }
}