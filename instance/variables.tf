# Declarar varibles
variable "ami_id" {
    default = ""
    description = "Ami Id"
}
variable "instance_type" {

}
variable "tags" {
    type = map
}
variable "sg_name" {

}
variable "ingress_rule" {
  
}