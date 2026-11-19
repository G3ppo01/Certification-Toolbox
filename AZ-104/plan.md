# AZ-104 — Revised Study Plan

## Context

- Current date: **19 November 2026**
- Goal: be ready to attempt **AZ-104 by the end of November 2026**, if readiness is sufficient.
- Exam is **not booked yet**.
- If the next practice assessment shows that readiness is still too low, postpone the exam instead of forcing an attempt.
- Initial baseline practice assessment: **52% overall**.
- Approximate initial strengths/weaknesses:
  - Storage: ~75%
  - Identity & Governance: ~65–70%
  - Networking: ~55%
  - Compute: ~30–35%
  - Monitor / Maintain: ~25%
- Current progress:
  - Compute study has started.
  - Completed the introductory Azure VM checklist unit.
  - Notes have been too detailed and are slowing down progress.
- New strategy:
  - prioritize **coverage + active recall + targeted labs**
  - reduce note-taking
  - use labs only where hands-on work adds real value
  - use practice results to decide whether to book the exam

---

# Main Priorities

Study priority based on exam weight + current weaknesses:

1. **Compute**
2. **Monitor / Backup / Recovery**
3. **Networking**
4. **Identity & Governance**
5. **Storage**

Do not study all domains equally.

The goal is to turn strong areas into reliable points and rapidly raise weak areas to a safe level.

---

# Study Method

For each study block:

1. **Official Microsoft Learn / documentation**
2. **Minimal notes**
3. **Scenario questions / active recall**
4. **Hands-on only if useful**
5. **Log mistakes**

Target structure for a normal session:

- 50–70 min learning
- 15–25 min concise notes
- 25–40 min questions / recall
- 10 min gap log
- optional 20–40 min lab when worthwhile

## Note-taking rule

Do **not** rewrite Microsoft Learn.

Only note:

- Azure-specific behavior
- differences between similar services
- exam traps
- values/rules worth remembering
- things I got wrong
- things I did not already know

Example:

Do not write:

> A subnet is a subdivision of a network.

Write:

> Azure reserves the first 4 IPs and the last IP of every subnet.

Target compression:

> ~10 pages of Microsoft Learn → 1–2 pages of useful notes

---

# Readiness Criteria

The next practice assessment is the main decision point.

## Green light

Book / sit the exam if:

- overall score is **80%+**
- no major domain is below **70%**
- I can explain why wrong answers are wrong
- results are not just memorized from previous questions

## Borderline

If overall score is **75–79%**:

- review the type of mistakes
- if mainly details / wording → exam may still be reasonable
- if major conceptual gaps remain → postpone

## Not ready

If overall score is:

- **65–74%** → postpone a few days and remediate
- **below 65%** → postpone and rebuild the plan around weak domains

---

# Revised Calendar Plan

## Friday 20 November — Compute I: VM Core

**Duration:** 2h

### Topics

- VM architecture
- VM sizes
- images
- OS disk
- data disks
- temporary disk
- managed disks
- resizing
- deallocation
- Azure Compute Gallery

### Study goal

Be able to explain:

- what resources a VM depends on
- OS disk vs data disk vs temporary disk
- what happens when a VM is stopped vs deallocated
- how VM size affects compute and NIC limits
- why managed disks exist

### Lab

No subscription required yet.

Read simple VM creation workflows, Bicep/ARM examples and PowerShell commands.

### Done when

- VM fundamentals can be explained without notes
- at least 15 Compute questions completed
- unclear topics added to `AZ104-GAPS.md`

---

## Saturday 21 November — Compute II: Availability and Scale

**Duration:** 2h30

### Topics

- Availability Sets
- Fault Domains
- Update Domains
- Availability Zones
- VM Scale Sets
- autoscaling
- scale up vs scale out

### Key comparison

Be able to choose between:

- single VM
- Availability Set
- Availability Zone
- VM Scale Set

### Optional lab

If no subscription:

- study diagrams and deployment workflows only

If subscription exists:

- create a small VMSS
- inspect instances
- inspect scaling settings
- delete resources afterward

### Done when

- availability choices can be selected from scenarios
- at least 20 scenario questions completed
- weak concepts logged

---

## Sunday 22 November — Compute III: App Service, Containers and IaC

**Duration:** 2h30

### Topics

#### App Service

- App Service Plan
- scaling
- deployment slots
- custom domains
- TLS
- backups
- networking basics

#### Containers

- Azure Container Registry
- Azure Container Instances
- Azure Container Apps

#### IaC

- ARM templates
- Bicep
- parameters
- variables
- resources
- outputs
- deployment scope

### Goal

Do not learn Bicep deeply.

Be able to:

- read a basic Bicep template
- recognize what is being deployed
- understand parameterization
- choose ACI vs Container Apps vs App Service in simple scenarios

### Done when

- 20+ Compute questions completed
- target **70%+ on Compute mini-test**

---

## Monday 23 November — Monitor, Logs and Alerts

**Duration:** 2h15

### Topics

- Azure Monitor
- metrics vs logs
- Log Analytics Workspace
- diagnostic settings
- alerts
- action groups
- Insights
- basic KQL recognition
- Activity Log

### Mental model

Resource  
→ metric / log  
→ Azure Monitor  
→ alert rule  
→ action group  
→ notification / automation

### Done when

- difference between metrics, logs and Activity Log is clear
- can explain alert + action group workflow
- can read a basic KQL query
- 15–20 questions completed

---

## Tuesday 24 November — Backup, Recovery and Network Monitoring

**Duration:** 2h15

### Topics

- Azure Backup
- Backup Vault
- Recovery Services Vault
- backup policies
- restore
- Site Recovery
- failover
- Network Watcher
- Connection Monitor

### Key comparison

Be able to explain:

- Backup vs Site Recovery
- Recovery Services Vault vs Backup Vault at a high level
- backup vs business continuity / disaster recovery

### Done when

- restore and failover workflows are understood
- 15–20 questions completed
- Monitor/Backup mini-test target: **70%+**

---

## Wednesday 25 November — Networking I

**Duration:** 2h15

### Topics

- VNets
- subnets
- IP addressing
- NSG
- ASG
- effective security rules
- UDR
- VNet peering
- Bastion
- public IP

### Existing knowledge

Do not spend time relearning:

- subnet basics
- routing basics
- firewall basics
- CIDR fundamentals

Focus on **Azure-specific implementation**.

### Done when

- can trace traffic through subnet/NIC NSGs
- can reason about effective rules
- can explain UDR and peering
- 20 networking questions completed

---

## Thursday 26 November — Networking II + Storage Refresh

**Duration:** 2h30

### Networking

- Private Endpoint
- Service Endpoint
- Private DNS
- Azure DNS
- internal vs public Load Balancer
- health probes
- backend pools
- troubleshooting connectivity

### Storage refresh

Only revise:

- redundancy
- SAS
- keys vs identity
- Blob tiers
- lifecycle management
- Azure Files
- Storage firewall
- AzCopy / Storage Explorer

### Key comparison

Know clearly:

- Private Endpoint vs Service Endpoint
- LRS / ZRS / GRS / GZRS
- SAS vs access keys vs RBAC

### Done when

- Networking quiz: target **75%+**
- Storage quiz: target **80%+**

---

## Friday 27 November — Identity and Governance Refresh

**Duration:** 2h

### Focus only on Azure-specific areas

- Azure RBAC
- scopes
- inheritance
- custom roles
- Management Groups
- subscriptions
- Resource Groups
- Azure Policy
- resource locks
- tags
- budgets
- Advisor

### Do not over-study familiar IAM topics

Entra users/groups are already relatively strong.

### Key comparisons

- Azure RBAC vs Entra roles
- RBAC vs Azure Policy
- Policy vs resource locks
- subscription vs management group vs resource group scope

### Done when

- 20 governance questions completed
- target **80%+**

---

## Saturday 28 November — Full Practice Assessment

**Duration:** 2h30–3h

### Rules

- fresh attempt
- closed notes
- no web search
- treat it like the exam

### After assessment

Record:

- overall score
- domain scores
- every wrong answer
- every guessed answer
- every topic that felt uncertain

Update:

`AZ104-GAPS.md`

### Decision

#### If ≥80%

Book the exam for the earliest reasonable slot near the end of November / beginning of December.

#### If 75–79%

Do targeted remediation Sunday and decide afterward.

#### If <75%

Do not rush the exam.

Postpone and rebuild the next study phase from the weak domains.

---

## Sunday 29 November — Targeted Remediation

**Duration:** 2–3h

Study **only** the top weaknesses from the 28 November assessment.

Do not restart entire Microsoft Learn paths.

For each weak topic:

1. read official documentation
2. write 3–5 concise bullets
3. complete targeted questions
4. explain the concept aloud / from memory

### Done when

- top 3 weaknesses have been reviewed
- fresh questions on those topics reach ~80%

---

## Monday 30 November — Readiness Check / Optional Exam Window

**Duration:** depends on outcome

### If ready

- light review only
- no new major topics
- sit AZ-104 if a suitable exam slot is available

### If not ready

- do not force an exam just to meet the November target
- move the exam to early December
- continue targeted remediation

---

# Azure Subscription Strategy

Do not create an Azure subscription just to complete very basic introductory labs.

Create/use a subscription when hands-on work becomes valuable for:

- VM Scale Sets
- disks
- NSGs
- VNet peering
- Private Endpoints
- Service Endpoints
- Azure Monitor
- Log Analytics
- Azure Backup
- App Service
- Policy / RBAC / Locks

Use a dedicated lab resource group.

Example:

```text
RG-AZ104-LAB
```

After each lab:

- delete unnecessary resources
- check remaining disks
- check public IPs
- check vault items
- verify nothing billable was accidentally left behind

---

# NotebookLM Strategy

Use NotebookLM as a study assistant, not as the source of truth.

Source of truth:

1. official AZ-104 study guide
2. Microsoft Learn
3. official Microsoft documentation
4. existing Geneva training notes and labs

Use NotebookLM for:

- scenario questions
- flashcards
- comparisons
- active recall
- weak-topic drills

Prefer questions like:

> A company has VNet A, VNet B and a storage account with requirement X. Which Azure configuration satisfies the requirement with the least administrative effort?

Avoid spending too much time on definition-only questions.

---

# Gap Log

Maintain:

```text
AZ104-GAPS.md
```

Format:

```md
## Compute

✅ Managed disks
⚠️ Availability Set vs Zone
❌ VMSS autoscale rules

## Networking

✅ NSG
⚠️ Load Balancer probes
❌ Private Endpoint + Private DNS

## Monitor

❌ Diagnostic settings
⚠️ Metrics vs Logs
```

Legend:

- ✅ confident
- ⚠️ partially understood
- ❌ weak / wrong in practice

Use the gap log to decide the next review session.

---

# Instructions for Gemini Calendar Scheduling

Use this plan to update my calendar.

## Scheduling rules

1. Time zone: **Europe/Zurich**.
2. Schedule sessions from **20 November through 30 November 2026**.
3. Preserve the topic order unless calendar conflicts make that impossible.
4. Prefer:
   - train time for reading, notes, flashcards and questions
   - desk/internet time for labs
5. Sessions may be split into 45–75 minute blocks if necessary.
6. Preserve the total planned study duration for each day.
7. Do not schedule labs during train travel unless no Azure interaction is required.
8. Add a **15-minute reminder** to study sessions.
9. Keep **28 November** reserved for the full practice assessment.
10. Keep **29 November** for remediation based on that result.
11. Treat **30 November** as a readiness/exam window, not as a mandatory exam date.
12. Do not create an exam booking automatically.
13. If there is insufficient free time, prioritize:
    - Compute
    - Monitor / Backup
    - Networking
14. Do not silently delete missed topics. Flag them for replanning.
15. If a session has already elapsed when this file is imported, reschedule it into the next available slot without moving the practice assessment unless necessary.

---

# Target Outcome

By the next full practice assessment:

- Compute: **≥75%**
- Monitor / Backup: **≥70%**
- Networking: **≥75%**
- Identity / Governance: **≥80%**
- Storage: **≥80%**
- Overall: **≥80% preferred**

The goal is not to finish every Microsoft Learn page.

The goal is to be able to correctly reason through AZ-104 scenarios across all exam domains.
