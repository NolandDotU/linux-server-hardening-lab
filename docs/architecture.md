# Network Architecture & Topology

## Infrastructure Overview
This project simulates a secure server enviroment using a Type-2 Hypervisur (VMBOX/VMWare). The network is using a **Bridged Adapter Network, Wireless LAN WIFI 6** to simulate production DMS enviroment.

### Topology Diagram
```mermaid
graph TD
    subgraph "Host Machin"
        Kali[Kali Linux]
        style Kali fill:#f96,stroke:#333,stroke-width:2px
        note[Auditor / Attacker]
    
        Ubuntu[Ubuntu Server LTS]
        style Ubuntu fill:#bbf,stroke:#333,stroke-width:2px
        note2[Target / Web Server]

        Switch((Virtual Switch))
    end

    Kali -- "TCP/22, 80, 443" --> Switch
    Switch -- "Ingress" --> Ubuntu
    Ubuntu -- "Log Analysis" --> Fail2Ban[Fail2Ban Service]
    Ubuntu -- "Filter" --> UFW[UFW Firewall]
