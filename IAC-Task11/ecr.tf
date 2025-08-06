resource "aws_ecr_repository" "strapi_repository" {
    name = "strapi-repo-gov"
    image_scanning_configuration {
    scan_on_push = true
    }
    tags = {
    name        = "strapi-repo-gov"
    }
}