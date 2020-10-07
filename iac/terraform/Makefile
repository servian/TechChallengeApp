.PHONY: plan-dev apply-dev destroy-dev plan-prod apply-prod destroy-prod

# creates the development infrastructure
deploy-dev: plan-dev apply-dev

# destroys the development infrastructure
undeploy-dev: destroy-dev

# creates the prod infrastructure
deploy-prod: plan-prod apply-prod

# destroys the development infrastructure
undeploy-prod: destroy-prod

terraform12="/tmp/terraform-0.12"

# get the required terraform version
get-terraform:
	curl -o /tmp/terraform-0.12.zip https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip && \
    rm -rf /tmp/terraform && \
    unzip /tmp/terraform-0.12.zip -d /tmp  && \
    mv -f /tmp/terraform /tmp/terraform-0.12  && \
    rm -rf /tmp/terraform-0.12.zip  && \
    chmod +x /tmp/terraform-0.12

init-dev:
	cd ../../iac/terraform/environments/dev && \
    $(terraform12) init

plan-dev: init-dev
	cd ../../iac/terraform/environments/dev && \
    rm -rf terraform.tfplan &&  $(terraform12) plan -out terraform.tfplan

apply-dev:
	cd ../../iac/terraform/environments/dev && \
    $(terraform12) apply terraform.tfplan

destroy-dev: init-dev
	cd ../../iac/terraform/environments/dev && \
    rm -rf terraform.tfplan && $(terraform12) plan -destroy -out terraform.tfplan && \
    $(terraform12) apply terraform.tfplan


init-prod:
	cd ../../iac/terraform/environments/prod && \
    $(terraform12) init

plan-prod: init-prod
	cd ../../iac/terraform/environments/prod && \
    rm -rf terraform.tfplan && $(terraform12) plan -out terraform.tfplan

apply-prod:
	cd ../../iac/terraform/environments/prod && \
    $(terraform12) apply -var-file terraform.tfvars

destroy-prod: init-prod
	cd  ../../iac/terraform/environments/prod && \
    rm -rf terraform.tfplan && $(terraform12) plan -destroy -out terraform.tfplan && \
    $(terraform12) apply terraform.tfplan