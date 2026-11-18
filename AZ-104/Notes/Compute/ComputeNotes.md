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
