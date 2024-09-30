# mssistemalanchonete : Infra EKS

Este repositório serve para automatizar o provisionamento de infraestrura para o [mssistemalanchonete](https://github.com/kelvinlins/mssistemalanchonete.git) utilizando terraform.   
Através dele pode ser privisionado um cluster EKS, VPC, grupos de segurança, um repositório ecr para a aplicação e prepara a integração entre o kubernetes do cluster e o load balancer que será criado para a aplicação.   
Para executar esses scripts você precisa de um bucket s3 que é usado como [backend](https://developer.hashicorp.com/terraform/language/backend) pelo terraform. Antes de executar crie o bucket e configure o backend no `Main.tf`nas pastas `eks e albController`.

## Executando via github-actions
Para executar os scripts diretamente do github, é necessário criar a variable `AWS_REGION` que é o código da região AWS e  as secrets `AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY`, respectivamente o código da região AWS, o ID e chave de acesso de um usuário AWS com permissões suficientes para criar e alterar os recursos citados acima.   
A automação ( **Deploy terraform** ) roda a partir de pull-requests para a `main`: na abertura ela valida os scripts, no merge ela aplica as alterações a infra. Também é possivel acionar a automação manualmente no menu action do github.
Para fazer o desprovisionamento da infra também existe uma action nesse repositório: **Deploy terraform**. Ela precisa ser acionada manualmente e escolhendo "Yes_sure" mo menu suspenso o processo é iniciado.


## Executando localmente
Para provisionar a infra na AWS rodando localmente o código desse repositório é necessário que o [aws-cli](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html) esteja instalado e configurado com acesso a conta AWS onde a infra deve ser provisionada .   
Também é necessário instalar  o [terraform](https://developer.hashicorp.com/terraform/install).  
**Atenção: utilizar recursos na nuvem custa dinheiro!!!**

### Provisionando a infra
Após clonar o repositório, altere o [backend](https://developer.hashicorp.com/terraform/language/backend) usado pelo terraform e abra o terminal na pasta `eks` e execute os comandos: 
```
terraform init
terraform plan
terraform apply
```
O console pedira que vc confirme a execução.   
Você pode alterar o nome do projeto e a região AWS através das variaveis `projectname e aws_region`, respectivamente. Veja como informar valores de variaveis [aqui](https://developer.hashicorp.com/terraform/language/values/variables#variables-on-the-command-line).   
Para completar o processo mude para a pasta `albController` e repita o processo acima.

### Destruindo tudo
Para desprovisionar a infra, abra o terminal na pasta `albController` e execute os comandos: 
```
terraform init
terraform destroy
```
É necessário confirmar a execução no console.
Repita o processo na pasta `eks`.
E então execute: 
```
aws iam delete-role-policy --role-name IRSA-EKSLoadBalancerControllerRole --policy-name AWSLoadBalancerControllerIAMPolicy
aws iam delete-role --role-name IRSA-EKSLoadBalancerControllerRole
```
Pronto! Toda a infra foi excluída!