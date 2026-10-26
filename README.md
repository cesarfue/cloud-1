# cloud-1

Déploiement automatisé, sur une ou plusieurs instances Ubuntu 22.04, de la stack WordPress issue du projet Inception : nginx, WordPress (php-fpm), MariaDB et phpMyAdmin, un conteneur par processus.

## Organisation

| Chemin | Rôle |
|---|---|
| `srcs/` | Images et `docker-compose.yml` de la stack. |
| `terraform/` | Création des instances EC2 nues et de leur security group. |
| `ansible/` | Configuration des machines et déploiement de la stack. |
| `Makefile` | Enchaînement des deux outils. |

Terraform ne fait que créer les machines : aucun `user_data`, rien n'est installé à la création. Ansible part d'une machine qui n'a que SSH et Python, et fonctionne avec n'importe quel inventaire, que les machines viennent de Terraform ou non.

Le playbook `ansible/site.yml` applique quatre rôles, dans cet ordre :

| Rôle | Effet |
|---|---|
| `swap` | Fichier d'échange de 2 Gio, activé et inscrit dans `/etc/fstab`. Les builds d'images dépassent sinon le 1 Gio d'une `t3.micro`. |
| `docker` | Dépôt apt officiel de Docker, Docker Engine avec les plugins buildx et compose, service activé au démarrage. |
| `firewall` | ufw : entrées refusées par défaut, 22, 80 et 443 autorisés. |
| `app` | Dossiers de données sous `/var/lib/cloud-1`, copie de `srcs/` dans `/opt/cloud-1`, `.env` généré en `0600`, build et lancement par `docker compose`, puis alignement des URL `home` et `siteurl` de WordPress sur l'adresse publique de l'hôte. |

Un second passage du playbook sur une machine déjà déployée ne change rien (`changed=0`). Les images ne sont reconstruites que si `srcs/` a changé.

## Réseau

Depuis l'extérieur, seuls 22, 80 et 443 sont joignables. Le security group n'ouvre 22 qu'au CIDR `ssh_allowed_cidr` ; 80 et 443 sont ouverts à tous. Sur la machine, ufw applique la même règle, et seul le conteneur nginx publie des ports. MariaDB et php-fpm restent sur le réseau interne du compose.

nginx redirige le port 80 vers HTTPS, sert WordPress sur `/` et phpMyAdmin sur `/phpmyadmin/`. Le certificat TLS est auto-signé, généré au build de l'image nginx.

## Prérequis

- Terraform 1.6 ou plus, AWS CLI configuré (`aws configure`) avec un utilisateur IAM disposant de `AmazonEC2FullAccess`.
- Ansible (paquet `ansible`, ou `ansible-core` avec les collections de `ansible/requirements.yml`).
- Une clé SSH, `~/.ssh/id_rsa.pub` par défaut (variable Terraform `ssh_public_key_path`).
- Le mot de passe du vault Ansible dans `~/.config/cloud-1/vault_pass`, en `0600`, ou un autre chemin passé par `VAULT_PASSWORD_FILE`.
- `terraform/terraform.tfvars`, sur le modèle de `terraform/terraform.tfvars.example`, avec l'IP de l'opérateur :

```bash
echo "ssh_allowed_cidr = \"$(curl -s https://checkip.amazonaws.com)/32\"" > terraform/terraform.tfvars
```

## Utilisation

| Commande | Effet |
|---|---|
| `make up` | Crée les instances, ou les rallume si elles sont arrêtées, écrit `ansible/inventory/aws.ini` depuis les outputs Terraform, puis lance `make deploy`. |
| `make deploy` | Lance le playbook sur `ansible/$(INVENTORY)`, par défaut `inventory/aws.ini`. |
| `make down` | Arrête les instances sans les supprimer. |
| `make destroy` | Supprime toutes les ressources, sans confirmation. |

Le nombre d'instances se règle avec la variable Terraform `instance_count` ; le playbook les déploie en parallèle.

Pour déployer sur des machines qui ne viennent pas de Terraform, un inventaire suffit, sur le modèle de `ansible/inventory/hosts.example.ini` :

```bash
make deploy INVENTORY=inventory/hosts.ini
```

L'URL publique d'un hôte vaut `https://<ansible_host>` ; la variable `app_public_url` la remplace, par exemple pour un nom de domaine.

## Facturation

`make down` arrête la facturation du calcul et libère l'IPv4 publique, qui change donc au `make up` suivant ; le playbook réaligne alors WordPress sur la nouvelle adresse. Le volume EBS de 20 Gio reste facturé tant que l'instance existe, dans la limite des 30 Go du free tier quand il s'applique. Seul `make destroy` ramène la facture à zéro.

Les instances sont en crédits CPU `standard` : une `t3.micro` à court de crédits ralentit au lieu de facturer le dépassement.

## Secrets

Les mots de passe de MariaDB et des comptes WordPress sont dans `ansible/group_vars/all/vault.yml`, chiffré par `ansible-vault` et versionné. Les autres valeurs sont dans `ansible/group_vars/all/vars.yml`. Le `.env` de la stack n'est jamais versionné : il est généré sur chaque hôte à partir de ces deux fichiers.

```bash
ansible-vault view --vault-password-file ~/.config/cloud-1/vault_pass ansible/group_vars/all/vault.yml
ansible-vault edit --vault-password-file ~/.config/cloud-1/vault_pass ansible/group_vars/all/vault.yml
```

L'état Terraform, `terraform.tfvars`, l'inventaire généré et `ansible/.known_hosts` sont exclus du dépôt.
