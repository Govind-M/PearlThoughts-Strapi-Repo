locals {
  alb_metric_name = replace(aws_lb.strapi.arn_suffix, "loadbalancer/", "")
  tg_metric_name = replace(aws_lb_target_group.strapi.arn_suffix, "targetgroup/", "")
}