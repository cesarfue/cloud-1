TF := terraform -chdir=terraform
INVENTORY ?= inventory/aws.ini
VAULT_PASSWORD_FILE ?= $(HOME)/.config/cloud-1/vault_pass

.PHONY: up deploy down destroy

up:
	$(TF) init -input=false
	$(TF) apply -auto-approve -input=false -var instance_state=running
	$(TF) apply -refresh-only -auto-approve -input=false -var instance_state=running
	$(TF) output -raw ansible_inventory > ansible/inventory/aws.ini
	$(TF) output public_ips
	$(MAKE) deploy

deploy:
	cd ansible && ansible-galaxy collection install -r requirements.yml
	cd ansible && ansible-playbook -i $(INVENTORY) --vault-password-file $(VAULT_PASSWORD_FILE) site.yml

down:
	$(TF) apply -auto-approve -input=false -var instance_state=stopped

destroy:
	$(TF) destroy -auto-approve -input=false
	rm -f ansible/inventory/aws.ini ansible/.known_hosts
