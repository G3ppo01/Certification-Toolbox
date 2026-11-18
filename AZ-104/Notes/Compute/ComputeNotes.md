# Learning Notes

## Introduction to virtual machines

https://learn.microsoft.com/en-us/training/modules/intro-to-azure-virtual-machines

Az ressource --> objet gérable dans az, comme une VM, disque, réseau (vnet),...

une VM a besoin de:

- VM
- Disque
- Virtual Network
- IP
- Network Security Group (NSG)

Az peut créer ces ressources lui même, ou l'on peut en assigner d'existantes
Les VM sont "IaaS"

Les VM ont des paramètres commes le nom, la taille (CPU, RAM, GPU, ..), et l'OS
Choisir la taille selon le besoin

Les VMs ont 2 disques par défaut, un pour l'OS, et un temporaire (données effacé si machine éteinte).
Possible d'en ajouter d'autres (persistant).

La VM a un VNIC (Virtual Network Interface) avec possibilitée d'un IP privé et/ou publique (dans un VNet).
De cette manière, la VM peut parler avec d'autres ressources AZ, ainsi qu'internet, ou un DC on-prem.

Toutes les ressources  lié à une app/projetsont dans un ressource group.

### VM checklist

#### Network

Virtual networks (VNets) est le réseau virtuel dans le quel la VM et d'autres ressources communiques.
C'est le même principe qu'un réseau normal.
De base, les ressources en communiques qu'avec d'autres ressource dans le même réseau, mais il est possible de modifier cela.

Lors de la création, il faut choisir une plage IP, qui possiblement ne piétine la plage que l'on utilise pour un autre VNet (ou On-Prem).
Ensuite, possible de créer des subnet dans un Vnet, et de sécuriser le traffic via Network security Groups (NSG)
Un NSG permet de mettre des règles de communication entres subnets, ASG (Application Security Groups), IP/Ports, ..., comme un FW un peu
Par exemple:
Ecco come dialogano insieme i componenti che hai elencato:

1. **1 VNet**: Fa da perimetro di rete generale per la tua applicazione (es. `10.0.0.0/16`).
2. **Subnet dedicate**: Separi la rete in livelli logici (es. `FrontendSubnet` per il Web e `BackendSubnet` per il Database).
3. **ASG per Ruolo**: Assegni le schede di rete (NIC) delle VM ai relativi gruppi logici:

    - `ASG-Web` alle VM frontend.
    - `ASG-SQL` alle VM del database.

4. **NSG centralizzato a livello di Subnet**: Associ l'NSG alla Subnet e scrivi regole pulite basate sugli ASG:

    - **Regola 1 (Ingresso Web)**: Sorgente: `ServiceTag: Internet` ➔ Destinazione: `ASG-Web` (Porta 443 HTTPS) ➔ **Allow**.
    - **Regola 2 (Web verso DB)**: Sorgente: `ASG-Web` ➔ Destinazione: `ASG-SQL` (Porta 1433 SQL) ➔ **Allow**.
    - **Regola 3 (Isolamento DB)**: Sorgente: `ServiceTag: Internet` ➔ Destinazione: `ASG-SQL` ➔ **Deny** (anche se la regola di default di Azure bloccherebbe già l'ingresso da Internet).

Ordre d'application des règles:
Les règles ont une priorité de 100 à 4096. La priorité la bplus basse l'emporte.
AZ check toutes les règles une par une, en partant du chiffre le plus petit, et arrète le check dès le premier match.

Si on a un NSG sur le NIC ainsi que le subnet, les 2 doivent approuver le traffic. Si un bloque, c'est mort.
Traffic IN: Subnet NSG --> NIC NSG
Traffic OUT: NIC NSG --> Subnet NSG

### VM

Une fois que le réseau a été plannifié, il faut préparer la VM selon les besoins

Il faut faire attention au non de la VM, car il n'est pas simple de le changer après cout.
Celui ci devient aussi hostname dans l'OS de la VM
Il faut une bonne convention de nommage:

- Env (Dev/prod/qa)
- Location (dans un environnement où on aurait plusieur régions)
- Instance (webapp01, 02,...)
- produit/service/projet
- role

exemple MS: deveus-webvm01

#### Location

Choisir l'emplacement le plus proche des utilisateurs possible.
cela permet d'améliorer les perf et d'etre compliant avec les réglementations locales

Certaines features ne sont pas dispo partout
Il peut aussi y avoir des differences au niveau de prix
Si il n'y a pas de restrictions réglementaires ou de perf, ça peut valoir la peine de comparer les prix

#### Taille de la VM

Plutot que de devoir tout configurer à la main, AZ propose des tailles adaptées aux differents Workloads

- General Purpose
- Compute Optimized (CPU)
- Memory Optimized (RAM)
- Storage Optimized (Storage et I/O)
- GPU (Graphic and AI workload)
- High Performance Compute (CPU ++ et High throughput network interface)

Il est possible de changer la taille d'une VM
Le chamgement reboot la machine

La taille détermine aussi le nombre de NiC utilisables pour une VM

### Pricing

Les VMs sont facturés, mais les composants qui y sont attachés aussi
Composants facturés:

- VNet
- IP (privée et publique)
