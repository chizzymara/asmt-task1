#create aws ecr repository 
resource "aws_ecr_repository" "asmt-1-cmba-ecr" {
  name                 = "asmt-1-cmba-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

#Build docker file 
resource "null_resource" "docker_file" {
  #provisioner "local-exec" {
  #  command = "docker build -t ${var.image_name}:${var.image_tag} app"
  #}
  provisioner "local-exec" {
    command = "/bin/bash docker_build.sh"
    #  interpreter = [“bash”]
  }
}

#Create the ecs cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "asmt-1-cmba-ecs"
}

#Create the task definition
resource "aws_ecs_task_definition" "Task" {
  family                   = "asmt-1-cmba-task"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu       = 512
  memory    = 1024
  execution_role_arn    = aws_iam_role.ecs_role.arn
  depends_on = [null_resource.docker_file]
  container_definitions = jsonencode([
    {
      name      = "${var.container_name}"
      image     = "${aws_ecr_repository.asmt-1-cmba-ecr.repository_url}/latest"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

#Create the service
resource "aws_ecs_service" "service" {
  name            = "asmt-1-cmba-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.Task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets = var.subnets-list
    assign_public_ip = true
  }
  

  #vpc_id       = "${module.vpc.vpc_id}"
  #vpc_cidr     = "${module.vpc.vpc_cidr}"
  #lb_subnetids = "${module.vpc.public_subnets}"
  #awsvpc_task_execution_role_arn = "${aws_iam_role.ecs_tasks_execution_role.arn}"
  #awsvpc_service_security_groups = ["${aws_security_group.awsvpc_sg.id}"]
  #awsvpc_service_subnetids       = "${module.vpc.private_subnets}"
  #iam_role        = aws_iam_role.ecs_role.arn
}  