resource "aws_secretsmanager_secret" "dockerhub_login" {
  name = "${var.app_name}-dockerhub-login"
}

resource "aws_secretsmanager_secret_version" "dockerhub_login" {
  secret_id     = aws_secretsmanager_secret.dockerhub_login.id
  secret_string = file("${path.module}/files/dockerLogin.json")
}

resource "aws_secretsmanager_secret" "env_vars" {
  name = "${var.app_name}-env-vars"
}

resource "aws_secretsmanager_secret_version" "env_vars" {
  secret_id     = aws_secretsmanager_secret.env_vars.id
  secret_string = file("${path.module}/files/CareerDocsApiEnvVariables.json")
}

resource "aws_secretsmanager_secret" "ssh_key" {
  name = "${var.app_name}-ssh-key"
}

resource "aws_secretsmanager_secret_version" "ssh_key" {
  secret_id     = aws_secretsmanager_secret.ssh_key.id
  secret_string = tls_private_key.app_key.private_key_pem
}