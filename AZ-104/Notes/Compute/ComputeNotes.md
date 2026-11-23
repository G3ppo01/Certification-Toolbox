# Learning Notes

## Introduction aux machines virtuelles

https://learn.microsoft.com/en-us/training/modules/intro-to-azure-virtual-machines

Une ressource Azure est un objet que l'on peut gérer dans Azure, par exemple une VM, un disque ou un réseau (VNet).

Une VM a besoin des éléments suivants :

- VM
- Disque
- Virtual Network
- IP
- Network Security Group (NSG)

Azure peut créer ces ressources lui-même ou utiliser des ressources existantes.
Les VM sont des ressources IaaS.

Les VM ont des paramètres comme le nom, la taille (CPU, RAM, GPU, etc.) et le système d'exploitation.
Il faut choisir la taille selon les besoins.

Les VM ont deux disques par défaut : un disque pour le système d'exploitation et un disque temporaire dont les données sont effacées lorsque la machine est arrêtée.
Il est possible d'ajouter d'autres disques persistants.

La VM possède une NIC (Network Interface Card) virtuelle avec une adresse IP privée et/ou publique dans un VNet.
Ainsi, la VM peut communiquer avec d'autres ressources Azure, avec Internet ou avec un contrôleur de domaine local (on-premises).

Toutes les ressources liées à une application ou à un projet sont regroupées dans un resource group.

### Liste de vérification pour la VM

#### Réseau

Les réseaux virtuels (VNet) constituent le réseau dans lequel la VM et les autres ressources communiquent.
Ils fonctionnent selon le même principe qu'un réseau traditionnel.
Par défaut, les ressources ne communiquent qu'avec les autres ressources du même réseau, mais il est possible de modifier ce comportement.

Lors de la création, il faut choisir une plage IP qui ne chevauche pas celle utilisée par un autre VNet ou par un réseau on-premises.
Il est ensuite possible de créer des sous-réseaux dans un VNet et de sécuriser le trafic à l'aide de Network Security Groups (NSG).
Dans chaque subnet, les premier 4 IPs et le dernier IP sont réservé pour la gestion du subnet.
Un NSG permet de définir des règles de communication entre sous-réseaux, ASG (Application Security Groups), adresses IP et ports. Il joue un rôle similaire à celui d'un pare-feu.

Par exemple :

1. **1 VNet**: Fa da perimetro di rete generale per la tua applicazione (es. `10.0.0.0/16`).
2. **Subnet dedicate**: Separi la rete in livelli logici (es. `FrontendSubnet` per il Web e `BackendSubnet` per il Database).
3. **ASG per Ruolo**: Assegni le schede di rete (NIC) delle VM ai relativi gruppi logici:

    - `ASG-Web` alle VM frontend.
    - `ASG-SQL` alle VM del database.

4. **NSG centralizzato a livello di Subnet**: Associ l'NSG alla Subnet e scrivi regole pulite basate sugli ASG:

    - **Regola 1 (Ingresso Web)**: Sorgente: `ServiceTag: Internet` ➔ Destinazione: `ASG-Web` (Porta 443 HTTPS) ➔ **Allow**.
    - **Regola 2 (Web verso DB)**: Sorgente: `ASG-Web` ➔ Destinazione: `ASG-SQL` (Porta 1433 SQL) ➔ **Allow**.
    - **Regola 3 (Isolamento DB)**: Sorgente: `ServiceTag: Internet` ➔ Destinazione: `ASG-SQL` ➔ **Deny** (anche se la regola di default di Azure bloccherebbe già l'ingresso da Internet).

Ordre d'application des règles :
Les règles ont une priorité comprise entre 100 et 4096. La priorité la plus basse est appliquée en premier.
Azure vérifie toutes les règles une par une, en commençant par la valeur la plus petite, et s'arrête dès la première correspondance.

Si un NSG est associé à la fois à la NIC et au sous-réseau, les deux doivent autoriser le trafic. Si l'un d'eux le bloque, le trafic est refusé.
Trafic entrant : sous-réseau NSG --> NIC NSG
Trafic sortant : NIC NSG --> sous-réseau NSG

### VM

Une fois que le réseau a été planifié, il faut préparer la VM selon les besoins.

Il faut faire attention au nom de la VM, car il n'est pas simple de le modifier après sa création.
Ce nom devient également le nom d'hôte dans le système d'exploitation de la VM.
Il faut définir une convention de nommage cohérente :

- environnement (Dev, Prod, QA) ;
- emplacement (dans un environnement comportant plusieurs régions) ;
- instance (webapp01, webapp02, etc.) ;
- produit, service ou projet ;
- rôle.

Exemple Microsoft : deveus-webvm01

#### Location

Choisir l'emplacement le plus proche possible des utilisateurs.
Cela permet d'améliorer les performances et de respecter les réglementations locales.

Certaines fonctionnalités ne sont pas disponibles partout.
Il peut aussi y avoir des différences de prix.
S'il n'y a aucune restriction réglementaire ou liée aux performances, il peut être utile de comparer les prix.

#### Taille de la VM

Plutôt que de devoir tout configurer manuellement, Azure propose des tailles adaptées aux différents workloads.

- General Purpose
- Compute Optimized (CPU)
- Memory Optimized (RAM)
- Storage Optimized (Storage et I/O)
- GPU (workloads graphiques et d'intelligence artificielle)
- High Performance Compute (CPU renforcé et interface réseau à haut débit)

Il est possible de changer la taille d'une VM.
La modification redémarre la machine.

La taille détermine aussi le nombre de NIC utilisables pour une VM.

### Tarification

Les VM sont facturées, tout comme les composants qui y sont associés.
Composants facturés :

- VNet
- IP (privée et publique)
- Disques du système d'exploitation et disques supplémentaires
- Licence du système d'exploitation (si applicable)

Pour les VMs, le calcul et le stockage sont facturé séparément. Ce qui permet d'optimiser au mieux les coûts de ces ressources

La tarification du calcul est indiquée sur une base horaire, mais facturée à la minute.
Si une VM est utilisée 43 minutes, et désallouée ensuite, uniquement 43 minutes seront facturées.
Désallouer une VM libère le hardware sur laquelle elle tourne dans le DC Microsoft.
Le prix est basé sur la taille et l'OS. En cas de besoin d'une licence pour l'OS, le prix de celle-ci est incluse dans le prix de la VM.
Il est possible de récupérer et utiliser des licences on-premises existantes, pour les utiliser dans le cloud. Ce qui peut permettre de gagner quelques sous.

2 types de payements pour les VMs:

- Pay-as-you-go
  - Paye l'utilisation (à la seconde).
  - Pas de payements "upfront".
- Reserved Virtual Machine Instances
  - Reserver une VM pour une durée de 1 à plusieurs années.
  - Peut coûter 72% moins cher que le Pay as you go pour une utilisation équivalente.
  - Les coûts sont prévisibles et plus facilement budgétisables.

Le stockage n'est pas inclus dans le pricing des VMs.
Si une VM est éteinte, mais qu'un disque existe et contient des données, il faudra tout de même payer le storage.

### Stockage

Une VM a deux disques par défaut : le disque du système d'exploitation et un disque éphémère.
Il est conseillé de créer un disque distinct pour conserver les données persistantes.

#### Types de disques Azure

| | Ultra Disk | Premium SSD v2 | Premium SSD | Standard SSD | Standard HDD |
| --- | --- | --- | --- | --- | --- |
| **Type de disque** | SSD | SSD | SSD | SSD | HDD |
| **Scénario** | Charge de travail intensive en entrées/sorties, comme SAP HANA, les bases de données critiques (SQL, Oracle, etc.) et les autres charges de travail transactionnelles lourdes. | Charge de production et de performances sensibles à la latence, nécessitant une faible latence ainsi qu'un débit et un nombre d'IOPS élevés. | Charge de production et de performances sensibles à la latence. | Serveurs web peu utilisés, applications d'entreprise et environnements de développement/test. | Sauvegarde, accès occasionnel non critique et peu fréquent. |
| **Taille maximale du disque** | 65 536 GiB | 65 536 GiB | 32 767 GiB | 32 767 GiB | 32 767 GiB |
| **Débit maximal** | 4 000 Mo/s | 1 200 Mo/s | 900 Mo/s | 750 Mo/s | 500 Mo/s |
| **IOPS maximal** | 160 000 | 80 000 | 20 000 | 6 000 | 2 000 |
| **Peut être utilisé comme disque du système d'exploitation** | Non | Non | Oui | Oui | Oui |

### Système d'exploitation

Prix de la VM peut varier selon l'OS, car les licences et besoin matériels ne sont pas les mêmes par tout.

Pour certain services, il existes des image à installer qui ont déjà uns stack prêtes dans le marketplace.
Par exemple, pour un site web, on pourrait avoir une image avec apache, MySQL et PHP/NodeJS déjà installés.

Il est aussi possible de créer des images à installer selon nos besoins, et utiliser "Azure Compute Gallery" pour gérer des images custom.

Azure Compute Gallery est un service qui permet de gérer, versionner et distribuer des images OS entre plusieurs régions et abonnements Azure

### Création de VMs

Creation de ressources via:
- gui
- powershell/bash/cloudshell
- ARM Templates/Bicep/Terraform
- rest API
- Azure Client SDK

Il est possible de configurer un accès SSH lors de la création d'une VM

Quand on utilise des templates, il est possible non seulement de créer de nouvelles VMs, mais aussi de repousser le Json d'une VM existante pour en modifier la configuration

création d'une VM via azure CLI:

``` bash
az vm create --resource-group TestResourceGroup --name test-wp1-eus-vm --image Ubuntu2204 --admin-username azureuser --generate-ssh-keys
```

création d'une VM via azure Powershell:

```Powershell
New-AzVm -ResourceGroupName "TestResourceGroup" -Name "test-wp1-eus-vm" -Location "East US" -Image Debian11 -VirtualNetworkName "test-wp1-eus-network" -SubnetName "default" -SecurityGroupName "test-wp1-eus-nsg" -PublicIpAddressName "test-wp1-eus-pubip" -GenerateSshKey -SshKeyName myPSKey -OpenPorts 22
```

"-OpenPorts" applique la configuration sur le NSG indiqué dans la commande.
le NSG ne fait pas de port forwarding. On expose donc la VM directement.
Pour faire du NAT et du Port forwarding, il faut utiliser: 
- Azure Bastion (best practice pour la gestion des accès admin)
- Azure Load Balancer
- Azure Firewall

Le client SDK est disponible pour C#, Java, Node.js, PHP, Python, Ruby, and go
les languages basés sur .net

les Azure VM Extentions sont des outils qui permettent de configurer et automatiser des tâches sur les VMs après le déploiement de celles-ci

Azure Automation services permet d'automatiser des tâches dans Azure:
- Script qui automatise une tâche repetitive
- Surveiller se des MAJ d'applications qui tournent sur in VM est disponible
- Surveiller les MAJ OS des VMs


Auto-shutdown
--> Plannifier des crainaux horaires lors des quel eteindre les VM dont on aurait pas besoin
permet d'économiser sur la facture.