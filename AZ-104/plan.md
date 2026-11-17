# AZ-104: 14-day study sprint — calendar brief for Gemini

## Dates and goals
- Time zone: **Europe/Zurich**. Fixed sprint: **17–30 November 2026**, inclusive.
- These explicit dates override the earlier phrase “starting tomorrow”: 17 November is today in the current context. Do not shift the sprint automatically; flag any elapsed sessions for replanning.
- Target: exam attempt #1 on **27 November**; practice assessment **25 November**; remediation **26 November**; conditional retake buffer **28–30 November**.
- Baseline: **52% overall**, taken before finishing the material. Approximate domain scores: Compute 30–35%, Monitor/Maintain 25%, Networking 55%, Identity/Governance 65–70%, Storage 75%.
- Priorities: Compute → Monitor/Backup → Networking → Identity/Governance → Storage. Cover every domain, with extra time for the first two.
- Readiness target: ≥80% on fresh mixed practice questions, no domain below 70%, and ability to explain choices without notes. This is a study target, not a guaranteed pass or an exam-score conversion.
- Core preparation: **25 hours through 26 November**; exam and conditional buffer time are additional.

## Session method and definition of done
For each 135-minute topic session: 55 min official learning → 40 min application → 30 min scenario questions → 10 min error log. Split across train journeys and a desk session if needed.

Application means a hands-on lab when available, otherwise a documented configuration walkthrough. Answer at least 15 topic questions per normal session; explain wrong answers and why alternatives fail. Record gaps in `AZ104-GAPS.md`: topic, mistake, correct rule, official reference, next review date. Aim for ≥80%; carry unresolved gaps into the next review.

## Daily calendar events
| Date | Event title | Duration | Topics / activity | Definition of done |
|---|---|---:|---|---|
| Tue 17 Nov | AZ-104 — Compute I: VMs and disks | 135 min | VM creation, sizing, OS/data/temp disks, managed disk types, encryption, resizing and moving VMs | Explain VM components and disk choices; configure or walk through one VM and disk change; complete topic questions. |
| Wed 18 Nov | AZ-104 — Compute II: Availability and IaC | 135 min | Availability Sets vs Zones, VM Scale Sets, scaling; ARM/Bicep resources, parameters, dependencies, deployment scopes | Choose availability options from scenarios; interpret and modify a small template; complete topic questions. |
| Thu 19 Nov | AZ-104 — Compute III: Apps and containers | 135 min | App Service plans, scale up/out, deployment slots, TLS/custom domains, backup; ACR, ACI and Container Apps | Select the right hosting service; explain slot swaps and scaling; deploy or trace one app/container; complete topic questions. |
| Fri 20 Nov | AZ-104 — Monitor, logs and alerts | 135 min | Azure Monitor metrics vs logs, diagnostic settings, Log Analytics, basic KQL, alerts, action groups, Insights | Trace a resource signal to an alert/action; interpret a simple query; complete topic questions. |
| Sat 21 Nov | AZ-104 — Backup, recovery and weak-domain check | 180 min | Backup policies, Recovery Services/Backup vault choices, restore, Site Recovery and failover; Network Watcher basics | 60 min learn + 45 min restore/failover walkthrough + 45 min fresh Compute/Monitor quiz (≥30 questions) + 30 min review. Log domain results and top three gaps; target ≥75%. |
| Sun 22 Nov | AZ-104 — Networking I: Connectivity and security | 135 min | VNets/subnets, IP addressing, peering, NSG/ASG rules, effective rules, UDRs, service/private endpoints | Trace a packet path and diagnose a blocked connection; explain endpoint choices; complete topic questions. |
| Mon 23 Nov | AZ-104 — Networking II: DNS and load balancing | 135 min | Public/private DNS, Azure Load Balancer, health probes, backend pools, connectivity troubleshooting | Resolve a DNS and a load-balancing scenario; check remaining networking objectives in the study guide; complete topic questions. |
| Tue 24 Nov | AZ-104 — Identity, governance and storage refresh | 180 min | 75 min Entra users/groups, guests, licensing, SSPR, RBAC scopes vs directory roles, Policy, locks, tags, management groups, budgets; 45 min storage redundancy, tiers/lifecycle, SAS/keys/RBAC, firewalls, Files/Blob recovery, AzCopy; 45 min mixed questions + 15 min log | Explain role/scope and Policy/lock differences; choose storage access/redundancy options; ≥25 mixed questions with reviewed answers. |
| Wed 25 Nov | AZ-104 — Practice assessment and diagnosis | 180 min | 90 min uninterrupted, closed-notes official practice assessment (or its stated duration); 60 min answer review; 30 min remediation plan | Save overall/domain results; rank gaps by frequency and exam impact. Target ≥80% overall and ≥70% per domain where reported; otherwise derive domain gaps from missed items. |
| Thu 26 Nov | AZ-104 — Remediation and readiness check | 150 min | 75 min top three gaps from 25 Nov; 45 min fresh mixed questions; 30 min review and exam logistics | Re-explain corrected rules; meet readiness target on fresh questions; verify booking, ID, route or online exam setup. If below target, flag postponement decision to user before any booking change. |
| Fri 27 Nov | AZ-104 — Exam attempt #1 | 30 min review + provisional 180 min exam block | Light recall only; exam block includes check-in and contingency, adjusted to booking confirmation | Attend confirmed exam; record outcome and domain feedback. Avoid heavy study immediately before exam. |
| Sat 28 Nov | AZ-104 — Conditional remediation / retake buffer | 90 min, conditional | If unsuccessful: review score report and remediate weakest domains. If passed: release buffer. | Document corrected gaps; consider one retake only after the required waiting period and sufficient preparation. |
| Sun 29 Nov | AZ-104 — Conditional readiness / retake buffer | 90 min, conditional | Fresh questions and targeted walkthroughs if still preparing; optional retake slot subject to availability | Recheck readiness; if retaking, replace study block with confirmed exam block plus check-in buffer. |
| Mon 30 Nov | AZ-104 — Final conditional retake buffer | Provisional 180 min, conditional | One retake if eligible, ready and booked; otherwise use 60–90 min to plan further remediation | Record outcome or next study steps. No assumption that a retake slot is available. |

## Train, subscription and lab notes
- Train-friendly: downloaded Learn material, notes, diagrams, template reading, flashcards and scenario questions. Download before travel; do not depend on train Wi-Fi.
- Desk session: Azure Portal/CLI labs, deployment, network testing and restore walkthroughs. Mark these calendar blocks “desk + internet required.”
- An Azure subscription is not assumed. If available, use a dedicated lab resource group, small resources and a budget alert; alerts do not cap spending. Remove lab resources after use and check for remaining billable disks, IPs and vault items.
- Without a subscription, continue on schedule using official lab instructions, screenshots and configuration reasoning. Mark activities as walkthroughs, not completed deployments; revisit the highest-priority labs when access is available. Do not assume a free sandbox exists.
- Prepare learning links, offline notes and the gap log before the first session; avoid letting setup consume the study block.

## Instructions for Gemini scheduling
1. Inspect calendar availability in Europe/Zurich. Use the exact dates, event titles, durations, topics and completion criteria above in event descriptions.
2. Prefer existing train journeys for learning/questions; use available desk time for labs. Commute times are unknown: use calendar evidence or ask for them. Do not invent train times or move existing commitments.
3. Split normal sessions into 45–75 minute blocks when useful, preserving total study time and learning → application → questions → log order. Add 5–10 minute breaks outside study durations. Keep the 25 Nov assessment uninterrupted.
4. Keep 25 Nov assessment, 26 Nov remediation and 27 Nov exam target fixed. If time is insufficient, flag the conflict; prioritize Compute and Monitor/Backup while retaining coverage of all domains. Do not silently compress or omit work.
5. Treat 27 Nov as a tentative exam hold until a real booking is confirmed. Calendar scheduling does not book or pay for the exam. Adjust the hold to the provider's confirmed appointment and check-in requirements.
6. Reserve 28–30 Nov as tentative availability for **one conditional retake**, not three exam attempts. Microsoft requires at least 24 hours after the first failed attempt; after a second failed attempt, the next wait is 14 days. Confirm eligibility, price and slot availability before booking. Release unused holds after passing.
7. Add a 15-minute reminder to study events. Use booking-specific exam reminders. Avoid overlapping events; if dates have elapsed, ask how to redistribute unfinished work without automatically shifting exam milestones.

## Official resources
- [AZ-104 study guide and objective checklist](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104) — use the objectives applicable to the exam date/language; check off coverage by 24 Nov.
- [AZ-104 certification, training and practice assessment](https://learn.microsoft.com/en-us/credentials/certifications/azure-administrator/) — follow the current practice-assessment link; prefer the updated experience over the legacy assessment. Use fresh questions to limit memorization effects.
- [Official AZ-104 lab instructions](https://microsoftlearning.github.io/AZ-104-MicrosoftAzureAdministrator/).
- [Microsoft exam retake policy](https://learn.microsoft.com/en-us/credentials/support/retake-policy).

## Stato attuale — aggiornato il 17/11/2026
- Valutazione iniziale: 52% complessivo.
- Sessioni completate: nessuna.
- Argomento attuale: Compute I — VM e dischi.
- Difficoltà riscontrate: da rilevare.
- Ultimo quiz: non ancora svolto.
- Prossimo passo: completare la prima sessione Compute.