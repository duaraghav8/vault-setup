provider "aws" {
  version = "2.10.0"
  region  = "${var.geo["default_region"]}"
}
