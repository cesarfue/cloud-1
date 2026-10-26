TF := terraform -chdir=terraform

.PHONY: up down destroy

up:
	$(TF) init -input=false
	$(TF) apply -auto-approve -input=false -var instance_state=running
	$(TF) apply -refresh-only -auto-approve -input=false -var instance_state=running
	$(TF) output public_ips

down:
	$(TF) apply -auto-approve -input=false -var instance_state=stopped

destroy:
	$(TF) destroy -auto-approve -input=false
