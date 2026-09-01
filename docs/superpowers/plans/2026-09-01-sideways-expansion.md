# On Your Processor Sideways Expansion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Expand the current manuscript into an 18-chapter, 22,000–25,000-word technical-comedy book whose new length comes from new kinds of jurisdiction.

**Architecture:** Redistribute the overloaded session, trust, and entitlement material into chapters with exclusive responsibilities, add TCC, policy, entitlement, and lightweight virtualization chapters, then preserve the existing three-part ending. Chapter Markdown remains authoritative; the existing build generates the continuous manuscript, HTML, and EPUB.

**Tech Stack:** Markdown, POSIX shell, Pandoc when available, existing receipt and canon ledgers.

**Spec:** `docs/superpowers/specs/2026-09-01-sideways-expansion-design.md`

## Global Constraints

- Preserve the technical-integrity rule verbatim: if proven, say it; if inferred, label it; if an undocumented Apple string exists, quote it without inventing semantics.
- Preserve every line in `notes/editorial-protections.md` verbatim.
- Preserve every recurring element in `notes/canon.md`.
- Keep Hardware Family Dinner, Shutdown, and Hyprvisor as the final three consecutive beats.
- Keep the final nonblank line exactly `moo.` with no reading-copy prose after it.
- Keep Chapter 15 conceptual; do not add VMCS internals, trap taxonomy, nested page tables, or SVM-versus-VMX history.
- Treat `chapters/*.md` as source and `manuscript.md`, HTML, and EPUB as generated outputs.
- Never stage unrelated `build.sh`, `book/`, `dist/`, or `notes/synopsis.md` changes in an editorial commit.

---

### Task 1: Freeze and audit the v0.3 spine

**Files:**
- Create: `releases/HELLO-CHILDREN-v0.3.md`
- Create: `notes/receipts-v0.4.md` from the frozen `notes/receipts-v0.3.md`
- Modify: `README.md`
- Modify: `notes/editorial-protections.md`
- Modify: `notes/canon.md`

**Interfaces:**
- Consumes: Current authoritative chapter files and the working `./build.sh`.
- Produces: A frozen pre-expansion manuscript and an updated protection ledger used by every later task.

- [ ] **Step 1: Rebuild the current source manuscript**

Run:

```sh
./build.sh
```

Expected: exit 0, `built manuscript.md`, and a final nonblank line of `moo.`. Pandoc outputs are expected when Pandoc is installed.

- [ ] **Step 2: Freeze the exact v0.3 reading copy**

Run:

```sh
test ! -e releases/HELLO-CHILDREN-v0.3.md
cp manuscript.md releases/HELLO-CHILDREN-v0.3.md
cksum releases/HELLO-CHILDREN-v0.3.md
wc -w releases/HELLO-CHILDREN-v0.3.md
```

Record the checksum and word count in `README.md` beside the existing frozen-release references.

- [ ] **Step 3: Start the expansion receipts without rewriting v0.3 history**

Run:

```sh
test ! -e notes/receipts-v0.4.md
cp notes/receipts-v0.3.md notes/receipts-v0.4.md
```

All later expansion tasks modify `notes/receipts-v0.4.md`; the v0.3 receipt ledger remains frozen with its manuscript.

- [ ] **Step 4: Add the approved new jokes to the ledgers**

Record the politics line as narrator satire, not an Apple-intent claim. Record the `GenuineApple™`/`branding transcends ISA` exchange as fake launchd dialogue, record `that's your résumé` as Gatekeeper dialogue, and retain the separate UID 2 canon elsewhere.

- [ ] **Step 5: Verify the freeze and protections**

Run:

```sh
cmp manuscript.md releases/HELLO-CHILDREN-v0.3.md
rg -n 'Apple and modern politics still argue|GenuineApple™|branding transcends ISA|that.s your résumé|UID 2|moo\.' chapters notes releases/HELLO-CHILDREN-v0.3.md
```

Expected: `cmp` exits 0; both new jokes, the UID 2 canon, and `moo.` are found.

- [ ] **Step 6: Commit only the freeze and ledgers**

```sh
git add releases/HELLO-CHILDREN-v0.3.md README.md notes/receipts-v0.4.md notes/editorial-protections.md notes/canon.md chapters/06-sessions-and-windows.md chapters/07-trust-and-signatures.md manuscript.md
git commit -m "freeze v0.3 manuscript"
```

### Task 2: Separate session authority from graphical authority

**Files:**
- Modify: `chapters/06-sessions-and-windows.md`
- Create: `chapters/07-those-are-my-windows.md`
- Rename: `chapters/07-trust-and-signatures.md` to `chapters/08-trust-and-signatures.md`
- Rename: `chapters/08-neighborhood-services.md` to `chapters/12-sharingd-knows-a-guy.md`
- Rename: `chapters/09-memory-and-borders.md` to `chapters/13-memory-has-borders.md`
- Rename: `chapters/10-sep-and-the-mailbox.md` to `chapters/14-sep-has-a-mailbox.md`
- Rename: `chapters/11-hardware-family-dinner.md` to `chapters/16-hardware-family-dinner.md`
- Rename: `chapters/12-shutdown.md` to `chapters/17-shutdown.md`
- Rename: `chapters/13-epilogue.md` to `chapters/18-epilogue.md`
- Modify: `notes/fact-check-ledger.md`
- Modify: `notes/receipts-v0.4.md`

**Interfaces:**
- Consumes: Current Chapter 6 loginwindow, WindowServer, GPU, display, and Finder material.
- Produces: Chapter 6 owning authenticated session formation and Chapter 7 owning graphical government.

- [ ] **Step 1: Move existing chapters into their final numbered slots**

Run:

```sh
git mv chapters/08-neighborhood-services.md chapters/12-sharingd-knows-a-guy.md
git mv chapters/09-memory-and-borders.md chapters/13-memory-has-borders.md
git mv chapters/10-sep-and-the-mailbox.md chapters/14-sep-has-a-mailbox.md
git mv chapters/11-hardware-family-dinner.md chapters/16-hardware-family-dinner.md
git mv chapters/12-shutdown.md chapters/17-shutdown.md
git mv chapters/13-epilogue.md chapters/18-epilogue.md
git mv chapters/07-trust-and-signatures.md chapters/08-trust-and-signatures.md
```

The temporary numbering gaps at Chapters 9–11 and 15 are intentional and will be filled by later tasks.

- [ ] **Step 2: Move, do not duplicate, the graphical sections**

Move `Those are my windows`, `The pixel custody dispute`, and `Private archaeology` into Chapter 7. Keep login authentication, root at the desk, per-user environment formation, and the politics punchline in Chapter 6.

- [ ] **Step 3: Add only the missing connective tissue**

Chapter 6 must distinguish account identity, authenticated session, and per-user service environment. Chapter 7 must distinguish app-owned content, WindowServer-managed graphical objects, GPU execution, display scanout, and physical light.

- [ ] **Step 4: Add the session-path diagram**

Use one fenced `text` diagram showing `loginwindow`, per-user services, WindowServer, GPU/display, and the user. Remove any paragraph that merely restates the finished diagram.

- [ ] **Step 5: Audit every private claim**

Keep archived loginwindow documentation visibly historical. Keep the Finder integer as third-party source evidence. Do not promote private SkyLight behavior to a stable Apple contract.

- [ ] **Step 6: Verify exclusive responsibilities**

Run:

```sh
rg -n '^## ' chapters/06-*.md chapters/07-*.md
wc -w chapters/06-*.md chapters/07-*.md
./build.sh
```

Expected: each section appears in only one chapter, both chapters fall near 1,100–1,300 words, and the build exits 0.

- [ ] **Step 7: Commit the session/window split and final numbering slots**

```sh
git add chapters/06-sessions-and-windows.md chapters/07-those-are-my-windows.md chapters/08-trust-and-signatures.md chapters/12-sharingd-knows-a-guy.md chapters/13-memory-has-borders.md chapters/14-sep-has-a-mailbox.md chapters/16-hardware-family-dinner.md chapters/17-shutdown.md chapters/18-epilogue.md manuscript.md notes/fact-check-ledger.md notes/receipts-v0.4.md
git commit -m "split session and graphical authority"
```

### Task 3: Separate code identity from policy operations

**Files:**
- Modify: renumbered `chapters/08-trust-and-signatures.md`
- Create: `chapters/09-policy-is-not-enforcement.md`
- Modify: `notes/fact-check-ledger.md`
- Modify: `notes/receipts-v0.4.md`

**Interfaces:**
- Consumes: Existing code-signing, AMFI, Gatekeeper, notarization, and runtime-policy material.
- Produces: Chapter 8 owning code identity and Chapter 9 owning evaluation, blocking, detection, and remediation.

- [ ] **Step 1: Refocus Trust and Signatures**

Keep signature identity, integrity, trust caches, AMFI/kernel enforcement, ad hoc signing, entitlements-as-claims, `amfid: signature?`, and the `GenuineApple™`/`branding transcends ISA` exchange. Move first-open policy and remediation material out.

- [ ] **Step 2: Draft Policy Is Not Enforcement**

Explain Gatekeeper, `syspolicyd`, XProtect, and MRT only to the level supported by public documentation or labeled observations. Organize the chapter around four verbs: evaluate, block, detect, remediate.

- [ ] **Step 3: Give every component a scoped refusal**

At least one dialogue beat must demonstrate that a favorable answer to one security question does not answer the next. Do not turn the components into a single bouncer wearing several hats.

- [ ] **Step 4: Add receipts before strengthening prose**

Create `PUB-POLICY-*` and, where reproducible, `OBS-POLICY-*` entries. For `syspolicyd`, state only documented roles or exact observations; do not infer a complete private request path.

- [ ] **Step 5: Verify wording and build**

Run:

```sh
rg -n 'sole|always|every execution|decides whether code may run' chapters/08-*.md chapters/09-*.md
wc -w chapters/08-*.md chapters/09-*.md
./build.sh
```

Review every match for overclaiming. Expected target: 1,300–1,500 words per chapter and build exit 0.

- [ ] **Step 6: Commit code-identity and policy chapters**

```sh
git add chapters/08-trust-and-signatures.md chapters/09-policy-is-not-enforcement.md manuscript.md notes/fact-check-ledger.md notes/receipts-v0.4.md
git commit -m "separate code trust from security policy"
```

### Task 4: Add TCC as consent authority

**Files:**
- Create: `chapters/10-consent-is-its-own-authority.md`
- Modify: `notes/fact-check-ledger.md`
- Modify: `notes/receipts-v0.4.md`

**Interfaces:**
- Consumes: Code identity established in Chapter 8 and policy separation established in Chapter 9.
- Produces: A chapter where consent, protected resource, and responsible code identity form a jurisdiction distinct from Unix credentials.

- [ ] **Step 1: Add primary-source receipts**

Add `PUB-TCC-*` entries from Apple privacy-control, developer, and platform-security documentation. Label any `tccd` or private entitlement observation `OBS-TCC-*` with the exact build.

- [ ] **Step 2: Draft the chapter around one request**

Follow one app requesting a protected resource. Show that filesystem permission, code identity, entitlement, user consent, and TCC policy answer different questions.

- [ ] **Step 3: Add the comparison sidebar**

`Three Different Ways to Say No` compares root, TCC approval, and entitlement in no more than 300 words. It must state that a normal app with appropriate approval does not thereby become more globally privileged than root.

- [ ] **Step 4: Add the multi-desk diagram**

Use a fenced `text` diagram showing identity, policy, consent, entitlement, and enforcement. Delete prose made redundant by the diagram.

- [ ] **Step 5: Verify technical qualifiers**

Run:

```sh
rg -n 'root|Full Disk Access|consent|entitlement|responsible|tccd' chapters/10-consent-is-its-own-authority.md
wc -w chapters/10-consent-is-its-own-authority.md
./build.sh
```

Expected: 1,300–1,600 words, visible qualifiers on private behavior, and build exit 0.

- [ ] **Step 6: Commit the TCC chapter**

```sh
git add chapters/10-consent-is-its-own-authority.md manuscript.md notes/fact-check-ledger.md notes/receipts-v0.4.md
git commit -m "add TCC consent jurisdiction"
```

### Task 5: Establish entitlement bureaucracy, then prove it with sharingd

**Files:**
- Create: `chapters/11-the-entitlement-bureaucracy.md`
- Modify: `chapters/12-sharingd-knows-a-guy.md`
- Modify: `notes/canon.md`
- Modify: `notes/fact-check-ledger.md`
- Modify: `notes/receipts-v0.4.md`

**Interfaces:**
- Consumes: Existing `amfid` and `sharingd` entitlement observations.
- Produces: One general capability-credential chapter followed by one character-driven case study.

- [ ] **Step 1: Reproduce the selected entitlement census**

Extract complete XML values for Console, Safari, `sharingd`, `amfid`, and MRT on the named target build. Count top-level keys only. Store raw dumps outside Git according to the existing receipt workflow.

- [ ] **Step 2: Draft The Entitlement Bureaucracy**

Explain signed claims, issuing authority, runtime checks, narrow versus broad credentials, and why typing a private entitlement does not grant it.

- [ ] **Step 3: Add both Chapter 11 sidebars**

`The Badge Census` gives build-labeled comparisons without treating counts as rank. `An Entitlement Name Is Not a Confession` separates a signed claim from observed behavior, backend authorization, and complete semantics.

- [ ] **Step 4: Compress sharingd into a case study**

Retain its diplomatic-passport entrance, conservative interpretation of `masquerade` and `impersonate`, Share-button summons, `amfid` comparison, and final badge drop. Remove general entitlement explanations now owned by Chapter 11.

- [ ] **Step 5: Verify counts and non-duplication**

Run:

```sh
rg -n 'top-level|build|masquerade|impersonate|rank|badge' chapters/11-*.md chapters/12-*.md notes/receipts-v0.4.md
wc -w chapters/11-*.md chapters/12-*.md
./build.sh
```

Expected: every count names a build, Chapter 11 owns the general rule, Chapter 12 owns the case study, and build exits 0.

- [ ] **Step 6: Commit entitlement chapters**

```sh
git add chapters/11-the-entitlement-bureaucracy.md chapters/12-sharingd-knows-a-guy.md manuscript.md notes/canon.md notes/fact-check-ledger.md notes/receipts-v0.4.md
git commit -m "add entitlement bureaucracy and sharingd case study"
```

### Task 6: Renumber and deepen memory and SEP without padding

**Files:**
- Modify: `chapters/13-memory-has-borders.md`
- Modify: `chapters/14-sep-has-a-mailbox.md`
- Modify: `notes/canon.md`
- Modify: `notes/fact-check-ledger.md`
- Modify: `notes/receipts-v0.4.md`

**Interfaces:**
- Consumes: The approved Chapter 9 comedy repair and existing SEP mailbox evidence.
- Produces: Renumbered chapters with diagrams and one SEP-mailbox sidebar, not repeated thesis prose.

- [ ] **Step 1: Add the address-map diagram**

Show process virtual address, CPU translation, device-visible I/O mapping, and physical memory. Preserve `do you have an address or a podcast`, `DART: absolutely fucking not`, and the protected DRAM line.

- [ ] **Step 2: Add the AP-to-SEP diagram**

Show AP software, mailbox-style communication, SEP software, and protected resources. The arrows prove communication only; they must not imply successful authorization.

- [ ] **Step 3: Add The Mailboxes Are Not Related**

Use fake launchd attempting `/var/mail` delivery to SEP. Explicitly state that Unix mail and the hardware mailbox are unrelated mechanisms.

- [ ] **Step 4: Verify evidence classes**

Keep Apple’s public `IOMMU` terminology separate from Asahi’s DART naming. Keep Apple’s Secure Enclave documentation separate from reverse-engineered mailbox evidence.

- [ ] **Step 5: Verify protected lines and build**

Run:

```sh
rg -n 'podcast|absolutely fucking not|DRAM cells|on your processor|/var/mail|mailbox' chapters/13-*.md chapters/14-*.md
wc -w chapters/13-*.md chapters/14-*.md
./build.sh
```

Expected: all protected jokes remain, each chapter stays below approximately 1,500 words, and build exits 0.

- [ ] **Step 6: Commit memory and SEP work**

```sh
git add chapters/13-memory-has-borders.md chapters/14-sep-has-a-mailbox.md manuscript.md notes/canon.md notes/fact-check-ledger.md notes/receipts-v0.4.md
git commit -m "deepen memory and SEP boundaries"
```

### Task 7: Add lightweight Apple virtualization and preserve the ending

**Files:**
- Create: `chapters/15-the-house-inside-the-house.md`
- Modify: `chapters/16-hardware-family-dinner.md`
- Modify: `chapters/17-shutdown.md`
- Modify: `chapters/18-epilogue.md`
- Modify: `notes/canon.md`
- Modify: `notes/editorial-protections.md`
- Modify: `notes/fact-check-ledger.md`
- Modify: `notes/receipts-v0.4.md`

**Interfaces:**
- Consumes: Official Hypervisor.framework and Virtualization.framework documentation plus the existing final three chapters.
- Produces: A conceptual host/guest chapter that hands off to Hyprvisor without spending the epilogue’s joke.

- [ ] **Step 1: Add official virtualization receipts**

Create `PUB-VIRT-*` receipts for the two Apple frameworks. Do not introduce reverse-engineered CPU internals when public framework documentation is sufficient.

- [ ] **Step 2: Draft The House Inside the House**

Explain only that lower-level virtualization machinery supports virtual CPUs and guest memory, while the higher-level framework configures and operates complete VMs. Center the chapter on host resource authority versus guest kernel authority.

- [ ] **Step 3: Add the nested-house diagram and short sidebar**

The diagram shows host, VM process/frameworks, guest kernel, and guest userspace. `The Abandoned Apartments` gives ring 1 and ring 2 one brief joke; it does not teach x86 privilege history.

- [ ] **Step 4: End with foreshadowing, not Hyprvisor**

Conclude Chapter 15 with the idea that the guest kernel may govern the house while the lease remains upstairs. Do not name Hyprvisor or use the ring-0 exchange there.

- [ ] **Step 5: Renumber the sacred ending**

Hardware Family Dinner becomes Chapter 16, Shutdown Chapter 17, and One More Jurisdiction Chapter 18. Change only references made stale by renumbering. Keep `moo.` as the final nonblank line.

- [ ] **Step 6: Verify depth and ending**

Run:

```sh
rg -n 'VMCS|nested page|trap taxonomy|SVM|VMX|hyprvisor|moo\.' chapters/15-*.md chapters/18-*.md
awk 'NF { line=$0 } END { print line }' chapters/18-*.md
wc -w chapters/15-*.md chapters/18-*.md
./build.sh
```

Expected: forbidden deep-dive terms are absent from Chapter 15, Hyprvisor appears in Chapter 18, the final line is `moo.`, and build exits 0.

- [ ] **Step 7: Commit virtualization and ending**

```sh
git add chapters/15-the-house-inside-the-house.md chapters/16-hardware-family-dinner.md chapters/17-shutdown.md chapters/18-epilogue.md manuscript.md notes/canon.md notes/editorial-protections.md notes/fact-check-ledger.md notes/receipts-v0.4.md
git commit -m "add virtualization jurisdiction and preserve ending"
```

### Task 8: Add the opening map, perform the compression pass, and publish v0.4

**Files:**
- Modify: `chapters/00-title.md`
- Modify: `chapters/01-nobody-is-actually-in-charge.md`
- Modify as required: all numbered chapter files, only for duplication removal and transitions.
- Modify: `README.md`
- Modify: `STYLE.md`
- Modify: `VERSION`
- Modify: `notes/canon.md`
- Modify: `notes/editorial-protections.md`
- Modify: `notes/fact-check-ledger.md`
- Modify: `notes/receipts-v0.4.md`
- Generated: `manuscript.md`
- Generated when Pandoc is installed: `dist/HELLO-CHILDREN.html`, `dist/HELLO-CHILDREN.epub`

**Interfaces:**
- Consumes: All completed chapter tasks and existing build assets.
- Produces: The coherent v0.4 reading copy and formatted artifacts.

- [ ] **Step 1: Add the opening jurisdiction map**

Place one fenced `text` diagram in Chapter 1 mapping authority to object, boundary, and enforcement. Cut adjacent paragraphs that restate the diagram.

- [ ] **Step 2: Update navigation and version metadata**

Set `VERSION` to `0.4`. Update the title/editorial note, README table of contents, numbered structural protections, and canon chapter references for all 18 chapters.

- [ ] **Step 3: Run the repetition audit**

Run:

```sh
rg -n -i 'authority has a jurisdiction|authority needs a noun|not omnipotent|breadth is not rank|root is not|one authority' chapters
```

Review every match. Keep deliberate callbacks; delete paragraphs that merely re-explain a rule already established.

- [ ] **Step 4: Run the evidence audit**

For every new Apple API, daemon, private entitlement, count, or behavior, confirm a corresponding ledger row and receipt entry. Downgrade unsupported declarative prose to explicit inference or remove it.

- [ ] **Step 5: Run the canon and protection audit**

Run exact-string searches for every line in `notes/editorial-protections.md` and every recurring joke in `notes/canon.md`. Confirm Hardware Family Dinner, Shutdown, and Hyprvisor are Chapters 16–18.

- [ ] **Step 6: Build all artifacts**

Run:

```sh
./build.sh
```

Expected: exit 0; `manuscript.md` built; HTML and EPUB built when Pandoc is installed.

- [ ] **Step 7: Verify length, order, and final line**

Run:

```sh
test "$(find chapters -maxdepth 1 -name '[0-9][0-9]-*.md' | wc -l | tr -d ' ')" = 19
test "$(rg -c '^# [0-9]+\.' manuscript.md)" = 18
wc -w manuscript.md
awk 'NF { line=$0 } END { print line }' manuscript.md
```

Expected: 19 source files including `00-title.md`, 18 numbered chapters, 22,000–25,000 words, and final line `moo.`.

- [ ] **Step 8: Inspect generated HTML and EPUB**

Open the HTML and EPUB through the current app workflow. Check title hierarchy, table of contents, fenced diagrams, blockquote sidebars, page breaks, and the final `moo.`. Correct source Markdown or book CSS, then rebuild; do not patch generated output directly.

- [ ] **Step 9: Commit the completed expansion**

```sh
git add chapters README.md STYLE.md VERSION notes/canon.md notes/editorial-protections.md notes/fact-check-ledger.md notes/receipts-v0.4.md manuscript.md dist/HELLO-CHILDREN.html dist/HELLO-CHILDREN.epub
git commit -m "release v0.4 sideways expansion"
```
