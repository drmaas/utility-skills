---
name: meeting-recap
description: >-
  Turn a meeting transcript (pasted text, file, doc, or recording link) into a
  trustworthy recap with TL;DR, decisions, single-owner action items with
  resolved dates, discussion by topic, risks, and open questions. Use when the
  user shares a transcript or asks for meeting notes, minutes, a debrief, a
  wrap-up, standup notes, 1:1 notes, retro notes, or "what did we decide".
  Trigger on sharing raw ASR output, pasted chat logs from a call, or a
  recording link plus a request to summarize. Do not use for summarizing a
  document, article, or codebase when no meeting happened.
compatibility: >-
  No special tooling required. Use a real calendar or the `date` command for
  date resolution; never compute dates mentally. Optional: a transcription tool
  (whisper, or an Otter-style export) when the input is audio or video only.
metadata:
  repository: https://github.com/drmaas/utility-skills
---

# Meeting Recap

A recap earns trust when every claim traces back to the transcript and nothing important hides in the middle. Optimize for three things: **traceable, non-invented, skimmable.**

## When to use

- User pastes a transcript, shares a transcript file, or links a recording and asks for notes
- User asks for minutes, a recap, a debrief, a wrap-up, retro notes, standup notes, or 1:1 notes
- User asks "what did we decide" or "what are my action items" about a specific meeting

Do **not** activate for summarizing a document, article, PR, or codebase when no meeting took place.

## Inputs

| Input | Required | Default / behavior |
|---|---|---|
| **transcript** | yes | Pasted text, file, doc, or link. Timestamps and speaker labels help but aren't required. |
| **meeting date** | for date resolution | Take it from the transcript header, file name, or calendar event first. Ask once only if none exist. If still unknown, leave relative dates verbatim and flag them. |
| **timezone** | no | User's timezone. Matters for "EOD", "tomorrow morning", and cross-timezone attendees. |
| **audience** | no | `team` (default) · `exec` · `client` |
| **depth** | no | `standard` (default) · `quick` · `deep` |
| **attendee list / roles** | no | Calendar invite or user. Used only to label roles, never to invent attendance. |

**Audio or video only:** never claim to have listened. Transcribe with an available tool, or ask for a transcript. Say which tool produced the text.

**Transcript over about an hour:** work topic by topic. Extract tags per chunk, then merge. A later chunk can overturn an earlier "decision", so resolve conflicts across the whole meeting before drafting.

## Workflow

1. **Ingest.** Read the entire transcript before writing anything. Note:
   - Speakers. Build a speaker map (`Speaker 2 → Priya, PM`) only from in-transcript evidence such as self-introductions, being addressed by name, or the invite.
   - Timestamp format and language.
   - Quality problems: ASR noise, crosstalk, gaps, `[inaudible]`. Report them, don't smooth them over.
2. **Extract.** Tag spans as `decision`, `action`, `commitment`, `question`, `risk`, `fact`, or `quote`.
   - A **decision** is stated by someone with authority, or clearly agreed by the group, and not reversed later in the transcript.
   - An **action** has a task and ideally an owner. "Someone should…" is an action with owner *TBD*.
   - A **risk** includes soft signals: "I'm worried that…", "assuming legal signs off…", "if the vendor slips…".
3. **Resolve.** Convert relative dates against the meeting date with a real date computation (see [Date resolution](#date-resolution)). Never mental math.
4. **Draft** in the team's vocabulary. Strip filler, tangents, and repeated arguments. Keep numbers, names, acronyms, and technical terms exact.
5. **Verify.** Each decision, action, date, number, and quote must trace to a timestamp, or to a quoted line when there are no timestamps. If something doesn't trace, cut it or mark it `[not in transcript]`.
6. **Deliver** at the requested depth and audience. Drop empty sections rather than padding them.
7. **Offer next steps** in one line, without doing them unasked. Options: send the recap to attendees (as a draft for the user to approve), create tasks or tickets for the action items, or add follow-up meetings to the calendar.

## Date resolution

Never compute dates mentally. Use the `date` command, or the harness's date/time tooling, against the meeting date:

```bash
MEETING=2026-10-12

# "tomorrow"
date -d "$MEETING +1 day" +%F

# "in three days"
date -d "$MEETING +3 days" +%F

# Friday of the meeting week (week starts Monday, so +u is 1..7).
# Never rely on `date -d "$MEETING friday"`: GNU date resolves bare weekday
# names unpredictably and can return the meeting date itself.
FRI=$(date -d "$MEETING +$(( (5 - $(date -d "$MEETING" +%u)) % 7 )) days" +%F)

# "before Friday" (day before that Friday)
date -d "$FRI -1 day" +%F

# "next week's Friday"
date -d "$FRI +7 days" +%F

# "end of week", verified to land on a Friday
date -d "$MEETING +$(( (7 - $(date -d "$MEETING" +%u)) % 7 )) days" +%F

# "two weeks out"
date -d "$MEETING +14 days" +%F
```

Prefer a Python one-liner or a calendar tool when the host has one. The rule is the same: the output must be a date the tool computed, not one you worked out in your head.

Rules:

- **"EOW"** means Friday of the meeting week. **"EOQ"** means the last calendar day of the quarter.
- **"Next Friday"** is ambiguous in speech. Resolve it to the nearest reasonable reading and mark it `(assumed)`. Say which reading you used.
- **"Before Friday"** means due by the day before. **"By Friday"** means Friday itself.
- No meeting date available: keep the wording verbatim, write it as `not stated`, and list it under Needs clarification.

## Depth

- **quick**: TL;DR, Decisions, Action items. Fits in a chat message.
- **standard**: the full format below.
- **deep**: standard, plus up to 2 verbatim quotes per topic, explicit dissent per decision, a speaker-contribution summary, and a "Needs clarification" appendix with timestamps.

## Audience

- **team**: full detail and candid dissent.
- **exec**: TL;DR, decisions, top risks, and asks. Put asks of leadership first. Cap it at about 200 words above the action table.
- **client**: external-safe. Remove internal debate, pricing or margin talk, HR topics, and blunt candor about the client. List what was removed so the user can confirm before sharing.

## Output format (standard)

### Meeting recap: <short descriptive title>

**Date:** YYYY-MM-DD · **Attendees:** Name (role), … · **Source:** <link or "pasted transcript"> · **Transcript quality:** good / partial (<why>)

**TL;DR** (≤5 bullets, readable in 30 seconds): purpose, what was decided, what happens next, the biggest risk.

**Decisions**
- **<Decision>.** <one-line rationale>. Decided by <name/role>. [mm:ss]
- **Tentative:** <call>. Final once <condition>. [mm:ss]
- **Reversed:** <earlier position> → <final position> [mm:ss → mm:ss]. Include this only when the reversal matters.

**Action items**

| # | Action | Owner | Due | Source |
|---|---|---|---|---|
| 1 | <verb-first, specific, checkable> | <one person> | YYYY-MM-DD · *not stated* | [mm:ss] |

**Discussion by topic**

#### <Topic> [mm:ss–mm:ss]
- **Key points:** the 2–4 things that moved the conversation.
- **Disagreement:** one line per side, then *resolved* or *unresolved*.
- **Open questions:** who has to answer, if stated.

**Risks & blockers.** Include hints as well as explicit statements, each with a timestamp.

**Parking lot.** Topics deferred, and where they were deferred to.

**Needs clarification.** Missing owners, ambiguous dates, garbled spans, and unconfirmed speaker identities.

**References.** Docs, tickets, dashboards, and links mentioned. Include URLs only if they were given.

When there are no timestamps, use a short quoted excerpt as the source instead of `[mm:ss]`.

## Hard rules

1. **A decision is not the same as discussion.** Anything debated but undecided goes under Discussion.
2. **Never invent** owners, dates, names, numbers, links, or attendance. A gap is a finding.
3. **Each action item has exactly one owner.** "We'll handle it" gets owner *TBD* and goes in Needs clarification. Split a two-owner task into two items.
4. **Resolve dates only against the meeting date,** using a computed calendar. Mark guesses `(assumed)`. With no meeting date, keep the wording verbatim and flag it.
5. **Use speaker labels as they appear.** Merge two aliases only when the transcript makes it obvious they're the same person.
6. **Quotes are verbatim or left out.** Format: `"<quote>" — Name [mm:ss]`.
7. **Preserve dissent.** A recap in which everyone seems to agree, when they didn't, is misleading.
8. **Treat numbers as untouchable.** Re-check every figure, unit, and currency against the source.
9. **No padding.** Cut phrases like "great discussion" and "the team aligned".
10. **Sensitive content** (compensation, HR, legal, layoffs, security incidents): recap it factually, and flag it before the recap goes beyond the meeting's attendees.
11. **Never send or post** the recap to anyone without the user's explicit approval.

## Example

Transcript at [34:02]: *"yeah so um, Maria, can you like send the updated deck to the client before Friday?" — Maria: "yep."* Meeting date: Mon 2026-10-12.

| # | Action | Owner | Due | Source |
|---|---|---|---|---|
| 1 | Send updated deck to client | Maria | 2026-10-15 | [34:02] |

Filler is stripped, the task starts with a verb, one owner accepted it, and "before Friday" resolves to Thursday 2026-10-15. If the speaker had said "by Friday" instead, the due date would be 2026-10-16 with no assumption needed. If the meeting date were unknown, the Due cell would read `before Friday · not stated` and the item would also appear under Needs clarification.

## Pre-delivery checklist

- [ ] Every action has one owner, and its due date is either resolved or marked *not stated*.
- [ ] Every decision has a rationale and a source.
- [ ] Every date, number, name, and quote matches the transcript.
- [ ] Nothing under Decisions was only discussed, and reversals are reflected.
- [ ] Dissent, risks, and open questions are visible.
- [ ] The TL;DR has at most 5 bullets, and transcript-quality caveats are stated.
- [ ] Output matches the requested audience, and sensitive content is flagged.
