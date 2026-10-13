# meeting-recap

Turn a meeting transcript into a recap people can act on and trust.

The skill optimizes for three things: every claim traceable to a timestamp, nothing invented, nothing important buried. Decisions, single-owner action items with resolved dates, discussion by topic, risks, and open questions — each one sourced, each one dated by a real calendar computation rather than mental math.

**When to use:** user pastes a transcript, shares a transcript file, or links a recording and asks for notes. Also on "meeting notes", "minutes", "debrief", "wrap-up", "retro notes", "standup notes", "1:1 notes", or "what did we decide".

**Do not use for:** summarizing a document, article, PR, or codebase when no meeting happened.

```bash
npx skills add drmaas/utility-skills --skill meeting-recap
```

**Needs:** nothing special. Dates get resolved with the `date` command or the host's calendar tooling. For audio or video input, a transcription tool helps — the skill never claims to have listened to a recording.

## Depth

| Depth | Contents |
| --- | --- |
| `quick` | TL;DR, decisions, action items. Fits in one chat message |
| `standard` | Full format, the default |
| `deep` | Standard plus verbatim quotes, explicit dissent per decision, speaker-contribution summary, and a clarification appendix |

## Audience

| Audience | Focus |
| --- | --- |
| `team` | Full detail and candid dissent (default) |
| `exec` | TL;DR, decisions, top risks, asks. About 200 words above the action table |
| `client` | External-safe. Internal debate, pricing, HR, and blunt candor removed, with a list of what was removed |

## What it refuses to do

- Invent owners, dates, names, numbers, links, or attendance
- Call a debate a decision
- Round an unowned task into an owned one
- Attribute a quote the transcript doesn't contain
- Send or post the recap anywhere without explicit approval

Details, output format, and the pre-delivery checklist: [`SKILL.md`](SKILL.md).
