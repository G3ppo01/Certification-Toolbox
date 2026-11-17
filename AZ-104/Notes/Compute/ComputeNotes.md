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
